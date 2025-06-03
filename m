Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30131CAA4;
	Tue,  3 Jun 2025 23:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748992877; cv=none; b=LE1t2XOuQ1LczuH439pdZUr6giX4T5sax1iZgFjQt19m1iWP6MhGWU8vyRWnyDYS3+kza9dNVe0pYQcjGslyXk/cQuZ6Ie0Y1BS+MQfGDiOmBKVOXeVcjL/wudlEoOTAGSGrM8sz1pdEdbJ0K8/0u3WwVgAuFCquJOjJhn+527Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748992877; c=relaxed/simple;
	bh=bFG5b1AMa/2P9t68S10S8ansVI+Q8NxdN/Hbdj7MEg4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=rPHixttW9O0vPG4lDgrHD3zkPJnfdO3xI45kQ1uzo3kP34kdJrjwaDOwjc4avi3s3AhIbzGCIuG79V/ge149G9KcHbBaQCrgfDAKM79IU/4z1gL3lsDgt8/d+sPU9Uoiq+nzm4T1UNbcut0l9qNtZM1MvSES8oqkG+YKIRP2Bgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f5yrBzvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f5yrBzvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F36C4CEED;
	Tue,  3 Jun 2025 23:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748992877;
	bh=bFG5b1AMa/2P9t68S10S8ansVI+Q8NxdN/Hbdj7MEg4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=f5yrBzvdBZ2wnuamQuYLpQju8cI5gdBu/YCO76MrCqaMY1goSmvDx4mCdf7befH6H
	 pOcffD+gFJ9mqU4QbZUxG9AucW1tEBx9synScVM8PL8YYx/NOccD6aFDqe0TZi8twZ
	 Z3HkmFTUBKqsexad6QfYlJvMyScJNbR/XX2GiQq5kOpgeRqd1pOge8EbrMrGSFCoJl
	 ne/ZdSGmGII3VyaWdfah3NLB/cwweS0wAyksZ8TKnzkYceRlAACWgZR0V4Ip9Dc+2h
	 tXNuj5TD+Qfolhd8ulRPnJ4meizFid4X2GJfjDWAFeMamLWcTAEks/kkKYwgjL/wM5
	 IFFwcThxI51hg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33C87380DBEC;
	Tue,  3 Jun 2025 23:21:51 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt-jcxLBK96EiF_w_QtOM1-2DHH4QAYKhikWSOkD1t-mA@mail.gmail.com>
References: <CAH2r5mt-jcxLBK96EiF_w_QtOM1-2DHH4QAYKhikWSOkD1t-mA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt-jcxLBK96EiF_w_QtOM1-2DHH4QAYKhikWSOkD1t-mA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc-part1-smb-client-fixes
X-PR-Tracked-Commit-Id: 8a5ebd2be99a1f4630d0382f7fdf581561d317cd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6d9b5f6b81ace1b2b0830271ad46628d6fad31bb
Message-Id: <174899291048.1701538.15350807995643547916.pr-tracker-bot@kernel.org>
Date: Tue, 03 Jun 2025 23:21:50 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 3 Jun 2025 10:36:55 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc-part1-smb-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6d9b5f6b81ace1b2b0830271ad46628d6fad31bb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
