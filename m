Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA032F3607;
	Fri, 31 Oct 2025 16:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761928738; cv=none; b=nVizprHrxA1TAH9OFuSDBX6BYDVRhxQ+c5wQ4Ynf2uJ96KKADoeziLNNA79mMCFNKm84+cqBIMsMEdeg9fk+PgI9VSrShAcVHm2hNVm/To53/FC3WcN1nrdwU+cmAG/ylxftw+ODLkDSYUscxiqMiPfqgs83VjI+nKAaNcZBLQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761928738; c=relaxed/simple;
	bh=KewkcVOAexcMMOs0qZlAN3o6q6LFwWisPCsEaUniVwE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=pWrYBTMwV7rMU5cM0N7hHnXrYkodAreNmNejanDb3hO1j7fKFYoiZw57lEeeDWjE2o8figYhs+3YY0x/tbSNpV+8Wg2uF4yrd2wMfY/W6Fniv6wBpHF8NqXrS8e1hgagIJYrbv7pta9cGJ835eVy60amOY3tnTXWmmkECHDWv88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FCUm2c/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FCUm2c/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529D7C4CEE7;
	Fri, 31 Oct 2025 16:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761928738;
	bh=KewkcVOAexcMMOs0qZlAN3o6q6LFwWisPCsEaUniVwE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=FCUm2c/7Gxe5ApaxsfgFM7YcNdxYC0vA2QkLBNslEBwLD7V0cSu2LinEt7aaCSy+l
	 2oJOPythdt3MtQL+1awvNIlEnyt3lZBr0JwZkt9wdy5imQB9GWa6M2lKrzdLWtlIoV
	 V12qE1Mz3wZh9jRW/AUqNQEryi3J8MkcpJykN+IsiX0wm33wb1RGn6lejbrosxx+Ht
	 ttCWnzVisFZLKVac0PeXOT8+OPAF2lxFArEhKx5HWE0XhEvUwoloF24be7NX02FnWS
	 6WIPjYMEw4yfTHcvmms1sWS2dV90uDj0zYxZDIT+JcOZdGDtWh/ureyPTbakrsFSTw
	 Na8tnkwkAU4XA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE04B3A8256F;
	Fri, 31 Oct 2025 16:38:35 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvmJJAp1AX2Sda3ungmu7hcaYje2NYS6YtngC4F67PHeA@mail.gmail.com>
References: <CAH2r5mvmJJAp1AX2Sda3ungmu7hcaYje2NYS6YtngC4F67PHeA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvmJJAp1AX2Sda3ungmu7hcaYje2NYS6YtngC4F67PHeA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.18-rc3-smb-client-fixes
X-PR-Tracked-Commit-Id: 895ad6f7083b0c9f1902b23b84136298a492cbeb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b909d77359b82821e1c6b6a3a8a51b355b06fdb5
Message-Id: <176192871431.563067.17743927112121105727.pr-tracker-bot@kernel.org>
Date: Fri, 31 Oct 2025 16:38:34 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 31 Oct 2025 11:13:15 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.18-rc3-smb-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b909d77359b82821e1c6b6a3a8a51b355b06fdb5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
