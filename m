From: Steve French <smfrench@gmail.com>
Subject: Re: [cifs bindaddr v5] cifs: Allow binding to local IP address.
Date: Mon, 20 Sep 2010 12:44:27 -0500
Message-ID: <AANLkTimM6CfB8JU0piS74ZMacn8WGVOrcpsWf3OVn7K6@mail.gmail.com>
References: <1283385962-10539-1-git-send-email-greearb@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Ben Greear <greearb@candelatech.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1283385962-10539-1-git-send-email-greearb@candelatech.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Ben,
Dr. Holder took a look at this and acked it.
This does help the problem of choosing
wired vs. wireless for mounts to specific servers
(where the default route would be wrong as happened
to me last week) and also there are some IPv6
cases it helps with.

If nfs guys require a different name for the mount
option etc. - let me know.

On Wed, Sep 1, 2010 at 7:06 PM, Ben Greear <greearb@candelatech.com> wr=
ote:
> When using multi-homed machines, it's nice to be able to specify
> the local IP to use for outbound connections. =A0This patch gives
> cifs the ability to bind to a particular IP address.
>
> =A0 Usage: =A0mount -t cifs -o srcaddr=3D192.168.1.50,user=3Dfoo, ...
> =A0 Usage: =A0mount -t cifs -o srcaddr=3D2002::100:1,user=3Dfoo, ...
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 b7431af... 1b6ddd6... M =A0fs/cifs/cifsfs.c
> :100644 100644 c9d0cfc... 784fd4a... M =A0fs/cifs/cifsglob.h
> :100644 100644 ec0ea4a... d3a36b4... M =A0fs/cifs/connect.c
> =A0fs/cifs/cifsfs.c =A0 | =A0 19 +++++++++++
> =A0fs/cifs/cifsglob.h | =A0 =A01 +
> =A0fs/cifs/connect.c =A0| =A0 90 ++++++++++++++++++++++++++++++++++++=
++++++++++++++-
> =A03 files changed, 108 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index b7431af..1b6ddd6 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -36,6 +36,7 @@
> =A0#include <linux/kthread.h>
> =A0#include <linux/freezer.h>
> =A0#include <linux/smp_lock.h>
> +#include <net/ipv6.h>
> =A0#include "cifsfs.h"
> =A0#include "cifspdu.h"
> =A0#define DECLARE_GLOBALS_HERE
> @@ -367,6 +368,8 @@ cifs_show_options(struct seq_file *s, struct vfsm=
ount *m)
> =A0{
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb =3D CIFS_SB(m->mnt_sb);
> =A0 =A0 =A0 =A0struct cifsTconInfo *tcon =3D cifs_sb->tcon;
> + =A0 =A0 =A0 struct sockaddr *srcaddr;
> + =A0 =A0 =A0 srcaddr =3D (struct sockaddr *)&tcon->ses->server->srca=
ddr;
>
> =A0 =A0 =A0 =A0seq_printf(s, ",unc=3D%s", tcon->treeName);
> =A0 =A0 =A0 =A0if (tcon->ses->userName)
> @@ -374,6 +377,22 @@ cifs_show_options(struct seq_file *s, struct vfs=
mount *m)
> =A0 =A0 =A0 =A0if (tcon->ses->domainName)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",domain=3D%s", tcon->se=
s->domainName);
>
> + =A0 =A0 =A0 if (srcaddr->sa_family !=3D AF_UNSPEC) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct sockaddr_in *saddr4;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct sockaddr_in6 *saddr6;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 saddr4 =3D (struct sockaddr_in *)srcadd=
r;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 saddr6 =3D (struct sockaddr_in6 *)srcad=
dr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (srcaddr->sa_family =3D=3D AF_INET6)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",srcaddr=
=3D%pI6c",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
&saddr6->sin6_addr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (srcaddr->sa_family =3D=3D AF_I=
NET)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",srcaddr=
=3D%pI4",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
&saddr4->sin_addr.s_addr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",srcaddr=
=3DBAD-AF:%i",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
(int)(srcaddr->sa_family));
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0seq_printf(s, ",uid=3D%d", cifs_sb->mnt_uid);
> =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",forceuid");
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index c9d0cfc..784fd4a 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -157,6 +157,7 @@ struct TCP_Server_Info {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct sockaddr_in sockAddr;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct sockaddr_in6 sockAddr6;
> =A0 =A0 =A0 =A0} addr;
> + =A0 =A0 =A0 struct sockaddr_storage srcaddr; /* locally bind to thi=
s IP */
> =A0 =A0 =A0 =A0wait_queue_head_t response_q;
> =A0 =A0 =A0 =A0wait_queue_head_t request_q; /* if more than maxmpx to=
 srvr must block*/
> =A0 =A0 =A0 =A0struct list_head pending_mid_q;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index ec0ea4a..d3a36b4 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -105,6 +105,7 @@ struct smb_vol {
> =A0 =A0 =A0 =A0bool sockopt_tcp_nodelay:1;
> =A0 =A0 =A0 =A0unsigned short int port;
> =A0 =A0 =A0 =A0char *prepath;
> + =A0 =A0 =A0 struct sockaddr_storage srcaddr; /* allow binding to a =
local IP */
> =A0 =A0 =A0 =A0struct nls_table *local_nls;
> =A0};
>
> @@ -1064,6 +1065,22 @@ cifs_parse_mount_options(char *options, const =
char *devname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"long\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "srcaddr", 7)=
 =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->srcaddr.ss_family =
=3D AF_UNSPEC;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!value || !*value) =
{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(=
KERN_WARNING "CIFS: srcaddr value"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0" not specified.\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
1; =A0 =A0 =A0 /* needs_arg; */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i =3D cifs_convert_addr=
ess((struct sockaddr *)&vol->srcaddr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0value, strlen(value));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (i < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(=
KERN_WARNING "CIFS: =A0Could not parse"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0" srcaddr: %s\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0value);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (strnicmp(data, "prefixpath"=
, 10) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!value || !*value)=
 {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk=
(KERN_WARNING
> @@ -1392,8 +1409,36 @@ cifs_parse_mount_options(char *options, const =
char *devname,
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> +/** Returns true if srcaddr isn't specified and rhs isn't
> + * specified, or if srcaddr is specified and
> + * matches the IP address of the rhs argument.
> + */
> +static bool
> +srcip_matches(struct sockaddr *srcaddr, struct sockaddr *rhs)
> +{
> + =A0 =A0 =A0 switch (srcaddr->sa_family) {
> + =A0 =A0 =A0 case AF_UNSPEC:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return (rhs->sa_family =3D=3D AF_UNSPEC=
);
> + =A0 =A0 =A0 case AF_INET: {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct sockaddr_in *saddr4 =3D (struct =
sockaddr_in *)srcaddr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct sockaddr_in *vaddr4 =3D (struct =
sockaddr_in *)rhs;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return (saddr4->sin_addr.s_addr =3D=3D =
vaddr4->sin_addr.s_addr);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 case AF_INET6: {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct sockaddr_in6 *saddr6 =3D (struct=
 sockaddr_in6 *)srcaddr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct sockaddr_in6 *vaddr6 =3D (struct=
 sockaddr_in6 *)&rhs;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ipv6_addr_equal(&saddr6->sin6_ad=
dr, &vaddr6->sin6_addr);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false; /* don't expect to be her=
e */
> + =A0 =A0 =A0 }
> +}
> +
> +
> =A0static bool
> -match_address(struct TCP_Server_Info *server, struct sockaddr *addr)
> +match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
> + =A0 =A0 =A0 =A0 =A0 =A0 struct sockaddr *srcaddr)
> =A0{
> =A0 =A0 =A0 =A0struct sockaddr_in *addr4 =3D (struct sockaddr_in *)ad=
dr;
> =A0 =A0 =A0 =A0struct sockaddr_in6 *addr6 =3D (struct sockaddr_in6 *)=
addr;
> @@ -1420,6 +1465,9 @@ match_address(struct TCP_Server_Info *server, s=
truct sockaddr *addr)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 if (!srcip_matches(srcaddr, (struct sockaddr *)&server-=
>srcaddr))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
> +
> =A0 =A0 =A0 =A0return true;
> =A0}
>
> @@ -1487,7 +1535,8 @@ cifs_find_tcp_session(struct sockaddr *addr, st=
ruct smb_vol *vol)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (server->tcpStatus =3D=3D CifsNew)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!match_address(server, addr))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!match_address(server, addr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
(struct sockaddr *)&vol->srcaddr))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!match_security(server, vol))
> @@ -1602,6 +1651,8 @@ cifs_get_tcp_session(struct smb_vol *volume_inf=
o)
> =A0 =A0 =A0 =A0 * no need to spinlock this init of tcpStatus or srv_c=
ount
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0tcp_ses->tcpStatus =3D CifsNew;
> + =A0 =A0 =A0 memcpy(&tcp_ses->srcaddr, &volume_info->srcaddr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(tcp_ses->srcaddr));
> =A0 =A0 =A0 =A0++tcp_ses->srv_count;
>
> =A0 =A0 =A0 =A0if (addr.ss_family =3D=3D AF_INET6) {
> @@ -2026,6 +2077,33 @@ static void rfc1002mangle(char *target, char *=
source, unsigned int length)
>
> =A0}
>
> +static int
> +bind_socket(struct TCP_Server_Info *server)
> +{
> + =A0 =A0 =A0 int rc =3D 0;
> + =A0 =A0 =A0 if (server->srcaddr.ss_family !=3D AF_UNSPEC) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Bind to the specified local IP addre=
ss */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct socket *socket =3D server->ssock=
et;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D socket->ops->bind(socket,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0(struct sockaddr *) &server->srcaddr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0sizeof(server->srcaddr));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct sockaddr_in *sad=
dr4;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct sockaddr_in6 *sa=
ddr6;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 saddr4 =3D (struct sock=
addr_in *)&server->srcaddr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 saddr6 =3D (struct sock=
addr_in6 *)&server->srcaddr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (saddr6->sin6_family=
 =3D=3D AF_INET6)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(=
1, "cifs: "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0"Failed to bind to: %pI6c, error: %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&saddr6->sin6_addr, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(=
1, "cifs: "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0"Failed to bind to: %pI4, error: %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&saddr4->sin_addr.s_addr, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return rc;
> +}
>
> =A0static int
> =A0ipv4_connect(struct TCP_Server_Info *server)
> @@ -2051,6 +2129,10 @@ ipv4_connect(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_reclassify_socket4(socket);
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 rc =3D bind_socket(server);
> + =A0 =A0 =A0 if (rc < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> +
> =A0 =A0 =A0 =A0/* user overrode default port */
> =A0 =A0 =A0 =A0if (server->addr.sockAddr.sin_port) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D socket->ops->connect(socket, (s=
truct sockaddr *)
> @@ -2213,6 +2295,10 @@ ipv6_connect(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_reclassify_socket6(socket);
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 rc =3D bind_socket(server);
> + =A0 =A0 =A0 if (rc < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> +
> =A0 =A0 =A0 =A0/* user overrode default port */
> =A0 =A0 =A0 =A0if (server->addr.sockAddr6.sin6_port) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D socket->ops->connect(socket,
> --
> 1.6.2.5
>
>



--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
