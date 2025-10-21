Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C36A54918
	for <linux-cifs@vger.kernel.org>; Tue, 21 Oct 2025 06:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761028519; cv=none; b=YQjdKGkiKfAPrWib2bjPyUtYhA5Y5UMN+38u2JdWonNqXYjHV3rFuEmCFKD8M4OMdkTmQXdidq3O8Im1Vq6dLbnuil5m72PTL0Czjg7K89GTgQfbwLBAytQKaz/kI7zjrqEGH+g6eufxDcE56t+RsSZilxyfVJQEslqJXl1hvmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761028519; c=relaxed/simple;
	bh=ELP0gRtoHXVoAgdij7vdirxiyLjLhnvL4G8trvQn7gc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OZEyjzALkRJdXTIafjms0K+G9fUkAawr4+0Ks5uFchTTBfCPoXmjM6EFmqZIGiBVaA4IGPNfjA7pOQRjbheo+HFPoy3rJFtNldQ/TV9ZgSelJ9hMYaQ/8j5qNLV5oqL+FnQIM6QMZnsYsB7kLbLPPWK7NeWr6y0gS8xyNsYiY6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rR4QWjBS; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rR4QWjBS"
Message-ID: <1270d868-f67d-44f5-bbd4-0e506b646bdf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761028514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QahPMd/vs7sSrGeiAcAsrQnLT+kim57Qj0mhCGxlotE=;
	b=rR4QWjBSr8TSh54zoLYFpCWDNPGIk5HTvaBc+1Vi6Ro7npUBOizKerYb1a45GwBLT1q7Gr
	YG4+vxn/pEBYFWKBTKR1jy5rAsTYbRvEuI0TFGKNBHcDxfvisqYWJq2wzgJ0+cI6s71P9z
	yjmIpT5vcvst/JgzNamrItvNNsIozJw=
Date: Tue, 21 Oct 2025 14:35:01 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 15/22] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to
 common/cifspdu.h
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: stfrench@microsoft.com, metze@samba.org, pali@kernel.org,
 smfrench@gmail.com, sfrench@samba.org, senozhatsky@chromium.org,
 tom@talpey.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, bharathsm@microsoft.com,
 christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251014072856.3004683-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251014072856.3004683-5-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd_xwKGST7PXu9ha5wdBF_M-qoe2g52Dp9Y3-0r+aYXa-w@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd_xwKGST7PXu9ha5wdBF_M-qoe2g52Dp9Y3-0r+aYXa-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Thanks for your suggestions. I’ll send v3 soon.

-- 
Thanks,
ChenXiaoSong.

On 10/20/25 1:35 PM, Namjae Jeon wrote:
> On Tue, Oct 14, 2025 at 4:30 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> Rename "struct filesystem_attribute_info" to "FILE_SYSTEM_ATTRIBUTE_INFO",
>> then move duplicate definitions to common header file.
>>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Please check the warnings from checkpatch.pl.
> 
> WARNING: do not add new typedefs
> #109: FILE: fs/smb/common/cifspdu.h:352:
> +typedef struct {
> 
> WARNING: Prefer __packed over __attribute__((packed))
> #114: FILE: fs/smb/common/cifspdu.h:357:
> +} __attribute__((packed)) FILE_SYSTEM_ATTRIBUTE_INFO;
> 
>> ---
>>   fs/smb/client/cifspdu.h    | 7 -------
>>   fs/smb/common/cifspdu.h    | 8 ++++++++
>>   fs/smb/server/smb2pdu.c    | 6 +++---
>>   fs/smb/server/smb_common.h | 7 -------
>>   4 files changed, 11 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
>> index 07eb821654e1..a6f7e168961e 100644
>> --- a/fs/smb/client/cifspdu.h
>> +++ b/fs/smb/client/cifspdu.h
>> @@ -1937,13 +1937,6 @@ typedef struct {
>>   /* minimum includes first three fields, and empty FS Name */
>>   #define MIN_FS_ATTR_INFO_SIZE 12
>>
>> -typedef struct {
>> -       __le32 Attributes;
>> -       __le32 MaxPathNameComponentLength;
>> -       __le32 FileSystemNameLen;
>> -       char FileSystemName[52]; /* do not have to save this - get subset? */
>> -} __attribute__((packed)) FILE_SYSTEM_ATTRIBUTE_INFO;
>> -
>>   /******************************************************************************/
>>   /* QueryFileInfo/QueryPathinfo (also for SetPath/SetFile) data buffer formats */
>>   /******************************************************************************/
>> diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
>> index 1109c20f7bf8..560900617be7 100644
>> --- a/fs/smb/common/cifspdu.h
>> +++ b/fs/smb/common/cifspdu.h
>> @@ -348,4 +348,12 @@ typedef struct server_negotiate_rsp {
>>   #define FILE_CASE_PRESERVED_NAMES      0x00000002
>>   #define FILE_CASE_SENSITIVE_SEARCH     0x00000001
>>
>> +/* See FS-FSCC 2.5.1 */
>> +typedef struct {
>> +       __le32 Attributes;
>> +       __le32 MaxPathNameComponentLength;
>> +       __le32 FileSystemNameLen;
>> +       __le16 FileSystemName[]; /* do not have to save this - get subset? */
>> +} __attribute__((packed)) FILE_SYSTEM_ATTRIBUTE_INFO;
>> +
>>   #endif /* _COMMON_CIFSPDU_H */
>> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
>> index a46d4ddade9e..a05b04799c0d 100644
>> --- a/fs/smb/server/smb2pdu.c
>> +++ b/fs/smb/server/smb2pdu.c
>> @@ -5485,10 +5485,10 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
>>          }
>>          case FS_ATTRIBUTE_INFORMATION:
>>          {
>> -               struct filesystem_attribute_info *info;
>> +               FILE_SYSTEM_ATTRIBUTE_INFO *info;
>>                  size_t sz;
>>
>> -               info = (struct filesystem_attribute_info *)rsp->Buffer;
>> +               info = (FILE_SYSTEM_ATTRIBUTE_INFO *)rsp->Buffer;
>>                  info->Attributes = cpu_to_le32(FILE_SUPPORTS_OBJECT_IDS |
>>                                                 FILE_PERSISTENT_ACLS |
>>                                                 FILE_UNICODE_ON_DISK |
>> @@ -5507,7 +5507,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
>>                                          "NTFS", PATH_MAX, conn->local_nls, 0);
>>                  len = len * 2;
>>                  info->FileSystemNameLen = cpu_to_le32(len);
>> -               sz = sizeof(struct filesystem_attribute_info) + len;
>> +               sz = sizeof(FILE_SYSTEM_ATTRIBUTE_INFO) + len;
>>                  rsp->OutputBufferLength = cpu_to_le32(sz);
>>                  break;
>>          }
>> diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
>> index a5dd656c36f1..016ec93e6df4 100644
>> --- a/fs/smb/server/smb_common.h
>> +++ b/fs/smb/server/smb_common.h
>> @@ -56,13 +56,6 @@
>>                  FILE_EXECUTE | FILE_DELETE_CHILD | \
>>                  FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
>>
>> -struct filesystem_attribute_info {
>> -       __le32 Attributes;
>> -       __le32 MaxPathNameComponentLength;
>> -       __le32 FileSystemNameLen;
>> -       __le16 FileSystemName[]; /* do not have to save this - get subset? */
>> -} __packed;
>> -
>>   struct filesystem_device_info {
>>          __le32 DeviceType;
>>          __le32 DeviceCharacteristics;
>> --
>> 2.43.0
>>

