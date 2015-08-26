$(function() {
  var tooltippable = $('[data-toggle="tooltip"]');

  if (tooltippable.length > 0) {
    return tooltippable.tooltip();
  }
});
