Received: from smtp.smtpout.orange.fr (smtp-18.smtpout.orange.fr [80.12.242.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2A51DACBE;
	Fri,  4 Oct 2024 18:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728067482; cv=none; b=MaEZHzNTFQOhU8VEGYKfhVy01OK2lmpaj+wFBziJdTY7i54fkF7eiRVfEbal2ELfzca//SBRmxQRhCXBOtsQHT/5uqjYZemuMUushcy9+01yzE2Q4ggAUnlf+PKVfIFEac+DGgpHCSytYdnaF/G4VJk5UYXixWg+a/co+JUA+dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728067482; c=relaxed/simple;
	bh=597Q6wValzeoDXD0GM6Nint4SOpQm2O1sfyPaJqB6Es=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mKNqk53bFAJ9PXLyZx7aRtmlKkWIMikbiWOReV0TulBc17DSvrwIy3OK1MM+beKdEbzIcCyeVB+9Xkg4zdadqVeSVw+heNYgbQ7XXDzxMF9FOH1124SVupyrPIj+cBiEpHb9Jt/f+LL4J4/b4sQMJMpL86arKAdodF0zaC++IAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=dwVRikjG; arc=none smtp.client-ip=80.12.242.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="dwVRikjG"
Received: from [192.168.1.37] ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id wmn2sZ1SktQe6wmn2sO60n; Fri, 04 Oct 2024 20:12:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1728065553;
	bh=+FJ6p6QOqtxrsdlaHKbUcyU854pjPY4SGHBHRXEAZ+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=dwVRikjGENzkhJzghHSh3ijv2O8o/IhDUk6UMg9iuCydZweAJLH+8YiCE7HAGVhOF
	 k9x9imNawEjzg1eW+a5dLN9YoFlQw6klSXGyeUiy7ddQaN6SfuoNmFFpz/4NB7563m
	 SnuLRbi06yJ2XQOrwiySpCmOZYs4e4dthH2wu1krB5sVfe/IH1fCRwxdDbfJGfcDlD
	 Zny9iyF2IPFQceHnkjsd/RdP/WXvO0uDlG5yq2mxjQDvto4SJx6KKPlDACQEZOH6fG
	 zj5fugQi5tC1Mw0FzhSvJlCMMgtfCL5BI7aJMl21a5I2NORdfX8qODeqJkIoefB7Uk
	 /ahlKIMKgiN1A==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Fri, 04 Oct 2024 20:12:33 +0200
X-ME-IP: 90.11.132.44
Message-ID: <c973f853-87b6-4dba-955f-1eccecd60f8c@wanadoo.fr>
Date: Fri, 4 Oct 2024 20:12:30 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fix logically dead code
To: Shuah Khan <skhan@linuxfoundation.org>,
 Advait Dhamorikar <advaitdhamorikar@gmail.com>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, David Howells <dhowells@redhat.com>,
 Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, anupnewsmail@gmail.com
References: <20241004103051.43862-1-advaitdhamorikar@gmail.com>
 <b04634a4-1301-4f73-a6eb-05ef79954aee@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <b04634a4-1301-4f73-a6eb-05ef79954aee@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 04/10/2024 à 20:00, Shuah Khan a écrit :
> On 10/4/24 04:30, Advait Dhamorikar wrote:
>> The if condition in collect_sample: can never be satisfied
>> because of a logical contradiction.
> 
> Add a better change log explaining how you found the problem.
> 
> Also your short log is missing subsystem information.
> Check submitting patches document for details on how
> to write shot logs and change logs.
> 
>>
>> Fixes: 94ae8c3fee94 ("smb: client: compress: LZ77 code improvements 
>> cleanup")
>> Signed-off-by: Advait Dhamorikar <advaitdhamorikar@gmail.com>
>> ---
>>   fs/smb/client/compress.c | 4 ----
>>   1 file changed, 4 deletions(-)
>>
>> diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
>> index 63b5a55b7a57..766b4de13da7 100644
>> --- a/fs/smb/client/compress.c
>> +++ b/fs/smb/client/compress.c
>> @@ -166,7 +166,6 @@ static int collect_sample(const struct iov_iter 
>> *iter, ssize_t max, u8 *sample)
>>       loff_t start = iter->xarray_start + iter->iov_offset;
>>       pgoff_t last, index = start / PAGE_SIZE;
>>       size_t len, off, foff;
>> -    ssize_t ret = 0;
>>       void *p;
>>       int s = 0;
>> @@ -193,9 +192,6 @@ static int collect_sample(const struct iov_iter 
>> *iter, ssize_t max, u8 *sample)
>>                   memcpy(&sample[s], p, len2);
>>                   kunmap_local(p);
>> -                if (ret < 0)
>> -                    return ret;
>> -
> 
> The change itself looks good to me - unless the intent is to
> check the return from kunmap_local() and take action based on
> it instead of removing the conditional that checks the ret value.

IIUC, kunmap_local() does not return anything.

CJ

> 
>>                   s += len2;
>>                   if (len2 < SZ_2K || s >= max - SZ_2K)
> 
> thanks,
> -- Shuah
> 
> 

