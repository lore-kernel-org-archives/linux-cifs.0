From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: pam module to set cifs credentials in key store
Date: Wed, 13 Nov 2013 16:50:45 -0500
Message-ID: <20131113165045.0e7842f9@tlielax.poochiereds.net>
References: <loom.20131113T002139-562@post.gmane.org>
	<20131112212536.6061477e@corrin.poochiereds.net>
	<5283E835.2090508@cora.nwra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5283E835.2090508-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 13 Nov 2013 13:59:33 -0700
Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org> wrote:

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

Nice! Looks like a good start, but I'm no PAM expert. Maybe we can get
someone else to help review it.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
