Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63E619EEB4;
	Thu, 19 Dec 2024 17:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734627799; cv=none; b=oRbgUL1kHkhCwsSr7UB3EuQpnHd0wuQ2KSUPXdoZaEvlZqNM45MHsg481e3goYU4WAmL/NSqgXHeFHevH5j6IE4NdvYHh6QRX+/cy4RdyP+TaP1xPc0SlF+nl7vvKhOMctE9ZC+pCrf5qVXNBdruS28UynwiDitZLMnxDNRRLH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734627799; c=relaxed/simple;
	bh=zgAdfmFD8lINgqFzGU8Zrd6atG5xBFN28cpA7woERpU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=RO9Y3bbJDY0r6WWz4g9rPRcdXoazsVoU1SO85sL8FrfT/7pVk+A8q2gkflJGE9RLPGDyvYGtPIrqyOAz3L/kVtWzx7ZxKygserDQ+Na4m90nh0ZeLqmX1Eao4/m6x7X4yenIe5qSyx9Rgm0I90R5zqvzRUOlxr6ht6M/ADUDH0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kYLjpomb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYLjpomb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E7EC4CECE;
	Thu, 19 Dec 2024 17:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734627798;
	bh=zgAdfmFD8lINgqFzGU8Zrd6atG5xBFN28cpA7woERpU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kYLjpombScnJwqv83EulZkdcJs6ar/xb7VWgSvSxT/KHBrqd7oPg/g0m9hkgTfSwe
	 m3TQyH+qpXzTOk1eJ/Yke/NF7dQpGHRY9Zt92Tlj/bz6M/YmQWoZI2AaCNlVFGUZfu
	 V0suNjOcEt7lbHua1gw9RMdk474blbiVPO35A9jMuBcvAauATbWJSxu5ifOMrTtruS
	 +rXaFxhIOADuScAvtrh0hrKV1PH3pYEsrbrNhgb6Vr37xqWBbSL6Nb8uezl4TBMk5Y
	 NYld6jHxcIcaQtp7SoAzcANmOzo2mgtb7Fw1zL/0i0vIYaupb9HzoalXuEULEsJ22R
	 8FBqqpswn5vdQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADED63806656;
	Thu, 19 Dec 2024 17:03:37 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msORKXoRLDHnu8H62W7ryRf2AdV4b-4R_3w=ep2g+yzsg@mail.gmail.com>
References: <CAH2r5msORKXoRLDHnu8H62W7ryRf2AdV4b-4R_3w=ep2g+yzsg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msORKXoRLDHnu8H62W7ryRf2AdV4b-4R_3w=ep2g+yzsg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.13-rc3-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: fe4ed2f09b492e3507615a053814daa8fafdecb1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 466b2d40f60ce874cb9b56dc88bd1a0880a43786
Message-Id: <173462781630.2314669.8440604095424887757.pr-tracker-bot@kernel.org>
Date: Thu, 19 Dec 2024 17:03:36 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 18 Dec 2024 17:40:56 -0600:

> git://git.samba.org/ksmbd.git tags/v6.13-rc3-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/466b2d40f60ce874cb9b56dc88bd1a0880a43786

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
