Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA4F2AD35;
	Sun, 24 May 2026 00:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779581269; cv=none; b=Pk2Lhf8nd5zxrzrOOLmgWoiDFOF0owsxKHDIVpiNR7PmRnqC16Gfcosf7EIa4LyI3WLpAeS1Otjc9XfcrCA7qFfxTnIBIp4CSulz+M5p2jPfl9M5nE4ZycA0tpv9OMvRwS21j5ev/cWDJLp6x+rO1/5uzrZ7pRGIzsEa9EieUAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779581269; c=relaxed/simple;
	bh=NOhG6M29L0fjBFE/oRB5xCF1JDSJ1fpDIv22D+7DgaU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=H8p1VeFZbXkGlyR90OQeD8NDcovjf1qiE58NvnaEogzfHvms2Wp4uGouSAyM3KCWoHhnRPDQPaRYnTexqyWjAxDT7qN6W4T2u7j88jCbBmRwXI/KHjSvXHey5EPTl1EXqx2ERrqLrtiP//2UfMKaW/VWDvPFlGiLeG5lOSq485o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUm9JQ48; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUm9JQ48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8241D1F000E9;
	Sun, 24 May 2026 00:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779581268;
	bh=PONxhdSLQ4L+ooflNxSkCJ+t/PUUWx2qKuvS/q1nBI0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=SUm9JQ48x8cR/+X2emOEtE741zxpe1fiaLUPO9TSA5BoVWBuP0cwSdNA5MMXAZMbE
	 UfSlk8li3wAwOz7qN3xIx9IJi+x86L/KI3wIEX1OC+C+obvZafxQHgfCJSjfvbAKEX
	 YXOvIxGO6nNU930JI0V8Oovgxzqprb4IW+08+1RHIpLyTA+cDAFG2pCuaCt0EZDsDy
	 k4QBH0jSvj/qQNpbBBtEAN+JtW8tGeyj6fkpD1/3MYyQFmQJTFvHmK22GPh1cPzGCz
	 QoKTaAyrVRon4yz4H5M7ok6q3+CNWK6iBhd/Wq0LzNr5OFQeYrE/jAXaGuiGcJfK/9
	 yaQRc0pEQYfYQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0BDC3808205;
	Sun, 24 May 2026 00:07:57 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mv+AhWk4nM8tWcMDwQHL40VneHN1XVwuQrX08OLRB8R9w@mail.gmail.com>
References: <CAH2r5mv+AhWk4nM8tWcMDwQHL40VneHN1XVwuQrX08OLRB8R9w@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mv+AhWk4nM8tWcMDwQHL40VneHN1XVwuQrX08OLRB8R9w@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.1-rc5-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 4ec9c8e023c79f613fe4d5ad8cc737112efb2e44
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4cbfe4502e3d4bda48eb4b83dfad8d7da3b22e90
Message-Id: <177958127630.1680243.1134537361898434591.pr-tracker-bot@kernel.org>
Date: Sun, 24 May 2026 00:07:56 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 23 May 2026 09:22:21 -0500:

> git://git.samba.org/ksmbd.git tags/v7.1-rc5-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4cbfe4502e3d4bda48eb4b83dfad8d7da3b22e90

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
