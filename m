Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA02934D4F6;
	Thu, 18 Dec 2025 20:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766090619; cv=none; b=EVdgFoOg0UxoZBSyFjdQNvFzHyAcvKzh2v3OYFqRs8gRfpWj8wVJtbLTO3duGn1z++DxGN3sbRMYr1mnbnRUFnamaeOhC3dFyobZWinkreow87EyZ45kUr8cT8Ujn9poAWmUSNBZ2kyRWgMvYomxD5ZwHPfll16BG6mt25lNI3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766090619; c=relaxed/simple;
	bh=fJZa5A5YQb5Cjr6Uv5pUKCPzyW8bT0Si8mQklNzTGVU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=puLd6mcve0Kw/a6XKTwMNBkngwJd0xY4hZ6T+X3zaSilBgxPQqsHYg9FBmcdZotmqyEy8WL+KXeKVXLnIKGWGJCAlMvbs57/6d1eLZJN4uEHQUerBfwIsQc2HZzWOEt90EWdcj0qyUzna/mfXNGLWIijYZru2zJcybm/ORc8IZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBEX/qvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBEX/qvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E75EC4CEFB;
	Thu, 18 Dec 2025 20:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766090619;
	bh=fJZa5A5YQb5Cjr6Uv5pUKCPzyW8bT0Si8mQklNzTGVU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=dBEX/qvnmnzV9gew2URFyV6SZs/4z0xxnRlZUO3bKEZZE+4Mu667ClLPNVEcnv46b
	 Z0W15bXhhNqcv/xj87wTVI4cVJomkXlEGXvILuwlOfKvd6qf2s1Lh/KIHuifD4jRua
	 I86m13tMbd6Rl7Vv+aE3hXT5h7Yj32f84levSrlTTs2ePue1m9Nj7FIOuxu+kp2W47
	 mKJHCKlHuUBv5O8jAr1e3cYI5nPzJMdvGugYNQ+Vq8tzMiUumAhBpY8psg2PwEt42E
	 Pq4So0/Rz+2X6p5RI6+aPIEcarASZATvMBAwU2dIenRzNksHymxhf7cTYGdo2gAkMB
	 yKh6/qDoS/BPg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F2BF7380AA41;
	Thu, 18 Dec 2025 20:40:29 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtxKs7+wFMoE2m9gMZLc9vr3Jj9eEm21JZCNsunuiydDQ@mail.gmail.com>
References: <CAH2r5mtxKs7+wFMoE2m9gMZLc9vr3Jj9eEm21JZCNsunuiydDQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtxKs7+wFMoE2m9gMZLc9vr3Jj9eEm21JZCNsunuiydDQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19-rc1-smb3-client-fixes
X-PR-Tracked-Commit-Id: d8a4af8f3d9d3367b2c49b0d9dee529556bdd2f4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a91e1138b7cb0e4dfa12ef823c6eedb34b28bd08
Message-Id: <176609042858.3123765.1898081444473697947.pr-tracker-bot@kernel.org>
Date: Thu, 18 Dec 2025 20:40:28 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 18 Dec 2025 10:48:23 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19-rc1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a91e1138b7cb0e4dfa12ef823c6eedb34b28bd08

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
