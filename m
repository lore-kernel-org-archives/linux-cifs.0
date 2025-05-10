Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8740133F6;
	Sat, 10 May 2025 04:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746850274; cv=none; b=Y1djTxmKf/t/iWxrQu+bkxEH7qZI2buJJw3N/Zt6vUHpOpUq+mIHqsec4LT4CT8V8r1FU0Wl3zFhcJYs4VlmqlG9C1rjlz5pCKAphmFc1zJp7HX34fiteJNuDwq3WW2LrFPi+2mH7SOMPAi4A++5nz10N3Kfo73VdZwXe/uPTnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746850274; c=relaxed/simple;
	bh=yigxBPyjABeEtPPpHkuA5KDTUTnASdcAJ1gPSs5+dE8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=u/bx2pFc3jR6ahJq3/5Mdb7PGgbXlCT41cSCrwarimjUoBbqoD7k70ocF+ZwNuHXTP/CZtPOJ+9dy/N6BZt8+5d5lDmOUKdfzFkp3mTSfDjRq7v+QS9YY4xzL1UFM0GhhYcUldZrRC6sZQJ/wqz5mqDEHrsCe/UW84XSCTEY4Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PcQvzjn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PcQvzjn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D806C4CEE2;
	Sat, 10 May 2025 04:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746850274;
	bh=yigxBPyjABeEtPPpHkuA5KDTUTnASdcAJ1gPSs5+dE8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=PcQvzjn6RJoOs1AigCqb+gpiGnRLbNiXUedMmeIdZYIoiNZmU5H5I4PYE7dJWGJBy
	 uPLXyluimNyF5tJrIfOxQqUP7ViQKMY3cSaRrpZahejcR3UHzdBDzvOdZsOOX5rUR/
	 SDMCWFucy6YhFLTeG4mjIoCcKnAWva1B+/6OKoweDeZeEdrMWa/hM2z1imQJDR2r+H
	 iabEfYkDB5cHbRi9GC8cT0Aao4xuV20z1WDFiw8ZWzadVW+9d22aY5/d5DraCu6BdI
	 iaHS6M6h92CtfPsYJPQorR+lqk85dyapNrF7TE/5mNkka51ndDsBzsbUy4drVJ0QPa
	 Z5bqLbiaQQY9g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAEE63822D42;
	Sat, 10 May 2025 04:11:53 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 cilent fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtRj=+xk4bt74j=pzbOF8=BxJNp2L3nr_VzvtZY5tLW0g@mail.gmail.com>
References: <CAH2r5mtRj=+xk4bt74j=pzbOF8=BxJNp2L3nr_VzvtZY5tLW0g@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtRj=+xk4bt74j=pzbOF8=BxJNp2L3nr_VzvtZY5tLW0g@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc5-smb3-client-fixes
X-PR-Tracked-Commit-Id: 3ca02e63edccb78ef3659bebc68579c7224a6ca2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1a33418a69cc801d48c59d7d803af5c9cd291be2
Message-Id: <174685031250.3889839.16286078530861390741.pr-tracker-bot@kernel.org>
Date: Sat, 10 May 2025 04:11:52 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 9 May 2025 16:38:38 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc5-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1a33418a69cc801d48c59d7d803af5c9cd291be2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
