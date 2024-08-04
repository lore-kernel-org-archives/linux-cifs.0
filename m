Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1F85589C;
	Sun,  4 Aug 2024 16:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722790456; cv=none; b=dhOvkS+prd+xE5BVdcnyQ40jMplsKq9X/HaVvslnN+6EcOe4o2r49RxxPUEufTG6seWSGSIMvxT1RkmXHUcgP8PmffXS1aOyb6L2/uDuzjwpBzlumzYKyqXzijAqOgiUhac44r0s7936REq7x48qTZYvTTZV3wb7NLcq/fH04UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722790456; c=relaxed/simple;
	bh=zmcoDeSLKQ0CmUzXotu/nW9ZW3C0p8z7FeycefSkR30=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=fxaN9TvU0Hnb28cYLPwkO+x+FiAWVwMTuAGCfvF31qIYLh7h7xWaJkFn65AOJVjIXf1Lgz1lDXLOsLutPVc+AO4meyad/0izJxxM2Y+5RMeq/TXrfvxvIO2OqhmF3CtyzFFw6esjl4Zqtho8dJh9PWlHNxKC6lEkW0JroBQRHb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kgWvrb6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kgWvrb6W"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 047ECC32786;
	Sun,  4 Aug 2024 16:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722790456;
	bh=zmcoDeSLKQ0CmUzXotu/nW9ZW3C0p8z7FeycefSkR30=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kgWvrb6WuJ6LZgaQjDyWhYKNYNEO052cGxwBz7Jc5ICZWzLlPwPoS0Q8+QYFi5EMj
	 Ldru5Qfk0HNks4WNNO/25VmYOyhKPNQResDTXVVl6+hPp7T7q5O5Naa/j3Pguq2zGV
	 Nw9ujnS0trH9kVv441obgJr+5PLi7bX1R8cE3GqSM5p2PBJqkt64xZqxGiUlfkzwy4
	 CiFWdgpZVJHjZcQ7DbCgeq3OZg85KbjbZXEKIfziTfQd9Eb4jBNHWAYM7QvIdTBt+H
	 VJ3O54p7q6WBVWxGU1+Am770BeL70wx17tFFOj+z/C/JgTCXWEm1MyPjDN1qZWyKob
	 JAQre8PTFMm6A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1477C4332C;
	Sun,  4 Aug 2024 16:54:15 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msSfDbF+wrZ6fWaaL7puR+N4MNQ3Vt1AH7K-Lp82nUGug@mail.gmail.com>
References: <CAH2r5msSfDbF+wrZ6fWaaL7puR+N4MNQ3Vt1AH7K-Lp82nUGug@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msSfDbF+wrZ6fWaaL7puR+N4MNQ3Vt1AH7K-Lp82nUGug@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.11-rc1-smb-client-fixes
X-PR-Tracked-Commit-Id: a91bfa67601c07ff9d31731fd2d624b47b0039f2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3f3f6d6123c3eb8bcae6c87776130d560250be77
Message-Id: <172279045584.17405.5135991288077777622.pr-tracker-bot@kernel.org>
Date: Sun, 04 Aug 2024 16:54:15 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 3 Aug 2024 18:14:19 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.11-rc1-smb-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3f3f6d6123c3eb8bcae6c87776130d560250be77

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
