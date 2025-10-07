Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B684322AE7F;
	Tue,  7 Oct 2025 06:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759820063; cv=none; b=NQg6Ne07mNfIvSFGqgbgGeY5U9KBXm8KC2aBuLmc/5PZRhRiEsJIOYM6f0ujoP0ybpT0frpd9DiEW6uOYv2x/ryCmbf2GG0OiRMbXL/SobPGUMNtV57/km6eBf08eYK0/H5w8/u8bOpYPSXQkfo1YBNl0T1u7WIh+KskBmLBoFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759820063; c=relaxed/simple;
	bh=Sq7ul6WNE6O5j4RCZio6JhjlWbzyNo4XrJcF6K7ASh4=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=lKLxg+mHHYICWNp+BtUVzmoHe8SdRQXgn85CXXIWJlVtfPKt28/PE2GkslHrz7l8wFZNudwzjASJFfaBMQuase5QCRhuGNWnSrwm48W6edFfO3zfHH0triB+GnSLUl9Mv89dKcUk7jjD3/DsDzd4NEMRWAf53bxXIa9Pt6BrD6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=BTGwj1ew; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="BTGwj1ew"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759820047; x=1760424847; i=markus.elfring@web.de;
	bh=XiROOt7871cZmtqY+ugdQ1cxJsYnGnsZeHsV5fwekMs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=BTGwj1ewyKWZ/FYRoQ5M6NRx/4rrcwMCidXblRlEMpfeBnukyuM2vkf0Xv46/kd2
	 i9CQautKvP3zTGy5mSQmm3NOg4Cu0+m0TBc7e/KLhw6bkzmk4BjFzw7T2PXSzp6Ef
	 t+2zKEg1r0japltVM6syAQYxPaMNKqGpU1sQQp8io/htKjDfjjwxL58zDmgc/dR9O
	 ENvlPNghl2lhdemlKrjjsXzwIvwAcAH2G2mXHMD4D6RUBr3JYrs6rhbf1KCxm0FbX
	 anogUy17rR2P/q8ddTiK8+A1S9okK2Cvbed6nxkzfJ7rbdikLLpVAFC/miu8TU74a
	 DPEacd6RrlCMfeBB3w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.202]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N8Vsr-1uAyzu1sTR-01874v; Tue, 07
 Oct 2025 08:54:07 +0200
Message-ID: <8793adcc-b8cb-48db-bc2b-457c95e97b63@web.de>
Date: Tue, 7 Oct 2025 08:54:04 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Fushuai Wang <wangfushuai@baidu.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
Cc: LKML <linux-kernel@vger.kernel.org>, Bharath SM
 <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Tom Talpey <tom@talpey.com>
References: <20251007041209.99174-1-wangfushuai@baidu.com>
Subject: Re: [PATCH v3] cifs: Fix copy_to_iter return value check
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251007041209.99174-1-wangfushuai@baidu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:em/FsB2gtab9+fXU9A3R/we1nPOxaVByxdES5UUzvZPc6aRcDho
 sRN2zhq/hzTsHTzJVX3/tZqfY5fWX/yymFLjHMdF6o3WFz7q8egA93nAJ2r9Q6RPy9Gd3Bs
 sftwTuNaGsFFL0PrSeH7KkjwGT10vi4fZNYun8oDLP4zCPR0KuxcRpSsLKtGX0Ne/n4Y4/G
 poaOlxCijTnBtmkmOWcbg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:wvx7OXpSs0g=;j9ewi7VLlOmq/zuBmyaY3zEFwpt
 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
 sHDIg==

=E2=80=A6
> ---
>  fs/smb/client/smb2ops.c | 10 +++++-----
=E2=80=A6

Some contributors would appreciate patch version descriptions.
https://lore.kernel.org/all/?q=3D%22This+looks+like+a+new+version+of+a+pre=
viously+submitted+patch%22
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.17#n310

Regards,
Markus
