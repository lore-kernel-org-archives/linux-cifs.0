Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF3830FC2D;
	Fri, 26 Sep 2025 20:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758919479; cv=none; b=ppxaQegAO1HdDVfzff4pxMlbnn+dhjMFN13znDzpikTGBpWvfTOnolaxLaJ3vxCBzGkckOivObqYlaNplHkkqQ7mguikAH40pRoa4uX0unXsS+CtBjihsPPsbO9S4UVRrL/dYAp9LZ+c1dhNGdKN9UAr4J7LN2nLzG1Zkfbzfms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758919479; c=relaxed/simple;
	bh=yuFbV5i1UjSFNBuAUspcdaLfzo4fDRBOFL7cdvx3kGg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=h1O6oCgaC9x7sFAyDw8zUVhobbbe830ltZ5PAHruVWYqsT/ia3COWs0U0/vroAyJ3ENrsrjh3GsPD88t7AhZwwn8guewNrA8tcLzHLo1IE6eV4ujMZTL1H+QEGZTADxgbPzHWzuj56ovBKs3yj+SZPCEosPVUw4uiyhQqnnNBPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IthLELdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IthLELdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C59C4CEF7;
	Fri, 26 Sep 2025 20:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758919479;
	bh=yuFbV5i1UjSFNBuAUspcdaLfzo4fDRBOFL7cdvx3kGg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=IthLELddFvoFWZp9JTM1nKPhKlPfsswxTfgJ4JFC+024pd10/4578QczQbygwKTje
	 drjTA+QMlCq18FPDznhEMjYz2apZHAzileGzZjgMSAbMdPxr6rYGG6VygObor7uyGK
	 aKoosbph0C1SBpHLVCD6JXtD39q++Mipm3DThHgh+vumaSqM420rDk0TvFVdxW5MMq
	 5NqVsNTIRBP+r62jv2E3WVCSJI/zKQuFw9XAQquJpIJZgrJqnvCcFbQOPIagBbYzKf
	 +guxhIw5bITiQy0+LbIYp7oPF+/PEG3YAo6spaTb/yP2YcaCaVneqd0uc/McoNrmbj
	 LB91Rv9hIYNgg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADF3539D0C3F;
	Fri, 26 Sep 2025 20:44:35 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muDMKFMMtG1_rUK6-h6T34qM4miRUL+hCQh72r-TrNoow@mail.gmail.com>
References: <CAH2r5muDMKFMMtG1_rUK6-h6T34qM4miRUL+hCQh72r-TrNoow@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muDMKFMMtG1_rUK6-h6T34qM4miRUL+hCQh72r-TrNoow@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.17rc7-smb3-client-fixes
X-PR-Tracked-Commit-Id: fbe2dc6a9c7318f7263f5e4d50f6272b931c5756
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f26a24662cd2875f82029e28879a20cea212214c
Message-Id: <175891947441.51956.9055221466184333075.pr-tracker-bot@kernel.org>
Date: Fri, 26 Sep 2025 20:44:34 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 26 Sep 2025 11:18:04 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.17rc7-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f26a24662cd2875f82029e28879a20cea212214c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
