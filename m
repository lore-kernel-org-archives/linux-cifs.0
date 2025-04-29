Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C223FD1;
	Tue, 29 Apr 2025 00:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745885252; cv=none; b=JpfNuE+QrAercBaeiTPIWi/LFT+K5vF78hH1OW5avfet/GOIWZGM+NZVtLu0Kyf4LOYtL1SC1s1yifOqqfhO+EoSaAimbYiuNgcQjJz2aLXHYcjDShEwkaql1ji2/FrRCnUTA3K5dF9pMIE2jMjQz/1OG4v1H1/w0c9RPauRNa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745885252; c=relaxed/simple;
	bh=E9I8hkHF/Lwec3wbVTSTvtscPSnIim3vx5VKI8nyr4k=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=MozNejC8LUavEchW8ksj+2TTOsntgkxc2Rx9eHzNmli5y9iKjt9e3vRD47fCYswoBX/b8k4ABFjJjkQsCoUM2kam50O6wAQ1wopQDEu7jwFlWlPei3+lTPSAs0hFFzRAWX82XRe8jH1Nzcf6PLOVSBrlYCqhBFJ2dqw9BHrpUj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KfL/xdEm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KfL/xdEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8CAC4CEE4;
	Tue, 29 Apr 2025 00:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745885252;
	bh=E9I8hkHF/Lwec3wbVTSTvtscPSnIim3vx5VKI8nyr4k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=KfL/xdEme7v61qRbYKjO77ahWb//hGfQxoTgMWURDtkaPlDCDIaDa1QYFtt0ARWki
	 14WKTRf/5y7oHUp22uJgynx7A3S3M/VlY9MgAPbg+WFpaHyaXSlLdNAZF52i9+rIjh
	 7ppErsyoJkaZpxR3TwHH0WHDjK97arxBWyTxZv+apWQzYsYJsTto9QgkZ3t5gawqMt
	 k2o7BOLGCyiNK7/gAifeKD/lKFFj7j6waMlAj96Gt/MpsGw7zbNKn+z6ri4UBZHewG
	 1+26V37W58v4OaTh+zHLeV95sX/li3/nbS6RXWTmj3Xbes2httrrTqXTrGTWSnq68l
	 eYKVT3PV2cacg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADE913822D4A;
	Tue, 29 Apr 2025 00:08:12 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtYUujsHMx28hNQdPOYLhgLTYMN6BypJhQ=28qSunocxg@mail.gmail.com>
References: <CAH2r5mtYUujsHMx28hNQdPOYLhgLTYMN6BypJhQ=28qSunocxg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtYUujsHMx28hNQdPOYLhgLTYMN6BypJhQ=28qSunocxg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.15-rc4-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 2fc9feff45d92a92cd5f96487655d5be23fb7e2b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ca91b9500108d4cf083a635c2e11c884d5dd20ea
Message-Id: <174588529130.1084685.15906062672921711573.pr-tracker-bot@kernel.org>
Date: Tue, 29 Apr 2025 00:08:11 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 28 Apr 2025 18:44:21 -0500:

> git://git.samba.org/ksmbd.git tags/v6.15-rc4-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ca91b9500108d4cf083a635c2e11c884d5dd20ea

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
