From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/5] cifs: make cifs_send_async take a kvec array
Date: Tue, 12 Apr 2011 13:39:13 +0400
Message-ID: <BANLkTinVzhYeLAc2+FLn=vvFH-s1o4ZQag@mail.gmail.com>
References: <1301747039-31411-1-git-send-email-jlayton@redhat.com>
	<1301747039-31411-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301747039-31411-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/2 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> We'll need this for async writes, so convert the call to take a kvec
> array. CIFSSMBEcho is changed to put a kvec on the stack and pass
> in the SMB buffer using that.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsproto.h | =A0 =A04 ++--
> =A0fs/cifs/cifssmb.c =A0 | =A0 =A06 ++++--
> =A0fs/cifs/transport.c | =A0 13 +++++++------
> =A03 files changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 4af7db8..e255a2b 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -65,8 +65,8 @@ extern struct mid_q_entry *AllocMidQEntry(const str=
uct smb_hdr *smb_buffer,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0struct TCP_Server_Info *server);
> =A0extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
> =A0extern int wait_for_free_request(struct TCP_Server_Info *sv, const=
 int long_op);
> -extern int cifs_call_async(struct TCP_Server_Info *server,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb_hdr *=
in_buf, mid_callback_t *callback,
> +extern int cifs_call_async(struct TCP_Server_Info *server, struct kv=
ec *iov,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int nve=
c, mid_callback_t *callback,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 void *cbdata);
> =A0extern int SendReceive(const unsigned int /* xid */ , struct cifs_=
ses *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb_hdr * /* in=
put */ ,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 655f24c..8de7e79 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -725,6 +725,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
> =A0{
> =A0 =A0 =A0 =A0ECHO_REQ *smb;
> =A0 =A0 =A0 =A0int rc =3D 0;
> + =A0 =A0 =A0 struct kvec iov;
>
> =A0 =A0 =A0 =A0cFYI(1, "In echo request");
>
> @@ -739,9 +740,10 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0put_bcc(1, &smb->hdr);
> =A0 =A0 =A0 =A0smb->Data[0] =3D 'a';
> =A0 =A0 =A0 =A0inc_rfc1001_len(smb, 3);
> + =A0 =A0 =A0 iov.iov_base =3D smb;
> + =A0 =A0 =A0 iov.iov_len =3D be32_to_cpu(smb->hdr.smb_buf_length) + =
4;
>
> - =A0 =A0 =A0 rc =3D cifs_call_async(server, (struct smb_hdr *)smb,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_ec=
ho_callback, server);
> + =A0 =A0 =A0 rc =3D cifs_call_async(server, &iov, 1, cifs_echo_callb=
ack, server);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Echo request failed: %d", rc)=
;
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index d9833fc..7ccf292 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -349,11 +349,12 @@ wait_for_response(struct TCP_Server_Info *serve=
r, struct mid_q_entry *midQ)
> =A0* the result. Caller is responsible for dealing with timeouts.
> =A0*/
> =A0int
> -cifs_call_async(struct TCP_Server_Info *server, struct smb_hdr *in_b=
uf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_callback_t *callback, void *cbdata)
> +cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int nvec, mid_callback_t *call=
back, void *cbdata)
> =A0{
> =A0 =A0 =A0 =A0int rc;
> =A0 =A0 =A0 =A0struct mid_q_entry *mid;
> + =A0 =A0 =A0 struct smb_hdr *hdr =3D (struct smb_hdr *)iov[0].iov_ba=
se;
>
> =A0 =A0 =A0 =A0rc =3D wait_for_free_request(server, CIFS_ASYNC_OP);
> =A0 =A0 =A0 =A0if (rc)
> @@ -361,10 +362,10 @@ cifs_call_async(struct TCP_Server_Info *server,=
 struct smb_hdr *in_buf,
>
> =A0 =A0 =A0 =A0/* enable signing if server requires it */
> =A0 =A0 =A0 =A0if (server->sec_mode & (SECMODE_SIGN_REQUIRED | SECMOD=
E_SIGN_ENABLED))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 in_buf->Flags2 |=3D SMBFLG2_SECURITY_SI=
GNATURE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hdr->Flags2 |=3D SMBFLG2_SECURITY_SIGNA=
TURE;
>
> =A0 =A0 =A0 =A0mutex_lock(&server->srv_mutex);
> - =A0 =A0 =A0 mid =3D AllocMidQEntry(in_buf, server);
> + =A0 =A0 =A0 mid =3D AllocMidQEntry(hdr, server);
> =A0 =A0 =A0 =A0if (mid =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&server->srv_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
> @@ -375,7 +376,7 @@ cifs_call_async(struct TCP_Server_Info *server, s=
truct smb_hdr *in_buf,
> =A0 =A0 =A0 =A0list_add_tail(&mid->qhead, &server->pending_mid_q);
> =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
>
> - =A0 =A0 =A0 rc =3D cifs_sign_smb(in_buf, server, &mid->sequence_num=
ber);
> + =A0 =A0 =A0 rc =3D cifs_sign_smb2(iov, nvec, server, &mid->sequence=
_number);
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&server->srv_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_err;
> @@ -385,7 +386,7 @@ cifs_call_async(struct TCP_Server_Info *server, s=
truct smb_hdr *in_buf,
> =A0 =A0 =A0 =A0mid->callback_data =3D cbdata;
> =A0 =A0 =A0 =A0mid->midState =3D MID_REQUEST_SUBMITTED;
> =A0 =A0 =A0 =A0cifs_in_send_inc(server);
> - =A0 =A0 =A0 rc =3D smb_send(server, in_buf, be32_to_cpu(in_buf->smb=
_buf_length));
> + =A0 =A0 =A0 rc =3D smb_sendv(server, iov, nvec);
> =A0 =A0 =A0 =A0cifs_in_send_dec(server);
> =A0 =A0 =A0 =A0cifs_save_when_sent(mid);
> =A0 =A0 =A0 =A0mutex_unlock(&server->srv_mutex);
> --
> 1.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
