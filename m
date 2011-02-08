From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: clarify the meaning of tcpStatus == CifsGood
Date: Tue, 8 Feb 2011 17:50:33 -0600
Message-ID: <AANLkTikiPgAbei+p2gnqOmuKdHnLpcYOshz7iqBotm1s@mail.gmail.com>
References: <1297086876-19165-1-git-send-email-jlayton@redhat.com>
	<1297086876-19165-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jg-9fI4heB6ewM@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1297086876-19165-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I discussed a simpler alternative with Jeff today.
maxBuf is set by SMB Negotiate Protocol, and when
reconnecting is reset to zero to indicate
that Negotiate Protocol needs to be done, so it
is a smaller patch to just check that
(we could eliminate the tcpStatus =3D=3D CifsGood check
as well, but it is harmless and as it was tested/works
I lean toward simply leaving that in, and adding
the most trivial change).  See below:

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 257b6d8..10011e9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -341,7 +341,7 @@ cifs_echo_request(struct work_struct *work)
 	 * We cannot send an echo until the NEGOTIATE_PROTOCOL request is don=
e.
 	 * Also, no need to ping if we got a response recently
 	 */
-	if (server->tcpStatus !=3D CifsGood ||
+	if ((server->tcpStatus !=3D CifsGood) || (server->maxBuf =3D=3D 0) ||
 	    time_before(jiffies, server->lstrp + SMB_ECHO_INTERVAL - HZ))
 		goto requeue_echo;

On Mon, Feb 7, 2011 at 7:54 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> When the TCP_Server_Info is first allocated and connected, tcpStatus =
=3D=3D
> CifsGood means that the NEGOTIATE_PROTOCOL request has completed and =
the
> socket is ready for other calls. cifs_reconnect however sets tcpStatu=
s
> to CifsGood as soon as the socket is reconnected and the optional
> RFC1001 session setup is done. We have no clear way to tell the
> difference between these two states, and we need to know this in orde=
r
> to know whether we can send an echo or not.
>
> Resolve this by adding a new statusEnum value -- CifsNeedNegotiate. W=
hen
> the socket has been connected but has not yet had a NEGOTIATE_PROTOCO=
L
> request done, set it to this value. Once the NEGOTIATE is done,
> cifs_negotiate_protocol will set tcpStatus to CifsGood.
>
> This also fixes and cleans the logic in cifs_reconnect and
> cifs_reconnect_tcon. The old code checked for specific states when wh=
at
> it really wants to know is whether the state has actually changed fro=
m
> CifsNeedReconnect.
>
> Reported-and-Tested-by: JG <jg-9fI4heB6ewM@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsglob.h | =A0 =A03 ++-
> =A0fs/cifs/cifssmb.c =A0| =A0 =A04 ++--
> =A0fs/cifs/connect.c =A0| =A0 =A08 ++++----
> =A03 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index edd5b29..5f333e0 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -92,7 +92,8 @@ enum statusEnum {
> =A0 =A0 =A0 =A0CifsNew =3D 0,
> =A0 =A0 =A0 =A0CifsGood,
> =A0 =A0 =A0 =A0CifsExiting,
> - =A0 =A0 =A0 CifsNeedReconnect
> + =A0 =A0 =A0 CifsNeedReconnect,
> + =A0 =A0 =A0 CifsNeedNegotiate
> =A0};
>
> =A0enum securityEnum {
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 904aa47..f4bd502 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -142,9 +142,9 @@ cifs_reconnect_tcon(struct cifsTconInfo *tcon, in=
t smb_command)
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0while (server->tcpStatus =3D=3D CifsNeedReconnect) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wait_event_interruptible_timeout(serve=
r->response_q,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (server->tcpStatus =3D=3D=
 CifsGood), 10 * HZ);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (server->tcpStatus !=3D=
 CifsNeedReconnect), 10 * HZ);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* is TCP session is reestablished now =
?*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* are we still trying to reconnect? */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (server->tcpStatus !=3D CifsNeedRec=
onnect)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 257b6d8..7deceae 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -199,8 +199,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
>
> - =A0 =A0 =A0 while ((server->tcpStatus !=3D CifsExiting) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0(server->tcpStatus !=3D CifsGood)) {
> + =A0 =A0 =A0 while (server->tcpStatus =3D=3D CifsNeedReconnect) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0try_to_freeze();
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* we should try only the port we conn=
ected to before */
> @@ -212,7 +211,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_inc(&tcpSesReco=
nnectCount);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&GlobalMid_L=
ock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (server->tcpStatus =
!=3D CifsExiting)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server-=
>tcpStatus =3D CifsGood;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server-=
>tcpStatus =3D CifsNeedNegotiate;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid=
_Lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> @@ -420,7 +419,7 @@ cifs_demultiplex_thread(struct TCP_Server_Info *s=
erver)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pdu_length =3D 4; /* enough to get RFC=
1001 header */
>
> =A0incomplete_rcv:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (echo_retries > 0 &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (echo_retries > 0 && server->tcpStat=
us =3D=3D CifsGood &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0time_after(jiffies, server->ls=
trp +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0(echo_retries * SMB_ECHO_INTERVAL))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Server %s h=
as not responded in %d seconds. "
> @@ -1732,6 +1731,7 @@ cifs_get_tcp_session(struct smb_vol *volume_inf=
o)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Error connecting to socket.=
 Aborting operation");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_err_crypto_release;
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 tcp_ses->tcpStatus =3D CifsNeedNegotiate;
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * since we're in a cifs function already, we know tha=
t
> --
> 1.7.4
>
>



--=20
Thanks,

Steve
