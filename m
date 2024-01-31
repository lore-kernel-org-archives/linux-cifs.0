Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158FC12BF33;
	Wed, 31 Jan 2024 17:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706722153; cv=pass; b=GRHG+G++WByCtEf2f/r5cBFqg15GRogNgGswCpJ66YRVXNtWnz727vhdi1uNRLnt50rk4GGUqRtTs7aeoppRNFRZaqPXRSo6FEKURl5vATuo+6iL/s0FR8hqKFLx3uHzhDGLGnndNaZ2q8Y6xcO+01jQf4nhawVR8FF1oj+wAO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706722153; c=relaxed/simple;
	bh=IaFEG33hBcEgNUsHITOicSErxjWnrxGesGXGIozJavk=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=VgpL5TOYuYae6uaRWAku3/x9MN2EtIhA5L4W7WeWTcGoHNND69K+qt+2Xg7ftKTzZGsuuU/eqkpZZofmy3CWYrAAdQIlSK1Eevuh+uDN/Whi7KqekNQDeqLqdBpiNXK/PAcv6/kj7sqXxDldCtV5yicmEOpg5vbueLgp9Q6o4FM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=R9XLS+nF; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="R9XLS+nF"
Message-ID: <848c0723a10638fcf293514fab8cfa2e@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1706721552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g9nP9Ud88BouQsVgMsrOba+H6PVYBrp7eIRfMuU8hBI=;
	b=R9XLS+nF1XxALuaU8TKoUrd6J06WkI6q6nnzDeoVhKQ7qtsvWA6DpXQExNpn5D9A2c6vCI
	itg/ReNgJd3dB/aQs85OcwOE76zrIRDaE9a0Rku3m1/iKM5VI+VCM0Ovti3BHWWxh//rn+
	4He5UVbzTccG9ekMabFQsuTDC5QxY7QC+KQuAniNyrMghY0/NDy7NnjtM3T+9jZukAzfyg
	M8SzGfIZVVe60AzTteVVnhsa9BwofYnJNDLDqXWWu16ny9Qu5GMxkVgqevRjvZ1bJSkgRf
	++/4+stihEsmd0Bv53XrCbILWjGRNKp3vYm5o1UqQxI/xmIIfd+823NNfltpcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1706721552; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g9nP9Ud88BouQsVgMsrOba+H6PVYBrp7eIRfMuU8hBI=;
	b=hFEpyKaWGj7ekhhr/6Wowfhs3EgLW+r3QPAoExl8vF6CCCJj/H6uEkyWSV+lrRfwx0xsKd
	Cd86+TY5Nj/rLEI18lSUQvqyO6dvCSiv9XaVZTTeCLWnWABOi0gxX4SkkksGlpIjS5Eynz
	YHZKIWpqNbcBvQKF3/W7my+VEIsVKzxCBn1yIPCMHsa0xOt7JKHW9Os9cNY9lcvUJ1peS4
	X2U33mBcroufdnQIMIskLhRdAvWlLVkj2afUJt1Gbjk5hTjI4NKuNe5Q+DFI0m4LKl2gCk
	y86MnnFFUO2tUtLZ+usId7qy5xbhCvYLhwyNsQZEl3ZRVgnxDGVCJJ27OZHtcw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1706721552; a=rsa-sha256;
	cv=none;
	b=qOtMiiPb3OA1I58drlFXTWIt82eDyDA0U9NT7o1nVTgEs/9YZC9Wdc5yhQ8hxmnBH65pAp
	jon6apKP3IOIY4OnMR+PkYgoKkJcmgB/6O7WoQtt5xSVY4GKrFUWdroWHveQ0w6OEzabGU
	bwXb7xSlu9WiHdg7z7egxfYfc+1TFz9sBLwOVTqOqonN8Z4Tb+S5Gq6oxFsLT9hNueXSBJ
	7wd66dkjS9hWOoIec5jSMLJCrHuv3SGBF9qNH462dbyi1fbvHdfzY1U1awgLXet9GHnTWk
	uUuv5eb9yZGY9mkuFu36okQYS4CQRQgrY4EY7H574flS7DsHMvsB26pAjkpoXQ==
From: Paulo Alcantara <pc@manguebit.com>
To: Salvatore Bonaccorso <carnil@debian.org>, "Mohamed Abuelfotoh, Hazem"
 <abuehaze@amazon.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 "leonardo@schenkel.net" <leonardo@schenkel.net>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 "m.weissbach@info-gate.de" <m.weissbach@info-gate.de>,
 "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
 "sairon@sairon.cz" <sairon@sairon.cz>, "stable@vger.kernel.org"
 <stable@vger.kernel.org>
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
In-Reply-To: <ZbnpDbgV7ZCRy3TT@eldamar.lan>
References: <53F11617-D406-47C6-8CA7-5BE26EB042BE@amazon.com>
 <9B20AAD6-2C27-4791-8CA9-D7DB912EDC86@amazon.com>
 <2024011521-feed-vanish-5626@gregkh>
 <716A5E86-9D25-4729-BF65-90AC2A335301@amazon.com>
 <ZbnpDbgV7ZCRy3TT@eldamar.lan>
Date: Wed, 31 Jan 2024 14:19:08 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Salvatore Bonaccorso <carnil@debian.org> writes:

> Hi,
>
> On Mon, Jan 15, 2024 at 03:30:46PM +0000, Mohamed Abuelfotoh, Hazem wrote:
>> Thanks Greg, I will submit separate patch inclusion requests for 
>> fixing this on 5.15 and 5.10.
>
> Note, my reply in the secondary thread:
> https://lore.kernel.org/stable/Zbl881W5S-nL7iof@eldamar.lan/T/#mb9a9a012adde1c5c6e9d3daa1d8dce2c9b5cc78f
>
> Now
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit?id=a280ecca48beb40ca6c0fc20dd5a7fdd9b3ee0b7
> was applied, but equally the backport
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=06aa6eff7b243891c631b40852a0c453e274955d
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=ef8316e0e29e98d9cf7e0689ddffa37e79d33736
>
> So I guess
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit?id=a280ecca48beb40ca6c0fc20dd5a7fdd9b3ee0b7
> should be dropped again.

Agreed.

Greg, could you please drop

        b3632baa5045 ("cifs: fix off-by-one in SMB2_query_info_init()")

from v5.10.y as suggested by Salvatore?

Thanks.
