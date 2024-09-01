Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6935F168C7;
	Sun,  1 Sep 2024 04:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725163309; cv=none; b=UCS3VOBmSz8snacVsJq81InUpaM4FZzx0QyCuylPQ88P0ye1J/pyfR1A0v8gi19F/oMhczqAXbqnOh3/fP2Uw5hrzPBCRdF2cgJlBTh1MZJfAVy1sKJIae5uIQTvAZ8jbcqEpLt+SDZ15IUCIOK6hXJP+didnoBMkNVYy6mgOTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725163309; c=relaxed/simple;
	bh=gD+opfgO6/cFGcyVUxtebJ8PQ4e3LjwTfgCDZvVdPbg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=tTWtVezhzRrkpSk7Yl+ytWPmNQY+EWYCJhyT2u0pxpWqaj83JTal7FF58UhSHghRDS30szzx1KtrxnbxDnJz3BJ1mmvLj9rkpnYxiJ4apLfDt4Q5IpPwaco6Hi1IqGyDoOQCZxg4PvVAamUKaBs3aFGIlLvtI3nnx3FKcjKoAs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NF8Sj5p7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NF8Sj5p7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01478C4CEC3;
	Sun,  1 Sep 2024 04:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725163309;
	bh=gD+opfgO6/cFGcyVUxtebJ8PQ4e3LjwTfgCDZvVdPbg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=NF8Sj5p7ZFYwBN2UvUH/cvJLfKdSOSD2W+9XG7Q8g7YQqrjM1cut70YdvD+WJjhEZ
	 LYUJ5fxyGLjN4yYE2/3cIfTgX1+DTnI41huOu7ebAgC/7BvHluKnqBzhzNKVJZC21H
	 8Ea54HsLoZ7/q+7pV+6ryspGybHliPQM+DwIDpfXABOdt1Ed8l76Drmfzj5Yu0+Ydh
	 qzoNcdfFkcPeehKVUC9xLVon5gYtbAZycHsnnFebiXsDrMG98o5G2q+ruTgIoq4jYG
	 1ybQKlxXLewi02xGbNSGdgZKAYPt3U5IviUoHR0ZoNJ/AowzFWarFUSzuDZVIOBDsl
	 nmUsKkNEu4Gzw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE5DA3809A80;
	Sun,  1 Sep 2024 04:01:50 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msC4LbpzLmJVvkg-9xGXT051dNc0PwbY2dOobvQRb2O_A@mail.gmail.com>
References: <CAH2r5msC4LbpzLmJVvkg-9xGXT051dNc0PwbY2dOobvQRb2O_A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msC4LbpzLmJVvkg-9xGXT051dNc0PwbY2dOobvQRb2O_A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.11-rc5-smb-client-fixes
X-PR-Tracked-Commit-Id: 91d1dfae464987aaf6c79ff51d8674880fb3be77
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6b9ffc4595ab936b10834167037acb992ebac34a
Message-Id: <172516330932.2978237.7360903486407516306.pr-tracker-bot@kernel.org>
Date: Sun, 01 Sep 2024 04:01:49 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 31 Aug 2024 22:41:35 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.11-rc5-smb-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6b9ffc4595ab936b10834167037acb992ebac34a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
