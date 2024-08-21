Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939E426281;
	Wed, 21 Aug 2024 02:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724206044; cv=none; b=ZSGkcGya6ot0ryg/b7zFyNZykc4nxnpum3IGw3Cn/1lQjrJe3Ve3hTeryguOionp/mM6LEmq0UNlCy7DBgzj5JQ87h2/YuMR4YXBOOZgLMMqN3Ws7gQhnoWs0PloBgvZmo00QZUKCmyCi4OslUZZUhW3TGQBPU88D1lmdtom12E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724206044; c=relaxed/simple;
	bh=PmeA4K00ekSbxX1pdT4CNBbAUbRmUUnTezkqaBXaGDM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=L7YlrG6SA034iwEzOZk1CmFIfv9OWH0n1uTQ3PSj3kjCZng81lYfL88nGmQcTUxnzQJCoUPRHazaPDADkD/ouwrbPsZSE0tFN0ZkZgQx+kmpUYGmDdCZVeGitzpmPNb49dOHAfJVQ5r7QQ5ESo5K7SWO9UpXUuAVm/udgZ0ewV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AjtLVDNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AjtLVDNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4FFC4AF12;
	Wed, 21 Aug 2024 02:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724206044;
	bh=PmeA4K00ekSbxX1pdT4CNBbAUbRmUUnTezkqaBXaGDM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=AjtLVDNuUzUxXd6NCeeQaPigyO5wo59UNKj8G80Z3mJQH/LXnPsSUClmoxyAymZVB
	 kZ6NeItcjcXAZMyHBx6h0ITUS17xgQu51p3o+2nq5CT46ZgzY+RRGS3YWWxjtnBUJ6
	 aCE+Gqc0EKljemG9FZwfr7nF26cFlAD8+0uXPgStRWWExCK2s4lTXIJR3IZrr13pDn
	 CWadODHl5fkOicWawhzZEn9XQ6AII7A2lu7TrItZW/CrJVrh5XiENmiF4NI+PYtWGN
	 Gk7rlRRKQZKjCiX5mR/uzLgvFGab3zIILmHX+PbGMVS+JFXYlDHjCZXVGvwXxII+MD
	 rH11fLLZ1x5qA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33F643804CB6;
	Wed, 21 Aug 2024 02:07:25 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muR=S_6jx7KtLofSSY9T3depX6yXNqK7PX3LDiNvZW0hw@mail.gmail.com>
References: <CAH2r5muR=S_6jx7KtLofSSY9T3depX6yXNqK7PX3LDiNvZW0hw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muR=S_6jx7KtLofSSY9T3depX6yXNqK7PX3LDiNvZW0hw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.11-rc4-server-fixes
X-PR-Tracked-Commit-Id: 7c525dddbee71880e654ad44f3917787a4f6042c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b311c1b497e51a628aa89e7cb954481e5f9dced2
Message-Id: <172420604366.1297481.17479959976409498902.pr-tracker-bot@kernel.org>
Date: Wed, 21 Aug 2024 02:07:23 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 20 Aug 2024 18:53:57 -0500:

> git://git.samba.org/ksmbd.git tags/6.11-rc4-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b311c1b497e51a628aa89e7cb954481e5f9dced2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
