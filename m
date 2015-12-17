From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Make echo interval tunable.
Date: Thu, 17 Dec 2015 10:58:33 +0530
Message-ID: <1450330113.4353.2.camel@redhat.com>
References: <1450097226-20815-1-git-send-email-sprabhu@redhat.com>
	 <CAH2r5mu1xKmd+cg33ti7UtBWpj9XCt5SL0B=7QnV4LDxw-79vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mu1xKmd+cg33ti7UtBWpj9XCt5SL0B=7QnV4LDxw-79vw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2015-12-16 at 22:37 -0600, Steve French wrote:
> Why restrict the echo interval to such a narrow range?=C2=A0=C2=A0If =
tunable
> might as well allow a larger range, maybe 1 to 600 (ten minutes)?=C2=A0=
=C2=A0I
> am not certain of the range of possible future uses - maybe a
> pseudo-real type workload connected to a really fast server wants
> something really low (a few seconds?) and maybe very poor network
> connections want something longer?=C2=A0=C2=A0Not a strong objection,=
 but seems
> like we could allow a broader range without confusing the user.
>=20
> Many years ago, Windows and OS/2 had an oplock break time (which also
> controlled how long to wait for acks to come back from the server) -
> and it ranged from 34 to 127 seconds for acks and 35 to 640 for
> oplock
> break timeouts.=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Don't see any reason to =
limit it less than that
> (that was really old and networks vary a lot in performance now).
>=20
> Thoughts?

the numbers I chose were arbitrary. I have no objections to changing
the min and max values. Do you want me to send a new patch with those
values?

Sachin Prabhu

>=20
> On Mon, Dec 14, 2015 at 6:47 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
> > Currently the echo interval is set to 60 seconds using a macro.
> > This
> > setting determines the interval at which echo requests are sent to
> > the
> > server on an idling connection. This setting also affects the time
> > required for a connection to an unresponsive server to timeout.
> >=20
> > Making this setting a tunable allows users to control the echo
> > interval
> > times as well as control the time after which the connecting to an
> > unresponsive server times out.
> >=20
> > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/cifsfs.c=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A02 ++
> > =C2=A0fs/cifs/cifsglob.h |=C2=A0=C2=A08 ++++++--
> > =C2=A0fs/cifs/connect.c=C2=A0=C2=A0| 33 +++++++++++++++++++++++++++=
------
> > =C2=A03 files changed, 35 insertions(+), 8 deletions(-)
> >=20
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index cbc0f4b..eab2de6 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -507,6 +507,8 @@ cifs_show_options(struct seq_file *s, struct
> > dentry *root)
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0seq_printf(s, ",rsi=
ze=3D%u", cifs_sb->rsize);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0seq_printf(s, ",wsi=
ze=3D%u", cifs_sb->wsize);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0seq_printf(s, ",echo_int=
erval=3D%lu",
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
tcon->ses->server->echo_interval / HZ);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* convert actimeo =
and display it in seconds */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0seq_printf(s, ",act=
imeo=3D%lu", cifs_sb->actimeo / HZ);
> >=20
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index 2b510c5..56d3698 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -70,8 +70,10 @@
> > =C2=A0#define SERVER_NAME_LENGTH 40
> > =C2=A0#define SERVER_NAME_LEN_WITH_NULL=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
(SERVER_NAME_LENGTH + 1)
> >=20
> > -/* SMB echo "timeout" -- FIXME: tunable? */
> > -#define SMB_ECHO_INTERVAL (60 * HZ)
> > +/* echo interval in seconds */
> > +#define SMB_ECHO_INTERVAL_MIN 10
> > +#define SMB_ECHO_INTERVAL_MAX 120
> > +#define SMB_ECHO_INTERVAL_DEFAULT 60
> >=20
> > =C2=A0#include "cifspdu.h"
> >=20
> > @@ -507,6 +509,7 @@ struct smb_vol {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sockaddr_sto=
rage dstaddr; /* destination address */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sockaddr_sto=
rage srcaddr; /* allow binding to a
> > local IP */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct nls_table *l=
ocal_nls;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int echo_interv=
al; /* echo interval in secs */
> > =C2=A0};
> >=20
> > =C2=A0#define CIFS_MOUNT_MASK (CIFS_MOUNT_NO_PERM | CIFS_MOUNT_SET_=
UID |
> > \
> > @@ -628,6 +631,7 @@ struct TCP_Server_Info {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int=C2=A0=C2=
=A0=C2=A0=C2=A0max_read;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int=C2=A0=C2=
=A0=C2=A0=C2=A0max_write;
> > =C2=A0#endif /* CONFIG_CIFS_SMB2 */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned long echo_inter=
val;
> > =C2=A0};
> >=20
> > =C2=A0static inline unsigned int
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index ecb0803..3b44e9e 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -95,6 +95,7 @@ enum {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Opt_cruid, Opt_gid,=
 Opt_file_mode,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Opt_dirmode, Opt_po=
rt,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Opt_rsize, Opt_wsiz=
e, Opt_actimeo,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Opt_echo_interval,
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Mount options wh=
ich take string value */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Opt_user, Opt_pass,=
 Opt_ip,
> > @@ -188,6 +189,7 @@ static const match_table_t
> > cifs_mount_option_tokens =3D {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0{ Opt_rsize, "rsize=
=3D%s" },
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0{ Opt_wsize, "wsize=
=3D%s" },
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0{ Opt_actimeo, "act=
imeo=3D%s" },
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0{ Opt_echo_interval, "ec=
ho_interval=3D%s" },
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0{ Opt_blank_user, "=
user=3D" },
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0{ Opt_blank_user, "=
username=3D" },
> > @@ -418,6 +420,7 @@ cifs_echo_request(struct work_struct *work)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int rc;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct TCP_Server_I=
nfo *server =3D container_of(work,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0struct TCP_Server_Info,
> > echo.work);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned long echo_inter=
val =3D server->echo_interval;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0* We cannot s=
end an echo if it is disabled or until the
> > @@ -427,7 +430,7 @@ cifs_echo_request(struct work_struct *work)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*/
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!server->ops->n=
eed_neg || server->ops->need_neg(server)=20
> > ||
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0(server->ops->can_echo && !server->ops-
> > >can_echo(server)) ||
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
time_before(jiffies, server->lstrp + SMB_ECHO_INTERVAL
> > - HZ))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
time_before(jiffies, server->lstrp + echo_interval -
> > HZ))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0goto requeue_echo;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rc =3D server->ops-=
>echo ? server->ops->echo(server) :
> > -ENOSYS;
> > @@ -436,7 +439,7 @@ cifs_echo_request(struct work_struct *work)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0server->hostname);
> >=20
> > =C2=A0requeue_echo:
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0queue_delayed_work(cifsi=
od_wq, &server->echo,
> > SMB_ECHO_INTERVAL);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0queue_delayed_work(cifsi=
od_wq, &server->echo,
> > echo_interval);
> > =C2=A0}
> >=20
> > =C2=A0static bool
> > @@ -487,9 +490,9 @@ server_unresponsive(struct TCP_Server_Info
> > *server)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0a response in >60s.
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*/
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (server->tcpStat=
us =3D=3D CifsGood &&
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
time_after(jiffies, server->lstrp + 2 *
> > SMB_ECHO_INTERVAL)) {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0cifs_dbg(VFS, "Server %s has not responded in %=
d
> > seconds. Reconnecting...\n",
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0server->hostname, (2 * SMB_ECHO_INTERVAL)
> > / HZ);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
time_after(jiffies, server->lstrp + 2 * server-
> > >echo_interval)) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0cifs_dbg(VFS, "Server %s has not responded in %=
lu
> > seconds. Reconnecting...\n",
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0server->hostname, (2 * server-
> > >echo_interval) / HZ);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0cifs_reconnect(server);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0wake_up(&server->response_q);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return true;
> > @@ -1624,6 +1627,14 @@ cifs_parse_mount_options(const char
> > *mountdata, const char *devname,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0goto cifs_parse_moun=
t_err;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0}
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0break;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0case Opt_echo_interval:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
if (get_option_ul(args, &option)) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cifs_dbg(VFS, "%s: Inva=
lid echo
> > interval value\n",
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__func__);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0goto cifs_parse_mount_e=
rr;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
}
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
vol->echo_interval =3D option;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
break;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0/* String Arguments */
> >=20
> > @@ -2089,6 +2100,9 @@ static int match_server(struct
> > TCP_Server_Info *server, struct smb_vol *vol)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!match_security=
(server, vol))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> >=20
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (server->echo_interva=
l !=3D vol->echo_interval)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 1;
> > =C2=A0}
> >=20
> > @@ -2208,6 +2222,13 @@ cifs_get_tcp_session(struct smb_vol
> > *volume_info)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0tcp_ses->tcpStatus =
=3D CifsNew;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0++tcp_ses->srv_coun=
t;
> >=20
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* echo interval should =
be between 10 and 120 secs */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (volume_info->echo_in=
terval > SMB_ECHO_INTERVAL_MIN ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0volume_info->echo_interval < SMB_ECHO_INTERVAL_=
MAX)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0tcp_ses->echo_interval =3D volume_info->echo_in=
terval=20
> > * HZ;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0else
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0tcp_ses->echo_interval =3D SMB_ECHO_INTERVAL_DE=
=46AULT
> > * HZ;
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rc =3D ip_connect(t=
cp_ses);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (rc < 0) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0cifs_dbg(VFS, "Error connecting to socket. A=
borting
> > operation.\n");
> > @@ -2237,7 +2258,7 @@ cifs_get_tcp_session(struct smb_vol
> > *volume_info)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cifs_fscache_get_cl=
ient_cookie(tcp_ses);
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* queue echo reque=
st delayed work */
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0queue_delayed_work(cifsi=
od_wq, &tcp_ses->echo,
> > SMB_ECHO_INTERVAL);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0queue_delayed_work(cifsi=
od_wq, &tcp_ses->echo, tcp_ses-
> > >echo_interval);
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return tcp_ses;
> >=20
> > --
> > 2.4.3
> >=20
>=20
>=20
>=20
