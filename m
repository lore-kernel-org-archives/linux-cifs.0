Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7620634F255;
	Thu, 18 Jun 2026 17:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781802296; cv=none; b=GXHWecTHHU2CRZbHJKRjckm7+a38fqtjOpW1/Pz94kS0KJY/PCDMWnPdBIKufi4gWK8NzPQGWMEOqeBhyTUlRFMKTpt9wB82WAxvoJV0Zr9gQY8sUZ3+6K8AkWwqDDwAquUyEWqfbuc0VnEj3YUWhSuae4A9tZ77iRp/nlU+RWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781802296; c=relaxed/simple;
	bh=H8Rs4Lxcg0wklo6hvL/ybThq0fpMxr0ItBfZnnUpi9E=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=FQEWC5U+jjkMUqWDiOmR4yWbOIZk+AEpy3IdEaRKkkS1cCDvP6SkasdKacj66I57Gik9ZF+SfCljoc15vx/dFMGfCEfGDrAl2k2sxMN4wJcxJzZwC/NAkcNyZ7WNqYpDNGeIqZJSJsp3b5f0s8ySYxz1zn/aMs8VdPG37kzEshs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a4hFCJFC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4hFCJFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9031F00A3D;
	Thu, 18 Jun 2026 17:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781802294;
	bh=wSZJmrIbej8+9oED9y6ViA6wYz5lYgO8fmxhlOoQAfA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=a4hFCJFCAnLjhAAqJkrLLFHuCuZRI8dQ6d0kt4R45Rf5GWJQH2CEYTGG2Cca8c3Ki
	 /0LKHJVpxJK1pBmpvHkd6Qg3V/AiFoctwdxWv2Yjl4N9YayaeomVNFjhxwUw62I4eO
	 I94DqDdkjpHzjogMkM5vnSBGoMJgSS2QZaKzez80MEKguHcC7NprIz4Rtx8jTjmB7D
	 /LrYv/UUM5U4ly0bd4s2evEN0YWljOE3SowDYsKFSHu8jHTCzfLazoMiGrz2FHK6JM
	 zwD9jEQo9BwNdN4RAdDWCojlQ+xTv3jNqCV9cT/gvKEfRRV1Hk2jNneeCQioctkSQt
	 2Kf4i03vorQbg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D09F73A566ED;
	Thu, 18 Jun 2026 17:04:48 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt-tckYA+GROnJLQWrR4JO2A6BgWGK37G5Z=HQ7efrkxQ@mail.gmail.com>
References: <CAH2r5mt-tckYA+GROnJLQWrR4JO2A6BgWGK37G5Z=HQ7efrkxQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt-tckYA+GROnJLQWrR4JO2A6BgWGK37G5Z=HQ7efrkxQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc-part1-smb3-client-fixes
X-PR-Tracked-Commit-Id: 0eb17dea51eff940230b5e562df29ce457124d41
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e753a63f2ac8599182a5b6899c158a745188551d
Message-Id: <178180228742.2987783.9818272346909244385.pr-tracker-bot@kernel.org>
Date: Thu, 18 Jun 2026 17:04:47 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 17 Jun 2026 17:32:33 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc-part1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e753a63f2ac8599182a5b6899c158a745188551d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
