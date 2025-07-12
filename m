Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24FA28DEF9;
	Sat, 12 Jul 2025 18:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752344102; cv=none; b=trn8HYRMDc2OGSEsgjVJ/P2yn81hT+W9A790ycUY+Ggtz+1brClJ0GKaUMKsSwUkwtNBUEXEQqbFKhAmCcPIOZ5Yl0RLlrG23y7WGsjY8fD+GgBc99lsdTYptASEWuZaqrO0FMy03CJT1Vc2hmeROO1wkj+m3AECSR27enxiCAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752344102; c=relaxed/simple;
	bh=egDcbf57dEKvG3c6oq0Igd27xsa71dlhLzuggU6pcDU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=cizrNbfKAqIDmc0kaPGx14nrmwB+/fAFoBiSvRrRkDKQE3oZj4u5Bqpou/vgl5gzUOXj69maAsYpAOueSPv6vsCxRGeTzqWfRuVlzBBHWZ2zhYxz17u4n8wtUlcyaG34fFqu/9x3TdTASb7R4SxaDVBJxf63/QobPdaH9WNWD3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jP0MfRdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jP0MfRdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C5DC4CEEF;
	Sat, 12 Jul 2025 18:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752344102;
	bh=egDcbf57dEKvG3c6oq0Igd27xsa71dlhLzuggU6pcDU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=jP0MfRdAHtOmQ9k8uBBVjQzlOqpC6fJ3lXRX/nz7i+PZ8w6eBWwxDA4I6B1yWoar6
	 2vF51BG6jUozs3D7kgoQEYqGePTY5yy9p6Ovffz2BY+38orTyYGHMfLg513IAIeQSy
	 f0t9/IW5s1sVuRb5KSALolWmMlhUPp0WSVHv4kcLufjv8rH63GoY2YTRO2+84VmPnn
	 cJq2KczChoJ/LkhLjjFlo5f9JV0U9e/1MbTDSdQDgtomDvdgWMbuXTlmUOORQjTzHn
	 1QPyXcdhcQuQJYOjgdFwM0j02y+m/swYP+TLz+4ffw+09IQklonerSHk4Wu2p15YLO
	 s/mutXrT3xy/g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70C7E383B276;
	Sat, 12 Jul 2025 18:15:25 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvKVofnEbFwtqAMcA=R6Q3Prp9hzqzBPEoAdyvJGgL06Q@mail.gmail.com>
References: <CAH2r5mvKVofnEbFwtqAMcA=R6Q3Prp9hzqzBPEoAdyvJGgL06Q@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvKVofnEbFwtqAMcA=R6Q3Prp9hzqzBPEoAdyvJGgL06Q@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.16-rc5-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 50f930db22365738d9387c974416f38a06e8057e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2632d81f5a02b65e6131cd57ba092bd321446e91
Message-Id: <175234412400.2616006.8098294838324972766.pr-tracker-bot@kernel.org>
Date: Sat, 12 Jul 2025 18:15:24 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 11 Jul 2025 08:21:27 -0500:

> git://git.samba.org/ksmbd.git tags/v6.16-rc5-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2632d81f5a02b65e6131cd57ba092bd321446e91

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
