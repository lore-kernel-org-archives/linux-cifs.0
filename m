Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E8F17D2;
	Sun, 26 May 2024 05:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716702061; cv=none; b=plGpeAuii2OJSskPK+wbok8+OAx+njAOFx5gcXUh2z0cRn5kG4jh/+a5mZP0Mu37TeohE9h+/35eVSJyut4v29rko/ntcNotjJieeUyllsoWVmVJd70+NKwuG98ahIuKCeE7HqRnvyGAzS+Xg4JKOEKlqpdzVq9q2lxqgAWJbYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716702061; c=relaxed/simple;
	bh=FkJIjbl0J6+JXdvEMWUMH/OFDQT7a+m9aHvTE2SmaNw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sSNK+i46wTehg+YoxR/frdrBfmqvn7PCYonYpwKwvodXY+p77p7l0RiyXtJCe2Ko764djCWoIiCHHkx5WbSvK88zTsPjtiV86AUB32gnOVRP9RtHTQo5okW1RDrK+M9HNFOYuMx/MrGchoIs64XsJMzEehWNUOH9EEM7m98ebmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MdZCXCA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MdZCXCA0"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90A73C2BD10;
	Sun, 26 May 2024 05:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716702060;
	bh=FkJIjbl0J6+JXdvEMWUMH/OFDQT7a+m9aHvTE2SmaNw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=MdZCXCA0AAP7i7XZuL5Jxl3GPKgDiUL3cxWztZQPl3B5aPM+bOdriCSJj8HSPJvWz
	 upleIIv+QFmUiPZFEl1LD1+2ieGvw8Jveh9/CkYQV1wW+5ua45Nz2ExdoHDZN1QZbq
	 D4lTGwJfRsQ2wShDZeDZHt51fACLhVniQXXlmGs+QeQB3KDwCdJ6Pb8nFUFdUB0V/E
	 ISrMl3NLXdejirkR1bQQkDs2Ge2bUExMKTC2i3HEgRVQsJBbNadUluOqH/Uq/UZCuY
	 MDVQpZ8+Sm2TBioYxBBNW5aDccqvdZfnZR+iJwA591NlkezTHmyZwa7tL9r0uZC/xp
	 y91fHxOz62h7A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84C75C43617;
	Sun, 26 May 2024 05:41:00 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muATaLWcsuYWw0x8pjKjJqBFNP20GdU63vBiVYhQvEVoQ@mail.gmail.com>
References: <CAH2r5muATaLWcsuYWw0x8pjKjJqBFNP20GdU63vBiVYhQvEVoQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muATaLWcsuYWw0x8pjKjJqBFNP20GdU63vBiVYhQvEVoQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc-smb3-fixes-part2
X-PR-Tracked-Commit-Id: 93a43155127fec0f8cc942d63b76668c2f8f69fa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c13320499ba0efd93174ef6462ae8a7a2933f6e7
Message-Id: <171670206053.1198.9357922561921054901.pr-tracker-bot@kernel.org>
Date: Sun, 26 May 2024 05:41:00 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, David Howells <dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 25 May 2024 17:24:42 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc-smb3-fixes-part2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c13320499ba0efd93174ef6462ae8a7a2933f6e7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
