Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F49A3C0A0A
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 08:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832553; cv=none; b=Cg2RAM+0WjHhf412XUltyPECPf4qKVfvZRHZAMCeyElvmVqUpj1oc3RAS/7J9ADdoRZv1yHdxZydhNMttxQ9yChymwSAkYwbulSPFj6l+aEsBwFnSup4buHEIIkBF5Zcic64EM37w6JeqxhlgkxyDtKFHJmMzNHyw5su33J+Cck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832553; c=relaxed/simple;
	bh=8rTIcR/IvKYK9EEFP9j3eNGRy4YunvPTTsKdQjUnLSI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=AIhbTXFJ0VulcQWMCQ/TqC1dsVY7ItJKZ+uOgpdKUIUIWoGdo7lO7PpYsqtkVEVIMH6E3UlGlLeyFGopIIBoaWWa4zTBKixUKuYWC3DK5E3hPdU9/TNhWZd1i10b38gd5HI/GEbO5r5GqgMywtjaslpbnYSev8vl/z1emH0NU5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Th+BOcVk; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Th+BOcVk"
Message-ID: <582686f6-b296-4950-b0f7-262852e1b43e@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785832548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Op2lfCGPOnxqzI6rJcXV2WLga1CK850zKJcPD9cw1ZA=;
	b=Th+BOcVkcrWor5ykdTWcGpX3EhZiUbFhJO/fCJ+qi0NzYjb4Z3FwjaDDm2FyLmwVFZIE71
	o0LepDM5nEUasF+Te2+tNaXOoNBkVJKBYciDWkG6/ZxrOwMf+2Hy5xG4s0dDTnb7dDHrPa
	J9Ai7v2Xx/6sArhYWHNAZSJR6b3yV7pjE14rwoBaA22GJbDvYMtlx21519EqjAvaa3Vx0s
	CjC9GnyWCMvjncw6L1ao54elLxRL0UvzA4UhB+VZt5lbeLJ6wTrg1v2UyVzmNi0uGcsFly
	tMrJaAEVF8/l75IvYPIt/NRR0YFvgod5ULnG1+2RqsK7IcNz8l6cl8TgpyOr4A==
Date: Tue, 4 Aug 2026 16:34:48 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb/server: check destination is open when renaming
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
References: <20260611085847.653284-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8ah8Jxi55WaoOONUDJEtRpkwTYvmNnL9e+4=FPD2fnHw@mail.gmail.com>
 <c0102f11-e49e-49e0-a7af-0c1dec642096@chenxiaosong.com>
 <CAKYAXd_wZG+T=WYdZC_S7jPsUmsUAeQ_UDsn7uKWzUS5nSSgoQ@mail.gmail.com>
 <b33c7395-6957-4c18-a3f8-a07121e7f338@chenxiaosong.com>
Content-Language: en-US
In-Reply-To: <b33c7395-6957-4c18-a3f8-a07121e7f338@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

I will send v2 soon. For now, we also need to fail with 
STATUS_ACCESS_DENIED if the existing target has an open handle.

Of course, I will also try to implement FileRenameInformationEx (level 
65) in the future.

On 8/4/26 16:28, ChenXiaoSong wrote:
> According to MS-FSA 2.1.5.15.12, level 10 (FileRenameInformation), an 
> overwrite rename must fail with STATUS_ACCESS_DENIED if the existing 
> target still has an open.
> 
> MS-FSA 2.1.5.15.12 FileRenameInformation: https://learn.microsoft.com/ 
> en-us/openspecs/windows_protocols/ms- 
> fsa/87f86c9b-6c2a-4803-84b7-131a74a434fa
> 
> On 8/4/26 15:53, Namjae Jeon wrote:
>> Okay. We can implement this in ksmbd and cifs.ko to pass generic/035 
>> test.
>>
>> Thanks for sharing it.
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

