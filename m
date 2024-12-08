Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A719F9460;
	Sun,  8 Dec 2024 19:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733685526; cv=none; b=OJoW+JPgJRDXFOIcccJNl6VeIkTvl7TeYBkPHIsCKKYknhojOoKYNUAkuS8eink2YjM1Ng6iypL8RQrPJV/wwQ1l8g1XgxB0dpzP2GvU5TA3gRrE8dGd3NyVu9lQ5AF07Vezbh/a7uyXd2Js+kHSNLlxCHtrqopM4+NegyMH4oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733685526; c=relaxed/simple;
	bh=eUfgd1sRnbCARhHA+BQX3I45Kj1gm7ecAqEcoWcRe4c=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=SgqATIfsqx0mD7khm3ja3NRK+b2x4yA27Is+IOnR+z+Gl0A0nD/jWKyg62Z9830VqIsI93tW3c3j+AQzedj4lrqx3F7ryl/EWrkDiddLl+Ow7BztUy7KRmHYPM7hkyhBZrUzwqNRmcHQD+Jdroc2+986qawe5d5t7UyySImQpJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZhBlECTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZhBlECTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E32C4CEF2;
	Sun,  8 Dec 2024 19:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733685526;
	bh=eUfgd1sRnbCARhHA+BQX3I45Kj1gm7ecAqEcoWcRe4c=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ZhBlECTIalbx80hnHvGULRA6WrsfzRhmlmE/toar2i1jn9Empk76FVBChHfFtxuri
	 jYI1YLRbfZKCQT/rTkCNPYGNvCIRxppH0C/HJ9mXpCO5tejeN95OmYhUG0aIHPJWru
	 7KJ063BxgLZccaYj46VLpCiDMrYyfQIGzPPjWTuQhAijbyyqBRNfh7ocpSObVofg6r
	 Ge3GGmKanX/+CeLJGt5Bu3Ha3HbJ3LaDQvxAhWeVQuljKTxzqQWA5AHQhFvs7nQpVF
	 qX3xmwBS0icWX0sJWEoq6PktW/kEx9lqXw05jfz7uNmBiiXFfu0LXOGVIFXQcvsglu
	 gTale9WgVJc7g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33EE1380A95D;
	Sun,  8 Dec 2024 19:19:03 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mus1UqScCCqqWoPO_9Zu0yr6=DMf4cu+YOusFn9HVX3nQ@mail.gmail.com>
References: <CAH2r5mus1UqScCCqqWoPO_9Zu0yr6=DMf4cu+YOusFn9HVX3nQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mus1UqScCCqqWoPO_9Zu0yr6=DMf4cu+YOusFn9HVX3nQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc1-smb3-client-fixes
X-PR-Tracked-Commit-Id: c32b624fa4f7ca5a2ff217a0b1b2f1352bb4ec11
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 62b5a46999c74497fe10eabd7d19701c505b23e3
Message-Id: <173368554183.3322083.121826589500839840.pr-tracker-bot@kernel.org>
Date: Sun, 08 Dec 2024 19:19:01 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 7 Dec 2024 16:22:42 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/62b5a46999c74497fe10eabd7d19701c505b23e3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
