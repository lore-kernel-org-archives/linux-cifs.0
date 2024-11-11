Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A812EF9FE;
	Mon, 11 Nov 2024 01:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731287635; cv=none; b=fJAj6ovyyIKoQ3mU4lSUH68PggIr2Wsd/+NJMQtIdCFjgSRNnIrBPRtQ/tJPhAZTbN1CUerpknYBdK4yheiQJVLju5+NKgwN04LSAhSyAASSwDSYuc8C1zLxEnQzksRDrPx661tIAGQ453HB9FT4zrIZ/ma/hq7E2l26FUulmrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731287635; c=relaxed/simple;
	bh=OjE4seRO0Rhe8mR3oVXyZ5I014aL2nCFzMnCXNY6kX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MVWuW4hqdHtnB58zyJq67y0pAk4zXQCkRLrqvCpTNV32n02xPdAlphEnmmeiad/fmcDozhjYYlLowdfOzDj8x4rpiZeK9QlrwVyx4wn0Bqcq9hVTskJT+wU8IMWARVItDUVEuHh70FU04UVOEmfnJSnGT2A72rmIOmLEKN1yl3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Sg+ASLJ+; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Sg+ASLJ+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=b7TSIwFk/YGak3yiWtc1uSJO/wsrsbKDC/dnWlGHD7A=; b=Sg+ASLJ+e5nf7GMrDyMY+BWBBb
	4AMQwpmgxrPegkMAc+VfH+z1FHlXRnlws9kqHULRM2zjzXgU8Q0LbfA43+7LjYiXx9TDb5WI0eerF
	uKeGfreZQXAfsoIP/ViznXp8RlxycOZATil4EnHg5QJVr2CYtGz7Wct+1C9tMRX2NSL41brfuxrsU
	eSyIuyEAuQzEytjK10eJysKu2XP74zSdBouoMLvcbkCLZ1vkOJ6VAIfgDyYs1FHyH0PBN59EEsrNs
	Xpr2NQ4qBk8BcwjvYOG6/+eqsGcH2jj2Stclk8dhasr705z3yCt6H55c7jqo7oJIaw6j+5/BaA9Ak
	hDsy/0PvvyyMIYT+2UA1cP4+pdtj8n7Jp+OWe3xrB4yUXRZ7ITEfYjnJtlgP/4f+mB6zM+VJsYeFX
	ivBxozMydBwGG6sQkffbDI9m6TjF6Op6HEVmep/mPrZaz32qySM557PJ/auVGXjxEZdD4KnRJ8MNi
	o0VDBOFMiOttuEw9I/lkg6gb;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tAJ01-009xRD-1e;
	Mon, 11 Nov 2024 01:13:49 +0000
Date: Sun, 10 Nov 2024 17:13:45 -0800
From: Jeremy Allison <jra@samba.org>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Steve French <smfrench@gmail.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath S M <bharathsm@microsoft.com>,
	CIFS <linux-cifs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cifs: Remove pre-historic unused CIFSSMBCopy
Message-ID: <ZzFaSf20nIbppt8w@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20241007210214.102568-1-linux@treblig.org>
 <Zy0reBfykkwXA47d@gallifrey>
 <CAH2r5mvL+xXH_nnoKKKnVPFo_xtOb=8mPSqrG28Dgngx6Aab7Q@mail.gmail.com>
 <CAH2r5ms1y3XsGmA2kU6Vdvdmg_jnVyd2w7mQPRyX9oh9rFD2tA@mail.gmail.com>
 <ZzEOuqDwagwoGCMf@jeremy-HP-Z840-Workstation>
 <CAN05THTgj+_78kG3LFnpU9zsjEEBAsyDZ0P20YL3-DP94r3KUA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAN05THTgj+_78kG3LFnpU9zsjEEBAsyDZ0P20YL3-DP94r3KUA@mail.gmail.com>

On Mon, Nov 11, 2024 at 09:02:03AM +1000, ronnie sahlberg wrote:
>All of SMB1 should be removed.  Not just disabled but deleted.
>
>What are the plans in samba? Any timeline to literally delete the smb1 code?

It can already be compiled out of any build,
so it's an option for any distro or user of
Samba.

I'm not sure deleting the code is needed at
this point, as it still has legacy uses
(there are still commercial uses of OS/2
out there for example).
