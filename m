From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix sparse warning when calling cifs_strtoUCS
Date: Tue, 8 Nov 2011 17:52:00 -0600
Message-ID: <CAH2r5mukqT1tJWqdpeTQj_ZpcvvZuoa2yCgRAQLTd9pS3P-uMA@mail.gmail.com>
References: <1320417736-15607-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1320417736-15607-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Isn't this cleaner (avoids adding a cast by defining wpwd as what it
really is, le16, rather than u16)?

diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 7cacba1..80d8508 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -209,7 +209,7 @@ E_md4hash(const unsigned char *passwd, unsigned cha=
r *p16,
 {
 	int rc;
 	int len;
-	__u16 wpwd[129];
+	__le16 wpwd[129];

 	/* Password cannot be longer than 128 characters */
 	if (passwd) /* Password must be converted to NT unicode */
@@ -219,8 +219,8 @@ E_md4hash(const unsigned char *passwd, unsigned cha=
r *p16,
 		*wpwd =3D 0; /* Ensure string is null terminated */
 	}

-	rc =3D mdfour(p16, (unsigned char *) wpwd, len * sizeof(__u16));
-	memset(wpwd, 0, 129 * sizeof(__u16));
+	rc =3D mdfour(p16, (unsigned char *) wpwd, len * sizeof(__le16));
+	memset(wpwd, 0, 129 * sizeof(__le16));

 	return rc;
 }

On Fri, Nov 4, 2011 at 9:42 AM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> Fix sparse endian check warning while calling cifs_strtoUCS
>
> CHECK =A0 fs/cifs/smbencrypt.c
> fs/cifs/smbencrypt.c:216:37: warning: incorrect type in argument 1
> (different base types)
> fs/cifs/smbencrypt.c:216:37: =A0 =A0expected restricted __le16 [usert=
ype] *<noident>
> fs/cifs/smbencrypt.c:216:37: =A0 =A0got unsigned short *<noident>
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/smbencrypt.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
> index 7cacba1..56002ae 100644
> --- a/fs/cifs/smbencrypt.c
> +++ b/fs/cifs/smbencrypt.c
> @@ -213,7 +213,7 @@ E_md4hash(const unsigned char *passwd, unsigned c=
har *p16,
>
> =A0 =A0 =A0 =A0/* Password cannot be longer than 128 characters */
> =A0 =A0 =A0 =A0if (passwd) /* Password must be converted to NT unicod=
e */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS(wpwd, passwd, 128=
, codepage);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)wpwd, p=
asswd, 128, codepage);
> =A0 =A0 =A0 =A0else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0len =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*wpwd =3D 0; /* Ensure string is null =
terminated */
> --
> 1.6.0.2
>
>



--=20
Thanks,

Steve
