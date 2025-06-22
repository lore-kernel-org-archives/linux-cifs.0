Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839181F63CD;
	Sun, 22 Jun 2025 19:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750622122; cv=none; b=J7fKMDuYxQ11LnhY1C7M9GsPWeA6didTMga83FqlFtMYdbJkr1KZgSXT1w8XvTzOUAcND3zLUhSIjlodEn47yKjZg5EfEZSn1usHkSCaTVWN8EsSJD7o8BFWKKuyilcHc1O4WxKN2ynwrgASOM6tsh1Ym32vU4AyIHV3HS+tBR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750622122; c=relaxed/simple;
	bh=8dESysbxctZ3Y0TrGsRY7hLgKzTCY0ECIUiAOy5nPgM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JF/CghQ2OK0BFOqMRoANSADv1oBSACixTHGoXrqoUxuQVfEw/cDxhntbuASP5y7Nc5lL1MKAxZrNOD7OlUJYwS4cmVHXBl2qOfoBpYMXjH3wWPhxDGlZMymTvElp6PLTjQLNEbaQjQdaaw7223gd/gmbbK7j6eKz+FRT1VpwK7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oZ67wxJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oZ67wxJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DBCC4CEE3;
	Sun, 22 Jun 2025 19:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750622122;
	bh=8dESysbxctZ3Y0TrGsRY7hLgKzTCY0ECIUiAOy5nPgM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=oZ67wxJH/PVdmA7rTVnhQ8+SL/OTHoXde6FY9JtglgrA0JqmzNFylKmY8bjKSqHPW
	 3qMEOLO7q2N33a1K8+EEmWtJrYOW8bi91N8PBOfTnSBbfIJT1n7l+Wc9ea5EIXhes+
	 jbNu2JszKEW7WAFJM1EYZhWA2sbfiKWOCEvQT0ud51eAoLJg7hMcQtPeVWJsijE0ca
	 eEgUd3IhGFy6N0taLUtq2aH65buN1y4qjudQZgC+FK9zgoo/lIlqAdsKDrfYi4V/sY
	 HMf7arIAg1fF9fHb04iU0vDeUsVk7FF1AnRsLbMT9iWyJTTK+JFh98MdqU5hmXpSLO
	 NT1Ftp2WxQYoA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EACAD39FEB77;
	Sun, 22 Jun 2025 19:55:50 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes (updated)
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt40T6YE_FLV5pdJcq_4ZBt53VNZPyPg9maoe3LxXPuBQ@mail.gmail.com>
References: <CAH2r5mt40T6YE_FLV5pdJcq_4ZBt53VNZPyPg9maoe3LxXPuBQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt40T6YE_FLV5pdJcq_4ZBt53VNZPyPg9maoe3LxXPuBQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc2-smb3-client-fixes-v2
X-PR-Tracked-Commit-Id: 27e9d5d021dbaa1211836d07a240078bf84b284e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 75f99f8cf445d577132ed97514032d9a3d3e2758
Message-Id: <175062214952.2132065.2310196285716527896.pr-tracker-bot@kernel.org>
Date: Sun, 22 Jun 2025 19:55:49 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 21 Jun 2025 11:10:32 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc2-smb3-client-fixes-v2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/75f99f8cf445d577132ed97514032d9a3d3e2758

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
