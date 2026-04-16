Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F59E22A80D;
	Thu, 16 Apr 2026 15:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776354156; cv=none; b=Ipd8kVGhifJWVIJuQkbvKdKUulhdx5exoFmU04S8PMcF1b0AHnv17dJVb4stW+TApOhXi7WlFwIq39AUR11nA9RP8pXKHZqDajcs8WAsfUMQTM6P0a/PI2fkKmtywqpBcHCmmNeuVtana5/DkuB9M0ocqNN53wPmF/bVAFu42Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776354156; c=relaxed/simple;
	bh=5ZhAifLE5l8Cqwiklqeay7iDoX7mImBlvFbk5NzuHNY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=tAsQtHWTONC6qKl8SPE6OcV1JzuihnyQU6Qpx7Urs0fyQfMiEnp9aM6c1Q20YdSDaUyb9bMrwHmJTx1D9KY8h/LW74JrVJrKVbQBEa5c5gjgaf6Zn4yNO5r9nPBfbsJX5QYjRRCqpeCeU3xE81gHnskMbhrVgA5O2FYzsUyVLkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bHxsk6iv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bHxsk6iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E92EC2BCAF;
	Thu, 16 Apr 2026 15:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776354156;
	bh=5ZhAifLE5l8Cqwiklqeay7iDoX7mImBlvFbk5NzuHNY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bHxsk6ivkkSwYBF4+kekrakVurfVmnX6GWs0yd9fNHmVUdoSo976uoYpuSpuLOO8f
	 mw5HTMJ39WrDYty3UsOSiApaI85OP96sgIGc3gMFAk4S1KuGUamxs8troPym+gfhwe
	 GfciKlkvEHre6TKVEi3TE12a05GfuZ8FgritvJ5RxWeW0DgOOIdvNKjEUNSlBaBBwc
	 db/YhDzjrtLdD/NF988AgXoxxZR4lgY3e0+NMwmGUdcYwqWaBdXS5YxaxqwTckBoG6
	 Pl1g5TKfnmoq1XL5ZG/j2RNqOb43hsyjGZEHwg4NM4eZQxf2+/f+Hl/7bsceNOhiXn
	 9TMJfAyfLMzQg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02E55380AA67;
	Thu, 16 Apr 2026 15:42:06 +0000 (UTC)
Subject: Re: [GIT PULL] smbdirect ksmbd and cifs changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mu2+PGJER79PJpPVCysoEEgCsyuzuCKCD9LzZSHQnhOSQ@mail.gmail.com>
References: <CAH2r5mu2+PGJER79PJpPVCysoEEgCsyuzuCKCD9LzZSHQnhOSQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mu2+PGJER79PJpPVCysoEEgCsyuzuCKCD9LzZSHQnhOSQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.1-rc-part1-smbdirect-fixes
X-PR-Tracked-Commit-Id: d09a040c186a2083b1cfa9c3c112782ce4b1f6d4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3cd8b194bf3428dfa53120fee47e827a7c495815
Message-Id: <177635412465.3287922.6961857389542258801.pr-tracker-bot@kernel.org>
Date: Thu, 16 Apr 2026 15:42:04 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 16 Apr 2026 10:03:47 -0500:

> git://git.samba.org/ksmbd.git tags/v7.1-rc-part1-smbdirect-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3cd8b194bf3428dfa53120fee47e827a7c495815

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
