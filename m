Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27F332B985
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 08:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772528392; cv=none; b=EwlyDFzR3XvEgdAMe5jps6xU1LKvg6qGsZfgj7zm1279ENraVzupfkCzPPlad8bAEXsIYTjuxFNZLwnHssHf6YJ77G4LGJuiRNuOUUAumPShV067HEbVF64OmvFG6uoajHzmKQYvxkoajRMQwwOGtg2kASpQYwrhdqAQ4TZntRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772528392; c=relaxed/simple;
	bh=wjv3xguKblJCxburJ5j7m3VdHascX0qjLQyVCJDFHIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CeORe1rZy1d1QnIhHYFs7tbyQjm2roNKAJLm4LIjjgS5nr6AgKFOcM68ZtxS2MxkLPt4ClwTCLCJBpgevBSfHORKlpRaNRyiBJtMEi1yEFIZ+9+cSr/Kjwbi7PtWAAERm6xsOov4QZX6sn6w5R2JOeC9nOXNkJCdrF2UL27UA4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=WEbJpQzk; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="WEbJpQzk"
Message-ID: <634dbb0b-9a5d-4f3d-ab5f-f4dc75e3527e@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1772528386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7SNIc1ZtQEq7gv+25vilN/Q3chOWmnP5d+qDGBMla3k=;
	b=WEbJpQzkUIBmm6NPiFco2hBgfUGzQ0ZuktIMUSwBCIdVfk9wPfVPbBpN4H5TpgHDEC3vup
	TyLPECUxhvkTwD7PCze6tNSaSU4mYkngup77tjxf/wfaKxihSaAXXgj7ABZYNF2sJCJQAx
	7gy3rY6MtSWn3k8PghOggTYLsQGsSua3uZ8/OuYdqja31toPlQIuwZQfMYKPpHKXBVR7Pf
	RCujZV70G5vwgH4vepF6MXsvN04OIkG35zRknA3RButymGdgqTtqo2Ek2bSqxCeroZbmu+
	ZAsz1fv5q1DdmXhznPjbXHGepd4q/Qt0thfLIdH4BHSx5/gpFPg94ABd45lk2w==
Date: Tue, 3 Mar 2026 16:58:48 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 5/5] smb: introduce struct file_posix_info
To: ZhangGuoDong <zhang.guodong@linux.dev>,
 Namjae Jeon <linkinjeon@kernel.org>, smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260225041100.707468-1-zhang.guodong@linux.dev>
 <20260225041100.707468-6-zhang.guodong@linux.dev>
 <CAKYAXd8ieg2fvYOK0BwBG8bbT18d9Z2A43-XoC21a5DArwsJKw@mail.gmail.com>
 <b257491a-e821-4b2a-8465-1aa1102d35b9@linux.dev>
 <09cb6f53-e5e1-4b42-9b25-b28860fe2a9e@linux.dev>
 <87181afa-553a-475c-8f08-3c292ba30ffb@chenxiaosong.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <87181afa-553a-475c-8f08-3c292ba30ffb@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Steve,

In client-side, it seems there is a bug in the smb2_compound_op():

   SMB2_query_info_init(..., sizeof(struct smb311_posix_qinfo *) + ...)

We should calculate the size of `struct smb311_posix_qinfo`, not the 
size of its pointer.

Code refactoring is very meaningful as it can uncover some potential issues.

Thanks,
ChenXiaoSong <chenxiaosong@chenxiaosong.com>

在 2026/3/3 15:31, ChenXiaoSong 写道:
> How about merging the two flexible array members and naming it 
> `sids_and_name[]`?
> 
> 在 2026/3/3 11:00, ZhangGuoDong 写道:
>> And we cannot use `SidBuffer[32]` because the size of `SidBuffer[]` on 
>> the client side is not necessarily 32.
>>
>> 在 2026/3/3 10:41, ZhangGuoDong 写道:
>>> Hi Namjae,
>>>
>>> C structure cannot have two flexible array members.
>>>
>>> If we make `Sids[]` a flexible array member, then there cannot be any 
>>> members after it. However, this structure still has `filenamelength` 
>>> and `filename[]` after it. And `filename[]` is also a flexible array 
>>> member.
>>>
>>> Do you have any suggestions for this?
>>>
>>> 在 2026/2/27 12:37, Namjae Jeon 写道:
>>>> You need to add Sids[] flex array here.
>>>>> +       // var sized owner SID
>>>>> +       // var sized group SID
>>>>> +       /* end of POSIX Create Context Response */
>>>>> +       // le32 filenamelength
>>>>> +       // u8 filename[]
>>>>> +} __packed;
>>>
>>
> 

