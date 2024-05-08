Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501CE12FF97;
	Wed,  8 May 2024 17:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715190380; cv=none; b=SPjduJpwbSoy7LfdWS1OJRfo4tegH41TkZ+OS2+78eW66tY/af2OGGlEHsLkmY4EStJQ+CR1FmnAsJoxfohQe7KmwxVJ3K6byIufFawIhK+k2/FhLg8cmGoFrgdgtLR+6nQceEaTWvOJsS1faGtmKoZY+QYkDpgi6Ex/Okz90Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715190380; c=relaxed/simple;
	bh=ZI2jC9TyQ0mNj+AJSzhcLKAVtTaBFzXXG0XRxB4cgSs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=KuyBfT1ZxPXrekmDNRXm/ZStTJAs3L8Ht3G6WK91+II1qxveNK4O8KPBNXRH6vueHRj2TlhSH3RXWge6bl1CYiIMrF0RLsfPhqVd73b3GA3ibdNWEywVdl2zBv2vxpzIr5QxOONG3wV/XIo1n1r2NPQrJB8+2vTVEd9XVtNKVvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iryrrzvb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iryrrzvb"
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFFF3C32781;
	Wed,  8 May 2024 17:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715190380;
	bh=ZI2jC9TyQ0mNj+AJSzhcLKAVtTaBFzXXG0XRxB4cgSs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=IryrrzvbMM2YVIEBFGJxmxSsZPJmA7wcdUCKUhNrz+TndyWBpRhMQe2Uo2dR1WVX+
	 Fy510PPUb1OU8qNuOSZLTWW3mH/ELJxaHMS9DqANI9jzKZa43NkbSeGVoFEuXe0v1Z
	 tab4eLN2HaecveI0u+WZ/nWfF/Lnd/C7PjvaIiI3Im/ot86hlUxltOgOxXFnnNQ0nr
	 zs6xTwOlfPgOkUKOWe2iB/jEktn0Y5yD1BgDkBFywsM6h7pR0W1x0iAOZH0280TMzu
	 pybfWWbdb2pnbIOUpl/m5hMGFc1EBLWexlpPkV4bihSS1yBtV8mYNKF80L7XsyiMUg
	 GnUvzFaEU7QsQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0C96C43330;
	Wed,  8 May 2024 17:46:19 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtdSGPTs-FEWJFzn_uED8Ni0LLSCXbrRs2s8nrxZt+3Ow@mail.gmail.com>
References: <CAH2r5mtdSGPTs-FEWJFzn_uED8Ni0LLSCXbrRs2s8nrxZt+3Ow@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtdSGPTs-FEWJFzn_uED8Ni0LLSCXbrRs2s8nrxZt+3Ow@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.9-rc7-ksmbd-fixes
X-PR-Tracked-Commit-Id: 691aae4f36f9825df6781da4399a1e718951085a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 45db3ab70092637967967bfd8e6144017638563c
Message-Id: <171519037991.20720.11614586608711913696.pr-tracker-bot@kernel.org>
Date: Wed, 08 May 2024 17:46:19 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 8 May 2024 10:19:07 -0500:

> git://git.samba.org/ksmbd.git tags/6.9-rc7-ksmbd-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/45db3ab70092637967967bfd8e6144017638563c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
