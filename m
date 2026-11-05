Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793903972;
	b=mi34g8jbStNlvGJDe/HUbbpQSA7wV+OebkQ1gVCF5omn5ZeE01aBLxd9t/2lMypUbA2j
	 X84AmI5mJy1fn03eFyt5W77feINeX5A+Vumf+v/Ztry69AEHno/qMVDrZvB6XDeo8vbpd
	 Njkbvgk1lWmMCpDruUPHqwdvP/A7n3Si560ycj6Xx+YGgqV3VVC/jVC+7mixFcagjaYhu
	 z823/SC7g0eZyLXs5VpDARRfdOalgOsXk9YeIg/aAXHzR1LblNUQfvVE6/IzEuTniRerP
	 FOA75xKZwDcWrEkOU444LX5N1sbKmQMrQUgsetSxLJPboIAEdSv5S4yLUXuOwk28XWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793903972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=GfFefFPCFFgVfaMUikxfvk1jmTnTROgypY/4sMiVmXE=;
	b=kHvJG+fk6pI8s4MN1cuu83YpWJMgARb638lpB8jILiQRosGpJZTXtkQ4CybZ3KPV8c2N
	 yM/HYY2Qp/RER6gXSAPyZPMigxgYAhTDwFm9e81I2k9A+7zsqWxkxNbZg9oc393jmfrDl
	 JhS0tsmodZD0Xn19lkRhMM7KB3dwu0zKqQiraUHS0/NjgwekeoUb6zOGNkQBZIdwoQ9Rd
	 WqzecJHkRsRhfYOF5qOYtFkrH5PxUjw9KXl1up9HpkZd1i25HGKF3McrmlJ6EGcmGTzx4
	 yzxeKE9SUXxY0uQPl+Owyu07X11ezeEQD1Ds8DUFRwc+ThdRSyLzEz8ilW72f+6IqlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NtTI2Xel;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1276F606A331;
	Thu,  5 Nov 2026 18:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NtTI2Xel
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D71C1F0093A;
	Thu,  5 Nov 2026 18:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793903971;
	bh=GfFefFPCFFgVfaMUikxfvk1jmTnTROgypY/4sMiVmXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtTI2XellujX61c+dOcEHTrQO4+kvgxYWgdKjTRnajsuYyyX573MgAYUnoDxh55fK
	 9BmD0HqldCtbf5KIitXv/oM+sI4PTvudUHwpNBFshllgLWkd1gtOoicHLBVfV9WNg6
	 DVA1KY8TJEqeniFvNrOYfCXKofP0ojnWQ+KdqKHpJabO6SNW3YYnuET9QkDQ7MKIKU
	 Na2iX7GaLKjYOUDbNFFrRU61c9VwIwyldxHy4Uv8gzWIk1zaDRqA/1Z4vayUWNgV/x
	 WJ4KHCDNDcF4pRGytihE2vwbYYXWwg7iORcShByUuFX7j/rsBeffelKcFgwyJRlDqw
	 3BjNsPvPFaAHw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	pc@manguebit.org,
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
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Subject: Re: [PATCH 6.1.y] smb: client: fix busy dentry warning on unmount after DIO
Date: Thu,  5 Nov 2026 13:39:14 -0500
Message-ID: <2026-11-05-1-daily-reply-0009-smb-busy-dentry-dio@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104173309.19150-1-sidchintamaneni@gmail.com>
References: None<20261104173309.19150-1-sidchintamaneni@gmail.com>
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

> commit 75f5c412fa867efa0bf9b646bffe0d912109e84a upstream.
>
> We recently backported commit 75f5c412fa86 ("smb: client: fix busy
> dentry warning on unmount after DIO") to the 6.6 stable kernel [1], and
> the same issue exists in the 6.1 stable kernel.

Queued for 6.1, thanks.

-- 
Thanks,
Sasha
