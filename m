From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/15] cifs: fix handling of signing with writepages (try #5)
Date: Wed, 22 Sep 2010 17:29:12 -0500
Message-ID: <AANLkTi=U25njqKFiGW2vO_uWMqQ52Xz9m+wigyW=AHez@mail.gmail.com>
References: <1285190586-10750-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285190586-10750-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The patch does seem to change one behavior.

If CIFSSMBWrite2 writes data, but less than requested
(bytes written < bytes_to_write) this may change the file size but the
(local copy of eof?) eof won't be updated in that case (as it was
before)

On Wed, Sep 22, 2010 at 4:23 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Get a reference to the file early so we can eventually base the decis=
ion
> about signing on the correct tcon. If that doesn't work for some reas=
on,
> then fall back to generic_writepages. That's just as likely to fail, =
but
> it simplifies the error handling.
>
> In truth, I'm not sure how that could occur anyway, so maybe a NULL
> open_file here ought to be a BUG()?
>
> After that, we drop the reference to the open_file and then we re-get
> one prior to each WriteAndX call. This helps ensure that the filehand=
le
> isn't held open any longer than necessary and that open files are
> reclaimed prior to each write call.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0 70 ++++++++++++++++++++++++++++++------------=
-------------
> =A01 files changed, 38 insertions(+), 32 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 84979fc..e099b50 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1353,6 +1353,15 @@ static int cifs_writepages(struct address_spac=
e *mapping,
> =A0 =A0 =A0 =A0int scanned =3D 0;
> =A0 =A0 =A0 =A0int xid, long_op;
>
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* BB: Is this meaningful for a non-block-device file=
 system?
> + =A0 =A0 =A0 =A0* If it is, we should test it again after we do I/O
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (wbc->nonblocking && bdi_write_congested(bdi)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wbc->encountered_congestion =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0cifs_sb =3D CIFS_SB(mapping->host->i_sb);
>
> =A0 =A0 =A0 =A0/*
> @@ -1362,26 +1371,28 @@ static int cifs_writepages(struct address_spa=
ce *mapping,
> =A0 =A0 =A0 =A0if (cifs_sb->wsize < PAGE_CACHE_SIZE)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return generic_writepages(mapping, wbc=
);
>
> - =A0 =A0 =A0 if ((cifs_sb->tcon->ses) && (cifs_sb->tcon->ses->server=
))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb->tcon->ses->server->secMode=
 &
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (SECMOD=
E_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!experimEnabled)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
generic_writepages(mapping, wbc);
> -
> =A0 =A0 =A0 =A0iov =3D kmalloc(32 * sizeof(struct kvec), GFP_KERNEL);
> =A0 =A0 =A0 =A0if (iov =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return generic_writepages(mapping, wbc=
);
>
> -
> =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0* BB: Is this meaningful for a non-block-device file=
 system?
> - =A0 =A0 =A0 =A0* If it is, we should test it again after we do I/O
> + =A0 =A0 =A0 =A0* if there's no open file, then this is likely to fa=
il too,
> + =A0 =A0 =A0 =A0* but it'll at least handle the return. Maybe it sho=
uld be
> + =A0 =A0 =A0 =A0* a BUG() instead?
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 if (wbc->nonblocking && bdi_write_congested(bdi)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 wbc->encountered_congestion =3D 1;
> + =A0 =A0 =A0 open_file =3D find_writable_file(CIFS_I(mapping->host))=
;
> + =A0 =A0 =A0 if (!open_file) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(iov);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return generic_writepages(mapping, wbc)=
;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 tcon =3D open_file->tcon;
> + =A0 =A0 =A0 if (!experimEnabled && tcon->ses->server->secMode &
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (SECMODE_SIGN_REQUIRED =
| SECMODE_SIGN_ENABLED)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFileInfo_put(open_file);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return generic_writepages(mapping, wbc)=
;
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 cifsFileInfo_put(open_file);
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
>
> @@ -1486,38 +1497,33 @@ retry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (n_iov) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Search for a writabl=
e handle every time we call
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* CIFSSMBWrite2. =A0=
We can't rely on the last handle
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* we used to still b=
e valid
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0open_file =3D find_wri=
table_file(CIFS_I(mapping->host));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!open_file) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR=
(1, "No writable handles for inode");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 -EBADF;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon =3D=
 open_file->tcon;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0long_o=
p =3D cifs_write_timeout(cifsi, offset);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
CIFSSMBWrite2(xid, tcon,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0open_file->netfid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
CIFSSMBWrite2(xid, tcon, open_file->netfid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes_to_write, offset,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &bytes_written, iov, n_iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 long_op);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifsFi=
leInfo_put(open_file);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_up=
date_eof(cifsi, offset, bytes_written);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =
|| bytes_written < bytes_to_write) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cERROR(1, "Write2 ret %d, wrote %d",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc, bytes_written);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 /* BB what if continued retry is
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0requested via mount flags? */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 if (rc =3D=3D -ENOSPC)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 set_bit(AS_ENOSPC, &mapping->flags);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 set_bit(AS_EIO, &mapping->flags);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else =
{
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cifs_stats_bytes_written(tcon, bytes_written);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || bytes_written=
 < bytes_to_write) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(=
1, "Write2 ret %d, wrote %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 rc, bytes_written);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB w=
hat if continued retry is
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
requested via mount flags? */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =
=3D=3D -ENOSPC)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 set_bit(AS_ENOSPC, &mapping->flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 set_bit(AS_EIO, &mapping->flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_up=
date_eof(cifsi, offset, bytes_written);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_st=
ats_bytes_written(tcon, bytes_written);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (i =3D 0; i < n_io=
v; i++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page =3D=
 pvec.pages[first + i];
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Sho=
uld we also set page error on
> --
> 1.7.3
>
>



--=20
Thanks,

Steve
