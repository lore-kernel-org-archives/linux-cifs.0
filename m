Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D962836B5;
	Thu, 21 Aug 2025 12:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755777662; cv=none; b=tCOwgboIJFUjkLYt28WIfEiADnKTgn1nKwXXj/ExJqD9bkcgk9OW/8ZiqXrON7DKap1Wl/GZRcaWe4RXYA1H5VQO2gEFmt4GBuyoYONRZx5j8GyG+0SqO0siuDx2JmLfiXhRv9LZCkxHYJ5DGbY9tvGI2yNxtbK7GUxbz8NamXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755777662; c=relaxed/simple;
	bh=ikICiDx5ynHD9UKWIpK0SLbF0G/cChV9xzcF3tz7FMo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=LsZ9WxIJqTMKd1NXfFsatZX/aAEo18PgWCMj0FKceycK32UIUHFcxeIHl7X00lJiJCBWcettNbr/RVZnHCViFmx9bQrdLvHuWsFMROld06m7qbSt9C7j7u0JSCA5W74oisLXZCs+OxnvAhjb+yXpjkKT0409aQv5CdfB5iZdSxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bP1QoMmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bP1QoMmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34035C4CEEB;
	Thu, 21 Aug 2025 12:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755777662;
	bh=ikICiDx5ynHD9UKWIpK0SLbF0G/cChV9xzcF3tz7FMo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bP1QoMmpj/83CiccuD5gxObMIGZZOYpJfJmiUXLJ1WkNa7cCTH9x4XSxKEUNgL+iS
	 iuV2je2sTxbaGevZh/we78CmygnjQS4gImwAczedmARZZC/J+d4iWgghHIlJ7tbGNZ
	 fOvR5qyu6mcHqsynuS2onWmt19nb9EPDYFNVcLmkrvxfKf/sdsR424uMdVY/XYl9pQ
	 ubxTxkP7EEEHAUGTd65Jj4IXNVZdY57MPfILtS08QeYw6rcs/HMu79DJf4Mh3eGKvK
	 X9henDuUj/tpJqUvxVFI80T33rX8ctEzcQg3LM+n5AEggQgqA3mohJTDj9GYrfd0Vt
	 UeDn7yKfxrvWQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE048383BF5B;
	Thu, 21 Aug 2025 12:01:12 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msSBLTFkG1FGLFD9rUjQ+8xSHdnUaoZ4zsBGrG33zGrcg@mail.gmail.com>
References: <CAH2r5msSBLTFkG1FGLFD9rUjQ+8xSHdnUaoZ4zsBGrG33zGrcg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msSBLTFkG1FGLFD9rUjQ+8xSHdnUaoZ4zsBGrG33zGrcg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.17-rc2-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 89bb430f621124af39bb31763c4a8b504c9651e2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: eb4a0992ddae04ad5b402029a430b2fa06c81647
Message-Id: <175577767131.1009012.2197929237550101428.pr-tracker-bot@kernel.org>
Date: Thu, 21 Aug 2025 12:01:11 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 20 Aug 2025 21:02:45 -0500:

> git://git.samba.org/ksmbd.git tags/6.17-rc2-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/eb4a0992ddae04ad5b402029a430b2fa06c81647

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
