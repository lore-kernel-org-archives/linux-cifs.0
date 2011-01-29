From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: fix two compiler warning about uninitialized vars
Date: Sat, 29 Jan 2011 13:42:48 -0600
Message-ID: <AANLkTi=v38jDb4vZgE460dwpnRk-G3_r0UhieiUGkJtC@mail.gmail.com>
References: <1296302582-18953-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296302582-18953-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Jan 29, 2011 at 6:03 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> fs/cifs/link.c: In function =91symlink_hash=92:
> fs/cifs/link.c:58:3: warning: =91rc=92 may be used uninitialized in t=
his
> function [-Wuninitialized]
>
> fs/cifs/smbencrypt.c: In function =91mdfour=92:
> fs/cifs/smbencrypt.c:61:3: warning: =91rc=92 may be used uninitialize=
d in this
> function [-Wuninitialized]
>
> Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/link.c =A0 =A0 =A0 | =A0 =A03 ++-
> =A0fs/cifs/smbencrypt.c | =A0 =A03 ++-
> =A02 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index 02cd60a..e8804d3 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -55,8 +55,9 @@ symlink_hash(unsigned int link_len, const char *lin=
k_str, u8 *md5_hash)
>
> =A0 =A0 =A0 =A0md5 =3D crypto_alloc_shash("md5", 0, 0);
> =A0 =A0 =A0 =A0if (IS_ERR(md5)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(md5);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "%s: Crypto md5 allocation e=
rror %d\n", __func__, rc);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(md5);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0size =3D sizeof(struct shash_desc) + crypto_shash_desc=
size(md5);
> =A0 =A0 =A0 =A0sdescmd5 =3D kmalloc(size, GFP_KERNEL);
> diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
> index b5450e9..b5041c8 100644
> --- a/fs/cifs/smbencrypt.c
> +++ b/fs/cifs/smbencrypt.c
> @@ -58,8 +58,9 @@ mdfour(unsigned char *md4_hash, unsigned char *link=
_str, int link_len)
>
> =A0 =A0 =A0 =A0md4 =3D crypto_alloc_shash("md4", 0, 0);
> =A0 =A0 =A0 =A0if (IS_ERR(md4)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(md4);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "%s: Crypto md4 allocation e=
rror %d\n", __func__, rc);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(md4);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0size =3D sizeof(struct shash_desc) + crypto_shash_desc=
size(md4);
> =A0 =A0 =A0 =A0sdescmd4 =3D kmalloc(size, GFP_KERNEL);
> --
> 1.7.3.4
>
>

Looks correct.  Missed that.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
