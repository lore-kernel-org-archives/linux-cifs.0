From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 12/13] cifs: reconnect unresponsive servers
Date: Tue, 14 Dec 2010 09:57:51 +0300
Message-ID: <AANLkTinFnqueDfCKiKKVH8FxLFuhJJkCPcLLdCPf5HxV@mail.gmail.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-13-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291995877-2276-13-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/10 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> If the server isn't responding to echoes, we don't want to leave task=
s
> hung waiting for it to reply. At that point, we'll want to reconnect
> so that soft mounts can return an error to userspace quickly.
>
> If the client hasn't received a reply after 3 echo intervals, assume
> that the transport is down and attempt to reconnect the socket.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 23 +++++++++++++++++++----
> =A01 files changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 98e1d38..c596515 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -55,6 +55,9 @@
> =A0/* SMB echo "timeout" -- FIXME: tunable? */
> =A0#define SMB_ECHO_INTERVAL (30 * HZ)
>
> +/* reconnect if no response from server in this time period */
> +#define UNRESPONSIVE_SERVER_TIMEOUT (3 * SMB_ECHO_INTERVAL)
> +
> =A0extern void SMBNTencrypt(unsigned char *passwd, unsigned char *c8,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned char *p24);
>
> @@ -187,6 +190,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0kfree(server->session_key.response);
> =A0 =A0 =A0 =A0server->session_key.response =3D NULL;
> =A0 =A0 =A0 =A0server->session_key.len =3D 0;
> + =A0 =A0 =A0 server->lstrp =3D jiffies;
> =A0 =A0 =A0 =A0mutex_unlock(&server->srv_mutex);
>
> =A0 =A0 =A0 =A0/*
> @@ -442,7 +446,19 @@ cifs_demultiplex_thread(struct TCP_Server_Info *=
server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smb_msg.msg_control =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smb_msg.msg_controllen =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pdu_length =3D 4; /* enough to get RFC=
1001 header */
> +
> =A0incomplete_rcv:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (time_after(jiffies,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->=
lstrp + UNRESPONSIVE_SERVER_TIMEOUT)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Server %s ha=
s not responded in %d seconds. "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Re=
connecting...", server->hostname,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UNR=
ESPONSIVE_SERVER_TIMEOUT / HZ);
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
> @@ -603,6 +619,8 @@ incomplete_rcv:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->lstrp =3D jiffies;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_for_each(tmp, &server->pending_mi=
d_q) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry =3D list_ent=
ry(tmp, struct mid_q_entry, qhead);
> @@ -653,10 +671,6 @@ multi_t2_fnd:
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
> =A0next_mid:
> @@ -1724,6 +1738,7 @@ cifs_get_tcp_session(struct smb_vol *volume_inf=
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
> 1.7.3.2

Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
