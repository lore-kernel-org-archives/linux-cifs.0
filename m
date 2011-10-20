From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Display strictcache mount option in /proc/mounts
Date: Thu, 20 Oct 2011 10:35:52 +0100
Message-ID: <1319103354.30821.60.camel@sprabhu.fab.redhat.com>
References: <1318337032.3659.65.camel@sprabhu.fab.redhat.com>
	 <CAH2r5ms0Udg87PTi9sRZsWbp3+SvCOKScHg3nWh6OtjKFNALqg@mail.gmail.com>
	 <1318861755.30821.27.camel@sprabhu.fab.redhat.com>
	 <CAH2r5msg+q2g9_iPnhEDbgxmROwVRid=XrkrCPELjH-8vYYbFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msg+q2g9_iPnhEDbgxmROwVRid=XrkrCPELjH-8vYYbFg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2011-10-19 at 21:10 -0500, Steve French wrote:
> > --
> >
> > Show nostrictsync and noperm mount options in /proc/mounts
> >
> > Add support to print nostrictsync and noperm mount options in /proc/mounts for shares mounted with these options.
> >
> > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/cifsfs.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 54b8f1e..eb6e8bf 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -432,6 +432,10 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
> >                seq_printf(s, ",mfsymlinks");
> >        if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
> >                seq_printf(s, ",fsc");
> > +       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)
> > +               seq_printf(s, ",nostrictsync");
> > +       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
> > +               seq_printf(s, ",noperm");
> >
> >        seq_printf(s, ",rsize=%d", cifs_sb->rsize);
> >        seq_printf(s, ",wsize=%d", cifs_sb->wsize);
> 
> I had to redo to avoid the merge conflict (your patch was not built on
> the previous one so conflicted with it) - but now merged.
> 
> 

Sorry about that. Thanks Steve.

Sachin Prabhu
