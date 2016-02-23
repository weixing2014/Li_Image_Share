/*jshint esversion:6*/

import $ from 'jquery';

const UNPROCESSABLE_ENTITY = 422;
const NOT_FOUND = 404;

class ShareImageModal  {

  constructor({shareModalSelector, successModalSelector}) {
    this.$modal = $(shareModalSelector);
    this.$successModal = $(successModalSelector);
  }

  resetToBlankForm() {
    this.$modal.find('input:not([type=submit])').val('');
    this.$modal.find('.js-error-message').remove();
  }

  rerenderFormWithErrors(responseJSON) {
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
  }

  handleSharingSuccess() {
    this.$modal.modal('hide');
    this.$successModal.modal('show');
  }

  handleSharingFailure({ status, responseJSON }) {
    if (status == UNPROCESSABLE_ENTITY) {
      this.rerenderFormWithErrors(responseJSON);
    } else if (status == NOT_FOUND) {
      this.$modal.modal('hide');
      alert('Sorry, the image has been deleted so that it cannot be shared');
    } else {
      alert('Sorry, something went wrong.');
    }
  }

  addShareEvents() {
    this.$modal.on('show.bs.modal', (event) => {
      const $shareImageTrigger = $(event.relatedTarget);
      const imageUrl = $shareImageTrigger.data('image-url');
      const imageId = $shareImageTrigger.data('image-id');

      this.setImageInfo(imageUrl, imageId);
      this.setFormAction(imageId);
    });

    this.$modal.on('shown.bs.modal', () => {
      this.$modal.find('.js-email-recipient').focus();
    });

    this.$modal.on('hidden.bs.modal', this.resetToBlankForm.bind(this));

    this.$modal.on('ajax:success', this.handleSharingSuccess.bind(this));

    this.$modal.on('ajax:error', (event, xhr) => {
      this.handleSharingFailure(xhr);
    });
  }
}

export default ShareImageModal;
