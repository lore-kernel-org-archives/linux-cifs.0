Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0321E2E413
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 01:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764899099; cv=none; b=cONl/6b9BXLlK4Hf9Yy6wO2ECqpwYvaSlAndllhiEdOXsW3wpGjHmDKBdPLO/poPrg48M30RwkvPjyO4V+aJhaS76nDPO/XF8fise/+i6PF1yl0hcqrJ4/qqCJPrj780nN7o12oG+soESXY941LFE4GecdMi0jSeEgcXC3BdFdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764899099; c=relaxed/simple;
	bh=Xq4FnqdqMMw5LwnWK9JYbB2ibycxGrW+X+KTjXef/qE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZGKUhBnEof9ha58KL7GrpKSPMUzNnspKU3WSdRMNa+9m9jVebLbpahKm8w2EXee18iZqrnQJVTeoaI0CXx408El5qOw+nW6y1X3+Q+umOSOiFfbSPBYhCcNuj5WkoFSoCVjks2ctTpUksvZApg3xWOWIQyRP9bAsJxFMGI7+faY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RgTBBq5k; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RgTBBq5k"
Message-ID: <7eac3a36-d2a2-400f-a4a2-7cec245a2709@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764899085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8N2Xcqu5T+Bstv2mPU1acoMfIS7Bq5WLmCYr4R3ahwA=;
	b=RgTBBq5kmf+8+6keEDC9Oof4eZdLwy84Rd4s1uTnl4yf+84QQIzaR9eUv6CE7vYyR6Vb++
	xPzxdgMoWZ/uJPAp5hMdTqKULNMtBDoE4sGFJh7wW4YAk7GEWBeBsThpZugXOhUOECqAGG
	xM/Cl/dHTYfleJqlpV5QeuJeNQXNzQk=
Date: Fri, 5 Dec 2025 09:44:05 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 09/10] smb: create common/common.h and common/common.c
To: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, sfrench@samba.org,
 linkinjeon@samba.org, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, chenxiaosong@chenxiaosong.com,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251204045818.2590727-10-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd_-ctfkz1E_Sqh0bJMarUE8rDrd2o7yKKa_cOFGPaYELg@mail.gmail.com>
 <5f7758db-cf88-4335-9a03-72be1f7d6b65@linux.dev>
 <CAH2r5mv74OszZ610pTn+vZq3ubRdx=+au=SHRNFpyt2rigKkYQ@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAH2r5mv74OszZ610pTn+vZq3ubRdx=+au=SHRNFpyt2rigKkYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Now, where should common/smb2maperror.c go? Should it be built into both 
cifs.ko and ksmbd.ko?

Thanks,
ChenXiaoSong.

On 12/5/25 09:36, Steve French wrote:
> i lean against an 'smbcommon.ko'   - it can be helpful to move common
> code (headers, #defines etc) into fs/smb/common but other than
> smbdirect code (where smbdirect.ko makes sense for cifs.ko, ksmbd.ko,
> Samba and user space AI apps e.g. to use), I lean against creating new
> modules for the client and server.
> 
> ksmbd.ko for server code
> cifs.ko (or maybe someday renamed to smb3.ko) for client code
> smbdirect.ko for the RDMA/smbdirect code shared by ksmbd/cifs.ko/userspace tools
> 
> maybe (as they did for the md4 code creating an cifs_md4.ko so that
> less secure code doesn't have to be linked in if unneeded) someday we
> could split an "smb1.ko" out for the SMB1 related code (since we want
> to discourage use of old insecure dialects, and could shrink cifs.ko,
> and slightly simplify it)
> 
> Finding common code is good - but let's not complicate things by
> creating lots of new modules - in the short term the focus is on
> sanely splitting the common RDMA/smbdirect code out (because 1) it is
> large enough 2) it will have use cases outside of cifs.ko and
> ksmbd.ko).  But I lean against creating multiple new modules in the
> short term.
> 
> On Thu, Dec 4, 2025 at 6:59 PM ChenXiaoSong
> <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> OK, I will create new smb2maperror.ko and will send v2 soon.
>>
>> Thanks for your review and suggestions.
>>
>> Thanks,
>> ChenXiaoSong.
>>
>> On 12/5/25 08:35, Namjae Jeon wrote:
>>> On Thu, Dec 4, 2025 at 2:00 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>>>
>>>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>>>
>>>> Preparation for moving client/smb2maperror.c to common/.
>>>>
>>>> We can put cifs_md4 and smb2maperror into a single smb_common.ko,
>>>> instead of creating two separate .ko (cifs_md4.ko and smb2maperror.ko).
>>> Sorry, I prefer not to create new *.ko for only smb2maperror.
>>>>
>>>>     - rename md4.h -> common.h, and update include guard
>>>>     - create common.c, and move module info from cifs_md4.c into common.c
>>> ksmbd does not use md4 in smb/common, I don't prefer this either.
>>> I would appreciate it if you could send me the patch set again except these.
>>>>
>>>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
> 
> 

