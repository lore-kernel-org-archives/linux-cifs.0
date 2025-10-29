Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBDD21A449;
	Wed, 29 Oct 2025 01:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761699805; cv=none; b=DL+KqaIuq/E7xXyjGcv7fMGTY4wgDwbSCGVeXm60Ns1M+LIlJKTKqs6NzY6dTP/YEqAztqdparF8GHsNxxMaVwG65gZCU+pbPZXtXhR/IiwIm6Jh9CESKimE6QiO7BRUmKQ6aNprtr0ZK2kIHjqW116tnkZwoFnJCwHZFSAI3X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761699805; c=relaxed/simple;
	bh=qTQRx045iGc5CZylB73JNiMYXhU/ZgVgoyPr8SeGb10=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=UgIdFajAMcGym1qQcugkdoCcMOKGiHFGOLVy1evihEgLKavw76Gt0AjksJSkFsp4VcUQdx4hm+ekYSeQYoKzhJXqq6Q9fsvcHANbg8pH1+b9PzpZ3SUxKVjmqeEsp9qb4ugN74cHqtct9c9qT2LchsDWX1lNLd8rfd/ldSNjwlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WYy72pa0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WYy72pa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06D2C4CEE7;
	Wed, 29 Oct 2025 01:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761699804;
	bh=qTQRx045iGc5CZylB73JNiMYXhU/ZgVgoyPr8SeGb10=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WYy72pa0RVZf7Xo5sxywZA61SxFqSnyl8Dc3eL77RSfpEK6Insx8qySOgUgyAESvX
	 tuK7ilH3oRJeVoS2wsX0cMFNjLCitjpOXwW47VIN7OawdplRdPqWH3aspEoOU4hUzF
	 VvsWOi83S87Q31W3fLavH/5gdMW6B71RjaU1dtg5DaGeWI+HJTd/EQgp7QzIWZxRuD
	 0B8dVAIpAVppgmUKBp599yPeuYx5yIxdDW30Br/DXzz9GJ9xoeHxKBtrhB5TATic/N
	 CgH63rpLXpT+rbpixZSrn/V/qKDEK0qOHuGnLxzOq/zl9WFTNpCTGUbjZROjJNyYbj
	 OfHIChaan+bxg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70EEB39FEB6D;
	Wed, 29 Oct 2025 01:03:03 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mu7ZOL06JftZt4forRyQy77+OYZQ0gWYn5Cs9Rvk62vjQ@mail.gmail.com>
References: <CAH2r5mu7ZOL06JftZt4forRyQy77+OYZQ0gWYn5Cs9Rvk62vjQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mu7ZOL06JftZt4forRyQy77+OYZQ0gWYn5Cs9Rvk62vjQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.18-rc3-smb-server-fixes
X-PR-Tracked-Commit-Id: f574069c5c55ebe642f899a01c8f127d845fd562
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e53642b87a4f4b03a8d7e5f8507fc3cd0c595ea6
Message-Id: <176169978214.2447535.11252590445564023047.pr-tracker-bot@kernel.org>
Date: Wed, 29 Oct 2025 01:03:02 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 28 Oct 2025 18:50:25 -0500:

> git://git.samba.org/ksmbd.git tags/v6.18-rc3-smb-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e53642b87a4f4b03a8d7e5f8507fc3cd0c595ea6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
