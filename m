Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7FD5339B;
	Sat, 15 Jun 2024 19:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718478913; cv=none; b=dpK0V0vQAk3TPY8Ls6Pfg2TsWNapsDKsL9HVj1sAUkGuNqzgbh3alIUreViZ3DSfKQ4zXoozUe8O7huzSZ8GcDmKQjpcnIBtd4lRVrzmBz3S0HhZlRdPV16IOXfY8AFY3IPF1uGDEKVU7orTABO6l/THwCW9JmfB9rBvmRKCdrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718478913; c=relaxed/simple;
	bh=1MDXDhN6Yyk/5jKBI8p8aPaF8BXDR+lYqCD+8ltTGs4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=IRl7UeLjwcOpG+TWtCjeKp+JZIF+Rhm1lqGDlbJYXrsIJcQApun6aZDmfZbgKpNdoitej0EcW8qsEwCFOklWFrROwSK1+OWzqJUQ818dQH8Kf/YZ3DkIdd/oqL08spP6i25Vgi37nt752rZpxLUBv2FY/ykrOInhOWgkusjiSvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ABLJrL8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ABLJrL8T"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15A62C116B1;
	Sat, 15 Jun 2024 19:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718478913;
	bh=1MDXDhN6Yyk/5jKBI8p8aPaF8BXDR+lYqCD+8ltTGs4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ABLJrL8TlyLU3NcvlM5zDrZD3Ad+BYxTERT1MW4SfMXKi1sMUNydOrwlCmbsewD4b
	 FrNN2JE3zCD94ngWNTnYN8f/Dc5dwzknWg4DFtmlFJEeZ9PLRbMHWDrgjyntCsNqbz
	 O1zkH+Z26/WPWPJszyNJyI5UhbY71NXMZ2VW/A8NfwdIuDQfxUxJfqOkTdwgLW6AWq
	 YNRA2HgR52VkBSbi6upg7sneWSngc8M7WhVIIbNznSCcpQ2NsvDdtt3yN+036O1uU7
	 Wi5/rxcL/COmwURofmz7HP7xGocDlAZno/IScXnE0IAFgOiB6QOzK/9Dx++Qx7JzU+
	 6D5ZGzTchK1ZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07133C4332D;
	Sat, 15 Jun 2024 19:15:13 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtj61t0AH6wDZ=k=rzGjAuYngLZCTYtw7AMT6ZhJcyWXw@mail.gmail.com>
References: <CAH2r5mtj61t0AH6wDZ=k=rzGjAuYngLZCTYtw7AMT6ZhJcyWXw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtj61t0AH6wDZ=k=rzGjAuYngLZCTYtw7AMT6ZhJcyWXw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.10-rc3-smb3-server-fixes
X-PR-Tracked-Commit-Id: 2bfc4214c69c62da13a9da8e3c3db5539da2ccd3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 62e1f3b3fdc026aa244982533ae8e05bd1b9ee77
Message-Id: <171847891301.12391.11921407115997454069.pr-tracker-bot@kernel.org>
Date: Sat, 15 Jun 2024 19:15:13 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 15 Jun 2024 10:45:30 -0500:

> git://git.samba.org/ksmbd.git tags/6.10-rc3-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/62e1f3b3fdc026aa244982533ae8e05bd1b9ee77

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
