/*jshint esversion:6*/

import $ from 'jquery';

class ShareImageResponseMessage {
  constructor() {
    this.$modal = $('#shareImageResponseMessage');
  }

  dismissed(eventHandler) {
    const $dismissButton = this.$modal.find('#js-dismiss-message');

    $dismissButton.on('click', eventHandler);
  }

  show() {
    this.$modal.modal({
      backdrop: 'static'
    });
  }

  replaceMessageText(title, body) {
    const $label = this.$modal.find('#shareImageResponseMessageLabel');
    const $messageBody = this.$modal.find('.modal-body');

    $label.text(title);
    $messageBody.children().remove();
    $messageBody.prepend(body);
  }
}

export default ShareImageResponseMessage;
