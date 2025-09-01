{{ partial('layout_partials/base_form', ['fields': form, 'id': 'settings']) }}

<script>
$(function() {
    mapDataToFormUI({'settings': '/api/scrutiny/settings/get'});
})();
</script>
