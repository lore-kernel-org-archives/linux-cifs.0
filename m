From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/7] cifs: add ignore_pend flag to cifs_call_async
Date: Fri, 15 Apr 2011 12:48:21 +0400
Message-ID: <BANLkTinvsJ6+8y-LMRtutKDuvQPufwMx0w@mail.gmail.com>
References: <1302694994-8303-1-git-send-email-jlayton@redhat.com>
	<1302694994-8303-5-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302694994-8303-5-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/13 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> The current code always ignores the max_pending limit. Have it instea=
d
> only optionally ignore the pending limit. For CIFSSMBEcho, we need to
> ignore it to make sure they always can go out. For async reads, write=
s
> and potentially other calls, we need to respect it.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsproto.h | =A0 =A02 +-
> =A0fs/cifs/cifssmb.c =A0 | =A0 =A02 +-
> =A0fs/cifs/transport.c | =A0 =A05 +++--
> =A03 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index e255a2b..c621b45 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -67,7 +67,7 @@ extern void DeleteMidQEntry(struct mid_q_entry *mid=
Entry);
> =A0extern int wait_for_free_request(struct TCP_Server_Info *sv, const=
 int long_op);
> =A0extern int cifs_call_async(struct TCP_Server_Info *server, struct =
kvec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int nvec=
, mid_callback_t *callback,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0void *cbdata);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0void *cbdata, bo=
ol ignore_pend);
> =A0extern int SendReceive(const unsigned int /* xid */ , struct cifs_=
ses *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb_hdr * /* in=
put */ ,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb_hdr * /* ou=
t */ ,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 79e4881..33adc15 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -743,7 +743,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0iov.iov_base =3D smb;
> =A0 =A0 =A0 =A0iov.iov_len =3D be32_to_cpu(smb->hdr.smb_buf_length) +=
 4;
>
> - =A0 =A0 =A0 rc =3D cifs_call_async(server, &iov, 1, cifs_echo_callb=
ack, server);
> + =A0 =A0 =A0 rc =3D cifs_call_async(server, &iov, 1, cifs_echo_callb=
ack, server, true);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Echo request failed: %d", rc)=
;
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index a31c279..ad32b70 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -350,13 +350,14 @@ wait_for_response(struct TCP_Server_Info *serve=
r, struct mid_q_entry *midQ)
> =A0*/
> =A0int
> =A0cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int nvec, mid_callback_t *call=
back, void *cbdata)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int nvec, mid_callback_t *call=
back, void *cbdata,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bool ignore_pend)
> =A0{
> =A0 =A0 =A0 =A0int rc;
> =A0 =A0 =A0 =A0struct mid_q_entry *mid;
> =A0 =A0 =A0 =A0struct smb_hdr *hdr =3D (struct smb_hdr *)iov[0].iov_b=
ase;
>
> - =A0 =A0 =A0 rc =3D wait_for_free_request(server, CIFS_ASYNC_OP);
> + =A0 =A0 =A0 rc =3D wait_for_free_request(server, ignore_pend ? CIFS=
_ASYNC_OP : 0);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> --
> 1.7.4.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Looks right. Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
