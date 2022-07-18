$('select').change(function() {
  let changedValue = $(this).val().split('-')[1];
  let changedValueId = $(this).attr('id');
  $('select').each(function() {
    if ($(this).val()) {
      if ($(this).attr('id') == changedValueId){
        return;
      }
      else if ($(this).val().split('-')[1] == changedValue){
        alert('順位が重複しています。\n1位~3位は1投稿ずつ選択してください。');
        $('input').prop('disabled', true);
        return false;
      }
      else {
        $('input').prop('disabled', false);
      }
    }
  })
});