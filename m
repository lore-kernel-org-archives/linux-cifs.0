Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FBC2FB621
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 05:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764827773; cv=none; b=dBtIy1Gv+cQ8knnigY2noEWgffbTNIU4bHBWqbuVvB7QtVZJ+HCVsjkj/7QzY31mPJW17kf/rbI2FGWMTVyFjT75X259so0D3s/ja5tU+UySAhIDCA8HKGv7/vhli4VuHKWOcciHOkDW/WVQvHao5iWx2xsWaW6YQQnz/tV3lbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764827773; c=relaxed/simple;
	bh=Qsk8pHHcsyflKI1E3+J3FIUX9RIpsBEQCkWOEMZeLhc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pk7y+eTvDEZWfMwk08pQt1NgPToJZI0LdnRX+SHDHgks5KARAiX23ODRYPrumRhosCsukTq1TDFpQxwbOlnBQkFSaIzVlIp2SVtBvMSGtGrgY/5518KXWy3xHunBeCsMGlnJUhbreOTrY+3aTi5GX/4nQ54FTPrQ5pVEZGA50hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a7VTP4TY; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a7VTP4TY"
Message-ID: <af214141-4a8f-4d79-819c-26edb016be66@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764827757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JVRQeuE3di9JM/1OKvwjd3eqJZQjVEvy+FDcFLt8V0I=;
	b=a7VTP4TYGJ9nwWpuf3FlxRN5LojmES2BoHTLgxEUJInkW/SH9jkMAPvDuuJgx3a2BJc9SU
	53s6+rzTBA9nFtZ78g+8xxPS27K/Tt8YkR2GEtlaDlAc7hoQgEqH4LvXHLSo4L8SJ8NwCp
	Ana1xP97uV9n5C3W9uT3R+wecfMnCFA=
Date: Thu, 4 Dec 2025 13:55:16 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 01/10] smb/client: reduce loop count in
 map_smb2_to_linux_error() by half
To: Steve French <smfrench@gmail.com>
Cc: linkinjeon@kernel.org, linkinjeon@samba.org, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, chenxiaosong@chenxiaosong.com,
 ChenXiaoSong <chenxiaosong@kylinos.cn>,
 samba-technical <samba-technical@lists.samba.org>
References: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251204045818.2590727-2-chenxiaosong.chenxiaosong@linux.dev>
 <CAH2r5mu25T8sBO4P25St_H0F0KMenn+5QGWx1Tfa+=6AsF6aNw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAH2r5mu25T8sBO4P25St_H0F0KMenn+5QGWx1Tfa+=6AsF6aNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Thanks for your review.

I'll test these patches as soon as possible. Besides smbtorture and 
xfstests, what other testing tools are available for SMB?

Thanks,
ChenXiaoSong.

On 12/4/25 13:49, Steve French wrote:
> Have merged the first three patches (see below) in this series into
> cifs-2.6.git for-next pending additional review and testing.   The
> other seven may also be ok - but want to look more carefully at them,
> more review appreciated
> 
> ba521f56912f (HEAD -> for-next, origin/for-next) smb: add two elements
> to smb2_error_map_table array
> 905d8999d67d smb/client: remove unused elements from smb2_error_map_table array
> 26866d690bd1 smb/client: reduce loop count in map_smb2_to_linux_error() by half
> 
> On Wed, Dec 3, 2025 at 10:59 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> The smb2_error_map_table array currently has 1740 elements. When searching
>> for the last element and calling smb2_print_status(), 3480 comparisons
>> are needed.
>>
>> The loop in smb2_print_status() is unnecessary, smb2_print_status() can be
>> removed, and only iterate over the array once, printing the message when
>> the target status code is found.
>>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>> ---
>>   fs/smb/client/smb2maperror.c | 30 ++++++------------------------
>>   1 file changed, 6 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
>> index 12c2b868789f..d1df6e518d21 100644
>> --- a/fs/smb/client/smb2maperror.c
>> +++ b/fs/smb/client/smb2maperror.c
>> @@ -2418,24 +2418,6 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
>>          {0, 0, NULL}
>>   };
>>
>> -/*****************************************************************************
>> - Print an error message from the status code
>> - *****************************************************************************/
>> -static void
>> -smb2_print_status(__le32 status)
>> -{
>> -       int idx = 0;
>> -
>> -       while (smb2_error_map_table[idx].status_string != NULL) {
>> -               if ((smb2_error_map_table[idx].smb2_status) == status) {
>> -                       pr_notice("Status code returned 0x%08x %s\n", status,
>> -                                 smb2_error_map_table[idx].status_string);
>> -               }
>> -               idx++;
>> -       }
>> -       return;
>> -}
>> -
>>   int
>>   map_smb2_to_linux_error(char *buf, bool log_err)
>>   {
>> @@ -2452,16 +2434,16 @@ map_smb2_to_linux_error(char *buf, bool log_err)
>>                  return 0;
>>          }
>>
>> -       /* mask facility */
>> -       if (log_err && (smb2err != STATUS_MORE_PROCESSING_REQUIRED) &&
>> -           (smb2err != STATUS_END_OF_FILE))
>> -               smb2_print_status(smb2err);
>> -       else if (cifsFYI & CIFS_RC)
>> -               smb2_print_status(smb2err);
>> +       log_err = (log_err && (smb2err != STATUS_MORE_PROCESSING_REQUIRED) &&
>> +                  (smb2err != STATUS_END_OF_FILE)) ||
>> +                 (cifsFYI & CIFS_RC);
>>
>>          for (i = 0; i < sizeof(smb2_error_map_table) /
>>                          sizeof(struct status_to_posix_error); i++) {
>>                  if (smb2_error_map_table[i].smb2_status == smb2err) {
>> +                       if (log_err)
>> +                               pr_notice("Status code returned 0x%08x %s\n", smb2err,
>> +                                         smb2_error_map_table[i].status_string);
>>                          rc = smb2_error_map_table[i].posix_error;
>>                          break;
>>                  }
>> --
>> 2.43.0
>>
> 
> 

