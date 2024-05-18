Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2386662A02;
	Sat, 18 May 2024 21:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716067317; cv=none; b=t+tGePkK+9K5VamaBqmcJbZNerg+LmVcb3KbFeU5W0sXsYis6UA/rf8Md5i9LS5tEVl/s6xCSOIjaOVtzsBlExt+bcuH35eGPlrn0UIhh0a4+N4I04RWqTPhiBM+5olsuHGlI4VSrxHcVEpr1zHM6LpysnNi0S7MHb+Gi9VvBwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716067317; c=relaxed/simple;
	bh=xaVdwMJGXMV+VLkCfXhrFIok6/lsYHXJg/N2c/XG7FU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=KP8hy8Hj/r6cZ0J8Tpij5NzuPckJ3Lfs0kTRPeOd3/NY4IlDk0rP8GRGTYKSRifP8jA85ihOgpVitXFqGRaWg9uBpeAaw8szIt0j017w8yjENV2XxVcwrBUcLNJ5jQofxOXibB3MYRHLjYD9FgPm6Fre/+UxSLc/56YavumPsa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SJJLJZFo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SJJLJZFo"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04DD0C113CC;
	Sat, 18 May 2024 21:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716067317;
	bh=xaVdwMJGXMV+VLkCfXhrFIok6/lsYHXJg/N2c/XG7FU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=SJJLJZFoqFiXz3QATRMoiUrlR1yWmSf+/rQSKxQsG2LXRt03advse3g0ct6ujKyHo
	 l1w4UjOaW3+S3iMvvtn8Kz83mT7WABg5UEhvSxqEs0Meue+C7uVYoDciIqswRGirkw
	 CVxOHziSTJ1gCKeRw35AA8oB/cYPRHQiD2jYnxxqdW95uSbqya4nCAXrupF+4ozAx4
	 aJ1NU2VQ9yLQOUrEGHn/v+DALhlUxZxGf6XyG7KTIyCJblU9aqwzOuCtqgT1Lvw8a4
	 eQKoRxqDo8v21A5j4Fx0F2+13QV99g6eyS9xT0PLDmOUKBh/GDpucARrJ4WDC/7FCo
	 wtOTOf89oIMhQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EED8EC43339;
	Sat, 18 May 2024 21:21:56 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msmH0Y=iUcu15eX3DiTS=Xdq=v1nqStWR20oVXYhAnFdA@mail.gmail.com>
References: <CAH2r5msmH0Y=iUcu15eX3DiTS=Xdq=v1nqStWR20oVXYhAnFdA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msmH0Y=iUcu15eX3DiTS=Xdq=v1nqStWR20oVXYhAnFdA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc-smb-fix
X-PR-Tracked-Commit-Id: a395726cf823fe8f62f1b8c3829010e5652ce98c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0450d2083be6bdcd18c9535ac50c55266499b2df
Message-Id: <171606731696.14195.4481379540601242834.pr-tracker-bot@kernel.org>
Date: Sat, 18 May 2024 21:21:56 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 18 May 2024 04:59:30 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc-smb-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0450d2083be6bdcd18c9535ac50c55266499b2df

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
