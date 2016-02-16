/*jshint esversion:6*/

import $ from 'jquery';

class ShareImageProgressBar {
  constructor() {
    this.$modal = $('#shareImageProgressBar');
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
