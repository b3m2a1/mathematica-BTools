jQuery(document).ready(function() {
	jQuery('.ce-notebook-expression').addClass('ce-white ce-colorTipContainer').append('<span class="ce-colorTip" style="margin-left: -60px;"><span class="ce-content">Copy input</span><span class="ce-pointyTipShadow"></span><span class="ce-pointyTip"></span></span>');

	jQuery('.ce-colorTipContainer').hover(
		function() {
			jQuery(this).find('.ce-colorTip').show();
	},
		function() {
			jQuery(this).find('.ce-colorTip').hide().find('.ce-content').text('Copy input');
	});

	jQuery('.ce-colorTipContainer').click(function() {
		jQuery(this).find('.ce-colorTip .ce-content').text('Copied!');
		jQuery(this).find('textarea').css('display', 'block').select();
		document.execCommand('copy');
		jQuery(this).find('textarea').css('display', 'none');
	});
});
