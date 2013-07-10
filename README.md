# Redmine My Page Queries

Adds custom queries onto My Page screen.
Also plugin adds "restore default" button on my page personalization.

## Installing a plugin

1. Copy plugin directory into #{RAILS_ROOT}/plugins.
If you are downloading the plugin directly from GitHub,
you can do so by changing into your plugin directory and issuing a command like

        git clone git://github.com/Undev/redmine_my_page_queries.git

2. Restart Redmine

## Upgrading from old versions (prior to 2.0.0)

For saving user settings of custom queries on the my_page you can run this task:

        rake my_page_queries:upgrade RAILS_ENV=production

## Compatibility

This version supports only redmine 2.x. See [redmine-1.x](https://github.com/Undev/redmine_my_page_queries/tree/feature/1.4-compatibility) branch for Redmine 1.x.
