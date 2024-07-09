Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EDE18A92D;
	Tue,  9 Jul 2024 15:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720538515; cv=none; b=i29GEJfl7C+RIIQYDq+iQHjzvhUBEK7zWYws9jBZyARaE+1XOtfGvFQc71pH8AyY1BRufb8XX0Ffqu0Rq2BfqtDSUYc/Mi1HJTFcI1uFzGXc4ej6GaUGfRCAdFBw1uYdOnE/IFqUURy8YfYE3WjCaaerctzRpxxuduVVDtSNm2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720538515; c=relaxed/simple;
	bh=ooNhGSZfnjKF4rRZFR/J+ca8Fa7D/2np4lj0/8/ulAs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=G+n+HaiSI/RulEO5IxzcfGhyjD1jmLkDq7wbYODZHbL+fNo/80/7i2yKbAJ6fLwQv9JP/SFGnRXuVZMH53Kl3VniviYWNPPZMb58LbCT1evSWkPC3zNbUpYCAKTuFxiXDk2NaWLaFIWaGrfzSqSKAYzE/vuZv8sM1TR19Iy0olc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4GNBfG1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4GNBfG1"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74BBFC32786;
	Tue,  9 Jul 2024 15:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720538515;
	bh=ooNhGSZfnjKF4rRZFR/J+ca8Fa7D/2np4lj0/8/ulAs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Q4GNBfG1U3Hzk5avwjr3ne9fy8KZ7qQFqgMQYgoSVrcKgNYklE9K453PPrSthUT9L
	 mGy5F/rmUcNJ2nrcD0OIiVVB83j+2ABrHcKv8rZ3RzMIgzyL4WSVUa+E2l5zksYstA
	 53CaVYKQfoFLSQhCgA8jIHav9EIvA0IdVyz4pRAZyhZtHERrrB1Zgt+6WM0+rkCwWK
	 iMwyg9OVh3f3yCFvR1HaHBEByDN6Axmrkm01KWXD2CkFd9CtZ8qSbmqhhKmSm0Du9D
	 gWemoC4ehxCX/D1zozJyzhmV8hl9p9lmwnXRLVK5UfzI71CJ6GHdOqXrT81F7xgFr4
	 5r7zjN/HzDqAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67A3CC4332D;
	Tue,  9 Jul 2024 15:21:55 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msc+xJSJcGhf+bV3++0M8g1C8f+oLLwA2R2G_cf_6S_8g@mail.gmail.com>
References: <CAH2r5msc+xJSJcGhf+bV3++0M8g1C8f+oLLwA2R2G_cf_6S_8g@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msc+xJSJcGhf+bV3++0M8g1C8f+oLLwA2R2G_cf_6S_8g@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.10-rc6-smb3-server-fixes
X-PR-Tracked-Commit-Id: e2e33caa5dc2eae7bddf88b22ce11ec3d760e5cd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 34afb82a3c67f869267a26f593b6f8fc6bf35905
Message-Id: <172053851541.32730.16314468783298639931.pr-tracker-bot@kernel.org>
Date: Tue, 09 Jul 2024 15:21:55 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 9 Jul 2024 09:57:59 -0500:

> git://git.samba.org/ksmbd.git tags/6.10-rc6-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/34afb82a3c67f869267a26f593b6f8fc6bf35905

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
