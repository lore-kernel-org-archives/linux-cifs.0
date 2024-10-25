Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485E520EA5B;
	Fri, 25 Oct 2024 19:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729883926; cv=none; b=PE5z7wtdon1XGbdT/6U1luiJz1dAIG9zL8mHogea5WfuLNiKrtGZDN6G1qRBmlpMho9wMaL+9Thz8++kz4DGmwtZ9KEZQ4LtZ/CUChXWxAzLEB1OHYUv+ALPCCGCALH1eY+E5ArSAP9+k2XkXF2/ThUSmBBildR8mMwhnwpYebg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729883926; c=relaxed/simple;
	bh=iT+q2zFAzAPPkNHw3sDo6kAzQXz2PVnA6RGvIqQ0zXk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sogJJaEV3G5MCXDLsWqTkJqMPzH+YsNiU9RfXU373/jnUkp7SDgRKPGhVxVZKsTnYLOjqcsMJn/nVKxnAd+5Ju4RdCg+nwf6UBd27NHdBMg/D3go7XmPXCaUh67Wyly6Ge1DaXqs0DVMbEl9wVANQhgBJKiQkiv8l2kMrZskgJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6H4mKZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6H4mKZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25519C4CEE4;
	Fri, 25 Oct 2024 19:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729883926;
	bh=iT+q2zFAzAPPkNHw3sDo6kAzQXz2PVnA6RGvIqQ0zXk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=f6H4mKZhdKakfSeaZ0x9zEFw8773UGEhtqz3VHzzLOh5OvFlv1oUTJdh+g3adcmQQ
	 66B/hwUBJKkW6QT1+/VRakCgu2k380KLg5CgW4TmHPwadmi8e2V+kEPkfmgOePKnqt
	 JXcu/VSoennFzC7/IZubNazB5N5MFY2CCciDz+3Qz+x8jcYBaL9cPzgWm4kgrATFVK
	 vcrn3n0xbUZ046de86Ge+aCBgs27rV+Za6fIFWMHKqOmEoK4yCMeGh/6W4wfY17X6s
	 I0O7wZU86nryOMId7onUSiINfXEy0lT/tpPA+/A0l3aplYFhw4T5YKfeIHkm2jpexT
	 qL+/2hgV3SpVw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 350A53809A8A;
	Fri, 25 Oct 2024 19:18:54 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muxd5VAivOGh1vfKkNSTphne3Dky3ZwTn9vZKxBBKXPmQ@mail.gmail.com>
References: <CAH2r5muxd5VAivOGh1vfKkNSTphne3Dky3ZwTn9vZKxBBKXPmQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muxd5VAivOGh1vfKkNSTphne3Dky3ZwTn9vZKxBBKXPmQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.12-rc4-smb3-client-fixes
X-PR-Tracked-Commit-Id: 2ce1007f42b8a6a0814386cb056feb28dc6d6091
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c71f8fb4dc911022748a378b16aad1cc9b43aad8
Message-Id: <172988393284.3013963.18302828075095751676.pr-tracker-bot@kernel.org>
Date: Fri, 25 Oct 2024 19:18:52 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 25 Oct 2024 11:40:10 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.12-rc4-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c71f8fb4dc911022748a378b16aad1cc9b43aad8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
