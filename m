Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90730345ED9;
	Thu, 23 Jul 2026 20:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840059; cv=none; b=rqOch7Qf7Xxvr9x2BmRBk+LzXyEoVnrUmFalgN9Yeg3YBGHoDPd4qw5gBhRTb0JChQDSDOb+ZIsw2TLimUCox4QvBkJDeTEYvEBF8c3tGqRMPUg2A3ctAK4mkRtavwZdJ593eN2W9AvvXtGooa0pcD7cJ2SHTBYjn0tdVTK8pCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840059; c=relaxed/simple;
	bh=7DLunjSLmVlXyfjJ99DYtpyWQfqtLUxYPgnSUiiDHfQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=s0JELktGxcf6xyGs9WCUud+BBAu5+VQsyrjA0W1NIDeyaY1m1KgDNxwnjIdPulkRTJpLEcwfo62sRo3TkRX1kGySXECbrA4BG6cRRPsVVkfFRU+CtAuYtyO/80WsXS/8ONW7B08+8YMmUMMLU3sFb6R6lRiQBg557QU0wtIBMbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M2D0gYKJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2D0gYKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325CB1F000E9;
	Thu, 23 Jul 2026 20:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840058;
	bh=nXVA+O5C4ucoPGYMCNofUrPH2D1ztjD6iN88RHc4xB0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=M2D0gYKJRiqmBB6pD2sqViA18neP+ijG5JoFjmwD3rXQmOXsEt1bp514elrf9tUPw
	 5i4TlRTdmhvg27vFCcXXooSEge3865duOhbQ+6sEVqqZzxqI8xGQLm3DEgP9A5GMFY
	 yJpXs/a1Og17amKuTl2mHRz6btTb4GF9DJR99441yh48euxebdBPAfbp45tO4NtvyF
	 iwWzkGHT4ataNg+0x2u1IhkCE2gvL4qWRtNMqzNMGw5kgOmwbMI0zaficbReeenLKX
	 0jA/iHyqyK1M0kMu7HFwo1TO3H3iVog7ethQUYzH0BX6hMuNms06j+qB007MN7OUS5
	 vEbZQR7GB9AHw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56B133924A1B;
	Thu, 23 Jul 2026 20:53:47 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mu0Qi4c8NprbnviCv5whzqGuzriVT6qShQ91=Kx4=T3Zg@mail.gmail.com>
References: <CAH2r5mu0Qi4c8NprbnviCv5whzqGuzriVT6qShQ91=Kx4=T3Zg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mu0Qi4c8NprbnviCv5whzqGuzriVT6qShQ91=Kx4=T3Zg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc4-smb3-client-fixes
X-PR-Tracked-Commit-Id: c2f2e83e3bbc5483730fd4ee903182761f1ae50f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 48a5a7ab8d6ab7090564339e039c421f315de912
Message-Id: <178484002578.2867324.15948106479827874983.pr-tracker-bot@kernel.org>
Date: Thu, 23 Jul 2026 20:53:45 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 23 Jul 2026 15:44:39 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc4-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/48a5a7ab8d6ab7090564339e039c421f315de912

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
