Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792550215;
	b=OAIIgXGTiuyw8D+ZLJAMH2mjtqhYht8+928w6sjCmGGpaaeWKX5EBYqqarRixxAxZQBQ
	 UvZfjsVg5TGpzt7ioZkBk/6P5C5/wBPdsgEJSJW9V+mCbyrXZV1bddd2PLknEUCApJ5Hk
	 zxYaB0AHbpgOTkUvtv4j6t39jIlXgxB+Bm6TLLOoHiVF0QMcaY/P3Moew7NoZ1yLHAioP
	 sh6iiambR6aCQyIPu+Gkwv3zYVE4rRIvDen3pCxwJe2gihhgiIW5YMkRK+w9jZ8hK0vcD
	 Mhp+dW1wPvp+zMrQpOnJPfsQkE33QdJGcCyX8bKxT6bgRdqo+bJQUJeZ/FQuhvHrHiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792550215;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=4fPiYyEubu0Ml4FBwEpKN6u8qKRkMaDj7/lrHBELfic=;
	b=Ul+3xxnQZN1qWd/gNqopTH8spEmavsTVF5Ids2mt7xS+D6sn88yPrIF/wo7Na5AsuqNa
	 oU5e9YuKxqdwJem/caC1b5VtSvyn2HklBbWepskP4UyYKBtev+lwPq/rLgVY+ICF7jdao
	 zBQz1pCVaW0Br4nt3O93LjdAkplCpdJAhPqWv3yH97YwC6PBsSYyE6E9YaP7qRXtW5lsQ
	 JJT9dfqhBBo2spjI2OaLnVr1yocjxZ8WgZSSPyuJINCBkDjhs6QFRl2mFZ7+XnBJi1KvJ
	 T/1Zaf38pa2hs2MDG/vLl4JVVq69mU5DD/jip8/Er/wGqeHZChXmYIJHkp4eiLqrpGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HvDI+Kvm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C759606A31B;
	Wed, 21 Oct 2026 02:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HvDI+Kvm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084FD1F000C9;
	Wed, 21 Oct 2026 02:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792550215;
	bh=4fPiYyEubu0Ml4FBwEpKN6u8qKRkMaDj7/lrHBELfic=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=HvDI+Kvm/YhtJPNb0DudzJKo7wOhkOcF33lKrizaCLD8M+A95pYvzkSpTpihkCY07
	 9OTMGgb7LpcG0kWOI/G927FVmBi8c3Lwm7NjmGlvrKysrCz0eqbsLG8IAUTUyD/5LK
	 QqfN/H/kCOXAQLzKOXRyc3BNwG6MgSxAlTgV9YfIBEb1ueVhC6o/Q0aEaLZr7YMH/e
	 Ur3HjXYILLhBM47FYkQNaC66gH1e0z2n9Yc7wI1qNhXbg4IMIVhfKZEdCnWLjiiFyN
	 SP0VoLD9XF4YblOtytaN21BW2IsR/SmGphbW0hOUWve3Yb0GAal4XFDwQyo3WuOhZT
	 5nBDKXcXSBXAQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F149D3809A18;
	Wed, 21 Oct 2026 02:36:54 +0000 (UTC)
Subject: Re: [GIT PULL] smb client changes for v7.4
From: pr-tracker-bot@kernel.org
In-Reply-To: <fcf60d2f4382fc7ccd77ea41c5e55b50@manguebit.org>
References: <fcf60d2f4382fc7ccd77ea41c5e55b50@manguebit.org>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <fcf60d2f4382fc7ccd77ea41c5e55b50@manguebit.org>
X-PR-Tracked-Remote: https://git.manguebit.org/linux.git tags/cifs-for-7.4
X-PR-Tracked-Commit-Id: 78f73985846465a25a7bd1d89904053661f3ca92
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 32543b09681a142ff1803d87609060f491355346
Message-Id: <179255021352.339009.10598672340543121937.pr-tracker-bot@kernel.org>
Date: Wed, 21 Oct 2026 02:36:53 +0000
To: Paulo Alcantara <pc@manguebit.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Christian Brauner <brauner@kernel.org>, Mark Brown <broonie@kernel.org>, linux-cifs@vger.kernel.org, linux-next@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Fri, 16 Oct 2026 20:52:42 -0300:

> https://git.manguebit.org/linux.git tags/cifs-for-7.4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/32543b09681a142ff1803d87609060f491355346

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
