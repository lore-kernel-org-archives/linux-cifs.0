Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AF429CE1
	for <linux-cifs@vger.kernel.org>; Sun, 26 Oct 2025 09:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761470469; cv=none; b=lQyzxGT6LUowswc64mqC55auwxgTHUiQPzTf8UVWLRJRl9tEO+ttNUb4fFwtJxgTrFaDVMR/Q/3yrXjIB19yKcx6P4K2mG0Vn3PLM1bKwcFYNPc7UwzFlQXK4Wz/rwnStzICX+4GLZ1BG2gKirmE/0P7gquTg3CXaDJ6zB6W+Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761470469; c=relaxed/simple;
	bh=dHEHOymarxJ/E4vwUwZ7VqcbQbmE3K9lR7MOM/cFS6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O9pebN8J8e8uAi+KjZ6q2yQn3NwLKzxoKojuXMuZKlS69SZ1MZ7a2HHlJ5aiYov3lUGfjrPekg1+FKd6DpxtlSjQM70XUhDFG5gHUOErB4buW1Y7v3wTlDY6qkmcf1XiwK+Genipq2tKDMBYxrz2+x/G5L5nHemrbASXxVLVxNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l3gsmR9x; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l3gsmR9x"
Message-ID: <e2757988-63af-4ace-aed7-f8708f52fe93@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761470461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BZ1mNPfVmr+XRghn4SL9a6fm6IEVj1GhI2L8kZHAyYQ=;
	b=l3gsmR9xIiAg847MttOGph3kwu5xKTlyUwYQaaiW5A18UoTmeovapDmkJZ6pOMImA36WRi
	yg8brkK7qDmY1o7mwW1a57Uti7OTSVbWU0Kp4Db3CiV3dp2X+As6Blaj0oT0cSHPEOHLg8
	BGoHDNctZFtUtCbn8/FHPC23jUqdChw=
Date: Sun, 26 Oct 2025 17:20:38 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 07/22] smb: move some duplicate definitions to
 common/smb2pdu.h
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: stfrench@microsoft.com, metze@samba.org, pali@kernel.org,
 smfrench@gmail.com, sfrench@samba.org, senozhatsky@chromium.org,
 tom@talpey.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, bharathsm@microsoft.com,
 christophe.jaillet@wanadoo.fr, zhangguodong@kylinos.cn,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251014071917.3004573-8-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd9SJ_92si7_wt=hLm9RZmrVm2oZZqNOPFDGvPZzMzkAYA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd9SJ_92si7_wt=hLm9RZmrVm2oZZqNOPFDGvPZzMzkAYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

I'm confused by what this sentence means: "I prefer moving it when the 
durable handle structures are moved to /common later.".

What does "it" refer to? Does "it" refer to the whole patch, or only to 
"SMB2_DHANDLE_FLAG_PERSISTENT"?

On 10/20/25 12:52 PM, Namjae Jeon wrote:
> On Tue, Oct 14, 2025 at 4:21 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>>
>> In order to maintain the code more easily, move duplicate definitions to
>> new common header file.
>>
>> Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
>> ---
>>   fs/smb/client/smb2pdu.h | 24 +++---------------------
>>   fs/smb/common/smb2pdu.h | 24 ++++++++++++++++++++++++
>>   fs/smb/server/smb2pdu.c |  8 ++++----
>>   fs/smb/server/smb2pdu.h | 17 -----------------
>>   4 files changed, 31 insertions(+), 42 deletions(-)
>>
>> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
>> index 101024f8f725..c013560bcfa1 100644
>> --- a/fs/smb/client/smb2pdu.h
>> +++ b/fs/smb/client/smb2pdu.h
>> @@ -135,11 +135,9 @@ struct share_redirect_error_context_rsp {
>>
>>
>>   /* See MS-SMB2 2.2.13.2.11 */
>> -/* Flags */
>> -#define SMB2_DHANDLE_FLAG_PERSISTENT   0x00000002
>>   struct durable_context_v2 {
>>          __le32 Timeout;
>> -       __le32 Flags;
>> +       __le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
>>          __u64 Reserved;
>>          __u8 CreateGuid[16];
>>   } __packed;
>> @@ -157,13 +155,13 @@ struct durable_reconnect_context_v2 {
>>                  __u64 VolatileFileId;
>>          } Fid;
>>          __u8 CreateGuid[16];
>> -       __le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
>> +       __le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
>>   } __packed;
>>
>>   /* See MS-SMB2 2.2.14.2.12 */
>>   struct durable_reconnect_context_v2_rsp {
>>          __le32 Timeout;
>> -       __le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
>> +       __le32 Flags; /* see SMB2_DHANDLE_FLAG_PERSISTENT */
>>   } __packed;
>>
>>   struct create_durable_handle_reconnect_v2 {
>> @@ -263,22 +261,6 @@ struct network_resiliency_req {
>>   } __packed;
>>   /* There is no buffer for the response ie no struct network_resiliency_rsp */
>>
>> -#define RSS_CAPABLE    cpu_to_le32(0x00000001)
>> -#define RDMA_CAPABLE   cpu_to_le32(0x00000002)
>> -
>> -#define INTERNETWORK   cpu_to_le16(0x0002)
>> -#define INTERNETWORKV6 cpu_to_le16(0x0017)
>> -
>> -struct network_interface_info_ioctl_rsp {
>> -       __le32 Next; /* next interface. zero if this is last one */
>> -       __le32 IfIndex;
>> -       __le32 Capability; /* RSS or RDMA Capable */
>> -       __le32 Reserved;
>> -       __le64 LinkSpeed;
>> -       __le16 Family;
>> -       __u8 Buffer[126];
>> -} __packed;
>> -
>>   struct iface_info_ipv4 {
>>          __be16 Port;
>>          __be32 IPv4Address;
>> diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
>> index f79a5165a7cc..25e8ece283c4 100644
>> --- a/fs/smb/common/smb2pdu.h
>> +++ b/fs/smb/common/smb2pdu.h
>> @@ -1290,6 +1290,10 @@ struct create_mxac_req {
>>          __le64 Timestamp;
>>   } __packed;
>>
>> +/* See MS-SMB2 2.2.13.2.11 and MS-SMB2 2.2.13.2.12 and MS-SMB2 2.2.14.2.12 */
>> +/* Flags */
>> +#define SMB2_DHANDLE_FLAG_PERSISTENT   0x00000002
> I prefer moving it when the durable handle structures are moved to
> /common later.
> Thanks.

-- 
Thanks,
ChenXiaoSong.

