From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: remove the sockopt= mount option
Date: Thu, 21 Feb 2013 11:19:32 -0500
Message-ID: <20130221111932.4a98f6fb@tlielax.poochiereds.net>
References: <1361446379-7970-1-git-send-email-jlayton@redhat.com>
	<CAFB9KM0bJo4NpePoe9aWMZGJ_jfk0W41Thefg7MD=_V+VP98Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM0bJo4NpePoe9aWMZGJ_jfk0W41Thefg7MD=_V+VP98Eg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 21 Feb 2013 10:37:21 -0500
Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Feb 21, 2013 at 6:32 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > ...as promised for 3.9.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/connect.c | 16 +---------------
> >  1 file changed, 1 insertion(+), 15 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index d997737..8609c42 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -97,7 +97,7 @@ enum {
> >         Opt_user, Opt_pass, Opt_ip,
> >         Opt_unc, Opt_domain,
> >         Opt_srcaddr, Opt_prefixpath,
> > -       Opt_iocharset, Opt_sockopt,
> > +       Opt_iocharset,
> >         Opt_netbiosname, Opt_servern,
> >         Opt_ver, Opt_vers, Opt_sec, Opt_cache,
> >
> > @@ -202,7 +202,6 @@ static const match_table_t cifs_mount_option_tokens =
> > {
> >         { Opt_srcaddr, "srcaddr=%s" },
> >         { Opt_prefixpath, "prefixpath=%s" },
> >         { Opt_iocharset, "iocharset=%s" },
> > -       { Opt_sockopt, "sockopt=%s" },
> >         { Opt_netbiosname, "netbiosname=%s" },
> >         { Opt_servern, "servern=%s" },
> >         { Opt_ver, "ver=%s" },
> > @@ -1722,19 +1721,6 @@ cifs_parse_mount_options(const char *mountdata,
> > const char *devname,
> >                          */
> >                         cFYI(1, "iocharset set to %s", string);
> >                         break;
> > -               case Opt_sockopt:
> > -                       string = match_strdup(args);
> > -                       if (string == NULL)
> > -                               goto out_nomem;
> > -
> > -                       if (strnicmp(string, "TCP_NODELAY", 11) == 0) {
> > -                               printk(KERN_WARNING "CIFS: the "
> > -                                       "sockopt=TCP_NODELAY option has
> > been "
> > -                                       "deprecated and will be removed "
> > -                                       "in 3.9\n");
> > -                               vol->sockopt_tcp_nodelay = 1;
> > -                       }
> > -                       break;
> >                 case Opt_netbiosname:
> >                         string = match_strdup(args);
> >                         if (string == NULL)
> 
> Gar.  Why was TCP_NODELAY pulled?  I only ask because I'm updating the
> socket options section of the smb.conf man page.  Supposedly NODELAY
> can have great results in some network configurations[citation
> needed].
>

commit b8eed28375a43e1c9aaa9d15af2a052aae0d0725
Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Tue Sep 18 16:20:35 2012 -0700

    cifs: cork the socket before a send and uncork it afterward
    
    We want to send SMBs as "atomically" as possible. Prior to sending any
    data on the socket, cork it to make sure that no non-full frames go
    out. Afterward, uncork it to make sure all of the data gets pushed out
    to the wire.
    
    Note that this more or less renders the socket=TCP_NODELAY mount option
    obsolete. When TCP_CORK and TCP_NODELAY are used on the same socket,
    TCP_NODELAY is essentially ignored.
    
    Acked-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
    Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
