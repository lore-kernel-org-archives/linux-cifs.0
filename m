Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD533909A4;
	Sat,  1 Aug 2026 00:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785545881; cv=none; b=r85uBzDiT44ECyGDHmJX76YLQNT8ASfWOLR7zXyERRItFZVzfEdpSa8WHPOz7hEUY8Bp7ktrFD3/po0IEKOPRqFkZL7w5Kro9K9XunnIWVwpblRVcZmqxnaCuqOplU7sugxLFLJwNh95j4T0aQ+Q6OVsRIwTEC1Y5szOQmY0fY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785545881; c=relaxed/simple;
	bh=ggLhIuEYVInO2aUEhzbzlrCq2DUewkxtpPoX7TwlylE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=st4Qh++HlGLLJR+tR6BIrMxwJAzmkCbze9/ME7+v6NkrcAfOTZfjWbGsAcdXn7i9pdsai1zLXmyWuSUejJjwOy8bhEm8y+HJl+9Xc40Ec7Bf8/wt0StzzF+TnX7gvxwoihsBqepKgoSEk/43lMllE7/IML0BQocTI0HodM3+Cc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LjSQ01SW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LjSQ01SW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B921F00AC4;
	Sat,  1 Aug 2026 00:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785545880;
	bh=4dUTzbPpO2D0ivl2pczX27wmtXMxjoWucyhGLPmLioo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=LjSQ01SWhD1ZXaZwnVj6UM/cPVgjJnX7qHfrwyl/RKYtqMdt1urznC9kmTA0FGheF
	 piQZIhUbtabW8GIWUO1FFUPjVQ8LteQetpLeksRId+5LYTx5yFLnrWAYLZAemf6q/i
	 MmPpOw56lPsA89TGTqjrfkMUj8J75TPBDZ72HPofbVJPX73y8FKsSwfi6TpD8oCJNM
	 EXC7ZdqANyX2RiU/9FRucRda27N0N8JaOSIfSsRbR5dH/mTEN21QNkhy2KyEQaG4yl
	 1leuYZ36FqcYYsKVvgQkuciF35ajj8K2uYNU2Lr1F+8ORYjANeX7hdg0bT9Meteuwi
	 E6DAJoYOuiP8Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5695C392665F;
	Sat,  1 Aug 2026 00:57:24 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms7t38Yx5ryMJtMSH28Neh+sKQPL0vmW_3hHROVYmqehQ@mail.gmail.com>
References: <CAH2r5ms7t38Yx5ryMJtMSH28Neh+sKQPL0vmW_3hHROVYmqehQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms7t38Yx5ryMJtMSH28Neh+sKQPL0vmW_3hHROVYmqehQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.2-rc5-smb3-server-fixes
X-PR-Tracked-Commit-Id: e8bb506e6ef749ac0336f3e579d8d02396b7d832
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bc29fe1c617883f65da693be6abde0335d85f24c
Message-Id: <178554584291.970149.10745096133208917166.pr-tracker-bot@kernel.org>
Date: Sat, 01 Aug 2026 00:57:22 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 31 Jul 2026 19:29:21 -0500:

> git://git.samba.org/ksmbd.git tags/v7.2-rc5-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bc29fe1c617883f65da693be6abde0335d85f24c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
