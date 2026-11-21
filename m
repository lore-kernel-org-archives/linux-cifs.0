Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795304413;
	b=aRHFWDWHvp92RngHdbJjIlGt4+qfKpJ01KLZ544VbMJU6lqHBWPylHnmj1cZjVkBXpTW
	 mzuA/Ayd5KIDEmUwNU9diiamgVYqCzH9JoOhuQR5qwNrYeC55E0Ii4nO+HAc/n5A10911
	 lr9DVY8V5KlO90qrM0TLK5pIqL13JiWpiKK0D1BhWUm7dtn/YMGaPNNxspH3pOGy3npOf
	 Jx5LQ2L8wdrQmkg8iozK56b67aTvBBeOLDfj/xeIanbZOEyFFtBSpD4pM9a3gIEzE5RcP
	 U1oPpTwcGbuiZIp/MWWvZfKu3SsS62u7e2tDTqtdur/mZv1qZ39u+zTni8YL5CI4uJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795304413;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=qcWvDx6JAB48+e73X6pTSpIPZ8u79qY/ZQ1uYbAQVSM=;
	b=V+vkGtJhpejy4xzRetg+68Jz7h5Y85bsqjT83/+9unpk7uEngEtlUJgfjdrn7CkoSoOC
	 ub5SxSUlvgB+53sqAQQthq1X0C+UEM9DMT40F8TBnKp+2KZrUd372vFxhdRfvSOAw3b0P
	 6Nyn9gdpVbVaLc2EGbG5NSQnnJ8gy3D1T/rokYilus5oFYTw++w31cPhjYH1FAvtSV8h3
	 GBkdduForxEowIujKxcxD9j9MDleyGvRcWtSSHe2t0ofVxPImJifIG7aQBU7NnEc858a5
	 axVodsgQuFU4WmyVedilEfe1YUj3K+5o+z6kmt7cD1O01cMgMjsUhypJBpFARuZcXGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Md1sVuKb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D9E606A320;
	Sat, 21 Nov 2026 23:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Md1sVuKb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449A61F000C6;
	Sat, 21 Nov 2026 23:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795304413;
	bh=qcWvDx6JAB48+e73X6pTSpIPZ8u79qY/ZQ1uYbAQVSM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Md1sVuKbl6Hm9bSQhEEcbnGJrZEOk/vbLp/o0LlXGSR52tutgVRCeowaKVR20N0SQ
	 6pTH8kiGp1/V3r7UAphYKTcmMVIyn6enu2sJ1r/+HKpH8Wto5Phl+6vKzEwENnXPnZ
	 I8EwUH+g86LVJQI/UlqEEDXJYzHZ1UCsXgN90zbGoYdmsw4PzXw9LwgoUJaeEpjszH
	 8KXGNOwdfSjLetzVqWMBJAF93zaZAXaXzKoV/pBV83z9paxRRk/rm6QUzFp9/w+CVp
	 hh8cRTAbkdoeGzHuFlvfFQZSTXYzyK4Cvo15bmTcC4GEEMdFiMU/G5qHVpUhQgzNBJ
	 sa5a9g31nC1PQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A624391B08F;
	Sat, 21 Nov 2026 23:40:13 +0000 (UTC)
Subject: Re: [GIT PULL] smb client fixes for 7.4-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <bada6649ca5eb9e4603216c71aff0a85@manguebit.org>
References: <bada6649ca5eb9e4603216c71aff0a85@manguebit.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <bada6649ca5eb9e4603216c71aff0a85@manguebit.org>
X-PR-Tracked-Remote: https://git.manguebit.org/linux.git tags/cifs-fixes-7.4-rc4
X-PR-Tracked-Commit-Id: a1a0ef3ba8e802060bfc2b0ebf131a2cf98c3b71
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 62b13f41be6284250c06ab4d79a7fb13fe93f4d7
Message-Id: <179530441205.1212204.12478628029583470153.pr-tracker-bot@kernel.org>
Date: Sat, 21 Nov 2026 23:40:12 +0000
To: Paulo Alcantara <pc@manguebit.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Sat, 21 Nov 2026 13:53:39 -0300:

> https://git.manguebit.org/linux.git tags/cifs-fixes-7.4-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/62b13f41be6284250c06ab4d79a7fb13fe93f4d7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
