Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804619;
	b=nshwq8K/MCst0dx1822ZFvZVh+YTpiwLf5E7sTMDaX5nyLY9A49enlMxX0xjV3N6NqnD
	 S4X6mku+/nQtep/WBiE1U5H5saWy4GIAIqXBhK4L/BNkVdPFchHJhUtOmTUe/3axSz5ku
	 r/g0QN/Nh+0oUi9kdI1DmooBRZ0FN/QTN987vhHdPnVBdvZdX3W7ZxUp+1/kAnMDpT7td
	 9A4MMQQi44hvjiLWtNrMQiDEbBCNeMePY/XCcTf0fsYmqsbFS4zu91MpywMuar56ZXzpr
	 BElkU5ZoWVIPOKpqfAno2gTTudoxDBqzkxmoVmm8q1WlFjVXMvND5MrDsihpMOG3l5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=DAyjJCj2wXbOfVNE2wFtfyQIhfJLU1v4OIJSdOSX2RA=;
	b=VA2b1zFTOXmD3ORR+GsPnYtsNAqXVhY28hWg6m6Dc8pnIIckpk+71VzlxapJ+y8hKG4S
	 XlRy9fgg3GCIAkDBRGZGGyDmo24448egCY0GyflIvXBRhzc9Ra99+Y5HfhbZUK6yZbQIJ
	 19GQZhjPJN2rAVT4sAx4wb+nnKNnOVQiZnw2MUaL88nOcGY5vC/0AS7alUiVLtry0VTKE
	 sTgPjTbbuEBqGCjCpR+PjDHSIqWAbLcaLCMzpAfngT+wPcGNrlVOGtf1lTkSMSBM8XW+W
	 mv30HUa1JtZt+lC/pik3MeC6b3tKXTzYPvba3pI1OAOBdPNaWfPgaOGP0QQ0n5Gf4og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mi9N+EfD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A0B606D805;
	Wed,  4 Nov 2026 15:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mi9N+EfD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A957A1F00A18;
	Wed,  4 Nov 2026 15:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804619;
	bh=DAyjJCj2wXbOfVNE2wFtfyQIhfJLU1v4OIJSdOSX2RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mi9N+EfD4/9heC/T1djMnTxHcdd2zL7Cuqu4kVpl4K4bX74glV8I1XIhSyoh6npLl
	 aFK4xF7+7mAh0tflr7Q5yw8tKoPgln+NI026P818OqQe6KMIhu+4lbUJsYpkQkv9Le
	 6ZU1FsUU60wQzr+kCZJFnCBBDvSkV9mLGUbVTrG5tPwdS2EUHxfkEwupmo73p5N4Op
	 ++uIku3/dY2E0w728BApzVJRYpd521MLQpKOmnL47zLS6b8JBQwp9tLaj1DR65milY
	 NIwWtnHO0A0vGTF3ozXoIRUO8A3Ri+0pBl/xdZwhOnGFLlHxZMqcCTGDVrtiVFZ14w
	 y/PVzYDOY9hsA==
From: Sasha Levin <sashal@kernel.org>
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	wozizhi@huawei.com,
	lsahlber@redhat.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	glaming@microsoft.com,
	linux-cifs@vger.kernel.org,
	apais@microsoft.com,
	rlmenge@gmail.com,
	hargar@linux.microsoft.com,
	Paulo Alcantara <pc@manguebit.org>
Subject: Re: [PATCH 6.6.y] smb: client: fix busy dentry warning on unmount after DIO
Date: Wed,  4 Nov 2026 10:03:19 -0500
Message-ID: <2026-11-04-1-daily-reply-0010-re-smb-busy-dentry-dio@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <7bd9007e90f271821114f617fda2c1ee@manguebit.org>
References: <7bd9007e90f271821114f617fda2c1ee@manguebit.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 2026-11-03, Paulo Alcantara <pc@manguebit.org> wrote:
> LGTM.
>
> Acked-by: Paulo Alcantara <pc@manguebit.org>

Thanks Paulo. Queued for 6.6.

Siddharth, I'll pick up the 6.1 variant when you send it.

-- 
Thanks,
Sasha
