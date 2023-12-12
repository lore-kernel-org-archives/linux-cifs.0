Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2EF81E33
	for <linux-cifs@vger.kernel.org>; Tue, 12 Dec 2023 19:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0YjAI/s"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6889FC433C9;
	Tue, 12 Dec 2023 19:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702408418;
	bh=b6+xPEypTzYTk/+aHKM9cnUEeFkXHPQIJcO0FRSD9O0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=f0YjAI/s3miADkyrML78I3zC+rs1Nj5CNWu+HQbg+TP2qHhyh3+015EY/QUs/ggdH
	 kkUHEw2GXIkhtuQ2oBQ+nHEXHfbXooOVkcC8suucreHDFT+WneMjgTXq/Q7oUcj0zg
	 ReSn1qGfW48VWfh2OsRsYwUEsW0utmZUZYB86WdVyNnIMqWwrY4JUnJcvbs8MHarAo
	 Yda1BrjTr0htYBMQHUQmVkTEMT/3GqHbSlVGLkbDR2c/PfKCgmK9USPm4Naxq5I7hE
	 xzzwihzdBMPQXNyxWjyOH7q0vWlEKguOFPH+fgy0FIyzaOOV+SiGHPvmyzUECDSS2s
	 kiwVkO/ivGJCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 55A3FDFC906;
	Tue, 12 Dec 2023 19:13:38 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mscEZygkgAK49pr0Tf89eJAhngE35AUo+Rmt1800m9TnQ@mail.gmail.com>
References: <CAH2r5mscEZygkgAK49pr0Tf89eJAhngE35AUo+Rmt1800m9TnQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mscEZygkgAK49pr0Tf89eJAhngE35AUo+Rmt1800m9TnQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.7-rc5-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 13736654481198e519059d4a2e2e3b20fa9fdb3e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8b8cd4beea4f6c68092736c544a797dcd5e094c5
Message-Id: <170240841834.26992.17245797143389384279.pr-tracker-bot@kernel.org>
Date: Tue, 12 Dec 2023 19:13:38 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 11 Dec 2023 22:44:32 -0600:

> git://git.samba.org/ksmbd.git tags/6.7-rc5-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8b8cd4beea4f6c68092736c544a797dcd5e094c5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
