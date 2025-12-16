Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818C134AAF9;
	Tue, 16 Dec 2025 08:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765872435; cv=none; b=XOY4gAWnofHXH1RRBSxerpxTEgLdf0S460zvjRE5ucO+uWt9315216J8ocFYIsg5LxsC74T/yT0KUo3d/CozTsLFM8rrYQwJ9A6yeZlIXA5JJXyb8EJPpV67pm65t/qDokGMC9N50GLhxOPxlI0CwP76kkc1cavCzx1vsBqMNqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765872435; c=relaxed/simple;
	bh=XJT1c9dqQBKD51DsUZRIv0656jhKt+6qbTEm5ztoPqQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PUqK5f9q+feIIlv38n33XJEWIDBILrPmdm08QevELxX8PsvwR2Vyfoty/BsvE/jVkI56ouIn3bjStPVs1Od6aM5eZ6mlIszXHt4fM/MMw4qtWPck476EMnIVNa0HkW8B1qCw99RfvsZ+RxFdtIfKQP3OaO/leVsFnhDuvdoZkMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KwIohlt7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KwIohlt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C354C16AAE;
	Tue, 16 Dec 2025 08:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872435;
	bh=XJT1c9dqQBKD51DsUZRIv0656jhKt+6qbTEm5ztoPqQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=KwIohlt7sjVoATV8Zd1ulQNz/XRVt99h1vexuXQFO6h/6U9HgL0q1XwrFoalGT8pH
	 PmDJjdJX2n761MWMsV09UXZpfmkOYaBq6dhNL38hbKklWmZ7n/3x+LEnRL//CFo9Pe
	 lR2bTzIa/w3rjXLkKHLhhlhFA5wfprGCMPlVjfWPglIQ+RCM9cc9vEATf4nkrcknK/
	 USpqQyewk2Q0M0HJJ0CME5b7YlhlW9U9Dxf2SQ+vtTIchWxKp6aaT6tIDh6FLQdMGN
	 nhBfoB7Vfqc20STRMf39X9VkY4bN2RqMSoo/drzpWVrzBZM8oKPyVBQw1YfSLI0uMm
	 oEAnKO3IyCRQQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3BAAE380CECA;
	Tue, 16 Dec 2025 08:04:07 +0000 (UTC)
Subject: Re: [GIT PULL[ ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msK2mYp39bX0=R+phV--knmAcLCXTdqYSWfuEfb=59dxA@mail.gmail.com>
References: <CAH2r5msK2mYp39bX0=R+phV--knmAcLCXTdqYSWfuEfb=59dxA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msK2mYp39bX0=R+phV--knmAcLCXTdqYSWfuEfb=59dxA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.19-rc1-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 95d7a890e4b03e198836d49d699408fd1867cb55
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 53ec4a79ff4b36d9711cfe030eeebc36afbc51dd
Message-Id: <176587224587.917451.16004614562498577580.pr-tracker-bot@kernel.org>
Date: Tue, 16 Dec 2025 08:04:05 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Stefan (metze) Metzmacher" <metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 15 Dec 2025 23:06:36 -0600:

> git://git.samba.org/ksmbd.git tags/v6.19-rc1-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/53ec4a79ff4b36d9711cfe030eeebc36afbc51dd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
