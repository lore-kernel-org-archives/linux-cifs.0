Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A58424466D;
	Fri, 10 Oct 2025 07:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760080999; cv=none; b=oLQLzMFTuCDgKxGKgCLA9o5qu24Jkrt42twwTfxzFHo+j/e6cozRnFVkGDa/hQx6nuTZ0L5apTd6rhdAzcTdPLKYy1PZ8hLCaiNTpGRSm6pQ5XFM1+QBTBk40pvUoYKbwZBsVb5Z6XjwaNSp0A7XNNz49NwkNrivdsVGgkoIdjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760080999; c=relaxed/simple;
	bh=aQHojoRwoDDswK4iL9dfOPSNQWdv0lvQkUGPQ8VAkkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AG7lSMbpQdVDX9FWA+viOVLTBhbtFogIaUa3/IfmRQ6doYR9UxaRR3K0Zd4fwmZecR8c9d2TlMDb237AUtVIxg6dAPW6WOuiQuVxgotFjbY+8SCF/joFKG577vpwUxGWFQONXkTk/LRL+b+ZABB38lUeEvAh2mFYPD1VQ/chkSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=Dz8+7BUh; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Dz8+7BUh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760080973; x=1760685773; i=markus.elfring@web.de;
	bh=aQHojoRwoDDswK4iL9dfOPSNQWdv0lvQkUGPQ8VAkkI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Dz8+7BUhB34wSzwP17C+OyJS24CmU1QZF5hBl3pO3uNQO9LqK2NhPATKy6zQiG6Z
	 ZpbMztyGlMBO8uPyqrCJjGzz7pH5N+EQyKVxB/7iWIQDJ+mBrOY4Upy3j1VyW4O2Y
	 9Oocq27I0ZzIzuTGHRgDuHzhQsyTYpXF5g7yPvBSeGNTvwPx9M7Hqw0rmubGjjYB9
	 o/JloP5Z8+ummPK26L5CmFILXMt4r1ngMRFUaLPJfx1SanP6s8u8Juvz03AiHnv57
	 Kdu/1080DmHBRsAHnrm+Wny5S0detcryz0TvBX+GYl2EZSH1i18J8EpAZXeutgC5t
	 nRn6ksgLgL3D6AJOAw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.184]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mho04-1ucAQv1U4e-00k6DA; Fri, 10
 Oct 2025 09:22:53 +0200
Message-ID: <836e7dc7-09d0-4a5f-b509-8f32b0ec876f@web.de>
Date: Fri, 10 Oct 2025 09:22:52 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: Simplify a return statement in
 get_smb2_acl_by_path()
To: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Bharath SM <bharathsm@microsoft.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>
Cc: Steve French <sfrench@samba.org>, LKML <linux-kernel@vger.kernel.org>,
 kernel-janitors@vger.kernel.org, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev
References: <5b95806a-e72e-4d05-9db8-104be645e6e5@web.de>
 <CAH2r5mvg=kqPyA2nYF=Nhjr3vkt4dT1R4p-Bk_MBQtddjx_EhA@mail.gmail.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <CAH2r5mvg=kqPyA2nYF=Nhjr3vkt4dT1R4p-Bk_MBQtddjx_EhA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:G/GV6Pt2lK7aorHu98H38Alj9cVhPHuct65Gx0PFxisjDeJJPP/
 tqKGYDKCEQgd5UlMcN1txdUFHFc9Q+pK4thJrr9Zk6cTxHqvdHNVdkErPoHQBjgZPtGIlkE
 OwlaQ3ZnFlsuiyIuZYdUYIUfGBcM7tEI1zpyAJraoT8rS1vkYgV2CQqZtp2Ow2XFc6URdvD
 SqydCo5pYHkIepRbHAmIA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:sOFXlQAKzhM=;U68cEk0lTA+xX1o4eS9hYfpEz0q
 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
 VfaWY96I2qyNClob3KICExOt5c0lVYeFY3E=

> As pointed out by the kernel test robot a few minutes ago, this patch
> would introduce a regression (uninitialized rc variable in free_xid
> macro), so will remove this patch from for-next.

Is there a need to express the tracing of return values in any other ways?
https://elixir.bootlin.com/linux/v6.17.1/source/fs/smb/client/cifsproto.h#L49-L58

Regards,
Markus
