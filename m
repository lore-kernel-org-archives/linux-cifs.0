From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v3 13/32] CIFS: Make demultiplex_thread work with SMB2 code
Date: Fri, 27 Jul 2012 01:18:12 +0400
Message-ID: <CAKywueQZmUVTE3W+or1-a+fRD2SpmYNb_UwGNAhCbF0wO=m3Bw@mail.gmail.com>
References: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
	<1342166025-29377-14-git-send-email-pshilovsky@samba.org>
	<20120725140811.17382375@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120725140811.17382375-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/7/25 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Fri, 13 Jul 2012 11:53:26 +0400
> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> Now we can process SMB2 messages: check message, get message id
>> and wakeup awaiting routines.
>>
>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  fs/cifs/Makefile     |    2 +-
>>  fs/cifs/cifs_debug.c |    2 +-
>>  fs/cifs/smb2misc.c   |  307 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/cifs/smb2ops.c    |   37 ++++++
>>  fs/cifs/smb2pdu.h    |   36 ++++++
>>  fs/cifs/smb2proto.h  |    2 +
>>  6 files changed, 384 insertions(+), 2 deletions(-)
>>  create mode 100644 fs/cifs/smb2misc.c
>>
>> diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
>> index a73d7f8..b77e9ec 100644
>> --- a/fs/cifs/Makefile
>> +++ b/fs/cifs/Makefile
>> @@ -16,4 +16,4 @@ cifs-$(CONFIG_CIFS_DFS_UPCALL) += dns_resolve.o cifs_dfs_ref.o
>>
>>  cifs-$(CONFIG_CIFS_FSCACHE) += fscache.o cache.o
>>
>> -cifs-$(CONFIG_CIFS_SMB2) += smb2ops.o smb2maperror.o smb2transport.o
>> +cifs-$(CONFIG_CIFS_SMB2) += smb2ops.o smb2maperror.o smb2transport.o smb2misc.o
>> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
>> index e814052..8aa8693 100644
>> --- a/fs/cifs/cifs_debug.c
>> +++ b/fs/cifs/cifs_debug.c
>> @@ -65,7 +65,7 @@ void cifs_dump_detail(void *buf)
>>       cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d",
>>                 smb->Command, smb->Status.CifsError,
>>                 smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
>> -     cERROR(1, "smb buf %p len %d", smb, smbCalcSize(smb));
>> +     cERROR(1, "smb buf %p len %u", smb, smbCalcSize(smb));
>>  #endif /* CONFIG_CIFS_DEBUG2 */
>>  }
>>
>> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
>> new file mode 100644
>> index 0000000..d422678
>> --- /dev/null
>> +++ b/fs/cifs/smb2misc.c
>> @@ -0,0 +1,307 @@
>> +/*
>> + *   fs/cifs/smb2misc.c
>> + *
>> + *   Copyright (C) International Business Machines  Corp., 2002,2011
>> + *                 Etersoft, 2012
>> + *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
>> + *              Pavel Shilovsky (pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org) 2012
>> + *
>> + *   This library is free software; you can redistribute it and/or modify
>> + *   it under the terms of the GNU Lesser General Public License as published
>> + *   by the Free Software Foundation; either version 2.1 of the License, or
>> + *   (at your option) any later version.
>> + *
>> + *   This library is distributed in the hope that it will be useful,
>> + *   but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
>> + *   the GNU Lesser General Public License for more details.
>> + *
>> + *   You should have received a copy of the GNU Lesser General Public License
>> + *   along with this library; if not, write to the Free Software
>> + *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
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
>> +     /*
>> +      * Make sure that this really is an SMB, that it is a response,
>> +      * and that the message ids match.
>> +      */
>> +     if ((*(__le32 *)hdr->ProtocolId == SMB2_PROTO_NUMBER) &&
>> +         (mid == hdr->MessageId)) {
>> +             if (hdr->Flags & SMB2_FLAGS_SERVER_TO_REDIR)
>> +                     return 0;
>> +             else {
>> +                     /* only one valid case where server sends us request */
>> +                     if (hdr->Command == SMB2_OPLOCK_BREAK)
>> +                             return 0;
>> +                     else
>> +                             cERROR(1, "Received Request not response");
>> +             }
>> +     } else { /* bad signature or mid */
>> +             if (*(__le32 *)hdr->ProtocolId != SMB2_PROTO_NUMBER)
>> +                     cERROR(1, "Bad protocol string signature header %x",
>> +                               *(unsigned int *) hdr->ProtocolId);
>> +             if (mid != hdr->MessageId)
>> +                     cERROR(1, "Mids do not match");
>
>                         This error message isn't as helpful as it could
>                         be. Perhaps you could print the mid and the
>                         hdr->MessageId?

make sense.

>
>> +     }
>> +     cERROR(1, "Bad SMB detected. The Mid=%llu", hdr->MessageId);
>> +     return 1;
>> +}
>> +
>> +/*
>> + *  The following table defines the expected "StructureSize" of SMB2 responses
>> + *  in order by SMB2 command.  This is similar to "wct" in SMB/CIFS responses.
>> + *
>> + *  Note that commands are defined in smb2pdu.h in le16 but the array below is
>> + *  indexed by command in host byte order
>> + */
>> +static const __le16 smb2_rsp_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
>> +     /* SMB2_NEGOTIATE */ __constant_cpu_to_le16(65),
>> +     /* SMB2_SESSION_SETUP */ __constant_cpu_to_le16(9),
>> +     /* SMB2_LOGOFF */ __constant_cpu_to_le16(4),
>> +     /* SMB2_TREE_CONNECT */ __constant_cpu_to_le16(16),
>> +     /* SMB2_TREE_DISCONNECT */ __constant_cpu_to_le16(4),
>> +     /* SMB2_CREATE */ __constant_cpu_to_le16(89),
>> +     /* SMB2_CLOSE */ __constant_cpu_to_le16(60),
>> +     /* SMB2_FLUSH */ __constant_cpu_to_le16(4),
>> +     /* SMB2_READ */ __constant_cpu_to_le16(17),
>> +     /* SMB2_WRITE */ __constant_cpu_to_le16(17),
>> +     /* SMB2_LOCK */ __constant_cpu_to_le16(4),
>> +     /* SMB2_IOCTL */ __constant_cpu_to_le16(49),
>> +     /* BB CHECK this ... not listed in documentation */
>> +     /* SMB2_CANCEL */ __constant_cpu_to_le16(0),
>> +     /* SMB2_ECHO */ __constant_cpu_to_le16(4),
>> +     /* SMB2_QUERY_DIRECTORY */ __constant_cpu_to_le16(9),
>> +     /* SMB2_CHANGE_NOTIFY */ __constant_cpu_to_le16(9),
>> +     /* SMB2_QUERY_INFO */ __constant_cpu_to_le16(9),
>> +     /* SMB2_SET_INFO */ __constant_cpu_to_le16(2),
>> +     /* BB FIXME can also be 44 for lease break */
>> +     /* SMB2_OPLOCK_BREAK */ __constant_cpu_to_le16(24)
>> +};
>> +
>> +int
>> +smb2_check_message(char *buf, unsigned int length)
>> +{
>> +     struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
>> +     struct smb2_pdu *pdu = (struct smb2_pdu *)hdr;
>> +     __u64 mid = hdr->MessageId;
>> +     __u32 len = get_rfc1002_length(buf);
>> +     __u32 clc_len;  /* calculated length */
>> +     int command;
>> +
>> +     /* BB disable following printk later */
>> +     cFYI(1, "%s length: 0x%x, smb_buf_length: 0x%x", __func__, length, len);
>> +
>> +     /*
>> +      * Add function to do table lookup of StructureSize by command
>> +      * ie Validate the wct via smb2_struct_sizes table above
>> +      */
>> +
>> +     if (length < 2 + sizeof(struct smb2_hdr)) {
>
>         Why 2 here? In the SMB1 code, the 2 is the width of the BCC
>         field. Here, I'm not sure I understand what it's for. Is it the
>         StructureSize2? If so, why not just use sizeof(struct smb2_pdu) ?

seems sizeof(struct smb2_pdu) is more suitable, thanks!

>
>> +             if ((length >= sizeof(struct smb2_hdr)) && (hdr->Status != 0)) {
>> +                     pdu->StructureSize2 = 0;
>> +                     /*
>> +                      * As with SMB/CIFS, on some error cases servers may
>> +                      * not return wct properly
>> +                      */
>> +                     return 0;
>> +             } else {
>> +                     cERROR(1, "Length less than SMB header size");
>> +             }
>> +             return 1;
>> +     }
>> +     if (len > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE - 4) {
>> +             cERROR(1, "SMB length greater than maximum, mid=%lld", mid);
>> +             return 1;
>> +     }
>> +
>> +     if (check_smb2_hdr(hdr, mid))
>> +             return 1;
>> +
>> +     if (hdr->StructureSize != SMB2_HEADER_SIZE) {
>> +             cERROR(1, "Illegal structure size %d",
>> +                       le16_to_cpu(hdr->StructureSize));
>> +             return 1;
>> +     }
>> +
>
> The name SMB2_HEADER_SIZE is confusing since it's not the header size,
> but the fixed value of hdr->StructureSize for SMB2. Renaming that would
> be nice.
>

ok.

>> +     command = le16_to_cpu(hdr->Command);
>> +     if (command >= NUMBER_OF_SMB2_COMMANDS) {
>> +             cERROR(1, "Illegal SMB2 command %d", command);
>> +             return 1;
>> +     }
>> +
>> +     if (smb2_rsp_struct_sizes[command] != pdu->StructureSize2) {
>> +             if (hdr->Status == 0 ||
>> +                 pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2) {
>> +                     /* error packets have 9 byte structure size */
>> +                     cERROR(1, "Illegal response size %u for command %d",
>> +                                le16_to_cpu(pdu->StructureSize2), command);
>> +                     return 1;
>> +             }
>> +     }
>> +
>> +     if (4 + len != length) {
>> +             cERROR(1, "Total length %u RFC1002 length %u mismatch mid %llu",
>> +                       length, 4 + len, mid);
>> +             return 1;
>> +     }
>> +
>> +     clc_len = smb2_calc_size(hdr);
>> +
>> +     if (4 + len != clc_len) {
>> +             cFYI(1, "Calculated size %u length %u mismatch mid %llu",
>> +                     clc_len, 4 + len, mid);
>> +             if (clc_len == 4 + len + 1) /* BB FIXME (fix samba) */
>> +                     return 0; /* BB workaround Samba 3 bug SessSetup rsp */
>
> If it's only for SessSetup, then might it make sense to limit the above
> workaround to only when command == SMB2_SESSION_SETUP?

Seems like Windows 7 does the same thing not only for SessSetup rsp -
will change the comment.

>
>> +             return 1;
>> +     }
>> +     return 0;
>> +}
>> +
>> +/*
>> + * The size of the variable area depends on the offset and length fields
>> + * located in different fields for various SMB2 responses. SMB2 responses
>> + * with no variable length info, show an offset of zero for the offset field.
>> + */
>> +static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] = {
>> +     /* SMB2_NEGOTIATE */ true,
>> +     /* SMB2_SESSION_SETUP */ true,
>> +     /* SMB2_LOGOFF */ false,
>> +     /* SMB2_TREE_CONNECT */ false,
>> +     /* SMB2_TREE_DISCONNECT */ false,
>> +     /* SMB2_CREATE */ true,
>> +     /* SMB2_CLOSE */ false,
>> +     /* SMB2_FLUSH */ false,
>> +     /* SMB2_READ */ true,
>> +     /* SMB2_WRITE */ false,
>> +     /* SMB2_LOCK */ false,
>> +     /* SMB2_IOCTL */ true,
>> +     /* SMB2_CANCEL */ false, /* BB CHECK this not listed in documentation */
>> +     /* SMB2_ECHO */ false,
>> +     /* SMB2_QUERY_DIRECTORY */ true,
>> +     /* SMB2_CHANGE_NOTIFY */ true,
>> +     /* SMB2_QUERY_INFO */ true,
>> +     /* SMB2_SET_INFO */ false,
>> +     /* SMB2_OPLOCK_BREAK */ false
>> +};
>> +
>> +/*
>> + * Returns the pointer to the beginning of the data area. Length of the data
>> + * area and the offset to it (from the beginning of the smb are also returned.
>> + */
>> +static char *
>> +smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
>> +{
>> +     *off = 0;
>> +     *len = 0;
>> +
>> +     /* error responses do not have data area */
>> +     if (hdr->Status && hdr->Status != STATUS_MORE_PROCESSING_REQUIRED &&
>> +         (((struct smb2_err_rsp *)hdr)->StructureSize) ==
>> +                                             SMB2_ERROR_STRUCTURE_SIZE2)
>> +             return NULL;
>> +
>
> I'm not sure I understand the logic in the above statement.
>
> Why the need to check the StructureSize above? Is it ever the case that
> you'll have Status set to something besides
> STATUS_MORE_PROCESSING_REQUIRED or 0, and the StructureSize is
> something besides SMB2_ERROR_STRUCTURE_SIZE2?
>
> If so, then you're treating it as a non-error response?
>

Let me clarify: SessSetup rsp and Error rsp has the same
StructureSize2 == 9. If Status != 0 it is a error, but if Status ==
STATUS_MORE_PROCESSING_REQUIRED it is a error but this packet has a
data area.

So, we treat the packet as "error without data area" in the case that
this if statement describes. Otherwise, the packet can have a data
area.

>> +     /*
>> +      * Following commands have data areas so we have to get the location
>> +      * of the data buffer offset and data buffer length for the particular
>> +      * command.
>> +      */
>> +     switch (hdr->Command) {
>> +     case SMB2_NEGOTIATE:
>> +     case SMB2_SESSION_SETUP:
>> +     case SMB2_CREATE:
>> +     case SMB2_READ:
>> +     case SMB2_QUERY_INFO:
>> +     case SMB2_QUERY_DIRECTORY:
>> +     case SMB2_IOCTL:
>> +     case SMB2_CHANGE_NOTIFY:
>> +     default:
>> +             /* BB FIXME for unimplemented cases above */
>> +             cERROR(1, "no length check for command");
>> +             break;
>> +     }
>
> Doesn't the above switch always end up doing the same thing? Print a
> cERROR? I guess you flesh this out in the later patches?

Yes, of course it will be changed by later patches.

>
>> +
>> +     /*
>> +      * Invalid length or offset probably means data area is invalid, but
>> +      * we have little choice but to ignore the data area in this case.
>> +      */
>> +     if (*off > 4096) {
>> +             cERROR(1, "offset %d too large, data area ignored", *off);
>> +             *len = 0;
>> +             *off = 0;
>> +     } else if (*off < 0) {
>> +             cERROR(1, "negative offset %d to data invalid ignore data area",
>> +                       *off);
>> +             *off = 0;
>> +             *len = 0;
>> +     } else if (*len < 0) {
>> +             cERROR(1, "negative data length %d invalid, data area ignored",
>> +                       *len);
>> +             *len = 0;
>> +     } else if (*len > 128 * 1024) {
>> +             cERROR(1, "data area larger than 128K: %d", *len);
>> +             *len = 0;
>> +     }
>> +
>> +     /* return pointer to beginning of data area, ie offset from SMB start */
>> +     if ((*off != 0) && (*len != 0))
>> +             return hdr->ProtocolId + *off;
>> +     else
>> +             return NULL;
>> +}
>> +
>> +/*
>> + * Calculate the size of the SMB message based on the fixed header
>> + * portion, the number of word parameters and the data portion of the message.
>> + */
>> +unsigned int
>> +smb2_calc_size(struct smb2_hdr *hdr)
>> +{
>> +     struct smb2_pdu *pdu = (struct smb2_pdu *)hdr;
>> +     int offset; /* the offset from the beginning of SMB to data area */
>> +     int data_length; /* the length of the variable length data area */
>> +     /* Structure Size has already been checked to make sure it is 64 */
>> +     int len = 4 + le16_to_cpu(pdu->hdr.StructureSize);
>> +
>> +     /*
>> +      * StructureSize2, ie length of fixed parameter area has already
>> +      * been checked to make sure it is the correct length.
>> +      */
>> +     len += le16_to_cpu(pdu->StructureSize2);
>> +
>> +     if (has_smb2_data_area[le16_to_cpu(hdr->Command)] == false)
>> +             goto calc_size_exit;
>> +
>> +     smb2_get_data_area_len(&offset, &data_length, hdr);
>> +     cFYI(1, "SMB2 data length %d offset %d", data_length, offset);
>> +
>> +     if (data_length > 0) {
>> +             /*
>> +              * Check to make sure that data area begins after fixed area,
>> +              * Note that last byte of the fixed area is part of data area
>> +              * for some commands, typically those with odd StructureSize,
>> +              * so we must add one to the calculation (and 4 to account for
>> +              * the size of the RFC1001 hdr.
>> +              */
>> +             if (offset + 4 + 1 < len) {
>> +                     cERROR(1, "data area offset %d overlaps SMB2 header %d",
>> +                               offset + 4 + 1, len);
>> +                     data_length = 0;
>> +             } else {
>> +                     len = 4 + offset + data_length;
>> +             }
>> +     }
>> +calc_size_exit:
>> +     cFYI(1, "SMB2 len %d", len);
>> +     return len;
>> +}
>> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>> index 67a0598..c6f8154 100644
>> --- a/fs/cifs/smb2ops.c
>> +++ b/fs/cifs/smb2ops.c
>> @@ -107,6 +107,38 @@ smb2_get_next_mid(struct TCP_Server_Info *server)
>>       return mid;
>>  }
>>
>> +static struct mid_q_entry *
>> +smb2_find_mid(struct TCP_Server_Info *server, char *buf)
>> +{
>> +     struct mid_q_entry *mid;
>> +     struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
>> +
>> +     spin_lock(&GlobalMid_Lock);
>> +     list_for_each_entry(mid, &server->pending_mid_q, qhead) {
>> +             if ((mid->mid == hdr->MessageId) &&
>> +                 (mid->mid_state == MID_REQUEST_SUBMITTED) &&
>> +                 (mid->command == hdr->Command)) {
>> +                     spin_unlock(&GlobalMid_Lock);
>> +                     return mid;
>> +             }
>> +     }
>> +     spin_unlock(&GlobalMid_Lock);
>> +     return NULL;
>> +}
>> +
>> +static void
>> +smb2_dump_detail(void *buf)
>> +{
>> +#ifdef CONFIG_CIFS_DEBUG2
>> +     struct smb2_hdr *smb = (struct smb2_hdr *)buf;
>> +
>> +     cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d",
>> +               smb->Command, smb->Status, smb->Flags, smb->MessageId,
>> +               smb->ProcessId);
>> +     cERROR(1, "smb buf %p len %u", smb, smb2_calc_size(smb));
>> +#endif
>> +}
>> +
>>  struct smb_version_operations smb21_operations = {
>>       .setup_request = smb2_setup_request,
>>       .check_receive = smb2_check_receive,
>> @@ -115,9 +147,14 @@ struct smb_version_operations smb21_operations = {
>>       .get_credits_field = smb2_get_credits_field,
>>       .get_credits = smb2_get_credits,
>>       .get_next_mid = smb2_get_next_mid,
>> +     .find_mid = smb2_find_mid,
>> +     .check_message = smb2_check_message,
>> +     .dump_detail = smb2_dump_detail,
>>  };
>>
>>  struct smb_version_values smb21_values = {
>>       .version_string = SMB21_VERSION_STRING,
>> +     .header_size = sizeof(struct smb2_hdr),
>> +     .max_header_size = MAX_SMB2_HDR_SIZE,
>>       .lock_cmd = SMB2_LOCK,
>>  };
>> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
>> index c7f52e3..b08a277 100644
>> --- a/fs/cifs/smb2pdu.h
>> +++ b/fs/cifs/smb2pdu.h
>> @@ -85,6 +85,12 @@
>>  /* BB FIXME - analyze following length BB */
>>  #define MAX_SMB2_HDR_SIZE 0x78 /* 4 len + 64 hdr + (2*24 wct) + 2 bct + 2 pad */
>>
>> +#define SMB2_PROTO_NUMBER __constant_cpu_to_le32(0x424d53fe)
>> +
>> +#define SMB2_HEADER_SIZE __constant_le16_to_cpu(64)
>> +
>> +#define SMB2_ERROR_STRUCTURE_SIZE2 __constant_le16_to_cpu(9)
>> +
>>  /*
>>   * SMB2 Header Definition
>>   *
>> @@ -112,4 +118,34 @@ struct smb2_hdr {
>>       __u8   Signature[16];
>>  } __packed;
>>
>> +struct smb2_pdu {
>> +     struct smb2_hdr hdr;
>> +     __le16 StructureSize2; /* size of wct area (varies, request specific) */
>> +} __packed;
>> +
>> +/*
>> + *   SMB2 flag definitions
>> + */
>> +#define SMB2_FLAGS_SERVER_TO_REDIR   __constant_cpu_to_le32(0x00000001)
>> +#define SMB2_FLAGS_ASYNC_COMMAND     __constant_cpu_to_le32(0x00000002)
>> +#define SMB2_FLAGS_RELATED_OPERATIONS        __constant_cpu_to_le32(0x00000004)
>> +#define SMB2_FLAGS_SIGNED            __constant_cpu_to_le32(0x00000008)
>> +#define SMB2_FLAGS_DFS_OPERATIONS    __constant_cpu_to_le32(0x10000000)
>> +
>> +/*
>> + *   Definitions for SMB2 Protocol Data Units (network frames)
>> + *
>> + *  See MS-SMB2.PDF specification for protocol details.
>> + *  The Naming convention is the lower case version of the SMB2
>> + *  command code name for the struct. Note that structures must be packed.
>> + *
>> + */
>> +struct smb2_err_rsp {
>> +     struct smb2_hdr hdr;
>> +     __le16 StructureSize;
>> +     __le16 Reserved; /* MBZ */
>> +     __le32 ByteCount;  /* even if zero, at least one byte follows */
>> +     __u8   ErrorData[1];  /* variable length */
>> +} __packed;
>> +
>>  #endif                               /* _SMB2PDU_H */
>> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
>> index 0e59afb..19bf987 100644
>> --- a/fs/cifs/smb2proto.h
>> +++ b/fs/cifs/smb2proto.h
>> @@ -33,6 +33,8 @@ struct statfs;
>>   *****************************************************************
>>   */
>>  extern int map_smb2_to_linux_error(char *buf, bool log_err);
>> +extern int smb2_check_message(char *buf, unsigned int length);
>> +extern unsigned int smb2_calc_size(struct smb2_hdr *hdr);
>>
>>  extern int smb2_check_receive(struct mid_q_entry *mid,
>>                             struct TCP_Server_Info *server, bool log_error);
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



-- 
Best regards,
Pavel Shilovsky.
