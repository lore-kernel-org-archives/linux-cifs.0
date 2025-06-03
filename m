Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD1F17A30A;
	Tue,  3 Jun 2025 23:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748992877; cv=none; b=Fd8Oxvb/1iHZGISSLiYOhj9J1ZlnWd7ammsMr0JKIuEKEyaNWDZUhvG4A25vCWfnUYGlBjad2SNUCzOPE7bK/326z1jjQIoAwD7CehMLmIKFLesyNfvdXkOZtWEe/terQeywp3qcTlaOfmKvVl9eeiuqeqWeI0mt9q7c6TLxB9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748992877; c=relaxed/simple;
	bh=bFG5b1AMa/2P9t68S10S8ansVI+Q8NxdN/Hbdj7MEg4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=BKntP1++uHu1Wb/l/9QpzfyqZln7gRDoNKjUReu4yfH/5vodiYWM0QCAFdiIifWF3FR2u1L7lvNNc4l5Z0WJi1XoqnlHF17Oazgp+55UXw7eLMWPEU/SP3zz4PiOQ14ViioA4A2b9EBwviNu4xmL8yWder96Ya88RuoXwwlXCbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rKmuiKIB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rKmuiKIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F6FC4CEEF;
	Tue,  3 Jun 2025 23:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748992877;
	bh=bFG5b1AMa/2P9t68S10S8ansVI+Q8NxdN/Hbdj7MEg4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=rKmuiKIBf7/xGO60kiMHp9ACaEehISsblaSjMWPzltpAsbs/OXQCh02bsTU7yiECt
	 4IHApdz+H4zwmD4M28YNCoCPvd3snL7cHS3unK992DaDNzw1HebmnnZKo1hlTgU+k+
	 WywJFEQ/PQZOhgxRZF/iD0ENJdlC6RECji/OsSKpPeBN3SjnVM/UhTzEJVss0mB8JA
	 CNtnHr7wQ3h7j1fKEQTXCrjHFMKYeaA50UuvzHJAruMSRJ4EFItEgeTck8t8O0TiAs
	 +OaTR5AEXnoTAAh/Z+Fod0Pl5CkrH2RENKXvWkR7jneU4wtXE0BKXIb+Brfm4CMP/R
	 hp6Y5DpjDVPTA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 359A0380DBEE;
	Tue,  3 Jun 2025 23:21:51 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt-jcxLBK96EiF_w_QtOM1-2DHH4QAYKhikWSOkD1t-mA@mail.gmail.com>
References: <CAH2r5mt-jcxLBK96EiF_w_QtOM1-2DHH4QAYKhikWSOkD1t-mA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt-jcxLBK96EiF_w_QtOM1-2DHH4QAYKhikWSOkD1t-mA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc-part1-smb-client-fixes
X-PR-Tracked-Commit-Id: 8a5ebd2be99a1f4630d0382f7fdf581561d317cd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6d9b5f6b81ace1b2b0830271ad46628d6fad31bb
Message-Id: <174899290991.1704306.18338155974798122543.pr-tracker-bot@kernel.org>
Date: Tue, 03 Jun 2025 23:21:49 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 3 Jun 2025 10:36:55 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc-part1-smb-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6d9b5f6b81ace1b2b0830271ad46628d6fad31bb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
