Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3365F1D5ADE;
	Wed, 11 Mar 2026 03:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773200009; cv=none; b=V1TSJTPelmKMlPRLODsqP4fJ6NuP4M8A8IXqyb1rVNpgwO0gN6eWdpSg0ofOCAwgSCnyY5qAzQ81DxJyWZ2cUUYV8vQ4o5zcIspM66WcGq6XlurLIJD9CLkPSz0leymnt+CihARb0mfwWiptbkPOSQwX7TQvYzrhCrd+VBFNJWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773200009; c=relaxed/simple;
	bh=uhwysNfDVoihprEL5duOOKv31q2we3NBTD/IRgRDsWg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=tVx1tlo2BRafZme2RN2l2a3a8LHMVesp3ZCcbD0k2XxTTguLKRPcK1Z2kXM9pijPYBVy/I2tfjmZHNNX8o93hVWnEMVwAeHjmpja5GffZEfNrTC10xPtxnf5iHaESqF6hM5RMZROSDI3f/9xCBPgVURarlNL8n+HBlAFrT9ctOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHujkNsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHujkNsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B18C4CEF7;
	Wed, 11 Mar 2026 03:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773200009;
	bh=uhwysNfDVoihprEL5duOOKv31q2we3NBTD/IRgRDsWg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=QHujkNsMX4fEYFZ5/UbRb5sC2dqsh/lQjur1B3ksYA4iPsgbnI7G3Ut0RwsdeoZWf
	 1Otb/zF5YybJkyhyhVH/U+xqPegLmf2P+67MvXuoP3FLBVsIuI0HKckJq5sE02Vhsn
	 H0VvOeWOLOexgMULpABzrvRuzGU3nNB6xjjkOVREMcKcdk7KdO6nDmNSZ6TZC1HaKD
	 7SyGHQRPWfqnlD1bZGszCoLszBytHP+n1JRv7MnUJatQwqjMfUd1Au199C33f7iHpC
	 w0gUUYMv9Ag6IYQ3b5IHrqa4GiaMmaRVgYOndfO4rRbvKjniDIv/cwmMW9aKxXx4oP
	 v1VQXddTYPurg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA1113808200;
	Wed, 11 Mar 2026 03:33:26 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mu0GQ2mg3z3495AjZVcyYr-LFu-BOOWbDT5Oeg10u07BQ@mail.gmail.com>
References: <CAH2r5mu0GQ2mg3z3495AjZVcyYr-LFu-BOOWbDT5Oeg10u07BQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mu0GQ2mg3z3495AjZVcyYr-LFu-BOOWbDT5Oeg10u07BQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.0-rc3-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 441336115df26b966575de56daf7107ed474faed
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b29fb8829bff243512bb8c8908fd39406f9fd4c3
Message-Id: <177320000527.3030226.9007540165760330588.pr-tracker-bot@kernel.org>
Date: Wed, 11 Mar 2026 03:33:25 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 10 Mar 2026 21:19:31 -0500:

> git://git.samba.org/ksmbd.git tags/v7.0-rc3-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b29fb8829bff243512bb8c8908fd39406f9fd4c3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
