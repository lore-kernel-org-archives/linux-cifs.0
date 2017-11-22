From: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH] cifs: avoid a kmalloc in smb2_send_recv/SendReceive2 for
 the common case
Date: Wed, 22 Nov 2017 00:06:38 +0000
Message-ID: <CY4PR21MB013522818F6E904053FA08D4B6200@CY4PR21MB0135.namprd21.prod.outlook.com>
References: <20171121040807.8364-1-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121040807.8364-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



2017-11-20 20:08 GMT-08:00 Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> In both functions, use an array of 8 (arbitrary but should be big enough
> for all current uses) iov and avoid having to kmalloc the array
> for the common case.
>
> If 8 is too small, then fall back to the original behaviour and use
> kmalloc/kfree.
>
> This should not change any behaviour but should save us a tiny amount of
> cpu cycles.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/transport.c | 33 +++++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 10 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index e678307bb7a0..510f41a435c8 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -38,6 +38,9 @@
>  #include "cifsproto.h"
>  #include "cifs_debug.h"
>
> +/* Max number of iovectors we can use off the stack when sending request=
s. */
> +#define CIFS_MAX_IOV_SIZE 8
> +
>  void
>  cifs_wake_up_task(struct mid_q_entry *mid)
>  {
> @@ -803,12 +806,16 @@ SendReceive2(const unsigned int xid, struct cifs_se=
s *ses,
>              const int flags, struct kvec *resp_iov)
>  {
>         struct smb_rqst rqst;
> -       struct kvec *new_iov;
> +       struct kvec s_iov[CIFS_MAX_IOV_SIZE], *new_iov;
>         int rc;
>
> -       new_iov =3D kmalloc(sizeof(struct kvec) * (n_vec + 1), GFP_KERNEL=
);
> -       if (!new_iov)
> -               return -ENOMEM;
> +       if (n_vec + 1 > CIFS_MAX_IOV_SIZE) {
> +               new_iov =3D kmalloc(sizeof(struct kvec) * (n_vec + 1),
> +                                 GFP_KERNEL);
> +               if (!new_iov)
> +                       return -ENOMEM;
> +       } else
> +               new_iov =3D s_iov;
>
>         /* 1st iov is a RFC1001 length followed by the rest of the packet=
 */
>         memcpy(new_iov + 1, iov, (sizeof(struct kvec) * n_vec));
> @@ -823,7 +830,8 @@ SendReceive2(const unsigned int xid, struct cifs_ses =
*ses,
>         rqst.rq_nvec =3D n_vec + 1;
>
>         rc =3D cifs_send_recv(xid, ses, &rqst, resp_buf_type, flags, resp=
_iov);
> -       kfree(new_iov);
> +       if (n_vec + 1 > CIFS_MAX_IOV_SIZE)
> +               kfree(new_iov);
>         return rc;
>  }
>
> @@ -834,15 +842,19 @@ smb2_send_recv(const unsigned int xid, struct cifs_=
ses *ses,
>                const int flags, struct kvec *resp_iov)
>  {
>         struct smb_rqst rqst;
> -       struct kvec *new_iov;
> +       struct kvec s_iov[CIFS_MAX_IOV_SIZE], *new_iov;
>         int rc;
>         int i;
>         __u32 count;
>         __be32 rfc1002_marker;
>
> -       new_iov =3D kmalloc(sizeof(struct kvec) * (n_vec + 1), GFP_KERNEL=
);
> -       if (!new_iov)
> -               return -ENOMEM;
> +       if (n_vec + 1 > CIFS_MAX_IOV_SIZE) {
> +               new_iov =3D kmalloc(sizeof(struct kvec) * (n_vec + 1),
> +                                 GFP_KERNEL);
> +               if (!new_iov)
> +                       return -ENOMEM;
> +       } else
> +               new_iov =3D s_iov;
>
>         /* 1st iov is an RFC1002 Session Message length */
>         memcpy(new_iov + 1, iov, (sizeof(struct kvec) * n_vec));
> @@ -861,7 +873,8 @@ smb2_send_recv(const unsigned int xid, struct cifs_se=
s *ses,
>         rqst.rq_nvec =3D n_vec + 1;
>
>         rc =3D cifs_send_recv(xid, ses, &rqst, resp_buf_type, flags, resp=
_iov);
> -       kfree(new_iov);
> +       if (n_vec + 1 > CIFS_MAX_IOV_SIZE)
> +               kfree(new_iov);
>         return rc;
>  }
>
> --
> 2.13.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks for the patch!

Should we split it into two and mark the 1st part for stable? This would ad=
dress possible performance degradation in previous kernels because SendRece=
ive2() was changed to use kmalloc() several kernels ago. I didn't measure a=
 performance difference, so not sure if it is worth the effort.

In both cases (as one patch or two), you can add my

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

--
Best regards,
Pavel Shilovsky
