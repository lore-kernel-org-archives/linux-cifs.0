From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 07/24] CIFS: Make demultiplex_thread work with SMB2 code
Date: Fri, 22 Jun 2012 16:55:13 -0500
Message-ID: <CAH2r5mv+_BXmc9rm59shjBoNmcfhUHidDAbmhrrPi6Na+-p6WQ@mail.gmail.com>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
	<1340202664-28696-8-git-send-email-pshilovsky@samba.org>
	<20120621114437.72a9483d@corrin.poochiereds.net>
	<CAKywueRCTr8bva4tX42JHH=j88i3t5+E0GNrVbKwhwp9hJScPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRCTr8bva4tX42JHH=j88i3t5+E0GNrVbKwhwp9hJScPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jun 22, 2012 at 9:59 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>=
 wrote:
> 2012/6/21 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> On Wed, 20 Jun 2012 18:30:47 +0400
>> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>>
>>> From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>
>>> Now we can process SMB2 messages: check message, get message id
>>> and wakeup awaiting routines.
>>>
>>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> ---
>>> =A0fs/cifs/Makefile =A0 =A0 | =A0 =A02 +-
>>> =A0fs/cifs/cifs_debug.c | =A0 =A02 +-
>>> =A0fs/cifs/smb2misc.c =A0 | =A0304 ++++++++++++++++++++++++++++++++=
++++++++++++++++++
>>> =A0fs/cifs/smb2ops.c =A0 =A0| =A0 37 ++++++
>>> =A0fs/cifs/smb2pdu.h =A0 =A0| =A0 30 +++++
>>> =A0fs/cifs/smb2proto.h =A0| =A0 =A02 +
>>> =A06 files changed, 375 insertions(+), 2 deletions(-)
>>> =A0create mode 100644 fs/cifs/smb2misc.c
>>>
>>> diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
>>> index a73d7f8..b77e9ec 100644
>>> --- a/fs/cifs/Makefile
>>> +++ b/fs/cifs/Makefile
>>> @@ -16,4 +16,4 @@ cifs-$(CONFIG_CIFS_DFS_UPCALL) +=3D dns_resolve.o=
 cifs_dfs_ref.o
>>>
>>> =A0cifs-$(CONFIG_CIFS_FSCACHE) +=3D fscache.o cache.o
>>>
>>> -cifs-$(CONFIG_CIFS_SMB2) +=3D smb2ops.o smb2maperror.o smb2transpo=
rt.o
>>> +cifs-$(CONFIG_CIFS_SMB2) +=3D smb2ops.o smb2maperror.o smb2transpo=
rt.o smb2misc.o
>>> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
>>> index e814052..8aa8693 100644
>>> --- a/fs/cifs/cifs_debug.c
>>> +++ b/fs/cifs/cifs_debug.c
>>> @@ -65,7 +65,7 @@ void cifs_dump_detail(void *buf)
>>> =A0 =A0 =A0 cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mi=
d: %d Pid: %d",
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb->Command, smb->Status.CifsError=
,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb->Flags, smb->Flags2, smb->Mid, =
smb->Pid);
>>> - =A0 =A0 cERROR(1, "smb buf %p len %d", smb, smbCalcSize(smb));
>>> + =A0 =A0 cERROR(1, "smb buf %p len %u", smb, smbCalcSize(smb));
>>> =A0#endif /* CONFIG_CIFS_DEBUG2 */
>>> =A0}
>>>
>>> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
>>> new file mode 100644
>>> index 0000000..03167eb
>>> --- /dev/null
>>> +++ b/fs/cifs/smb2misc.c
>>> @@ -0,0 +1,304 @@
>>> +/*
>>> + * =A0 fs/cifs/smb2misc.c
>>> + *
>>> + * =A0 Copyright (C) International Business Machines =A0Corp., 200=
2,2011
>>> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Etersoft, 2012
>>> + * =A0 Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
>>> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0Pavel Shilovsky (pshilovsky-eUNUBHrolfY@public.gmane.org=
g) 2012
>>> + *
>>> + * =A0 This library is free software; you can redistribute it and/=
or modify
>>> + * =A0 it under the terms of the GNU Lesser General Public License=
 as published
>>> + * =A0 by the Free Software Foundation; either version 2.1 of the =
License, or
>>> + * =A0 (at your option) any later version.
>>> + *
>>> + * =A0 This library is distributed in the hope that it will be use=
ful,
>>> + * =A0 but WITHOUT ANY WARRANTY; without even the implied warranty=
 of
>>> + * =A0 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =A0See
>>> + * =A0 the GNU Lesser General Public License for more details.
>>> + *
>>> + * =A0 You should have received a copy of the GNU Lesser General P=
ublic License
>>> + * =A0 along with this library; if not, write to the Free Software
>>> + * =A0 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02=
111-1307 USA
>>> + */
>>> +#include <linux/ctype.h>
>>> +#include "smb2pdu.h"
>>> +#include "cifsglob.h"
>>> +#include "cifsproto.h"
>>> +#include "smb2proto.h"
>>> +#include "cifs_debug.h"
>>> +#include "cifs_unicode.h"
>>> +#include "smb2status.h"
>>> +
>>> +static int
>>> +check_smb2_hdr(struct smb2_hdr *hdr, __u64 mid)
>>> +{
>>> + =A0 =A0 /*
>>> + =A0 =A0 =A0* Make sure that this really is an SMB, that it is a r=
esponse,
>>> + =A0 =A0 =A0* and that the message ids match
>>> + =A0 =A0 =A0*/
>>> + =A0 =A0 if ((*(__le32 *)hdr->ProtocolId =3D=3D cpu_to_le32(0x424d=
53fe)) &&
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0... =3D=3D __constant=
_cpu_to_le32()
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0It would also be good to turn that in=
to a #define'ed constant and use it in the check below.
>>
>>> + =A0 =A0 =A0 =A0 (mid =3D=3D hdr->MessageId)) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (hdr->Flags & SMB2_FLAGS_SERVER_TO_RED=
IR)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* only one valid case wh=
ere server sends us request */
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (hdr->Command =3D=3D S=
MB2_OPLOCK_BREAK)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1,=
 "Received Request not response");
>>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>>> + =A0 =A0 } else { /* bad signature or mid */
>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (*(__le32 *)hdr->ProtocolId !=3D cpu_t=
o_le32(0x424d53fe))
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Bad protocol s=
tring signature header %x",
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*(unsigned=
 int *) hdr->ProtocolId);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (mid !=3D hdr->MessageId)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Mids do not ma=
tch");
>>> + =A0 =A0 }
>>> + =A0 =A0 cERROR(1, "Bad SMB detected. The Mid=3D%llu", hdr->Messag=
eId);
>>> + =A0 =A0 return 1;
>>> +}
>>> +
>>> +/*
>>> + * =A0The following table defines the expected "StructureSize" of =
SMB2 responses
>>> + * =A0in order by SMB2 command. =A0This is similar to "wct" in SMB=
/CIFS responses.
>>> + *
>>> + * =A0Note that commands are defined in smb2pdu.h in le16 but the =
array below is
>>> + * =A0indexed by command in host byte order
>>> + */
>>> +static const int smb2_rsp_struct_sizes[NUMBER_OF_SMB2_COMMANDS] =3D=
 {
>>> + =A0 =A0 /* SMB2_NEGOTIATE */ 65,
>>> + =A0 =A0 /* SMB2_SESSION_SETUP */ 9,
>>> + =A0 =A0 /* SMB2_LOGOFF */ 4,
>>> + =A0 =A0 /* SMB2_TREE_CONNECT */ 16,
>>> + =A0 =A0 /* SMB2_TREE_DISCONNECT */ 4,
>>> + =A0 =A0 /* SMB2_CREATE */ 89,
>>> + =A0 =A0 /* SMB2_CLOSE */ 60,
>>> + =A0 =A0 /* SMB2_FLUSH */ 4,
>>> + =A0 =A0 /* SMB2_READ */ 17,
>>> + =A0 =A0 /* SMB2_WRITE */ 17,
>>> + =A0 =A0 /* SMB2_LOCK */ 4,
>>> + =A0 =A0 /* SMB2_IOCTL */ 49,
>>> + =A0 =A0 /* SMB2_CANCEL */ 0, /* BB CHECK this ... not listed in d=
ocumentation */
>>> + =A0 =A0 /* SMB2_ECHO */ 4,
>>> + =A0 =A0 /* SMB2_QUERY_DIRECTORY */ 9,
>>> + =A0 =A0 /* SMB2_CHANGE_NOTIFY */ 9,
>>> + =A0 =A0 /* SMB2_QUERY_INFO */ 9,
>>> + =A0 =A0 /* SMB2_SET_INFO */ 2,
>>> + =A0 =A0 /* SMB2_OPLOCK_BREAK */ 24 /* BB FIXME can also be 44 for=
 lease break */
>>> +};
>>> +
>>
>> It might save a few cycles (and memory) to make the above an array o=
f
>> __le16's and go ahead and __constant_cpu_to_le16 the values. Then yo=
u
>> wouldn't need to convert the values in the headers below.
>
> Yes, make sense.
>
>>
>>> +int
>>> +smb2_check_message(char *buf, unsigned int length)
>>> +{
>>> + =A0 =A0 struct smb2_hdr *hdr =3D (struct smb2_hdr *)buf;
>>> + =A0 =A0 struct smb2_pdu *pdu =3D (struct smb2_pdu *)hdr;
>>> + =A0 =A0 __u64 mid =3D hdr->MessageId;
>>> + =A0 =A0 __u32 len =3D get_rfc1002_length(buf);
>>> + =A0 =A0 __u32 clc_len; =A0/* calculated length */
>>> + =A0 =A0 int command;
>>> +
>>> + =A0 =A0 /* BB disable following printk later */
>>> + =A0 =A0 cFYI(1, "checkSMB Length: 0x%x, smb_buf_length: 0x%x", le=
ngth, len);
>>> +
>>> + =A0 =A0 /*
>>> + =A0 =A0 =A0* Add function to do table lookup of StructureSize by =
command
>>> + =A0 =A0 =A0* ie Validate the wct via smb2_struct_sizes table abov=
e
>>> + =A0 =A0 =A0*/
>>> +
>>> + =A0 =A0 if (length < 2 + sizeof(struct smb2_hdr)) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 if ((length >=3D sizeof(struct smb2_hdr))=
 && (hdr->Status !=3D 0)) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdu->StructureSize2 =3D 0=
;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* As with SMB/CIFS, on=
 some error cases servers may
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* not return wct prope=
rly
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 } else {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Length less th=
an smb header size");
>>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>>> + =A0 =A0 }
>>> + =A0 =A0 if (len > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE - 4) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "smb length greater than maximu=
m, mid=3D%lld", mid);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>>> + =A0 =A0 }
>>> +
>>> + =A0 =A0 if (check_smb2_hdr(hdr, mid))
>>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>>> +
>>> + =A0 =A0 if (le16_to_cpu(hdr->StructureSize) !=3D 64) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Illegal structure size %d",
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le16_to_cpu(hdr->Stru=
ctureSize));
>>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>>> + =A0 =A0 }
>>> +
>>> + =A0 =A0 command =3D le16_to_cpu(hdr->Command);
>>> + =A0 =A0 if (command >=3D NUMBER_OF_SMB2_COMMANDS) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "illegal SMB2 command %d", comm=
and);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>>> + =A0 =A0 }
>>> +
>>> + =A0 =A0 if (smb2_rsp_struct_sizes[command] !=3D
>>> + =A0 =A0 =A0 =A0 le16_to_cpu(pdu->StructureSize2)) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 if ((hdr->Status =3D=3D 0) ||
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (le16_to_cpu(pdu->StructureSize2)=
 !=3D 9)) {
>> The 9 here should probably be a preprocessor constant:
>>
>> =A0 =A0#define SMB2_ERROR_STRUCTURE_SIZE2 =A0__constant_le16_to_cpu(=
9)
>>
>> Then you could just compare that to a bare pdu->StructureSize2
>>
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* error packets have 9 b=
yte structure size */
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Illegal respon=
se size %d for command %d",
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le=
16_to_cpu(pdu->StructureSize2), command);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>>> + =A0 =A0 }
>>> +
>>> + =A0 =A0 clc_len =3D smb2_calc_size(hdr);
>>> +
>>> + =A0 =A0 if (4 + len !=3D length) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Length read does not match RFC=
1001 length %d",
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0len);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>>> + =A0 =A0 }
>>
>>
>> Does RFC1001 apply here? The error message above could be clearer.
>>
>>> +
>>> + =A0 =A0 if (4 + len !=3D clc_len) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Calculated size %d length %d mis=
match for mid %lld",
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0clc_len, 4 + len, mid)=
;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (clc_len =3D=3D 4 + len + 1) /* BB FIX=
ME (fix samba) */
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0; /* BB workaroun=
d Samba 3 bug SessSetup rsp */
>>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>>> + =A0 =A0 }
>>> + =A0 =A0 return 0;
>>> +}
>>> +
>>> +/*
>>> + * =A0The size of the variable area depends on the offset and leng=
th fields
>>> + * =A0located in different fields for various SMB2 responses. =A0S=
MB2 responses
>>> + * =A0with no variable length info, show an offset of zero for the=
 offset field.
>>> + */
>>> +static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] =3D =
{
>>> + =A0 =A0 /* SMB2_NEGOTIATE */ true,
>>> + =A0 =A0 /* SMB2_SESSION_SETUP */ true,
>>> + =A0 =A0 /* SMB2_LOGOFF */ false,
>>> + =A0 =A0 /* SMB2_TREE_CONNECT */ false,
>>> + =A0 =A0 /* SMB2_TREE_DISCONNECT */ false,
>>> + =A0 =A0 /* SMB2_CREATE */ true,
>>> + =A0 =A0 /* SMB2_CLOSE */ false,
>>> + =A0 =A0 /* SMB2_FLUSH */ false,
>>> + =A0 =A0 /* SMB2_READ */ true,
>>> + =A0 =A0 /* SMB2_WRITE */ false,
>>> + =A0 =A0 /* SMB2_LOCK */ false,
>>> + =A0 =A0 /* SMB2_IOCTL */ true,
>>> + =A0 =A0 /* SMB2_CANCEL */ false, /* BB CHECK this not listed in d=
ocumentation */
>>> + =A0 =A0 /* SMB2_ECHO */ false,
>>> + =A0 =A0 /* SMB2_QUERY_DIRECTORY */ true,
>>> + =A0 =A0 /* SMB2_CHANGE_NOTIFY */ true,
>>> + =A0 =A0 /* SMB2_QUERY_INFO */ true,
>>> + =A0 =A0 /* SMB2_SET_INFO */ false,
>>> + =A0 =A0 /* SMB2_OPLOCK_BREAK */ false
>>> +};
>>> +
>>> +/*
>>> + * Returns the pointer to the beginning of the data area. Length o=
f the data
>>> + * area and the offset to it (from the beginning of the smb are al=
so returned.
>>> + */
>>> +static char *
>>> +smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
>>> +{
>>> + =A0 =A0 *off =3D 0;
>>> + =A0 =A0 *len =3D 0;
>>> +
>>> + =A0 =A0 /* error responses do not have data area */
>>> + =A0 =A0 if (hdr->Status &&
>>> + =A0 =A0 =A0 =A0(le32_to_cpu(hdr->Status) !=3D STATUS_MORE_PROCESS=
ING_REQUIRED) &&
>>
>> I wonder...should we also convert the STATUS_* constants to LE value=
s?
>> That would save a few cycles on BE machines...
>
> In this case we should probably convert nterr.h too -- Steve, what do=
 you think?

It is probably fine if it makes the cifs code a little cleaner, but I
am more concerned about optimizing the smb2.1/smb3 code than
optimizing the cifs code at this point. I don't

--=20
Thanks,

Steve
