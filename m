Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D542F1791F4;
	Sat, 28 Dec 2024 19:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735413362; cv=none; b=AnI7HoA/3Vv2TQ8pZpFNSg+AecJEyGI2yafPoCP1rtPVYGvTuFaxD1+HF20AcofF/5XX7M4x+9+TCJZn3JygnqLJ4BE4xo+n4IqIKRPpDk0MHYByeZ/TSDIrqFkqV+ImEIOqwZyzK/89cXmDF9KqsTxjPVuGyazrxkIr5H/czkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735413362; c=relaxed/simple;
	bh=KmBNacDbDnJdbgGYgenuylE0+ZBjiG18Qwlk5CikwO0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jvNA0DppbcKodrwEgombLlwBUG67J+s6lJEXCbBeDfXMUct3+VWsC80kFsXjBNobo7VOmMM0x2LuDSv48JOTUaqExFRNnq7GxApvSakMqS5iPArgnLF8H3sBsPdPWccE7EbecWjdmzihAwO0bBbhndyVGgNVQg4EXnbHZCnSi8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uY3eJaUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uY3eJaUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550EDC4CECD;
	Sat, 28 Dec 2024 19:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735413361;
	bh=KmBNacDbDnJdbgGYgenuylE0+ZBjiG18Qwlk5CikwO0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=uY3eJaUif1rvyPn7PvYDMMnkDBMGsTiPuy6Fu8qoyld1AXVkbKPWt291ULQD+2X12
	 /+M4enD6zwHRiUYDO1gtu6CCDyWv7hQ+vys26Z4Z2BhmFGEOcGk8gs+s7+Ctu/zl6E
	 MmcuhRuBVayOwieg0h6qLPd9uHNcYFVljXkTmT6+9mQc7zVBduyBjurYAF2hImLoee
	 FVSWfkuPfKQ8l7ZoFL1RWAoXg0RSA8WoboSPu8QCFoecNqau7GFuaKM7b4I61d8cZD
	 HQ9K8CQrfD3cCNoV+QhvpXgJZgo2q9JU0sMwytY4eEFIneVdAfFunF94b5O/exI+G4
	 P9rd9vq+RKHIQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB16C3805DB2;
	Sat, 28 Dec 2024 19:16:21 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mu+CPAAMHz9oFyzwr7O=cQ6pQa05+8_NDZ=3FwNh8bmSA@mail.gmail.com>
References: <CAH2r5mu+CPAAMHz9oFyzwr7O=cQ6pQa05+8_NDZ=3FwNh8bmSA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mu+CPAAMHz9oFyzwr7O=cQ6pQa05+8_NDZ=3FwNh8bmSA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc4-SMB3-client-fixes
X-PR-Tracked-Commit-Id: f17224c2a7bdc11a17c96d9d8cb2d829f54d40bb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e51da4a2324e595af54a0cb3b4c35eed87548de4
Message-Id: <173541338064.748444.17337789525145182762.pr-tracker-bot@kernel.org>
Date: Sat, 28 Dec 2024 19:16:20 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 27 Dec 2024 20:42:14 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc4-SMB3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e51da4a2324e595af54a0cb3b4c35eed87548de4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
