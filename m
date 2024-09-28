Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3C545009;
	Sat, 28 Sep 2024 16:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727541911; cv=none; b=fIVWfEBm4hczIJK1npJ3M31CnBQaC6fKq/FFpae6DFIlefWC1KDsKl2/wz5Rgg7HJXSO0vWCVlX3aWxCfj5uhd5bGYrFPcqWh14CLnltqglSNpzRmxZOSM9G3rKMOtn3mDGQ05M2EJkde6+s5jqIJfxsuc6V4uoRiA980roSCKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727541911; c=relaxed/simple;
	bh=Yb9XSV0M2RgRB/jgiO4CWlBUOpV/P2NgF6iAGI74v1s=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=NRihZmw2GLvrxt82e//P7ZgQn/Qtr5aFVUCOfXcLspCrhHxpr3s8xn7/IPJqGkhUQMTPNJuEvdpBB3ByhufpZ9BdJKDUMevjockCjBJc5T4eqz7FikdohDyu1RXmbbC7tnBI2QilB5GcUM3XNB6CcrqxycWxd9AbuA5GmrOMbGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kqG/842F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kqG/842F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26F0C4CEC3;
	Sat, 28 Sep 2024 16:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727541910;
	bh=Yb9XSV0M2RgRB/jgiO4CWlBUOpV/P2NgF6iAGI74v1s=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kqG/842FYwf2CyGP+F9dUAZxMfKAJzz6l5/cDNUH3A/EJoiFdVXh+O6P+8criTdVb
	 X9U7sRSXMr/J2F9KTUyYiPTPsahAMUWw51IFmMqWCVgkuGrEUQ7dOXAQgXO9gh4XYp
	 iDzu0c8cwBEI4LbgrKdISu6Ju1aYTqko+rmgJyCc0tWzdsgmwTwhAEMnF2TWhxAgRx
	 3gNB838WnpMw08z0iUZeYV9e4FoEf40m4LTJrOsnmHdxA3517lZscpdrKd1+G6BvUt
	 8UTqOXY66AiaCFIfVbD+Qw81mPqzMcAWm7u4PCTcVef9CLAJ49r4jjCnMOPbQxq/gM
	 ppC/XkXbIv67Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADC203809A80;
	Sat, 28 Sep 2024 16:45:14 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvoGx=vCTUjHWzU2ywfvFrV5b5+GEvvL9PQDL=ydTzd7A@mail.gmail.com>
References: <CAH2r5mvoGx=vCTUjHWzU2ywfvFrV5b5+GEvvL9PQDL=ydTzd7A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvoGx=vCTUjHWzU2ywfvFrV5b5+GEvvL9PQDL=ydTzd7A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.12-rc-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 9e676e571d39eb6189bf6d55a9c401ba2dd13410
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9717d5343849beb4ccf96df7bbf347660fd8898d
Message-Id: <172754191335.2302262.17289729953018252026.pr-tracker-bot@kernel.org>
Date: Sat, 28 Sep 2024 16:45:13 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 27 Sep 2024 21:05:40 -0500:

> git://git.samba.org/ksmbd.git tags/v6.12-rc-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9717d5343849beb4ccf96df7bbf347660fd8898d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
