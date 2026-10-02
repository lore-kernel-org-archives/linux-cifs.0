Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B57E33AD88;
	Fri,  2 Oct 2026 21:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790975482; cv=none; b=Bw810X3f5G5A0yXZS4S1Don6VEZ1fGJr2MIeG4+U5xqbcn3oA4D+kFc25nMKi2uIIQydCPuAehmoti6UDlol9ivAu1wuOcwwvzn5jjVw9VYMMc5iD/ysA8XqcSiMFgwB6ZYMpQIQlXVnjqDw4q0UPsI6eDGqWZNDsfJBH8IDN7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790975482; c=relaxed/simple;
	bh=epb/pTgDiHlKY/1lndx0/zeuht4ACtMQnTBInF1rjIg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=I2Uyn56CF6n1ccVx4eZKgMShIIt2glhO+96ieEXwddvhXYP0zZ3uAGePsJf+z/mKJPy0R+d60zoCO4OxL3hzkvcto6mR3CwVSrVlJ1lPo4abvLS6WEjumISmscolvCq+VswjjffYN6peBIDIzJbssGsq4Lp08Bk9dIH7uT296MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XXdSuK8q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XXdSuK8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090C31F000FF;
	Fri,  2 Oct 2026 21:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790975481;
	bh=VeZoC8wnvPckVIOR9wRFK/+DXTqDin+bqdpsn9fPCTg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=XXdSuK8qzgPffIPYiuV9hV6ba5jEMrcl9JTmQ6w2YbRckzcbx6Jf0ZjFcwHSNXsei
	 4r7vqlY+N265ENjuzTSHgs44QpKXZC/XQTSPIKZstXPmGaV7L6kWIkQy9tHlNndQVs
	 9/kBOjnY25sYlkDWN7fRGulOeZgkrvnuRB+IeweDHbvn7lMD1YLmOlltkbr/AW4kB6
	 a9ogOedDjoZlVuHb3sTRv+w4piWyFGgeq+BBrOyExK6j3m/t+YFrXY3k2PLCnOHGbN
	 y81EzUohiYhDDCwjeDg1b9Eh9j3nroEgqcfTTkRV3GpljYNQdC4yvSs/SBCURu1H1J
	 tUNGXQ5mBWqFQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F16533811A72;
	Fri,  2 Oct 2026 21:11:20 +0000 (UTC)
Subject: Re: [GIT PULL] smb client fixes for 7.3-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <7af974fcbddc7e739dc7d18aaf1ea69f@manguebit.org>
References: <7af974fcbddc7e739dc7d18aaf1ea69f@manguebit.org>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <7af974fcbddc7e739dc7d18aaf1ea69f@manguebit.org>
X-PR-Tracked-Remote: https://git.manguebit.org/linux tags/cifs-fixes-7.3-rc6
X-PR-Tracked-Commit-Id: 19465a9aeb664f1d710d0d22c07c31bfb7c85446
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ff47652a4b66c067c765a7ad464d930b5a9367cc
Message-Id: <179097547951.3587474.14332160813562131151.pr-tracker-bot@kernel.org>
Date: Fri, 02 Oct 2026 21:11:19 +0000
To: Paulo Alcantara <pc@manguebit.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 02 Oct 2026 17:42:23 -0300:

> https://git.manguebit.org/linux tags/cifs-fixes-7.3-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ff47652a4b66c067c765a7ad464d930b5a9367cc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
