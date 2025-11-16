Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD34BA3D
	for <linux-cifs@vger.kernel.org>; Sun, 16 Nov 2025 23:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763336896; cv=none; b=K7q+xmxHjQv8gdcJM9gidhjbk3BIhVxyh7CGMJ5EYIAIIgY7kFzJ2Tq2Ho3TQDw/IZnaUdN5tHXjpVgju5UQpZjMCRhi8EGJxrWDx6cpGbn3LyvvegxltLzDJ+I5MMFrnu6TgBOfpvaiLDMLN3OBcjNFN528z+lr+L6UYz5xSko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763336896; c=relaxed/simple;
	bh=2tci6KH0XthjGXaZCTioAjumN1+YUqbpzlovSIZs/tU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qzuvCuLBy1hF5qK73GeyMnCW3RJ6sHAaFk9A7ctxwbhJldHvU72WhP30HTpi2VnjgP2ufc7Vi2qqKQAFnlVaEC0sm5rVhNm1ojyUhVKgFExPGfCbIKX5hNB8L3RqvPZpntkiX/x4DtUZ2aDCMvda1TLObOMLnK+0+rm45P5ZdPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fNnl2E42; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fNnl2E42"
Message-ID: <d7682150-7af6-45a3-bc19-251d806e1c7f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763336891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z3WM8Hxr+Jp9kM3CDfksIZHciQ+E85TMeq1E6yFHPDg=;
	b=fNnl2E42L03ij2/D7x7DEAhM30pjwVdsfjQ5H2umAzANgne5QU8Sgm0FDjGF9uo0LoNwom
	74+zoeGxH9wri9Z0fQSbFXA6SbAuCgL7qHqIj1cJ7t2YfljEPWqjeawMZzsnFEI2NCDIH9
	nrQXPXpbAUMl4MwwUpxx1Gv5sYiT+ZY=
Date: Mon, 17 Nov 2025 07:47:54 +0800
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
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd_ZcmQnxAD8iLMjnCvtTrqHvkgPcd_8QSRmfFn1avZ99g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Yes, we should also add MAX_FS_NAME_LEN here. This was my mistake.

Thanks,
ChenXiaoSong.

On 11/17/25 7:00 AM, Namjae Jeon wrote:
> On Sun, Nov 16, 2025 at 3:53 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> Modify the following places:
>>
>>    - struct filesystem_attribute_info -> FILE_SYSTEM_ATTRIBUTE_INFO
>>    - Remove MIN_FS_ATTR_INFO_SIZE definition
>>    - Introduce MAX_FS_NAME_LEN
>>    - max_len of FileFsAttributeInformation -> sizeof(FILE_SYSTEM_ATTRIBUTE_INFO) + MAX_FS_NAME_LEN
>>    - min_len of FileFsAttributeInformation -> sizeof(FILE_SYSTEM_ATTRIBUTE_INFO)
>>
>> Then move FILE_SYSTEM_ATTRIBUTE_INFO to common header file.
>>
>> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> Did you check if it is being used here too?
> cifssmb.c:4866:        sizeof(FILE_SYSTEM_ATTRIBUTE_INFO));

