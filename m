Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F0033A029;
	Fri, 29 Aug 2025 16:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756485579; cv=none; b=OvSBcNPoQOpT0SDQQZixNB6HlEIhQdtHoqOF5b/8f/pHcvh9Q+91/cFJY+41S5tX1/VjHbrSKyPycF96IvnNbD2QZRdrD4+5TIA0DYvW14Lexqc/PAa+/HAmci4L98c5mldgdZBYLttqZPAEHczNgGlLkoWKEOLzrZ5nSHZhh44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756485579; c=relaxed/simple;
	bh=S+A3UQDKuia5BpAKma1QvBmWZt44YFkgc1r8tx4Xmp0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=f7ooyUFBK+llizdJYyR1VtcxjNMEnrEaKrC22tagExCuRReSTNg0Kmn69VVcJvs4RDKpwWNYhR/GGox0E6N1MQB5zUo/nobAzcMFnZKeyMnNGyrhls3nM10xAiUEqy/Tyh/mZuFGi7OuZqvMEuBNgQvYGwVt/LCMyNpd0AJQS4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mz4cVGgd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mz4cVGgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E7BC4CEF7;
	Fri, 29 Aug 2025 16:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756485579;
	bh=S+A3UQDKuia5BpAKma1QvBmWZt44YFkgc1r8tx4Xmp0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=mz4cVGgdRetKSUrWoPWlhhOolXLegldO01zwQ1gWZFoodatARZIEZ5+vyZntflilj
	 NInyyXGGLaApOBY+xFzKgNGOAy8hVdvsk0uP+VybotKq6+oQceQ+jRpeCU/w5xbvs/
	 59FSMmIUPBBg2U6FH5ZEFMHu8IRIH6DvdcVDEwskmNDJBv+97r+07YIli2LAQEPNuj
	 NXfUEj9kK/slEPY0Jt45NABNiml0uCYgQYeAUxIQXqYzIwCKZDiX1yKBhfz516ZytE
	 tcKl2vKLhM75bbNLSmMP70YDNr31GPakkkY8ee6FbEsfITQf9bVl7MuTgGNP4iIZFe
	 jJmAf2SPyP35w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33DB8383BF75;
	Fri, 29 Aug 2025 16:39:47 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvT2dSmW_pvop2A2GKYBRdXzyHGomg3dFEhF2n1N_XCHA@mail.gmail.com>
References: <CAH2r5mvT2dSmW_pvop2A2GKYBRdXzyHGomg3dFEhF2n1N_XCHA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvT2dSmW_pvop2A2GKYBRdXzyHGomg3dFEhF2n1N_XCHA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.17-rc3-smb3-client-fixes
X-PR-Tracked-Commit-Id: ab529e6ca1f67bcf31f3ea80c72bffde2e9e053e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2575e638e2d9c70971e5232398ca22afa6f06293
Message-Id: <175648558587.2275621.18211389909245512790.pr-tracker-bot@kernel.org>
Date: Fri, 29 Aug 2025 16:39:45 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 29 Aug 2025 09:01:24 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.17-rc3-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2575e638e2d9c70971e5232398ca22afa6f06293

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
