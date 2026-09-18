Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395FB524AE0;
	Fri, 18 Sep 2026 21:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789765912; cv=none; b=UgrqGWO3fLTktSrcS3ETZE1arPOvgDhyCna6fRTioYvLUBau5zqtJueApwkTQb5ik3o3FAMCGKqgJDJLyNjFwm0NVZGbLiN9T8l2hVnHVeX/Kh9K3cy0qB413HXyFkmIoEdBWmuLonS3MhTdd74+lnQl0QfTPmtwXECiVX0FuHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789765912; c=relaxed/simple;
	bh=osNcEEyuw22cX8LswihH9CLJ8LWAlCXlvVTJ2gc0LvI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PHfWMm23iubc17/gx7EWb8HRJKOaNhVCEtyRvkooE/Y6szN/4urJeGPZ72PdXrFSW3aSW2yTrE/kqj2lIc/H29UmM9OqmE5FZnLf0BECE6kG+p7nLVdfHuD5lauPUcXWjrtM8b2mW3JJcceYqOn5TRJpzWFKRe5p5XUN7nzSWvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gCdGlKf6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gCdGlKf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6AE1F000FF;
	Fri, 18 Sep 2026 21:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789765910;
	bh=cO2yGP0A/z8g/sVWgR2PjO41OyfrtIW0cabUbepwUoI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=gCdGlKf6jYJoDAecSDkA9G7R6GDWgZIK3tzNq5OjdD+gteUchLm3lSeGxUSPQS0vt
	 wj0gQhREIvEQj2gNpEk5lEX2d5fyfWjXsjAvXPIGI4/fFkSWluBKPgQPCbWvjPuELY
	 uTsYKk9KlUL5C0hLtgXulYdSg/8hD6G+QeSHAmdf7hyezd0/XdggO2VydjeR6eHtWE
	 z1jCsB5f1uvKOQJXU6WFd/dVVuTLo8UTjL04YtGq6zkUaNYAPmLzaQM8+3J1ViLWOF
	 xLAsENFFGETpchbutndrFlbX4Dw/+e0FBrZOM0ryZf6pebR1N0r4a2pBN26/fgC9Tv
	 SCtHMOb92bK+w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19DA338111DB;
	Fri, 18 Sep 2026 21:10:45 +0000 (UTC)
Subject: Re: [GIT PULL] smb client fixes for 7.3-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <e1bfb4b2fa19f5f67b17ed2fcf141c7b@manguebit.org>
References: <e1bfb4b2fa19f5f67b17ed2fcf141c7b@manguebit.org>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <e1bfb4b2fa19f5f67b17ed2fcf141c7b@manguebit.org>
X-PR-Tracked-Remote: https://git.manguebit.org/linux.git tags/cifs-fixes-7.3-rc4
X-PR-Tracked-Commit-Id: 717e0a25036b6c92cecace30913b2d874a4c22b8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 17e7b8eacf4cac800a4fc89a28729df72a2dabda
Message-Id: <178976584360.1148872.9406692266425067829.pr-tracker-bot@kernel.org>
Date: Fri, 18 Sep 2026 21:10:43 +0000
To: Paulo Alcantara <pc@manguebit.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 18 Sep 2026 17:41:13 -0300:

> https://git.manguebit.org/linux.git tags/cifs-fixes-7.3-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/17e7b8eacf4cac800a4fc89a28729df72a2dabda

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
