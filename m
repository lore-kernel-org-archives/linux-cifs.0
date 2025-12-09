Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33942236F0
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 02:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765249067; cv=none; b=rqpsDw3cfLysF3zQU60UWSexaZVDwF7YLDKMwAJbdEuz8o5wMH7cPGdFyGgTHgdxp8rgR8m1OLPK1rpkFVCkGCmW/DSGSbBGtIvcUgV76SvL8+mruoNfhR58nvwlYI61xLNjMY2wc40nHEMyAARnqvZy49F2SlnD3WdqJqChJdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765249067; c=relaxed/simple;
	bh=d6iakszXcR8ptnE9T+sXk8klHJLomPQXF9MpmsIsI08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r5AIbCnrbNE6yDI03uNIJZrDJpTQj8NiNRpratfOdqItj7daYR+0v7JiXoAiR0zOGUMr93di8DBw046P19HtDgRUAOqaT3WjVlua8pxpj/Zmretl4PZjAwZlwX/1rdJQMHP6+p56DJ+6yudQ4J8W9LVMxz/wLcYLrpdz07Fk730=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gMq2Jxw7; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gMq2Jxw7"
Message-ID: <6ff6fa14-15d2-487d-8d6f-373bd64fcb46@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765249053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jarh1JW4RJNshxJMbDLC4mpC3qO6a3sku0tvnMGKSk=;
	b=gMq2Jxw7vxD9kZjyumu7xtn73NtNp3gcEEWGRgnOQBEw3xJBozsYu2NVJ7RXD+0jdwb4Kw
	JA0auGEs2YwQet3MupEqneZxMqd4nBKhxj7yq/ZxC9ZSEXpo8F3ztPB/SwUT2czzQWYWNK
	357n/RLClLBnE2UZJnakpou/2MeVl2U=
Date: Tue, 9 Dec 2025 10:56:49 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 13/13] smb: move some SMB1 definitions into
 common/smb1pdu.h
To: Steve French <smfrench@gmail.com>
Cc: sfrench@samba.org, linkinjeon@kernel.org, linkinjeon@samba.org,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn,
 ZhangGuoDong <zhangguodong@kylinos.cn>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251209011020.3270989-14-chenxiaosong.chenxiaosong@linux.dev>
 <CAH2r5muXiti986tsg7fwLTEw7CceJ6UdtTh6s7CXWqU-D+COAw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAH2r5muXiti986tsg7fwLTEw7CceJ6UdtTh6s7CXWqU-D+COAw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

ksmbd only implements SMB_COM_NEGOTIATE. Please refer to the 
init_smb1_rsp_hdr() function

Thanks,
ChenXiaoSong.

On 12/9/25 10:52, Steve French wrote:
> One option to consider is moving smb1 definitions into a client only
> (fs/smb/client) header since ksmbd doesn't use SMB1 technically they
> aren't 'common'
> 
> Did you find ksmbd server cases where it depends on any of these?
> 
> On Mon, Dec 8, 2025 at 7:12 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>>
>> These definitions are only used by SMB1, so move them into the new
>> common/smb1pdu.h.
>>
>> Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
>> ---
>>   fs/smb/client/cifspdu.h    |  2 +-
>>   fs/smb/common/smb1pdu.h    | 59 ++++++++++++++++++++++++++++++++++++++
>>   fs/smb/common/smb2pdu.h    | 44 ----------------------------
>>   fs/smb/common/smbglob.h    |  2 --
>>   fs/smb/server/smb_common.h |  1 +
>>   5 files changed, 61 insertions(+), 47 deletions(-)
>>   create mode 100644 fs/smb/common/smb1pdu.h
>>
>> diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
>> index 758ea29769da..bf6329cb4fd4 100644
>> --- a/fs/smb/client/cifspdu.h
>> +++ b/fs/smb/client/cifspdu.h
>> @@ -12,7 +12,7 @@
>>   #include <net/sock.h>
>>   #include <linux/unaligned.h>
>>   #include "../common/smbfsctl.h"
>> -#include "../common/smb2pdu.h"
>> +#include "../common/smb1pdu.h"
>>
>>   #define CIFS_PROT   0
>>   #define POSIX_PROT  (CIFS_PROT+1)
>> diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
>> new file mode 100644
>> index 000000000000..11797471b2eb
>> --- /dev/null
>> +++ b/fs/smb/common/smb1pdu.h
>> @@ -0,0 +1,59 @@
>> +/* SPDX-License-Identifier: LGPL-2.1 */
>> +/*
>> + *
>> + *   Copyright (c) International Business Machines  Corp., 2002,2009
>> + *                 2018 Samsung Electronics Co., Ltd.
>> + *   Author(s): Steve French (sfrench@us.ibm.com)
>> + *              Namjae Jeon (linkinjeon@kernel.org)
>> + *
>> + */
>> +
>> +#ifndef _COMMON_SMB1_PDU_H
>> +#define _COMMON_SMB1_PDU_H
>> +
>> +#define SMB1_PROTO_NUMBER              cpu_to_le32(0x424d53ff)
>> +
>> +/*
>> + * See MS-CIFS 2.2.3.1
>> + *     MS-SMB 2.2.3.1
>> + */
>> +struct smb_hdr {
>> +       __be32 smb_buf_length;  /* BB length is only two (rarely three) bytes,
>> +               with one or two byte "type" preceding it that will be
>> +               zero - we could mask the type byte off */
>> +       __u8 Protocol[4];
>> +       __u8 Command;
>> +       union {
>> +               struct {
>> +                       __u8 ErrorClass;
>> +                       __u8 Reserved;
>> +                       __le16 Error;
>> +               } __packed DosError;
>> +               __le32 CifsError;
>> +       } __packed Status;
>> +       __u8 Flags;
>> +       __le16 Flags2;          /* note: le */
>> +       __le16 PidHigh;
>> +       union {
>> +               struct {
>> +                       __le32 SequenceNumber;  /* le */
>> +                       __u32 Reserved; /* zero */
>> +               } __packed Sequence;
>> +               __u8 SecuritySignature[8];      /* le */
>> +       } __packed Signature;
>> +       __u8 pad[2];
>> +       __u16 Tid;
>> +       __le16 Pid;
>> +       __u16 Uid;
>> +       __le16 Mid;
>> +       __u8 WordCount;
>> +} __packed;
>> +
>> +/* See MS-CIFS 2.2.4.52.1 */
>> +typedef struct smb_negotiate_req {
>> +       struct smb_hdr hdr;     /* wct = 0 */
>> +       __le16 ByteCount;
>> +       unsigned char DialectsArray[];
>> +} __packed SMB_NEGOTIATE_REQ;
>> +
>> +#endif /* _COMMON_SMB1_PDU_H */
>> diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
>> index 2d68bd24f3bd..098f147680c5 100644
>> --- a/fs/smb/common/smb2pdu.h
>> +++ b/fs/smb/common/smb2pdu.h
>> @@ -1642,42 +1642,6 @@ struct smb2_lease_ack {
>>          __le64 LeaseDuration;
>>   } __packed;
>>
>> -/*
>> - * See MS-CIFS 2.2.3.1
>> - *     MS-SMB 2.2.3.1
>> - */
>> -struct smb_hdr {
>> -       __be32 smb_buf_length;  /* BB length is only two (rarely three) bytes,
>> -               with one or two byte "type" preceding it that will be
>> -               zero - we could mask the type byte off */
>> -       __u8 Protocol[4];
>> -       __u8 Command;
>> -       union {
>> -               struct {
>> -                       __u8 ErrorClass;
>> -                       __u8 Reserved;
>> -                       __le16 Error;
>> -               } __packed DosError;
>> -               __le32 CifsError;
>> -       } __packed Status;
>> -       __u8 Flags;
>> -       __le16 Flags2;          /* note: le */
>> -       __le16 PidHigh;
>> -       union {
>> -               struct {
>> -                       __le32 SequenceNumber;  /* le */
>> -                       __u32 Reserved; /* zero */
>> -               } __packed Sequence;
>> -               __u8 SecuritySignature[8];      /* le */
>> -       } __packed Signature;
>> -       __u8 pad[2];
>> -       __u16 Tid;
>> -       __le16 Pid;
>> -       __u16 Uid;
>> -       __le16 Mid;
>> -       __u8 WordCount;
>> -} __packed;
>> -
>>   #define OP_BREAK_STRUCT_SIZE_20                24
>>   #define OP_BREAK_STRUCT_SIZE_21                36
>>
>> @@ -1782,14 +1746,6 @@ struct smb_hdr {
>>   #define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
>>                                  | READ_CONTROL | SYNCHRONIZE)
>>
>> -/* See MS-CIFS 2.2.4.52.1 */
>> -typedef struct smb_negotiate_req {
>> -       struct smb_hdr hdr;     /* wct = 0 */
>> -       __le16 ByteCount;
>> -       unsigned char DialectsArray[];
>> -} __packed SMB_NEGOTIATE_REQ;
>> -
>> -
>>   /*
>>    * [POSIX-SMB2] SMB3 POSIX Extensions
>>    * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/smb3_posix_extensions.md
>> diff --git a/fs/smb/common/smbglob.h b/fs/smb/common/smbglob.h
>> index 7853b5771128..353dc4f0971a 100644
>> --- a/fs/smb/common/smbglob.h
>> +++ b/fs/smb/common/smbglob.h
>> @@ -11,8 +11,6 @@
>>   #ifndef _COMMON_SMB_GLOB_H
>>   #define _COMMON_SMB_GLOB_H
>>
>> -#define SMB1_PROTO_NUMBER              cpu_to_le32(0x424d53ff)
>> -
>>   struct smb_version_values {
>>          char            *version_string;
>>          __u16           protocol_id;
>> diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
>> index b8da31cdbfd1..f47ce4a6719c 100644
>> --- a/fs/smb/server/smb_common.h
>> +++ b/fs/smb/server/smb_common.h
>> @@ -11,6 +11,7 @@
>>   #include "glob.h"
>>   #include "nterr.h"
>>   #include "../common/smbglob.h"
>> +#include "../common/smb1pdu.h"
>>   #include "../common/smb2pdu.h"
>>   #include "../common/fscc.h"
>>   #include "smb2pdu.h"
>> --
>> 2.43.0
>>
> 
> 

