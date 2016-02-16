/*jshint esversion:6*/

import $ from 'jquery';

class ShareImageResponseModal {
  constructor() {
    this.$modal = $('.js-share-image-response-modal');
  }

  dismissed(eventHandler) {
    const $dismissButton = this.$modal.find('.js-dismiss-message');

    $dismissButton.on('click', eventHandler);
  }

  show() {
    this.$modal.modal({
      backdrop: 'static'
    });
  }

  replaceMessageText(title, body) {
    const $label = this.$modal.find('.js-modal-title');
    const $messageBody = this.$modal.find('.js-modal-body');

    $label.text(title);
    $messageBody.children().remove();
    $messageBody.prepend(body);
  }
}

export default ShareImageResponseModal;
