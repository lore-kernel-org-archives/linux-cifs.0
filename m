Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B612142AA6;
	Sat, 28 Jun 2025 03:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751082830; cv=none; b=YJcMJ+yE+BAoUxJjYNNEM1YaNdq4tOCi8gWXDqiiCb65ax83wddnHqG5rTJhXRBQnPlA7x6pQUY1BqYaDLLzDIgrD587GqRKgk1wxl7ypZkIWFB1bvX//gvtReLfGqYeyvUwLbLx1r7byvTdSRnCJcRhY3zlJDZ2OmaAGebQPWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751082830; c=relaxed/simple;
	bh=R8DBgXSYVmnE/2qNcMDNEWDxiBZAD06vdY6tyHSYaGI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=brMbZwAZOCAZrYCP0Cy2ZGApW7CWW5+eD7VZX0QZ/DE1GJZrBv1sNyM3S/Jr15MJyuYL9ustN45tt1+78Z5WVmYEBhD17geAy0are507czCe2TD5x2sLi6mgTaMpm2Fc6+GhS1VOucNinv6cWyfIMvZ/y+fFjmSekyAlktfvyfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mHuyWM5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mHuyWM5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513D0C4CEEA;
	Sat, 28 Jun 2025 03:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751082830;
	bh=R8DBgXSYVmnE/2qNcMDNEWDxiBZAD06vdY6tyHSYaGI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=mHuyWM5+k0K3DX7YZsFV2JjTT0LHtMM+WpOX120a46DeVpAH+jMtdw5DoYLdqYXJW
	 tv4BiGnOsBWElVipy60c3eJVSeUvy329XE0D1sEXD3E3Rbmn9AY5Uz4/8BeyAkuK0K
	 3ezgN2hQzwfcGeiboT1tPAfuBGAHlCtwtgLY/IT88ILB9ZY8WNawE58/H4f/76Pk1l
	 xRbcJrIyR0JKiMn3Rn8q6eDkHaNOzBpTkFClYbGWjKhktqeRK1B0SlN3uoLiMw46ss
	 0h8v58Vp9V1+vCN8JnMlbMiLKleQGwlO+nqmZSx25D8+uprjUUD5lPbU/Qyv6MhAbH
	 xWnsLgfhWkPmw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70D2D38111CE;
	Sat, 28 Jun 2025 03:54:17 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muAE5KvodJSk9VuFOF1fAHWPdnG3NsSgOZONqge06k65g@mail.gmail.com>
References: <CAH2r5muAE5KvodJSk9VuFOF1fAHWPdnG3NsSgOZONqge06k65g@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muAE5KvodJSk9VuFOF1fAHWPdnG3NsSgOZONqge06k65g@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc3-smb3-client-fixes
X-PR-Tracked-Commit-Id: 263debecb4aa7cec0a86487e6f409814f6194a21
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: aaf724ed69264719550ec4f194d3ab17b886af9a
Message-Id: <175108285614.2130122.13154392429987223620.pr-tracker-bot@kernel.org>
Date: Sat, 28 Jun 2025 03:54:16 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 27 Jun 2025 18:19:17 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc3-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/aaf724ed69264719550ec4f194d3ab17b886af9a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
