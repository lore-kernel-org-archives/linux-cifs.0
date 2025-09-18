Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B662582;
	Thu, 18 Sep 2025 03:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758166698; cv=none; b=Y+F1WQsj7YGG3xIBMrrM4QuopbMCf3PXqQHkDUYOTvx6fbChAIBUK1d7GCqBHCbr8yI10ARuFgTkho0mwqUsn2NCDN8uhZBzu55aiI0duEqiTPrt1QwWfQ5CsibGY5kOilV9L3MKE3xLk6V2oYcuH72cKB62K5/o8nebHYawxNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758166698; c=relaxed/simple;
	bh=9zlp7HPPoTfiEyUqnJ1aM49b7XicO+GZ1rBQUGKxoGc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=M9RgjVp8YriEhI2tVORSpH7hLi/puMVpKCIA52Tp7EanClaOBy7PErFdWz1okigwBqindETJtUkaB8An1Gs6r20WbffEHt2yv6H7ILgCKTQ0TMRZXkcZNWB8wjl9DJXQ8eqfhBiaeL7JXDseHVEjV+pmEC37O7tw+y/Rgbw9zP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ez6AdStu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ez6AdStu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EEEC4CEE7;
	Thu, 18 Sep 2025 03:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758166697;
	bh=9zlp7HPPoTfiEyUqnJ1aM49b7XicO+GZ1rBQUGKxoGc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Ez6AdStu5nBpZwd7W4163cNGnuEZsTLewXuLmoocC1znZsRpgk9sz+w20iAJM++ok
	 1lByfAbQfw3pfjpGSdeL7SgExx9Bas6vZJn0p2LbXwwVEs+mlYgCMwi+vH1AEZTjq/
	 rM8QGF0lXS9wGGA5pkrBKZgGSZ1ja+mKz3wBjih5Qjw917VWmHz2DEr9a64/0bXI6R
	 fVj+moWqiPDZdy/T75CS0E3UpEAF6qwlNr93CeKE0QB5kdqb8nwX8SmTvkdSgDX/w7
	 j2hWcEaf2bLB74SD+HYj8ePikiAW1/KBN7fzMKBiRlYp2fHw67f7gid5ZOCtCTtzuP
	 eEQyG/ehhjGTQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7166B39D0C28;
	Thu, 18 Sep 2025 03:38:19 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mveqnRsJ4Fi8pQjTY2WrtDbys1f3JPR+OR=w-eskUoiyw@mail.gmail.com>
References: <CAH2r5mveqnRsJ4Fi8pQjTY2WrtDbys1f3JPR+OR=w-eskUoiyw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mveqnRsJ4Fi8pQjTY2WrtDbys1f3JPR+OR=w-eskUoiyw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.17-rc6-ksmbd-fixes
X-PR-Tracked-Commit-Id: e1868ba37fd27c6a68e31565402b154beaa65df0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 592a93fea16bd86a605a1b4ce9aed16e22d124d2
Message-Id: <175816669794.2244756.15215190037383884573.pr-tracker-bot@kernel.org>
Date: Thu, 18 Sep 2025 03:38:17 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, "Stefan (metze) Metzmacher" <metze@samba.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 17 Sep 2025 19:24:31 -0500:

> git://git.samba.org/ksmbd.git tags/6.17-rc6-ksmbd-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/592a93fea16bd86a605a1b4ce9aed16e22d124d2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
