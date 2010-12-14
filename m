From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 09/13] cifs: add cifs_call_async
Date: Tue, 14 Dec 2010 09:52:16 +0300
Message-ID: <AANLkTikB9ykuu9=jaaw4sJBqfdmLinhLkYGZ0putUzGB@mail.gmail.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-10-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291995877-2276-10-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/10 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Add a function that will send a request, and set up the mid for an
> async reply.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsproto.h | =A0 =A05 ++++
> =A0fs/cifs/transport.c | =A0 53 +++++++++++++++++++++++++++++++++++++=
+++++++++++++-
> =A02 files changed, 57 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index a8fc606..6131c1b 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -61,7 +61,12 @@ extern char *cifs_compose_mount_options(const char=
 *sb_mountdata,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *fullpath, const struct dfs=
_info3_param *ref,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char **devname);
> =A0/* extern void renew_parental_timestamps(struct dentry *direntry);=
*/
> +extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_=
buffer,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct TCP_Server_Info *server);
> =A0extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
> +extern int cifs_call_async(struct TCP_Server_Info *server,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb_hdr *=
in_buf, mid_callback_t *callback,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0void *cbdata);
> =A0extern int SendReceive(const unsigned int /* xid */ , struct cifsS=
esInfo *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb_hdr * /* in=
put */ ,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb_hdr * /* ou=
t */ ,
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 97a1170..2a0b14d 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -42,7 +42,7 @@ wake_up_task(struct mid_q_entry *mid)
> =A0 =A0 =A0 =A0wake_up_process(mid->callback_data);
> =A0}
>
> -static struct mid_q_entry *
> +struct mid_q_entry *
> =A0AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server=
_Info *server)
> =A0{
> =A0 =A0 =A0 =A0struct mid_q_entry *temp;
> @@ -338,6 +338,57 @@ wait_for_response(struct TCP_Server_Info *server=
, struct mid_q_entry *midQ)
>
>
> =A0/*
> + * Send a SMB request and set the callback function in the mid to ha=
ndle
> + * the result. Caller is responsible for dealing with timeouts.
> + */
> +int
> +cifs_call_async(struct TCP_Server_Info *server, struct smb_hdr *in_b=
uf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_callback_t *callback, void *cbdata)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 struct mid_q_entry *mid;
> +
> + =A0 =A0 =A0 rc =3D wait_for_free_request(server, CIFS_ASYNC_OP);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> +
> + =A0 =A0 =A0 mutex_lock(&server->srv_mutex);
> + =A0 =A0 =A0 mid =3D AllocMidQEntry(in_buf, server);
> + =A0 =A0 =A0 if (mid =3D=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 rc =3D cifs_sign_smb(in_buf, server, &mid->sequence_num=
ber);
> + =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 mid->callback =3D callback;
> + =A0 =A0 =A0 mid->callback_data =3D cbdata;
> + =A0 =A0 =A0 mid->midState =3D MID_REQUEST_SUBMITTED;
> +#ifdef CONFIG_CIFS_STATS2
> + =A0 =A0 =A0 atomic_inc(&server->inSend);
> +#endif
> + =A0 =A0 =A0 rc =3D smb_send(server, in_buf, in_buf->smb_buf_length)=
;
> +#ifdef CONFIG_CIFS_STATS2
> + =A0 =A0 =A0 atomic_dec(&server->inSend);
> + =A0 =A0 =A0 mid->when_sent =3D jiffies;
> +#endif
> + =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> +
> + =A0 =A0 =A0 return rc;
> +out_err:
> + =A0 =A0 =A0 DeleteMidQEntry(mid);
> + =A0 =A0 =A0 atomic_dec(&server->inFlight);
> + =A0 =A0 =A0 wake_up(&server->request_q);
> + =A0 =A0 =A0 return rc;
> +}
> +
> +/*
> =A0*
> =A0* Send an SMB Request. =A0No response info (other than return code=
)
> =A0* needs to be parsed.
> --
> 1.7.3.2
>


Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
