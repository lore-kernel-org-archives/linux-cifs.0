Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDA12F6921;
	Fri, 12 Dec 2025 10:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765534301; cv=none; b=UumdBhd6yzv8x3/SyTTUh3ysZpbPxgo03W9HFbbMeg5LeodHO8CSnz7teMEw+u8n/gFKj7oLDUgW3ibssnAK/iZ7e2p30nqQ0Ls6tTguVyMbpMFwIULh2fJXi2KCG4I9Bout/4dAQE0jkaa2LHkdGaAgD0xsk4Ad4UXcDjrvlWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765534301; c=relaxed/simple;
	bh=PdBCSIkO+rnHooB2/ofKOApE7EQR9VQMfXgjoQ8Ea7k=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ju1mje4HUf15kXDIaRKXR9w8lKuV1NkBidXZ3eULhM6W0sha8xc+biDPIAGP7Q0MNPSZC5mNibun+siHYfgvHo8fKaH9SsPgiMQ/TMt/HGwnz9K+GuzQNg1pSgA8qCeqA07wsUXN9ypB8qLvSylUA+vJUcs/OXSEHGWt3CGq8x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KJcMC1aP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KJcMC1aP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E587C4CEF1;
	Fri, 12 Dec 2025 10:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765534301;
	bh=PdBCSIkO+rnHooB2/ofKOApE7EQR9VQMfXgjoQ8Ea7k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=KJcMC1aPrKKELfPDFTc/0i4VhUPQTtRgAmQ1utMfuw6ii2y7cMJZVbJWnzphPWya5
	 qXpnUDVBvsYeBOX3wibNPMlUIvag6InTVt+HsPxKxAQXYjL9bLrYfy94KHdSSv/X2U
	 qDedG/lyHGcZ32K8r0Jr1JJMYq6XvMXHl9ia7ejQupIFjfLWuX1CS+Ywjm0aLpmomU
	 qAM9fGyracEMj0sDfSWRFzjcooy+66TnyUSoEt13LMp07eiGuSydRzU4SXD8KjiFwq
	 d7vytI9bgf6v7ERlk99teYnkr8xln7CmmHhOnWh0af+iwMT+Bm8cLXOutfjJB/roCo
	 KEYulHnPtrthA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F30B33809A90;
	Fri, 12 Dec 2025 10:08:35 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msAbUgccRkUFLPAyzR9+7L=4+=q6csmx6WXTAzMwOriYQ@mail.gmail.com>
References: <CAH2r5msAbUgccRkUFLPAyzR9+7L=4+=q6csmx6WXTAzMwOriYQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msAbUgccRkUFLPAyzR9+7L=4+=q6csmx6WXTAzMwOriYQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19-rc-part2-smb3-client-fixes
X-PR-Tracked-Commit-Id: ab0347e67dacd121eedc2d3a6ee6484e5ccca43d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 10cc3e9a11dc0d5d8450ecf6db99551c867f3203
Message-Id: <176553411462.2108206.18037727979548930484.pr-tracker-bot@kernel.org>
Date: Fri, 12 Dec 2025 10:08:34 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 11 Dec 2025 20:11:52 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19-rc-part2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/10cc3e9a11dc0d5d8450ecf6db99551c867f3203

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
