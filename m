From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 11/13] cifs: set up recurring workqueue job to do SMB echo requests
Date: Tue, 14 Dec 2010 09:57:06 +0300
Message-ID: <AANLkTimU0Qbd4+_G99-K6c9mjh4ik2VqnVs=ysMt2HSs@mail.gmail.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-12-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291995877-2276-12-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/10 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsglob.h | =A0 =A01 +
> =A0fs/cifs/connect.c =A0| =A0 29 +++++++++++++++++++++++++++++
> =A02 files changed, 30 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index fb75f04..d924f3c 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -221,6 +221,7 @@ struct TCP_Server_Info {
> =A0 =A0 =A0 =A0bool =A0 =A0sec_kerberosu2u; =A0 =A0 =A0 =A0/* support=
s U2U Kerberos */
> =A0 =A0 =A0 =A0bool =A0 =A0sec_ntlmssp; =A0 =A0 =A0 =A0 =A0 =A0/* sup=
ports NTLMSSP */
> =A0 =A0 =A0 =A0bool session_estab; /* mark when very first sess is es=
tablished */
> + =A0 =A0 =A0 struct delayed_work =A0 =A0 echo; /* echo ping workqueu=
e job */
> =A0#ifdef CONFIG_CIFS_FSCACHE
> =A0 =A0 =A0 =A0struct fscache_cookie =A0 *fscache; /* client index ca=
che cookie */
> =A0#endif
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 0feb592..98e1d38 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -52,6 +52,9 @@
> =A0#define CIFS_PORT 445
> =A0#define RFC1001_PORT 139
>
> +/* SMB echo "timeout" -- FIXME: tunable? */
> +#define SMB_ECHO_INTERVAL (30 * HZ)
> +
> =A0extern void SMBNTencrypt(unsigned char *passwd, unsigned char *c8,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned char *p24);
>
> @@ -354,6 +357,26 @@ static int coalesce_t2(struct smb_hdr *psecond, =
struct smb_hdr *pTargetSMB)
>
> =A0}
>
> +static void
> +cifs_echo_request(struct work_struct *work)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 struct TCP_Server_Info *server =3D container_of(work,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct TCP_Server_Info, echo.work);
> +
> + =A0 =A0 =A0 /* no need to ping if we got a response recently */
> + =A0 =A0 =A0 if (time_before(jiffies, server->lstrp + SMB_ECHO_INTER=
VAL - HZ))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto requeue_echo;
> +
> + =A0 =A0 =A0 rc =3D CIFSSMBEcho(server);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Unable to send echo request to=
 server: %s",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->hostname);
> +
> +requeue_echo:
> + =A0 =A0 =A0 queue_delayed_work(system_nrt_wq, &server->echo, SMB_EC=
HO_INTERVAL);
> +}
> +
> =A0static int
> =A0cifs_demultiplex_thread(struct TCP_Server_Info *server)
> =A0{
> @@ -1610,6 +1633,8 @@ cifs_put_tcp_session(struct TCP_Server_Info *se=
rver)
> =A0 =A0 =A0 =A0list_del_init(&server->tcp_ses_list);
> =A0 =A0 =A0 =A0spin_unlock(&cifs_tcp_ses_lock);
>
> + =A0 =A0 =A0 cancel_delayed_work_sync(&server->echo);
> +
> =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0server->tcpStatus =3D CifsExiting;
> =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
> @@ -1701,6 +1726,7 @@ cifs_get_tcp_session(struct smb_vol *volume_inf=
o)
> =A0 =A0 =A0 =A0tcp_ses->sequence_number =3D 0;
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
> + =A0 =A0 =A0 INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * at this point we are the only ones with the pointer
> @@ -1750,6 +1776,9 @@ cifs_get_tcp_session(struct smb_vol *volume_inf=
o)
>
> =A0 =A0 =A0 =A0cifs_fscache_get_client_cookie(tcp_ses);
>
> + =A0 =A0 =A0 /* queue echo request delayed work */
> + =A0 =A0 =A0 queue_delayed_work(system_nrt_wq, &tcp_ses->echo, SMB_E=
CHO_INTERVAL);
> +
> =A0 =A0 =A0 =A0return tcp_ses;
>
> =A0out_err_crypto_release:
> --
> 1.7.3.2
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
