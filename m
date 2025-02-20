Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A38212D83;
	Thu, 20 Feb 2025 17:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071004; cv=none; b=UzxJqJP0K+GbxB8/FHLyz08notYMhUFFCqlJJMpQD0AEreofCbTTyqZYtIEE+i3Kz3Jj612WpfXtqjn0CQj116yj2DC9GGLwtyGAqaZnhxxNWl+WHJVdB6Bs2f+3fnuXcb9cwuQjnIGvx1GwxbZexbRnb6cOdByWkYtX/fSgSfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071004; c=relaxed/simple;
	bh=UihZzHHpSNWFBTIsr71cXWDdr/KYFkVpK3kK3u6RFiA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ZG9JIxbAPabQbjeu5JXPgC7cHn5qpT3Cn39QpShfou8MRGd6/r96HugxlmYzc0Bv4C7c5Iuam3AfmBiVVbFIZS6NwuxdWiFlEVgSjSoEOGMc2jtCg4z1HHdmfMGLzML79LOimpRm15jBDevES1m5FhcbRDK0kRiQt7q6PVzLclo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WzV6XKqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WzV6XKqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37138C4CEE2;
	Thu, 20 Feb 2025 17:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740071004;
	bh=UihZzHHpSNWFBTIsr71cXWDdr/KYFkVpK3kK3u6RFiA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WzV6XKqAkdol5KsBFRYNIMkNlmfir65RTYrEVdhhqUFxF8TQLfpJbYuYd/q4gMDi4
	 UXWma/sEmqQrxe9CaZOzDWHowydYeEyJQUjZJGRbEHMxY/zTnNgbHb7T3ObLdLpwC4
	 Mcy0CX3wH70ejnfYAbE19Qm2O8QVWnmY8pFKZAPzhpe6o4cIPlDgKq+0SZD5JSgUuM
	 mFRa/8kaP/6XH4qlUFiqbQJ+7qTcJUUPM+jBMebnxYxIWtMaX2u9FH3ELmOHiMWVp/
	 M8ZX+/vTpSNNYdUV6tD0SLpHPn7M9nA8gkyKUgz1pJJcwndD4dbjQWE5IlTk0OpfbO
	 RinalpbKyeYBw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D3D380CEE2;
	Thu, 20 Feb 2025 17:03:56 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mu-WXH1irOa5ZiSRnBA4Had9BPaVR_w6ZjSPFFkm=4WXQ@mail.gmail.com>
References: <CAH2r5mu-WXH1irOa5ZiSRnBA4Had9BPaVR_w6ZjSPFFkm=4WXQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mu-WXH1irOa5ZiSRnBA4Had9BPaVR_w6ZjSPFFkm=4WXQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc3-smb3-client-fixes
X-PR-Tracked-Commit-Id: b587fd128660d48cd2122f870f720ff8e2b4abb3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e9a8cac0bf895efe0bc7b11d174e8dae9b195da8
Message-Id: <174007103466.1392144.1887578442984965554.pr-tracker-bot@kernel.org>
Date: Thu, 20 Feb 2025 17:03:54 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 20 Feb 2025 10:08:53 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc3-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e9a8cac0bf895efe0bc7b11d174e8dae9b195da8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
