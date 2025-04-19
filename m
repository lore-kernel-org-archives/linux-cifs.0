Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3225475E;
	Sat, 19 Apr 2025 03:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745033400; cv=none; b=tik87CEqNExcNZibVlz01K4vsuxk0IDN45a1rC6GpNthHn4AW/aaAdALcVHm46sNOsK3t5aBq5Ss0JnbJ4KgqNNmmGmMLT7cAKPA69zZy9aJcNqcqMAwjAAfuKWrgB7flrT9NVnB+XvGlDNc5Rmkl6nr/tJGum5gtKBRMjAJwPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745033400; c=relaxed/simple;
	bh=GJA2IZkMBMWW8If3gOGLjX0xuApQQ+Jn3/E/O/UMfjs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=lB7mP4rdwQ4jz8uEuufZTKazyMq2pWqMo53ATO/OCNTGARvfuac8imhqx6KNXqq7Hj4MhooDASktwLibwtwpYvvyR5yqOkj/4eg1rTrSe/4tfBKzfkvowMoCYVK6HXq6+P+BHEMa+qTnECeUUYSE3ik9veRFThbBPaV66HI5E68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZdN9lpRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZdN9lpRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DADFC4CEE2;
	Sat, 19 Apr 2025 03:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745033400;
	bh=GJA2IZkMBMWW8If3gOGLjX0xuApQQ+Jn3/E/O/UMfjs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ZdN9lpRJuPFQYrLRKOO/BLHjoX7XrZ3Na60adCBQ6XsGSuuErW7zDH4kExYAWHPMi
	 yU8hucdbMrgVdRd/RYIoIZa27H1BpYBU9jRjh7Sjg0kUFdTHw3tSiIC5NQau5w2v1b
	 nh14cys4tMuvzhA49z1+QYk4ypr5v1/yCAmkkWJQMvY7HZ9oQLdv5eGeSAiS6uMRyO
	 lC0R7skw/H0aaIED+weVJJZeDJMFJ6IKdqWTlU4wNaWCAO22KS583UKkhWacVnTpyd
	 CeuhVe1s2cy1Lc05b4vVe4U4kfvMWAfE9BSRFZgUZXepXrs2hST6HKRsswwp94sTIo
	 sxFMQTjpXtAkg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7478B3806642;
	Sat, 19 Apr 2025 03:30:39 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msf5GpS_RV3-apwDGuVMVDWsiWfeKfRy55xnTbjMvPCXw@mail.gmail.com>
References: <CAH2r5msf5GpS_RV3-apwDGuVMVDWsiWfeKfRy55xnTbjMvPCXw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msf5GpS_RV3-apwDGuVMVDWsiWfeKfRy55xnTbjMvPCXw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc2-smb3-client-fixes
X-PR-Tracked-Commit-Id: 95d2b9f693ff2a1180a23d7d59acc0c4e72f4c41
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8560697b23dc2f405cb463af2b17256a9888129d
Message-Id: <174503343822.382492.14831471178986691172.pr-tracker-bot@kernel.org>
Date: Sat, 19 Apr 2025 03:30:38 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Kuniyuki Iwashima <kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 18 Apr 2025 21:57:17 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8560697b23dc2f405cb463af2b17256a9888129d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
