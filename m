From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 04/11] CIFS: Delete echo_retries module parm
Date: Mon, 27 Feb 2012 17:39:46 -0600
Message-ID: <CAH2r5mtabJkqJ5AaW-f2pZX71+x5CZbfasiExC6s2jcbaMPf6g@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-5-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329895984-9251-5-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Having interesting conversations here about maxmpx, echo, blocking lock=
s etc.

To Samba apparently we should not be limiting these requests in flight
- they can go far beyond 50 with no problem (although for non-SMB2
case we should be checking for a few other things - like that opens
don't exceed 64K on cifs).

=46or blocking locks the story (according to Chris H.) is interesting,
but we can allow up to maxmpx (actually maxmpx minus one or two, for
oplock, and one other non-blocking command presumably) per pid-mid
pair (ie mids per process).   So we should be able to allow 48 (or 8,
ie two less than maxmpx, depending on server) simultaneous pending
blocking locks per process (per process/per connection) not per
connection.

On Wed, Feb 22, 2012 at 1:32 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
> It's the essential step before respecting MaxMpxCount value during
> negotiating because we will keep only one extra slot for sending
> echo requests. If there is no response for echo message - reconnect
> the tcp session.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/README =A0 =A0 | =A0 =A06 +-----
> =A0fs/cifs/cifsfs.c =A0 | =A0 =A05 -----
> =A0fs/cifs/cifsglob.h | =A0 =A03 ---
> =A0fs/cifs/connect.c =A0| =A0 =A07 +++----
> =A04 files changed, 4 insertions(+), 17 deletions(-)
>
> diff --git a/fs/cifs/README b/fs/cifs/README
> index 895da1d..b7d782b 100644
> --- a/fs/cifs/README
> +++ b/fs/cifs/README
> @@ -753,10 +753,6 @@ module loading or during the runtime by using th=
e interface
>
> =A0i.e. echo "value" > /sys/module/cifs/parameters/<param>
>
> -1. echo_retries - The number of echo attempts before giving up and
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 reconnecting to the server. The def=
ault is 5. The value 0
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 means never reconnect.
> -
> -2. enable_oplocks - Enable or disable oplocks. Oplocks are enabled b=
y default.
> +1. enable_oplocks - Enable or disable oplocks. Oplocks are enabled b=
y default.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0[Y/y/1]. To disable use any of=
 [N/n/0].
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index b1fd382..e1ce1ca 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -77,11 +77,6 @@ unsigned int cifs_max_pending =3D CIFS_MAX_REQ;
> =A0module_param(cifs_max_pending, int, 0444);
> =A0MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to serve=
r. "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "=
Default: 50 Range: 2 to 256");
> -unsigned short echo_retries =3D 5;
> -module_param(echo_retries, ushort, 0644);
> -MODULE_PARM_DESC(echo_retries, "Number of echo attempts before givin=
g up and "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"reconne=
cting server. Default: 5. 0 means "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"never r=
econnect.");
> =A0module_param(enable_oplocks, bool, 0644);
> =A0MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks (bool)=
=2E Default:"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "y/Y/=
1");
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 600d61c..674792e 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1049,9 +1049,6 @@ GLOBAL_EXTERN unsigned int cifs_min_rcv; =A0 =A0=
/* min size of big ntwrk buf pool */
> =A0GLOBAL_EXTERN unsigned int cifs_min_small; =A0/* min size of small=
 buf pool */
> =A0GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at on=
ce to server*/
>
> -/* reconnect after this many failed echo attempts */
> -GLOBAL_EXTERN unsigned short echo_retries;
> -
> =A0#ifdef CONFIG_CIFS_ACL
> =A0GLOBAL_EXTERN struct rb_root uidtree;
> =A0GLOBAL_EXTERN struct rb_root gidtree;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 673813f..86d7a40 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -373,12 +373,11 @@ allocate_buffers(struct TCP_Server_Info *server=
)
> =A0static bool
> =A0server_unresponsive(struct TCP_Server_Info *server)
> =A0{
> - =A0 =A0 =A0 if (echo_retries > 0 && server->tcpStatus =3D=3D CifsGo=
od &&
> - =A0 =A0 =A0 =A0 =A0 time_after(jiffies, server->lstrp +
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (echo_r=
etries * SMB_ECHO_INTERVAL))) {
> + =A0 =A0 =A0 if (server->tcpStatus =3D=3D CifsGood &&
> + =A0 =A0 =A0 =A0 =A0 time_after(jiffies, server->lstrp + SMB_ECHO_IN=
TERVAL)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Server %s has not responded=
 in %d seconds. "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Reconnecting...",=
 server->hostname,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (echo_retries * SMB=
_ECHO_INTERVAL / HZ));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SMB_ECHO_INTERVAL /=
 HZ);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_reconnect(server);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&server->response_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return true;
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
