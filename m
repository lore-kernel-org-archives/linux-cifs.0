Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB736352933;
	Thu, 13 Nov 2025 13:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763039121; cv=none; b=UhygX6py4CtVUpng5Pp86fh35Tp5b0YgEyW/awqRF+tGLyqj//R6qvDK75OHsx34oY2BwESuuSnPu1Nysa6qzrWJ2z6WzaXi6GTSH7b6ij2u+fp2cNY0CMqVsOXHASdM20rC8TA+BSfRzIvsLkxY+GYhDuKvLrBb7BZSirTOQFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763039121; c=relaxed/simple;
	bh=b6AVM/55YOIU7sxAY+20XYw1+V/P2RtbaE0tvYN9zSY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=HJIALovDKHbLkws4tIarN7WrMo0gkR4rTdMrjEvQoAPefYdbkI3/5zi5nxq+42g4M+qklbVgvQDkyptQdzLmz4y7/z0yKfWJDXzc9/0IyJCQHuUHa/Q3y7XhjSimQfeVIH4UjLlTAWS/+7tazo39ySoK+zFWtTQVqSA4XftxYvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lwH8UZ+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lwH8UZ+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B83C4CEF5;
	Thu, 13 Nov 2025 13:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763039121;
	bh=b6AVM/55YOIU7sxAY+20XYw1+V/P2RtbaE0tvYN9zSY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lwH8UZ+Z2AdqyxxsrlaPR4CTxc2AZcT/NxnM5pfQo7QMp25gKXpX1cOR6ewgHfl6q
	 YH3wU9poy30i39JS7hWzZ/FNvLD9MPBsXyUOdM3QVmfASkoaIruWhHsfEIQ1rOeLhj
	 N0Hzl0e+CTwLNomfOHFbigHGOqcNyxIQfUKjULWl5WJFAJPngAbwPu3i7PVOv1OXbi
	 23/MN5jmoxf3uki5T1jo+S8+2oFrYzumK/N03pYSAeQgb7vpb3VsYc9vvT68kZ2i1x
	 iwOlzizZm/0/QZshhRH+/ueyusFst2ghWyvfhjBX5uS29gOyW321n/DTQ2VfLYHWB1
	 rx+M63p5thlYw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33FD73A41034;
	Thu, 13 Nov 2025 13:04:52 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt03Ds=Fcbn59XO+9Vy6SVpeQ4DvcUzu-gA4-=gw5A2nw@mail.gmail.com>
References: <CAH2r5mt03Ds=Fcbn59XO+9Vy6SVpeQ4DvcUzu-gA4-=gw5A2nw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt03Ds=Fcbn59XO+9Vy6SVpeQ4DvcUzu-gA4-=gw5A2nw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.18-rc5-smb-server-fixes
X-PR-Tracked-Commit-Id: 55286b1e1bf4ce55f61ad2816d4ff8a7861a8cbb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 967a72fa7f6b77eb9f65c7365487662a4d04dbe4
Message-Id: <176303909079.842124.2716335830497466078.pr-tracker-bot@kernel.org>
Date: Thu, 13 Nov 2025 13:04:50 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, "Stefan (metze) Metzmacher" <metze@samba.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 12 Nov 2025 22:39:33 -0600:

> git://git.samba.org/ksmbd.git tags/v6.18-rc5-smb-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/967a72fa7f6b77eb9f65c7365487662a4d04dbe4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
