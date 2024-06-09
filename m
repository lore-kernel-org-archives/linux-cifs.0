Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B7FBE4F;
	Sun,  9 Jun 2024 02:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717899525; cv=none; b=cnCTc+xoC7Ft8jdZLPA7koo+ze8tJHhl1n4IhMUigjd93CO3P8RN06u8hUC1vbkLGPkv9hG+s09WzZwz8/5Gn/Nq+yYUg6FAd08JvG+5TEQeJVtZPapn3Z3po2WtYsJiJLyDZ8wgjoPRxpX8HQjQezYBO6mRHCO7DaMlIs+KcbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717899525; c=relaxed/simple;
	bh=Bea9mPR6xlcQ6bWD9g/zEvks4GD58AbFFNx5iRXVeNg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=R32YhJ77lQDPplRylIkRi1cksPufhRhwFXL8HWcVmmJhFLHYgxl+erSYA8sDRrOdqav0VuBRGfr7F+eqWiLx8VSzMFoSSSUOiWRoEauo60RZhudgz2Nfqo0bC288YpmUVEnbC07kSqg58BwsL+br5+0Tl9BKuzneWufJ2r5L5VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hwQpDL+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hwQpDL+2"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3580C2BD11;
	Sun,  9 Jun 2024 02:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717899524;
	bh=Bea9mPR6xlcQ6bWD9g/zEvks4GD58AbFFNx5iRXVeNg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hwQpDL+2743YEgPmV2U3q1tsaMYjskBGz1YmD0juSpZvFuemv8UcPpE+SWnLuJE18
	 xJltrx/3BiEZS/I+YH4y7tQWBZBKru1PTpcFQtX4J/JAg/GWnYlcKddSyFrAlIADBg
	 ESpfRTV+H3RmgH+egxOTosv8Vab9cfFEVX5GUhuS1xH1VgqkwaDYmjuMvZrMajxByI
	 7BonguLFmpr1NATn45uJhADHvaddhiVg/qAosKPg7sDitgjYzNsG1hmYciPdgmBaJM
	 wIX2+dSjllkv35NCVfgaHzJc3j0dzSlVakVGcX9KG2leNo/WxxrnEZn/Jie60dnrDW
	 3K3Fj9jgv0OKA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9C97CF3BA4;
	Sun,  9 Jun 2024 02:18:44 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muOwzD0cy_mZ5ydJfQLpmY4MYpKqYsHgAB1Z+qs6Gknmg@mail.gmail.com>
References: <CAH2r5muOwzD0cy_mZ5ydJfQLpmY4MYpKqYsHgAB1Z+qs6Gknmg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muOwzD0cy_mZ5ydJfQLpmY4MYpKqYsHgAB1Z+qs6Gknmg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc2-smb3-client-fixes
X-PR-Tracked-Commit-Id: a88d60903696c01de577558080ec4fc738a70475
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c5dbc2ed0006d1a910b5496202a280138ce596e4
Message-Id: <171789952488.28801.9387865286608951069.pr-tracker-bot@kernel.org>
Date: Sun, 09 Jun 2024 02:18:44 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 8 Jun 2024 18:41:12 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c5dbc2ed0006d1a910b5496202a280138ce596e4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
