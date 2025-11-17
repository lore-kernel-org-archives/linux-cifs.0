Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618F61367
	for <linux-cifs@vger.kernel.org>; Mon, 17 Nov 2025 00:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763338158; cv=none; b=bEQ+QyoQeCCZ/rRW35QJTaSFzOSnw1Rb2SoJjBBGrvMIdVtnn3h/TT0aQ8qAqHA6vcwvq7LOPybrVqDSu8NDUxyXq3Ad/I5HeyME6PPwvU0PbWZ+rFzTM+Rf+jzdojlTXSBJq5metU3l37YV42/WrKNT1Ltg2PtPKmyTlVI+8Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763338158; c=relaxed/simple;
	bh=cYHUKUecSlnDQB6hYpQf4bqk3Z7WRzmiIJkIL4IvNPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l3hubYg/ZfVFYqLN9m9yzcylSPbRuMSIIjmOmSKq0ppIVi45Zj92dPyo91OFukM3igxLUADLt3uF2T1Xwd5rV2BXAUq8LAHMxL1ctNK5mCUb+M0WJSnXyIflLXwOSy81XL+HGtTRjPmcEz9dvjFw9cNYT278Yjo1PR4H5A/an7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rpd8vYxb; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rpd8vYxb"
Message-ID: <0219f68e-32f6-4511-9ccc-698b77ea12de@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763338151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g9xkUTbcDi0tZb/VYtF5zvTKry3QrKS4ib2+IXtMo5g=;
	b=rpd8vYxbCUqHpsjB9yECawe5h3itjC3glDQQty6N+bLnntb0YvoFRcaq/U+GJTisNTPm/K
	0qpInc7Zpi/e8lMAo9DTNurmf5R68YfLwF5Gn8VIkhTiPJLqKSCDVogM5GcnGL5umWYwz/
	1XBkaavJARqQcQjG/zp07FmSiTpU1uQ=
Date: Mon, 17 Nov 2025 08:08:56 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v8 1/1] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to
 common/fscc.h
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
 christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, chenxiaosong@chenxiaosong.com,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251116065213.282598-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251116065213.282598-2-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd_ZcmQnxAD8iLMjnCvtTrqHvkgPcd_8QSRmfFn1avZ99g@mail.gmail.com>
 <d7682150-7af6-45a3-bc19-251d806e1c7f@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <d7682150-7af6-45a3-bc19-251d806e1c7f@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

And in the following part of the SMB2_QFS_attr() function, it also seems 
that we should change it to `memcpy(..., min_t(..., min_len))`.

```c
SMB2_QFS_attr()
{
...
	if (level == FS_ATTRIBUTE_INFORMATION)
	        memcpy(&tcon->fsAttrInfo, offset
	                + (char *)rsp, min_t(unsigned int,
	                rsp_len, max_len));
...
}
```

Thanks,
ChenXiaoSong.

On 11/17/25 7:47 AM, ChenXiaoSong wrote:
> Yes, we should also add MAX_FS_NAME_LEN here. This was my mistake.
> 
> Thanks,
> ChenXiaoSong.
> 
> On 11/17/25 7:00 AM, Namjae Jeon wrote:
>> On Sun, Nov 16, 2025 at 3:53 PM <chenxiaosong.chenxiaosong@linux.dev> 
>> wrote:
>>>
>>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>>
>>> Modify the following places:
>>>
>>>    - struct filesystem_attribute_info -> FILE_SYSTEM_ATTRIBUTE_INFO
>>>    - Remove MIN_FS_ATTR_INFO_SIZE definition
>>>    - Introduce MAX_FS_NAME_LEN
>>>    - max_len of FileFsAttributeInformation -> 
>>> sizeof(FILE_SYSTEM_ATTRIBUTE_INFO) + MAX_FS_NAME_LEN
>>>    - min_len of FileFsAttributeInformation -> 
>>> sizeof(FILE_SYSTEM_ATTRIBUTE_INFO)
>>>
>>> Then move FILE_SYSTEM_ATTRIBUTE_INFO to common header file.
>>>
>>> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
>>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> Did you check if it is being used here too?
>> cifssmb.c:4866:        sizeof(FILE_SYSTEM_ATTRIBUTE_INFO));
> 

