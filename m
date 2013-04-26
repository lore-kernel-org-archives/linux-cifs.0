From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: multiuser kerberised cifs via autofs needs root ticket cache
Date: Fri, 26 Apr 2013 10:14:10 -0400
Message-ID: <20130426101410.1754c9ab@tlielax.poochiereds.net>
References: <51723F74.3010807@steve-ss.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51723F74.3010807-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 20 Apr 2013 09:10:44 +0200
steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:

> Hi
> one of my automount files is:
> * -fstype=cifs,sec=krb5,multiuser ://doloresdc/users/&
> 
> It works fine but only if the krb5cc_0 cache is available under /tmp. 
> When a user logs in, he gets his own cache. With multiuser, why isn't 
> that good enough to be able to mount his share?
> 

Because you haven't specified the cruid= that should be used to mount
the share and act as the root credentials for the mount.

I don't think you really want "multiuser" in the above situation. It
sounds like you're trying to set up each autofs-mounted cifs filesystem
for a single user.

In that case, you probably want to do something like:

    * -fstype=cifs,sec=krb5,uid=&,gid=&,cruid=& ://doloresdc/users/&

...assuming of course that the directory names under that filesystem
match the usernames of your users.

> Question, if we really must have the root cache then how do I get that 
> on boot? I need to run this as root:
> kinit -k steve2 to get the cache with my key in /etc/krb5.keytab. I 
> can't find a way to be able to do that on either Ubuntu 12.10 nor 
> openSUSE 12.3.
> 

I think you're confused as to what "multiuser" does. It allows users to
access the *same* mounted filesystem with their own krb5 creds. IOW,
instead of trying to use autofs like you are here, you could simply
do this:

    mount -t cifs //doloresdc/users /cifsusers -o sec=krb5,multiuser

...assuming that you have a credcache for uid=0 or proper credentials
in /etc/krb5.keytab, then it should mount and users can access
everything under /cifsusers with their own credentials.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
