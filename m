Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C1E1862A
	for <linux-cifs@vger.kernel.org>; Sat, 15 Nov 2025 08:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763194065; cv=none; b=ZKmMn6pE4yH/yGCcrmfsm63YNnHWTBmisQDq5c9gnqpooPwqBSBPQg1TelQrDNKfCea431r9uA6LvFFk89m8wObUo+7lIjINm4Ngp69ktD2BSlFOYDsBsy3H2IAIqQW0QjUkNj0ePAHt39EGuNdiClLB+NBNoR3TWqnUT3ywFr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763194065; c=relaxed/simple;
	bh=iBlPA+f2aCiPDr5N6xDHSbG8b4HI0bGxUON7gYrubUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dJjjdLhANz4khBPbxjDkBQ6Bi60T80E+IplpRi8ksp8SsH5BSGd7jIBOe4AXlw9UbfnlJ4R3NrtbzdTTiBM3fpEVdkrJkBNtMXcFO8fNDHlZrx1ZhHMbAv3G7wFkEVhc8GuJZbJ7MeSoaowkXoEtwkhpq1kbd0ynaSdsRRc2prU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RLojyrNr; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RLojyrNr"
Message-ID: <bb4597b3-65cb-4170-8f15-796ee78b1d5b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763194051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JFWr5f6BjTW35aVPs/1vfYL9i+Lgm1xz2gMv0HdLrGM=;
	b=RLojyrNrL3rz1wSu8OcXYnJ1B8Ai6t1Ix/Bi3mXpC17dQ3MHdpTuR4gp1ly7C8RfKIcvuC
	o0t/t9DT8Otn7otf97YaF1zJ1dWRIgCzso4dqaJ+qcUXQM0aQ9Cw8oLQHPak5b8k04w3VD
	jsRJbZbR9R3I6gQoLaQZXRd6P1Oiya8=
Date: Sat, 15 Nov 2025 16:06:40 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v7 2/2] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to
 common/fscc.h
To: Namjae Jeon <linkinjeon@kernel.org>, chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
 christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, chenxiaosong@chenxiaosong.com
References: <20251113133252.145867-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251113133252.145867-3-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd-E2sSk-8Kw3uZPm-CH8KSr8h0fcCvjFm2YK3eyN1BC3g@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd-E2sSk-8Kw3uZPm-CH8KSr8h0fcCvjFm2YK3eyN1BC3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

It seems we need to add 52 to `max_len` in the `SMB2_QFS_attr()` 
function, similar to struct smb3_fs_vol_info.

Or we can temporarily use the v5 version for now? v5: 
https://lore.kernel.org/all/20251102073059.3681026-13-chenxiaosong.chenxiaosong@linux.dev/

Thanks,
ChenXiaoSong.

On 11/15/25 15:41, Namjae Jeon wrote:
> On Thu, Nov 13, 2025 at 10:34 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> Modify the following places:
>>
>>    - struct filesystem_attribute_info -> FILE_SYSTEM_ATTRIBUTE_INFO
>>    - client: remove MIN_FS_ATTR_INFO_SIZE definition,
>>              MIN_FS_ATTR_INFO_SIZE -> sizeof(FILE_SYSTEM_ATTRIBUTE_INFO)
>>
>> Then move FILE_SYSTEM_ATTRIBUTE_INFO to common header file.
>>
>> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> ---
>>   fs/smb/client/cifspdu.h    | 10 ----------
>>   fs/smb/client/smb2pdu.c    |  2 +-
>>   fs/smb/common/fscc.h       |  8 ++++++++
>>   fs/smb/server/smb2pdu.c    |  6 +++---
>>   fs/smb/server/smb_common.h |  7 -------
>>   5 files changed, 12 insertions(+), 21 deletions(-)
>>
>> diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
>> index d84e10b1477f..49f35cb3cf2e 100644
>> --- a/fs/smb/client/cifspdu.h
>> +++ b/fs/smb/client/cifspdu.h
>> @@ -2068,16 +2068,6 @@ typedef struct {
>>   #define FILE_PORTABLE_DEVICE                   0x00004000
>>   #define FILE_DEVICE_ALLOW_APPCONTAINER_TRAVERSAL 0x00020000
>>
>> -/* minimum includes first three fields, and empty FS Name */
>> -#define MIN_FS_ATTR_INFO_SIZE 12
>> -
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
>> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
>> index 30c391424022..4ccc8d1e130d 100644
>> --- a/fs/smb/client/smb2pdu.c
>> +++ b/fs/smb/client/smb2pdu.c
>> @@ -5982,7 +5982,7 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
>>                  min_len = sizeof(FILE_SYSTEM_DEVICE_INFO);
>>          } else if (level == FS_ATTRIBUTE_INFORMATION) {
>>                  max_len = sizeof(FILE_SYSTEM_ATTRIBUTE_INFO);
>> -               min_len = MIN_FS_ATTR_INFO_SIZE;
>> +               min_len = sizeof(FILE_SYSTEM_ATTRIBUTE_INFO);
> FILE_SYSTEM_ATTRIBUTE_INFO is being used elsewhere on the smb client,
> and there are cases where sizeof(FILE_SYSTEM_ATTRIBUTE_INFO) is being
> used. Will there really be no problems if we change it to flex-array?

