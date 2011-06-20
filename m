From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: free blkcipher in smbhash
Date: Mon, 20 Jun 2011 14:00:39 -0500
Message-ID: <BANLkTimavY4NVBh9zqt+e22uBW5hdX6foA@mail.gmail.com>
References: <1308594796-29004-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1308594796-29004-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jun 20, 2011 at 1:33 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> This is currently leaked in the rc =3D=3D 0 case.
>
> Reported-by: J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/smbencrypt.c | =A0 =A06 ++----
> =A01 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
> index 1525d5e..1c5b770 100644
> --- a/fs/cifs/smbencrypt.c
> +++ b/fs/cifs/smbencrypt.c
> @@ -90,12 +90,10 @@ smbhash(unsigned char *out, const unsigned char *=
in, unsigned char *key)
> =A0 =A0 =A0 =A0sg_init_one(&sgout, out, 8);
>
> =A0 =A0 =A0 =A0rc =3D crypto_blkcipher_encrypt(&desc, &sgout, &sgin, =
8);
> - =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "could not encrypt crypt key=
 rc: %d\n", rc);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_free_blkcipher(tfm_des);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto smbhash_err;
> - =A0 =A0 =A0 }
>
> + =A0 =A0 =A0 crypto_free_blkcipher(tfm_des);
> =A0smbhash_err:
> =A0 =A0 =A0 =A0return rc;
> =A0}
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Correct.
Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
