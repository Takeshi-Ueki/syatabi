
$('select').change(function() {

  let changeValueArray = [];

  $('select').each(function() {
    let value = $(this).val().split('-')[1]
    if (value !== undefined) {
      changeValueArray.push(value);
    }
  });

  // ref: https://qiita.com/diescake/items/70d9b0cbd4e3d5cc6fce#foreach--filter
  // ref: https://www.nxworld.net/js-array-filter-snippets.html
  let duplicateValues = changeValueArray.filter((value, index, array) =>
    array.indexOf(value) === index && array.lastIndexOf(value) !== index
  );

  if (duplicateValues.length > 0) {
    alert('順位が重複しています。\n1位~3位は1投稿ずつ選択してください。');
    $('input').prop('disabled', true);
  } else {
    $('input').prop('disabled', false);
  }
});