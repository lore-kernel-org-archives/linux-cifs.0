From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 05/50] CIFS: Add SMB2 transport routines
Date: Fri, 3 Feb 2012 16:05:53 -0500
Message-ID: <20120203160553.2c272a02@tlielax.poochiereds.net>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
	<1327048511-2342-5-git-send-email-piastry@etersoft.ru>
	<20120203140007.5a232933@tlielax.poochiereds.net>
	<CAH2r5mvxhgmNOrQhiSMwQ4tNUkaqbCBCPXKm-g5G9tBG0NV5fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvxhgmNOrQhiSMwQ4tNUkaqbCBCPXKm-g5G9tBG0NV5fw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 3 Feb 2012 13:46:39 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I am not certain that the mid is treated the same semantically, even
> discounting the difference in size, in particular collision detection=
,
> so it may be risky to treat the mid identically in each.  I am
> interested in other's opinions on this.
>=20
> Would be interesting to scan through the server code to see whether
> they overload the field in Samba server.
>=20

I see no reason not to use the same field for both. They are mutually
exclusive. You'll never use both fields on the same socket. Just use a
64 bit field for both. For SMB2, you can use the field unadulterated,
and can probably also skip checking for collisions in most cases.

=46or SMB1:

    u16 smb1mid =3D (u16)(64bit_mid & 0xffff);

=2E..and then check for collisions.

> On Fri, Feb 3, 2012 at 1:00 PM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>=
 wrote:
> > On Fri, 20 Jan 2012 12:34:26 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> And simplify smb_sendv to make it process SMB2 requests. It let us
> >> send SMB2 negotiate message to the server.
> >>
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/cifs_debug.h =C2=A0 =C2=A0| =C2=A0 =C2=A03 +
> >> =C2=A0fs/cifs/cifsglob.h =C2=A0 =C2=A0 =C2=A0| =C2=A0 18 +++
> >> =C2=A0fs/cifs/cifsproto.h =C2=A0 =C2=A0 | =C2=A0 12 ++-
> >> =C2=A0fs/cifs/smb2misc.c =C2=A0 =C2=A0 =C2=A0| =C2=A0 35 ++++++
> >> =C2=A0fs/cifs/smb2pdu.h =C2=A0 =C2=A0 =C2=A0 | =C2=A0 59 +++++++++
> >> =C2=A0fs/cifs/smb2proto.h =C2=A0 =C2=A0 | =C2=A0 42 +++++++
> >> =C2=A0fs/cifs/smb2transport.c | =C2=A0305 ++++++++++++++++++++++++=
+++++++++++++++++++++++
> >> =C2=A0fs/cifs/transport.c =C2=A0 =C2=A0 | =C2=A0142 +++++++++++++-=
---------
> >> =C2=A08 files changed, 554 insertions(+), 62 deletions(-)
> >> =C2=A0create mode 100644 fs/cifs/smb2misc.c
> >> =C2=A0create mode 100644 fs/cifs/smb2proto.h
> >> =C2=A0create mode 100644 fs/cifs/smb2transport.c
> >>
> >> diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
> >> index 8942b28..e9911bf 100644
> >> --- a/fs/cifs/cifs_debug.h
> >> +++ b/fs/cifs/cifs_debug.h
> >> @@ -33,6 +33,9 @@ void cifs_dump_mids(struct TCP_Server_Info *);
> >> =C2=A0#endif
> >> =C2=A0extern int traceSMB; =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* flag whi=
ch enables the function below */
> >> =C2=A0void dump_smb(struct smb_hdr *, int);
> >> +#ifdef CONFIG_CIFS_SMB2
> >> +void dump_smb2(struct smb2_hdr *smb_buf, int smb_buf_length);
> >> +#endif
> >> =C2=A0#define CIFS_INFO =C2=A0 =C2=A00x01
> >> =C2=A0#define CIFS_RC =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00x02
> >> =C2=A0#define CIFS_TIMER =C2=A0 0x04
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index 15c3a92..bb2af48 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -22,11 +22,15 @@
> >> =C2=A0#include <linux/in.h>
> >> =C2=A0#include <linux/in6.h>
> >> =C2=A0#include <linux/slab.h>
> >> +#include <linux/mempool.h>
> >> =C2=A0#include <linux/workqueue.h>
> >> =C2=A0#include "cifs_fs_sb.h"
> >> =C2=A0#include "cifsacl.h"
> >> =C2=A0#include <crypto/internal/hash.h>
> >> =C2=A0#include <linux/scatterlist.h>
> >> +#ifdef CONFIG_CIFS_SMB2
> >> +#include "smb2pdu.h"
> >> +#endif /* CONFIG_CIFS_SMB2 */
> >>
> >> =C2=A0/*
> >> =C2=A0 * The sizes of various internal tables and strings
> >> @@ -236,6 +240,12 @@ struct cifs_mnt_data {
> >> =C2=A0 =C2=A0 =C2=A0 int flags;
> >> =C2=A0};
> >>
> >> +static inline unsigned int
> >> +get_rfc1002_length(void *buf)
> >> +{
> >> + =C2=A0 =C2=A0 return be32_to_cpu(*((__be32 *)buf));
> >> +}
> >> +
> >> =C2=A0struct TCP_Server_Info {
> >> =C2=A0 =C2=A0 =C2=A0 struct list_head tcp_ses_list;
> >> =C2=A0 =C2=A0 =C2=A0 struct list_head smb_ses_list;
> >> @@ -307,6 +317,9 @@ struct TCP_Server_Info {
> >> =C2=A0 =C2=A0 =C2=A0 atomic_t in_send; /* requests trying to send =
*/
> >> =C2=A0 =C2=A0 =C2=A0 atomic_t num_waiters; =C2=A0 /* blocked waiti=
ng to get in sendrecv */
> >> =C2=A0#endif
> >> +#ifdef CONFIG_CIFS_SMB2
> >> + =C2=A0 =C2=A0 __u64 current_smb2_mid; =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 /* multiplex id - rotating counter */
> >> +#endif
> >> =C2=A0};
> >>
> >> =C2=A0/*
> >> @@ -693,6 +706,7 @@ struct mid_q_entry {
> >> =C2=A0 =C2=A0 =C2=A0 unsigned long when_sent; /* time when smb sen=
d finished */
> >> =C2=A0 =C2=A0 =C2=A0 unsigned long when_received; /* when demux co=
mplete (taken off wire) */
> >> =C2=A0#endif
> >> + =C2=A0 =C2=A0 bool is_smb2:1; =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* SMB=
2 mid */
> >> =C2=A0 =C2=A0 =C2=A0 mid_receive_t *receive; /* call receive callb=
ack */
> >> =C2=A0 =C2=A0 =C2=A0 mid_callback_t *callback; /* call completion =
callback */
> >> =C2=A0 =C2=A0 =C2=A0 void *callback_data; =C2=A0 =C2=A0/* general =
purpose pointer for callback */
> >> @@ -835,6 +849,7 @@ static inline void free_dfs_info_array(struct =
dfs_info3_param *param,
> >> =C2=A0#define =C2=A0 MID_RETRY_NEEDED =C2=A0 =C2=A0 =C2=A08 /* ses=
sion closed while this request out */
> >> =C2=A0#define =C2=A0 MID_RESPONSE_MALFORMED 0x10
> >> =C2=A0#define =C2=A0 MID_SHUTDOWN =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A00x20
> >> +#define =C2=A0 MID_NO_RESPONSE_NEEDED 0x40
> >>
> >> =C2=A0/* Types of response buffer returned from SendReceive2 */
> >> =C2=A0#define =C2=A0 CIFS_NO_BUFFER =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=
=A0 =C2=A0/* Response buffer not returned */
> >> @@ -843,6 +858,7 @@ static inline void free_dfs_info_array(struct =
dfs_info3_param *param,
> >> =C2=A0#define =C2=A0 CIFS_IOVEC =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A04 =C2=A0 =C2=A0/* array of response buffers */
> >>
> >> =C2=A0/* Type of Request to SendReceive2 */
> >> +#define =C2=A0 CIFS_STD_OP =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00
> >> =C2=A0#define =C2=A0 CIFS_BLOCKING_OP =C2=A0 =C2=A0 =C2=A01 =C2=A0=
 =C2=A0/* operation can block */
> >> =C2=A0#define =C2=A0 CIFS_ASYNC_OP =C2=A0 =C2=A0 =C2=A0 =C2=A0 2 =C2=
=A0 =C2=A0/* do not wait for response */
> >> =C2=A0#define =C2=A0 CIFS_TIMEOUT_MASK 0x003 =C2=A0 =C2=A0/* only =
one of above set in req */
> >> @@ -1028,4 +1044,6 @@ void cifs_oplock_break(struct work_struct *w=
ork);
> >>
> >> =C2=A0extern const struct slow_work_ops cifs_oplock_break_ops;
> >>
> >> +extern mempool_t *cifs_mid_poolp;
> >> +
> >> =C2=A0#endif =C2=A0 =C2=A0 =C2=A0 /* _CIFS_GLOB_H */
> >> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> >> index 6f4e243..d1e30d9 100644
> >> --- a/fs/cifs/cifsproto.h
> >> +++ b/fs/cifs/cifsproto.h
> >> @@ -36,7 +36,9 @@ extern void cifs_buf_release(void *);
> >> =C2=A0extern struct smb_hdr *cifs_small_buf_get(void);
> >> =C2=A0extern void cifs_small_buf_release(void *);
> >> =C2=A0extern int smb_send(struct TCP_Server_Info *, struct smb_hdr=
 *,
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 unsigned int /* length */);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned=
 int /* length */);
> >> +extern int smb_sendv(struct TCP_Server_Info *server, struct kvec =
*iov,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0in=
t n_vec);
> >> =C2=A0extern unsigned int _GetXid(void);
> >> =C2=A0extern void _FreeXid(unsigned int);
> >> =C2=A0#define GetXid() =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \
> >> @@ -68,6 +70,14 @@ extern char *cifs_compose_mount_options(const c=
har *sb_mountdata,
> >> =C2=A0extern struct mid_q_entry *AllocMidQEntry(const struct smb_h=
dr *smb_buffer,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stru=
ct TCP_Server_Info *server);
> >> =C2=A0extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
> >> +extern void cifs_delete_mid(struct mid_q_entry *midEntry);
> >> +extern int cifs_sync_mid_result(struct mid_q_entry *mid,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct TCP_Server_Info *server);
> >> +extern int cifs_wait_for_free_request(struct TCP_Server_Info *ser=
ver,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const int long_op)=
;
> >> +extern int cifs_wait_for_response(struct TCP_Server_Info *server,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct mid_q_entry *midQ);
> >> +extern void cifs_wake_up_task(struct mid_q_entry *mid);
> >> =C2=A0extern int cifs_call_async(struct TCP_Server_Info *server, s=
truct kvec *iov,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0unsigned int nvec, mid_receive_t *receive,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0mid_callback_t *callback, void *cbdata,
> >> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> >> new file mode 100644
> >> index 0000000..355fb15
> >> --- /dev/null
> >> +++ b/fs/cifs/smb2misc.c
> >> @@ -0,0 +1,35 @@
> >> +/*
> >> + * =C2=A0 fs/cifs/smb2misc.c
> >> + *
> >> + * =C2=A0 Copyright (C) International Business Machines =C2=A0Cor=
p., 2002,2011
> >> + * =C2=A0 Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
> >> + * =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Pavel Shilovsk=
y (pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org) 2012
> >> + *
> >> + * =C2=A0 This library is free software; you can redistribute it =
and/or modify
> >> + * =C2=A0 it under the terms of the GNU Lesser General Public Lic=
ense as published
> >> + * =C2=A0 by the Free Software Foundation; either version 2.1 of =
the License, or
> >> + * =C2=A0 (at your option) any later version.
> >> + *
> >> + * =C2=A0 This library is distributed in the hope that it will be=
 useful,
> >> + * =C2=A0 but WITHOUT ANY WARRANTY; without even the implied warr=
anty of
> >> + * =C2=A0 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =C2=
=A0See
> >> + * =C2=A0 the GNU Lesser General Public License for more details.
> >> + *
> >> + * =C2=A0 You should have received a copy of the GNU Lesser Gener=
al Public License
> >> + * =C2=A0 along with this library; if not, write to the Free Soft=
ware
> >> + * =C2=A0 Foundation, Inc., 59 Temple Place, Suite 330, Boston, M=
A 02111-1307 USA
> >> + */
> >> +#include <linux/ctype.h>
> >> +#include "smb2pdu.h"
> >> +#include "cifsglob.h"
> >> +#include "cifsproto.h"
> >> +#include "smb2proto.h"
> >> +#include "cifs_debug.h"
> >> +#include "cifs_unicode.h"
> >> +#include "smb2status.h"
> >> +
> >> +void
> >> +dump_smb2(struct smb2_hdr *smb_buf, int smb_buf_length)
> >> +{
> >> + =C2=A0 =C2=A0 dump_smb((struct smb_hdr *)smb_buf, smb_buf_length=
);
> >> +}
> >> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> >> index e3e67bb..5ec0c9f 100644
> >> --- a/fs/cifs/smb2pdu.h
> >> +++ b/fs/cifs/smb2pdu.h
> >> @@ -26,6 +26,65 @@
> >> =C2=A0#include <net/sock.h>
> >>
> >> =C2=A0/*
> >> + * Note that, due to trying to use names similar to the protocol =
specifications,
> >> + * there are many mixed case field names in the structures below.=
 =C2=A0Although
> >> + * this does not match typical Linux kernel style, it is necessar=
y to be
> >> + * be able to match against the protocol specfication.
> >> + *
> >> + * SMB2 commands
> >> + * Some commands have minimal (wct=3D0,bcc=3D0), or uninteresting=
, responses
> >> + * (ie no useful data other than the SMB error code itself) and a=
re marked such.
> >> + * Knowing this helps avoid response buffer allocations and copy =
in some cases.
> >> + */
> >> +
> >> +/* List is sent on wire as little endian */
> >> +#define SMB2_NEGOTIATE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 cpu_to_le16(0x0000)
> >> +#define SMB2_SESSION_SETUP =C2=A0 cpu_to_le16(0x0001)
> >> +#define SMB2_LOGOFF =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cpu_to_le16=
(0x0002) /* trivial request/resp */
> >> +#define SMB2_TREE_CONNECT =C2=A0 =C2=A0cpu_to_le16(0x0003)
> >> +#define SMB2_TREE_DISCONNECT cpu_to_le16(0x0004) /* trivial req/r=
esp */
> >> +#define SMB2_CREATE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cpu_to_le16=
(0x0005)
> >> +#define SMB2_CLOSE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le16=
(0x0006)
> >> +#define SMB2_FLUSH =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le16=
(0x0007) /* trivial resp */
> >> +#define SMB2_READ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cpu_to=
_le16(0x0008)
> >> +#define SMB2_WRITE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le16=
(0x0009)
> >> +#define SMB2_LOCK =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cpu_to=
_le16(0x000A)
> >> +#define SMB2_IOCTL =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le16=
(0x000B)
> >> +#define SMB2_CANCEL =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cpu_to_le16=
(0x000C)
> >> +#define SMB2_ECHO =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cpu_to=
_le16(0x000D)
> >> +#define SMB2_QUERY_DIRECTORY cpu_to_le16(0x000E)
> >> +#define SMB2_CHANGE_NOTIFY =C2=A0 cpu_to_le16(0x000F)
> >> +#define SMB2_QUERY_INFO =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0cpu_to_le16(0x0010)
> >> +#define SMB2_SET_INFO =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0cpu_to_le16(0x0011)
> >> +#define SMB2_OPLOCK_BREAK =C2=A0 =C2=A0cpu_to_le16(0x0012)
> >> +
> >> +/* Same List of commands in host endian */
> >> +#define SMB2NEGOTIATE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00x0000
> >> +#define SMB2SESSION_SETUP =C2=A0 =C2=A00x0001
> >> +#define SMB2LOGOFF =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x0002 /* t=
rivial request/resp */
> >> +#define SMB2TREE_CONNECT =C2=A0 =C2=A0 0x0003
> >> +#define SMB2TREE_DISCONNECT =C2=A00x0004 /* trivial req/resp */
> >> +#define SMB2CREATE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x0005
> >> +#define SMB2CLOSE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0006
> >> +#define SMB2FLUSH =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0007=
 /* trivial resp */
> >> +#define SMB2READ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x0008
> >> +#define SMB2WRITE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0009
> >> +#define SMB2LOCK =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x000A
> >> +#define SMB2IOCTL =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x000B
> >> +#define SMB2CANCEL =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x000C
> >> +#define SMB2ECHO =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x000D
> >> +#define SMB2QUERY_DIRECTORY =C2=A00x000E
> >> +#define SMB2CHANGE_NOTIFY =C2=A0 =C2=A00x000F
> >> +#define SMB2QUERY_INFO =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 0x0010
> >> +#define SMB2SET_INFO =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x0011
> >> +#define SMB2OPLOCK_BREAK =C2=A0 =C2=A0 0x0012
> >> +
> >> +#define NUMBER_OF_SMB2_COMMANDS =C2=A0 =C2=A0 =C2=A00x0013
> >> +
> >> +/* BB FIXME - analyze following length BB */
> >> +#define MAX_SMB2_HDR_SIZE 0x78 /* 4 len + 64 hdr + (2*24 wct) + 2=
 bct + 2 pad */
> >> +
> >> +/*
> >> =C2=A0 * SMB2 Header Definition
> >> =C2=A0 *
> >> =C2=A0 * "MBZ" : =C2=A0Must be Zero
> >> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> >> new file mode 100644
> >> index 0000000..6cffdf1
> >> --- /dev/null
> >> +++ b/fs/cifs/smb2proto.h
> >> @@ -0,0 +1,42 @@
> >> +/*
> >> + * =C2=A0 fs/cifs/smb2proto.h
> >> + *
> >> + * =C2=A0 Copyright (c) International Business Machines =C2=A0Cor=
p., 2002, 2011
> >> + * =C2=A0 Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
> >> + * =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Pavel Shilovsk=
y (pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org) 2012
> >> + *
> >> + * =C2=A0 This library is free software; you can redistribute it =
and/or modify
> >> + * =C2=A0 it under the terms of the GNU Lesser General Public Lic=
ense as published
> >> + * =C2=A0 by the Free Software Foundation; either version 2.1 of =
the License, or
> >> + * =C2=A0 (at your option) any later version.
> >> + *
> >> + * =C2=A0 This library is distributed in the hope that it will be=
 useful,
> >> + * =C2=A0 but WITHOUT ANY WARRANTY; without even the implied warr=
anty of
> >> + * =C2=A0 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =C2=
=A0See
> >> + * =C2=A0 the GNU Lesser General Public License for more details.
> >> + *
> >> + * =C2=A0 You should have received a copy of the GNU Lesser Gener=
al Public License
> >> + * =C2=A0 along with this library; if not, write to the Free Soft=
ware
> >> + * =C2=A0 Foundation, Inc., 59 Temple Place, Suite 330, Boston, M=
A 02111-1307 USA
> >> + */
> >> +#ifndef _SMB2PROTO_H
> >> +#define _SMB2PROTO_H
> >> +#include <linux/nls.h>
> >> +#include <linux/key-type.h>
> >> +
> >> +struct statfs;
> >> +
> >> +/*
> >> + ****************************************************************=
*
> >> + * All Prototypes
> >> + ****************************************************************=
*
> >> + */
> >> +extern int map_smb2_to_linux_error(struct smb2_hdr *smb2, int log=
Err);
> >> +
> >> +extern int smb2_sendrcv2(const unsigned int xid, struct cifs_ses =
*ses,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0struct kvec *vec, int nvec, int *ret_buf_type,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0int *status, const int flags);
> >> +extern int smb2_sendrcv_norsp(const unsigned int xid, struct cifs=
_ses *ses,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 struct smb2_hdr *in_buf, int flags);
> >> +
> >> +#endif =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 /* _SMB2PROTO_H */
> >> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> >> new file mode 100644
> >> index 0000000..d7f1c05
> >> --- /dev/null
> >> +++ b/fs/cifs/smb2transport.c
> >> @@ -0,0 +1,305 @@
> >> +/*
> >> + * =C2=A0 fs/cifs/smb2transport.c
> >> + *
> >> + * =C2=A0 Copyright (C) International Business Machines =C2=A0Cor=
p., 2002, 2011
> >> + * =C2=A0 Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
> >> + * =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Jeremy Allison=
 (jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org) 2006
> >> + * =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Pavel Shilovsk=
y (pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org) 2012
> >> + *
> >> + * =C2=A0 This library is free software; you can redistribute it =
and/or modify
> >> + * =C2=A0 it under the terms of the GNU Lesser General Public Lic=
ense as published
> >> + * =C2=A0 by the Free Software Foundation; either version 2.1 of =
the License, or
> >> + * =C2=A0 (at your option) any later version.
> >> + *
> >> + * =C2=A0 This library is distributed in the hope that it will be=
 useful,
> >> + * =C2=A0 but WITHOUT ANY WARRANTY; without even the implied warr=
anty of
> >> + * =C2=A0 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =C2=
=A0See
> >> + * =C2=A0 the GNU Lesser General Public License for more details.
> >> + *
> >> + * =C2=A0 You should have received a copy of the GNU Lesser Gener=
al Public License
> >> + * =C2=A0 along with this library; if not, write to the Free Soft=
ware
> >> + * =C2=A0 Foundation, Inc., 59 Temple Place, Suite 330, Boston, M=
A 02111-1307 USA
> >> + */
> >> +
> >> +#include <linux/fs.h>
> >> +#include <linux/list.h>
> >> +#include <linux/wait.h>
> >> +#include <linux/net.h>
> >> +#include <linux/delay.h>
> >> +#include <linux/uaccess.h>
> >> +#include <asm/processor.h>
> >> +#include <linux/mempool.h>
> >> +#include "smb2pdu.h"
> >> +#include "cifsglob.h"
> >> +#include "cifsproto.h"
> >> +#include "smb2proto.h"
> >> +#include "cifs_debug.h"
> >> +#include "smb2status.h"
> >> +
> >> +static __u64
> >> +smb2_get_mid(struct TCP_Server_Info *server)
> >> +{
> >> + =C2=A0 =C2=A0 __u64 mid;
> >> +
> >> + =C2=A0 =C2=A0 spin_lock(&GlobalMid_Lock);
> >> + =C2=A0 =C2=A0 mid =3D server->current_smb2_mid++;
> >> + =C2=A0 =C2=A0 spin_unlock(&GlobalMid_Lock);
> >> + =C2=A0 =C2=A0 return mid;
> >> +} /* BB do we eventually need an SMB2 version of this routine? BB=
 */
> >> +
> >
> > current_smb2_mid should be merged with SMB1 server->CurrentMid. Jus=
t
> > mask off the upper bits for SMB1 before checking for collisions.
> >
> >> +/*
> >> + * Set message id for the request. Should be called after wait_fo=
r_free_request
> >> + * and when srv_mutex is held. iov array must have at least 1 ele=
ment.
> >> + */
> >> +static inline void
> >> +smb2_seq_num_into_buf(struct TCP_Server_Info *server, struct kvec=
 *iov)
> >> +{
> >> + =C2=A0 =C2=A0 ((struct smb2_hdr *)iov[0].iov_base)->MessageId =3D=
 smb2_get_mid(server);
> >> +}
> >> +
> >> +static struct mid_q_entry *
> >> +smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0st=
ruct TCP_Server_Info *server)
> >> +{
> >> + =C2=A0 =C2=A0 struct mid_q_entry *temp;
> >> +
> >> + =C2=A0 =C2=A0 if (server =3D=3D NULL) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cERROR(1, "Null TCP se=
ssion in smb2_mid_entry_alloc");
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 temp =3D mempool_alloc(cifs_mid_poolp, GFP_NOFS);
> >> + =C2=A0 =C2=A0 if (temp =3D=3D NULL)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return temp;
> >> + =C2=A0 =C2=A0 else {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(temp, 0, sizeof=
(struct mid_q_entry));
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 temp->mid =3D smb_buff=
er->MessageId; =C2=A0 =C2=A0 =C2=A0/* always LE */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 temp->pid =3D current-=
>pid;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 temp->command =3D smb_=
buffer->Command; =C2=A0 =C2=A0/* Always LE */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 temp->when_alloc =3D j=
iffies;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 temp->is_smb2 =3D true=
;
> >> +
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* The default is=
 for the mid to be synchronous, so the
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* default callba=
ck just wakes up the current task.
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 temp->callback =3D cif=
s_wake_up_task;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 temp->callback_data =3D=
 current;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 atomic_inc(&midCount);
> >> + =C2=A0 =C2=A0 temp->mid_state =3D MID_REQUEST_ALLOCATED;
> >> + =C2=A0 =C2=A0 return temp;
> >> +}
> >> +
> >> +static int
> >> +smb2_get_mid_entry(struct cifs_ses *ses, struct smb2_hdr *buf,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct mi=
d_q_entry **mid)
> >> +{
> >> + =C2=A0 =C2=A0 if (ses->server->tcpStatus =3D=3D CifsExiting)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOENT;
> >> +
> >> + =C2=A0 =C2=A0 if (ses->server->tcpStatus =3D=3D CifsNeedReconnec=
t) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "tcp session d=
ead - return to caller to retry");
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EAGAIN;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 if (ses->status !=3D CifsGood) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* check if SMB2 sessi=
on is bad because we are setting it up */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((buf->Command !=3D=
 SMB2_SESSION_SETUP) &&
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (buf->Co=
mmand !=3D SMB2_NEGOTIATE))
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return -EAGAIN;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* else ok - we are se=
tting up session */
> >> + =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 *mid =3D smb2_mid_entry_alloc(buf, ses->server);
> >> + =C2=A0 =C2=A0 if (*mid =3D=3D NULL)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOMEM;
> >> + =C2=A0 =C2=A0 spin_lock(&GlobalMid_Lock);
> >> + =C2=A0 =C2=A0 list_add_tail(&(*mid)->qhead, &ses->server->pendin=
g_mid_q);
> >> + =C2=A0 =C2=A0 spin_unlock(&GlobalMid_Lock);
> >> + =C2=A0 =C2=A0 return 0;
> >> +}
> >> +
> >> +static int
> >> +smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Inf=
o *server,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned =
int receive_len, bool log_error)
> >> +{
> >> + =C2=A0 =C2=A0 unsigned int len =3D get_rfc1002_length(mid->resp_=
buf);
> >> +
> >> + =C2=A0 =C2=A0 dump_smb2(mid->resp_buf, min_t(u32, 80, len));
> >> + =C2=A0 =C2=A0 /* convert the length into a more usable form */
> >> + =C2=A0 =C2=A0 /* BB - uncomment with SMB2 signing implementation=
 */
> >> + =C2=A0 =C2=A0 /* if ((receive_len > 24) &&
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 (server->sec_mode & (SECMODE_SIGN_RE=
QUIRED|SECMODE_SIGN_ENABLED))) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (smb2_verify_signat=
ure(mid->resp_buf, server))
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 cERROR(1, "Unexpected SMB signature");
> >> + =C2=A0 =C2=A0 } */
> >> +
> >> + =C2=A0 =C2=A0 return map_smb2_to_linux_error(mid->resp_buf, log_=
error);
> >> +}
> >> +
> >> +int
> >> +smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct kvec *iov, int n_vec, =
int *presp_buftype /* ret */,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int *status /* ret SMB2 netwo=
rk status code */, const int flags)
> >> +{
> >> + =C2=A0 =C2=A0 int rc =3D 0;
> >> + =C2=A0 =C2=A0 int long_op;
> >> + =C2=A0 =C2=A0 unsigned int receive_len;
> >> + =C2=A0 =C2=A0 struct mid_q_entry *midQ;
> >> + =C2=A0 =C2=A0 struct smb2_hdr *buf =3D iov[0].iov_base;
> >> +
> >> + =C2=A0 =C2=A0 if (status)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *status =3D STATUS_SUC=
CESS;
> >> + =C2=A0 =C2=A0 long_op =3D flags & CIFS_TIMEOUT_MASK;
> >> +
> >> + =C2=A0 =C2=A0 *presp_buftype =3D CIFS_NO_BUFFER; =C2=A0/* no res=
ponse buf yet */
> >> +
> >> + =C2=A0 =C2=A0 if ((ses =3D=3D NULL) || (ses->server =3D=3D NULL)=
) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_small_buf_release=
(buf);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cERROR(1, "Null sessio=
n");
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EIO;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 if (ses->server->tcpStatus =3D=3D CifsExiting) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_small_buf_release=
(buf);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOENT;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 rc =3D cifs_wait_for_free_request(ses->server, lon=
g_op);
> >> + =C2=A0 =C2=A0 if (rc) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_small_buf_release=
(buf);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0* Make sure that we sign in the same order t=
hat we send on this socket
> >> + =C2=A0 =C2=A0 =C2=A0* and avoid races inside tcp sendmsg code th=
at could cause corruption
> >> + =C2=A0 =C2=A0 =C2=A0* of smb data.
> >> + =C2=A0 =C2=A0 =C2=A0*/
> >> +
> >> + =C2=A0 =C2=A0 mutex_lock(&ses->server->srv_mutex);
> >> +
> >> + =C2=A0 =C2=A0 smb2_seq_num_into_buf(ses->server, iov);
> >> +
> >> + =C2=A0 =C2=A0 rc =3D smb2_get_mid_entry(ses, buf, &midQ);
> >> + =C2=A0 =C2=A0 if (rc) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&ses->ser=
ver->srv_mutex);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_small_buf_release=
(buf);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wake_up(&ses->server->=
request_q);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> + =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 /* rc =3D smb2_sign_smb2(iov, n_vec, ses->server);
> >> + =C2=A0 =C2=A0 if (rc) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&ses->ser=
ver->srv_mutex);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_small_buf_release=
(buf);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> >> + =C2=A0 =C2=A0 } */
> >> +
> >> + =C2=A0 =C2=A0 midQ->mid_state =3D MID_REQUEST_SUBMITTED;
> >> + =C2=A0 =C2=A0 cifs_in_send_inc(ses->server);
> >> + =C2=A0 =C2=A0 rc =3D smb_sendv(ses->server, iov, n_vec);
> >> + =C2=A0 =C2=A0 cifs_in_send_dec(ses->server);
> >> + =C2=A0 =C2=A0 cifs_save_when_sent(midQ);
> >> +
> >> + =C2=A0 =C2=A0 mutex_unlock(&ses->server->srv_mutex);
> >> +
> >> + =C2=A0 =C2=A0 if (rc < 0) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_small_buf_release=
(buf);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 if (long_op =3D=3D CIFS_ASYNC_OP) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_small_buf_release=
(buf);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 rc =3D cifs_wait_for_response(ses->server, midQ);
> >> + =C2=A0 =C2=A0 if (rc !=3D 0) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* BB send cancel mess=
age */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&GlobalMid_L=
ock);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (midQ->mid_state =3D=
=3D MID_REQUEST_SUBMITTED) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 midQ->callback =3D cifs_delete_mid;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 spin_unlock(&GlobalMid_Lock);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 cifs_small_buf_release(buf);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 wake_up(&ses->server->request_q);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return rc;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&GlobalMid=
_Lock);
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 cifs_small_buf_release(buf);
> >> +
> >> + =C2=A0 =C2=A0 rc =3D cifs_sync_mid_result(midQ, ses->server);
> >> + =C2=A0 =C2=A0 if (rc) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wake_up(&ses->server->=
request_q);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 if (!midQ->resp_buf || (midQ->mid_state !=3D MID_R=
ESPONSE_RECEIVED)) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -EIO;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "Bad MID state=
?");
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 buf =3D (struct smb2_hdr *)midQ->resp_buf;
> >> + =C2=A0 =C2=A0 receive_len =3D get_rfc1002_length(buf);
> >> +
> >> + =C2=A0 =C2=A0 if (receive_len > CIFSMaxBufSize + MAX_SMB2_HDR_SI=
ZE) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cERROR(1, "Frame too l=
arge received. =C2=A0Length: %d =C2=A0Xid: %d",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 receive_len, xid);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -EIO;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 /* rcvd frame is ok */
> >> +
> >> + =C2=A0 =C2=A0 iov[0].iov_base =3D (char *)buf;
> >> + =C2=A0 =C2=A0 iov[0].iov_len =3D receive_len + 4;
> >> + =C2=A0 =C2=A0 if (midQ->large_buf)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *presp_buftype =3D CIF=
S_LARGE_BUFFER;
> >> + =C2=A0 =C2=A0 else
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *presp_buftype =3D CIF=
S_SMALL_BUFFER;
> >> +
> >> + =C2=A0 =C2=A0 rc =3D smb2_check_receive(midQ, ses->server, recei=
ve_len,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 flags & CIFS_LOG_ERROR);
> >> +
> >> + =C2=A0 =C2=A0 if (status)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *status =3D le32_to_cp=
u(buf->Status);
> >> +
> >> + =C2=A0 =C2=A0 if ((flags & CIFS_NO_RESP) =3D=3D 0)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* mark it so buf will=
 not be freed by free_smb2mid */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 midQ->resp_buf =3D NUL=
L;
> >> +
> >> +out:
> >> + =C2=A0 =C2=A0 cifs_delete_mid(midQ);
> >> + =C2=A0 =C2=A0 wake_up(&ses->server->request_q);
> >> + =C2=A0 =C2=A0 return rc;
> >> +}
> >> +
> >
> >
> > NACK on the cut and paste madness...
> >
> > This needs to be consolidated with the existing cifs code. Abstract=
 out
> > the pieces that are protocol-specific and have SendReceive2 (or
> > whatever you want to name it) call those functions as needed. Ditto=
 for
> > many of the functions above this one and probably for the ones belo=
w.
> >
> > Not only will that cut down code duplication but it will also help
> > modularize the code and make it easier to debug.
> >
> > It's just better engineering practice.
> >
> >
> >> +/*
> >> + * Send an SMB2 Request. No response info (other than return code=
) needs to
> >> + * be parsed.
> >> + *
> >> + * flags indicate the type of request buffer and how long to wait
> >> + * and whether to log NT STATUS code (error) before mapping it to=
 POSIX error.
> >> + */
> >> +int
> >> +smb2_sendrcv_norsp(const unsigned int xid, struct cifs_ses *ses,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct sm=
b2_hdr *in_buf, int flags)
> >> +{
> >> + =C2=A0 =C2=A0 int rc;
> >> + =C2=A0 =C2=A0 struct kvec iov[1];
> >> + =C2=A0 =C2=A0 int resp_buf_type;
> >> +
> >> + =C2=A0 =C2=A0 iov[0].iov_base =3D (char *)in_buf;
> >> + =C2=A0 =C2=A0 iov[0].iov_len =3D get_rfc1002_length(in_buf) + 4;
> >> + =C2=A0 =C2=A0 flags |=3D CIFS_NO_RESP;
> >> + =C2=A0 =C2=A0 rc =3D smb2_sendrcv2(xid, ses, iov, 1, &resp_buf_t=
ype, NULL, flags);
> >> + =C2=A0 =C2=A0 /* BB remove the following debug line eventually *=
/
> >> + =C2=A0 =C2=A0 cFYI(1, "%s flags %d rc %d", __func__, flags, rc);
> >> +
> >> + =C2=A0 =C2=A0 return rc;
> >> +}
> >> +
> >> +/* BB add missing functions here */
> >> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> >> index f3f98ad..f7ac3f0 100644
> >> --- a/fs/cifs/transport.c
> >> +++ b/fs/cifs/transport.c
> >> @@ -35,10 +35,8 @@
> >> =C2=A0#include "cifsproto.h"
> >> =C2=A0#include "cifs_debug.h"
> >>
> >> -extern mempool_t *cifs_mid_poolp;
> >> -
> >> -static void
> >> -wake_up_task(struct mid_q_entry *mid)
> >> +void
> >> +cifs_wake_up_task(struct mid_q_entry *mid)
> >> =C2=A0{
> >> =C2=A0 =C2=A0 =C2=A0 wake_up_process(mid->callback_data);
> >> =C2=A0}
> >> @@ -70,7 +68,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer,=
 struct TCP_Server_Info *server)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* The defau=
lt is for the mid to be synchronous, so the
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* default c=
allback just wakes up the current task.
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 temp->callback =3D wak=
e_up_task;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 temp->callback =3D cif=
s_wake_up_task;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 temp->callback_da=
ta =3D current;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> @@ -83,7 +81,15 @@ void
> >> =C2=A0DeleteMidQEntry(struct mid_q_entry *midEntry)
> >> =C2=A0{
> >> =C2=A0#ifdef CONFIG_CIFS_STATS2
> >> + =C2=A0 =C2=A0 __le16 command;
> >> =C2=A0 =C2=A0 =C2=A0 unsigned long now;
> >> +
> >> +#ifdef CONFIG_CIFS_SMB2
> >> + =C2=A0 =C2=A0 if (midEntry->is_smb2)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 command =3D SMB2_LOCK;
> >> + =C2=A0 =C2=A0 else
> >> +#endif
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 command =3D cpu_to_le1=
6(SMB_COM_LOCKING_ANDX);
> >> =C2=A0#endif
> >> =C2=A0 =C2=A0 =C2=A0 midEntry->mid_state =3D MID_FREE;
> >> =C2=A0 =C2=A0 =C2=A0 atomic_dec(&midCount);
> >> @@ -98,8 +104,7 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0* something is wrong, unless it is quit=
e a slow link or server.
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> >> =C2=A0 =C2=A0 =C2=A0 if ((now - midEntry->when_alloc) > HZ) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((cifsFYI & CIFS_TI=
MER) &&
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (midEntr=
y->command !=3D cpu_to_le16(SMB_COM_LOCKING_ANDX))) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((cifsFYI & CIFS_TI=
MER) && (midEntry->command !=3D command)) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 printk(KERN_DEBUG " CIFS slow rsp: cmd %d mid %llu",
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0midEntry->command, midEntry->mid)=
;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 printk(" A: 0x%lx S: 0x%lx R: 0x%lx\n",
> >> @@ -112,8 +117,8 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
> >> =C2=A0 =C2=A0 =C2=A0 mempool_free(midEntry, cifs_mid_poolp);
> >> =C2=A0}
> >>
> >> -static void
> >> -delete_mid(struct mid_q_entry *mid)
> >> +void
> >> +cifs_delete_mid(struct mid_q_entry *mid)
> >> =C2=A0{
> >> =C2=A0 =C2=A0 =C2=A0 spin_lock(&GlobalMid_Lock);
> >> =C2=A0 =C2=A0 =C2=A0 list_del(&mid->qhead);
> >> @@ -122,18 +127,24 @@ delete_mid(struct mid_q_entry *mid)
> >> =C2=A0 =C2=A0 =C2=A0 DeleteMidQEntry(mid);
> >> =C2=A0}
> >>
> >> -static int
> >> +int
> >> =C2=A0smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, =
int n_vec)
> >> =C2=A0{
> >> =C2=A0 =C2=A0 =C2=A0 int rc =3D 0;
> >> =C2=A0 =C2=A0 =C2=A0 int i =3D 0;
> >> =C2=A0 =C2=A0 =C2=A0 struct msghdr smb_msg;
> >> + =C2=A0 =C2=A0 __be32 *buf_length =3D (__be32 *)iov[0].iov_base;
> >> =C2=A0 =C2=A0 =C2=A0 struct smb_hdr *smb_buffer =3D iov[0].iov_bas=
e;
> >> +#ifdef CONFIG_CIFS_SMB2
> >> + =C2=A0 =C2=A0 struct smb2_hdr *smb2_buffer =3D iov[0].iov_base;
> >> +#endif
> >> =C2=A0 =C2=A0 =C2=A0 unsigned int len =3D iov[0].iov_len;
> >> =C2=A0 =C2=A0 =C2=A0 unsigned int total_len;
> >> =C2=A0 =C2=A0 =C2=A0 int first_vec =3D 0;
> >> - =C2=A0 =C2=A0 unsigned int smb_buf_length =3D be32_to_cpu(smb_bu=
ffer->smb_buf_length);
> >> =C2=A0 =C2=A0 =C2=A0 struct socket *ssocket =3D server->ssocket;
> >> + =C2=A0 =C2=A0 unsigned int smb_buf_length;
> >> +
> >> + =C2=A0 =C2=A0 smb_buf_length =3D get_rfc1002_length(iov[0].iov_b=
ase);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 if (ssocket =3D=3D NULL)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOTSOCK;=
 /* BB eventually add reconnect code here */
> >> @@ -152,7 +163,12 @@ smb_sendv(struct TCP_Server_Info *server, str=
uct kvec *iov, int n_vec)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 total_len +=3D io=
v[i].iov_len;
> >>
> >> =C2=A0 =C2=A0 =C2=A0 cFYI(1, "Sending smb: =C2=A0total_len %d", to=
tal_len);
> >> - =C2=A0 =C2=A0 dump_smb(smb_buffer, len);
> >> +#ifdef CONFIG_CIFS_SMB2
> >> + =C2=A0 =C2=A0 if (server->is_smb2)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dump_smb2(smb2_buffer,=
 len);
> >> + =C2=A0 =C2=A0 else
> >> +#endif
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dump_smb(smb_buffer, l=
en);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 i =3D 0;
> >> =C2=A0 =C2=A0 =C2=A0 while (total_len) {
> >> @@ -160,24 +176,25 @@ smb_sendv(struct TCP_Server_Info *server, st=
ruct kvec *iov, int n_vec)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 n_vec - first_vec,=
 total_len);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((rc =3D=3D -E=
NOSPC) || (rc =3D=3D -EAGAIN)) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 i++;
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* if blocking send we try 3 times, since each can block
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0for 5 seconds. For nonblocking =C2=A0we have to try mo=
re
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0but wait increasing amounts of time allowing time for
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0socket to clear. =C2=A0The overall time we wait in eit=
her
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0case to send on the socket is about 15 seconds.
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0Similarly we wait for 15 seconds for
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0a response from the server in SendReceive[2]
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0for the server to send a response back for
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0most types of requests (except SMB Write
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0past end of file which can be slow, and
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0blocking lock operations). NFS waits slightly longer
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0than CIFS, but this can make it take longer for
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0nonresponsive servers to be detected and 15 seconds
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0is more than enough time for modern networks to
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0send a packet. =C2=A0In most cases if we fail to send
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0after the retries we will kill the socket and
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0reconnect which may clear the network problem.
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* If blocking send we try 3 times, since each can block
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* for 5 seconds. For nonblocking =C2=A0we have to try more
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* but wait increasing amounts of time allowing time for
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* socket to clear. =C2=A0The overall time we wait in either
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* case to send on the socket is about 15 seconds.
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* Similarly we wait for 15 seconds for
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* a response from the server in SendReceive[2]
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* for the server to send a response back for
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* most types of requests (except SMB Write
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* past end of file which can be slow, and
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* blocking lock operations). NFS waits slightly longer
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* than CIFS, but this can make it take longer for
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* nonresponsive servers to be detected and 15 seconds
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* is more than enough time for modern networks to
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* send a packet. =C2=A0In most cases if we fail to send
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* after the retries we will kill the socket and
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* reconnect which may clear the network problem.
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0*/
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if ((i >=3D 14) || (!server->noblocksnd && (i > 2))) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cERROR(1, "sends on sock %p stuc=
k for 15 seconds",
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ssocket);
> >> @@ -198,8 +215,10 @@ smb_sendv(struct TCP_Server_Info *server, str=
uct kvec *iov, int n_vec)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc =3D=3D 0) =
{
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* should never happen, letting socket clear before
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0retrying is our only obvious option here */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* Should never happen, letting socket clear before
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* retrying is our only obvious option here.
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0*/
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cERROR(1, "tcp sent no data");
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 msleep(500);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 continue;
> >> @@ -225,10 +244,12 @@ smb_sendv(struct TCP_Server_Info *server, st=
ruct kvec *iov, int n_vec)
> >> =C2=A0 =C2=A0 =C2=A0 if ((total_len > 0) && (total_len !=3D smb_bu=
f_length + 4)) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "partial =
send (%d remaining), terminating session",
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 total_len);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* If we have only sen=
t part of an SMB then the next SMB
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0could be =
taken as the remainder of this one. =C2=A0We need
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0to kill t=
he socket so the server throws away the partial
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SMB */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* If we have onl=
y sent part of an SMB then the next SMB
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* could be taken=
 as the remainder of this one. =C2=A0We need
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* to kill the so=
cket so the server throws away the partial
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* SMB.
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 server->tcpStatus=
 =3D CifsNeedReconnect;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> @@ -237,9 +258,8 @@ smb_sendv(struct TCP_Server_Info *server, stru=
ct kvec *iov, int n_vec)
> >> =C2=A0 =C2=A0 =C2=A0 else
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D 0;
> >>
> >> - =C2=A0 =C2=A0 /* Don't want to modify the buffer as a
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0side effect of this call. */
> >> - =C2=A0 =C2=A0 smb_buffer->smb_buf_length =3D cpu_to_be32(smb_buf=
_length);
> >> + =C2=A0 =C2=A0 /* Don't want to modify the buffer as a side effec=
t of this call. */
> >> + =C2=A0 =C2=A0 *buf_length =3D cpu_to_be32(smb_buf_length);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0}
> >> @@ -256,8 +276,8 @@ smb_send(struct TCP_Server_Info *server, struc=
t smb_hdr *smb_buffer,
> >> =C2=A0 =C2=A0 =C2=A0 return smb_sendv(server, &iov, 1);
> >> =C2=A0}
> >>
> >> -static int
> >> -wait_for_free_request(struct TCP_Server_Info *server, const int l=
ong_op)
> >> +int
> >> +cifs_wait_for_free_request(struct TCP_Server_Info *server, const =
int long_op)
> >> =C2=A0{
> >> =C2=A0 =C2=A0 =C2=A0 if (long_op =3D=3D CIFS_ASYNC_OP) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* oplock breaks =
must not be held up */
> >> @@ -322,8 +342,8 @@ static int allocate_mid(struct cifs_ses *ses, =
struct smb_hdr *in_buf,
> >> =C2=A0 =C2=A0 =C2=A0 return 0;
> >> =C2=A0}
> >>
> >> -static int
> >> -wait_for_response(struct TCP_Server_Info *server, struct mid_q_en=
try *midQ)
> >> +int
> >> +cifs_wait_for_response(struct TCP_Server_Info *server, struct mid=
_q_entry *midQ)
> >> =C2=A0{
> >> =C2=A0 =C2=A0 =C2=A0 int error;
> >>
> >> @@ -335,7 +355,6 @@ wait_for_response(struct TCP_Server_Info *serv=
er, struct mid_q_entry *midQ)
> >> =C2=A0 =C2=A0 =C2=A0 return 0;
> >> =C2=A0}
> >>
> >> -
> >> =C2=A0/*
> >> =C2=A0 * Send a SMB request and set the callback function in the m=
id to handle
> >> =C2=A0 * the result. Caller is responsible for dealing with timeou=
ts.
> >> @@ -349,7 +368,8 @@ cifs_call_async(struct TCP_Server_Info *server=
, struct kvec *iov,
> >> =C2=A0 =C2=A0 =C2=A0 struct mid_q_entry *mid;
> >> =C2=A0 =C2=A0 =C2=A0 struct smb_hdr *hdr =3D (struct smb_hdr *)iov=
[0].iov_base;
> >>
> >> - =C2=A0 =C2=A0 rc =3D wait_for_free_request(server, ignore_pend ?=
 CIFS_ASYNC_OP : 0);
> >> + =C2=A0 =C2=A0 rc =3D cifs_wait_for_free_request(server,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ignore_pend=
 ? CIFS_ASYNC_OP : 0);
> >> =C2=A0 =C2=A0 =C2=A0 if (rc)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >>
> >> @@ -393,7 +413,7 @@ cifs_call_async(struct TCP_Server_Info *server=
, struct kvec *iov,
> >>
> >> =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0out_err:
> >> - =C2=A0 =C2=A0 delete_mid(mid);
> >> + =C2=A0 =C2=A0 cifs_delete_mid(mid);
> >> =C2=A0 =C2=A0 =C2=A0 atomic_dec(&server->inFlight);
> >> =C2=A0 =C2=A0 =C2=A0 wake_up(&server->request_q);
> >> =C2=A0 =C2=A0 =C2=A0 return rc;
> >> @@ -425,7 +445,7 @@ SendReceiveNoRsp(const unsigned int xid, struc=
t cifs_ses *ses,
> >> =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0}
> >>
> >> -static int
> >> +int
> >> =C2=A0cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Ser=
ver_Info *server)
> >> =C2=A0{
> >> =C2=A0 =C2=A0 =C2=A0 int rc =3D 0;
> >> @@ -550,7 +570,7 @@ SendReceive2(const unsigned int xid, struct ci=
fs_ses *ses,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0to the same server. We may make =
this configurable later or
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0use ses->maxReq */
> >>
> >> - =C2=A0 =C2=A0 rc =3D wait_for_free_request(ses->server, long_op)=
;
> >> + =C2=A0 =C2=A0 rc =3D cifs_wait_for_free_request(ses->server, lon=
g_op);
> >> =C2=A0 =C2=A0 =C2=A0 if (rc) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_small_buf_re=
lease(in_buf);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> @@ -596,7 +616,7 @@ SendReceive2(const unsigned int xid, struct ci=
fs_ses *ses,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> - =C2=A0 =C2=A0 rc =3D wait_for_response(ses->server, midQ);
> >> + =C2=A0 =C2=A0 rc =3D cifs_wait_for_response(ses->server, midQ);
> >> =C2=A0 =C2=A0 =C2=A0 if (rc !=3D 0) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 send_nt_cancel(se=
s->server, in_buf, midQ);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&Global=
Mid_Lock);
> >> @@ -636,11 +656,11 @@ SendReceive2(const unsigned int xid, struct =
cifs_ses *ses,
> >>
> >> =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_check_receive(midQ, ses->server, =
flags & CIFS_LOG_ERROR);
> >>
> >> - =C2=A0 =C2=A0 /* mark it so buf will not be freed by delete_mid =
*/
> >> + =C2=A0 =C2=A0 /* mark it so buf will not be freed by cifs_delete=
_mid */
> >> =C2=A0 =C2=A0 =C2=A0 if ((flags & CIFS_NO_RESP) =3D=3D 0)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 midQ->resp_buf =3D=
 NULL;
> >> =C2=A0out:
> >> - =C2=A0 =C2=A0 delete_mid(midQ);
> >> + =C2=A0 =C2=A0 cifs_delete_mid(midQ);
> >> =C2=A0 =C2=A0 =C2=A0 atomic_dec(&ses->server->inFlight);
> >> =C2=A0 =C2=A0 =C2=A0 wake_up(&ses->server->request_q);
> >>
> >> @@ -679,7 +699,7 @@ SendReceive(const unsigned int xid, struct cif=
s_ses *ses,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EIO;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> - =C2=A0 =C2=A0 rc =3D wait_for_free_request(ses->server, long_op)=
;
> >> + =C2=A0 =C2=A0 rc =3D cifs_wait_for_free_request(ses->server, lon=
g_op);
> >> =C2=A0 =C2=A0 =C2=A0 if (rc)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >>
> >> @@ -718,7 +738,7 @@ SendReceive(const unsigned int xid, struct cif=
s_ses *ses,
> >> =C2=A0 =C2=A0 =C2=A0 if (long_op =3D=3D CIFS_ASYNC_OP)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> >>
> >> - =C2=A0 =C2=A0 rc =3D wait_for_response(ses->server, midQ);
> >> + =C2=A0 =C2=A0 rc =3D cifs_wait_for_response(ses->server, midQ);
> >> =C2=A0 =C2=A0 =C2=A0 if (rc !=3D 0) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 send_nt_cancel(se=
s->server, in_buf, midQ);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&Global=
Mid_Lock);
> >> @@ -752,7 +772,7 @@ SendReceive(const unsigned int xid, struct cif=
s_ses *ses,
> >> =C2=A0 =C2=A0 =C2=A0 memcpy(out_buf, buf, *pbytes_returned + 4);
> >> =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_check_receive(midQ, ses->server, =
0);
> >> =C2=A0out:
> >> - =C2=A0 =C2=A0 delete_mid(midQ);
> >> + =C2=A0 =C2=A0 cifs_delete_mid(midQ);
> >> =C2=A0 =C2=A0 =C2=A0 atomic_dec(&ses->server->inFlight);
> >> =C2=A0 =C2=A0 =C2=A0 wake_up(&ses->server->request_q);
> >>
> >> @@ -820,7 +840,7 @@ SendReceiveBlockingLock(const unsigned int xid=
, struct cifs_tcon *tcon,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EIO;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> - =C2=A0 =C2=A0 rc =3D wait_for_free_request(ses->server, CIFS_BLO=
CKING_OP);
> >> + =C2=A0 =C2=A0 rc =3D cifs_wait_for_free_request(ses->server, CIF=
S_BLOCKING_OP);
> >> =C2=A0 =C2=A0 =C2=A0 if (rc)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >>
> >> @@ -838,7 +858,7 @@ SendReceiveBlockingLock(const unsigned int xid=
, struct cifs_tcon *tcon,
> >>
> >> =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_sign_smb(in_buf, ses->server, &mi=
dQ->sequence_number);
> >> =C2=A0 =C2=A0 =C2=A0 if (rc) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 delete_mid(midQ);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_delete_mid(midQ);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&ses=
->server->srv_mutex);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> @@ -851,7 +871,7 @@ SendReceiveBlockingLock(const unsigned int xid=
, struct cifs_tcon *tcon,
> >> =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&ses->server->srv_mutex);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 if (rc < 0) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 delete_mid(midQ);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_delete_mid(midQ);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> @@ -872,7 +892,7 @@ SendReceiveBlockingLock(const unsigned int xid=
, struct cifs_tcon *tcon,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0blocking lock to return. */
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D send_nt_cancel(ses->server, in_buf, midQ);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (rc) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 delete_mid(midQ);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_delete_mid(midQ);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
> >> @@ -884,12 +904,12 @@ SendReceiveBlockingLock(const unsigned int x=
id, struct cifs_tcon *tcon,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /* If we get -ENOLCK back the lock may have
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0already been removed. Don't exit in this case. =
*/
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (rc && rc !=3D -ENOLCK) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 delete_mid(midQ);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_delete_mid(midQ);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D wait_for_respon=
se(ses->server, midQ);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_wait_for_r=
esponse(ses->server, midQ);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 send_nt_cancel(ses->server, in_buf, midQ);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 spin_lock(&GlobalMid_Lock);
> >> @@ -922,7 +942,7 @@ SendReceiveBlockingLock(const unsigned int xid=
, struct cifs_tcon *tcon,
> >> =C2=A0 =C2=A0 =C2=A0 memcpy(out_buf, buf, *pbytes_returned + 4);
> >> =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_check_receive(midQ, ses->server, =
0);
> >> =C2=A0out:
> >> - =C2=A0 =C2=A0 delete_mid(midQ);
> >> + =C2=A0 =C2=A0 cifs_delete_mid(midQ);
> >> =C2=A0 =C2=A0 =C2=A0 if (rstart && rc =3D=3D -EACCES)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ERESTARTS=
YS;
> >> =C2=A0 =C2=A0 =C2=A0 return rc;
> >
> >
> > --
> > Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
