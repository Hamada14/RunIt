$("form.lambda-create-form").submit(function(e) {
  e.preventDefault();
  $.post('/lambdas', {
      lambdaName: $("#lambdaNameInput").val(),
      lambdaCode: $("#lambdaCodeInput").val()
    },
    function(data, status) {
      result = JSON.parse(data);
      if (result['success']) {
        time_str = formatDate(new Date());
        addRowForInput($("#lambdaNameInput").val(), time_str);
        clearForm();
      } else {
        alert("Please don't mess with us.");
      }
    });
});

function addRowForInput(name, time) {
  var row = $('<tr>');
  row.append($('<td>').html(name));
  row.append($('<td>').html('N/A'));
  row.append($('<td>').html(time));
  row.append($('<td>').html(''));
  $('#lambda-table').append(row);
};

function formatDate(date) {
  var day = correctLength(date.getDate());
  var monthIndex = correctLength(date.getMonth() + 1);
  var year = date.getFullYear();
  return year + '-' + monthIndex + '-' + day;
};

function correctLength(data) {
  if (data.length == 1)
    return '0' + data;
  return data;
};

function clearForm() {
  $("#lambdaNameInput").val('');
  $("#lambdaCodeInput").val('');
};
