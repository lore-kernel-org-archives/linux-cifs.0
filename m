Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA17DDA0
	for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 17:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f8BvU2cj"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94B81C433C8;
	Sun, 26 Nov 2023 17:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701018979;
	bh=8qwCMrGr6c2uYi/MHjPT0Z/qLAZNLU2bIMQyUuo966A=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=f8BvU2cjhPcjXD+GMMWS3VXfUT31i9uzeCYkKfAZhHA6XPTTMGovCLZJgYa8LC8OG
	 zUnAA6yY6ZU4OdHABYVdrRI4CBin757dC0abHvKJjtim1nEmNuw9jO7ej9Mk4go5mb
	 Pki2LulGmSn9hW6mIG/hDuo34SoOxnN8oJKgI5LVY15OeKudS7HRuQSmKHEK9BoHq3
	 bHbAJhqi6G3EzJMHzSbinomoh9ZIfvdByOuVXE2Pz77wprRihIhAsvdnl3I5G+sUGM
	 O7nbVA2KRZDZqvP2NxEopIMyQ8nfAwlsMs5cU9SfkQnmevjYTKjb0ee8s3d0ybg/91
	 7PMa8QcaWww9w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 82D8DEAA958;
	Sun, 26 Nov 2023 17:16:19 +0000 (UTC)
Subject: Re: [GIT PULL] smb3/cifs client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtFbhGETfqO=qE185xWY+82Yv2AF3BoOH5TLa8_TnY35A@mail.gmail.com>
References: <CAH2r5mtFbhGETfqO=qE185xWY+82Yv2AF3BoOH5TLa8_TnY35A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtFbhGETfqO=qE185xWY+82Yv2AF3BoOH5TLa8_TnY35A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.7-rc2-smb3-client-fixes
X-PR-Tracked-Commit-Id: b0348e459c836abdb0f4b967e006d15c77cf1c87
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4515866db1346d0b3d7c53214c60ff5373e39bb7
Message-Id: <170101897952.23229.15045361391381087966.pr-tracker-bot@kernel.org>
Date: Sun, 26 Nov 2023 17:16:19 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 25 Nov 2023 23:25:59 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.7-rc2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4515866db1346d0b3d7c53214c60ff5373e39bb7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
