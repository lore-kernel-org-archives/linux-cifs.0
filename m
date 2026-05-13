Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9974D990A
	for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 16:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778691270; cv=none; b=dQ/lI32868/DuC11cC2W+0fjnkVnsn9nwIbUG8P4LQ+hHrHUqvAikjaz1dASCnN0EgObTrStJBnRTxZXagPmNihp4xVAvG8rTJZRe4u0C9vgsLvvdGWyjGN3Z/tgJJ4dEJJ958IPovxly/dJ/rD+KY3wvZ6FkQ2KMjsVpRqfr9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778691270; c=relaxed/simple;
	bh=X+vAvrk4BOoiLqoEBSjuTBlkKJrS3AA/TWW4u8XPhzY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ban8OBgcJpRBh1GFVZuYAG6qP7BgCj5uIgs/u7iiqlWo7z+cLA1E9nkvzT8+wYAFViZXPjuo8m6Y423md894LPfObnek3E11JOulQlCUpgD29ler87Rpur4unEnsJpS509FKbVtuH7tO0EvHlIDLDDsq0D9oToThuzXe4EHEIXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=S5ovTFnS; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="S5ovTFnS"
Message-ID: <b5400da0-b60e-4bed-87a6-92b1b009c2dd@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1778691264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6yc4C7B3dStFEa9zOHeP/EI8UB9Y+B5NDztv8Xu7raQ=;
	b=S5ovTFnS0HdxF2tW6YvS+TX5gUS6qcOviymv4z4QJNjozEYJIOdrcEVNN46AtVW94+gfuj
	DhOs0sa/9nFmoSRWCa2Dl0b6ZaJjN0b1eC/ig+sXJfYvmtwS1zCsFXmo36k5nfLyOGMP7V
	3dL5s+Bt7ng4lELoD3xyebb7FwyEEv/0MJ5x65YR1fGr6RMYqPwN5+t8XReyesAFKopzwb
	47VipBzLA8ja+jIkJnjLt6G5hPVCyY+1EaTyMqsAkGSmR+sbNesSZKjznjjzb66wlK7KAs
	hUedWa/1jFz10+lB2RxJbEJiasnRBTb5BUqxL9PFF7EKfSXCoBZyc3VFcOyvSg==
Date: Thu, 14 May 2026 00:54:12 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: generic/004 server bug
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
 Huiwen He <hehuiwen@kylinos.cn>
Cc: Paulo Alcantara <pc@manguebit.org>, CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mvP9s_KMc2G-_AsP__G0S5JCmrigOT-7U_ZNu1pLf+Q2g@mail.gmail.com>
 <CAKYAXd-8VmgLNX=0TnsPL1LP2u-V-zOs+Z08dKHDZUbt+q2AAw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd-8VmgLNX=0TnsPL1LP2u-V-zOs+Z08dKHDZUbt+q2AAw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

I am currently debugging this issue: 
https://chenxiaosong.com/en/smb-xfstests-generic-004.html

My team member Huiwen He <hehuiwen@kylinos.cn> will continue my work.

On 2026/5/12 15:59, Namjae Jeon wrote:
> On Mon, May 11, 2026 at 6:36 AM Steve French <smfrench@gmail.com> wrote:
>>
>> I noticed generic/004 fails to ksmbd, likely server bug since it works
>> to Samba and Windows and Azure.   Test generic/004 was recently
>> enabled when O_TMPFILE support was added by Paulo.
>>
>> Ideas welcome on the ksmbd problem this found.
> If there are no volunteers for a while, I'll take a look at it later.
> I will add it to my to-do list.
> Thanks.
> 
