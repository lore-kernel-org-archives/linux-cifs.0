From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: cifs_flush should wait for writeback to complete
 before proceeding
Date: Fri, 24 Sep 2010 12:58:55 -0500
Message-ID: <AANLkTimdoOPyAmhWw0kTtnZan6+gudJZn=vgqTNpEL+A@mail.gmail.com>
References: <1285333153-9113-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285333153-9113-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We need to see the performance impact.  As you say cifs_writepages is
synchronous so we should be ok without it.  Any test results
before/after?

On Fri, Sep 24, 2010 at 7:59 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> It's possible that the kernel will call cifs_close on a filp while th=
ere
> is still dirty data attached to the inode. If it's the last writeable
> filp for an inode, then we may have no way to flush this data to the
> server.
>
> Thus, simply doing a filemap_fdatawrite in the .flush operation isn't
> sufficient. The client needs to wait for it to complete before
> returning. OTOH, there's no real need to perform a flush on a
> filehandle that's read-only.
>
> What currently saves us on this is the fact that cifs_writepages is
> basically synchronous. If and when we ever switch to an async writeba=
ck
> model, this will need to be fixed, so we might as well go ahead and
> fix it now.
>
> When flushing a writable filp, wait for the writeback to complete bef=
ore
> returning to ensure that the filehandle stays around until the writeb=
ack
> is complete.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0 17 +++++++----------
> =A01 files changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 80856f1..8084a8d 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1737,16 +1737,13 @@ int cifs_flush(struct file *file, fl_owner_t =
id)
> =A0 =A0 =A0 =A0struct inode *inode =3D file->f_path.dentry->d_inode;
> =A0 =A0 =A0 =A0int rc =3D 0;
>
> - =A0 =A0 =A0 /* Rather than do the steps manually:
> - =A0 =A0 =A0 =A0 =A0lock the inode for writing
> - =A0 =A0 =A0 =A0 =A0loop through pages looking for write behind data=
 (dirty pages)
> - =A0 =A0 =A0 =A0 =A0coalesce into contiguous 16K (or smaller) chunks=
 to write to server
> - =A0 =A0 =A0 =A0 =A0send to server (prefer in parallel)
> - =A0 =A0 =A0 =A0 =A0deal with writebehind errors
> - =A0 =A0 =A0 =A0 =A0unlock inode for writing
> - =A0 =A0 =A0 =A0 =A0filemapfdatawrite appears easier for the time be=
ing */
> -
> - =A0 =A0 =A0 rc =3D filemap_fdatawrite(inode->i_mapping);
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* if the file is writable, then flush any dirty data=
 to ensure that
> + =A0 =A0 =A0 =A0* the filehandle isn't closed out before writeback c=
ompletes.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (file->f_mode & FMODE_WRITE)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_and_wait(inode->i_=
mapping);
> +
> =A0 =A0 =A0 =A0/* reset wb rc if we were able to write out dirty page=
s */
> =A0 =A0 =A0 =A0if (!rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFS_I(inode)->write_behind_rc;
> --
> 1.7.2.3
>
>



--=20
Thanks,

Steve
