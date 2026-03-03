Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26A21E230E
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 03:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772506859; cv=none; b=XZvhASYV4Elh4ZcRMYM0Jq/V47gFkF9jvqSvy2txCWDz91PFhwFPvkmSRy2IVJCF5pwfXwZxl0r8zUWR5EQsCaaCUlep5Pp9cdeUm1LL5s4pyBLuQbXkjOs39UKREDIIvzUh0R55iPKSqgMFjjiU3p+hm+8jFuyZRrmedDuY56g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772506859; c=relaxed/simple;
	bh=9Kn4wBc9+L+QVqRyRlkcdfmcJlfpDm2/laanG3c31IU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rlqHEiDizTBA4nBmyr+IcT73wm74Pt5c6FjTSFbXZ+aXeDstvrk/vQgX02x3RqaCS6YTsM/SA7HzxVU9keae+6z9UuIpja2ED52aqzDWeTyZOioY84iEfEc/A3XbrXsc6/YquNVVa46b3JfJFuNQnF4NUv0NwosVNm+TIGVnr+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FtjL4EKG; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FtjL4EKG"
Message-ID: <09cb6f53-e5e1-4b42-9b25-b28860fe2a9e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772506856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WLEch/y2RM83ECNs+et/5JFV2QLg9L/eS2imK2YYq/I=;
	b=FtjL4EKG628X/DbbpfqrThNjc0u2Fbc87Bdh0wwpLzNCd+vBymV6EAQYIpgXGQhaJ68j7K
	5lrwNxkOMPWVKzG8sND1hhNiVR7HAqt8c0xdot/bi2PB5PTPEe/0/NMjrV2vBWQ1CsLDqM
	O4/vDqoacneLEsx+DAVEnQkjmOaPCqc=
Date: Tue, 3 Mar 2026 11:00:00 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 5/5] smb: introduce struct file_posix_info
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, chenxiaosong@chenxiaosong.com,
 linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260225041100.707468-1-zhang.guodong@linux.dev>
 <20260225041100.707468-6-zhang.guodong@linux.dev>
 <CAKYAXd8ieg2fvYOK0BwBG8bbT18d9Z2A43-XoC21a5DArwsJKw@mail.gmail.com>
 <b257491a-e821-4b2a-8465-1aa1102d35b9@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ZhangGuoDong <zhang.guodong@linux.dev>
In-Reply-To: <b257491a-e821-4b2a-8465-1aa1102d35b9@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

And we cannot use `SidBuffer[32]` because the size of `SidBuffer[]` on 
the client side is not necessarily 32.

在 2026/3/3 10:41, ZhangGuoDong 写道:
> Hi Namjae,
> 
> C structure cannot have two flexible array members.
> 
> If we make `Sids[]` a flexible array member, then there cannot be any 
> members after it. However, this structure still has `filenamelength` and 
> `filename[]` after it. And `filename[]` is also a flexible array member.
> 
> Do you have any suggestions for this?
> 
> 在 2026/2/27 12:37, Namjae Jeon 写道:
>> You need to add Sids[] flex array here.
>>> +       // var sized owner SID
>>> +       // var sized group SID
>>> +       /* end of POSIX Create Context Response */
>>> +       // le32 filenamelength
>>> +       // u8 filename[]
>>> +} __packed;
> 

