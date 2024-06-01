Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF3833CA
	for <linux-cifs@vger.kernel.org>; Sat,  1 Jun 2024 21:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717276910; cv=pass; b=IIz6C3CWWLPwXVz8Z5ok4ICFdCiDgmwfT4+3IbovQhPszqMcFQdg/pycVXKqJ6erHIRZ3Nn8RXlrYiy9PIDgai+71EnpR/l1lCedSSzCc7EYdi0TjqVo05/twIxsmEjnlKxCTF1Io+0El9ZgRk1khkltpAazIQ1GXZwdpT1//nw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717276910; c=relaxed/simple;
	bh=IL3Kc27TPMpVYTtTOfpUuZBLBQVU5U7mB9kBjdq1fGc=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=NQGA2ftSE8UgPCtrj7PWXqCO/UzbN6qKM0E15dYChDs3M5+zdOLFmTHcwNTymcilHWb4OlmMvcKy00Hkl3JWciPlzprR4r2fys6CWK9/fNyGQ+csuQaQWCqXrDZjmK0LrDJN95GwGBrjIQsecNZ6b4bHCkTboTAL0l2hLoHWWyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=jBZsONGP; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="jBZsONGP"
Message-ID: <d1b246661ef0d10502dbf34479ca209b@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1717276499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OWYb62EXLxOHE76NBIGS41kX5hmrqSLof9lSju10LiA=;
	b=jBZsONGPwxY9wO44frMvlfbGDilJ4NEysrX0i6ruDXnk4oYHp5xblHwqsBynPe2FM07E9Y
	iHR93KQHkU3Ig4senF8RG1aZxTZuYXfvV/2vPHvx4qWqMVjnl810b/tvaiJmtgoZPaIrY7
	GUdieFqflv0vNDDlMgQtNM/+RLvMEq4Xb7q/8b5Nvw6arujX5X0Gb2f291PMly8c0mledN
	hCsnJ+DtFY4VpPzCBAvJ9FnR/++kp2L/4t1F8nW+hZmVpxmNK/kV3tdibvg6yEtgs86v7m
	tyF0IW3TJcLbgS7TX09hsXA9cuLPEAkplBpxKHq2lZpRX5F8MqJHOeeiA1RHVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1717276499; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OWYb62EXLxOHE76NBIGS41kX5hmrqSLof9lSju10LiA=;
	b=LTq96yAcc/wGqVqGhDCgrr/LTxG6795diJxM+5Y9x5TWGVivtkfox+I7UOM/7MqhH9LN0/
	/fnJQ3Yci8ynFqbltkNVZEekmrEV1nPIkBG/S8n4gupKsy8CPAt9n+1BeHgi75yu4Zw5ld
	HPHv3CYTRifswqVIjtpC1hzJEia9nzJFZfwz8gX3W//PnCUkOaIEuDu4rwAQrDCgo5a+es
	LKcUMtHmrjhkhYfb2K89K2Z795XN24pllDAovn/eXEaFHJ6NHzxLtSIlY0oaxDScXVOj+z
	vwxVBUD43u4kLSlHPyVWM6w6R6hZrSMwD7mAUMg0TIt28J86qlvhtODiFAM1mA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1717276499; a=rsa-sha256;
	cv=none;
	b=coDdWCuZL5daq6qVNC4HW4sCBbAed9oTAnczLbQkqQWPFLy2Z+C3mgaqZxTY9jCVMFaGns
	p0SBxsxr1AGeo+wk4uJ9uap/nql4//LRrLPHbuBsYj06pVNHmHho3VDMs6LQB7a7dacQhi
	Rmpq1j4UDxFy+nWgiqkxBJFn62og/Vsz/eDquDrZ1S2NT5ra1S5qx9bsGu73zO9Sw3ZBMe
	KGJ77sP7e60FvZlW78qlKQW77RSU1HPlTE5Jr6DgpV1hO7fDrjv9ZVOiHz6ylPRt5LJ8Nl
	O6NXO3D9WOJH14k8dk/9EaPfXoCCKsFZJB7L+xSYkdnmNZgGVbwccYJ74V3Gqg==
From: Paulo Alcantara <pc@manguebit.com>
To: Wang Zhaolong <wangzhaolong1@huawei.com>, smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH 01/12] smb: client: fix potential UAF in
 cifs_debug_files_proc_show()
In-Reply-To: <aaf165e4-a5ad-cb66-2c39-2ee6b39939d5@huawei.com>
References: <20240402193404.236159-1-pc@manguebit.com>
 <aaf165e4-a5ad-cb66-2c39-2ee6b39939d5@huawei.com>
Date: Sat, 01 Jun 2024 18:14:55 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Wang Zhaolong <wangzhaolong1@huawei.com> writes:

> Hello,
>
> I have some questions regarding CVE-2024-26928.
>
> I would like to confirm whether the phrase "fix potential UAF in
> cifs_debug_files_proc_show()" implies that the UAF issue does not
> actually exist, correct?

Correct.  This is just a way to prevent one from accessing any fields
from @ses while it is being released by a different task.

> Based on this understanding, I wonder if the issue addressed by
> this CVE might not be a genuine problem. I am also curious about
> the series of patches considered as fixes for this CVE.

Nope.  The fixes were created and sent without having any related CVEs.
