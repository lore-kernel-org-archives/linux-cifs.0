Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794674974;
	b=lAkCurQ4uzCUfDm03WBuQ44Wn00XRiebNf1whgnoUSng088cxqZSly9yoexIGrvNYop1
	 uLSfji6fvqDKZNc7FBAo80eVWMnxTRKzXIW7P8os+Q/WIGCeygd9S80jgPzjGTCo7Pp1v
	 WUFZ3GHgL2TH9wj7IHtJVOXq3SsZ4qU8zMAr/vJAy9NHwz7fFGKjtMN1j5DfrFMSPy2uB
	 xAW/VYlTYtW1JTJ1SH8FSF8Gl/p35dX9OaKRhrgGPfzb4AbtU5LDMygbsAPUntu+SyOEW
	 5aWVLG1R3Bisyg4gdzvWwTv2FFaC00FV5yP7ZPfmjYH7KNusIwT8dqZ2DAREeEIyYpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794674974;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=R5PD87DXQGe5z4GXxFpUkZC/qGaFBbI9+9pX0FnLtN0=;
	b=4ckSc6F3RCK7C51F/dlOegxM+FxR+Too9l/WhwnVWIqFnz4TDasHTudvzTgCvI6MkGlq
	 wkbQSt09R8HZQgfEJbgQYaBvkEyiPH/c1revbcsiRSIJUwHhz5i0KJsOR8yqpd8jDq1FL
	 wUMYcYkH4inNhI2x0IosJhwdWCXCbnL5S3/iVjdfawOOLf3sn2KmoG9KE59TVNShFoy5x
	 rfhk33NBjwNigca7J4Vov2BTFNagMipRMXtWuPi0wsWObio9bdzvdo0WvxHcfm6axs/OV
	 89cuEH/BxGh1IBnU9frZHnLD3T1ijVAut5Sd2RK8fv43WxY2XdL1nL1sXQVHEHepwXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E2YrsNPc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8CA606A33E;
	Sat, 14 Nov 2026 16:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E2YrsNPc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE091F000CA;
	Sat, 14 Nov 2026 16:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794674973;
	bh=R5PD87DXQGe5z4GXxFpUkZC/qGaFBbI9+9pX0FnLtN0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=E2YrsNPcVSo1f3iz0IMlCHAK1Y39CshGCKYPMGEYAuDIljUJEHFNE1qUVwGwjeEl0
	 Jwucxzblqy6p9ObBvvLZ08a/OtxR/JlR7HDCqktoivS8+bf378iUjL0lnaga8qlc+E
	 9E095TgC2mfP7WKB0JT5kOVIUpYalmspYVIjBKhhrq1q2C6rbpl+zIGW1Ev31rARcy
	 Lnt5UX3cUGFCgV9ugsRTbcUApLjcQYX22goUu9tA5YgAsO/oDQtnZKeJ8JzgLu7Nvd
	 QQdZEOTSldRP56q1Em8laPl7bQBIxXT340icuNnnSOaAU10gn0qbzr7SHKi3Hy3Hu3
	 8tiX3Kdx5kKwA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B4519380821F;
	Sat, 14 Nov 2026 16:49:33 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes for 7.4-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAKYAXd8oLzyQkLpZ9AFxVc=GvdN1GTYN3yGOcV-n0U7uPGrPQQ@mail.gmail.com>
References: <CAKYAXd8oLzyQkLpZ9AFxVc=GvdN1GTYN3yGOcV-n0U7uPGrPQQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAKYAXd8oLzyQkLpZ9AFxVc=GvdN1GTYN3yGOcV-n0U7uPGrPQQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git tags/ksmbd-for-7.4-rc3
X-PR-Tracked-Commit-Id: b0af9a3e6b1534d353ca6ac23caaf46127f62e4a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cba88960471ac67635080708b67ed5c2a2e4e9fd
Message-Id: <179467497224.2233204.15080018499468700811.pr-tracker-bot@kernel.org>
Date: Sat, 14 Nov 2026 16:49:32 +0000
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Sat, 14 Nov 2026 14:29:14 +0900:

> git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git tags/ksmbd-for-7.4-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cba88960471ac67635080708b67ed5c2a2e4e9fd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
