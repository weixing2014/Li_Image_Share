/*jshint esversion:6*/

import $ from 'jquery';

class ShareImageProgressBar {
  constructor() {
    this.$modal = $('.js-share-image-progress-bar');
  }

  show() {
    this.$modal.modal({
      keyboard: false,
      backdrop: 'static'
    });
  }

  hide() {
    this.$modal.modal('toggle');
  }
}

export default ShareImageProgressBar;
