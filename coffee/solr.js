
// Use `var solr = require('solr-client')` in your code
var solr = require('solr-client');

var client = solr.createClient("memorial05.cloudapp.net", 8983);


// Lucene query
var query2 = client.createQuery()
                                //.matchFilter("id", "EUR")
.q({manu: '*'})
                                   .start(19)
                                   .rows(1);
client.search(query2,function(err,obj){
   if(err){
        console.log(err);
   }else{
        console.log(JSON.stringify(obj.response));
   }
});
