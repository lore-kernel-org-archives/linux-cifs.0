Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC4317736;
	Fri, 24 Apr 2026 00:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776989643; cv=none; b=EX2s+/1DdQZZLGc3UHBBDQgtlXfx336F+wzZHqo6O3ElPXjhK3eSmUJRA3RhnN0ntCF/IsARG985YEIIy2MzpIcFYdkmlUFScpn77zYL2NW+Wr4C1DcQJrfUEgsqJUU4OXeceiU0Z17doCsHumO0qkoF3os0kTTe1IlfzKlPcRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776989643; c=relaxed/simple;
	bh=xrCNOjtIeugz3q4upJ651hRB+YA6RSn6sI6B/72mTyE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=bp5rZG/ye3YbjzIitdBGFtYuiWTMT3yvTEWF0ZAYvLlpxiDPUumbEXlMYkp43Z9P3v/Q4/rSOOijMstti1yiXJd0p+7DS1mI3HrfuOAIf9TMaurTGM98bE3FfqK6xmncvx3+H+BCtNIgH/DQjVd2Kc2rrHZ/V4XbEy/HT8exWlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XZnfTdLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XZnfTdLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254A7C2BCAF;
	Fri, 24 Apr 2026 00:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776989643;
	bh=xrCNOjtIeugz3q4upJ651hRB+YA6RSn6sI6B/72mTyE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=XZnfTdLIjC5C2lA/n+RfbiYIr4vmJvlTrfWHe3mFQBLX017axUY7x6CTaSUsae0Xo
	 679Cnw6vp153wZDBJ8Ci1gNUupTNliyXWhVTKR7HcvjsCruJtTjRkV+psPa4H6wPZk
	 eMxF2UTffjmoiTLTJT+bhXBwIHD9Ika7JUMPCMpdVyDb9pYPLnhwtyTIYZlONbWdka
	 XcC1AoBXGUonrs2mlWaTmDHFnece2mUd4ZgccUtaSYX8LwG+gqnDsmujbLtuJS7lLn
	 5HNYTbJZkfOsgB8wHfdgcgi7GHZ2oeyV1oH0W5gYtkVry3QZiY+6VUM/CCax6xfK7b
	 Ou/4kK3MVDwJA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CFAB380A951;
	Fri, 24 Apr 2026 00:13:25 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msLsRyRyu0q68y8hWMMO9Yq_-yA73Q0=owSY2hbx77BJg@mail.gmail.com>
References: <CAH2r5msLsRyRyu0q68y8hWMMO9Yq_-yA73Q0=owSY2hbx77BJg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msLsRyRyu0q68y8hWMMO9Yq_-yA73Q0=owSY2hbx77BJg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc1-part3-smb3-client-fixes
X-PR-Tracked-Commit-Id: a83307f34e0bd9b0e595b1074dc8fbcc1b7f3172
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d0ed69f3e380276e7ab36f1a3f19702c5e993915
Message-Id: <177698960400.818077.13743625371075604493.pr-tracker-bot@kernel.org>
Date: Fri, 24 Apr 2026 00:13:24 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 23 Apr 2026 14:32:42 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc1-part3-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d0ed69f3e380276e7ab36f1a3f19702c5e993915

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
