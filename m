From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: remove the sockopt= mount option
Date: Thu, 21 Feb 2013 11:27:19 -0500
Message-ID: <20130221112719.2ed40ecf@tlielax.poochiereds.net>
References: <1361446379-7970-1-git-send-email-jlayton@redhat.com>
	<CAFB9KM0bJo4NpePoe9aWMZGJ_jfk0W41Thefg7MD=_V+VP98Eg@mail.gmail.com>
	<CAH2r5mtHsOjXjXx5NdHWNzoTmVmny8gSh_Gd1XfHdNfCOHJDyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtHsOjXjXx5NdHWNzoTmVmny8gSh_Gd1XfHdNfCOHJDyA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 21 Feb 2013 10:00:07 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> We should do some quick performance runs to verify this - but with
> corking and uncorking the socket explicitly presumably TCP_NODELAY
> should not be needed.
> 

I would think time for that sort of investigation was before you merged
the patch that said we were going to remove it. I assumed that since
you took that patch, you were OK with it.

In any case, I'll turn this question around...

TCP_NODELAY says: Send frames as soon as possible after a sendmsg (or
kernel_sendmsg in this case)

TCP_CORK says: hold sending until I uncork the socket

If the socket is CORK'ed then that overrides TCP_NODELAY (at least in
my reading of the code). Since we always cork/uncork the socket now,
what possible benefit could there be to keeping the sockopt=TCP_NODELAY
option around?

> On Thu, Feb 21, 2013 at 9:37 AM, Scott Lovenberg
> <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Thu, Feb 21, 2013 at 6:32 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >>
> >> ...as promised for 3.9.
> >>
> >> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> ---
> >>  fs/cifs/connect.c | 16 +---------------
> >>  1 file changed, 1 insertion(+), 15 deletions(-)
> >>
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index d997737..8609c42 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -97,7 +97,7 @@ enum {
> >>         Opt_user, Opt_pass, Opt_ip,
> >>         Opt_unc, Opt_domain,
> >>         Opt_srcaddr, Opt_prefixpath,
> >> -       Opt_iocharset, Opt_sockopt,
> >> +       Opt_iocharset,
> >>         Opt_netbiosname, Opt_servern,
> >>         Opt_ver, Opt_vers, Opt_sec, Opt_cache,
> >>
> >> @@ -202,7 +202,6 @@ static const match_table_t cifs_mount_option_tokens =
> >> {
> >>         { Opt_srcaddr, "srcaddr=%s" },
> >>         { Opt_prefixpath, "prefixpath=%s" },
> >>         { Opt_iocharset, "iocharset=%s" },
> >> -       { Opt_sockopt, "sockopt=%s" },
> >>         { Opt_netbiosname, "netbiosname=%s" },
> >>         { Opt_servern, "servern=%s" },
> >>         { Opt_ver, "ver=%s" },
> >> @@ -1722,19 +1721,6 @@ cifs_parse_mount_options(const char *mountdata,
> >> const char *devname,
> >>                          */
> >>                         cFYI(1, "iocharset set to %s", string);
> >>                         break;
> >> -               case Opt_sockopt:
> >> -                       string = match_strdup(args);
> >> -                       if (string == NULL)
> >> -                               goto out_nomem;
> >> -
> >> -                       if (strnicmp(string, "TCP_NODELAY", 11) == 0) {
> >> -                               printk(KERN_WARNING "CIFS: the "
> >> -                                       "sockopt=TCP_NODELAY option has
> >> been "
> >> -                                       "deprecated and will be removed "
> >> -                                       "in 3.9\n");
> >> -                               vol->sockopt_tcp_nodelay = 1;
> >> -                       }
> >> -                       break;
> >>                 case Opt_netbiosname:
> >>                         string = match_strdup(args);
> >>                         if (string == NULL)
> >
> > Gar.  Why was TCP_NODELAY pulled?  I only ask because I'm updating the
> > socket options section of the smb.conf man page.  Supposedly NODELAY
> > can have great results in some network configurations[citation
> > needed].
> >
> > --
> > Peace and Blessings,
> > -Scott.
> 
> 
> 


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
