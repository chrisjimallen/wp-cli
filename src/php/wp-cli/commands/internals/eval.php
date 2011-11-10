<?php

// Add the command to the wp-cli
WP_CLI::addCommand('eval', 'EvalCommand');

/**
 * Implement eval command
 *
 * @package wp-cli
 * @subpackage commands/internals
 */
class EvalCommand extends WP_CLI_Command {

	/**
	 * Overwrite the constructor to have a command without sub-commands.
     *
     * @param array $args
	 * @param array $assoc_args
	 */
	public function __construct( $args, $assoc_args ) {
		if ( empty( $args ) ) {
			WP_CLI::line( "usage: wp eval <php-code>" );
			exit;
		}

		$name = $args[0];
		eval( $args[0] );
	}

	/**
	 * Help function for this command
	 */
	public static function help() {
		WP_CLI::line( <<<EOB
example: wp eval 'echo WP_CONTENT_DIR;'
example: wp eval 'require some-file.php;'

Executes arbitrary PHP code after bootstrapping WordPress.
EOB
		);
	}
}
