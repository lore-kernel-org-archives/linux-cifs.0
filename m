Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F023D6CC4;
	Fri, 25 Sep 2026 20:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790368382; cv=none; b=H4TMmYgsFqUpkABF2uONhK9OUjSaaEaougcos4bHv01Hqg95FHkYQqvLb8/QarMKNI+Gb9Dejg4OxeZO41EKR1MblP8yZa7liECmsrzL6TN9L5m3HuSIjuh34cEE3ISfAWonq4LCNtZ9otf13MF9J3AdbBDtzL57zM1zTza5HJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790368382; c=relaxed/simple;
	bh=+HkF2QLitTG1D9zI5EOI/RAoMV1k44O6jcQPl0VyzMw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=lm0pCCDSL3pKaFrqph3smhPqG8uY2KXuVbrL/mAB4Xy/dzPU5q4vmj8SLWPu2CbunxfcwFMm52ooZYDe3VGDsgyn+9RNQzAsD87JuKctldi2iBx7ute+ys1UcTTls4/3Z2CUkj9XLwJAsmbzpK9UfB0zE45vU4/wKgXycaxlTAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MDYIYp4Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MDYIYp4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A60D1F000FF;
	Fri, 25 Sep 2026 20:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790368380;
	bh=EwkkJeaLLeNA8mbsgHYntn3W6CcL1fkL8g47UYXE4Ug=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=MDYIYp4Qh8J6B4RNk1AYq+nn1sNaKuRVYq7cHBPO0HDH+YZVBTTh+pZ6ubgGJ1HbQ
	 AGCQCLrQO0+Tp1HHNarKax6PYSuk2VKoIO0Fa0RETHCioE8Mpi4GMfyOKQHGMYmh78
	 DInclZvu/BF/S64E+k3kFzcs93MciXvxOx24aYk9msEa+O+odx7bB0W8+zQy4ykF+G
	 QT6cXUf+BG+BDOpKOnS+/MkNvccFI96S6chUePBKxawtdMsB4hKU9gV+J5DAencYAX
	 8eEMvhjlc09mJwAhPU+6VNezPfbEXHzUow0WoM4gxHanLP2GbOySAkhqD3VkG9efVG
	 eEQq3t6a4g/rA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 79C6C380820D;
	Fri, 25 Sep 2026 20:31:49 +0000 (UTC)
Subject: Re: [GIT PULL] smb client fixes for 7.3-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <b3008a6b831ccdad2e1f403795a2d568@manguebit.org>
References: <b3008a6b831ccdad2e1f403795a2d568@manguebit.org>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <b3008a6b831ccdad2e1f403795a2d568@manguebit.org>
X-PR-Tracked-Remote: https://git.manguebit.org/linux.git tags/cifs-fixes-7.3-rc5
X-PR-Tracked-Commit-Id: e66cf1625ec4a3fe68346119f371def713fd0a4d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f14572c203d57492e1d4e5d7851a3b143e083b82
Message-Id: <179036830828.3137666.13040716630985187628.pr-tracker-bot@kernel.org>
Date: Fri, 25 Sep 2026 20:31:48 +0000
To: Paulo Alcantara <pc@manguebit.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 25 Sep 2026 17:15:23 -0300:

> https://git.manguebit.org/linux.git tags/cifs-fixes-7.3-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f14572c203d57492e1d4e5d7851a3b143e083b82

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
