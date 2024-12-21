Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8FC1714BF;
	Sat, 21 Dec 2024 17:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734802662; cv=none; b=I3h+Bg33o+bl987Pwog8hBaY+f8kdo5JETUEUSXOBqTqAf0v1yLP0IF/oprNAOBnWN3WwCiEEDt75LGZcAEfUCGV5j5pEyONMOsVXCapK+DOUqYjuISa+itTwqZSkmGyY3Az91+5VvRbUuDmGAXytFn7sGsUNcVI2GHQVF6CcUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734802662; c=relaxed/simple;
	bh=idGTWyYmc4/BfKDM6vg9AbHYb4OvA+e7VyQe7DRmBPk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Z2SsoP2ZRCkISXPXn7t5dHZ1IKfhRviSauwPXZ/kODJ9vmoEqW39HPn3uJVwecYqpqwsTP2H2B6l7VsItJinoeU2T03KGLc5Bc7WQfdfQK6ODyFoYK58WLAD6q5NWTqgVtVIa7J/WPAcHN0bYfK5xD1pLNq/ol/kxOO21JLyZNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TgLYrq/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TgLYrq/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC935C4CECE;
	Sat, 21 Dec 2024 17:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734802661;
	bh=idGTWyYmc4/BfKDM6vg9AbHYb4OvA+e7VyQe7DRmBPk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=TgLYrq/lFA1VtWQCWd1jPNulRzKUIeO/1l/Y5FU+90uXafBs2XK4D57jIb/lFUh8M
	 uJPtjORjqnUkE0o4GiWlAZf7p2ef1AulX1oyUKJ65iQoVAWETdZ1Tq97nseiRnmyQb
	 JC8594vWA3OfZQnrTvVQPvu8xv+97+tAUEzT13sqOGX8ht5S1w+MRPq2Ah39M+Lf7Z
	 E5LrawqAuy0ufjLRIzOJ2IkgaYBLW9W1DV0/F/IXCkqmsrkCwq8WBKc1uCpZqxiCS7
	 EIeYdPuMYg0YGXqV8LenODEwVYKJR0RIeAzOkkR8h0rpgDpLYsdsTlZ0Ne8OwMuFxn
	 L3e3xrtZ15k4w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33C693806656;
	Sat, 21 Dec 2024 17:38:00 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvT2k2ToswPuhzqtcxTjAa6mAEYgZ5ZOHUeE19jYq=xoA@mail.gmail.com>
References: <CAH2r5mvT2k2ToswPuhzqtcxTjAa6mAEYgZ5ZOHUeE19jYq=xoA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvT2k2ToswPuhzqtcxTjAa6mAEYgZ5ZOHUeE19jYq=xoA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc3-SMB3-client-fixes
X-PR-Tracked-Commit-Id: 92941c7f2c9529fac1b2670482d0ced3b46eac70
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: baa172c77ac52b2058ba3abae7512b7b16d0c461
Message-Id: <173480267869.3197313.12556075687132333650.pr-tracker-bot@kernel.org>
Date: Sat, 21 Dec 2024 17:37:58 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 20 Dec 2024 21:27:28 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc3-SMB3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/baa172c77ac52b2058ba3abae7512b7b16d0c461

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
