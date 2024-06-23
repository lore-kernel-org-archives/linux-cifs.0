Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74857181D0E;
	Sun, 23 Jun 2024 15:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719155594; cv=none; b=gtU9iutnPKUjT1+CJsk+jvOF9W+VOheJ+h/x5+2RwFNtMPd10RMQ8Mx2Z1nly9c+McOLROF4KDDijPxRg+lUk/VTMIo7t45loqHxggJ8yZEyE2aQkH6fM+UuhQLeiZSi9g8yDlqXuIZ0hMXusW8+QQP2+4hUA90Hu2j1VUyboc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719155594; c=relaxed/simple;
	bh=oOqVRkJC0NfalXCzUh+l0B273wep0hAvfw/byP7KRs4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=rCXRSY6J5VXFr6IUb4jIkO6FJoj4TNLa8s8M3PMp7oPeONinZW6axhbpOSI4MVqEISEEsjdqKsCCSW3u1R3Dnx9Wn+QyemOUzNlqTAstTHl8M5CO9yNEEjisJezalju7C2oUaUzheZdCukxjadeJJo88CkY660WjFdNNUsDShDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6lSMGw7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6lSMGw7"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4CCC0C2BD10;
	Sun, 23 Jun 2024 15:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719155594;
	bh=oOqVRkJC0NfalXCzUh+l0B273wep0hAvfw/byP7KRs4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=C6lSMGw7HS4yiG1QbJs4wniwD2vLqJ6PfO4h6w/L3bWp22QQWofuqHOoVoXjBGN28
	 y59cY6+FvifLwSsR3rKR3vNLNMDw8FwKw3F8emWz1PpFXPwkQsnNhkRYIAXD5X6gDW
	 t98tpupO2ZD3wgE9TSMRsR9un/4hhto3C28uP7p2nPpup66XTAMFx/UyG6XrFXivqx
	 gZrh3DvXLewobccKVHpwb+VfLdDgwEO+wZJzLDJTVYpXSnuKHyVZAK139fV7eDSqOM
	 LuUyNFX3XjvXSSro0E4DWGIy+zf3uaOLOW83oLqZJEuZ5MupoEIVdGLfXJKC5joeQa
	 eDecGLLz11UQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42D7DC43140;
	Sun, 23 Jun 2024 15:13:14 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muEks4khtNFc_rE=ywU15-6FfACkohXfxNGNvkdZ=0ovQ@mail.gmail.com>
References: <CAH2r5muEks4khtNFc_rE=ywU15-6FfACkohXfxNGNvkdZ=0ovQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muEks4khtNFc_rE=ywU15-6FfACkohXfxNGNvkdZ=0ovQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/smfrench/cifs-2.6.git 6.10-rc4-smb3-client-fixes
X-PR-Tracked-Commit-Id: 3f59138580bf8006fa99641b5803d0f683709f10
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d14f2780f0552edac67c24ac8868d44b2b1022a3
Message-Id: <171915559426.3671.7916591355822403537.pr-tracker-bot@kernel.org>
Date: Sun, 23 Jun 2024 15:13:14 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 23 Jun 2024 01:44:50 -0500:

> git://git.samba.org/smfrench/cifs-2.6.git 6.10-rc4-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d14f2780f0552edac67c24ac8868d44b2b1022a3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
