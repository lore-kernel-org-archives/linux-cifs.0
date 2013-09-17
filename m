From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: don't spam the logs on unexpected lookup errors
Date: Tue, 17 Sep 2013 10:55:33 -0400
Message-ID: <20130917105533.517d1ff1@tlielax.poochiereds.net>
References: <1379416091-2040-1-git-send-email-jlayton@redhat.com>
	<CAH2r5mvVhOy22dGcOhCojZn0TiwdrtyW1SV_ePMiKqZkhgsPFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andrey Shernyukov <andreysh-0G7livjLyD/FOEHFb8W2jw@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvVhOy22dGcOhCojZn0TiwdrtyW1SV_ePMiKqZkhgsPFQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 17 Sep 2013 09:48:27 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Why not change it to ignore sharing violation?

That's just taking us down the special-case rabbit hole. This is not
information that is particularly relevant to anyone unless they're
trying to debug a problem, and in that situation having them turn up
cifsFYI makes more sense.

> What happens if vers=2.1 ie smb2.1
>
> On Sep 17, 2013 6:08 AM, "Jeff Layton" <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > Andrey reported that he was seeing cifs.ko spam the logs with messages
> > like this:
> >
> >     CIFS VFS: Unexpected lookup error -26
> >
> > He was listing the root directory of a server and hitting an error when
> > trying to QUERY_PATH_INFO against hiberfil.sys and pagefile.sys. The
> > right fix would be to switch the lookup code over to using FIND_FIRST,
> > but until then we really don't need to report this at a level of
> > KERN_ERR. Convert this message over to FYI level.
> >
> > Reported-by: "Andrey Shernyukov" <andreysh-0G7livjLyD/FOEHFb8W2jw@public.gmane.org>
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/dir.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> > index d3e2eaa..55c38cf 100644
> > --- a/fs/cifs/dir.c
> > +++ b/fs/cifs/dir.c
> > @@ -755,7 +755,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct
> > dentry *direntry,
> >         /*      if it was once a directory (but how can we tell?) we could
> > do
> >                 shrink_dcache_parent(direntry); */
> >         } else if (rc != -EACCES) {
> > -               cifs_dbg(VFS, "Unexpected lookup error %d\n", rc);
> > +               cifs_dbg(FYI, "Unexpected lookup error %d\n", rc);
> >                 /* We special case check for Access Denied - since that
> >                 is a common return code */
> >         }
> > --
> > 1.8.3.1
> >
> >


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
