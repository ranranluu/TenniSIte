document.addEventListener('turbolinks:load',function(){
$('.search__form__input').on('keyup', function(e){
      Rails.fire($(".search__form")[0], "submit");
  });
});
