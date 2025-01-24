Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2161D516A;
	Fri, 24 Jan 2025 01:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737681007; cv=none; b=Dt3jNzAhw6FqI/p18FlIRG92OxhAtOD8yxFjxm+vfhmS2pHWxAgDEZ5yYDkpvmr+z778YkbxQS8QOqJIseBbD84PCbys3FgThVdnm3txBgVwHbkAEzzCq6lQmKDyfkXxQnaEosb8Tpd3DAMBPvhsgdB2IOgOrb2qA6nXLWz5J0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737681007; c=relaxed/simple;
	bh=qOU1I3woVBoq7qxf1dQe4BlB4LlA+pLLKKFwM7P8OUE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=OSQ/VKsOogF3oW0koeJUgxG+6SA7c4KTEiJxqV/DJhfhxenNnygoYYQO2uWlgHE+biizfCFxygt99usjbqWlQxu5Wt7cgTRC+AItQdatvaQlcMq2KEhncHezJA6MWZphnyaq1kccGP45w20YzBRYbBxLzjSXqPyxe+trm1aY0zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d/nmxEab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d/nmxEab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B586C4CEDF;
	Fri, 24 Jan 2025 01:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737681006;
	bh=qOU1I3woVBoq7qxf1dQe4BlB4LlA+pLLKKFwM7P8OUE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=d/nmxEabNvaxA21+X1DaQNl4vb+0UX/llvRUsLjdJu1Cs0dm0zOyeA+PmZhdZaFbC
	 iNRPw/BZup8FdexhNbqIJkYtGCHKEKB/zvzRVM0FmEOYVmqo7blMNV2Xs2D0TesX3O
	 dc8jvuWL9iZhx5fqctWai2g0bzc5G2c+W7nIz85r2024PZravgpYFUhIixkzF9Itiu
	 VKoEc9EE6ZC5ofnnO6CVRhK/1EoctTBWMVnkgJ+E7ufUpGhGcHIAfFq3PEXjQ/4EBF
	 nrUnaoaIXkLCRgakvIOA2veYYd4D0wqk0HMZkNlnyHqmnwqbMbxdgZ9JI/1jOVb1T5
	 9iAWW1SWxBRfg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70CA0380AA79;
	Fri, 24 Jan 2025 01:10:32 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msZ8nseF-kZMsbi9tc6rVr9ug=11AVtJ-ieJqY0qNObUQ@mail.gmail.com>
References: <CAH2r5msZ8nseF-kZMsbi9tc6rVr9ug=11AVtJ-ieJqY0qNObUQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msZ8nseF-kZMsbi9tc6rVr9ug=11AVtJ-ieJqY0qNObUQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc-smb3-client-fixes-part
X-PR-Tracked-Commit-Id: 3681c74d342db75b0d641ba60de27bf73e16e66b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e0b1f59142746f74476a03040f745329c8355a7e
Message-Id: <173768103144.1552388.14963776267512773855.pr-tracker-bot@kernel.org>
Date: Fri, 24 Jan 2025 01:10:31 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 23 Jan 2025 15:23:33 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc-smb3-client-fixes-part

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e0b1f59142746f74476a03040f745329c8355a7e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
