Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672FA3219F;
	Wed, 15 May 2024 20:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715804995; cv=none; b=iKjvFmd9yLEpEs7OqE9PPjHGaw6eIPhcUyeAp7Z5Q3Tknx5wYIlmDpzTMFcrk5QD3b0FrD5c8lOvUfbv5FdJ7Lik75/V0QyWK+xZwV3dRtqnPoNuw1HvXmgG+AAn8jm7QljKNYmx0d+0KgAkrkJtiS7hi6wltiNOcgyBgTwDKto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715804995; c=relaxed/simple;
	bh=k+4qdNRK01UvyY8obfuRLYnnVCh8bMwh4x3yH1nfkv8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=in3zSK3UD8CWFzxP9TV562Osla4q/pCU73q+KxI8SQtyfL/a8oZF6HrhXWMc0CQ9z52G8XLhysx2CJRIAgTSAplGDoMA9rn3+WVkTqeAAukIZqhp6t3xwj0Sks59OCB2qQjLriVyDxA+H6n4zVBrNKZ8vPP8P8olCDjvdDfIjF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IAKV+0+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IAKV+0+V"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31993C116B1;
	Wed, 15 May 2024 20:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715804995;
	bh=k+4qdNRK01UvyY8obfuRLYnnVCh8bMwh4x3yH1nfkv8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=IAKV+0+VaFEDv9E6LOQSDCuUO7HWSq5fhm13vlftRH6xAt5L6pCfS37nKzWiFPb5o
	 KD5P6h8GQdvvN3Egr89IJPiqoTcJWG7O/n+f2KJ/uYhCHCuuOQ6yC4zScXaEokDQBA
	 Tus+11AOrAg44goxiNl7Gz8BDByrTbTe6fnvKSAQEcZdeQngmEubxYyNOYvv1QPpub
	 YwCEOCkXIKRGZoE8jfeDKAPSEQcqITSsWaQXrKdv7J2/9oGofMxlbO2J4d6GW8ExQz
	 yRoWpWNakKwl+h2g2GJNWIEvTQOMrKaRkDQogZeae9PiJPgxdqasPtcz+/LlCSJR8X
	 SNOO87XPmElwg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 294E8C43332;
	Wed, 15 May 2024 20:29:55 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mv5B8PAWpMq-5L_n9NXjOb_Jw6atrTETWOUi1rUM=8ugw@mail.gmail.com>
References: <CAH2r5mv5B8PAWpMq-5L_n9NXjOb_Jw6atrTETWOUi1rUM=8ugw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mv5B8PAWpMq-5L_n9NXjOb_Jw6atrTETWOUi1rUM=8ugw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc-smb3-fixes
X-PR-Tracked-Commit-Id: edfc6481faf896301cab940da776229fe39e9fc9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1ab1bd2f6a5fd876d1980d6ade74ce5f83807baf
Message-Id: <171580499516.10831.4679221615351969274.pr-tracker-bot@kernel.org>
Date: Wed, 15 May 2024 20:29:55 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, David Howells <dhowells@redhat.com>, Christian Brauner <brauner@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 15 May 2024 00:37:46 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1ab1bd2f6a5fd876d1980d6ade74ce5f83807baf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
