From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 03/22] CIFS: Make transport routines work with SMB2
Date: Wed, 20 Jun 2012 13:46:46 +0400
Message-ID: <CAKywueRpaYGmJ_8MpMTT3L8ULF7ZwR238FrT04mr87Y=u8jz7g@mail.gmail.com>
References: <1340109611-7210-1-git-send-email-pshilovsky@samba.org>
	<1340109611-7210-4-git-send-email-pshilovsky@samba.org>
	<20120619160946.6cb19f74@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120619160946.6cb19f74-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/6/20 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Tue, 19 Jun 2012 16:39:52 +0400
> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/Makefile =A0 =A0 =A0 =A0| =A0 =A02 +-
>> =A0fs/cifs/cifsglob.h =A0 =A0 =A0| =A0 =A05 ++
>> =A0fs/cifs/cifsproto.h =A0 =A0 | =A0 =A03 +-
>> =A0fs/cifs/smb1ops.c =A0 =A0 =A0 | =A0 =A01 +
>> =A0fs/cifs/smb2ops.c =A0 =A0 =A0 | =A0 18 ++++++
>> =A0fs/cifs/smb2pdu.h =A0 =A0 =A0 | =A0 59 ++++++++++++++++++
>> =A0fs/cifs/smb2proto.h =A0 =A0 | =A0 =A05 ++
>> =A0fs/cifs/smb2transport.c | =A0151 ++++++++++++++++++++++++++++++++=
+++++++++++++++
>> =A0fs/cifs/transport.c =A0 =A0 | =A0 13 ++--
>> =A09 files changed, 248 insertions(+), 9 deletions(-)
>> =A0create mode 100644 fs/cifs/smb2transport.c
>>
>> diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
>> index 4a77271..a73d7f8 100644
>> --- a/fs/cifs/Makefile
>> +++ b/fs/cifs/Makefile
>> @@ -16,4 +16,4 @@ cifs-$(CONFIG_CIFS_DFS_UPCALL) +=3D dns_resolve.o =
cifs_dfs_ref.o
>>
>> =A0cifs-$(CONFIG_CIFS_FSCACHE) +=3D fscache.o cache.o
>>
>> -cifs-$(CONFIG_CIFS_SMB2) +=3D smb2ops.o smb2maperror.o
>> +cifs-$(CONFIG_CIFS_SMB2) +=3D smb2ops.o smb2maperror.o smb2transpor=
t.o
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 1266e2e..ae27ab8 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -22,6 +22,7 @@
>> =A0#include <linux/in.h>
>> =A0#include <linux/in6.h>
>> =A0#include <linux/slab.h>
>> +#include <linux/mempool.h>
>> =A0#include <linux/workqueue.h>
>> =A0#include "cifs_fs_sb.h"
>> =A0#include "cifsacl.h"
>> @@ -218,6 +219,7 @@ struct smb_version_values {
>> =A0 =A0 =A0 size_t =A0 =A0 =A0 =A0 =A0header_size;
>> =A0 =A0 =A0 size_t =A0 =A0 =A0 =A0 =A0max_header_size;
>> =A0 =A0 =A0 size_t =A0 =A0 =A0 =A0 =A0read_rsp_size;
>> + =A0 =A0 __le16 =A0 =A0 =A0 =A0 =A0lock_cmd;
>> =A0};
>>
>> =A0#define HEADER_SIZE(server) (server->vals->header_size)
>> @@ -812,6 +814,7 @@ typedef void (mid_callback_t)(struct mid_q_entry=
 *mid);
>> =A0/* one of these for every pending CIFS request to the server */
>> =A0struct mid_q_entry {
>> =A0 =A0 =A0 struct list_head qhead; /* mids waiting on reply from th=
is server */
>> + =A0 =A0 struct TCP_Server_Info *server; /* server corresponding to=
 this mid */
>> =A0 =A0 =A0 __u64 mid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* multiplex id */
>> =A0 =A0 =A0 __u32 pid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* process id */
>> =A0 =A0 =A0 __u32 sequence_number; =A0/* for CIFS signing */
>> @@ -1153,6 +1156,8 @@ void cifs_oplock_break(struct work_struct *wor=
k);
>> =A0extern const struct slow_work_ops cifs_oplock_break_ops;
>> =A0extern struct workqueue_struct *cifsiod_wq;
>>
>> +extern mempool_t *cifs_mid_poolp;
>> +
>> =A0/* Operations for different SMB versions */
>> =A0#define SMB1_VERSION_STRING =A0"1.0"
>> =A0extern struct smb_version_operations smb1_operations;
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 2f4f661..c45adfa 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -36,7 +36,7 @@ extern void cifs_buf_release(void *);
>> =A0extern struct smb_hdr *cifs_small_buf_get(void);
>> =A0extern void cifs_small_buf_release(void *);
>> =A0extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int /* length */)=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int /* length */);
>
> Unneeded change?

Yes :)

>
>> =A0extern unsigned int _GetXid(void);
>> =A0extern void _FreeXid(unsigned int);
>> =A0#define GetXid() =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> @@ -68,6 +68,7 @@ extern char *cifs_compose_mount_options(const char=
 *sb_mountdata,
>> =A0extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *s=
mb_buffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 struct TCP_Server_Info *server);
>> =A0extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
>> +extern void cifs_wake_up_task(struct mid_q_entry *mid);
>> =A0extern int cifs_call_async(struct TCP_Server_Info *server, struct=
 kvec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int nvec=
, mid_receive_t *receive,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_callback_t *c=
allback, void *cbdata,
>> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
>> index 1a3f08c..cd7fbfd 100644
>> --- a/fs/cifs/smb1ops.c
>> +++ b/fs/cifs/smb1ops.c
>> @@ -445,4 +445,5 @@ struct smb_version_values smb1_values =3D {
>> =A0 =A0 =A0 .header_size =3D sizeof(struct smb_hdr),
>> =A0 =A0 =A0 .max_header_size =3D MAX_CIFS_HDR_SIZE,
>> =A0 =A0 =A0 .read_rsp_size =3D sizeof(READ_RSP),
>> + =A0 =A0 .lock_cmd =3D cpu_to_le16(SMB_COM_LOCKING_ANDX),
>> =A0};
>> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>> index f065e89..80d9674 100644
>> --- a/fs/cifs/smb2ops.c
>> +++ b/fs/cifs/smb2ops.c
>> @@ -18,10 +18,28 @@
>> =A0 */
>>
>> =A0#include "cifsglob.h"
>> +#include "smb2pdu.h"
>> +#include "smb2proto.h"
>> +
>> +static __u64
>> +smb2_get_next_mid(struct TCP_Server_Info *server)
>> +{
>> + =A0 =A0 __u64 mid;
>> + =A0 =A0 /* for SMB2 we need the current value */
>> + =A0 =A0 spin_lock(&GlobalMid_Lock);
>> + =A0 =A0 mid =3D server->CurrentMid;
>> + =A0 =A0 server->CurrentMid++;
>
> =A0 =A0 =A0 =A0mid =3D server->CurrentMid++;
>
>> + =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> + =A0 =A0 return mid;
>> +}
>>
>> =A0struct smb_version_operations smb21_operations =3D {
>> + =A0 =A0 .setup_request =3D smb2_setup_request,
>> + =A0 =A0 .check_receive =3D smb2_check_receive,
>> + =A0 =A0 .get_next_mid =3D smb2_get_next_mid,
>> =A0};
>>
>> =A0struct smb_version_values smb21_values =3D {
>> =A0 =A0 =A0 .version_string =3D SMB21_VERSION_STRING,
>> + =A0 =A0 .lock_cmd =3D SMB2_LOCK,
>> =A0};
>> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
>> index d35ac68..ed73201 100644
>> --- a/fs/cifs/smb2pdu.h
>> +++ b/fs/cifs/smb2pdu.h
>> @@ -27,6 +27,65 @@
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
>> +/* List of commands in host endian */
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
>
> I know that this is bikeshedding, but there's little difference betwe=
en
> these names and the ones below. That is going to result in bugs when =
we
> get these mixed up (and we will).
>
> Perhaps you should give the ones above more distinct names --
> SMB2_NEGOTIATE_HE or something? Where _HE means host-endian?
>
>> +/* The same list in little endian */
>> +#define SMB2_NEGOTIATE =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(SMB2=
NEGOTIATE)
>> +#define SMB2_SESSION_SETUP =A0 cpu_to_le16(SMB2SESSION_SETUP)
>> +#define SMB2_LOGOFF =A0 =A0 =A0 =A0 =A0cpu_to_le16(SMB2LOGOFF)
>> +#define SMB2_TREE_CONNECT =A0 =A0cpu_to_le16(SMB2TREE_CONNECT)
>> +#define SMB2_TREE_DISCONNECT cpu_to_le16(SMB2TREE_DISCONNECT)
>> +#define SMB2_CREATE =A0 =A0 =A0 =A0 =A0cpu_to_le16(SMB2CREATE)
>> +#define SMB2_CLOSE =A0 =A0 =A0 =A0 =A0 cpu_to_le16(SMB2CLOSE)
>> +#define SMB2_FLUSH =A0 =A0 =A0 =A0 =A0 cpu_to_le16(SMB2FLUSH)
>> +#define SMB2_READ =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le16(SMB2READ)
>> +#define SMB2_WRITE =A0 =A0 =A0 =A0 =A0 cpu_to_le16(SMB2WRITE)
>> +#define SMB2_LOCK =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le16(SMB2LOCK)
>> +#define SMB2_IOCTL =A0 =A0 =A0 =A0 =A0 cpu_to_le16(SMB2IOCTL)
>> +#define SMB2_CANCEL =A0 =A0 =A0 =A0 =A0cpu_to_le16(SMB2CANCEL)
>> +#define SMB2_ECHO =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le16(SMB2ECHO)
>> +#define SMB2_QUERY_DIRECTORY cpu_to_le16(SMB2QUERY_DIRECTORY)
>> +#define SMB2_CHANGE_NOTIFY =A0 cpu_to_le16(SMB2CHANGE_NOTIFY)
>> +#define SMB2_QUERY_INFO =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le16(SMB2=
QUERY_INFO)
>> +#define SMB2_SET_INFO =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le16(SM=
B2SET_INFO)
>> +#define SMB2_OPLOCK_BREAK =A0 =A0cpu_to_le16(SMB2OPLOCK_BREAK)
>> +
>> +#define NUMBER_OF_SMB2_COMMANDS =A0 =A0 =A00x0013
>> +
>> +/* BB FIXME - analyze following length BB */
>> +#define MAX_SMB2_HDR_SIZE 0x78 /* 4 len + 64 hdr + (2*24 wct) + 2 b=
ct + 2 pad */
>> +
>
> Would it be better to define this in terms of sizeof(SMB2_LARGEST_HEA=
DER_STRUCT) ?

Now we only define smb2_hdr structure - we can fix this value further
than SMB2_LARGEST_HEADER_STRUCT appears.

>
>> +/*
>> =A0 * SMB2 Header Definition
>> =A0 *
>> =A0 * "MBZ" : =A0Must be Zero
>> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
>> index 08249ee..0e59afb 100644
>> --- a/fs/cifs/smb2proto.h
>> +++ b/fs/cifs/smb2proto.h
>> @@ -34,4 +34,9 @@ struct statfs;
>> =A0 */
>> =A0extern int map_smb2_to_linux_error(char *buf, bool log_err);
>>
>> +extern int smb2_check_receive(struct mid_q_entry *mid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct TCP_Ser=
ver_Info *server, bool log_error);
>> +extern int smb2_setup_request(struct cifs_ses *ses, struct kvec *io=
v,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int n=
vec, struct mid_q_entry **ret_mid);
>> +
>> =A0#endif =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* _SMB2PROTO_=
H */
>> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
>> new file mode 100644
>> index 0000000..74830f2
>> --- /dev/null
>> +++ b/fs/cifs/smb2transport.c
>> @@ -0,0 +1,151 @@
>> +/*
>> + * =A0 fs/cifs/smb2transport.c
>> + *
>> + * =A0 Copyright (C) International Business Machines =A0Corp., 2002=
, 2011
>> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Etersoft, 2012
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
>> +/*
>> + * Set message id for the request. Should be called after wait_for_=
free_request
>> + * and when srv_mutex is held. iov array must have at least 1 eleme=
nt.
>> + */
>> +static inline void
>> +smb2_seq_num_into_buf(struct TCP_Server_Info *server, struct kvec *=
iov)
>
> Why pass in a kvec here? Maybe a smb2_hdr pointer instead?

Yes, it makes sense.

>
>> +{
>> + =A0 =A0 ((struct smb2_hdr *)iov[0].iov_base)->MessageId =3D get_ne=
xt_mid(server);
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 temp->server =3D server;
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
>> +int
>> +smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info =
*server,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool log_error)
>> +{
>> + =A0 =A0 unsigned int len =3D get_rfc1002_length(mid->resp_buf);
>> +
>> + =A0 =A0 dump_smb(mid->resp_buf, min_t(u32, 80, len));
>> + =A0 =A0 /* convert the length into a more usable form */
>> + =A0 =A0 /* BB - uncomment with SMB2 signing implementation */
>> + =A0 =A0 /* if ((len > 24) &&
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
>> +smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int nvec, struct mid_q_ent=
ry **ret_mid)
>> +{
>> + =A0 =A0 int rc;
>> + =A0 =A0 struct smb2_hdr *hdr =3D (struct smb2_hdr *)iov[0].iov_bas=
e;
>> + =A0 =A0 struct mid_q_entry *mid;
>> +
>> + =A0 =A0 smb2_seq_num_into_buf(ses->server, iov);
>> +
>> + =A0 =A0 rc =3D smb2_get_mid_entry(ses, hdr, &mid);
>> + =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 /* rc =3D smb2_sign_smb2(iov, nvec, ses->server);
>> + =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 delete_mid(mid); */
>> + =A0 =A0 *ret_mid =3D mid;
>> + =A0 =A0 return rc;
>> +}
>> +
>> +/* BB add missing functions here */
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index 54cd8dd..ea86753 100644
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
>> @@ -65,12 +63,13 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer,=
 struct TCP_Server_Info *server)
>> =A0 =A0 =A0 /* =A0 =A0 =A0do_gettimeofday(&temp->when_sent);*/ /* ea=
sier to use jiffies */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* when mid allocated can be before when=
 sent */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp->when_alloc =3D jiffies;
>> + =A0 =A0 =A0 =A0 =A0 =A0 temp->server =3D server;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
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
>> @@ -83,6 +82,7 @@ void
>> =A0DeleteMidQEntry(struct mid_q_entry *midEntry)
>> =A0{
>> =A0#ifdef CONFIG_CIFS_STATS2
>> + =A0 =A0 __le16 command =3D midEntry->server->vals->lock_cmd;
>> =A0 =A0 =A0 unsigned long now;
>> =A0#endif
>> =A0 =A0 =A0 midEntry->mid_state =3D MID_FREE;
>> @@ -96,8 +96,7 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
>> =A0 =A0 =A0 /* commands taking longer than one second are indication=
s that
>> =A0 =A0 =A0 =A0 =A0something is wrong, unless it is quite a slow lin=
k or server */
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
>
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>



--=20
Best regards,
Pavel Shilovsky.
