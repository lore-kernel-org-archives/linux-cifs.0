Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC787305693;
	Fri, 15 May 2026 22:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778883229; cv=none; b=Cl0QywB0D73Prw5uJuYZCKSUt8V1J8pDvB/SAueg3lYkIUMrvyZZcpvRdwOKOqx/GUfhH4wrkIfTNEs6q6Zu1x/7qg22XnapC3ktXBvp842/9DzRR9bkTto+S5X6nS9UBrq3FZSrtY6rQ7qUF0c/HwfSAEJKZtgABtmAgcd1koE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778883229; c=relaxed/simple;
	bh=hKqVRZEOe9SzgcK0rW01H11ARClqYccJPTvR1v91pU4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ND+KQsHTCQV0tb4otcT4j6unXozUHDNnICsNLW+hQhAyQP63sIy3KknvcCr1LvKEs5HqIzT8I0BijWV4Xql93Y9vHko8JOQJ+b8ngW0yFTxA7tuwLxeDhRxL1h0RAQaXMo1063By01+YWKA/z4syFIG64wQ8m3U6Xq4CozHcf4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YP3jm/jG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YP3jm/jG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F85C2BCB0;
	Fri, 15 May 2026 22:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778883229;
	bh=hKqVRZEOe9SzgcK0rW01H11ARClqYccJPTvR1v91pU4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YP3jm/jGBTGIsV/1TKxnUcylxYhQJ4FGQs/GuY3Iz4k/G6EYyZ81qiII0qWU9XZmC
	 ph93LpuXmRkjXF5KRhs3da/G90Tdtf44TTFMIBt6Go3cQWmpzUKayYyM/fXSN1BpyT
	 cbdMKz3p3ZuY6eiCF3aEUyH/rxjVUp0XgK6W4iEcjxbCh223tHszHwqe0epPr0nk84
	 8jvh18CJO/CW54KCjG+IQxj14FFcu+RTuUHmpyvwuy3r3P6i+Uw33gjCTZu3poLovN
	 HqmXFs7pCuwGF4qJO1Q5SqVg9QUVLi8ggmqUSx779pXXz66885ygFhkk7GWSCotLJ+
	 QleoDynimSQ4Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19A043930A12;
	Fri, 15 May 2026 22:14:04 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvGAbdCXg8uJ2NrFWLT0kB1myECtq5B6ttcXqdQ-SXE7g@mail.gmail.com>
References: <CAH2r5mvGAbdCXg8uJ2NrFWLT0kB1myECtq5B6ttcXqdQ-SXE7g@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvGAbdCXg8uJ2NrFWLT0kB1myECtq5B6ttcXqdQ-SXE7g@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc4-smb3-client-fixes
X-PR-Tracked-Commit-Id: c207f1d785044667f87cc8c72355e33f3981f2d6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b0662be9131d87d8858d34d6134500e109dff958
Message-Id: <177888324264.173168.16527408889934157565.pr-tracker-bot@kernel.org>
Date: Fri, 15 May 2026 22:14:02 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 15 May 2026 13:44:45 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc4-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b0662be9131d87d8858d34d6134500e109dff958

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
