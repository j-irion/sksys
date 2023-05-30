
document.getElementById("apiToken").addEventListener("input", function(e) {
  let api = e.target.value;
  document.getElementById("apiOutput").innerHTML = api;
  
});
