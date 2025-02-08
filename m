Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8B4157E6B;
	Sat,  8 Feb 2025 04:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738988635; cv=none; b=M7csVrwTosTV/g+P472ScYgx7oCYqhgfN3jbwyeZyo9B14C+GxiRF8oL9eMfTmMFdKqyXGKof1tnnk15XzGd0a1PjB5SQIRmF0YPS1D/b3kpVO6r7cDry15iQsnjGSPp15LO5yVEIpoUsl7dc7SpKMBUekDTw9VOVeIA+WeH+6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738988635; c=relaxed/simple;
	bh=KN6AT4Ttm+7Lvzm/WFktuwob+a2g0EczB839xH/mITg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=U/CPTRJg1Gue2k5DpKRa43iceqKuJNQjDr5OH6LRbt7G8b8lMKjH4M9eNSnFBJrYKnk5jNb2mQjSp9vkfad1RVxdf8lz331oLbi7MJDJrwFyHt4rdmQ7HUwIlV3GmSqUQOWW3ieOJZSjA0W1bqrUFJWfcFrSFAWdrm1voP8VfmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O2C5ww3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O2C5ww3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC929C4CED6;
	Sat,  8 Feb 2025 04:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738988635;
	bh=KN6AT4Ttm+7Lvzm/WFktuwob+a2g0EczB839xH/mITg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=O2C5ww3lV59TR9eZzsvto9nlIBoz1DWx9NcEv/a+U3KwXnbyBxsg5BP8IehrY26yZ
	 URsxyJU29W7dmkXqsIhOKaoqoXctt+3MaqWI758ARvXTXCg3RG0RXczeCkbXw7Awbq
	 zSj3h+XRK+yehjCQlogvPxnQNzDsuL/g9GW1G/Y8iNvncovr0TF36gUrhhiqCLC2yV
	 XcXCY0gzKiUGzjj8Z9FlZEGUIl9fVEkOUCTLcpXapcU7xlyal7VWbqEkZwz49/2dz8
	 y4BnJyjIXFajoXicoC30LsUIQXkPyr2ENnlKKF+y5GQUJ4NJ2p2eimIy7CuCaP+hON
	 9Wh31JHdS6tUw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3443B380AAF5;
	Sat,  8 Feb 2025 04:24:24 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muMvrt2ZT1OAF=mWxNssTg-fHcO-Zqc6r3OeZ1nrhMTgQ@mail.gmail.com>
References: <CAH2r5muMvrt2ZT1OAF=mWxNssTg-fHcO-Zqc6r3OeZ1nrhMTgQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muMvrt2ZT1OAF=mWxNssTg-fHcO-Zqc6r3OeZ1nrhMTgQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14rc1-smb3-client-fixes
X-PR-Tracked-Commit-Id: 57e4a9bd61c308f607bc3e55e8fa02257b06b552
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2b753053980339a25d7ccc717b879f64e6a1cbea
Message-Id: <173898866277.2491573.9224195031713134141.pr-tracker-bot@kernel.org>
Date: Sat, 08 Feb 2025 04:24:22 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 7 Feb 2025 20:33:58 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14rc1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2b753053980339a25d7ccc717b879f64e6a1cbea

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
