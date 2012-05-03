From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: make sure we ignore the credentials= and cred=
 options
Date: Thu, 3 May 2012 07:30:23 -0400
Message-ID: <20120503073023.0bcb27cf@corrin.poochiereds.net>
References: <1335981808-3885-1-git-send-email-jlayton@redhat.com>
	<1336043928.2948.13.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ronald645-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336043928.2948.13.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 03 May 2012 12:18:48 +0100
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Wed, 2012-05-02 at 14:03 -0400, Jeff Layton wrote:
> > Older mount.cifs programs passed this on to the kernel after parsing
> > the file. Make sure the kernel ignores that option.
> > 
> > Should fix:
> > 
> >     https://bugzilla.kernel.org/show_bug.cgi?id=43195
> > 
> > Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Reported-by: Ronald <ronald645-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/connect.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index a75902b..5dcc551 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -215,6 +215,8 @@ static const match_table_t cifs_mount_option_tokens = {
> >  
> >  	{ Opt_ignore, "cred" },
> >  	{ Opt_ignore, "credentials" },
> > +	{ Opt_ignore, "cred=%s" },
> > +	{ Opt_ignore, "credentials=%s" },
> 
> We don't expect cred/credentials by themselves in the mount options
> list. Instead of adding the new checks, we can instead simply replace
> the original lines with ones containing the string.
> 
> -       { Opt_ignore, "cred" },
> -       { Opt_ignore, "credentials" },
> +       { Opt_ignore, "cred=%s" },
> +       { Opt_ignore, "credentials=%s" },
> 
> Sachin Prabhu
> 

I considered that, but figured we might want to keep ignoring the
"bare" options. OTOH, nothing should be sending those to the kernel, so
might as well remove them.

Steve has already merged my patch though, so you'd need to do a new one
on top of that...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
