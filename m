Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2296836A367;
	Fri, 22 May 2026 19:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779478723; cv=none; b=sUchLbyboU46Sei8cLJICcLWdcLShnZCIuwI9PxpOngdLtHI3qO7086uE7ypw9cA5X/EtxupVagKpJa7emUHbYdlrAppChRqR8TwCKCy7kBwcKB9QUjzTnJ1qkvVKElzLSPRE/HuFuEi7YB0+sKvpOTS2Lk2mMPF9Nc9ZWV59bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779478723; c=relaxed/simple;
	bh=LpREK5AS9C0C1EcVOJLMAatovvS1rPI1fGrC199IvYU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sbdVVbJk3qcq2FF3/woOJakD1Ek0VJjPOTY1szRf107NA9rbm+2K9tkXDYV7Lq18EJdU5xowO+GFhYNXS3QB/k1cPZJAbhQ0yctwwoXNqnnd7swnDGCRbZhkNAg0l4OoxZB2C0n91ZVaomTXOJX184/HfE/k+5UggXFvliSA2Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UWFR8WkD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UWFR8WkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3461F00A3D;
	Fri, 22 May 2026 19:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779478722;
	bh=pN/kHHhxL7nmEKF3+D7m8YTkTde/YgAXFcnr4cs41SM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=UWFR8WkDUjzmibTD7YiIGdSjV3wMqDQ1FTSRxx3kZ/p1v+Cjg29YjMczH1LZSFDBW
	 I5UAWACLMUYMk/3qXCKh9KBdleftuYw/SrgnMuQXy1guxzxfeeL5RGQ7UXNHDqF2NG
	 Ion6rGglMgGEvKQFpmLQ2T71LmJbw0DdxMuSGfF9XVRqnw1hDAp3JABmM3DINKVjgX
	 +1dHTwRViDFPZ5DbmInSKs14kgf4NPxuXQ/iIm1CJgieM5FXBio/zBSCl0KaFFJxa9
	 8hxpBOen+OhYEpSqnuI78G7zJm/y1bD0PSbSFtvH6bXnp2TiaGxueUx8uC6H+T6skY
	 DfFZO4EpakdNg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56CE63930FBA;
	Fri, 22 May 2026 19:38:52 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mu4Gn_=ytSix0xtuSLp5ENp0pgx=M8xBauG5-1U-+y2rw@mail.gmail.com>
References: <CAH2r5mu4Gn_=ytSix0xtuSLp5ENp0pgx=M8xBauG5-1U-+y2rw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mu4Gn_=ytSix0xtuSLp5ENp0pgx=M8xBauG5-1U-+y2rw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc5-smb3-client-fixes
X-PR-Tracked-Commit-Id: dcd4313f0987d69c4134c12bbe3a8cdf795f6c1e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 558c3eca715ea0110fe6fce38b063a6f9936188c
Message-Id: <177947873076.1341212.11433168173511485216.pr-tracker-bot@kernel.org>
Date: Fri, 22 May 2026 19:38:50 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 22 May 2026 10:50:10 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc5-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/558c3eca715ea0110fe6fce38b063a6f9936188c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
