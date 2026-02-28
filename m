Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E7835F171;
	Sat, 28 Feb 2026 19:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772305442; cv=none; b=iYzRA6ITC7N+Gxl1Zkf+heFs/p+PErAod+PWVqp5IMzR9LghEBGrQik3AiOoBapSJ4XNEFOpvLhKVXiWPRxWZVk7woBUiULFAY/LTHivr9FrsyG5R1pk8IZzewnX3w9J1x6oL3IT6wBREX0TAXnnOuMI+lsBKINqVoV6bmVBAVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772305442; c=relaxed/simple;
	bh=OL3L694dMLoD77w3n1IgSIGxh8j6f4LCMkDb2WdGyPA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=b5WO+g0w2xc2vtpmRwS/3MozY2MQKVHak5baU0ppfhXi9IdmArXubNSs3xu2UZwrkWMIh6RK0pH7XlXzXdq+h71tGsYsA4HU+i+dgT72SDuytQDLVmR5BizjkUO211TAVH4H4X6pD0xElLZfcVcAA87qgul63olV7LOiAK0StJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gy85t/u4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gy85t/u4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74061C116D0;
	Sat, 28 Feb 2026 19:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772305442;
	bh=OL3L694dMLoD77w3n1IgSIGxh8j6f4LCMkDb2WdGyPA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Gy85t/u4uFyVhBxlViLhH8lNumSL+iFH0e/m9HBne0H5DKpopHotq7xvZH22f9RS4
	 wyCfG3ZSyxqGrRhceMiDTurYxeaigDFsc8WHcp5Ff3QpLyTEw5FmM+pPHK3QjWTK8E
	 7CDi3UGoSmeJwegwrw6XuKZ1zr1QJKZMAnzAtLO9eHNKf44LnZPjx1mD+dHKgrME7Q
	 UA9ks2QrUifIh8d2m0rwY7GgAl/S8TOvoDM6od4zPhLn8P9JaxetMwicuuN6mTQc1a
	 zd6zwUWFcWU4mFmkaEtRyQpsYEcbTrnIpAdkE4NBezBna/t/wIT9wRy9BlEqgyZLm1
	 +REdkdIAr3hNA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA19D39F2022;
	Sat, 28 Feb 2026 19:04:06 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muiqKXDBeubdQPmxN_aqxsmSp0xoSLYV6mmm053VAnBCQ@mail.gmail.com>
References: <CAH2r5muiqKXDBeubdQPmxN_aqxsmSp0xoSLYV6mmm053VAnBCQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muiqKXDBeubdQPmxN_aqxsmSp0xoSLYV6mmm053VAnBCQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0rc1-smb3-client-fixes
X-PR-Tracked-Commit-Id: f505a45776d149632e3bd0b87f0da1609607161a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 42eb01783091e49020221a8a7d6c00e154ae7e58
Message-Id: <177230544522.3042872.10227444892821906862.pr-tracker-bot@kernel.org>
Date: Sat, 28 Feb 2026 19:04:05 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 28 Feb 2026 12:19:25 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0rc1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/42eb01783091e49020221a8a7d6c00e154ae7e58

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
