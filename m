From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/50] CIFS: Add SMB2 transport routines
Date: Fri, 3 Feb 2012 13:46:39 -0600
Message-ID: <CAH2r5mvxhgmNOrQhiSMwQ4tNUkaqbCBCPXKm-g5G9tBG0NV5fw@mail.gmail.com>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
	<1327048511-2342-5-git-send-email-piastry@etersoft.ru>
	<20120203140007.5a232933@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120203140007.5a232933-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I am not certain that the mid is treated the same semantically, even
discounting the difference in size, in particular collision detection,
so it may be risky to treat the mid identically in each.  I am
interested in other's opinions on this.

Would be interesting to scan through the server code to see whether
they overload the field in Samba server.

On Fri, Feb 3, 2012 at 1:00 PM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> w=
rote:
> On Fri, 20 Jan 2012 12:34:26 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> And simplify smb_sendv to make it process SMB2 requests. It let us
>> send SMB2 negotiate message to the server.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifs_debug.h =A0 =A0| =A0 =A03 +
>> =A0fs/cifs/cifsglob.h =A0 =A0 =A0| =A0 18 +++
>> =A0fs/cifs/cifsproto.h =A0 =A0 | =A0 12 ++-
>> =A0fs/cifs/smb2misc.c =A0 =A0 =A0| =A0 35 ++++++
>> =A0fs/cifs/smb2pdu.h =A0 =A0 =A0 | =A0 59 +++++++++
>> =A0fs/cifs/smb2proto.h =A0 =A0 | =A0 42 +++++++
>> =A0fs/cifs/smb2transport.c | =A0305 ++++++++++++++++++++++++++++++++=
+++++++++++++++
>> =A0fs/cifs/transport.c =A0 =A0 | =A0142 +++++++++++++----------
>> =A08 files changed, 554 insertions(+), 62 deletions(-)
>> =A0create mode 100644 fs/cifs/smb2misc.c
>> =A0create mode 100644 fs/cifs/smb2proto.h
>> =A0create mode 100644 fs/cifs/smb2transport.c
>>
>> diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
>> index 8942b28..e9911bf 100644
>> --- a/fs/cifs/cifs_debug.h
>> +++ b/fs/cifs/cifs_debug.h
>> @@ -33,6 +33,9 @@ void cifs_dump_mids(struct TCP_Server_Info *);
>> =A0#endif
>> =A0extern int traceSMB; =A0 =A0 =A0 =A0 /* flag which enables the fu=
nction below */
>> =A0void dump_smb(struct smb_hdr *, int);
>> +#ifdef CONFIG_CIFS_SMB2
>> +void dump_smb2(struct smb2_hdr *smb_buf, int smb_buf_length);
>> +#endif
>> =A0#define CIFS_INFO =A0 =A00x01
>> =A0#define CIFS_RC =A0 =A0 =A0 =A0 =A0 =A0 =A00x02
>> =A0#define CIFS_TIMER =A0 0x04
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 15c3a92..bb2af48 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -22,11 +22,15 @@
>> =A0#include <linux/in.h>
>> =A0#include <linux/in6.h>
>> =A0#include <linux/slab.h>
>> +#include <linux/mempool.h>
>> =A0#include <linux/workqueue.h>
>> =A0#include "cifs_fs_sb.h"
>> =A0#include "cifsacl.h"
>> =A0#include <crypto/internal/hash.h>
>> =A0#include <linux/scatterlist.h>
>> +#ifdef CONFIG_CIFS_SMB2
>> +#include "smb2pdu.h"
>> +#endif /* CONFIG_CIFS_SMB2 */
>>
>> =A0/*
>> =A0 * The sizes of various internal tables and strings
>> @@ -236,6 +240,12 @@ struct cifs_mnt_data {
>> =A0 =A0 =A0 int flags;
>> =A0};
>>
>> +static inline unsigned int
>> +get_rfc1002_length(void *buf)
>> +{
>> + =A0 =A0 return be32_to_cpu(*((__be32 *)buf));
>> +}
>> +
>> =A0struct TCP_Server_Info {
>> =A0 =A0 =A0 struct list_head tcp_ses_list;
>> =A0 =A0 =A0 struct list_head smb_ses_list;
>> @@ -307,6 +317,9 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 atomic_t in_send; /* requests trying to send */
>> =A0 =A0 =A0 atomic_t num_waiters; =A0 /* blocked waiting to get in s=
endrecv */
>> =A0#endif
>> +#ifdef CONFIG_CIFS_SMB2
>> + =A0 =A0 __u64 current_smb2_mid; =A0 =A0 =A0 =A0 /* multiplex id - =
rotating counter */
>> +#endif
>> =A0};
>>
>> =A0/*
>> @@ -693,6 +706,7 @@ struct mid_q_entry {
>> =A0 =A0 =A0 unsigned long when_sent; /* time when smb send finished =
*/
>> =A0 =A0 =A0 unsigned long when_received; /* when demux complete (tak=
en off wire) */
>> =A0#endif
>> + =A0 =A0 bool is_smb2:1; =A0 =A0 =A0 =A0 /* SMB2 mid */
>> =A0 =A0 =A0 mid_receive_t *receive; /* call receive callback */
>> =A0 =A0 =A0 mid_callback_t *callback; /* call completion callback */
>> =A0 =A0 =A0 void *callback_data; =A0 =A0/* general purpose pointer f=
or callback */
>> @@ -835,6 +849,7 @@ static inline void free_dfs_info_array(struct df=
s_info3_param *param,
>> =A0#define =A0 MID_RETRY_NEEDED =A0 =A0 =A08 /* session closed while=
 this request out */
>> =A0#define =A0 MID_RESPONSE_MALFORMED 0x10
>> =A0#define =A0 MID_SHUTDOWN =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00x20
>> +#define =A0 MID_NO_RESPONSE_NEEDED 0x40
>>
>> =A0/* Types of response buffer returned from SendReceive2 */
>> =A0#define =A0 CIFS_NO_BUFFER =A0 =A0 =A0 =A00 =A0 =A0/* Response bu=
ffer not returned */
>> @@ -843,6 +858,7 @@ static inline void free_dfs_info_array(struct df=
s_info3_param *param,
>> =A0#define =A0 CIFS_IOVEC =A0 =A0 =A0 =A0 =A0 =A04 =A0 =A0/* array o=
f response buffers */
>>
>> =A0/* Type of Request to SendReceive2 */
>> +#define =A0 CIFS_STD_OP =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00
>> =A0#define =A0 CIFS_BLOCKING_OP =A0 =A0 =A01 =A0 =A0/* operation can=
 block */
>> =A0#define =A0 CIFS_ASYNC_OP =A0 =A0 =A0 =A0 2 =A0 =A0/* do not wait=
 for response */
>> =A0#define =A0 CIFS_TIMEOUT_MASK 0x003 =A0 =A0/* only one of above s=
et in req */
>> @@ -1028,4 +1044,6 @@ void cifs_oplock_break(struct work_struct *wor=
k);
>>
>> =A0extern const struct slow_work_ops cifs_oplock_break_ops;
>>
>> +extern mempool_t *cifs_mid_poolp;
>> +
>> =A0#endif =A0 =A0 =A0 /* _CIFS_GLOB_H */
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 6f4e243..d1e30d9 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -36,7 +36,9 @@ extern void cifs_buf_release(void *);
>> =A0extern struct smb_hdr *cifs_small_buf_get(void);
>> =A0extern void cifs_small_buf_release(void *);
>> =A0extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int /* length */)=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int /* length */);
>> +extern int smb_sendv(struct TCP_Server_Info *server, struct kvec *i=
ov,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int n_vec);
>> =A0extern unsigned int _GetXid(void);
>> =A0extern void _FreeXid(unsigned int);
>> =A0#define GetXid() =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> @@ -68,6 +70,14 @@ extern char *cifs_compose_mount_options(const cha=
r *sb_mountdata,
>> =A0extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *s=
mb_buffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 struct TCP_Server_Info *server);
>> =A0extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
>> +extern void cifs_delete_mid(struct mid_q_entry *midEntry);
>> +extern int cifs_sync_mid_result(struct mid_q_entry *mid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct TCP=
_Server_Info *server);
>> +extern int cifs_wait_for_free_request(struct TCP_Server_Info *serve=
r,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 const int long_op);
>> +extern int cifs_wait_for_response(struct TCP_Server_Info *server,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct=
 mid_q_entry *midQ);
>> +extern void cifs_wake_up_task(struct mid_q_entry *mid);
>> =A0extern int cifs_call_async(struct TCP_Server_Info *server, struct=
 kvec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int nvec=
, mid_receive_t *receive,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_callback_t *c=
allback, void *cbdata,
>> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
>> new file mode 100644
>> index 0000000..355fb15
>> --- /dev/null
>> +++ b/fs/cifs/smb2misc.c
>> @@ -0,0 +1,35 @@
>> +/*
>> + * =A0 fs/cifs/smb2misc.c
>> + *
>> + * =A0 Copyright (C) International Business Machines =A0Corp., 2002=
,2011
>> + * =A0 Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
>> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0Pavel Shilovsky (pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org=
) 2012
>> + *
>> + * =A0 This library is free software; you can redistribute it and/o=
r modify
>> + * =A0 it under the terms of the GNU Lesser General Public License =
as published
>> + * =A0 by the Free Software Foundation; either version 2.1 of the L=
icense, or
>> + * =A0 (at your option) any later version.
>> + *
>> + * =A0 This library is distributed in the hope that it will be usef=
ul,
>> + * =A0 but WITHOUT ANY WARRANTY; without even the implied warranty =
of
>> + * =A0 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =A0See
>> + * =A0 the GNU Lesser General Public License for more details.
>> + *
>> + * =A0 You should have received a copy of the GNU Lesser General Pu=
blic License
>> + * =A0 along with this library; if not, write to the Free Software
>> + * =A0 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 021=
11-1307 USA
>> + */
>> +#include <linux/ctype.h>
>> +#include "smb2pdu.h"
>> +#include "cifsglob.h"
>> +#include "cifsproto.h"
>> +#include "smb2proto.h"
>> +#include "cifs_debug.h"
>> +#include "cifs_unicode.h"
>> +#include "smb2status.h"
>> +
>> +void
>> +dump_smb2(struct smb2_hdr *smb_buf, int smb_buf_length)
>> +{
>> + =A0 =A0 dump_smb((struct smb_hdr *)smb_buf, smb_buf_length);
>> +}
>> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
>> index e3e67bb..5ec0c9f 100644
>> --- a/fs/cifs/smb2pdu.h
>> +++ b/fs/cifs/smb2pdu.h
>> @@ -26,6 +26,65 @@
>> =A0#include <net/sock.h>
>>
>> =A0/*
>> + * Note that, due to trying to use names similar to the protocol sp=
ecifications,
>> + * there are many mixed case field names in the structures below. =A0=
Although
>> + * this does not match typical Linux kernel style, it is necessary =
to be
>> + * be able to match against the protocol specfication.
>> + *
>> + * SMB2 commands
>> + * Some commands have minimal (wct=3D0,bcc=3D0), or uninteresting, =
responses
>> + * (ie no useful data other than the SMB error code itself) and are=
 marked such.
>> + * Knowing this helps avoid response buffer allocations and copy in=
 some cases.
>> + */
>> +
>> +/* List is sent on wire as little endian */
>> +#define SMB2_NEGOTIATE =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(0x00=
00)
>> +#define SMB2_SESSION_SETUP =A0 cpu_to_le16(0x0001)
>> +#define SMB2_LOGOFF =A0 =A0 =A0 =A0 =A0cpu_to_le16(0x0002) /* trivi=
al request/resp */
>> +#define SMB2_TREE_CONNECT =A0 =A0cpu_to_le16(0x0003)
>> +#define SMB2_TREE_DISCONNECT cpu_to_le16(0x0004) /* trivial req/res=
p */
>> +#define SMB2_CREATE =A0 =A0 =A0 =A0 =A0cpu_to_le16(0x0005)
>> +#define SMB2_CLOSE =A0 =A0 =A0 =A0 =A0 cpu_to_le16(0x0006)
>> +#define SMB2_FLUSH =A0 =A0 =A0 =A0 =A0 cpu_to_le16(0x0007) /* trivi=
al resp */
>> +#define SMB2_READ =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le16(0x0008)
>> +#define SMB2_WRITE =A0 =A0 =A0 =A0 =A0 cpu_to_le16(0x0009)
>> +#define SMB2_LOCK =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le16(0x000A)
>> +#define SMB2_IOCTL =A0 =A0 =A0 =A0 =A0 cpu_to_le16(0x000B)
>> +#define SMB2_CANCEL =A0 =A0 =A0 =A0 =A0cpu_to_le16(0x000C)
>> +#define SMB2_ECHO =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le16(0x000D)
>> +#define SMB2_QUERY_DIRECTORY cpu_to_le16(0x000E)
>> +#define SMB2_CHANGE_NOTIFY =A0 cpu_to_le16(0x000F)
>> +#define SMB2_QUERY_INFO =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le16(0x00=
10)
>> +#define SMB2_SET_INFO =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le16(0x=
0011)
>> +#define SMB2_OPLOCK_BREAK =A0 =A0cpu_to_le16(0x0012)
>> +
>> +/* Same List of commands in host endian */
>> +#define SMB2NEGOTIATE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00x0000
>> +#define SMB2SESSION_SETUP =A0 =A00x0001
>> +#define SMB2LOGOFF =A0 =A0 =A0 =A0 =A0 0x0002 /* trivial request/re=
sp */
>> +#define SMB2TREE_CONNECT =A0 =A0 0x0003
>> +#define SMB2TREE_DISCONNECT =A00x0004 /* trivial req/resp */
>> +#define SMB2CREATE =A0 =A0 =A0 =A0 =A0 0x0005
>> +#define SMB2CLOSE =A0 =A0 =A0 =A0 =A0 =A00x0006
>> +#define SMB2FLUSH =A0 =A0 =A0 =A0 =A0 =A00x0007 /* trivial resp */
>> +#define SMB2READ =A0 =A0 =A0 =A0 =A0 =A0 0x0008
>> +#define SMB2WRITE =A0 =A0 =A0 =A0 =A0 =A00x0009
>> +#define SMB2LOCK =A0 =A0 =A0 =A0 =A0 =A0 0x000A
>> +#define SMB2IOCTL =A0 =A0 =A0 =A0 =A0 =A00x000B
>> +#define SMB2CANCEL =A0 =A0 =A0 =A0 =A0 0x000C
>> +#define SMB2ECHO =A0 =A0 =A0 =A0 =A0 =A0 0x000D
>> +#define SMB2QUERY_DIRECTORY =A00x000E
>> +#define SMB2CHANGE_NOTIFY =A0 =A00x000F
>> +#define SMB2QUERY_INFO =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x0010
>> +#define SMB2SET_INFO =A0 =A0 =A0 =A0 0x0011
>> +#define SMB2OPLOCK_BREAK =A0 =A0 0x0012
>> +
>> +#define NUMBER_OF_SMB2_COMMANDS =A0 =A0 =A00x0013
>> +
>> +/* BB FIXME - analyze following length BB */
>> +#define MAX_SMB2_HDR_SIZE 0x78 /* 4 len + 64 hdr + (2*24 wct) + 2 b=
ct + 2 pad */
>> +
>> +/*
>> =A0 * SMB2 Header Definition
>> =A0 *
>> =A0 * "MBZ" : =A0Must be Zero
>> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
>> new file mode 100644
>> index 0000000..6cffdf1
>> --- /dev/null
>> +++ b/fs/cifs/smb2proto.h
>> @@ -0,0 +1,42 @@
>> +/*
>> + * =A0 fs/cifs/smb2proto.h
>> + *
>> + * =A0 Copyright (c) International Business Machines =A0Corp., 2002=
, 2011
>> + * =A0 Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
>> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0Pavel Shilovsky (pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org=
) 2012
>> + *
>> + * =A0 This library is free software; you can redistribute it and/o=
r modify
>> + * =A0 it under the terms of the GNU Lesser General Public License =
as published
>> + * =A0 by the Free Software Foundation; either version 2.1 of the L=
icense, or
>> + * =A0 (at your option) any later version.
>> + *
>> + * =A0 This library is distributed in the hope that it will be usef=
ul,
>> + * =A0 but WITHOUT ANY WARRANTY; without even the implied warranty =
of
>> + * =A0 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =A0See
>> + * =A0 the GNU Lesser General Public License for more details.
>> + *
>> + * =A0 You should have received a copy of the GNU Lesser General Pu=
blic License
>> + * =A0 along with this library; if not, write to the Free Software
>> + * =A0 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 021=
11-1307 USA
>> + */
>> +#ifndef _SMB2PROTO_H
>> +#define _SMB2PROTO_H
>> +#include <linux/nls.h>
>> +#include <linux/key-type.h>
>> +
>> +struct statfs;
>> +
>> +/*
>> + *****************************************************************
>> + * All Prototypes
>> + *****************************************************************
>> + */
>> +extern int map_smb2_to_linux_error(struct smb2_hdr *smb2, int logEr=
r);
>> +
>> +extern int smb2_sendrcv2(const unsigned int xid, struct cifs_ses *s=
es,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct kvec *vec, int n=
vec, int *ret_buf_type,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int *status, const int =
flags);
>> +extern int smb2_sendrcv_norsp(const unsigned int xid, struct cifs_s=
es *ses,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb2_hd=
r *in_buf, int flags);
>> +
>> +#endif =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* _SMB2PROTO_H =
*/
>> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
>> new file mode 100644
>> index 0000000..d7f1c05
>> --- /dev/null
>> +++ b/fs/cifs/smb2transport.c
>> @@ -0,0 +1,305 @@
>> +/*
>> + * =A0 fs/cifs/smb2transport.c
>> + *
>> + * =A0 Copyright (C) International Business Machines =A0Corp., 2002=
, 2011
>> + * =A0 Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
>> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0Jeremy Allison (jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org) 2006
>> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0Pavel Shilovsky (pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org=
) 2012
>> + *
>> + * =A0 This library is free software; you can redistribute it and/o=
r modify
>> + * =A0 it under the terms of the GNU Lesser General Public License =
as published
>> + * =A0 by the Free Software Foundation; either version 2.1 of the L=
icense, or
>> + * =A0 (at your option) any later version.
>> + *
>> + * =A0 This library is distributed in the hope that it will be usef=
ul,
>> + * =A0 but WITHOUT ANY WARRANTY; without even the implied warranty =
of
>> + * =A0 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =A0See
>> + * =A0 the GNU Lesser General Public License for more details.
>> + *
>> + * =A0 You should have received a copy of the GNU Lesser General Pu=
blic License
>> + * =A0 along with this library; if not, write to the Free Software
>> + * =A0 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 021=
11-1307 USA
>> + */
>> +
>> +#include <linux/fs.h>
>> +#include <linux/list.h>
>> +#include <linux/wait.h>
>> +#include <linux/net.h>
>> +#include <linux/delay.h>
>> +#include <linux/uaccess.h>
>> +#include <asm/processor.h>
>> +#include <linux/mempool.h>
>> +#include "smb2pdu.h"
>> +#include "cifsglob.h"
>> +#include "cifsproto.h"
>> +#include "smb2proto.h"
>> +#include "cifs_debug.h"
>> +#include "smb2status.h"
>> +
>> +static __u64
>> +smb2_get_mid(struct TCP_Server_Info *server)
>> +{
>> + =A0 =A0 __u64 mid;
>> +
>> + =A0 =A0 spin_lock(&GlobalMid_Lock);
>> + =A0 =A0 mid =3D server->current_smb2_mid++;
>> + =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> + =A0 =A0 return mid;
>> +} /* BB do we eventually need an SMB2 version of this routine? BB *=
/
>> +
>
> current_smb2_mid should be merged with SMB1 server->CurrentMid. Just
> mask off the upper bits for SMB1 before checking for collisions.
>
>> +/*
>> + * Set message id for the request. Should be called after wait_for_=
free_request
>> + * and when srv_mutex is held. iov array must have at least 1 eleme=
nt.
>> + */
>> +static inline void
>> +smb2_seq_num_into_buf(struct TCP_Server_Info *server, struct kvec *=
iov)
>> +{
>> + =A0 =A0 ((struct smb2_hdr *)iov[0].iov_base)->MessageId =3D smb2_g=
et_mid(server);
>> +}
>> +
>> +static struct mid_q_entry *
>> +smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct TCP_Server_Info *server)
>> +{
>> + =A0 =A0 struct mid_q_entry *temp;
>> +
>> + =A0 =A0 if (server =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Null TCP session in smb2_mid_en=
try_alloc");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 temp =3D mempool_alloc(cifs_mid_poolp, GFP_NOFS);
>> + =A0 =A0 if (temp =3D=3D NULL)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return temp;
>> + =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 memset(temp, 0, sizeof(struct mid_q_entry)=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 temp->mid =3D smb_buffer->MessageId; =A0 =A0=
 =A0/* always LE */
>> + =A0 =A0 =A0 =A0 =A0 =A0 temp->pid =3D current->pid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 temp->command =3D smb_buffer->Command; =A0=
 =A0/* Always LE */
>> + =A0 =A0 =A0 =A0 =A0 =A0 temp->when_alloc =3D jiffies;
>> + =A0 =A0 =A0 =A0 =A0 =A0 temp->is_smb2 =3D true;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* The default is for the mid to be sync=
hronous, so the
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* default callback just wakes up the cu=
rrent task.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 temp->callback =3D cifs_wake_up_task;
>> + =A0 =A0 =A0 =A0 =A0 =A0 temp->callback_data =3D current;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 atomic_inc(&midCount);
>> + =A0 =A0 temp->mid_state =3D MID_REQUEST_ALLOCATED;
>> + =A0 =A0 return temp;
>> +}
>> +
>> +static int
>> +smb2_get_mid_entry(struct cifs_ses *ses, struct smb2_hdr *buf,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct mid_q_entry **mid)
>> +{
>> + =A0 =A0 if (ses->server->tcpStatus =3D=3D CifsExiting)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOENT;
>> +
>> + =A0 =A0 if (ses->server->tcpStatus =3D=3D CifsNeedReconnect) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "tcp session dead - return to call=
er to retry");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EAGAIN;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (ses->status !=3D CifsGood) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* check if SMB2 session is bad because we=
 are setting it up */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if ((buf->Command !=3D SMB2_SESSION_SETUP)=
 &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (buf->Command !=3D SMB2_NEGOTIATE)=
)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EAGAIN;
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* else ok - we are setting up session */
>> + =A0 =A0 }
>> + =A0 =A0 *mid =3D smb2_mid_entry_alloc(buf, ses->server);
>> + =A0 =A0 if (*mid =3D=3D NULL)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 spin_lock(&GlobalMid_Lock);
>> + =A0 =A0 list_add_tail(&(*mid)->qhead, &ses->server->pending_mid_q)=
;
>> + =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> + =A0 =A0 return 0;
>> +}
>> +
>> +static int
>> +smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info =
*server,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int receive_len, bool log_=
error)
>> +{
>> + =A0 =A0 unsigned int len =3D get_rfc1002_length(mid->resp_buf);
>> +
>> + =A0 =A0 dump_smb2(mid->resp_buf, min_t(u32, 80, len));
>> + =A0 =A0 /* convert the length into a more usable form */
>> + =A0 =A0 /* BB - uncomment with SMB2 signing implementation */
>> + =A0 =A0 /* if ((receive_len > 24) &&
>> + =A0 =A0 =A0 =A0 (server->sec_mode & (SECMODE_SIGN_REQUIRED|SECMODE=
_SIGN_ENABLED))) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (smb2_verify_signature(mid->resp_buf, s=
erver))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Unexpected SMB =
signature");
>> + =A0 =A0 } */
>> +
>> + =A0 =A0 return map_smb2_to_linux_error(mid->resp_buf, log_error);
>> +}
>> +
>> +int
>> +smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
>> + =A0 =A0 =A0 =A0 =A0 struct kvec *iov, int n_vec, int *presp_buftyp=
e /* ret */,
>> + =A0 =A0 =A0 =A0 =A0 int *status /* ret SMB2 network status code */=
, const int flags)
>> +{
>> + =A0 =A0 int rc =3D 0;
>> + =A0 =A0 int long_op;
>> + =A0 =A0 unsigned int receive_len;
>> + =A0 =A0 struct mid_q_entry *midQ;
>> + =A0 =A0 struct smb2_hdr *buf =3D iov[0].iov_base;
>> +
>> + =A0 =A0 if (status)
>> + =A0 =A0 =A0 =A0 =A0 =A0 *status =3D STATUS_SUCCESS;
>> + =A0 =A0 long_op =3D flags & CIFS_TIMEOUT_MASK;
>> +
>> + =A0 =A0 *presp_buftype =3D CIFS_NO_BUFFER; =A0/* no response buf y=
et */
>> +
>> + =A0 =A0 if ((ses =3D=3D NULL) || (ses->server =3D=3D NULL)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Null session");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (ses->server->tcpStatus =3D=3D CifsExiting) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOENT;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 rc =3D cifs_wait_for_free_request(ses->server, long_op);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Make sure that we sign in the same order that we send=
 on this socket
>> + =A0 =A0 =A0* and avoid races inside tcp sendmsg code that could ca=
use corruption
>> + =A0 =A0 =A0* of smb data.
>> + =A0 =A0 =A0*/
>> +
>> + =A0 =A0 mutex_lock(&ses->server->srv_mutex);
>> +
>> + =A0 =A0 smb2_seq_num_into_buf(ses->server, iov);
>> +
>> + =A0 =A0 rc =3D smb2_get_mid_entry(ses, buf, &midQ);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&ses->server->srv_mutex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->request_q);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> + =A0 =A0 /* rc =3D smb2_sign_smb2(iov, n_vec, ses->server);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&ses->server->srv_mutex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 } */
>> +
>> + =A0 =A0 midQ->mid_state =3D MID_REQUEST_SUBMITTED;
>> + =A0 =A0 cifs_in_send_inc(ses->server);
>> + =A0 =A0 rc =3D smb_sendv(ses->server, iov, n_vec);
>> + =A0 =A0 cifs_in_send_dec(ses->server);
>> + =A0 =A0 cifs_save_when_sent(midQ);
>> +
>> + =A0 =A0 mutex_unlock(&ses->server->srv_mutex);
>> +
>> + =A0 =A0 if (rc < 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (long_op =3D=3D CIFS_ASYNC_OP) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 rc =3D cifs_wait_for_response(ses->server, midQ);
>> + =A0 =A0 if (rc !=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* BB send cancel message */
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (midQ->mid_state =3D=3D MID_REQUEST_SUB=
MITTED) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->callback =3D cifs_de=
lete_mid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Loc=
k);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->requ=
est_q);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 cifs_small_buf_release(buf);
>> +
>> + =A0 =A0 rc =3D cifs_sync_mid_result(midQ, ses->server);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->request_q);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (!midQ->resp_buf || (midQ->mid_state !=3D MID_RESPONSE_=
RECEIVED)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Bad MID state?");
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 buf =3D (struct smb2_hdr *)midQ->resp_buf;
>> + =A0 =A0 receive_len =3D get_rfc1002_length(buf);
>> +
>> + =A0 =A0 if (receive_len > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Frame too large received. =A0Le=
ngth: %d =A0Xid: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 receive_len, xid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 /* rcvd frame is ok */
>> +
>> + =A0 =A0 iov[0].iov_base =3D (char *)buf;
>> + =A0 =A0 iov[0].iov_len =3D receive_len + 4;
>> + =A0 =A0 if (midQ->large_buf)
>> + =A0 =A0 =A0 =A0 =A0 =A0 *presp_buftype =3D CIFS_LARGE_BUFFER;
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 *presp_buftype =3D CIFS_SMALL_BUFFER;
>> +
>> + =A0 =A0 rc =3D smb2_check_receive(midQ, ses->server, receive_len,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags & CI=
=46S_LOG_ERROR);
>> +
>> + =A0 =A0 if (status)
>> + =A0 =A0 =A0 =A0 =A0 =A0 *status =3D le32_to_cpu(buf->Status);
>> +
>> + =A0 =A0 if ((flags & CIFS_NO_RESP) =3D=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* mark it so buf will not be freed by fre=
e_smb2mid */
>> + =A0 =A0 =A0 =A0 =A0 =A0 midQ->resp_buf =3D NULL;
>> +
>> +out:
>> + =A0 =A0 cifs_delete_mid(midQ);
>> + =A0 =A0 wake_up(&ses->server->request_q);
>> + =A0 =A0 return rc;
>> +}
>> +
>
>
> NACK on the cut and paste madness...
>
> This needs to be consolidated with the existing cifs code. Abstract o=
ut
> the pieces that are protocol-specific and have SendReceive2 (or
> whatever you want to name it) call those functions as needed. Ditto f=
or
> many of the functions above this one and probably for the ones below.
>
> Not only will that cut down code duplication but it will also help
> modularize the code and make it easier to debug.
>
> It's just better engineering practice.
>
>
>> +/*
>> + * Send an SMB2 Request. No response info (other than return code) =
needs to
>> + * be parsed.
>> + *
>> + * flags indicate the type of request buffer and how long to wait
>> + * and whether to log NT STATUS code (error) before mapping it to P=
OSIX error.
>> + */
>> +int
>> +smb2_sendrcv_norsp(const unsigned int xid, struct cifs_ses *ses,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb2_hdr *in_buf, int flags)
>> +{
>> + =A0 =A0 int rc;
>> + =A0 =A0 struct kvec iov[1];
>> + =A0 =A0 int resp_buf_type;
>> +
>> + =A0 =A0 iov[0].iov_base =3D (char *)in_buf;
>> + =A0 =A0 iov[0].iov_len =3D get_rfc1002_length(in_buf) + 4;
>> + =A0 =A0 flags |=3D CIFS_NO_RESP;
>> + =A0 =A0 rc =3D smb2_sendrcv2(xid, ses, iov, 1, &resp_buf_type, NUL=
L, flags);
>> + =A0 =A0 /* BB remove the following debug line eventually */
>> + =A0 =A0 cFYI(1, "%s flags %d rc %d", __func__, flags, rc);
>> +
>> + =A0 =A0 return rc;
>> +}
>> +
>> +/* BB add missing functions here */
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index f3f98ad..f7ac3f0 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -35,10 +35,8 @@
>> =A0#include "cifsproto.h"
>> =A0#include "cifs_debug.h"
>>
>> -extern mempool_t *cifs_mid_poolp;
>> -
>> -static void
>> -wake_up_task(struct mid_q_entry *mid)
>> +void
>> +cifs_wake_up_task(struct mid_q_entry *mid)
>> =A0{
>> =A0 =A0 =A0 wake_up_process(mid->callback_data);
>> =A0}
>> @@ -70,7 +68,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, s=
truct TCP_Server_Info *server)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* The default is for the mid to be sy=
nchronous, so the
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* default callback just wakes up the =
current task.
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 temp->callback =3D wake_up_task;
>> + =A0 =A0 =A0 =A0 =A0 =A0 temp->callback =3D cifs_wake_up_task;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp->callback_data =3D current;
>> =A0 =A0 =A0 }
>>
>> @@ -83,7 +81,15 @@ void
>> =A0DeleteMidQEntry(struct mid_q_entry *midEntry)
>> =A0{
>> =A0#ifdef CONFIG_CIFS_STATS2
>> + =A0 =A0 __le16 command;
>> =A0 =A0 =A0 unsigned long now;
>> +
>> +#ifdef CONFIG_CIFS_SMB2
>> + =A0 =A0 if (midEntry->is_smb2)
>> + =A0 =A0 =A0 =A0 =A0 =A0 command =3D SMB2_LOCK;
>> + =A0 =A0 else
>> +#endif
>> + =A0 =A0 =A0 =A0 =A0 =A0 command =3D cpu_to_le16(SMB_COM_LOCKING_AN=
DX);
>> =A0#endif
>> =A0 =A0 =A0 midEntry->mid_state =3D MID_FREE;
>> =A0 =A0 =A0 atomic_dec(&midCount);
>> @@ -98,8 +104,7 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
>> =A0 =A0 =A0 =A0* something is wrong, unless it is quite a slow link =
or server.
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 if ((now - midEntry->when_alloc) > HZ) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if ((cifsFYI & CIFS_TIMER) &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (midEntry->command !=3D cpu_to_le1=
6(SMB_COM_LOCKING_ANDX))) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if ((cifsFYI & CIFS_TIMER) && (midEntry->c=
ommand !=3D command)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_DEBUG " CIFS=
 slow rsp: cmd %d mid %llu",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0midEntry-=
>command, midEntry->mid);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(" A: 0x%lx S: 0x%=
lx R: 0x%lx\n",
>> @@ -112,8 +117,8 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
>> =A0 =A0 =A0 mempool_free(midEntry, cifs_mid_poolp);
>> =A0}
>>
>> -static void
>> -delete_mid(struct mid_q_entry *mid)
>> +void
>> +cifs_delete_mid(struct mid_q_entry *mid)
>> =A0{
>> =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
>> =A0 =A0 =A0 list_del(&mid->qhead);
>> @@ -122,18 +127,24 @@ delete_mid(struct mid_q_entry *mid)
>> =A0 =A0 =A0 DeleteMidQEntry(mid);
>> =A0}
>>
>> -static int
>> +int
>> =A0smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n=
_vec)
>> =A0{
>> =A0 =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 int i =3D 0;
>> =A0 =A0 =A0 struct msghdr smb_msg;
>> + =A0 =A0 __be32 *buf_length =3D (__be32 *)iov[0].iov_base;
>> =A0 =A0 =A0 struct smb_hdr *smb_buffer =3D iov[0].iov_base;
>> +#ifdef CONFIG_CIFS_SMB2
>> + =A0 =A0 struct smb2_hdr *smb2_buffer =3D iov[0].iov_base;
>> +#endif
>> =A0 =A0 =A0 unsigned int len =3D iov[0].iov_len;
>> =A0 =A0 =A0 unsigned int total_len;
>> =A0 =A0 =A0 int first_vec =3D 0;
>> - =A0 =A0 unsigned int smb_buf_length =3D be32_to_cpu(smb_buffer->sm=
b_buf_length);
>> =A0 =A0 =A0 struct socket *ssocket =3D server->ssocket;
>> + =A0 =A0 unsigned int smb_buf_length;
>> +
>> + =A0 =A0 smb_buf_length =3D get_rfc1002_length(iov[0].iov_base);
>>
>> =A0 =A0 =A0 if (ssocket =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOTSOCK; /* BB eventually add r=
econnect code here */
>> @@ -152,7 +163,12 @@ smb_sendv(struct TCP_Server_Info *server, struc=
t kvec *iov, int n_vec)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_len +=3D iov[i].iov_len;
>>
>> =A0 =A0 =A0 cFYI(1, "Sending smb: =A0total_len %d", total_len);
>> - =A0 =A0 dump_smb(smb_buffer, len);
>> +#ifdef CONFIG_CIFS_SMB2
>> + =A0 =A0 if (server->is_smb2)
>> + =A0 =A0 =A0 =A0 =A0 =A0 dump_smb2(smb2_buffer, len);
>> + =A0 =A0 else
>> +#endif
>> + =A0 =A0 =A0 =A0 =A0 =A0 dump_smb(smb_buffer, len);
>>
>> =A0 =A0 =A0 i =3D 0;
>> =A0 =A0 =A0 while (total_len) {
>> @@ -160,24 +176,25 @@ smb_sendv(struct TCP_Server_Info *server, stru=
ct kvec *iov, int n_vec)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
n_vec - first_vec, total_len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((rc =3D=3D -ENOSPC) || (rc =3D=3D -E=
AGAIN)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i++;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* if blocking send we try=
 3 times, since each can block
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for 5 seconds. For =
nonblocking =A0we have to try more
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0but wait increasing=
 amounts of time allowing time for
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0socket to clear. =A0=
The overall time we wait in either
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case to send on the=
 socket is about 15 seconds.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Similarly we wait f=
or 15 seconds for
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0a response from the=
 server in SendReceive[2]
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for the server to s=
end a response back for
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0most types of reque=
sts (except SMB Write
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0past end of file wh=
ich can be slow, and
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blocking lock opera=
tions). NFS waits slightly longer
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0than CIFS, but this=
 can make it take longer for
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nonresponsive serve=
rs to be detected and 15 seconds
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0is more than enough=
 time for modern networks to
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0send a packet. =A0I=
n most cases if we fail to send
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0after the retries w=
e will kill the socket and
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0reconnect which may=
 clear the network problem.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If blocking send we t=
ry 3 times, since each can block
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* for 5 seconds. For no=
nblocking =A0we have to try more
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* but wait increasing a=
mounts of time allowing time for
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* socket to clear. =A0T=
he overall time we wait in either
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* case to send on the s=
ocket is about 15 seconds.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Similarly we wait for=
 15 seconds for
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* a response from the s=
erver in SendReceive[2]
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* for the server to sen=
d a response back for
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* most types of request=
s (except SMB Write
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* past end of file whic=
h can be slow, and
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* blocking lock operati=
ons). NFS waits slightly longer
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* than CIFS, but this c=
an make it take longer for
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* nonresponsive servers=
 to be detected and 15 seconds
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* is more than enough t=
ime for modern networks to
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* send a packet. =A0In =
most cases if we fail to send
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* after the retries we =
will kill the socket and
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* reconnect which may c=
lear the network problem.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((i >=3D 14) || (!ser=
ver->noblocksnd && (i > 2))) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1=
, "sends on sock %p stuck for 15 seconds",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
ssocket);
>> @@ -198,8 +215,10 @@ smb_sendv(struct TCP_Server_Info *server, struc=
t kvec *iov, int n_vec)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* should never happen, le=
tting socket clear before
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0retrying is our onl=
y obvious option here */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Should never happen, =
letting socket clear before
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* retrying is our only =
obvious option here.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "tcp sent no d=
ata");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep(500);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> @@ -225,10 +244,12 @@ smb_sendv(struct TCP_Server_Info *server, stru=
ct kvec *iov, int n_vec)
>> =A0 =A0 =A0 if ((total_len > 0) && (total_len !=3D smb_buf_length + =
4)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "partial send (%d remaining), te=
rminating session",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_len);
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* If we have only sent part of an SMB the=
n the next SMB
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0could be taken as the remainder of =
this one. =A0We need
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0to kill the socket so the server th=
rows away the partial
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SMB */
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* If we have only sent part of an SMB t=
hen the next SMB
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* could be taken as the remainder of th=
is one. =A0We need
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* to kill the socket so the server thro=
ws away the partial
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* SMB.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->tcpStatus =3D CifsNeedReconnect;
>> =A0 =A0 =A0 }
>>
>> @@ -237,9 +258,8 @@ smb_sendv(struct TCP_Server_Info *server, struct=
 kvec *iov, int n_vec)
>> =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
>>
>> - =A0 =A0 /* Don't want to modify the buffer as a
>> - =A0 =A0 =A0 =A0side effect of this call. */
>> - =A0 =A0 smb_buffer->smb_buf_length =3D cpu_to_be32(smb_buf_length)=
;
>> + =A0 =A0 /* Don't want to modify the buffer as a side effect of thi=
s call. */
>> + =A0 =A0 *buf_length =3D cpu_to_be32(smb_buf_length);
>>
>> =A0 =A0 =A0 return rc;
>> =A0}
>> @@ -256,8 +276,8 @@ smb_send(struct TCP_Server_Info *server, struct =
smb_hdr *smb_buffer,
>> =A0 =A0 =A0 return smb_sendv(server, &iov, 1);
>> =A0}
>>
>> -static int
>> -wait_for_free_request(struct TCP_Server_Info *server, const int lon=
g_op)
>> +int
>> +cifs_wait_for_free_request(struct TCP_Server_Info *server, const in=
t long_op)
>> =A0{
>> =A0 =A0 =A0 if (long_op =3D=3D CIFS_ASYNC_OP) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* oplock breaks must not be held up */
>> @@ -322,8 +342,8 @@ static int allocate_mid(struct cifs_ses *ses, st=
ruct smb_hdr *in_buf,
>> =A0 =A0 =A0 return 0;
>> =A0}
>>
>> -static int
>> -wait_for_response(struct TCP_Server_Info *server, struct mid_q_entr=
y *midQ)
>> +int
>> +cifs_wait_for_response(struct TCP_Server_Info *server, struct mid_q=
_entry *midQ)
>> =A0{
>> =A0 =A0 =A0 int error;
>>
>> @@ -335,7 +355,6 @@ wait_for_response(struct TCP_Server_Info *server=
, struct mid_q_entry *midQ)
>> =A0 =A0 =A0 return 0;
>> =A0}
>>
>> -
>> =A0/*
>> =A0 * Send a SMB request and set the callback function in the mid to=
 handle
>> =A0 * the result. Caller is responsible for dealing with timeouts.
>> @@ -349,7 +368,8 @@ cifs_call_async(struct TCP_Server_Info *server, =
struct kvec *iov,
>> =A0 =A0 =A0 struct mid_q_entry *mid;
>> =A0 =A0 =A0 struct smb_hdr *hdr =3D (struct smb_hdr *)iov[0].iov_bas=
e;
>>
>> - =A0 =A0 rc =3D wait_for_free_request(server, ignore_pend ? CIFS_AS=
YNC_OP : 0);
>> + =A0 =A0 rc =3D cifs_wait_for_free_request(server,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 ignore_pend ? CIFS_ASYNC_OP : 0);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> @@ -393,7 +413,7 @@ cifs_call_async(struct TCP_Server_Info *server, =
struct kvec *iov,
>>
>> =A0 =A0 =A0 return rc;
>> =A0out_err:
>> - =A0 =A0 delete_mid(mid);
>> + =A0 =A0 cifs_delete_mid(mid);
>> =A0 =A0 =A0 atomic_dec(&server->inFlight);
>> =A0 =A0 =A0 wake_up(&server->request_q);
>> =A0 =A0 =A0 return rc;
>> @@ -425,7 +445,7 @@ SendReceiveNoRsp(const unsigned int xid, struct =
cifs_ses *ses,
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> -static int
>> +int
>> =A0cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_I=
nfo *server)
>> =A0{
>> =A0 =A0 =A0 int rc =3D 0;
>> @@ -550,7 +570,7 @@ SendReceive2(const unsigned int xid, struct cifs=
_ses *ses,
>> =A0 =A0 =A0 =A0 =A0to the same server. We may make this configurable=
 later or
>> =A0 =A0 =A0 =A0 =A0use ses->maxReq */
>>
>> - =A0 =A0 rc =3D wait_for_free_request(ses->server, long_op);
>> + =A0 =A0 rc =3D cifs_wait_for_free_request(ses->server, long_op);
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(in_buf);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> @@ -596,7 +616,7 @@ SendReceive2(const unsigned int xid, struct cifs=
_ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 rc =3D wait_for_response(ses->server, midQ);
>> + =A0 =A0 rc =3D cifs_wait_for_response(ses->server, midQ);
>> =A0 =A0 =A0 if (rc !=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 send_nt_cancel(ses->server, in_buf, midQ=
);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
>> @@ -636,11 +656,11 @@ SendReceive2(const unsigned int xid, struct ci=
fs_ses *ses,
>>
>> =A0 =A0 =A0 rc =3D cifs_check_receive(midQ, ses->server, flags & CIF=
S_LOG_ERROR);
>>
>> - =A0 =A0 /* mark it so buf will not be freed by delete_mid */
>> + =A0 =A0 /* mark it so buf will not be freed by cifs_delete_mid */
>> =A0 =A0 =A0 if ((flags & CIFS_NO_RESP) =3D=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->resp_buf =3D NULL;
>> =A0out:
>> - =A0 =A0 delete_mid(midQ);
>> + =A0 =A0 cifs_delete_mid(midQ);
>> =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
>> =A0 =A0 =A0 wake_up(&ses->server->request_q);
>>
>> @@ -679,7 +699,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 rc =3D wait_for_free_request(ses->server, long_op);
>> + =A0 =A0 rc =3D cifs_wait_for_free_request(ses->server, long_op);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> @@ -718,7 +738,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>> =A0 =A0 =A0 if (long_op =3D=3D CIFS_ASYNC_OP)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>
>> - =A0 =A0 rc =3D wait_for_response(ses->server, midQ);
>> + =A0 =A0 rc =3D cifs_wait_for_response(ses->server, midQ);
>> =A0 =A0 =A0 if (rc !=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 send_nt_cancel(ses->server, in_buf, midQ=
);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
>> @@ -752,7 +772,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>> =A0 =A0 =A0 memcpy(out_buf, buf, *pbytes_returned + 4);
>> =A0 =A0 =A0 rc =3D cifs_check_receive(midQ, ses->server, 0);
>> =A0out:
>> - =A0 =A0 delete_mid(midQ);
>> + =A0 =A0 cifs_delete_mid(midQ);
>> =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
>> =A0 =A0 =A0 wake_up(&ses->server->request_q);
>>
>> @@ -820,7 +840,7 @@ SendReceiveBlockingLock(const unsigned int xid, =
struct cifs_tcon *tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 rc =3D wait_for_free_request(ses->server, CIFS_BLOCKING_OP=
);
>> + =A0 =A0 rc =3D cifs_wait_for_free_request(ses->server, CIFS_BLOCKI=
NG_OP);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> @@ -838,7 +858,7 @@ SendReceiveBlockingLock(const unsigned int xid, =
struct cifs_tcon *tcon,
>>
>> =A0 =A0 =A0 rc =3D cifs_sign_smb(in_buf, ses->server, &midQ->sequenc=
e_number);
>> =A0 =A0 =A0 if (rc) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 delete_mid(midQ);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_delete_mid(midQ);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&ses->server->srv_mutex);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>> @@ -851,7 +871,7 @@ SendReceiveBlockingLock(const unsigned int xid, =
struct cifs_tcon *tcon,
>> =A0 =A0 =A0 mutex_unlock(&ses->server->srv_mutex);
>>
>> =A0 =A0 =A0 if (rc < 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 delete_mid(midQ);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_delete_mid(midQ);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>>
>> @@ -872,7 +892,7 @@ SendReceiveBlockingLock(const unsigned int xid, =
struct cifs_tcon *tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blocking lock to =
return. */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D send_nt_cancel(se=
s->server, in_buf, midQ);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 delete_mid=
(midQ);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_delet=
e_mid(midQ);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return r=
c;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> @@ -884,12 +904,12 @@ SendReceiveBlockingLock(const unsigned int xid=
, struct cifs_tcon *tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If we get -ENOLCK bac=
k the lock may have
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0already been remo=
ved. Don't exit in this case. */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc && rc !=3D -ENOLC=
K) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 delete_mid=
(midQ);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_delet=
e_mid(midQ);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return r=
c;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wait_for_response(ses->server, midQ=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_wait_for_response(ses->server,=
 midQ);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 send_nt_cancel(ses->serv=
er, in_buf, midQ);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Loc=
k);
>> @@ -922,7 +942,7 @@ SendReceiveBlockingLock(const unsigned int xid, =
struct cifs_tcon *tcon,
>> =A0 =A0 =A0 memcpy(out_buf, buf, *pbytes_returned + 4);
>> =A0 =A0 =A0 rc =3D cifs_check_receive(midQ, ses->server, 0);
>> =A0out:
>> - =A0 =A0 delete_mid(midQ);
>> + =A0 =A0 cifs_delete_mid(midQ);
>> =A0 =A0 =A0 if (rstart && rc =3D=3D -EACCES)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ERESTARTSYS;
>> =A0 =A0 =A0 return rc;
>
>
> --
> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
