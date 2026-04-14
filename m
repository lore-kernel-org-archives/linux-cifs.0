Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2706C1F3BA4;
	Tue, 14 Apr 2026 00:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776126613; cv=none; b=AFJpxrMuNEtxhfQHMvcg7mTvbf4pfedUNi3y+t+5iyc0I0/+bbN6Gin3IfG2bf6WufY2oodGhLnLgQfyVZwP1ym8e3hXDxs1caaIh4kjMVF0Clfn3sO+hr7C+XB3j0LexnElPp7Ovzg9vjGavabxx1uZjjo2Zc147QfI7rOw5dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776126613; c=relaxed/simple;
	bh=JzS/ROIW+p2+sXRU1IlMRbW9D2wiXc9AblBpPDJUujw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=s3u4LkQ9wzWaYS7a/U29GDcC/cq3sEFwqqBt/TJU0omA/cMk56CuAffWrXGcvQYtNJkAOcYyABz2p9V3xHVE+pPaBTwaa7JRj3QR2jSZc/Px6h3cJmWSSxNDKyb9ZE6WuzEufJwxrTiOOIfMESWs6PDTz7uuUIA8oilwuzguUsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iL0qN+CL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iL0qN+CL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1222C2BCAF;
	Tue, 14 Apr 2026 00:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776126613;
	bh=JzS/ROIW+p2+sXRU1IlMRbW9D2wiXc9AblBpPDJUujw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=iL0qN+CLfZ5LsbNTsMNypVXV7A9mErV2tFcsv35xaEREEFQFupZAkpFnLeC65iEZ3
	 ++HS1qLkUVqRpkp7oxf+ZqoRr3tITo4cwtf7WOz7Nt1fPvmF5qLXhgJAhffc09mRyz
	 umdIrTXk2dgqvViWTqD9GVWmZGJfg1IkGOBhVLiiZnGACXLtm9y34VLHDPIPLIZjlF
	 MZFWYhWToHd47aq6ttAeLJ5bPAVNPZ8HM6rIOd+dcS8kNjk7PCNwG7nXkeXcXg0+nC
	 Ivf+uYtWae/3tjtvF2RTg9WP7PWND8QsjiH4Y1EqqCZSterOULRIsmeSVDVjG50m0T
	 qtzME8knJz/jQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 4BE5F3809A0B;
	Tue, 14 Apr 2026 00:29:45 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muW_D8eDN0iN7kzFV0km+QBVZn087+AGHTeSHm0E-KqYw@mail.gmail.com>
References: <CAH2r5muW_D8eDN0iN7kzFV0km+QBVZn087+AGHTeSHm0E-KqYw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muW_D8eDN0iN7kzFV0km+QBVZn087+AGHTeSHm0E-KqYw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc1-part1-smb3-client-fixes
X-PR-Tracked-Commit-Id: 4248ed1013816f97f4029d06b16c67a6e43d0668
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 81dc1e4d32b064ac47abc60b0acbf49b66a34d52
Message-Id: <177612658416.618768.14233069905235826977.pr-tracker-bot@kernel.org>
Date: Tue, 14 Apr 2026 00:29:44 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 13 Apr 2026 17:06:16 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc1-part1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/81dc1e4d32b064ac47abc60b0acbf49b66a34d52

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
