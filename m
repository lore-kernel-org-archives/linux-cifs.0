Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34337127B54;
	Sat, 25 May 2024 21:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716672736; cv=none; b=YhA7brmYje+xdhZMKcG7EwlmYta1cwY2kLM0e/HKpD1jfrTl+HMIlK1f3fN+e76jcxZ0Nyy2sYq3VyHt+a50czV8wczQvwZDScTATxIgQ6prUySxFPWfLk9Smx+l/vBy7sQaALz3ctZgM1rWrwuapdxYgdio7JrXjVtJw9eS7sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716672736; c=relaxed/simple;
	bh=cy6NSh4g3NucxCNSRzTFnc58GmiSUkyzMwm3F6HtjqE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ML+mTVFo45BpiqX1Re8EAqivTarDkKm6b1/ykYuUiYmeAj63k2gy8rmRMrnR4yfIQwTMWG2W8eyN0Vnz5Y7FjitNRcBGqrGnjkfj7U4MRQ0vxetr2W5SGFXu0L0P+Xm6EmOhA5jdCyTihYgPClAlv0e9ihpp9hYF8v/zAEwIODs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sL5G5uuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sL5G5uuk"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16DAAC2BD11;
	Sat, 25 May 2024 21:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716672736;
	bh=cy6NSh4g3NucxCNSRzTFnc58GmiSUkyzMwm3F6HtjqE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=sL5G5uukNCv1GUMnH1Ipx7MtXCiZ30KXcZG38TuTSJ2PwYAB3vcDhoWeRVDsFL5M4
	 ythlOC1jfLG/WLRphQV9LN0ZP4Enb/3e0DefWxC+ecZOhj98zZXmGWjqvTcYbYwsw6
	 fpNy8GO9UvTkX5lFZrLQa+FoxYHHwYEVtxf8UQwMj9WKlttRVr4LokZlHyd6sonANZ
	 Zn+Rs1hjW2vEFEu2U6gtVzgnUiNMuo1mSxntU1MOZZZIPWG4n0wcirjAVzgrYJacg+
	 wjT8+q/eqEGSaEwGu+RkH7iLMqcMjtVP1Y5nuzox1OxvuqGtERwfrgdBm3d+C6sipy
	 TI9j1XvY2PTug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0E8EFC433F2;
	Sat, 25 May 2024 21:32:16 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvL-bvRPsbj6qhNwguxu_7wtkfYOAN5vdizG26rfcMKKQ@mail.gmail.com>
References: <CAH2r5mvL-bvRPsbj6qhNwguxu_7wtkfYOAN5vdizG26rfcMKKQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvL-bvRPsbj6qhNwguxu_7wtkfYOAN5vdizG26rfcMKKQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.10-rc-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 405ee4097c4bc3e70556520aed5ba52a511c2266
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6c8b1a2dca0b98775f75a59ddf5f62b6c9512b75
Message-Id: <171667273605.25058.9735442066654427272.pr-tracker-bot@kernel.org>
Date: Sat, 25 May 2024 21:32:16 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 24 May 2024 22:16:56 -0500:

> git://git.samba.org/ksmbd.git tags/6.10-rc-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6c8b1a2dca0b98775f75a59ddf5f62b6c9512b75

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
