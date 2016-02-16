/*jshint esversion:6*/

import $ from 'jquery';
import ShareImageProgressBar from './share_image_progress_bar';
import ShareImageResponseModal from './share_image_response_modal';

const succeedMessage = `<p>Your image has been successfully shared!</p>`;
const errorMessage = `<p>Sorry, your image is failed to share</p>`;

class ShareImageModal  {
  constructor() {
    this.$modal = $('.js-share-image-modal');
    this.$progressBar = new ShareImageProgressBar();
    this.$responseMessage = new ShareImageResponseModal();
  }

  addShareEvents() {
    const $form = this.$modal.find('.js-share-image-form');
    const $imageId = this.$modal.find('.js-image-id');
    const $imagePreview = this.$modal.find('.js-share-image-preview');
    const $imageRecipient = this.$modal.find('.js-image-recipient');
    const $emailSubject = this.$modal.find('.js-email-subject');
    const $sendButton = this.$modal.find('.js-send-image');
    const $shareButton = $('.js-share-image');

    $shareButton.on('click', (event)=> {
      let button = $(event.target);
      let imageUrl = button.data('image-url');
      let imageId = button.data('image-id');

      $imagePreview.attr('src', imageUrl);
      $imageId.val(imageId);
      $imageRecipient.val('');
      $imageRecipient.focus();
      $emailSubject.val('');
    });

    this.$modal.on('shown.bs.modal', ()=> {
      $imageRecipient.focus();

      while($('.modal-backdrop').length > 1) {
        $('.modal-backdrop:last').remove();
      }
    });

    $sendButton.on('click', ()=> {
      let imageId = $imageId.val();
      let recipient = $imageRecipient.val();
      let subject = $emailSubject.val();
      let path = $form.attr('action');

      this.$modal.modal('hide');
      this.$progressBar.show();

      let shareImageReq = $.post(path, { id: imageId,
                                         recipient: recipient,
                                         subject: subject })
            .done(()=> {
              this.responded('Sharing succeeded', succeedMessage, ()=> {});
            })
            .fail(()=> {
              this.responded('Sharing failed', errorMessage, ()=> { this.$modal.modal('show'); });
            })
            .always(()=> {
              this.$progressBar.hide();
            });
    });
  }

  responded(messageTitle, messageBody, eventHandler) {
    this.$responseMessage.dismissed(eventHandler);

    this.$responseMessage.replaceMessageText(messageTitle, messageBody);
    this.$responseMessage.show();
  }
}

export default ShareImageModal;
