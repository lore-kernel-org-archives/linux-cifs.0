Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA718BEE;
	Sat, 17 May 2025 02:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747450166; cv=none; b=reJsBFDzDPKeJ1CQ89Dga2y+U09jo4a3FkA+uBlT5BneNY9PveXG/XT3RkoablWpv15Ur0FuPKWUIuBfrIprVCvvPUI3chdK2DaeEOHdoYcJbfFPUny8wF0cON0f4mhMUIvMSRh8OXX5Z0v6KHj2Zf95ixAqvi4KBlrtenmmKiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747450166; c=relaxed/simple;
	bh=qZ+e7NtafRD4DxC4O8d6QLrUaUgkutAubws1I1PpxPg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=XwY9xbc5jv+ewT9yeaEnuMbSjpwZgAHscY9/v5EdN5kLueRW0cG/aNaX9Y14hA61c2eGBaCiqh4FGXHQTieP2VN/ZCGx7RCnB79PgL1R0jefv+kwxFbWC5BKypS95H9ykxyCGb8OZ/ILdCitQmfjykWZfDHrfG5b8g9oz+ZwW5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CCcVX6TA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CCcVX6TA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8E0C4CEE4;
	Sat, 17 May 2025 02:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747450166;
	bh=qZ+e7NtafRD4DxC4O8d6QLrUaUgkutAubws1I1PpxPg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=CCcVX6TAXh5ojTK/omxqvA+zb0zUGdB8pGhWwc7L7aEVeUgYwTVqXuuGrXn+Oxqsr
	 auMllS336jRXN6d1h+2TTvUnielnOa+OljJtW4M0YxivpBtPdXT+CGyZLVf/u/CCZM
	 XF1KXUaC8aSwvCoWSNSWlXg9//a1AGVOurjgnrVPvKimwGjpgQMdhNncp5Yuvs85T+
	 pJx+9SNLFbIYoEsWallgrqrfC3l8oIEFBlwTW3sxci1iz5bwu/A76hFz6Xovxs24Wo
	 CeWdmyKIfEtz4WxV9skrD8dHu1uLL0/8vLqOy1JJWQfp84eAcsDGdfA9gnQskCBSDF
	 Ofciv2cCggTBg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 341BE380AAFB;
	Sat, 17 May 2025 02:50:04 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mu7-vNnVE+1fdESnV4kJ-sr3gV4YnAQJ==BuXve2QOjpQ@mail.gmail.com>
References: <CAH2r5mu7-vNnVE+1fdESnV4kJ-sr3gV4YnAQJ==BuXve2QOjpQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mu7-vNnVE+1fdESnV4kJ-sr3gV4YnAQJ==BuXve2QOjpQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc6-smb3-client-fixes
X-PR-Tracked-Commit-Id: 3965c23773e81c476f6de30ccc5d201c59ff9714
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 172a9d94339cea832d89630b89d314e41d622bd8
Message-Id: <174745020310.4160808.16600487116843074086.pr-tracker-bot@kernel.org>
Date: Sat, 17 May 2025 02:50:03 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 16 May 2025 18:42:19 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc6-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/172a9d94339cea832d89630b89d314e41d622bd8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
