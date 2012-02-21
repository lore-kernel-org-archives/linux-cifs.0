From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 7/8] cifs: abstract out function to marshal up the
 iovec array for async writes
Date: Tue, 21 Feb 2012 11:47:57 +0400
Message-ID: <CAKywueRxVEk3Em9WLwA64UYqNdBCPkd=cvmXRODESNcV-stPPw@mail.gmail.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
	<1328279581-21889-8-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328279581-21889-8-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/3 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> We'll need to do something a bit different depending on the caller.
> Abstract the code that marshals the page array into an iovec.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsproto.h | =A0 =A02 ++
> =A0fs/cifs/cifssmb.c =A0 | =A0 17 +++++++----------
> =A0fs/cifs/file.c =A0 =A0 =A0| =A0 22 ++++++++++++++++++++++
> =A03 files changed, 31 insertions(+), 10 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index ff528f3..bceadc5 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -480,6 +480,8 @@ struct cifs_writedata {
> =A0 =A0 =A0 =A0pid_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 pid;
> =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0by=
tes;
> =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 result;
> + =A0 =A0 =A0 void (*marshal_iov) (struct kvec *iov,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifs_=
writedata *wdata);
> =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nr=
_pages;
> =A0 =A0 =A0 =A0struct page =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *p=
ages[1];
> =A0};
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index e03a650..113b5af 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -2098,7 +2098,6 @@ cifs_async_writev(struct cifs_writedata *wdata)
> =A0 =A0 =A0 =A0WRITE_REQ *smb =3D NULL;
> =A0 =A0 =A0 =A0int wct;
> =A0 =A0 =A0 =A0struct cifs_tcon *tcon =3D tlink_tcon(wdata->cfile->tl=
ink);
> - =A0 =A0 =A0 struct inode *inode =3D wdata->cfile->dentry->d_inode;
> =A0 =A0 =A0 =A0struct kvec *iov =3D NULL;
>
> =A0 =A0 =A0 =A0if (tcon->ses->capabilities & CAP_LARGE_FILES) {
> @@ -2141,15 +2140,13 @@ cifs_async_writev(struct cifs_writedata *wdat=
a)
> =A0 =A0 =A0 =A0iov[0].iov_len =3D be32_to_cpu(smb->hdr.smb_buf_length=
) + 4 + 1;
> =A0 =A0 =A0 =A0iov[0].iov_base =3D smb;
>
> - =A0 =A0 =A0 /* marshal up the pages into iov array */
> - =A0 =A0 =A0 wdata->bytes =3D 0;
> - =A0 =A0 =A0 for (i =3D 0; i < wdata->nr_pages; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[i + 1].iov_len =3D min(inode->i_siz=
e -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 page_offset(wdata->pages[i]),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 (loff_t)PAGE_CACHE_SIZE);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[i + 1].iov_base =3D kmap(wdata->pag=
es[i]);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->bytes +=3D iov[i + 1].iov_len;
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* This function should marshal up the page array int=
o the kvec
> + =A0 =A0 =A0 =A0* array, reserving [0] for the header. It should kma=
p the pages
> + =A0 =A0 =A0 =A0* and set the iov_len properly for each one. It may =
also set
> + =A0 =A0 =A0 =A0* wdata->bytes too.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 wdata->marshal_iov(iov, wdata);
>
> =A0 =A0 =A0 =A0cFYI(1, "async write at %llu %u bytes", wdata->offset,=
 wdata->bytes);
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 264e99c..c7e47a2 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1604,6 +1604,27 @@ static int cifs_partialpagewrite(struct page *=
page, unsigned from, unsigned to)
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +/*
> + * Marshal up the iov array, reserving the first one for the header.=
 Also,
> + * set wdata->bytes.
> + */
> +static void
> +cifs_writepages_marshal_iov(struct kvec *iov, struct cifs_writedata =
*wdata)
> +{
> + =A0 =A0 =A0 int i;
> + =A0 =A0 =A0 struct inode *inode =3D wdata->cfile->dentry->d_inode;
> + =A0 =A0 =A0 loff_t size =3D i_size_read(inode);
> +
> + =A0 =A0 =A0 /* marshal up the pages into iov array */
> + =A0 =A0 =A0 wdata->bytes =3D 0;
> + =A0 =A0 =A0 for (i =3D 0; i < wdata->nr_pages; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[i + 1].iov_len =3D min(size - page_=
offset(wdata->pages[i]),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 (loff_t)PAGE_CACHE_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[i + 1].iov_base =3D kmap(wdata->pag=
es[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->bytes +=3D iov[i + 1].iov_len;
> + =A0 =A0 =A0 }
> +}
> +
> =A0static int cifs_writepages(struct address_space *mapping,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct writeback_=
control *wbc)
> =A0{
> @@ -1748,6 +1769,7 @@ retry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wdata->sync_mode =3D wbc->sync_mode;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wdata->nr_pages =3D nr_pages;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wdata->offset =3D page_offset(wdata->p=
ages[0]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->marshal_iov =3D cifs_writepages_=
marshal_iov;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0do {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (wdata->cfile !=3D =
NULL)
> --
> 1.7.7.6
>

Looks good.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
