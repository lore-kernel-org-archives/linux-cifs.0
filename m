From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] cifs: writing past the end of the array
Date: Sun, 6 Mar 2011 08:56:29 -0600
Message-ID: <AANLkTinMYhGZu+o6otZKUmX0sxgTBeTsAS_jgVjhzptC@mail.gmail.com>
References: <20110306132621.GN3416@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110306132621.GN3416@bicker>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Mar 6, 2011 at 7:26 AM, Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> This is a cut and paste error. =A0p16 only has 16 chars, not 21.
>
> Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
> index 3967635..1525d5e 100644
> --- a/fs/cifs/smbencrypt.c
> +++ b/fs/cifs/smbencrypt.c
> @@ -353,7 +353,7 @@ SMBNTencrypt(unsigned char *passwd, unsigned char=
 *c8, unsigned char *p24)
> =A0 =A0 =A0 =A0int rc;
> =A0 =A0 =A0 =A0unsigned char p16[16], p21[21];
>
> - =A0 =A0 =A0 memset(p16, '\0', 21);
> + =A0 =A0 =A0 memset(p16, '\0', 16);
> =A0 =A0 =A0 =A0memset(p21, '\0', 21);
>
> =A0 =A0 =A0 =A0rc =3D E_md4hash(passwd, p16);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Looks correct.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
