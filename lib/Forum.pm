package Forum;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;



# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
    Authentication
    Authorization::Roles
    Authorization::ACL
    Session
    Session::State::Cookie
    Session::Store::FastMmap
    Unicode
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in forum.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'Forum',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
    #config authentication
    #'View::View' => {
        #INCLUDE_PATH => [
            #__PACKAGE__->path_to('root', ''),
            #__PACKAGE__->path_to('root', 'src'),
            #__PACKAGE__->path_to('root', 'lib')
        #],
        #TEMPLATE_EXTENSION => '.tt',
        #CATALYST_VAR => 'c',
        #TIMER => 0,
        #WRAPPER => 'site/wrapper'
    #},
    'Plugin::Authentication' => {
        default => {
            credential => {
                class => 'Password',
                #password_type => 'crypted',
                password_field => 'password',
                password_type => 'hashed',
                password_hash_type => 'SHA-1'
            },
            store => {
                class => 'DBIx::Class',
                user_model => 'ForumDB::User',
                role_relation => 'roles',
                role_field => 'role_name',
                use_userdata_from_session => '1'
            }
        }
    },
    
    upload_abs => __PACKAGE__->path_to('root', 'upload'),
    upload_dir => '/upload'
);


# Start the application
__PACKAGE__->setup();

__PACKAGE__->deny_access_unless('/admin', [qw/admin/]);

=head1 NAME

Forum - Catalyst based application

=head1 SYNOPSIS

    script/forum_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Forum::Controller::Root>, L<Catalyst>

=head1 AUTHOR

CentOS

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
