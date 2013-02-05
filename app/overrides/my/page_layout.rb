Deface::Override.new :virtual_path => 'my/page_layout',
    :name => 'cancel-button',
    :insert_after => 'code:contains(":button_back")',
    :text => [
        "<%= form_tag({:action => 'default_layout'}, :id => 'default-layout-form') do %>",
        "<%= link_to l(:button_default_layout), '#', :onclick => '$(\"#default-layout-form\").submit()', :class => 'icon icon-reload' %>",
        "<% end %>"
    ].join
