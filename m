From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 07/24] CIFS: Make demultiplex_thread work with SMB2 code
Date: Fri, 22 Jun 2012 18:59:23 +0400
Message-ID: <CAKywueRCTr8bva4tX42JHH=j88i3t5+E0GNrVbKwhwp9hJScPg@mail.gmail.com>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
	<1340202664-28696-8-git-send-email-pshilovsky@samba.org>
	<20120621114437.72a9483d@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120621114437.72a9483d-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/6/21 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Wed, 20 Jun 2012 18:30:47 +0400
> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> Now we can process SMB2 messages: check message, get message id
>> and wakeup awaiting routines.
>>
>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/Makefile =A0 =A0 | =A0 =A02 +-
>> =A0fs/cifs/cifs_debug.c | =A0 =A02 +-
>> =A0fs/cifs/smb2misc.c =A0 | =A0304 +++++++++++++++++++++++++++++++++=
+++++++++++++++++
>> =A0fs/cifs/smb2ops.c =A0 =A0| =A0 37 ++++++
>> =A0fs/cifs/smb2pdu.h =A0 =A0| =A0 30 +++++
>> =A0fs/cifs/smb2proto.h =A0| =A0 =A02 +
>> =A06 files changed, 375 insertions(+), 2 deletions(-)
>> =A0create mode 100644 fs/cifs/smb2misc.c
>>
>> diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
>> index a73d7f8..b77e9ec 100644
>> --- a/fs/cifs/Makefile
>> +++ b/fs/cifs/Makefile
>> @@ -16,4 +16,4 @@ cifs-$(CONFIG_CIFS_DFS_UPCALL) +=3D dns_resolve.o =
cifs_dfs_ref.o
>>
>> =A0cifs-$(CONFIG_CIFS_FSCACHE) +=3D fscache.o cache.o
>>
>> -cifs-$(CONFIG_CIFS_SMB2) +=3D smb2ops.o smb2maperror.o smb2transpor=
t.o
>> +cifs-$(CONFIG_CIFS_SMB2) +=3D smb2ops.o smb2maperror.o smb2transpor=
t.o smb2misc.o
>> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
>> index e814052..8aa8693 100644
>> --- a/fs/cifs/cifs_debug.c
>> +++ b/fs/cifs/cifs_debug.c
>> @@ -65,7 +65,7 @@ void cifs_dump_detail(void *buf)
>> =A0 =A0 =A0 cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid=
: %d Pid: %d",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb->Command, smb->Status.CifsError,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb->Flags, smb->Flags2, smb->Mid, s=
mb->Pid);
>> - =A0 =A0 cERROR(1, "smb buf %p len %d", smb, smbCalcSize(smb));
>> + =A0 =A0 cERROR(1, "smb buf %p len %u", smb, smbCalcSize(smb));
>> =A0#endif /* CONFIG_CIFS_DEBUG2 */
>> =A0}
>>
>> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
>> new file mode 100644
>> index 0000000..03167eb
>> --- /dev/null
>> +++ b/fs/cifs/smb2misc.c
>> @@ -0,0 +1,304 @@
>> +/*
>> + * =A0 fs/cifs/smb2misc.c
>> + *
>> + * =A0 Copyright (C) International Business Machines =A0Corp., 2002=
,2011
>> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Etersoft, 2012
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
>> +static int
>> +check_smb2_hdr(struct smb2_hdr *hdr, __u64 mid)
>> +{
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Make sure that this really is an SMB, that it is a re=
sponse,
>> + =A0 =A0 =A0* and that the message ids match
>> + =A0 =A0 =A0*/
>> + =A0 =A0 if ((*(__le32 *)hdr->ProtocolId =3D=3D cpu_to_le32(0x424d5=
3fe)) &&
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0... =3D=3D __constant_=
cpu_to_le32()
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0It would also be good to turn that int=
o a #define'ed constant and use it in the check below.
>
>> + =A0 =A0 =A0 =A0 (mid =3D=3D hdr->MessageId)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (hdr->Flags & SMB2_FLAGS_SERVER_TO_REDI=
R)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* only one valid case whe=
re server sends us request */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (hdr->Command =3D=3D SM=
B2_OPLOCK_BREAK)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, =
"Received Request not response");
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 } else { /* bad signature or mid */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (*(__le32 *)hdr->ProtocolId !=3D cpu_to=
_le32(0x424d53fe))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Bad protocol st=
ring signature header %x",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*(unsigned =
int *) hdr->ProtocolId);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (mid !=3D hdr->MessageId)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Mids do not mat=
ch");
>> + =A0 =A0 }
>> + =A0 =A0 cERROR(1, "Bad SMB detected. The Mid=3D%llu", hdr->Message=
Id);
>> + =A0 =A0 return 1;
>> +}
>> +
>> +/*
>> + * =A0The following table defines the expected "StructureSize" of S=
MB2 responses
>> + * =A0in order by SMB2 command. =A0This is similar to "wct" in SMB/=
CIFS responses.
>> + *
>> + * =A0Note that commands are defined in smb2pdu.h in le16 but the a=
rray below is
>> + * =A0indexed by command in host byte order
>> + */
>> +static const int smb2_rsp_struct_sizes[NUMBER_OF_SMB2_COMMANDS] =3D=
 {
>> + =A0 =A0 /* SMB2_NEGOTIATE */ 65,
>> + =A0 =A0 /* SMB2_SESSION_SETUP */ 9,
>> + =A0 =A0 /* SMB2_LOGOFF */ 4,
>> + =A0 =A0 /* SMB2_TREE_CONNECT */ 16,
>> + =A0 =A0 /* SMB2_TREE_DISCONNECT */ 4,
>> + =A0 =A0 /* SMB2_CREATE */ 89,
>> + =A0 =A0 /* SMB2_CLOSE */ 60,
>> + =A0 =A0 /* SMB2_FLUSH */ 4,
>> + =A0 =A0 /* SMB2_READ */ 17,
>> + =A0 =A0 /* SMB2_WRITE */ 17,
>> + =A0 =A0 /* SMB2_LOCK */ 4,
>> + =A0 =A0 /* SMB2_IOCTL */ 49,
>> + =A0 =A0 /* SMB2_CANCEL */ 0, /* BB CHECK this ... not listed in do=
cumentation */
>> + =A0 =A0 /* SMB2_ECHO */ 4,
>> + =A0 =A0 /* SMB2_QUERY_DIRECTORY */ 9,
>> + =A0 =A0 /* SMB2_CHANGE_NOTIFY */ 9,
>> + =A0 =A0 /* SMB2_QUERY_INFO */ 9,
>> + =A0 =A0 /* SMB2_SET_INFO */ 2,
>> + =A0 =A0 /* SMB2_OPLOCK_BREAK */ 24 /* BB FIXME can also be 44 for =
lease break */
>> +};
>> +
>
> It might save a few cycles (and memory) to make the above an array of
> __le16's and go ahead and __constant_cpu_to_le16 the values. Then you
> wouldn't need to convert the values in the headers below.

Yes, make sense.

>
>> +int
>> +smb2_check_message(char *buf, unsigned int length)
>> +{
>> + =A0 =A0 struct smb2_hdr *hdr =3D (struct smb2_hdr *)buf;
>> + =A0 =A0 struct smb2_pdu *pdu =3D (struct smb2_pdu *)hdr;
>> + =A0 =A0 __u64 mid =3D hdr->MessageId;
>> + =A0 =A0 __u32 len =3D get_rfc1002_length(buf);
>> + =A0 =A0 __u32 clc_len; =A0/* calculated length */
>> + =A0 =A0 int command;
>> +
>> + =A0 =A0 /* BB disable following printk later */
>> + =A0 =A0 cFYI(1, "checkSMB Length: 0x%x, smb_buf_length: 0x%x", len=
gth, len);
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Add function to do table lookup of StructureSize by c=
ommand
>> + =A0 =A0 =A0* ie Validate the wct via smb2_struct_sizes table above
>> + =A0 =A0 =A0*/
>> +
>> + =A0 =A0 if (length < 2 + sizeof(struct smb2_hdr)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if ((length >=3D sizeof(struct smb2_hdr)) =
&& (hdr->Status !=3D 0)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdu->StructureSize2 =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* As with SMB/CIFS, on =
some error cases servers may
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* not return wct proper=
ly
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Length less tha=
n smb header size");
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 }
>> + =A0 =A0 if (len > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE - 4) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "smb length greater than maximum=
, mid=3D%lld", mid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (check_smb2_hdr(hdr, mid))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> +
>> + =A0 =A0 if (le16_to_cpu(hdr->StructureSize) !=3D 64) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Illegal structure size %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le16_to_cpu(hdr->Struc=
tureSize));
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 command =3D le16_to_cpu(hdr->Command);
>> + =A0 =A0 if (command >=3D NUMBER_OF_SMB2_COMMANDS) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "illegal SMB2 command %d", comma=
nd);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (smb2_rsp_struct_sizes[command] !=3D
>> + =A0 =A0 =A0 =A0 le16_to_cpu(pdu->StructureSize2)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if ((hdr->Status =3D=3D 0) ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (le16_to_cpu(pdu->StructureSize2) =
!=3D 9)) {
> The 9 here should probably be a preprocessor constant:
>
> =A0 =A0#define SMB2_ERROR_STRUCTURE_SIZE2 =A0__constant_le16_to_cpu(9=
)
>
> Then you could just compare that to a bare pdu->StructureSize2
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* error packets have 9 by=
te structure size */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Illegal respons=
e size %d for command %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le1=
6_to_cpu(pdu->StructureSize2), command);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 clc_len =3D smb2_calc_size(hdr);
>> +
>> + =A0 =A0 if (4 + len !=3D length) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Length read does not match RFC1=
001 length %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 }
>
>
> Does RFC1001 apply here? The error message above could be clearer.
>
>> +
>> + =A0 =A0 if (4 + len !=3D clc_len) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Calculated size %d length %d mism=
atch for mid %lld",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0clc_len, 4 + len, mid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (clc_len =3D=3D 4 + len + 1) /* BB FIXM=
E (fix samba) */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0; /* BB workaround=
 Samba 3 bug SessSetup rsp */
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 }
>> + =A0 =A0 return 0;
>> +}
>> +
>> +/*
>> + * =A0The size of the variable area depends on the offset and lengt=
h fields
>> + * =A0located in different fields for various SMB2 responses. =A0SM=
B2 responses
>> + * =A0with no variable length info, show an offset of zero for the =
offset field.
>> + */
>> +static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] =3D {
>> + =A0 =A0 /* SMB2_NEGOTIATE */ true,
>> + =A0 =A0 /* SMB2_SESSION_SETUP */ true,
>> + =A0 =A0 /* SMB2_LOGOFF */ false,
>> + =A0 =A0 /* SMB2_TREE_CONNECT */ false,
>> + =A0 =A0 /* SMB2_TREE_DISCONNECT */ false,
>> + =A0 =A0 /* SMB2_CREATE */ true,
>> + =A0 =A0 /* SMB2_CLOSE */ false,
>> + =A0 =A0 /* SMB2_FLUSH */ false,
>> + =A0 =A0 /* SMB2_READ */ true,
>> + =A0 =A0 /* SMB2_WRITE */ false,
>> + =A0 =A0 /* SMB2_LOCK */ false,
>> + =A0 =A0 /* SMB2_IOCTL */ true,
>> + =A0 =A0 /* SMB2_CANCEL */ false, /* BB CHECK this not listed in do=
cumentation */
>> + =A0 =A0 /* SMB2_ECHO */ false,
>> + =A0 =A0 /* SMB2_QUERY_DIRECTORY */ true,
>> + =A0 =A0 /* SMB2_CHANGE_NOTIFY */ true,
>> + =A0 =A0 /* SMB2_QUERY_INFO */ true,
>> + =A0 =A0 /* SMB2_SET_INFO */ false,
>> + =A0 =A0 /* SMB2_OPLOCK_BREAK */ false
>> +};
>> +
>> +/*
>> + * Returns the pointer to the beginning of the data area. Length of=
 the data
>> + * area and the offset to it (from the beginning of the smb are als=
o returned.
>> + */
>> +static char *
>> +smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
>> +{
>> + =A0 =A0 *off =3D 0;
>> + =A0 =A0 *len =3D 0;
>> +
>> + =A0 =A0 /* error responses do not have data area */
>> + =A0 =A0 if (hdr->Status &&
>> + =A0 =A0 =A0 =A0(le32_to_cpu(hdr->Status) !=3D STATUS_MORE_PROCESSI=
NG_REQUIRED) &&
>
> I wonder...should we also convert the STATUS_* constants to LE values=
?
> That would save a few cycles on BE machines...

In this case we should probably convert nterr.h too -- Steve, what do y=
ou think?


>
>> + =A0 =A0 =A0 =A0(le16_to_cpu(((struct smb2_err_rsp *)hdr)->Structur=
eSize) =3D=3D 9))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Following commands have data areas so we have to get =
the location
>> + =A0 =A0 =A0* of the data buffer offset and data buffer length for =
the particular
>> + =A0 =A0 =A0* command.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 switch (hdr->Command) {
>> + =A0 =A0 case SMB2_NEGOTIATE:
>> + =A0 =A0 case SMB2_SESSION_SETUP:
>> + =A0 =A0 case SMB2_CREATE:
>> + =A0 =A0 case SMB2_READ:
>> + =A0 =A0 case SMB2_QUERY_INFO:
>> + =A0 =A0 case SMB2_QUERY_DIRECTORY:
>> + =A0 =A0 case SMB2_IOCTL:
>> + =A0 =A0 case SMB2_CHANGE_NOTIFY:
>> + =A0 =A0 default:
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* BB FIXME for unimplemented cases above =
*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "no length check for command");
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Invalid length or offset probably means data area is =
invalid, but
>> + =A0 =A0 =A0* we have little choice but to ignore the data area in =
this case.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 if (*off > 4096) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 dump_stack();
>
> Is a stack trace likely to be helpful here? I wouldn't think so...
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "offset %d too large, data area =
ignored", *off);
>> + =A0 =A0 =A0 =A0 =A0 =A0 *len =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 *off =3D 0;
>> + =A0 =A0 } else if (*off < 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "negative offset to data invalid=
 ignore data area");
>
> Printing the actual value might be helpful.
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 *off =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 *len =3D 0;
>> + =A0 =A0 } else if (*len < 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "negative data length invalid, d=
ata area ignored");
>
> Ditto...
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 *len =3D 0;
>> + =A0 =A0 } else if (*len > 128 * 1024) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "data area larger than 128K");
>
> How big was it?
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 *len =3D 0;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 /* return pointer to beginning of data area, ie offset fro=
m SMB start */
>> + =A0 =A0 if ((*off !=3D 0) && (*len !=3D 0))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return hdr->ProtocolId + *off;
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> +}
>> +
>> +/*
>> + * Calculate the size of the SMB message based on the fixed header
>> + * portion, the number of word parameters and the data portion of t=
he message.
>> + */
>> +unsigned int
>> +smb2_calc_size(struct smb2_hdr *hdr)
>> +{
>> + =A0 =A0 struct smb2_pdu *pdu =3D (struct smb2_pdu *)hdr;
>> + =A0 =A0 int offset; /* the offset from the beginning of SMB to dat=
a area */
>> + =A0 =A0 int data_length; /* the length of the variable length data=
 area */
>> + =A0 =A0 /* Structure Size has already been checked to make sure it=
 is 64 */
>> + =A0 =A0 int len =3D 4 + le16_to_cpu(pdu->hdr.StructureSize);
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* StructureSize2, ie length of fixed parameter area has=
 already
>> + =A0 =A0 =A0* been checked to make sure it is the correct length.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 len +=3D le16_to_cpu(pdu->StructureSize2);
>> +
>> + =A0 =A0 if (has_smb2_data_area[le16_to_cpu(hdr->Command)] =3D=3D f=
alse)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto calc_size_exit;
>> +
>> + =A0 =A0 smb2_get_data_area_len(&offset, &data_length, hdr);
>> + =A0 =A0 cFYI(1, "smb2 data length %d offset %d", data_length, offs=
et);
>> +
>> + =A0 =A0 if (data_length > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* Check to make sure that data area beg=
ins after fixed area,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* Note that last byte of the fixed area=
 is part of data area
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* for some commands, typically those wi=
th odd StructureSize,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* so we must add one to the calculation=
 (and 4 to account for
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* the size of the RFC1001 hdr.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (offset + 4 + 1 < len) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "data area overl=
aps SMB2 header, ignoring");
>
> Again, some info that would help us to debug this situation might be
> helpful. What were offset and len?
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 data_length =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D 4 + offset + data_=
length;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +calc_size_exit:
>> + =A0 =A0 cFYI(1, "smb2 len %d", len);
>> + =A0 =A0 return len;
>> +}
>> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>> index ab2590f..88cbfce 100644
>> --- a/fs/cifs/smb2ops.c
>> +++ b/fs/cifs/smb2ops.c
>> @@ -105,6 +105,38 @@ smb2_get_next_mid(struct TCP_Server_Info *serve=
r)
>> =A0 =A0 =A0 return mid;
>> =A0}
>>
>> +static struct mid_q_entry *
>> +smb2_find_mid(struct TCP_Server_Info *server, char *buf)
>> +{
>> + =A0 =A0 struct mid_q_entry *mid;
>> + =A0 =A0 struct smb2_hdr *hdr =3D (struct smb2_hdr *)buf;
>> +
>> + =A0 =A0 spin_lock(&GlobalMid_Lock);
>> + =A0 =A0 list_for_each_entry(mid, &server->pending_mid_q, qhead) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if ((mid->mid =3D=3D hdr->MessageId) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (mid->mid_state =3D=3D MID_REQUEST=
_SUBMITTED) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (mid->command =3D=3D hdr->Command)=
) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Loc=
k);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return mid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> + =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> + =A0 =A0 return NULL;
>> +}
>> +
>> +static void
>> +smb2_dump_detail(void *buf)
>> +{
>> +#ifdef CONFIG_CIFS_DEBUG2
>> + =A0 =A0 struct smb2_hdr *smb =3D (struct smb2_hdr *)buf;
>> +
>> + =A0 =A0 cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d=
",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb->Command, smb->Status, smb->Flags,=
 smb->MessageId,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb->ProcessId);
>> + =A0 =A0 cERROR(1, "smb buf %p len %u", smb, smb2_calc_size(smb));
>> +#endif
>> +}
>> +
>> =A0struct smb_version_operations smb21_operations =3D {
>> =A0 =A0 =A0 .setup_request =3D smb2_setup_request,
>> =A0 =A0 =A0 .check_receive =3D smb2_check_receive,
>> @@ -113,9 +145,14 @@ struct smb_version_operations smb21_operations =
=3D {
>> =A0 =A0 =A0 .get_credits_field =3D smb2_get_credits_field,
>> =A0 =A0 =A0 .get_credits =3D smb2_get_credits,
>> =A0 =A0 =A0 .get_next_mid =3D smb2_get_next_mid,
>> + =A0 =A0 .find_mid =3D smb2_find_mid,
>> + =A0 =A0 .check_message =3D smb2_check_message,
>> + =A0 =A0 .dump_detail =3D smb2_dump_detail,
>> =A0};
>>
>> =A0struct smb_version_values smb21_values =3D {
>> =A0 =A0 =A0 .version_string =3D SMB21_VERSION_STRING,
>> + =A0 =A0 .header_size =3D sizeof(struct smb2_hdr),
>> + =A0 =A0 .max_header_size =3D MAX_SMB2_HDR_SIZE,
>> =A0 =A0 =A0 .lock_cmd =3D SMB2_LOCK,
>> =A0};
>> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
>> index c7f52e3..efb0d98 100644
>> --- a/fs/cifs/smb2pdu.h
>> +++ b/fs/cifs/smb2pdu.h
>> @@ -112,4 +112,34 @@ struct smb2_hdr {
>> =A0 =A0 =A0 __u8 =A0 Signature[16];
>> =A0} __packed;
>>
>> +struct smb2_pdu {
>> + =A0 =A0 struct smb2_hdr hdr;
>> + =A0 =A0 __le16 StructureSize2; /* size of wct area (varies, reques=
t specific) */
>> +} __packed;
>> +
>> +/*
>> + * =A0 SMB2 flag definitions
>> + */
>> +#define SMB2_FLAGS_SERVER_TO_REDIR =A0 cpu_to_le32(0x00000001) /* R=
esponse */
>> +#define SMB2_FLAGS_ASYNC_COMMAND =A0 =A0 cpu_to_le32(0x00000002)
>> +#define SMB2_FLAGS_RELATED_OPERATIONS =A0 =A0 =A0 =A0cpu_to_le32(0x=
00000004)
>> +#define SMB2_FLAGS_SIGNED =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le32(0x0000=
0008)
>> +#define SMB2_FLAGS_DFS_OPERATIONS =A0 =A0cpu_to_le32(0x10000000)
>> +
>
> Probably should use __constant_cpu_to_le32 here, though these macros
> can sometimes figure that out (if __builtin_constant_p is true for th=
ese
> values).
>
>> +/*
>> + * =A0 Definitions for SMB2 Protocol Data Units (network frames)
>> + *
>> + * =A0See MS-SMB2.PDF specification for protocol details.
>> + * =A0The Naming convention is the lower case version of the SMB2
>> + * =A0command code name for the struct. Note that structures must b=
e packed.
>> + *
>> + */
>> +struct smb2_err_rsp {
>> + =A0 =A0 struct smb2_hdr hdr;
>> + =A0 =A0 __le16 StructureSize;
>> + =A0 =A0 __le16 Reserved; /* MBZ */
>> + =A0 =A0 __le32 ByteCount; =A0/* even if zero, at least one byte fo=
llows */
>> + =A0 =A0 __u8 =A0 ErrorData[1]; =A0/* variable length */
>> +} __packed;
>> +
>> =A0#endif =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 /* _SMB2PDU_H */
>> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
>> index 0e59afb..19bf987 100644
>> --- a/fs/cifs/smb2proto.h
>> +++ b/fs/cifs/smb2proto.h
>> @@ -33,6 +33,8 @@ struct statfs;
>> =A0 ****************************************************************=
*
>> =A0 */
>> =A0extern int map_smb2_to_linux_error(char *buf, bool log_err);
>> +extern int smb2_check_message(char *buf, unsigned int length);
>> +extern unsigned int smb2_calc_size(struct smb2_hdr *hdr);
>>
>> =A0extern int smb2_check_receive(struct mid_q_entry *mid,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct TCP_S=
erver_Info *server, bool log_error);
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks for the review - agree with your points. Since other patches
from the series don't depend on these changes, I will repost this one
with the whole series again when we finish with other patches.

--=20
Best regards,
Pavel Shilovsky.
