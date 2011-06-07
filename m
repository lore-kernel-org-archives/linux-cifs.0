From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: silence printk when establishing first session on socket
Date: Mon, 6 Jun 2011 21:10:21 -0500
Message-ID: <BANLkTim5nTju2enYuwGTThr2OwDCdwm7Ng@mail.gmail.com>
References: <1307389223-25744-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1307389223-25744-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jun 6, 2011 at 2:40 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> When signing is enabled, the first session that's established on a
> socket will cause a printk like this to pop:
>
> =A0 =A0CIFS VFS: Unexpected SMB signature
>
> This is because the key exchange hasn't happened yet, so the signatur=
e
> field is bogus. Don't try to check the signature on the socket until =
the
> first session has been established. Also, eliminate the specific chec=
k
> for SMB_COM_NEGOTIATE since this check covers that case too.
>
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsencrypt.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index dfbd9f1..5a0ee7f 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -184,7 +184,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_pd=
u,
> =A0 =A0 =A0 =A0if (cifs_pdu =3D=3D NULL || server =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>
> - =A0 =A0 =A0 if (cifs_pdu->Command =3D=3D SMB_COM_NEGOTIATE)
> + =A0 =A0 =A0 if (!server->session_estab)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> =A0 =A0 =A0 =A0if (cifs_pdu->Command =3D=3D SMB_COM_LOCKING_ANDX) {
> --
> 1.7.5.2
>
>

No more that message in syslog buffer...

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
