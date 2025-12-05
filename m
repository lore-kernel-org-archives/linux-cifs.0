Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC2A2DF6F4
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 02:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764900926; cv=none; b=ErAHXIwjQWqzvdJFcgBgWLdtRvoTv6zI4TrT7Mu/HaDXe4WrgLJ2GSsPVsgdCVjAdJos+ix8v6KlSCVLXd5wtoKOiKcwVMVppfBaMmCasQ13/6rOJK/4sK/h/+4BvERRyLn+PBnwnhJKlHaAKOhri+zl/aFOCN100mhIGJdUwV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764900926; c=relaxed/simple;
	bh=Xea2LvscI4dt+xhspqD1NOpqzKOeEMQ5YSkxTLrcVoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UfXaOGCQEfeSZIMjdgKsR4rcV3h6jL7wT9Oybi0br/lSuYD25WWCccwpjbPn6djo1EehOS5OAXO6pGnXnJnKCrPfR3Q6DczYOb6+PIxa/A6x+aOvHmlNQvtz8vcqhs71sQCl8abYj+xOjw7jCfdQYWj6Prv67AqQh7wz+xJykQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U0mk09LI; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U0mk09LI"
Message-ID: <b5a416d2-b097-4378-b25d-a6ab077f1eed@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764900909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cx+rO0kd2g3nRsO7j3DYC4JlPWDpmUNENfxmRAInZ/I=;
	b=U0mk09LIQboxQeMnkMme6AuraIQ3AWXIImPlB9gdPh8YvVHTkfHP6XZPnP1ikhSk1WnD1A
	IeCGfIg7vanUgvYJ42woP4VFXhKzBbp1hd/Dm/3SAP1Bn0nhT2Lam3tSpqiK+EfyT/AxVM
	1LaD8DEmXdVjTvstZOH5vvBR/l2gBlI=
Date: Fri, 5 Dec 2025 10:14:23 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 09/10] smb: create common/common.h and common/common.c
To: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linkinjeon@samba.org,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 chenxiaosong@chenxiaosong.com, ChenXiaoSong <chenxiaosong@kylinos.cn>,
 "Stefan (metze) Metzmacher" <metze@samba.org>
References: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251204045818.2590727-10-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd_-ctfkz1E_Sqh0bJMarUE8rDrd2o7yKKa_cOFGPaYELg@mail.gmail.com>
 <5f7758db-cf88-4335-9a03-72be1f7d6b65@linux.dev>
 <CAH2r5mv74OszZ610pTn+vZq3ubRdx=+au=SHRNFpyt2rigKkYQ@mail.gmail.com>
 <7eac3a36-d2a2-400f-a4a2-7cec245a2709@linux.dev>
 <CAH2r5mtEmJdCuG_U3fhk66Luf+XN4xPK5T3ozpOuuDOrTDHncA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAH2r5mtEmJdCuG_U3fhk66Luf+XN4xPK5T3ozpOuuDOrTDHncA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Alternatively, we could consider placing MD4 into an smb1_common.ko, and 
creating an smb2_common.ko for the SMB2/3 common code. What do you think?

Thanks,
ChenXiaoSong.

On 12/5/25 09:50, Steve French wrote:
> On Thu, Dec 4, 2025 at 7:44 PM ChenXiaoSong
> <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> Now, where should common/smb2maperror.c go? Should it be built into both
>> cifs.ko and ksmbd.ko?
>>
>> Thanks,
>> ChenXiaoSong.
> 
> I am open to other opinions - especially from Metze and Namjae who are
> dealing with similar issues in splitting out the RDMA/smbdirect code,
> but I lean toward (at least for now) just including it in both cifs.ko
> or ksmbd.ko, or not moving the C code yet (just move to common headers
> for #defines, inlined functions that are put in headers etc.).  I
> consider moving the common C functions into a common C file used by
> cifs.ko and ksmbd.ko is lower priority than other cleanup.
> 
> Do you have a list of all of the (general types of) functions that
> smb3common.ko could contain?  IIRC you mentioned for mapping errors
> but what other routines could easily make it into this proposed common
> module with low risk?
> 
>>
>> On 12/5/25 09:36, Steve French wrote:
>>> i lean against an 'smbcommon.ko'   - it can be helpful to move common
>>> code (headers, #defines etc) into fs/smb/common but other than
>>> smbdirect code (where smbdirect.ko makes sense for cifs.ko, ksmbd.ko,
>>> Samba and user space AI apps e.g. to use), I lean against creating new
>>> modules for the client and server.
>>>
>>> ksmbd.ko for server code
>>> cifs.ko (or maybe someday renamed to smb3.ko) for client code
>>> smbdirect.ko for the RDMA/smbdirect code shared by ksmbd/cifs.ko/userspace tools
>>>
>>> maybe (as they did for the md4 code creating an cifs_md4.ko so that
>>> less secure code doesn't have to be linked in if unneeded) someday we
>>> could split an "smb1.ko" out for the SMB1 related code (since we want
>>> to discourage use of old insecure dialects, and could shrink cifs.ko,
>>> and slightly simplify it)
>>>
>>> Finding common code is good - but let's not complicate things by
>>> creating lots of new modules - in the short term the focus is on
>>> sanely splitting the common RDMA/smbdirect code out (because 1) it is
>>> large enough 2) it will have use cases outside of cifs.ko and
>>> ksmbd.ko).  But I lean against creating multiple new modules in the
>>> short term.
>>>
>>> On Thu, Dec 4, 2025 at 6:59 PM ChenXiaoSong
>>> <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>>>
>>>> OK, I will create new smb2maperror.ko and will send v2 soon.
>>>>
>>>> Thanks for your review and suggestions.
>>>>
>>>> Thanks,
>>>> ChenXiaoSong.
>>>>
>>>> On 12/5/25 08:35, Namjae Jeon wrote:
>>>>> On Thu, Dec 4, 2025 at 2:00 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>>>>>
>>>>>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>>>>>
>>>>>> Preparation for moving client/smb2maperror.c to common/.
>>>>>>
>>>>>> We can put cifs_md4 and smb2maperror into a single smb_common.ko,
>>>>>> instead of creating two separate .ko (cifs_md4.ko and smb2maperror.ko).
>>>>> Sorry, I prefer not to create new *.ko for only smb2maperror.
>>>>>>
>>>>>>      - rename md4.h -> common.h, and update include guard
>>>>>>      - create common.c, and move module info from cifs_md4.c into common.c
>>>>> ksmbd does not use md4 in smb/common, I don't prefer this either.
>>>>> I would appreciate it if you could send me the patch set again except these.
>>>>>>
>>>>>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>>>
>>>
>>>
>>
> 
> 

