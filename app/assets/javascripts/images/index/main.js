/*jshint esversion:6*/

import ShareImageModal from './share_image_modal';

const shareImageModal = new ShareImageModal({
  shareModalSelector: '.js-share-image-modal',
  successModalSelector: '.js-share-image-success-modal'
});

shareImageModal.addShareEvents();
