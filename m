Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF831C5D77;
	Thu,  4 Dec 2025 04:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764823838; cv=none; b=oAZMT5Vp6MP9bKTdmRoxvUX8CGmpXZ45i/8N8Q6GuHmZ+hTdE5PtZesrNa1bTcJ6UnW+u3L1Ip0VArTyFcXkJsw9B5LtXwWfGAaCW3BNSB9ozN0QzPaz2RaKejBSc/SdeWR13MpPTpq8SPreoBwPuYxvfrvnTBGdQ4SwyJXtlxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764823838; c=relaxed/simple;
	bh=X8KSCurJv7dSi2EYFD1LLgDTa6u2Hrt3B/eBLVAefWM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=lwpDAYl9hOwJJUVPPvL+dbL0Q1Ytp2cCNdMQWpVlns9HOMvd0blpGZwYXWRzgU+JTd6WEb+yEYhFBsCXp5HKIkjO7IovtlQz4Djm3Ijl7iwHDjmutPqWYNE+5e64LBC7KCS5XTqIG8oFA7uNi+1o7oE1TF7OysotbI1FO/+hY4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/P/50IA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/P/50IA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367CBC113D0;
	Thu,  4 Dec 2025 04:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764823838;
	bh=X8KSCurJv7dSi2EYFD1LLgDTa6u2Hrt3B/eBLVAefWM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=A/P/50IANgUuqBl0LM69zdB2GzP8aOdhcfryOp+GKJIK/f1jWthGFj1GVKqmWPSOg
	 nrcHEyZxZuh7SdufX4VZcmrXohuC2o2K6QFeDp0p5xIzypE32/5TNpLkAN2uMCrP4C
	 ZoLVj4heJd4MR4DKsOvosEPqP38BeBi4coCyxl/7GRpsO/oRrifetgX1HYJYPULb3E
	 jvKOmUGkGsvmWEN9QA1O4MPVruX5Caik3hizHq5crFaaX0my2lmfHy5PeLhnN3EkPH
	 d+q67CntwKhGihF/5rlcUwolrjFA2nNPrD87GQsOiCNl/Dc+MsnDgA6AzluskaDh+F
	 EKyY2guQ5H+aA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F3B633AA9A8A;
	Thu,  4 Dec 2025 04:47:37 +0000 (UTC)
Subject: Re: [GIT PULL] smb client and server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtHWXNvtYB0mTUci0qa-b0dmOjUMr7sARERV9SyFpTAVA@mail.gmail.com>
References: <CAH2r5mtHWXNvtYB0mTUci0qa-b0dmOjUMr7sARERV9SyFpTAVA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtHWXNvtYB0mTUci0qa-b0dmOjUMr7sARERV9SyFpTAVA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.19-rc-smb-fixes
X-PR-Tracked-Commit-Id: e1469f56089fc00bc94706a07c5cd63fa3e8625b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 869737543b39a145809c41a7253c6ee777e22729
Message-Id: <176482365657.238370.18009456389242673547.pr-tracker-bot@kernel.org>
Date: Thu, 04 Dec 2025 04:47:36 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 1 Dec 2025 19:06:25 -0600:

> git://git.samba.org/ksmbd.git tags/v6.19-rc-smb-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/869737543b39a145809c41a7253c6ee777e22729

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
