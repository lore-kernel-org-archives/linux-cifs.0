Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42551D88D0;
	Sun,  8 Jun 2025 18:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749408781; cv=none; b=axg5JRVZRoFww8/8ALzBbs3cdmUg7oa2zdNc3RJevzAoepfwEHwl/ixdQWa/4+Cq8bqDfxQ1zjhS9k1FriW691le3EvaruYfnit097PsK2ipvn2ME/0/he5aG51OMeFh1iwEyjG9+ptVOUMsWiFHXH8j1FRc01DFwqrH1b7hzBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749408781; c=relaxed/simple;
	bh=mOpAWN0iLGQckafJr4AEBQ2DUtwfAF0jbnunGgeNxeU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=YJ7jaao+DuBFvKO9dwYUwz+I7A8zxLnjxu6WmnGrv/9jUE4cVocZPX25tMQHIzbrwKxGGOuZBPFIkBqMc7krdQI2SwzdAqkIoi/Z6Pic5TkKxYnVetCnSbBKQA2qpmN0R2JuLVH4YDYUzV/2uzFaIQvMi+5RcqG+n6N4QMuWK6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HIIOtkzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HIIOtkzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9BDC4CEEE;
	Sun,  8 Jun 2025 18:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749408781;
	bh=mOpAWN0iLGQckafJr4AEBQ2DUtwfAF0jbnunGgeNxeU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=HIIOtkzQttdWiBVtmyOFTmRYv/2YTlDeOTjEAYG8n2nxxMEKxCTO9eVwb+476Ljx1
	 T7lgW4h294DtlMjzcdxMFtpKZln9A/uSUgTyJp31DToVv+uQJo8ljG+rib4CWGz6eV
	 foL8qZuCHpw4dAGdil0PjvmuK/ptaJa5JuGv17Oin5AdTLb6THGHVYfCQsn009ZsdC
	 w1eH0iQrZm14Gg9dHNydvOiGGeFtj//GzkqIiwoKqMYdHoY66GDT2dPGjNQiolkGYW
	 s97YUvZlzunUyYxPh8K8aFWXo/FKK9M/un4VS59cudZgHB7cAUpUtvyFUC9p87nQT+
	 HeucmNlNXxS5g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAD9E380AAE2;
	Sun,  8 Jun 2025 18:53:33 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muDjjJVcngtDHa87ZWKGD_uZPV7KVO=Fg7g57-OyudMxQ@mail.gmail.com>
References: <CAH2r5muDjjJVcngtDHa87ZWKGD_uZPV7KVO=Fg7g57-OyudMxQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muDjjJVcngtDHa87ZWKGD_uZPV7KVO=Fg7g57-OyudMxQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.16-rc-part2-smb3-client-fixes
X-PR-Tracked-Commit-Id: 8e9d6efccdd728fb1193e4faada45dff03773608
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 522cd6acd250dea76afaabc52e028fef280fd753
Message-Id: <174940881253.385950.74710184731026347.pr-tracker-bot@kernel.org>
Date: Sun, 08 Jun 2025 18:53:32 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 7 Jun 2025 20:03:12 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.16-rc-part2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/522cd6acd250dea76afaabc52e028fef280fd753

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
