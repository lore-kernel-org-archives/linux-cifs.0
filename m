Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C033D5230;
	Fri, 13 Mar 2026 17:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773424444; cv=none; b=GMatAlUjLA/Al+Ezr1VS4vHZD4d3E/kD7XSwxScO1iYC0tMVGfGRnV5g4HGtHGiGU7yKEFQwpGTfTBFgegsSkJb4OB+Ys9sav6TasVXyfwaIXpBc+6v3JoxDQMaqhT5IAVcxUO0ydvW4NrZGQHSz7BrFKpDAaLMLgL8CuUg5o90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773424444; c=relaxed/simple;
	bh=Kc/3RxnqOQDw3ziXa/efxhyoCmLGuY4hGufiMZHxHCo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=EmM+B2zQsnPRLWK9IirbmFo2f/ppCQQDFi/ubVYMUH+dl1hXZM6zUVe8fGdr0J+NfluifkVzD3kYVtkVSwRUIbslJgwVKSr4/KOO0DxiPGeL+8omHtIy72rlz7VmJd2QAQmCcUmZDXdIQIFDaLyhBodawEe0sc4V38/VS74CfMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SgbxMas5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgbxMas5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070C4C19424;
	Fri, 13 Mar 2026 17:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773424444;
	bh=Kc/3RxnqOQDw3ziXa/efxhyoCmLGuY4hGufiMZHxHCo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=SgbxMas5G+h5vitDEKoMgpsOzGpvMp4EHM4ljGlC4yVro2vDwYKN6+8gL5TSucTN4
	 HhRNbNSx4msnx/CMPVgjpZTb/drQUmhl5BxFivb/+AdwiKQY71xryd+3PSWnIdyz/k
	 hCLCqDUyVH94YfTDv/rNrsCWqIJd7t1zlNEN8asXzcmX56A8Iza3rmXrIWW3wHznKz
	 s97S1567WBtRNNV8PN8tN8QK1xtGls2dC8R4mnZw2df3nXVntLc//7xo9U22wFfp1v
	 KN5EfX2QyIg7JbB40M7d5yU+wDQXXcmWyNKAdjrwx98Qw+ARbHZRbW5qwvfReTCt8R
	 VzWPVTfMHp9mg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02FE93808200;
	Fri, 13 Mar 2026 17:54:00 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtRx_t2rraTyEmbyWMZk9_NTwuyHjC+oAkbFXz9AwxCvQ@mail.gmail.com>
References: <CAH2r5mtRx_t2rraTyEmbyWMZk9_NTwuyHjC+oAkbFXz9AwxCvQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtRx_t2rraTyEmbyWMZk9_NTwuyHjC+oAkbFXz9AwxCvQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc3-smb3-client-fixes
X-PR-Tracked-Commit-Id: e3beefd3af09f8e460ddaf39063d3d7664d7ab59
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d874ca0522389405e26bc2ba38b59c9849c52cc1
Message-Id: <177342443868.1446579.16120188400201209486.pr-tracker-bot@kernel.org>
Date: Fri, 13 Mar 2026 17:53:58 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 13 Mar 2026 09:57:12 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc3-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d874ca0522389405e26bc2ba38b59c9849c52cc1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
