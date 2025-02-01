Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78DB1D47AF;
	Sat,  1 Feb 2025 20:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738440505; cv=none; b=svK91WqihOa208C8HSMQWnX3wAkxZ4uqoF3BEF7tuBy1xvnNmR/ZQ2rLoNsJUb4xJnVAQRpGw4Ql6tGPCrRqeh1+zGLzzjRG8yp9f2PGKcaArFKsAIIF47kMsQ32cBR8OI0qwuCmmeVg0ePvMiFM/3FLP9SlRYv0Qllw8Ahp/uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738440505; c=relaxed/simple;
	bh=pXeLBNUmh6njv4ljnzn08HznTVfIl3ifNKrju6pm8QA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=lpkrOQ22gb+pLUIAO+bn2F3oMqpQ01sMTJzBp+z7u7BlOC/SIgAx29inyRefDeJ3F0+VK0PXOnsg1g0csmst8gWcwaYKFTSgkYsYqQGWWM8JzwLGSNuEyyztA0myju/otTeAQisCAoXycz0VCi7zCwpjXVtXW/m7OFbspmOWR4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d+XJVgha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d+XJVgha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452F2C4CED3;
	Sat,  1 Feb 2025 20:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738440505;
	bh=pXeLBNUmh6njv4ljnzn08HznTVfIl3ifNKrju6pm8QA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=d+XJVghapDS8mh62goqnfpKNiUvCxEAr4AASNwaHDb03LTh2/o2Jm4JSQcp3iuAqc
	 QNgko39uUuOS4Gkd1d4m+ZHh6eowSpE1THpRPzN/A7MAaJlxFDZHFiwpir7OlLzYfN
	 LQ1Jgzd4vNo2pRKSf1+mwti9pvMx8T9d+5kdQuxUD+9qmpz76EK7NSuh8Ed1Qe+UpP
	 Y9mMjQ3Q175uR/HI6SJTvet10UKNpevOIkd5jiAKXtTUOGv6ajXfGYR/u1UqqJGT39
	 12aIxzgBDjaoYhQHOGEFk4Nm5ApuN/6osAn05Xp7HUL6CFzW8gynK4QnKsvO0B7ZBs
	 pBiv8h91Hd34Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D3F380AA68;
	Sat,  1 Feb 2025 20:08:53 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mv0fCe9F3YnMT-4_hc4DPGgSp+nu7detzz8K1X-bwj9mA@mail.gmail.com>
References: <CAH2r5mv0fCe9F3YnMT-4_hc4DPGgSp+nu7detzz8K1X-bwj9mA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mv0fCe9F3YnMT-4_hc4DPGgSp+nu7detzz8K1X-bwj9mA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc-smb3-client-fixes-part2
X-PR-Tracked-Commit-Id: a49da4ef4b94345554923cdba1127a2d2a73d1e6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cabb4685d57ed50cd197498d2ac946ad5b6272e7
Message-Id: <173844053182.1982916.16525469986734713537.pr-tracker-bot@kernel.org>
Date: Sat, 01 Feb 2025 20:08:51 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 1 Feb 2025 13:03:42 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc-smb3-client-fixes-part2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cabb4685d57ed50cd197498d2ac946ad5b6272e7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
