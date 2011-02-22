From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Use invalidate_inode_pages2 instead of invalidate_remote_inode
Date: Tue, 22 Feb 2011 18:12:30 +0300
Message-ID: <AANLkTi=DB0OuwMe_ASPDxbfwxJvDDYJD0K0fRfK-it1T@mail.gmail.com>
References: <1298387346-9228-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016367b629ab44d6c049ce0684a
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1298387346-9228-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--0016367b629ab44d6c049ce0684a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2011/2/22 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> We should invalidate a page even if it is locked now by someone, because
> we can leave an invalid data there and then think it's uptodate according
> to an oplock level (exclusive or II).
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/inode.c | =A0 13 ++++++++-----
> =A01 files changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 8852470..1da1f26 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1691,12 +1691,15 @@ cifs_invalidate_mapping(struct inode *inode)
>
> =A0 =A0 =A0 =A0cifs_i->invalid_mapping =3D false;
>
> - =A0 =A0 =A0 /* write back any cached data */
> - =A0 =A0 =A0 if (inode->i_mapping && inode->i_mapping->nrpages !=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_and_wait(inode->i_mapp=
ing);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode->i_mapping, rc);
> + =A0 =A0 =A0 if (inode->i_mapping) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* write back any cached data */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (inode->i_mapping->nrpages !=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_and_wa=
it(inode->i_mapping);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode->i_=
mapping, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 invalidate_inode_pages2(inode->i_mapping);
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 invalidate_remote_inode(inode);
> +
> =A0 =A0 =A0 =A0cifs_fscache_reset_inode_cookie(inode);
> =A0}
>
> --
> 1.7.1
>
>

I attached python script-reproducer. All shares should be mount with
new strictcache mount option.

--=20
Best regards,
Pavel Shilovsky.

--0016367b629ab44d6c049ce0684a
Content-Type: text/x-python; charset=US-ASCII; name="cache_validation.py"
Content-Disposition: attachment; filename="cache_validation.py"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkgye4b40

IyEvdXNyL2Jpbi9lbnYgcHl0aG9uCiMKIyBXZSBoYXZlIHRvIG1vdW50IHRoZSBzYW1lIHNoYXJl
IHRvIHRlc3QsIHRlc3QxLCB0ZXN0MiBkaXJlY3RvcmllcyB0aGF0IGxvY2F0ZSBpbiB0aGUgZGly
ZWN0b3J5IHdlCiMgZXhlY3V0ZSB0aGlzIHNjcmlwdCBmcm9tLgoKZnJvbSBvcyBpbXBvcnQgb3Bl
biwgY2xvc2UsIE9fUkRXUiwgT19DUkVBVCwgd3JpdGUsIHJlYWQsIE9fUkRPTkxZLCBPX1dST05M
WSwgT19UUlVOQywgbHNlZWssIFNFRUtfRU5ELCBTRUVLX1NFVAppbXBvcnQgdGltZQoKdHJpZXMg
PSAxCgp3aGlsZSBUcnVlOgoJcHJpbnQgJ3RyeSAjJywgdHJpZXMKCWYgPSBvcGVuKCd0ZXN0L190
ZXN0NDMyMV8nLCBPX1JEV1IgfCBPX0NSRUFUIHwgT19UUlVOQykKCWNsb3NlKGYpCgoJZjEgPSBv
cGVuKCd0ZXN0MS9fdGVzdDQzMjFfJywgT19SRFdSKQoJd3JpdGUoZjEsICdhJykKCWNsb3NlKGYx
KQoKCWYyID0gb3BlbigndGVzdDIvX3Rlc3Q0MzIxXycsIE9fV1JPTkxZKQoJd3JpdGUoZjIsICd4
JykKCWNsb3NlKGYyKQoKCWYzID0gb3BlbigndGVzdDEvX3Rlc3Q0MzIxXycsIE9fUkRPTkxZKQoJ
cmVzID0gcmVhZChmMywgMSkKCXByaW50ICdtdXN0IGJlIHg6JywgcmVzLCAnLScsCglpZiByZXMg
IT0gJ3gnOgoJCXByaW50ICdGQUlMJwoJCXRpbWUuc2xlZXAoMSkKCQlleGl0KCkKCXRpbWUuc2xl
ZXAoMC4xKQoKCWNsb3NlKGYzKQoJcHJpbnQgJ09LJwoJdHJpZXMgKz0gMQo=
--0016367b629ab44d6c049ce0684a--
