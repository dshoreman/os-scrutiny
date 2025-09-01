<script>
function setval(opt, val) {
    document.getElementById(`scrutiny.settings.${opt}`).innerHTML = val;
};

(() => {
    const form = mapDataToFormUI({'settings': '/api/scrutiny/settings/get'}),
    installBtnData = 'data-endpoint="/api/scrutiny/service/download" data-label="Install"',
    installBtn = `<button id="install" class="btn btn-xs btn-primary" ${installBtnData}></button>`;

    form.done((data) => {
        setval('SmartVersion', '{{ versions.smartctl }}');
        if ('{{ versions.scrutiny }}' != 'not detected') {
            setval('CollectorVersion', '{{ versions.scrutiny }}');
        } else {
            setval('CollectorVersion', installBtn);

            $('#install').SimpleActionButton({
                onAction: (data) => {
                    let val = data['message'];

                    if ('version' in data && data['success']) {
                        $('#response').html(`<code class="text-info">${data['message'].replaceAll('\n', '<br>')}</code>`);
                        val = data['version'];
                    } else {
                        $('#response').removeClass('alert-info').addClass('alert-danger').text('Install failed.');
                    }

                    setval('CollectorVersion', val.replaceAll('\n', '<br>'));
                    $('#response').fadeIn();
                }
            });
        }
    });
})();
</script>

<div class="alert alert-info" role="alert" style="display: none;" id="response"></div>

<div class="content-box">
    {{ partial('layout_partials/base_form', ['fields': form, 'id': 'settings']) }}
</div>
