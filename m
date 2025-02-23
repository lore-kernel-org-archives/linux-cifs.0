Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0DC17588;
	Sun, 23 Feb 2025 05:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740287198; cv=none; b=Rv2U12ev/p0Ko89WiG32CMecwrsGHFW/icaLI7AjzOI1AY+UlwfnP6sE4qtHkZEDutYKXgL2C4rg9WCmZ4IjE2BYViTiiis0WWJ1ZHQnveP+tJe2GwXYnxNaJXn68BcHoaYGy/auUan6SG4kYUrzalyYXkDpAvU6/Uht0p08qqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740287198; c=relaxed/simple;
	bh=/iIwbLBtSDsMUiEMtyBHxF0frGs1Ws4+F3xd/zDNKCs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=O+ajDy6DBdy3p05ae+iHG2zMLl/FiD/Eg7Lehs2XXE4CiRUoh6Bt8Snj8pwVsI42ekyIoVwIfDdGfdGtW6gafp/84zb1ehbBYR58zTMzTDkTqKtcK0ULVtxLTnvgIWYa2PBIHG/A4jAprGN+eFbrpZ4pBu+XqVDAS4N0+K8ZPFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nPxAdGWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nPxAdGWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA024C4CEDD;
	Sun, 23 Feb 2025 05:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740287197;
	bh=/iIwbLBtSDsMUiEMtyBHxF0frGs1Ws4+F3xd/zDNKCs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=nPxAdGWwE8hwX6UjXoJmQk6/mwEi5B0iuw6j9+Rch36xPitvsCH/HtNzvvjvGr7PA
	 mf//G3AF6lAoEpXhaH9I6pnVGTCuOMkwKOSABYIwmfTsw9fMlTUl2myQ6ryDlX0OXx
	 SMCJBREjhVbdhAWx11LHcL/W7mWDkMPALPkNDX9fWJcIYXsvL5UexL8L7HToVqz16x
	 7WFiGztf4WuE3zrlWQLl/2kTmxb/5NfrjmuSgYLv5fpf3q72u5v5SJ+X4mSH+eVZha
	 +9mN5d+h/p5cYwVNNh37CBiWe+kYCQXRcoEYR8D3gKU5ovG0RNgwFnbE16eVKt9Gc9
	 ytF+uaTyM37xw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D9A380CEFA;
	Sun, 23 Feb 2025 05:07:10 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt2PEH5ZOR6YP8wNSkaQGrAy0FJJB7bPT5VPxb3-kTAkg@mail.gmail.com>
References: <CAH2r5mt2PEH5ZOR6YP8wNSkaQGrAy0FJJB7bPT5VPxb3-kTAkg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt2PEH5ZOR6YP8wNSkaQGrAy0FJJB7bPT5VPxb3-kTAkg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc3-smb3-client-fix-part2
X-PR-Tracked-Commit-Id: 860ca5e50f73c2a1cef7eefc9d39d04e275417f7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 27102b38b8ca7ffb1622f27bcb41475d121fb67f
Message-Id: <174028722886.2494983.11827241303854655021.pr-tracker-bot@kernel.org>
Date: Sun, 23 Feb 2025 05:07:08 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 22 Feb 2025 19:03:50 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc3-smb3-client-fix-part2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/27102b38b8ca7ffb1622f27bcb41475d121fb67f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
