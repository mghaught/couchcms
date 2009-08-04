// http://wiki.apache.org/couchdb/View_Snippets

// *GET
//  key=keyvalue
//  startkey=keyvalue
//  startkey_docid=docid
//  endkey=keyvalue
//  endkey_docid=docid
//  limit=max rows to return 
//  stale=ok
//  descending=true
//  skip=number of rows to skip
//  group=true Version 0.8.0 and forward
//  group_level=int
//  reduce=false Trunk only (0.9)
//  include_docs=true Trunk only (0.9)
// *POST
//  {"keys": ["key1", "key2", ...]} Trunk only (0.9)

// http://localhost:5984/server_development/_design/Content/_view/languages?include_docs=true
// http://localhost:5984/server_development/_design/Content/_view/languages?key="en"
// http://localhost:5984/server_development/_design/Content/_view/languages?key="fr"
// http://localhost:5984/contents/_view/languages
"languages": {
    "map": "function(doc) { if(doc['couchrest-type'] == 'Content') { for(var i in doc.data) { emit(i, doc.data[i]); }}}"
}

view_by :language,
  :map =>
    "function(doc) {
      if (doc['couchrest-type'] == 'Content' && doc['data']) {
        for(var i in doc.data) { 
          emit(i, doc.data[i]); 
        }
      }
    }",
  :reduce =>
    "function(keys, values, rereduce) {
      return sum(values);
    }"

// Basic Views
{
   "by_created_at": {
       "map": "function(doc) {\n  
         if ((doc['couchrest-type'] == 'Content') && doc['created_at']) {\n    
           emit(doc['created_at'], null);\n  
          }\n
        }\n"
   },
   "by_name": {
       "map": "function(doc) {\n  
         if ((doc['couchrest-type'] == 'Content') && doc['name']) {\n    
           emit(doc['name'], null);\n  
          }\n}\n"
   },
   "all": {
       "reduce": "function(keys, values) {\n                  
         return sum(values);\n                
        }",
       "map": "function(doc) {\n                  
         if (doc['couchrest-type'] == 'Content') {\n                    
           emit(null,1);\n                  
          }\n                
        }"
   }
}


// Word Count
{
   "words": {
       "map": "function(doc){\n    
         var words = doc.text.split(/\\W/);\n    
         words.forEach(function(word){\n      
           if (word.length > 0) emit([word,doc.title],1);\n    
         });\n  
        }",
       "reduce": "function(key,combine){\n    
         return sum(combine);\n  
        }"
   }
}

// view_by :tags,

{
  "tags": {
    "map": "function(doc) {
        if (doc.type == 'Passage' && doc.tags) {
          doc.tags.forEach(function(tag){
            emit(tag, 1);
          });
        }
      }",
    "reduce": "function(keys, values, rereduce) {
        return sum(values);
      }"

  }
}
  
{
  "tags": {
    "map": "function(doc) { 
      if(doc.type == 'article') { 
        for(var i in doc.tags) { 
          emit(doc.tags[i], 1); 
        }
      }
    }",
    "reduce": "function(tag, counts) { 
      var sum = 0; 
      for(var i = 0; i < counts.length; i++) { 
        sum += counts[i]; 
      }; 
      return sum; 
    }"
  }
  // other views omitted for brevity
}


// GET http://localhost:5984/blog/_view/articles/tags?group=true&group_level=1
 
{"rows":[
  {"key":"awesome","value":1},
  {"key":"agile","value":2},
  {"key":"ajax","value":2},
  {"key":"apache","value":2},
  {"key":"api","value":1},
  {"key":"caching","value":1},
  {"key":"coding","value":7},
  {"key":"conference","value":1},
  // and so on ...
]}




