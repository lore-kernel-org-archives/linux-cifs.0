Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA1018DB29;
	Thu,  3 Apr 2025 23:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743722644; cv=none; b=Ay0y7MJAGouCr+PwnmrPotiuO2BjU0QMOc4MzZkhoicJu81JKv1HI8biAuCAJ3UGHtv4xJqCR/UkvLUK0yJ0KdKU27MVYEuGSsqXwRCkA8KUImKAaRM/GAcvUBlSTMWVlhIoDlOMPuTbmXh/+i9R1+ytUlvUiTgn555MxrYN51o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743722644; c=relaxed/simple;
	bh=225QhKbWqeDMrkWI+TUb7k9GhuP8VuhonRSgQFXPplQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=qep+RCZJ4d5ldpNhqBfwAd14vibv2/qjywGmJoIvfJXIWxK9pRH2seSuk9Tf62pn8al8TR7vJ0IIivDcDFP/gJdKOqfzFOQaEZ6UdKJI1feh7VutOpoOzJoH+3EcPUcC03nO424iNQbkDwNNLrmSxv5Ev1lSzgs//X4IU+ouBuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MsLaJ/e4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MsLaJ/e4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D39C4CEE3;
	Thu,  3 Apr 2025 23:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743722644;
	bh=225QhKbWqeDMrkWI+TUb7k9GhuP8VuhonRSgQFXPplQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=MsLaJ/e4vVBSYqDFHQYK2Qy10EQFhi2IvredQrBg6o1JbMMXp6dCrMMfV6+rnQgzt
	 EnWklH+WoSf5lc8Yr8F7SBpUOA6tKXE/CtgfSDbdIR3X+tUPB7y/g9XmFIxbuotHr6
	 16+mDKD7KMKaeokgbTZqoMIc2D/5jWIjF7Db/1fUxKpPtaMFeQ2BpjqTIg1CIEPNiY
	 PJcmpaq2G3BudYVFjIfbf6zmoR/4GphQBfJqJ44JllvhuZuWiU+TRHXrS0j2oKEfzw
	 9JGjcYVOlpn6eage1Rq8PxSP4PYzvx7LYoc8NmkwtTtqQ8tFHUSpGZq1VnIHuYpTx6
	 rwl2dpzeh0MJA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33F45380664C;
	Thu,  3 Apr 2025 23:24:42 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mufSJAwwbVgNTy5eFLtEUNZGuRt9K8-LnKBTKd8A+Cu2w@mail.gmail.com>
References: <CAH2r5mufSJAwwbVgNTy5eFLtEUNZGuRt9K8-LnKBTKd8A+Cu2w@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mufSJAwwbVgNTy5eFLtEUNZGuRt9K8-LnKBTKd8A+Cu2w@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.15rc-part2-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: c8b5b7c5da7d0c31c9b7190b4a7bba5281fc4780
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 06a22366d6a11ca8ed03c738171822ac9b714cfd
Message-Id: <174372268062.2720155.8074107293907031995.pr-tracker-bot@kernel.org>
Date: Thu, 03 Apr 2025 23:24:40 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 3 Apr 2025 18:13:05 -0500:

> git://git.samba.org/ksmbd.git tags/v6.15rc-part2-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/06a22366d6a11ca8ed03c738171822ac9b714cfd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
