Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FB02571C3;
	Mon, 28 Jul 2025 23:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753746017; cv=none; b=th0vv7ZIF62s1BbPLy9Z7MdQgeQp5ZyOhzjnVs1pc4bcPs0th9bLH/ynVC+t/vKrkqYucgZXr3hHij3dm4P7o7gM4I2F325ATymLbkOyoQ2X9aoYR1jEHjXC+A6tRusAzPN05qcaQWLy9ouHBzJFCHCaygunXorQqF16q/KpRDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753746017; c=relaxed/simple;
	bh=LvNLtL1sBLEF4WJRS/MAnhLnh3k6POEfDOO23lZ2rFA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=I5YpfBe0Q8mVvZSGb5nnNbiNdYl/jqVodxMmvJ6H4U1qi+qU/fivo6LH8BgD6b+X6dPTPGWTf42VkBTxbeU/gLwmT5mKApFib4BVE5VAfmzZWdvszIexRtweAYOWzVwjkHeFuC31mdz0ekYH2kaLFD5ISWDonkLl8HJFkY2Wk0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mvB7u3rB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mvB7u3rB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392B1C4CEE7;
	Mon, 28 Jul 2025 23:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753746017;
	bh=LvNLtL1sBLEF4WJRS/MAnhLnh3k6POEfDOO23lZ2rFA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=mvB7u3rBuNtLYN7OaHJA0qmaZIxUkhrVkKrxcaHsBMSWp/sq5hcidIQ6AUpxdFXmP
	 XRJTGHUaId6PVhpAifq9xRE7OrgCtQ+J1kgEFdUDhHRcxq7Rlavfv0rfeGNbzadtrs
	 oaYu8BOm9hUuJL2PUcnfUOUgMPvUywfTGAIBtzIX17EmNC76/jjPXW0i7CLHwad//a
	 rZNQnD2UAf/26HCMyDroetH0mtpOuODVg/wXBClPEbyAhNj2r6EtdJUw4IH0omyYmb
	 8NrdOrN6fULlCud++G5i7pE3ZJusnAPA98d/tg5Yt3lJ4lH4WErFiMvO3VmqBGzlXT
	 WH6LcbRm1wu9w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0794E383BF60;
	Mon, 28 Jul 2025 23:40:35 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms0_hBugivNhSKW1TG22D6pTZA6WV=p+uOmcYmNp4Xvww@mail.gmail.com>
References: <CAH2r5ms0_hBugivNhSKW1TG22D6pTZA6WV=p+uOmcYmNp4Xvww@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms0_hBugivNhSKW1TG22D6pTZA6WV=p+uOmcYmNp4Xvww@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.17-rc-smb3-server-fixes
X-PR-Tracked-Commit-Id: 4f8ff9486fd94b9d6a4932f2aefb9f2fc3bd0cf6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e5cf61fa6e2fb9ae6339eaa892612488c966baaf
Message-Id: <175374603394.885311.3016689371337224782.pr-tracker-bot@kernel.org>
Date: Mon, 28 Jul 2025 23:40:33 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 28 Jul 2025 18:20:47 -0500:

> git://git.samba.org/ksmbd.git tags/v6.17-rc-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e5cf61fa6e2fb9ae6339eaa892612488c966baaf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
