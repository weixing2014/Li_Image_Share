/*jshint esversion:6*/

import $ from 'jquery';

const UNPROCESSABLE_ENTITY = 422;
const NOT_FOUND = 404;

class ShareImageModal  {

  constructor() {
    this.$modal = $('.js-share-image-modal');
    this.$successMessage = $('.js-share-image-success-message');
    this.$blankModalHtml = $('.js-share-image-modal').html();
  }

  resetToBlankForm() {
    this.$modal.html(this.$blankModalHtml);
  }

  setErrorMsgForm(responseJSON) {
    this.$modal.find('form').replaceWith(responseJSON.form_html);
  }

  setFormAction(imageId) {
    const $form = this.$modal.find('.js-share-image-form');
    const formAction = $form.data('url-template').replace('ID_PLACEHOLDER', imageId);
    $form.attr('action', formAction);
  }

  setImageInfo(imageUrl, imageId) {
    const $imagePreview = this.$modal.find('.js-share-image-preview');
    $imagePreview.attr('src', imageUrl);

    this.setFormAction(imageId);
  }

  handleSharingSuccess() {
    this.$modal.modal('hide');
    this.$successMessage.modal('show');
  }

  handleSharingFailure({ status, responseJSON }) {
    if (status == UNPROCESSABLE_ENTITY) {
      this.setErrorMsgForm(responseJSON);
    } else if (status == NOT_FOUND) {
      this.$modal.modal('hide');
      alert('Sorry, the image has been deleted so that it cannot be shared');
    } else {
      alert('Sorry, something went wrong.');
    }
  }

  addShareEvents() {
    this.$modal.on('show.bs.modal', (event)=> {
      let button = $(event.relatedTarget);
      let imageUrl = button.data('image-url');
      let imageId = button.data('image-id');

      this.setImageInfo(imageUrl, imageId);
    });

    this.$modal.on('shown.bs.modal', ()=> {
      const $emailRecipient = this.$modal.find('.js-email-recipient');
      $emailRecipient.focus();
    });

    this.$modal.on('hidden.bs.modal', ()=> {
      this.resetToBlankForm();
    });

    this.$modal.on('ajax:success', this.handleSharingSuccess.bind(this));

    this.$modal.on('ajax:error', (event, xhr)=> {
      this.handleSharingFailure(xhr);
    });
  }
}

export default ShareImageModal;
