From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 15/18] cifs: reconnect unresponsive servers
Date: Mon, 27 Dec 2010 18:58:35 +0300
Message-ID: <AANLkTik0cc=eRCe9e4mZQD2eEOofMigr4fOnvf+=Po1m@mail.gmail.com>
References: <1293417006-6417-1-git-send-email-jlayton@redhat.com>
	<1293417006-6417-16-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293417006-6417-16-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/27 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> If the server isn't responding to echoes, we don't want to leave task=
s
> hung waiting for it to reply. At that point, we'll want to reconnect
> so that soft mounts can return an error to userspace quickly.
>
> If the client hasn't received a reply after a specified number of ech=
o
> intervals, assume that the transport is down and attempt to reconnect
> the socket.
>
> The number of echo_intervals to wait before attempting to reconnect i=
s
> tunable via a module parameter. Setting it to 0, means that the clien=
t
> will never attempt to reconnect. The default is 5.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c =A0 | =A0 =A05 +++++
> =A0fs/cifs/cifsglob.h | =A0 =A03 +++
> =A0fs/cifs/connect.c =A0| =A0 21 +++++++++++++++++----
> =A03 files changed, 25 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index e0fabbf..27fa0a2 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -80,6 +80,11 @@ bool sign_zero_copy =3D false;
> =A0module_param(sign_zero_copy, bool, 0644);
> =A0MODULE_PARM_DESC(sign_zero_copy, "Don't copy pages on write with s=
igning "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "enab=
led. Default: N");
> +unsigned short echo_retries =3D 5;
> +module_param(echo_retries, ushort, 0644);
> +MODULE_PARM_DESC(echo_retries, "Number of echo attempts before givin=
g up and "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"rec=
onnecting server. Default: 5. 0 means "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"nev=
er reconnect.");
> =A0extern mempool_t *cifs_sm_req_poolp;
> =A0extern mempool_t *cifs_req_poolp;
> =A0extern mempool_t *cifs_mid_poolp;
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 64d69f9..1dc74f4 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -799,6 +799,9 @@ GLOBAL_EXTERN unsigned int cifs_min_small; =A0/* =
min size of small buf pool */
> =A0GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at on=
ce to server*/
> =A0GLOBAL_EXTERN bool sign_zero_copy; /* don't copy written pages wit=
h signing */
>
> +/* reconnect after this many failed echo attempts */
> +GLOBAL_EXTERN unsigned short echo_retries;
> +
> =A0void cifs_oplock_break(struct work_struct *work);
> =A0void cifs_oplock_break_get(struct cifsFileInfo *cfile);
> =A0void cifs_oplock_break_put(struct cifsFileInfo *cfile);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 57187c6..0e7ae1e 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -186,6 +186,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0kfree(server->session_key.response);
> =A0 =A0 =A0 =A0server->session_key.response =3D NULL;
> =A0 =A0 =A0 =A0server->session_key.len =3D 0;
> + =A0 =A0 =A0 server->lstrp =3D jiffies;
> =A0 =A0 =A0 =A0mutex_unlock(&server->srv_mutex);
>
> =A0 =A0 =A0 =A0/* mark submitted MIDs for retry and issue callback */
> @@ -420,7 +421,20 @@ cifs_demultiplex_thread(struct TCP_Server_Info *=
server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smb_msg.msg_control =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smb_msg.msg_controllen =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pdu_length =3D 4; /* enough to get RFC=
1001 header */
> +
> =A0incomplete_rcv:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (echo_retries > 0 &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 time_after(jiffies, server->lst=
rp +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 (echo_retries * SMB_ECHO_INTERVAL))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Server %s ha=
s not responded in %d seconds. "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Re=
connecting...", server->hostname,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ec=
ho_retries * SMB_ECHO_INTERVAL / HZ));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_reconnect(server);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 csocket =3D server->sso=
cket;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&server->respon=
se_q);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0length =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kernel_recvmsg(csocket, &smb_m=
sg,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&iov, =
1, pdu_length, 0 /* BB other flags? */);
> @@ -581,6 +595,8 @@ incomplete_rcv:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->lstrp =3D jiffies;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_for_each_safe(tmp, tmp2, &server-=
>pending_mid_q) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry =3D list_ent=
ry(tmp, struct mid_q_entry, qhead);
> @@ -629,10 +645,6 @@ multi_t2_fnd:
> =A0#ifdef CONFIG_CIFS_STATS2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_en=
try->when_received =3D jiffies;
> =A0#endif
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* so w=
e do not time out requests to =A0server
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 which i=
s still responding (since server could
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 be busy=
 but not dead) */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server-=
>lstrp =3D jiffies;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry =3D NULL;
> @@ -1683,6 +1695,7 @@ cifs_get_tcp_session(struct smb_vol *volume_inf=
o)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0volume_info->target_rfc1001_name, RFC1=
001_NAME_LEN_WITH_NULL);
> =A0 =A0 =A0 =A0tcp_ses->session_estab =3D false;
> =A0 =A0 =A0 =A0tcp_ses->sequence_number =3D 0;
> + =A0 =A0 =A0 tcp_ses->lstrp =3D jiffies;
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
> =A0 =A0 =A0 =A0INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
