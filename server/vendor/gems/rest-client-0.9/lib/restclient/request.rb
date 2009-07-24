module RestClient
	# This class is used internally by RestClient to send the request, but you can also
	# access it internally if you'd like to use a method not directly supported by the
	# main API.  For example:
	#
	#   RestClient::Request.execute(:method => :head, :url => 'http://example.com')
   #
	class Request
		attr_reader :method, :url, :payload, :headers, :user, :password, :timeout

		def self.execute(args)
			new(args).execute
		end

		def initialize(args)
			@method = args[:method] or raise ArgumentError, "must pass :method"
			@url = args[:url] or raise ArgumentError, "must pass :url"
			@headers = args[:headers] || {}
			@payload = process_payload(args[:payload])
			@user = args[:user]
			@password = args[:password]
			@timeout = args[:timeout]
		end

		def execute
			execute_inner
		rescue Redirect => e
			@url = e.url
			execute
		end

		def execute_inner
			uri = parse_url_with_auth(url)
			transmit uri, net_http_request_class(method).new(uri.request_uri, make_headers(headers)), payload
		end

		def make_headers(user_headers)
			default_headers.merge(user_headers).inject({}) do |final, (key, value)|
				final[key.to_s.gsub(/_/, '-').capitalize] = value.to_s
				final
			end
		end

		def net_http_class
			if RestClient.proxy
				proxy_uri = URI.parse(RestClient.proxy)
				Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password)
			else
				Net::HTTP
			end
		end

		def net_http_request_class(method)
			Net::HTTP.const_get(method.to_s.capitalize)
		end

		def parse_url(url)
			url = "http://#{url}" unless url.match(/^http/)
			URI.parse(url)
		end

		def parse_url_with_auth(url)
			uri = parse_url(url)
			@user = uri.user if uri.user
			@password = uri.password if uri.password
			uri
		end

		def process_payload(p=nil, parent_key=nil)
			unless p.is_a?(Hash)
				p
			else
				@headers[:content_type] ||= 'application/x-www-form-urlencoded'
				p.keys.map do |k|
					key = parent_key ? "#{parent_key}[#{k}]" : k
					if p[k].is_a? Hash
						process_payload(p[k], key)
					else
						value = URI.escape(p[k].to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
						"#{key}=#{value}"
					end
				end.join("&")
			end
		end

		def transmit(uri, req, payload)
			setup_credentials(req)

			net = net_http_class.new(uri.host, uri.port)
			net.use_ssl = uri.is_a?(URI::HTTPS)
			net.verify_mode = OpenSSL::SSL::VERIFY_NONE

			display_log request_log

			net.start do |http|
				http.read_timeout = @timeout if @timeout
				res = http.request(req, payload)
				display_log response_log(res)
				string = process_result(res)
				if string
					Response.new(string, res)
				else
					nil
				end
			end
		rescue EOFError
			raise RestClient::ServerBrokeConnection
		rescue Timeout::Error
			raise RestClient::RequestTimeout
		end

		def setup_credentials(req)
			req.basic_auth(user, password) if user
		end

		def process_result(res)
			if %w(200 201 202).include? res.code
				decode res['content-encoding'], res.body
			elsif %w(301 302 303).include? res.code
				url = res.header['Location']

				if url !~ /^http/
					uri = URI.parse(@url)
					uri.path = "/#{url}".squeeze('/')
					url = uri.to_s
				end

				raise Redirect, url
			elsif res.code == "304"
				raise NotModified
			elsif res.code == "401"
				raise Unauthorized, res
			elsif res.code == "404"
				raise ResourceNotFound, res
			else
				raise RequestFailed, res
			end
		end

		def decode(content_encoding, body)
			if content_encoding == 'gzip'
				Zlib::GzipReader.new(StringIO.new(body)).read
			elsif content_encoding == 'deflate'
				Zlib::Inflate.new.inflate(body)
			else
				body
			end
		end

		def request_log
			out = []
			out << "RestClient.#{method} #{url.inspect}"
			out << (payload.size > 100 ? "(#{payload.size} byte payload)".inspect : payload.inspect) if payload
			out << headers.inspect.gsub(/^\{/, '').gsub(/\}$/, '') unless headers.empty?
			out.join(', ')
		end

		def response_log(res)
			"# => #{res.code} #{res.class.to_s.gsub(/^Net::HTTP/, '')} | #{(res['Content-type'] || '').gsub(/;.*$/, '')} #{(res.body) ? res.body.size : nil} bytes"
		end

		def display_log(msg)
			return unless log_to = RestClient.log

			if log_to == 'stdout'
				STDOUT.puts msg
			elsif log_to == 'stderr'
				STDERR.puts msg
			else
				File.open(log_to, 'a') { |f| f.puts msg }
			end
		end

		def default_headers
			{ :accept => 'application/xml', :accept_encoding => 'gzip, deflate' }
		end
	end
end
