<script>
    {literal}
    (function(contact_id,data){
        cj(function($){
            if ($(".crm-contact_type_label").length == 0) {
                CRM.alert("Someone has changed the summary layout, relationships can't be displayed properly");
                return;
            }

            $(".crm-summary-demographic-block").append('<div class="crm-summary-relationships-block"><div class="crm-clear crm-inline-block-content" title="{/literal}{ts}Relationships{/ts}{literal}"></div></div>');

            $.each(data.values, function(key) {
                var is_active = true;
                if (data.values[key].end_date) {
                    var endDate = new Date(data.values[key].end_date);
                    var today = new Date();
                    if (endDate <= today) {
                        is_active = false;
                    }
                }
                if (is_active) {
                    var url = CRM.url('civicrm/contact/view', {'cid': data.values[key].cid, 'reset': '1'});
                    var relationship = '<div class="crm-summary-row relationship-' + data.values[key].id + '">';
                    relationship = relationship + '<div class="crm-label">' + data.values[key].relation + '</div>';
                    relationship = relationship + '<div class="crm-content"><a href="' + url + '">' + data.values[key].display_name + '</a></div>';
                    relationship = relationship + '</div>';

                    $(".crm-summary-relationships-block .crm-inline-block-content").append(relationship);
                }
            });
        });
    }{/literal}
    ({$contactId}, {crmAPI entity='Relationship' action='get' sequential=1 contact_id=$contactId is_active=1}));
</script>