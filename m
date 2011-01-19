From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/5] cifs: clean up unaligned accesses in validate_t2
Date: Wed, 19 Jan 2011 09:39:51 -0600
Message-ID: <AANLkTikBMqxiVtP9Gi-MXTDhEK51qqCMPG40knpg8NdV@mail.gmail.com>
References: <1295382799-7902-1-git-send-email-jlayton@redhat.com>
	<1295382799-7902-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295382799-7902-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jan 18, 2011 at 2:33 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> ...and clean up function to reduce indentation.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifssmb.c | =A0 44 +++++++++++++++++++++++----------------=
-----
> =A01 files changed, 23 insertions(+), 21 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 3b3072c..75a1559 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -331,31 +331,33 @@ smb_init_no_reconnect(int smb_command, int wct,=
 struct cifsTconInfo *tcon,
>
> =A0static int validate_t2(struct smb_t2_rsp *pSMB)
> =A0{
> - =A0 =A0 =A0 int rc =3D -EINVAL;
> - =A0 =A0 =A0 int total_size;
> + =A0 =A0 =A0 unsigned int total_size;
> +
> + =A0 =A0 =A0 /* check for plausible wct */
> + =A0 =A0 =A0 if (pSMB->hdr.WordCount < 10)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto vt2_err;
>
> - =A0 =A0 =A0 /* check for plausible wct, bcc and t2 data and parm si=
zes */
> =A0 =A0 =A0 =A0/* check for parm and data offset going beyond end of =
smb */
> - =A0 =A0 =A0 if (pSMB->hdr.WordCount >=3D 10) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((le16_to_cpu(pSMB->t2_rsp.Parameter=
Offset) <=3D 1024) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(le16_to_cpu(pSMB->t2_rsp.DataOf=
fset) <=3D 1024)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* check that bcc is at=
 least as big as parms + data */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* check that bcc is le=
ss than negotiated smb buffer */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_size =3D le16_to_=
cpu(pSMB->t2_rsp.ParameterCount);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (total_size < 512) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_s=
ize +=3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 le16_to_cpu(pSMB->t2_rsp.DataCount);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tot=
al_size <=3D get_bcc(&pSMB->hdr) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 total_size <
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 return 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (get_unaligned_le16(&pSMB->t2_rsp.ParameterOffset) >=
 1024 ||
> + =A0 =A0 =A0 =A0 =A0 get_unaligned_le16(&pSMB->t2_rsp.DataOffset) > =
1024)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto vt2_err;
> +
> + =A0 =A0 =A0 /* check that bcc is at least as big as parms + data */
> + =A0 =A0 =A0 /* check that bcc is less than negotiated smb buffer */
> + =A0 =A0 =A0 total_size =3D get_unaligned_le16(&pSMB->t2_rsp.Paramet=
erCount);
> + =A0 =A0 =A0 if (total_size >=3D 512)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto vt2_err;
> +
> + =A0 =A0 =A0 total_size +=3D get_unaligned_le16(&pSMB->t2_rsp.DataCo=
unt);
> + =A0 =A0 =A0 if (total_size > get_bcc(&pSMB->hdr) ||
> + =A0 =A0 =A0 =A0 =A0 total_size >=3D CIFSMaxBufSize + MAX_CIFS_HDR_S=
IZE)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto vt2_err;
> +
> + =A0 =A0 =A0 return 0;
> +vt2_err:
> =A0 =A0 =A0 =A0cifs_dump_mem("Invalid transact2 SMB: ", (char *)pSMB,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct smb_t2_rsp) + 16);
> - =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 return -EINVAL;
> =A0}
>
> =A0int
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Looks correct.
Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
