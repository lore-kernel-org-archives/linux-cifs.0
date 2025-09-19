Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BFA2D47ED;
	Fri, 19 Sep 2025 23:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758323665; cv=none; b=bNz6rpPzQwVmuhilG4l1vPU2xi5Rdvjy2uWAJqs8NHcwEQTRDGh6Jxst5H8pyiyEhxlqLTYLZQ+dlB4T2bGlAblNqOA7g7QcMfCkjRzPgJiTIUrbCuiIPAarptVwPuZOrm1K8zsr+6du8Q5pNahzj3WIzIlZx9kXfkLyxk8vLS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758323665; c=relaxed/simple;
	bh=XlZdOV/35hjfqDqb+dBQcYYNLPsjtj/xCCdAgVqcKNM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Q8DoGAiKavzh+qsoPNQR2/b74THorlU5Mtlk/+ny0AqmwQBe0RvneIiXC6dH1FFijNsrnGkbkZA/J7X0NXKYF7xgnU58MxwZXAAvVbU/YFkhyoXfNv6tmyPMACPdiuwXl+n1v5/QoKcAbvY6zlt9n1f8BbHPcEFxKzKuEDsxFj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cYOq3dxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cYOq3dxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A450C4CEF0;
	Fri, 19 Sep 2025 23:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758323665;
	bh=XlZdOV/35hjfqDqb+dBQcYYNLPsjtj/xCCdAgVqcKNM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cYOq3dxRXBnJ1ocftWYz5AVerUdf/w2mA+/nL/Z5fOiwH8b/ACKdCEaf9xLF+sxgJ
	 C552vdbvyElwH0LreIu58NOuNp85tVkIR7DMNScYV8xBVyf3J9NR+1qu37mAea9EFx
	 PMh72fTHZpU5tzmIG6MDjgAKornjC3Glp0XMEr/DKtRh9Ip36ZZQp66vpQv+XWZh7f
	 LciSh4ekKdb/HzLEg5/zxdZp642V1lZdDA4R5aj3nqNzLeFPnguwhzfffthUn3+5Lm
	 /T4s3aasCbo+OarGZmeaPU/R9ReK6Ls5w7IlGMt4rlrHIhOEKciLaq4XLuhm9yOecr
	 USGcihLB9aVxw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAE1D39D0C20;
	Fri, 19 Sep 2025 23:14:25 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms1vdZHKz4guZFpR0fMfZFE36eBwdH+fapaW-i1tOTSaw@mail.gmail.com>
References: <CAH2r5ms1vdZHKz4guZFpR0fMfZFE36eBwdH+fapaW-i1tOTSaw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms1vdZHKz4guZFpR0fMfZFE36eBwdH+fapaW-i1tOTSaw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.17-rc6-smb3-client-fixes
X-PR-Tracked-Commit-Id: daac51c7032036a0ca5f1aa419ad1b0471d1c6e0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cd89d487374c49f18a8c4af312ecc74d997f3b07
Message-Id: <175832366464.3732828.8309327723878148075.pr-tracker-bot@kernel.org>
Date: Fri, 19 Sep 2025 23:14:24 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 19 Sep 2025 15:22:35 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.17-rc6-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cd89d487374c49f18a8c4af312ecc74d997f3b07

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
