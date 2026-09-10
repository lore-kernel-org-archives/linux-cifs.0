Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7353E1CE4;
	Thu, 10 Sep 2026 21:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077222; cv=none; b=ecssk36Sr5yxOmxRhAkYnJ2zlgO7egzWUrujy5lN98mT2A9zMomvb7Uyx5z1/87sa5K6mEhSQCplLe2dQZo1NYQmx5tl/GmtlaVq4qnpuYn4WGSCaKSOfJ0ZeVJ3wuEocFP1IUo4jQJJ8zMOt7yDDb+WUFtyHM1n3Ri0KaqVKug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077222; c=relaxed/simple;
	bh=2uRrYfnR/DmWma9Ddr0rpxNPtolzFhcMsecV+IN60Mo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=nOCQVUW37gGiiRsenjtmeFDVknQf9eRVHUFIxAqXEKj9lrPcpuJJwZsk9DIDlcqlQ6ZbSo+NKDjG/KdA6NV7B/XHg+vlLZ0am4i+zlRWcLBlCiUzgqxh0DPU1ZZ3eIPofpkvqrWD3Br8TbRqICeu9DFGBWveJRMOuEHs//Rb+3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nUfewBtM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nUfewBtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD3A1F008A3;
	Thu, 10 Sep 2026 21:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789077220;
	bh=1IPBvXzUld8PLQEmZvNNb6cS5gRjJ2IaW+OwbDGmTTc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=nUfewBtM4XPw5ugAwLos+N1KykC8IzLU1Z1sT54HzWzhWuuJm1hDfnnpbgS3rITkd
	 uCsSU31PlRpIEvqp0Zl759EiFq5R23tdQBjsDjhcleY0S9VQXXzFuBOzLDV1EE2vAs
	 vUQxLGfzQrgBJlG7TOa1PzwH/xQaR72JR6bydADhneW/voidfbkvXxCeXeotGm0olN
	 tjZ1T1WRjK7gaOTkrzVwVnEXPs3tsH+/ONLdZgZI1PMw9YuwxEzHEOSVL92wG/Hyin
	 cO60C3o279VWKfm6MdYYJ+k/BOMQmUL2yLw/YcuPrIOSbhKUEZ4FSlVVa3Uee0crhp
	 VST7fFCjDEwAA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56A82380DBDD;
	Thu, 10 Sep 2026 21:52:39 +0000 (UTC)
Subject: Re: [GIT PULL] smb client fixes for 7.3-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <bb769b6f6f976d75cbfca3ed00556bde@manguebit.org>
References: <bb769b6f6f976d75cbfca3ed00556bde@manguebit.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <bb769b6f6f976d75cbfca3ed00556bde@manguebit.org>
X-PR-Tracked-Remote: https://git.manguebit.org/linux.git tags/cifs-fixes-7.3-rc3
X-PR-Tracked-Commit-Id: cb26524ef4ac28fcfa554c0656e8dc412c38a8ff
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0a96d0d726cd380423ac38e2c28f538db2940a1d
Message-Id: <178907715793.2100681.9680077125751104548.pr-tracker-bot@kernel.org>
Date: Thu, 10 Sep 2026 21:52:37 +0000
To: Paulo Alcantara <pc@manguebit.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 10 Sep 2026 12:45:41 -0300:

> https://git.manguebit.org/linux.git tags/cifs-fixes-7.3-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0a96d0d726cd380423ac38e2c28f538db2940a1d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
