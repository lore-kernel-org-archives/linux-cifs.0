From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] cifs: integer overflow in parse_dacl()
Date: Wed, 11 Jan 2012 09:50:58 -0600
Message-ID: <CADT32eLVwQT9V67BX8TkjVHDnQoYS7OqA_-xbnjY57ZXO3EfsA@mail.gmail.com>
References: <20120111074627.GA4519@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120111074627.GA4519-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jan 11, 2012 at 1:46 AM, Dan Carpenter <dan.carpenter-QHcLZuEGTsthl2p70BpVqQ@public.gmane.org=
m> wrote:
> On 32 bit systems num_aces * sizeof(struct cifs_ace *) could overflow
> leading to a smaller ppace buffer than we expected.
>
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 72ddf23..c1b2544 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -909,6 +909,8 @@ static void parse_dacl(struct cifs_acl *pdacl, ch=
ar *end_of_acl,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0umode_t group_mask =3D S_IRWXG;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0umode_t other_mask =3D S_IRWXU | S_IRW=
XG | S_IRWXO;
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (num_aces > ULONG_MAX / sizeof(struc=
t cifs_ace *))

Should an error/warning (like cifs client can't handle these many aces =
or
possible erroneous number of aces sent by server etc.) be logged before
returning?

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ppace =3D kmalloc(num_aces * sizeof(st=
ruct cifs_ace *),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_KE=
RNEL);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!ppace) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
