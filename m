Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556CB1DF975;
	Thu, 22 May 2025 19:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747943005; cv=none; b=FMrffTY9Km0G/wyMjUKtaqdU93II17fGrLv4UOg4I9X+XdbV8zFq/OI58Y22ELBczbNNDjLmo3PvTuSSHG6hhybB8vSPlhFzhZy4/tVOlCtlorJI+SSchNanV4yE0zA/vfKbzB1vl+HUB9Eop11DOglJOFKYtvBvjK4hmE45CH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747943005; c=relaxed/simple;
	bh=8IudL4hGWVD1khQJexukEFpHMqBqEpJK/Eq4PRG3uwY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=F7p5B3Ki/WmhfWp8/SOnmd/bPTwGEruFPMm1Sjf92w/0rZmzUqvIMgJi3fHnbtfyFgXJ9YGmsPuB3bCRpfzK5xcLzQ9csBd0Az+XOLkxly6/BaA9RdfbtWnSfZsGaWmlEsJqumAmY2m07UPM2EQUdLNSDSQnIG1rE1zzit3iXkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2a9WfJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2a9WfJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9076C4CEE4;
	Thu, 22 May 2025 19:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747943004;
	bh=8IudL4hGWVD1khQJexukEFpHMqBqEpJK/Eq4PRG3uwY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=d2a9WfJf2ZWsS2PqINJYELgFqrAphx+/uxoNUyzxqotVu4ANdk/1lj7D6WOxzk7b9
	 Dezqh6A/kd+HqGv8M38tjnS5YF2Cp/YmRp9MGZxp0K9Vn9NxVOrzwt8egXaGhHFiF6
	 GjIv4V43jg5Xdu8ubhIwHa6cWuSszZfCwKmVR4Mj5rDdCrA2jlxdkHJQLPt4zCsHKI
	 WxwJdpyCMqxaHuJawrD9HCtqyRpRnlArpD8J+9xU32rGpbt+14ElnlxuB4JXFR1j5r
	 /1Yy0VJGkfkbwC6pYoNx8zG2y7qGF2bRJVJRZgr4CphcejStsV1sCz1a8e7EC8RGzG
	 5GNDVWRoN8Umg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 779403805D89;
	Thu, 22 May 2025 19:44:01 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvC+E8L719+MGf1C+mj0One1kn=VZbSAiF2mGCqgPvqYQ@mail.gmail.com>
References: <CAH2r5mvC+E8L719+MGf1C+mj0One1kn=VZbSAiF2mGCqgPvqYQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvC+E8L719+MGf1C+mj0One1kn=VZbSAiF2mGCqgPvqYQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc8-smb3-client-fixes
X-PR-Tracked-Commit-Id: e48f9d849bfdec276eebf782a84fd4dfbe1c14c0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e85dea591fbf900330c796579314bfb7cc399d31
Message-Id: <174794304025.2998623.6831008393741467322.pr-tracker-bot@kernel.org>
Date: Thu, 22 May 2025 19:44:00 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 22 May 2025 13:42:47 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc8-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e85dea591fbf900330c796579314bfb7cc399d31

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
