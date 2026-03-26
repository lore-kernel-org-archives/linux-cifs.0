Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5AE3AF65A;
	Thu, 26 Mar 2026 21:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774559562; cv=none; b=Dv7AQiv3dH4ulSgb7//mckhUXmwN+Du+Im5qKFKhYup57+Zz4MjppLpEAZcNR/WWdXZZiA3tge2wC0BIE3gtvk5fJLcqKdb1j8OPllqSHgHH42JFZH8IlAkWfqnYniD8RRcM7l/O7jmJOmHcgsUeRnQ8+oOSaGQ2Krzfhk8MTJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774559562; c=relaxed/simple;
	bh=Z1K8PlEbWf/C+0L4j++38zWcPpdc8bKtq8S2NiCKTqY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Y1xgDfgJ/DGRkooxwtjEzR1XO5PR/TbEz5VgpSFuqetJteZ7J270BbdGqZ9HjIlTfjjR3jI2xN33MoqQlj44/3FrP7jf2xPb10BCqCKmS3A2rmzlYySXW0vHS0TknVrQEf0s0bd2OPz/fUIlgrjw8umqg3rylveBKKTkaADc7aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RhxhaKhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RhxhaKhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678ABC2BCB1;
	Thu, 26 Mar 2026 21:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774559562;
	bh=Z1K8PlEbWf/C+0L4j++38zWcPpdc8bKtq8S2NiCKTqY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=RhxhaKhFXNpQvxcOousqmcGYnhiISsWzMCjKwMJkwdK1K6ZrXn2wh2Fupa10lrYiY
	 iv5ydy0feSoWb8bSkzWCz4Jm57lR95t9eZ2d3RXgRqdVmC6rNb+fCOCEnAOtV6USGt
	 XlW5EzOghmOUoPHnG5i4F9wf20FEuLJEsshKvRv8/mQ7Q9uTibSynxDSjCZ2GDACv8
	 jJ6G82Sore4j2/+ZUbIyiMqDYvOCYqQrI47Pw7cSfGwDZAsJW5WdkFIuKynMs5MLQj
	 dOyUqa35i3FUT7SwRVVlXYQDx/rOuzNoch7qHW8Y81DM7CwA5LW/b97SyJvIhqiFE0
	 zo7i1ZR9X0VNA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02F7539F280C;
	Thu, 26 Mar 2026 21:12:30 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muw=UrEBvucGa8OrT_3tE4zXpGKO+d9mU7unmbTw=C=CQ@mail.gmail.com>
References: <CAH2r5muw=UrEBvucGa8OrT_3tE4zXpGKO+d9mU7unmbTw=C=CQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muw=UrEBvucGa8OrT_3tE4zXpGKO+d9mU7unmbTw=C=CQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc5-smb3-client-fix
X-PR-Tracked-Commit-Id: 34420cb92dbb9e37ff6c6603f4f5e1807db3f1de
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 46b513250491a7bfc97d98791dbe6a10bcc8129d
Message-Id: <177455954862.3179012.4489411617641171591.pr-tracker-bot@kernel.org>
Date: Thu, 26 Mar 2026 21:12:28 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 26 Mar 2026 15:59:06 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc5-smb3-client-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/46b513250491a7bfc97d98791dbe6a10bcc8129d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
