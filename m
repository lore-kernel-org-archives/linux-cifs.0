Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE451BF54;
	Sat, 13 Jul 2024 20:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720901196; cv=none; b=XsfhhFHbOdAjfiVLHmY5e+pZXvrOh6tWZgbd27k7EzvkWFSa60Tz7LTVmZNfsA9AuqvFDobyv6XWXyJcOkgvK5iIYuhJ9cyDVHgkeRm6Zu7qbenhfRFxz4PZm+HVZo9CiS12ghCVEgI/PqrnOPyn8rDsJ6HwzS50KTlB0T3vDyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720901196; c=relaxed/simple;
	bh=Mcq3RA7WokZr1xc2/lkMJ1vTzQiNMnKB9bMdD6l984o=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=dLQ45FfFM1Erjv2BNNQmGSNc3VSl9SpKuDhGD/bdyj2HlyphtBB6+MsR/6ldp802lLwYsRga+yJPubW9oBtKwjRby5QCqCWOhJrj08ajESuM7p+TR0KKOqiJdr+cVhU7PhMo5i3aiEqhoa+zbuFEDCHNy/4cpf2WEGG2D6HN22c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kMn0ra6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kMn0ra6f"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 242AEC32781;
	Sat, 13 Jul 2024 20:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720901196;
	bh=Mcq3RA7WokZr1xc2/lkMJ1vTzQiNMnKB9bMdD6l984o=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kMn0ra6fQDW9wjxzIy2DOo7ahE3hXsJ/n+Lfx73azGd6fYCGYnrJP+Iv/cClPdJ1X
	 BtbKkMH/ur0z60Pzr9x1bFRjmhvhRI4snnq9vNkOLEBpObXGhyCu6Y7Ov3nSLsKnZ7
	 uFLZmEgjaupuoNn6gPBHxOXoLKA6w4tBAIOsrdihvFEjKAuHLTvZHOYbPKyiy1Tbp7
	 EEeYRhRKOQ1UfiUv1AUCAxCyn7spTJynu71kmynv2zaXm8InWbbA4HvhthXVcik5bB
	 fUrWf2oBFWWuQgDy5JxLSL0hpMHfXs4oA3o5P3NIjrhg4PWsNklQXJU7TzqPc7DOb3
	 o5javxZCBgjvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15683C43468;
	Sat, 13 Jul 2024 20:06:36 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms7Q3p_-wPDttT+XCX9a8GvDmC5EdbV_SguK_iriWE_qA@mail.gmail.com>
References: <CAH2r5ms7Q3p_-wPDttT+XCX9a8GvDmC5EdbV_SguK_iriWE_qA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms7Q3p_-wPDttT+XCX9a8GvDmC5EdbV_SguK_iriWE_qA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc7-smb3-client-fix
X-PR-Tracked-Commit-Id: d2346e2836318a227057ed41061114cbebee5d2a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d0d0cd38005518533d641e1344537f89cfe95203
Message-Id: <172090119607.18567.11027341496178265690.pr-tracker-bot@kernel.org>
Date: Sat, 13 Jul 2024 20:06:36 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 13 Jul 2024 13:53:39 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc7-smb3-client-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d0d0cd38005518533d641e1344537f89cfe95203

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
