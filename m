Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2BA152DE7;
	Wed, 28 Aug 2024 05:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724823143; cv=none; b=g3nfdJOmhmJkD4zKlulOPy8Nm8Vori8WQXtm9nu7MzLOhJRgvl5RliT+Ze6Qcd1lsNVfAXkPDgCYgFgR0Ycph7a64BBepSMXM59G8XZBgwo8rQbtrFt5lW0pqoSm7KV3w0tSBKPfWRqPNS58LEPTtnlJ3ZBEpfcAvOxK4RHuSuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724823143; c=relaxed/simple;
	bh=i8ucd/Ngz55QuSWGsUJplsWlgL3cu3NomNlJtXm7BE8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=V/tkekWHSGcooPDFfRwP5JxVnZLH8RkHDCSzhc1O2D7NEDWK1uOxIZCnQsGa5zaqn1KxigeTf9ryC10n7V5whzE1d+rZ00pAD2OqFj2tWwwOSTiv1MKKa8Kknl2LRKg9d3wUyq5E4xZAH7WeQ8OfnIYV71K2finU7gJW0X4oxOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ahNZN4gl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ahNZN4gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93537C4AF19;
	Wed, 28 Aug 2024 05:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724823142;
	bh=i8ucd/Ngz55QuSWGsUJplsWlgL3cu3NomNlJtXm7BE8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ahNZN4glXslFTgWnSPSOXPhDAbqHq8nc8FIRiwG8cvD8midp4XpnquG1hGChcmT3a
	 RN2NozosNHLc+5JY7iyEw/c38wtZmGJOvkmspdgdu0wQ94F0BnfWnuevGEw+BYfC1N
	 vk2VDoSQrCp65GEjsObiBjlR2MhVgRJ1AG76ycoxf1Nnqmpraed9qqfK/L5qxEpPCY
	 Awv/WDNm0hspNA2E6rYgdGkaAZyaa2or1GH9V/rOGuT3jtVtO35xnmBsxAAz+U9p9Q
	 YpiEFalOq8/p3JnFqS8Tn29uUGFpqTyi8uEHLhnoI0J6bJw82KwxgZ+PYVjyk11TeA
	 ZTuYy/BGovJ8g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAE8E3822D6F;
	Wed, 28 Aug 2024 05:32:23 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msMPe09TV2mmMFZC=BEXoYrN1foPk3ccgZrozgFU9YZFA@mail.gmail.com>
References: <CAH2r5msMPe09TV2mmMFZC=BEXoYrN1foPk3ccgZrozgFU9YZFA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msMPe09TV2mmMFZC=BEXoYrN1foPk3ccgZrozgFU9YZFA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.11-rc5-client-fixes
X-PR-Tracked-Commit-Id: 416871f4fb84bc96822562e654941d5625a25bf8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 86987d84b968b69a610fd00ab9006c13db193b4e
Message-Id: <172482314242.853602.9836856930863205477.pr-tracker-bot@kernel.org>
Date: Wed, 28 Aug 2024 05:32:22 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 27 Aug 2024 20:39:12 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.11-rc5-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/86987d84b968b69a610fd00ab9006c13db193b4e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
