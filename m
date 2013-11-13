From: Simo <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: pam module to set cifs credentials in key store
Date: Wed, 13 Nov 2013 17:34:59 -0500
Message-ID: <1384382099.4226.63.camel@pico.ipa.ssimo.org>
References: <loom.20131113T002139-562@post.gmane.org>
	 <20131112212536.6061477e@corrin.poochiereds.net>
	 <5283E835.2090508@cora.nwra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5283E835.2090508-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2013-11-13 at 13:59 -0700, Orion Poplawski wrote:
> On 11/12/2013 07:25 PM, Jeff Layton wrote:
> > On Tue, 12 Nov 2013 23:22:57 +0000 (UTC)
> > Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org> wrote:
> >
> >> Has anyone started work on a pam module to set the cifs keys on login?  Is
> >> this sensible?
> >>
> >> - Orion
> >>
> >
> > Quite sensible. No one is working on it that I know of...
> >
> 
> How does this seem?
> 
> - I pulled a couple shared routines out of cifscreds.c into cifskey.[hc].
> - We build the pam_cifscreds.so directly from all of the source to get -fpic.
> 
> I've tested with:
> 
> /etc/pam.d/login
> #%PAM-1.0
> auth [user_unknown=ignore success=ok ignore=ignore default=bad] pam_securetty.so
> auth       substack     system-auth
> auth       optional     pam_cifscreds.so
> auth       include      postlogin
> account    required     pam_nologin.so
> account    include      system-auth
> password   include      system-auth
> # pam_selinux.so close should be the first session rule
> session    required     pam_selinux.so close
> session    required     pam_loginuid.so
> session    optional     pam_console.so
> # pam_selinux.so open should only be followed by sessions to be executed in 
> the user context
> session    required     pam_selinux.so open
> session    required     pam_namespace.so
> session    optional     pam_keyinit.so force revoke
> session    include      system-auth
> session    optional     pam_cifscreds.so domain=CO-RA
> session    include      postlogin
> -session   optional     pam_ck_connector.so
> 
> and it seems to work.
> 
> I tried putting it into system-auth but no luck.  Not sure what is up there.
> 

Uhm doesn't this code store the user password in the clear in a key that
is explicitly made readable to any process of the user in the same
session ?

Simo.
