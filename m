From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Make echo interval tunable.
Date: Tue, 15 Dec 2015 15:51:54 +0530
Message-ID: <1450174914.4930.14.camel@redhat.com>
References: <1450097226-20815-1-git-send-email-sprabhu@redhat.com>
	 <1450097641.6822.6.camel@redhat.com>
	 <CADT32e+AtzJ5f5bOKKVz=uTonHvNMs=DJmNTnohy_Yi5HK=R7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+AtzJ5f5bOKKVz=uTonHvNMs=DJmNTnohy_Yi5HK=R7A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2015-12-14 at 21:58 -0600, Shirish Pargaonkar wrote:
> Looks correct. Only comment would be to keep one definition of
> echo_interval,
> preferably unsigned int (instead of unsigned long also).

Sirish,

The event_timeout defined in struct smb_vol contains the timeout value
in seconds while the one defined in struct=C2=A0TCP_Server_Info multipl=
ies
the value from the smb_vol by HZ to get the time in ticks.

Sachin Prabhu

>=20
> On Mon, Dec 14, 2015 at 6:54 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
> > Another approach as pointed to by Jeff Layton is to make it a
> > module
> > parameter which is then set for all shares mounted on the client.
> >=20
> > Any comments on the patch are welcome.
> >=20
> > Sachin Prabhu
> >=20
> > On Mon, 2015-12-14 at 18:17 +0530, Sachin Prabhu wrote:
> > > Currently the echo interval is set to 60 seconds using a macro.
> > > This
> > > setting determines the interval at which echo requests are sent
> > > to
> > > the
> > > server on an idling connection. This setting also affects the
> > > time
> > > required for a connection to an unresponsive server to timeout.
> > >=20
> > > Making this setting a tunable allows users to control the echo
> > > interval
> > > times as well as control the time after which the connecting to
> > > an
> > > unresponsive server times out.
> > >=20
> > > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > ---
> > > =C2=A0fs/cifs/cifsfs.c=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A02 ++
> > > =C2=A0fs/cifs/cifsglob.h |=C2=A0=C2=A08 ++++++--
> > > =C2=A0fs/cifs/connect.c=C2=A0=C2=A0| 33 +++++++++++++++++++++++++=
++------
> > > =C2=A03 files changed, 35 insertions(+), 8 deletions(-)
> > >=20
> > > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > > index cbc0f4b..eab2de6 100644
> > > --- a/fs/cifs/cifsfs.c
> > > +++ b/fs/cifs/cifsfs.c
> > > @@ -507,6 +507,8 @@ cifs_show_options(struct seq_file *s, struct
> > > dentry *root)
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0seq_printf(s, ",rsize=3D%u", =
cifs_sb->rsize);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0seq_printf(s, ",wsize=3D%u", =
cifs_sb->wsize);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0seq_printf(s, ",echo_interval=3D%l=
u",
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0tcon->ses->=
server->echo_interval / HZ);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* convert actimeo and displa=
y it in seconds */
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0seq_printf(s, ",actimeo=3D%lu=
", cifs_sb->actimeo / HZ);
> > >=20
> > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > > index 2b510c5..56d3698 100644
> > > --- a/fs/cifs/cifsglob.h
> > > +++ b/fs/cifs/cifsglob.h
> > > @@ -70,8 +70,10 @@
> > > =C2=A0#define SERVER_NAME_LENGTH 40
> > > =C2=A0#define SERVER_NAME_LEN_WITH_NULL=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0(SERVER_NAME_LENGTH + 1)
> > >=20
> > > -/* SMB echo "timeout" -- FIXME: tunable? */
> > > -#define SMB_ECHO_INTERVAL (60 * HZ)
> > > +/* echo interval in seconds */
> > > +#define SMB_ECHO_INTERVAL_MIN 10
> > > +#define SMB_ECHO_INTERVAL_MAX 120
> > > +#define SMB_ECHO_INTERVAL_DEFAULT 60
> > >=20
> > > =C2=A0#include "cifspdu.h"
> > >=20
> > > @@ -507,6 +509,7 @@ struct smb_vol {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sockaddr_storage dstad=
dr; /* destination address */
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sockaddr_storage srcad=
dr; /* allow binding to a
> > > local
> > > IP */
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct nls_table *local_nls;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int echo_interval; /* ech=
o interval in secs */
> > > =C2=A0};
> > >=20
> > > =C2=A0#define CIFS_MOUNT_MASK (CIFS_MOUNT_NO_PERM | CIFS_MOUNT_SE=
T_UID
> > > | \
> > > @@ -628,6 +631,7 @@ struct TCP_Server_Info {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int=C2=A0=C2=A0=C2=A0=
=C2=A0max_read;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int=C2=A0=C2=A0=C2=A0=
=C2=A0max_write;
> > > =C2=A0#endif /* CONFIG_CIFS_SMB2 */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned long echo_interval;
> > > =C2=A0};
> > >=20
> > > =C2=A0static inline unsigned int
> > > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > > index ecb0803..3b44e9e 100644
> > > --- a/fs/cifs/connect.c
> > > +++ b/fs/cifs/connect.c
> > > @@ -95,6 +95,7 @@ enum {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Opt_cruid, Opt_gid, Opt_file_=
mode,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Opt_dirmode, Opt_port,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Opt_rsize, Opt_wsize, Opt_act=
imeo,
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Opt_echo_interval,
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Mount options which take s=
tring value */
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Opt_user, Opt_pass, Opt_ip,
> > > @@ -188,6 +189,7 @@ static const match_table_t
> > > cifs_mount_option_tokens =3D {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0{ Opt_rsize, "rsize=3D%s" },
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0{ Opt_wsize, "wsize=3D%s" },
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0{ Opt_actimeo, "actimeo=3D%s"=
 },
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0{ Opt_echo_interval, "echo_interva=
l=3D%s" },
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0{ Opt_blank_user, "user=3D" }=
,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0{ Opt_blank_user, "username=3D=
" },
> > > @@ -418,6 +420,7 @@ cifs_echo_request(struct work_struct *work)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int rc;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct TCP_Server_Info *serve=
r =3D container_of(work,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0struct TCP_Server_Info,
> > > echo.work);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned long echo_interval =3D se=
rver->echo_interval;
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* We cannot send an ech=
o if it is disabled or until the
> > > @@ -427,7 +430,7 @@ cifs_echo_request(struct work_struct *work)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*/
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!server->ops->need_neg ||=
 server->ops->need_neg(server)
> > > > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(serv=
er->ops->can_echo && !server->ops
> > > ->can_echo(server)) ||
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0time_befor=
e(jiffies, server->lstrp + SMB_ECHO_INTERVAL
> > > -
> > > HZ))
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0time_befor=
e(jiffies, server->lstrp + echo_interval -
> > > HZ))
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0goto requeue_echo;
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rc =3D server->ops->echo ? se=
rver->ops->echo(server) :
> > > -ENOSYS;
> > > @@ -436,7 +439,7 @@ cifs_echo_request(struct work_struct *work)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
server->hostname);
> > >=20
> > > =C2=A0requeue_echo:
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0queue_delayed_work(cifsiod_wq, &se=
rver->echo,
> > > SMB_ECHO_INTERVAL);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0queue_delayed_work(cifsiod_wq, &se=
rver->echo,
> > > echo_interval);
> > > =C2=A0}
> > >=20
> > > =C2=A0static bool
> > > @@ -487,9 +490,9 @@ server_unresponsive(struct TCP_Server_Info
> > > *server)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0a response in >60s.
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*/
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (server->tcpStatus =3D=3D =
CifsGood &&
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0time_after=
(jiffies, server->lstrp + 2 *
> > > SMB_ECHO_INTERVAL)) {
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0cifs_dbg(VFS, "Server %s has not responded in %d
> > > seconds. Reconnecting...\n",
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0serve=
r->hostname, (2 * SMB_ECHO_INTERVAL)
> > > /
> > > HZ);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0time_after=
(jiffies, server->lstrp + 2 * server
> > > ->echo_interval)) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0cifs_dbg(VFS, "Server %s has not responded in %lu
> > > seconds. Reconnecting...\n",
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0serve=
r->hostname, (2 * server
> > > ->echo_interval) / HZ);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0cifs_reconnect(server);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0wake_up(&server->response_q);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return true;
> > > @@ -1624,6 +1627,14 @@ cifs_parse_mount_options(const char
> > > *mountdata, const char *devname,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0goto cifs_parse_mount_err;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0break=
;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0case Opt_echo_interval:
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (get_opt=
ion_ul(args, &option)) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cifs_dbg(VFS, "%s: Invalid echo
> > > interval value\n",
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0__func__);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0goto cifs_parse_mount_err;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vol->echo_i=
nterval =3D option;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0break;
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0/* String Arguments */
> > >=20
> > > @@ -2089,6 +2100,9 @@ static int match_server(struct
> > > TCP_Server_Info
> > > *server, struct smb_vol *vol)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!match_security(server, v=
ol))
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return 0;
> > >=20
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (server->echo_interval !=3D vol=
->echo_interval)
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0return 0;
> > > +
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 1;
> > > =C2=A0}
> > >=20
> > > @@ -2208,6 +2222,13 @@ cifs_get_tcp_session(struct smb_vol
> > > *volume_info)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0tcp_ses->tcpStatus =3D CifsNe=
w;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0++tcp_ses->srv_count;
> > >=20
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* echo interval should be between=
 10 and 120 secs */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (volume_info->echo_interval > S=
MB_ECHO_INTERVAL_MIN ||
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0volume_info->echo_interval < SMB_ECHO_INTERVAL_MAX)
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0tcp_ses->echo_interval =3D volume_info->echo_interval
> > > * HZ;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0else
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0tcp_ses->echo_interval =3D SMB_ECHO_INTERVAL_DEFAULT
> > > *
> > > HZ;
> > > +
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rc =3D ip_connect(tcp_ses);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (rc < 0) {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0cifs_dbg(VFS, "Error connecting to socket. Aborting
> > > operation.\n");
> > > @@ -2237,7 +2258,7 @@ cifs_get_tcp_session(struct smb_vol
> > > *volume_info)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cifs_fscache_get_client_cooki=
e(tcp_ses);
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* queue echo request delayed=
 work */
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0queue_delayed_work(cifsiod_wq, &tc=
p_ses->echo,
> > > SMB_ECHO_INTERVAL);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0queue_delayed_work(cifsiod_wq, &tc=
p_ses->echo, tcp_ses
> > > ->echo_interval);
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return tcp_ses;
> > >=20
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > cifs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-=
info.html
