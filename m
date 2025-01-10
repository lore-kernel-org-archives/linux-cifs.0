Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249E61B0437;
	Fri, 10 Jan 2025 02:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736475928; cv=none; b=lJLzfN2cFmFgO4lInG0hug4kwU0deKLDsbpssW/vGqE2xSvx7ZVWrOIxrgm6AHKc8Hl2GrXYHZqVRzEVu3JxQM0529F+VMfvqVQU+OOgGju0zz5/G+oah6c5QYKJpwWdc0s+XZUtlDHVKwG/TpEe8kJ+rBAjiPTfaYMup+CcJck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736475928; c=relaxed/simple;
	bh=z1g+JHavsCQfNe+rm+Z/nOEMZU0k3KdFiCGqLEoeo8E=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=asnD70CEOs06Ruxs2xzs6SqGT2d5d+hV74iTueUKDsCqAyD4rG+7VMvd+FHdDwdpraVDOuc5NrkUqeDn8XcXWUd5PyIQeMGoQ1faMtQffG3/DHpqviBAiITObyKIl4drpXUrGDK9Y/hiuDpQXGmJI7jCIWWOVn5EfuqaGMNryMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TPrpWaxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TPrpWaxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6A6C4CED3;
	Fri, 10 Jan 2025 02:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736475927;
	bh=z1g+JHavsCQfNe+rm+Z/nOEMZU0k3KdFiCGqLEoeo8E=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=TPrpWaxT85YtS4THFH5X3ny9NTwIyVlqead0JHnxfGJ13U+GHyjN5PgKrDgZ1vqFe
	 X+/o6/kfwApShZtbZiGykbgTYutFHPBDIzbwrH3OmGi1uGAb6hYLXT638Ye5r8hxFP
	 7yyVNUryX3SUNzQgfr9dTxJ2Yipm0cdwcvHWKcuOxl9LBYykNuttcxQZc/IebzZrKt
	 6jKsucSz8BY/mqmVwwdWBRozXnHt8HHta48uiafNgF/7YFOCrXbL5A8fxCz+sgoQYD
	 ifkxrhVwueqxFd+hM7XUsl+9Wcxs4XxULrMFSEs7FicBqkVsClh9beq/079uztxVv6
	 3fC/MlYsuhfpQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE104380A97F;
	Fri, 10 Jan 2025 02:25:50 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvjSQNPb7M1ammL5_9+Qx7d-hVQXtTy+rBrbcdDSbfK9w@mail.gmail.com>
References: <CAH2r5mvjSQNPb7M1ammL5_9+Qx7d-hVQXtTy+rBrbcdDSbfK9w@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvjSQNPb7M1ammL5_9+Qx7d-hVQXtTy+rBrbcdDSbfK9w@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.13-rc6-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: e8580b4c600e085b3c8e6404392de2f822d4c132
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2144da25584eb10b84252230319b5783f6a83041
Message-Id: <173647594937.1580660.9117475659266476419.pr-tracker-bot@kernel.org>
Date: Fri, 10 Jan 2025 02:25:49 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 9 Jan 2025 18:37:19 -0600:

> git://git.samba.org/ksmbd.git tags/6.13-rc6-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2144da25584eb10b84252230319b5783f6a83041

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
