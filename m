Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D499233859B;
	Sat,  7 Mar 2026 04:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772858041; cv=none; b=LFBYaV8MTwP1Vu3N1KMJB+KYjsn57HV3As0k7kO9get7apogXEFB0l3ZsQakXH6C/4oot2cgx7tA+IQUWfpm5IZ+I29BOOIwIhAHeXo18QImxguifwxqjUP4seq+OqDO33GW5lcHM+S9UJIaATEBykYVBGiasy+ZkHwOc2Eu1xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772858041; c=relaxed/simple;
	bh=WPj0fMg1J5yesKEumS7maJo++bQOLKHuz8wUU/t7/fo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=thtAE68qQVjCYeem8141GvGIN/tZL8uHVjpXNdJhqyAjx98k7Kqbw5f3Pl12ucfnqh9eDX7XfiVL3BeFx2+h0saHiuYOrPSXKr0kJloM4RDg+ktqA7x9JWYCAtH72FQUZ+JEAUEqf5XRXt8gKWGVwX/UMUwQeaa3zmiiWhZEKiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=idASue+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="idASue+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808FCC19422;
	Sat,  7 Mar 2026 04:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772858041;
	bh=WPj0fMg1J5yesKEumS7maJo++bQOLKHuz8wUU/t7/fo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=idASue+GCYAL7u9qVts8PLzoBcViOx9bjfN68TMmCDVD886Q5TquPptTuA9ZULyTG
	 /04HF9+727lMJUVjiUmCMjkihLQgJea6hlOnwPm8/6Nk/9kPlqvEUWD1qE6Sm2uk1m
	 vCzoKIEqtuHtnGKgTVcUbwlh7gqqHeuGQAiwVNf3NZvXtR1kButNepIiBZWUXybakl
	 SKcOUOyUPC/dnEu/zPOleGHbJsKRc7RMb/yBu/ESM0i+VSoA+7DVPOBjs6uBIri3Rf
	 gMhLlB0pGptQ2NXxi/KuOrtyg0QqubviPx1glOJcDBRFdFJDkpycJ6XnPP4TyvEG7u
	 TbqYPE8+xIx6Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9F213808200;
	Sat,  7 Mar 2026 04:34:01 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mu0T+Gcea5YKaAA7L6FfM5OMjEKenih6Sgk2W4EXrSpWw@mail.gmail.com>
References: <CAH2r5mu0T+Gcea5YKaAA7L6FfM5OMjEKenih6Sgk2W4EXrSpWw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mu0T+Gcea5YKaAA7L6FfM5OMjEKenih6Sgk2W4EXrSpWw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git v7.0-rc2-smb3-client-fixes
X-PR-Tracked-Commit-Id: 048efe129a297256d3c2088cf8d79515ff5ec864
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e0c505cb764e73273b3ddce80b5944fa5b796bd9
Message-Id: <177285804030.165831.3550369925091047049.pr-tracker-bot@kernel.org>
Date: Sat, 07 Mar 2026 04:34:00 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 6 Mar 2026 16:03:46 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git v7.0-rc2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e0c505cb764e73273b3ddce80b5944fa5b796bd9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
