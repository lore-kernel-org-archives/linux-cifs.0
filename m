Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F70274670;
	Fri, 31 Jul 2026 00:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785458723; cv=none; b=N8ECPz1PkL1+dsncFjjQOyjo50HLdIFiArBVlGG/XwnajaJ5HSxuoPdgsqWRIyIVscyiwYQkdnNOpIrBxI561EGqDx0DjbGeJuC0Trorc1LDEIkPN8a0nDeTuGNjT9+ajo+v7rREjc1mhxqflLws+omW+XjeorkP7u6gAAj7cPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785458723; c=relaxed/simple;
	bh=WvRwGk290xf+hl9E25MmHpqGSI2QjRBFkvuGVUdjEQY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=nengdg9/Hmu7apqDI4yDdFxtpmJgcCXwWaoxWwnbxDDdXKz4ovRmgIyCz0oSAdS/iyhLWGy5pIrfE0aObXBk4xl7snAICc8jV+t2j5EzgBxIbLJbS6TcG422D/O9e0CNvGFCfqGmK2Tct+m+qS380atizH2lmvot6wUjxchVPLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gLkMcXD4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gLkMcXD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D91D1F000E9;
	Fri, 31 Jul 2026 00:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785458721;
	bh=27jbGYSZ8kkZjwUw8Cfbcgby5WsGkQ1tyfZXvkp/pvY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=gLkMcXD4CkvI4+Eq07RDVH7KXg4PDcgldg9rELBtJwHCxNW9jM/N5a5XUhRBiUBEh
	 zvp399tmGH6M+WlCxd0lOynDfOAW8paJY5r6saR4ho0T1Vfeg2elFm2NTimUiZFm5q
	 2B/0CvbWmtaAeS5w0O5TxBVK0YLMo2WyK1GqYI4mfcmXLFpyZ7O6XEhauf1xw1BfpK
	 0ttYj5qNdqHPPZ8cW7u33lObWvQiJPmh5+UwR4buQ+sss6znGQHEyPCy9DJeff8+FQ
	 bomjGXJ+FX87LdI3VwSuPjdNOqwZltoCkHSuudI3RTtgZ9oS1FQJPzfmX97OLyPkP3
	 n5YrcnMyU+ZrQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19D443924472;
	Fri, 31 Jul 2026 00:44:46 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms9nKwhH4uv0C0wKvmcu4F3AoPzvmGw8Xqr_pk2U9bUfg@mail.gmail.com>
References: <CAH2r5ms9nKwhH4uv0C0wKvmcu4F3AoPzvmGw8Xqr_pk2U9bUfg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms9nKwhH4uv0C0wKvmcu4F3AoPzvmGw8Xqr_pk2U9bUfg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc5-smb3-client-fixes
X-PR-Tracked-Commit-Id: fa724e235cfdb0fb0bb427d0f9dfe864ae27403e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8ba098e6b6ff0db8edf28528d1552be261af30d4
Message-Id: <178545868470.61505.11173355244228176246.pr-tracker-bot@kernel.org>
Date: Fri, 31 Jul 2026 00:44:44 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 30 Jul 2026 18:11:34 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc5-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8ba098e6b6ff0db8edf28528d1552be261af30d4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
