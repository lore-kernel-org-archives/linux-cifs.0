Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D3E41A8E;
	Thu, 19 Sep 2024 05:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726723218; cv=none; b=CUhA7lpE8aAoNn/nFFxjQFjiVtF92/HYpXk5hrm9k0mywZH/au5uL2ClehOzn94mDZO+GcjBGSBWXYNn3UZfrKuidkTyBakWEob2HY71YhNVbDTynAzpWfKGS+BNTeYD36R8o287HJs9d4sSVfIy9R9NQPPqvQSnS/zjHcaSwwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726723218; c=relaxed/simple;
	bh=C6cVeUPH4z+fQSJFqEWAZfFQ8LyEAqc/IWVmVno2mes=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=q6o6QKo3mKcFZgFJ7KonS11olYW7nDuFDJktqDoNXQCf+F+p97YV1Y2pQP7Ju0eOyhB/KtVDtwMDhoQsOWbzFH21tddJoYppSdvCEVnYX3SiNaX8sEWlt5LhEjsP/BobBNl6BwqrTjwmDKN85QVz+uHwRyJbA4AyajDybgolS/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LHXKRr2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LHXKRr2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E87C4CED1;
	Thu, 19 Sep 2024 05:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726723218;
	bh=C6cVeUPH4z+fQSJFqEWAZfFQ8LyEAqc/IWVmVno2mes=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=LHXKRr2aC9lCDfSnWsz105tFPS7CJc1lDaZoWBC86AOMKlW0pgJZeFGoNMGeLZ5iD
	 ZrY6E1OVAf1OJhsKLnH0fDy1POMb+H1XJUDk0wjpPcY8blKas8e6NANrwX5zFiQHVM
	 b/aiWZTlSsFeP+JyYa+HaOSfxoqR2jT221RKXcIfy4fsQnmfNl9/IrY1xUrxBz1mQV
	 1VoZ1tk2jZoskmACe8z/jxjgEtvEFfTSUYLmudV9UBCvGSi3n/fHjUceiFnnIq4040
	 fgzvz2SbT6aHkpl4aivgwcNdVyExAr3R2Z6jZNgoDCu4+1uBAEklwSUito4p3SziF0
	 Jcq2sWe8Qd4Rg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AEB813806651;
	Thu, 19 Sep 2024 05:20:21 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvoPwxQgOFOJpLke-deTpy2rh6o=Xh-F8tWr08bMdiEcg@mail.gmail.com>
References: <CAH2r5mvoPwxQgOFOJpLke-deTpy2rh6o=Xh-F8tWr08bMdiEcg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvoPwxQgOFOJpLke-deTpy2rh6o=Xh-F8tWr08bMdiEcg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.12-rc-smb3-client-fixes-part1
X-PR-Tracked-Commit-Id: 5ac1f99fdd09d80223e8f47dffaea41a6563aace
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4e0373f1f920811a67fef0c3383f1ad602b3845e
Message-Id: <172672322060.1036593.7114125994221471186.pr-tracker-bot@kernel.org>
Date: Thu, 19 Sep 2024 05:20:20 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 17 Sep 2024 03:22:17 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.12-rc-smb3-client-fixes-part1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4e0373f1f920811a67fef0c3383f1ad602b3845e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
