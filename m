Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638BD4C91;
	Fri, 24 Jan 2025 01:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737681005; cv=none; b=e6XIfb/CHkAUUR+5vhAL5JS4UUvY9hb6VBmkO6XThL2qi2ntN8oo+2ZuEgs4OSGMDJIFmesNaT8s0Qa+BWKHiI9sejaGhLQHWdJwX4zHBlcxGJxIjZVCWUKBnnzjSfd7UuqoVxPn1SEbEFLxFwliK9a4w4RMQdwY7nr+6cpzmuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737681005; c=relaxed/simple;
	bh=dtzNFpVjGbmluph5u10lV5CAk3XIEBKT767E6Gun4aQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=kBWBAdkE9/VVHZ1WB0DIqbagvVn4p6Q17qPl616nSwu7tzcc/weODBx+pZme+km2QgFbOvpaALI6i/AzqcaBdI9FX5lBndmCOCevpJA07gHnhlU0BhCiJJ4A39MXVmzfbaOPFOBrFFf/ix0rUQOmRkyGdK+rdgSK8l4Omz+tTgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=StURDa6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StURDa6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3280BC4CED3;
	Fri, 24 Jan 2025 01:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737681005;
	bh=dtzNFpVjGbmluph5u10lV5CAk3XIEBKT767E6Gun4aQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=StURDa6GNLaUBIKidEjku/Jin1jfbbc2Qan6pZxPYRWT7LARIFqce7wDF9iqloNOs
	 OsZOp8lKgw59rqHGZ3Yw2pStmcK+8tvZ+/7Ap0XUcYEUjHQxvIUTw1Al1A55qeBLTt
	 5RSEjCAglC7d7RKjPGXnpgDIgxpYxMJLO0ETnFz6uGLUudvfTOk+LJdwgJ7BpiRqg4
	 PS7gtJJWVooIdJTbmWlybhjs3iUBvtt3EqahOU0QShniRaqIYYHnjxpuSLHZr8qSgN
	 3Pk2gqH+G8Zhroqw7FkKXR2R3itH+QZcOxPrABpTpfXM2Czdj43k70YSvggfeWylb1
	 BMBJ7phKtbMBQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EF09F380AA79;
	Fri, 24 Jan 2025 01:10:30 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvrTgizT-zVYJpn0wE8S6DWJemS5yaOC4d=t_ejVz7wsQ@mail.gmail.com>
References: <CAH2r5mvrTgizT-zVYJpn0wE8S6DWJemS5yaOC4d=t_ejVz7wsQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvrTgizT-zVYJpn0wE8S6DWJemS5yaOC4d=t_ejVz7wsQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.14-rc-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: aab98e2dbd648510f8f51b83fbf4721206ccae45
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e814f3fd16acfb7f9966773953de8f740a1e3202
Message-Id: <173768102975.1552388.12338332860850572129.pr-tracker-bot@kernel.org>
Date: Fri, 24 Jan 2025 01:10:29 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 22 Jan 2025 17:51:51 -0600:

> git://git.samba.org/ksmbd.git tags/v6.14-rc-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e814f3fd16acfb7f9966773953de8f740a1e3202

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
