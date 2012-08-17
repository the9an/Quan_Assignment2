package Forum::Controller::Root;
use Moose;
use namespace::autoclean;
use DateTime;
use DateTime::Duration;
use Digest::SHA1;
use 5.010;
use utf8;

use warnings;
use strict;


BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

Forum::Controller::Root - Root Controller for Forum

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    #$c->response->body( $c->welcome_message );
    #Get topics forum database
    my $topics_rs = $c->model('ForumDB::Topic')->search(undef);
    @{$c->stash->{'topics'}} = $topics_rs->all();
    $c->stash->{'fr_mode'} = 'topics';
    $c->stash->{template};
    
}

sub base : Chained('/'): PathPart(''): CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash(users_rs => $c->model('ForumDB::User'));
}

sub login :Local :Args(0) {
    my ( $self, $c ) = @_;
    if ( exists($c->req->params->{'user_name'}) ) {
        if ($c->authenticate( {
            user_name => $c->req->params->{'user_name'},
            password => $c->req->params->{'password'},
            status => ['active', 'trial']
            }) )
        {
            ## user is signed in
            #Admin
            if ($c->check_user_roles( qw/ admin /)){
                $c->res->redirect($c->uri_for($c->controller('admin')->action_for('admin')));
            }
            else {
                $c->res->redirect($c->uri_for($c->controller()->action_for('')));
            }
            $c->detach();
        }
        else {
            $c->stash->{'message'} = "Invalid login.";
            $c->log->debug("Sai password roi nhe".$c->req->params->{'password'});
            $c->res->redirect($c->uri_for($c->controller()->action_for('')));
        }
    }
}

sub logout :Local :Args(0) {
    my ( $self, $c ) = @_;
    #$c->stash->{'template'} = 'people/logout.tt';
    $c->res->redirect($c->uri_for($c->controller()->action_for('')));
    $c->logout();
    $c->stash->{'message'} = "You have been logged out.";
}


sub register : Chained('base'): PathPart('register'): Args(0) {
    my ($self, $c) = @_;
    if(lc $c->req->method eq 'post') {
        my $params = $c->req->params;
        ## Retrieve the users_rs stashed by the base action:
        my $users_rs = $c->stash->{users_rs};
        if (!$params->{user_name} || !$params->{user_email} || !$params->{password}){
            $c->stash( errors => { user_regist => 'Please enter user name, email, password!' }, err => $@ );
            return;
        }
        #Is user name exists?
        if ($c->model ( "ForumDB::User" )->find({user_name => $params->{user_name}})){
            $c->stash( errors => { user_name => 'exists' }, err => $@ );
            return;
        }
        ## Create the user:
        #encrypt password sha1
        my $sha1_enc = Digest::SHA1->new;
        $sha1_enc->add($params->{password});
        ## VALIDATE THE EMAIL
        if ($params->{user_email} =~ /[\w\-]+\@[\w\-]+\.[\w\-]+/)
        {
            #Email address is valid
            # insert to database
            my $today = DateTime->now();
	        my $newuser = eval { $users_rs->create({
		        user_name => $params->{user_name},
		        user_email => $params->{user_email}, 
                password => $sha1_enc->hexdigest, 
                created_date => $today,     
	        }) 
	    };
            userRole ($c, $newuser->user_id);
            return $c->res->redirect($c->uri_for($c->controller()->action_for('')));
        }
        else {
            $c->stash( errors => { user_email => 'invalid' }, err => $@ );
            $c->log->debug("Email sai roi nheeeeeeeeeeeeeee ");
        }
    }
}

sub userRole
{
    my($c, $usr_id) = @_;
    $c->log->debug("ID nguoi dung la: ".$usr_id);
    #conect to database via model
    my $rs = $c->model('ForumDB::RoleUser');
    my $newuser_role = eval { $rs->create({
    	role_id => '3', #default new user is 'register'
	user_id => $usr_id, 
    })
    }; 
}



=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

CentOS

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
