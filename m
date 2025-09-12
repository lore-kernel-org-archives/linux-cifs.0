Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F618272802;
	Fri, 12 Sep 2025 17:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757699341; cv=none; b=qAc/YNoOdOj3AQop+ZabL+1rmvuu4P4S8ooA+7Rg6IX4CLEQy1bs/cBMiBjZcd4BePRyvg+Ft+HKk8vGqx2GJz7nD+Iaf3DrFWoDJOGx9skYs4WtbL1zrRx2qTql2NKDAjCwHZ7S+rT+QF1Ps9oJifp/ozYzQ5WYORkkf5+54IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757699341; c=relaxed/simple;
	bh=Tetm5pvxQ5xd0nUhcCJ+arW3xLq+acWyTrW0VyNRqa0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=MTLVzqMIVhHejPpWQRVw2EHp/2QLu3zJAAkuBYiYnALQyvUeVUNQIwJ8uHzrZMnxrvz2M6bYNYtN6kfmG9YdZLL+mhjJwXNXieKgbI2BT/UF10i/oIYh+gvbj7LvgkDzv3IFDIW1MhH8OSEdGqNkSuxg+tcwWyknjEY5zivCK5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OMenZj2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMenZj2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D81C4CEF1;
	Fri, 12 Sep 2025 17:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757699341;
	bh=Tetm5pvxQ5xd0nUhcCJ+arW3xLq+acWyTrW0VyNRqa0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OMenZj2phHVRY/0BGrINzFA4FhkpBwU1+NRWcYcBy2L1ut2vRNZMetHPCEIQWbyK/
	 sdDKbaR5bWtJfD2utEcKrFAeuHp7UTD8zkd8rsOGpKdu8K4Sl4GwY9xKFTqfD7AQK8
	 4SiPIDIeYkhLCR0o5ya0W8qYImgZ+PrUPPkkgle7GXmxtkOXnF+E5hQMK3pKftga/E
	 DwgdvZVDDp+OuByMzSrCX7AUgrx8bGuTD+yzvrQTztPTZWRL69COv62Dz9Hgv7+epX
	 Bct3+/xDEtFU2zk4wPPlsbFOxWJsowzI88UFYFwNuE5c3pNCourOq/ZXQ2XhD/8t0A
	 prdlyoj/UJspQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB301383BF4E;
	Fri, 12 Sep 2025 17:49:04 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mteAcfR8sgQuCEKHxWn2H32BEQ0pJcTuiRmAs4Yo0dYJw@mail.gmail.com>
References: <CAH2r5mteAcfR8sgQuCEKHxWn2H32BEQ0pJcTuiRmAs4Yo0dYJw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mteAcfR8sgQuCEKHxWn2H32BEQ0pJcTuiRmAs4Yo0dYJw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.17-rc5-smb3-client-fixes
X-PR-Tracked-Commit-Id: c5ea3065586d790ea5193a679b85585173d59866
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cb780b79b236db9a036a4b7975361dd44a0b4d29
Message-Id: <175769934340.3023336.13657325316731938056.pr-tracker-bot@kernel.org>
Date: Fri, 12 Sep 2025 17:49:03 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 11 Sep 2025 22:06:56 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.17-rc5-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cb780b79b236db9a036a4b7975361dd44a0b4d29

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
