Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7290710F2
	for <linux-cifs@vger.kernel.org>; Wed, 10 Dec 2025 00:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765325582; cv=none; b=EnyFTziK5Mvke+n+jSSll7yq35dIDHqwu4UnzpsF+/PCsxrmbd95a4Lck+JKODOsIDHR/aNV8yqHI5Sa/1krWtkmRzd0m1LThE4GBirzdpufXlCv4FQpOhi6DAx91NVcU6bs8ZcL5g9VJcdmB101GqKijwOJURIYaIDPlVmGbSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765325582; c=relaxed/simple;
	bh=p965QHT5DHiRH7mz772nkuZPCOSc1rdN9MQ79qW9PvM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T0Hk1bNepKGBEk+5DKnLVHCna9pkswZweLQ0wxtM1ifVv0R7X4A3UegEibb0xxQ0+32wVWvSGlL57pg04PUtdvZFGsRGZHFVCyjPGu74tjXyn04DtgCe1O2GSUyV3BhVkrWCJevSdP3V2vYwmLz/fO3wneuYzos5kxFgZdXk8jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oP66Y2Ve; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oP66Y2Ve"
Message-ID: <c153bfca-4b19-4ffe-8c65-21a0b87263fa@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765325577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uLDC7VXdA3eHM0p9oj/2zoEg2h1UzzJtF7WHYT7gjcg=;
	b=oP66Y2Vei9Y1Vov9le/xPzJzd7YXwOgVPT92gJwaO+IuFPyFgegbOqCzns5vSD+8IKKEWZ
	93sRthobriyf2Tx5iliE4x9LRtfMUVrn3d7mDcFuiR5kwPZJ9SV5o1Uob5ofI53Lp26HhV
	S9n5Q3oeQKpTetBnqpfGReoOzOp0Xo8=
Date: Wed, 10 Dec 2025 08:12:38 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 11/13] smb: introduce struct create_posix_ctxt_rsp
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn,
 ZhangGuoDong <zhangguodong@kylinos.cn>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251209011020.3270989-12-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd8so+qB4zAXmj2mNSxqQ4emJe6eqhg-UgpKYgP+URk_yA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd8so+qB4zAXmj2mNSxqQ4emJe6eqhg-UgpKYgP+URk_yA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

The `create_posix_rsp` structures on the client and server sides differ, 
but they share a common part, and only this common part is defined in 
POSIX‑SMB2 2.2.14.2.16.

/*
  * [POSIX-SMB2] SMB3 POSIX Extensions
  * Link: 
https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/smb3_posix_extensions.md
  */

Thanks,
ChenXiaoSong.

On 12/10/25 7:45 AM, Namjae Jeon wrote:
> On Tue, Dec 9, 2025 at 10:12 AM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>>
>> Modify the following places:
>>
>>    - introduce new struct create_posix_ctxt_rsp
>>    - some fields in "struct create_posix_rsp" -> "struct create_posix_ctxt_rsp"
>>    - create_posix_rsp_buf(): offsetof(..., nlink) -> offsetof(..., ctxt_rsp)
> I don't know why we need to add a new create_posix_ctxt_rsp struct.
>>
>> Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
>> ---
>>   fs/smb/client/smb2pdu.c |  9 +++++----
>>   fs/smb/client/smb2pdu.h |  6 ++----
>>   fs/smb/common/smb2pdu.h | 18 ++++++++++++++++++
>>   fs/smb/server/oplock.c  |  8 ++++----
>>   fs/smb/server/smb2pdu.h |  6 ++----
>>   5 files changed, 31 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
>> index ef2c6ac500f7..ec0f83db5591 100644
>> --- a/fs/smb/client/smb2pdu.c
>> +++ b/fs/smb/client/smb2pdu.c
>> @@ -2298,9 +2298,9 @@ parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info,
>>
>>          memset(posix, 0, sizeof(*posix));
>>
>> -       posix->nlink = le32_to_cpu(*(__le32 *)(beg + 0));
>> -       posix->reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
>> -       posix->mode = le32_to_cpu(*(__le32 *)(beg + 8));
>> +       posix->ctxt_rsp.nlink = le32_to_cpu(*(__le32 *)(beg + 0));
>> +       posix->ctxt_rsp.reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
>> +       posix->ctxt_rsp.mode = le32_to_cpu(*(__le32 *)(beg + 8));
>>
>>          sid = beg + 12;
>>          sid_len = posix_info_sid_size(sid, end);
>> @@ -2319,7 +2319,8 @@ parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info,
>>          memcpy(&posix->group, sid, sid_len);
>>
>>          cifs_dbg(FYI, "nlink=%d mode=%o reparse_tag=%x\n",
>> -                posix->nlink, posix->mode, posix->reparse_tag);
>> +                posix->ctxt_rsp.nlink, posix->ctxt_rsp.mode,
>> +                posix->ctxt_rsp.reparse_tag);
>>   }
>>
>>   int smb2_parse_contexts(struct TCP_Server_Info *server,
>> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
>> index 78bb99f29d38..4928fb620233 100644
>> --- a/fs/smb/client/smb2pdu.h
>> +++ b/fs/smb/client/smb2pdu.h
>> @@ -251,11 +251,9 @@ struct smb2_file_id_extd_directory_info {
>>
>>   extern char smb2_padding[7];
>>
>> -/* equivalent of the contents of SMB3.1.1 POSIX open context response */
>> +/* See POSIX-SMB2 2.2.14.2.16 */
>>   struct create_posix_rsp {
>> -       u32 nlink;
>> -       u32 reparse_tag;
>> -       u32 mode;
>> +       struct create_posix_ctxt_rsp ctxt_rsp;
>>          struct smb_sid owner; /* var-sized on the wire */
>>          struct smb_sid group; /* var-sized on the wire */
>>   } __packed;
>> diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
>> index 72f2cfc47da8..698ab9d7d16b 100644
>> --- a/fs/smb/common/smb2pdu.h
>> +++ b/fs/smb/common/smb2pdu.h
>> @@ -1814,4 +1814,22 @@ typedef struct smb_negotiate_req {
>>          unsigned char DialectsArray[];
>>   } __packed SMB_NEGOTIATE_REQ;
>>
>> +
>> +/*
>> + * [POSIX-SMB2] SMB3 POSIX Extensions
>> + * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/smb3_posix_extensions.md
>> + */
>> +
>> +/*
>> + * SMB2_CREATE_POSIX_CONTEXT Response
>> + * See POSIX-SMB2 2.2.14.2.16
>> + */
>> +struct create_posix_ctxt_rsp {
>> +       __le32 nlink;
>> +       __le32 reparse_tag;
>> +       __le32 mode;
>> +       // var sized owner SID
>> +       // var sized group SID
>> +} __packed;
>> +
>>   #endif                         /* _COMMON_SMB2PDU_H */
>> diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
>> index 1f07ebf431d7..8658402ff893 100644
>> --- a/fs/smb/server/oplock.c
>> +++ b/fs/smb/server/oplock.c
>> @@ -1703,7 +1703,7 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
>>          buf = (struct create_posix_rsp *)cc;
>>          memset(buf, 0, sizeof(struct create_posix_rsp));
>>          buf->ccontext.DataOffset = cpu_to_le16(offsetof
>> -                       (struct create_posix_rsp, nlink));
>> +                       (struct create_posix_rsp, ctxt_rsp));
>>          /*
>>           * DataLength = nlink(4) + reparse_tag(4) + mode(4) +
>>           * domain sid(28) + unix group sid(16).
>> @@ -1730,9 +1730,9 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
>>          buf->Name[14] = 0xCD;
>>          buf->Name[15] = 0x7C;
>>
>> -       buf->nlink = cpu_to_le32(inode->i_nlink);
>> -       buf->reparse_tag = cpu_to_le32(fp->volatile_id);
>> -       buf->mode = cpu_to_le32(inode->i_mode & 0777);
>> +       buf->ctxt_rsp.nlink = cpu_to_le32(inode->i_nlink);
>> +       buf->ctxt_rsp.reparse_tag = cpu_to_le32(fp->volatile_id);
>> +       buf->ctxt_rsp.mode = cpu_to_le32(inode->i_mode & 0777);
>>          /*
>>           * SidBuffer(44) contain two sids(Domain sid(28), UNIX group sid(16)).
>>           * Domain sid(28) = revision(1) + num_subauth(1) + authority(6) +
>> diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
>> index 66cdc8e4a648..09311a9eb1de 100644
>> --- a/fs/smb/server/smb2pdu.h
>> +++ b/fs/smb/server/smb2pdu.h
>> @@ -83,13 +83,11 @@ struct create_durable_rsp {
>>          } Data;
>>   } __packed;
>>
>> -/* equivalent of the contents of SMB3.1.1 POSIX open context response */
>> +/* See POSIX-SMB2 2.2.14.2.16 */
>>   struct create_posix_rsp {
>>          struct create_context_hdr ccontext;
>>          __u8    Name[16];
>> -       __le32 nlink;
>> -       __le32 reparse_tag;
>> -       __le32 mode;
>> +       struct create_posix_ctxt_rsp ctxt_rsp;
>>          /* SidBuffer contain two sids(Domain sid(28), UNIX group sid(16)) */
>>          u8 SidBuffer[44];
>>   } __packed;
>> --
>> 2.43.0
>>

