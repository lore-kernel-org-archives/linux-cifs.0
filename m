Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204B63876CA
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 12:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769689289; cv=none; b=mXW6EW2nqRE6WWS4eIzeVLx0Bc+qmt0MsZVPR0pRkS3Fp71ZcX1JMFuCLjXmvdI3ulaudqr7p06ntvWEeMBvnwztZ4ppJIUEfyf0u2YB4XmCOeh9WeQqrQr3GL7qUbvxZCl+/c292GhhUHWzjorx4LJZQOux/M0N2u+Y5OxhZqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769689289; c=relaxed/simple;
	bh=Myi6GaG4tpI2HhbXCxGEX7kbKfOlW3tLSZgiDbGjfZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V7VRQC0565x3+v6SfGEOhwyP0W3JcyerYXrQVs0obcMJSjELVNys6rBMoqVN8+QIIRVU71RfPa+QIkc81TrOkF+J//riy1e9nFSpiOd9LBdHsu6TcOGDO4mzhu0stDQlct9ialWxxGYd8QkNckSXZOPDT+vanq53tC18jyrqH3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LO33bMoC; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LO33bMoC"
Message-ID: <f1b9cd58-8a61-4fa7-a7e9-198c2c468c59@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769689284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nmTmcNqj6IUJh7kYyi48msH2r5G3wd2KEuGJVwxN7M0=;
	b=LO33bMoChxSi5qEwh5O8h3mIaE9h72NrTY4N1kYNYu4DxE1l3Zq5yZC4gDvJs4SVHEl56R
	VxfUp6fS0rqXxnLbPSxSz/mDPmGsawh2dDaJ5yT4ccJLsJovuTNOidU9MVNsfDYtvu4OaM
	BW3CaB6qttGMGyXO9RUOp+DJY17em0o=
Date: Thu, 29 Jan 2026 20:20:23 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: xfstests failed test cases
To: Steve French <smfrench@gmail.com>, Shyam Prasad N
 <nspmangalore@gmail.com>, David Howells <dhowells@redhat.com>,
 Henrique Carvalho <henrique.carvalho@suse.com>,
 Bharath S M <bharathsm@microsoft.com>,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
Cc: CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mv41nFwJQwszD82MQbtDV75zVy6=tbwqxDTOsw2hwfBpw@mail.gmail.com>
 <CANT5p=qmo_KORMQbnjonapAaGHq=UvWAMzR0jNKBBvx3UUkyjQ@mail.gmail.com>
 <CANT5p=pfQE2A++j6W4sEudrSLH6ct=ho4i=k2ZDEecUAX0cReg@mail.gmail.com>
 <CAH2r5mvakK7=1i-fZTE9hLLYd_Q3o5z557vQZ5QQtdOTkZeSew@mail.gmail.com>
 <CAH2r5mufJgC85ULoVzYSMXDq4=-RUiJ2YgppM434vz1Q4B1d+A@mail.gmail.com>
 <CAH2r5msVifsc-E0TjaYXt2Afh1MiCsJTSwMnsDAdUShRgkJ_4A@mail.gmail.com>
 <CAH2r5mukVmnfK7X3jXWwRnD-_RAMuUgzXpi+HzNjxOat4tobJA@mail.gmail.com>
 <CAH2r5mvW23-eUsjDQ_0oLrmj406Og5sDs-yPgqh6jPwdSEG+Tg@mail.gmail.com>
 <CAH2r5mu909vLwAQcKFQX7cWz421V1QmSiBAKyJeC8gUcGVb0Ew@mail.gmail.com>
 <bcd3d847-c38f-4c88-af07-3da09dad476b@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <bcd3d847-c38f-4c88-af07-3da09dad476b@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

I found the key factor that triggers kmemleak in cifs/103, the directory 
exported by the server must be read-only.

When sharing a folder on Windows, do not check "Allow Change", set the 
permissions of the shared directory to read-only.

Alternatively, `smb.conf` of Samba is configured as follows:
```
[test]
     ...
     read only = yes
[test2]
     ...
     read only = yes
```

For detailed information, please check the link: 
https://chenxiaosong.com/en/smb-buildbot.html#cifs-103

I will first try to analyze the code, and if that doesn't work, I will 
try to bisect it.

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 1/28/26 23:29, ChenXiaoSong wrote:
> I have reproduced the failures of these test cases. For detailed 
> information, please check the link: https://chenxiaosong.com/en/smb- 
> buildbot.html (I will ensure this link is always accessible).
> 
> Perhaps sending these issues to the mailing list could help resolve them 
> more quickly.

