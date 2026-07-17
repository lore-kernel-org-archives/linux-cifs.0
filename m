Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6729C3ABD82
	for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 08:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784278776; cv=none; b=lZy0cHMPP+1Nn/KEh2gHaNBvjnrs9OSP5JG42X9lqXYqZd2zyvlx2IZu7hKadomoQddOMrvrZY9+Ffnzrcpmx3x8/MCRvvI2DZJI/xHNcIP9GqUbkNruh0MokglkSmaIPxCNLF3ny2TvyZaajYAaLqtgJvZn62mT5Fi8YLbAAy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784278776; c=relaxed/simple;
	bh=EcW7rDQFWmMLql+JsZRFKloubuM9d9wTZLkuwKPhmks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fhw/jCd7S1CQUP+vIg+p86z22qh+DAzrgf3ap8pW5i12fbeeel/dIe/2VmK3iKfNQ37KZISpJK34ZkVnNochkMYCiOCQtpZil6ELr7UII4uJ/Bx0WfSpelfYva6LVRVvrA0ZZthHU7wRz9Fl/FFfUdUgMgwuwJgyyUBNM0ECBzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=GL/W/Uvs; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="GL/W/Uvs"
Message-ID: <687d3602-79d9-46b7-88e3-c01d31a93c74@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784278769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7mdRA/Y4wvUll+rUdY/YMM9riVqoZL4VET83vWoLBCA=;
	b=GL/W/UvsVm4dCg5WkWmUAUiCrQ6uQfTphCJiTE7fktlUsY3b+2finHQW8crgYwU55Sntkf
	8XVhJmrdeV+6CCfI2EUwSYQ3sjqu8ItREsgPwMQFpthy/7w09BdehjWIR2ST8JBFfJ0iBa
	70W6/oHux/dhRrnYIH3BOFKfovYeDj185hsz6usT2GGpxBchB23ZCmBkBIOXh9tZjjKzKF
	I3eXGoOi0luTDhVAN6f+sNBzdAdukHrcXwVFESzy++imW7vhgO0iRm7uzeWRzQzLwDXrSk
	P49jv52o0y0Rv4dThj7agESqDgE1zG1rWMDS8xHYBP6eve/vRlJe/ceHT/4QSQ==
Date: Fri, 17 Jul 2026 16:58:34 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/3] smb/server: fix signing when a response uses more
 than one iov
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 metze@samba.org, gael.blivet@gmail.com, linux-cifs@vger.kernel.org
References: <20260716001156.671587-1-chenxiaosong@chenxiaosong.com>
 <20260716001156.671587-2-chenxiaosong@chenxiaosong.com>
 <alk9-WOWQeHaq0wV@ashevche-desk.local>
 <7d806e83-2535-433d-8aa3-f8b452ecbb83@chenxiaosong.com>
 <alnh59UIBda8vwPp@ashevche-desk.local>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <alnh59UIBda8vwPp@ashevche-desk.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

The condition is always true. The explicit checks were intended to 
document the invalid state, but WARN_ON_ONCE(1) is clearer. I will 
update it. Thanks!

On 7/17/26 16:03, Andy Shevchenko wrote:
> Can you elaborate? The second part is the same check as it's done in
> the for-loop body. The first part checks if we ever go into that loop,
> so the logic here is either we have an invalid input (we skip the loop)
> or always true due to repetition of the check inside, meaning that
> the loop passed without finding the match.
> 
> So, what's the point?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

