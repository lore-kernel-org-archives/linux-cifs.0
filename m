Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA921848
	for <linux-cifs@vger.kernel.org>; Tue, 28 Nov 2023 01:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ye+CPAJd"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67C51C433C8;
	Tue, 28 Nov 2023 01:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701134817;
	bh=tnxFaU5digXS9w+34jo2ANB8bDJ9CQjVLsvQcCUdALU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Ye+CPAJd/eZNY+l7e3I9kIoyyWZQXGZBtY/xNGnLyKiWzN64ev0+GBq5OCxRAufxC
	 axwLHYn9OMqZq+nezcLMZcXQfTW0uhkvgjCks0peXDJBeeXRWGhDEj0GaS8Pc2fG/u
	 DLk60fmTLn0/SpeNJpQL3qsexHsY5xDQPAwRnhyO3Z4QT9pvJveFFRiRJ3pyMJ0ZpY
	 FDeYFH84zAjLTfSWxZFouMwHwDSrlFUlv/Nv3ONe8s38q9Fo4HaZbzmy72I4JTtKyA
	 6vLQuZDzK2rfeC8MKFp7N0qe83tEYmytcSyZ7YeMRebP2Wdoa7IEk63gLaCLLvGB1h
	 qh0s8hkHOOLww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4D1DCE00092;
	Tue, 28 Nov 2023 01:26:57 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvMv=F2JpZNW=t03TY+1H7W+6eJtNDE+f838wsS+r8BfA@mail.gmail.com>
References: <CAH2r5mvMv=F2JpZNW=t03TY+1H7W+6eJtNDE+f838wsS+r8BfA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvMv=F2JpZNW=t03TY+1H7W+6eJtNDE+f838wsS+r8BfA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.7-rc3-smb3-server-fixes
X-PR-Tracked-Commit-Id: cd80ce7e68f1624ac29cd0a6b057789d1236641e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: df60cee26a2e3d937a319229e335cb3f9c1f16d2
Message-Id: <170113481731.2219.4184290566110950813.pr-tracker-bot@kernel.org>
Date: Tue, 28 Nov 2023 01:26:57 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 27 Nov 2023 15:00:59 -0600:

> git://git.samba.org/ksmbd.git tags/6.7-rc3-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/df60cee26a2e3d937a319229e335cb3f9c1f16d2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
