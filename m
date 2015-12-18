From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] [v3]cifs: Make echo interval tunable
Date: Fri, 18 Dec 2015 16:23:40 +0530
Message-ID: <1450436020.3168.2.camel@redhat.com>
References: <1450358873-32490-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450358873-32490-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2015-12-17 at 18:57 +0530, Sachin Prabhu wrote:
> Currently the echo interval is set to 60 seconds using a macro. This
> setting determines the interval at which echo requests are sent to
> the
> server on an idling connection. This setting also affects the time
> required for a connection to an unresponsive server to timeout.
>=20
> Making this setting a tunable allows users to control the echo
> interval
> times as well as control the time after which the connecting to an
> unresponsive server times out.
>=20
> v2: Change MIN and MAX timeout values
> v3: Remove incorrect comment in cifs_get_tcp_session
>=20
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Steve,

I found a bug in the if condition in cifs_get_tcp_session() . I had
fixed the bug in testing but forgot to pull back into my repo. I am re-
sending the patch with the fix.

Thanks
Sachin Prabhu

> ---
> =C2=A0fs/cifs/cifsfs.c=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A02 ++
> =C2=A0fs/cifs/cifsglob.h |=C2=A0=C2=A08 ++++++--
> =C2=A0fs/cifs/connect.c=C2=A0=C2=A0| 32 ++++++++++++++++++++++++++---=
---
> =C2=A03 files changed, 34 insertions(+), 8 deletions(-)
>=20
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index cbc0f4b..eab2de6 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -507,6 +507,8 @@ cifs_show_options(struct seq_file *s, struct
> dentry *root)
> =C2=A0
> =C2=A0	seq_printf(s, ",rsize=3D%u", cifs_sb->rsize);
> =C2=A0	seq_printf(s, ",wsize=3D%u", cifs_sb->wsize);
> +	seq_printf(s, ",echo_interval=3D%lu",
> +			tcon->ses->server->echo_interval / HZ);
> =C2=A0	/* convert actimeo and display it in seconds */
> =C2=A0	seq_printf(s, ",actimeo=3D%lu", cifs_sb->actimeo / HZ);
> =C2=A0
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 2b510c5..9d14926 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -70,8 +70,10 @@
> =C2=A0#define SERVER_NAME_LENGTH 40
> =C2=A0#define SERVER_NAME_LEN_WITH_NULL=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
(SERVER_NAME_LENGTH + 1)
> =C2=A0
> -/* SMB echo "timeout" -- FIXME: tunable? */
> -#define SMB_ECHO_INTERVAL (60 * HZ)
> +/* echo interval in seconds */
> +#define SMB_ECHO_INTERVAL_MIN 1
> +#define SMB_ECHO_INTERVAL_MAX 600
> +#define SMB_ECHO_INTERVAL_DEFAULT 60
> =C2=A0
> =C2=A0#include "cifspdu.h"
> =C2=A0
> @@ -507,6 +509,7 @@ struct smb_vol {
> =C2=A0	struct sockaddr_storage dstaddr; /* destination address */
> =C2=A0	struct sockaddr_storage srcaddr; /* allow binding to a local
> IP */
> =C2=A0	struct nls_table *local_nls;
> +	unsigned int echo_interval; /* echo interval in secs */
> =C2=A0};
> =C2=A0
> =C2=A0#define CIFS_MOUNT_MASK (CIFS_MOUNT_NO_PERM | CIFS_MOUNT_SET_UI=
D | \
> @@ -628,6 +631,7 @@ struct TCP_Server_Info {
> =C2=A0	unsigned int	max_read;
> =C2=A0	unsigned int	max_write;
> =C2=A0#endif /* CONFIG_CIFS_SMB2 */
> +	unsigned long echo_interval;
> =C2=A0};
> =C2=A0
> =C2=A0static inline unsigned int
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index ecb0803..dc405db 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -95,6 +95,7 @@ enum {
> =C2=A0	Opt_cruid, Opt_gid, Opt_file_mode,
> =C2=A0	Opt_dirmode, Opt_port,
> =C2=A0	Opt_rsize, Opt_wsize, Opt_actimeo,
> +	Opt_echo_interval,
> =C2=A0
> =C2=A0	/* Mount options which take string value */
> =C2=A0	Opt_user, Opt_pass, Opt_ip,
> @@ -188,6 +189,7 @@ static const match_table_t
> cifs_mount_option_tokens =3D {
> =C2=A0	{ Opt_rsize, "rsize=3D%s" },
> =C2=A0	{ Opt_wsize, "wsize=3D%s" },
> =C2=A0	{ Opt_actimeo, "actimeo=3D%s" },
> +	{ Opt_echo_interval, "echo_interval=3D%s" },
> =C2=A0
> =C2=A0	{ Opt_blank_user, "user=3D" },
> =C2=A0	{ Opt_blank_user, "username=3D" },
> @@ -418,6 +420,7 @@ cifs_echo_request(struct work_struct *work)
> =C2=A0	int rc;
> =C2=A0	struct TCP_Server_Info *server =3D container_of(work,
> =C2=A0					struct TCP_Server_Info,
> echo.work);
> +	unsigned long echo_interval =3D server->echo_interval;
> =C2=A0
> =C2=A0	/*
> =C2=A0	=C2=A0* We cannot send an echo if it is disabled or until the
> @@ -427,7 +430,7 @@ cifs_echo_request(struct work_struct *work)
> =C2=A0	=C2=A0*/
> =C2=A0	if (!server->ops->need_neg || server->ops->need_neg(server)
> ||
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0(server->ops->can_echo && !server->ops=
-
> >can_echo(server)) ||
> -	=C2=A0=C2=A0=C2=A0=C2=A0time_before(jiffies, server->lstrp + SMB_EC=
HO_INTERVAL -
> HZ))
> +	=C2=A0=C2=A0=C2=A0=C2=A0time_before(jiffies, server->lstrp + echo_i=
nterval -
> HZ))
> =C2=A0		goto requeue_echo;
> =C2=A0
> =C2=A0	rc =3D server->ops->echo ? server->ops->echo(server) :
> -ENOSYS;
> @@ -436,7 +439,7 @@ cifs_echo_request(struct work_struct *work)
> =C2=A0			=C2=A0server->hostname);
> =C2=A0
> =C2=A0requeue_echo:
> -	queue_delayed_work(cifsiod_wq, &server->echo,
> SMB_ECHO_INTERVAL);
> +	queue_delayed_work(cifsiod_wq, &server->echo,
> echo_interval);
> =C2=A0}
> =C2=A0
> =C2=A0static bool
> @@ -487,9 +490,9 @@ server_unresponsive(struct TCP_Server_Info
> *server)
> =C2=A0	=C2=A0*=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0a response in >60s.
> =C2=A0	=C2=A0*/
> =C2=A0	if (server->tcpStatus =3D=3D CifsGood &&
> -	=C2=A0=C2=A0=C2=A0=C2=A0time_after(jiffies, server->lstrp + 2 *
> SMB_ECHO_INTERVAL)) {
> -		cifs_dbg(VFS, "Server %s has not responded in %d
> seconds. Reconnecting...\n",
> -			=C2=A0server->hostname, (2 * SMB_ECHO_INTERVAL) /
> HZ);
> +	=C2=A0=C2=A0=C2=A0=C2=A0time_after(jiffies, server->lstrp + 2 * ser=
ver-
> >echo_interval)) {
> +		cifs_dbg(VFS, "Server %s has not responded in %lu
> seconds. Reconnecting...\n",
> +			=C2=A0server->hostname, (2 * server-
> >echo_interval) / HZ);
> =C2=A0		cifs_reconnect(server);
> =C2=A0		wake_up(&server->response_q);
> =C2=A0		return true;
> @@ -1624,6 +1627,14 @@ cifs_parse_mount_options(const char
> *mountdata, const char *devname,
> =C2=A0				goto cifs_parse_mount_err;
> =C2=A0			}
> =C2=A0			break;
> +		case Opt_echo_interval:
> +			if (get_option_ul(args, &option)) {
> +				cifs_dbg(VFS, "%s: Invalid echo
> interval value\n",
> +					=C2=A0__func__);
> +				goto cifs_parse_mount_err;
> +			}
> +			vol->echo_interval =3D option;
> +			break;
> =C2=A0
> =C2=A0		/* String Arguments */
> =C2=A0
> @@ -2089,6 +2100,9 @@ static int match_server(struct TCP_Server_Info
> *server, struct smb_vol *vol)
> =C2=A0	if (!match_security(server, vol))
> =C2=A0		return 0;
> =C2=A0
> +	if (server->echo_interval !=3D vol->echo_interval)
> +		return 0;
> +
> =C2=A0	return 1;
> =C2=A0}
> =C2=A0
> @@ -2208,6 +2222,12 @@ cifs_get_tcp_session(struct smb_vol
> *volume_info)
> =C2=A0	tcp_ses->tcpStatus =3D CifsNew;
> =C2=A0	++tcp_ses->srv_count;
> =C2=A0
> +	if (volume_info->echo_interval > SMB_ECHO_INTERVAL_MIN ||
> +		volume_info->echo_interval < SMB_ECHO_INTERVAL_MAX)
> +		tcp_ses->echo_interval =3D volume_info->echo_interval
> * HZ;
> +	else
> +		tcp_ses->echo_interval =3D SMB_ECHO_INTERVAL_DEFAULT *
> HZ;
> +
> =C2=A0	rc =3D ip_connect(tcp_ses);
> =C2=A0	if (rc < 0) {
> =C2=A0		cifs_dbg(VFS, "Error connecting to socket. Aborting
> operation.\n");
> @@ -2237,7 +2257,7 @@ cifs_get_tcp_session(struct smb_vol
> *volume_info)
> =C2=A0	cifs_fscache_get_client_cookie(tcp_ses);
> =C2=A0
> =C2=A0	/* queue echo request delayed work */
> -	queue_delayed_work(cifsiod_wq, &tcp_ses->echo,
> SMB_ECHO_INTERVAL);
> +	queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses-
> >echo_interval);
> =C2=A0
> =C2=A0	return tcp_ses;
> =C2=A0
