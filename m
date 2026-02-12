Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEAD26E6FA;
	Thu, 12 Feb 2026 19:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770923628; cv=none; b=tGHBA5LsdhHqWc5vJMMAhL1nre3v5Ho9acH4VREMRDOz3MOc93ce3dk/PEI2lPwdhZlD63qRhoNlrbu0gJy1CSuLsN7beMz2e0I41NURGLm1vAz9fUrhXBFm2yyghFQxU6oW0HA/BN/ZSOOEhR3kpfb6+gO7ZzykgINvvIXKL1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770923628; c=relaxed/simple;
	bh=7p1wFJZyNvaUcTSM6UWhypZTz4oyXV4fOe2EuWePzu8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=WFL08T5sQ6PzQW7QlykiNSU70X9B2xRKhUAueJ3vQcwpBJ6i9pAv0Shj3ZZwEwl049O9T+AIdj+9+AdEGCPf5AcnVuyynwppYd3im2d+mURPDFKXM4mJ7M8zuL70/7NwCZYa5cMzUP6Edwd/GCQ//3sR50Ku9C+Ty3OBJjwMLHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YF5pm4g1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YF5pm4g1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6B1C4CEF7;
	Thu, 12 Feb 2026 19:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770923628;
	bh=7p1wFJZyNvaUcTSM6UWhypZTz4oyXV4fOe2EuWePzu8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YF5pm4g1ddPSERhWkyQmN/Rcy+GQF3C/OxAEvh2lMqQVPuWejyt/AlP2nkqP2J4hg
	 hbU2GvBXMODxECHEqiKSj9sb1VeVxDCEoZlq2PFYwoxO3L+DtyY/Ua+9LVGrZHryK4
	 QgcXpVA9Z25Zd3gpd14rpTrLXCXVHWUnoMU2pJH8/E4t23zvocHJZFW7wcL6JvArbo
	 vW8JkLNRHVG1Ck7AVq3C564R7J0D66IEu5L2KrUP9uUoatJjZohkXaPaATY4YVUonW
	 cz4DaAPAl1FlcDZnH5Lv27YMiLB3L4LepVnL655YnRKbAZpKAw9E/2ZJSTaFVpDy7c
	 uqsFMews7f+Ew==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8554A3800346;
	Thu, 12 Feb 2026 19:13:43 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server and smbdirect fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mspbOKxugfaCoZB1qgO3Bt0Qw3wNPLfNQYf8ZGaYLPXTg@mail.gmail.com>
References: <CAH2r5mspbOKxugfaCoZB1qgO3Bt0Qw3wNPLfNQYf8ZGaYLPXTg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mspbOKxugfaCoZB1qgO3Bt0Qw3wNPLfNQYf8ZGaYLPXTg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.0-rc-part1-ksmbd-and-smbdirect-fixes
X-PR-Tracked-Commit-Id: 8f7df60fe063b6b8f039af1042a4b99214347dd1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d53f4d93f3d686fd64513abb3977c9116bbfdaf8
Message-Id: <177092362210.1663336.17330759084623750614.pr-tracker-bot@kernel.org>
Date: Thu, 12 Feb 2026 19:13:42 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 11 Feb 2026 18:31:56 -0600:

> git://git.samba.org/ksmbd.git tags/v7.0-rc-part1-ksmbd-and-smbdirect-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d53f4d93f3d686fd64513abb3977c9116bbfdaf8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
