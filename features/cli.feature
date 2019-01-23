Feature: `wp cli` tasks

  Scenario: Ability to detect a WP-CLI registered command
    Given a WP installation

    # Allow for composer/ca-bundle using `openssl_x509_parse()` which throws PHP warnings on old versions of PHP.
    When I try `wp package install wp-cli/scaffold-package-command`
    And I run `wp cli has-command scaffold package`
    Then the return code should be 0

    # Allow for composer/ca-bundle using `openssl_x509_parse()` which throws PHP warnings on old versions of PHP.
    When I try `wp package uninstall wp-cli/scaffold-package-command`
    And I try `wp cli has-command scaffold package`
    Then the return code should be 1

  Scenario: Ability to detect a command which is registered by plugin
    Given a WP installation
    And a wp-content/mu-plugins/test-cli.php file:
      """
      <?php
      // Plugin Name: Test CLI Help

      class TestCommand {
      }

      WP_CLI::add_command( 'test-command', 'TestCommand' );
      """

    When I run `wp cli has-command test-command`
    Then the return code should be 0

  Scenario: Dump the list of global parameters with values
    Given a WP installation

    When I run `wp cli param-dump --with-values | grep -o '"current":' | uniq -c | tr -d ' '`
    Then STDOUT should be:
      """
      17"current":
      """
    And STDERR should be empty
    And the return code should be 0

  Scenario: Ability to detect a global configuration does exists or not
    Given a WP installation
    And a custom-cmd.php file:
      """
      <?php
      class Custom_Command extends WP_CLI_Command {

          /**
           * @when after_wp_load
           */
          public function __invoke() {
              if ( WP_CLI::has_config( 'dummy' ) ) {
                  WP_CLI::log( 'Configuration `dummy` does exists.' );
              } else {
                  WP_CLI::log( 'Configuration `dummy` does not exists.' );
              }
          }

      }
      WP_CLI::add_command( 'custom-command', 'Custom_Command' );
      """

    When I run `wp --require=custom-cmd.php custom-command --dummy=example.com`
    Then STDOUT should be:
      """
      Configuration `dummy` does exists.
      """

    When I run `wp --require=custom-cmd.php custom-command`
    Then STDOUT should be:
      """
      Configuration `dummy` does not exists.
      """
