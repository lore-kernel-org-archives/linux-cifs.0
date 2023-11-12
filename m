Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B5B136D
	for <linux-cifs@vger.kernel.org>; Sun, 12 Nov 2023 01:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZnCzHa28"
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD6C4C433C7;
	Sun, 12 Nov 2023 01:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699752622;
	bh=7yXv8lSfiz8Pmtplrl947hP8L2j7U0Ljh1zCJ/+tCo8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ZnCzHa28sJnGN2x9v2UxUWD//Jq8tkFt7mTWRCGFHEtovcMIaC25IQiPeg33dvCgB
	 sJ0OgGxKidUDP3+CFYQItz34CbhjOfs/VGg73xf1pzPs5vtqcYeu6GJij37vnuGhEG
	 erG+M/172VGsAV9zBrOx+rtmGKpCdEKW/kmzFbm57TRIJZZE7or8e9C3m8nUHmF2cT
	 RhUJmbOGjj9lRoxMnwZ0kuEmnBvpwsH7UM6k4T9pvdJX9kFLqZarYLHL0UcNlD/jjH
	 3UQARomKBSksNHuE8CdY+rGeW0Gbq34WoWdGJON+jbWrM7N2LnI9dVA2tDSSWyvYzU
	 p/ee8HVfqpOtw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E6EEC3274D;
	Sun, 12 Nov 2023 01:30:22 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muWrqOdEDUhmYHgX2Pr0yWSMrFLPms+4pqwrZaMr4i7Og@mail.gmail.com>
References: <CAH2r5muWrqOdEDUhmYHgX2Pr0yWSMrFLPms+4pqwrZaMr4i7Og@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muWrqOdEDUhmYHgX2Pr0yWSMrFLPms+4pqwrZaMr4i7Og@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.7-rc-smb3-client-fixes-part2
X-PR-Tracked-Commit-Id: fd2bd7c0539e28f267a84da8d68f9378511b50a7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1b907d0507354b74a4f2c286380cd6059af79248
Message-Id: <169975262251.20343.3324446234541471652.pr-tracker-bot@kernel.org>
Date: Sun, 12 Nov 2023 01:30:22 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 11 Nov 2023 16:21:28 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.7-rc-smb3-client-fixes-part2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1b907d0507354b74a4f2c286380cd6059af79248

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
