/*jshint esversion:6*/

import ShareImageModal from './share_image_modal';

const shareImageModal = new ShareImageModal('.js-share-image-modal', '.js-share-image-success-modal');
shareImageModal.addShareEvents();
