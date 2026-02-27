Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B021E2BF3CC;
	Fri, 27 Feb 2026 01:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772157394; cv=none; b=QAnYCrAlKzpDEJxWAaqOn2HIo+10jZ+emMFiWTb+2fU1V45kOBOqz1D+Nn4UxOvW6YcQYDcxSHHcY8wmlYSkD1eo1NExwu1Upxc6eIshd1F0GWTC5ykpjxk/hy94UZSVH5loM9fHhrnuV8g090btj/jYTzXl+plPJSSb+z1Q1iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772157394; c=relaxed/simple;
	bh=9OyKRQ/mjeqbXpiDlAl5Ls4akfRw0KgouVAGYUx/wZM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=YQU9aOW+Y/xVU77ubqHVGMKCku94GRtcuM3IqmE5GfRZNmkpK+tqHn9Tc66cjem4fm/qfJIYIgAbWXYW6xVs1OsQ7No0KbVsVCU6yWUNkiAnjrwM35wHSUsGfs4lwo4xm40FWGoJduFhYv8sNa/V9En84ETya08kPw0Vh39G6NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y6agt1rR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y6agt1rR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910CAC19425;
	Fri, 27 Feb 2026 01:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772157394;
	bh=9OyKRQ/mjeqbXpiDlAl5Ls4akfRw0KgouVAGYUx/wZM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Y6agt1rRUd/FYZlIOCRsZy2RpoKG5e0ciHOq5sp2YE5aSU7sosvEFZFa3gZM0H3Vx
	 oSWdTP+7OYT9H2719MC9Av2R3Pfq6PPn7j7QIhVBy3E/3xtW1ZzYTdath9at/XshPV
	 VQhbv30MzRjyVtF0KdTui4HIh4UukXsZJ858GIQiGscHK+eag+8X/blAqYUQvOgESf
	 FHPx0WhmL9T65enb1Rw9sCnY3mGm8sOAigoORS4SRRZwGbwf5lv6YmNDXO7Dh+BdDv
	 FdAx3E3zb9zMEkE0CkUQr4HxGcoXfV9gJ7Qwt0z2KOQlSfZPBPSuMfASP3Q2Oo/BbO
	 z60Of4tEpFM1Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02D51393109B;
	Fri, 27 Feb 2026 01:56:40 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mszMp8yO6oUHPeCKCo5iqco2L6cJ=MnRXuBusBNrdd7Sw@mail.gmail.com>
References: <CAH2r5mszMp8yO6oUHPeCKCo5iqco2L6cJ=MnRXuBusBNrdd7Sw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mszMp8yO6oUHPeCKCo5iqco2L6cJ=MnRXuBusBNrdd7Sw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.0-rc1-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 6b4f875aac344cdd52a1f34cc70ed2f874a65757
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a75cb869a8ccc88b0bc7a44e1597d9c7995c56e5
Message-Id: <177215739844.1937342.12748559864600898922.pr-tracker-bot@kernel.org>
Date: Fri, 27 Feb 2026 01:56:38 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, "Stefan (metze) Metzmacher" <metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 26 Feb 2026 17:12:54 -0600:

> git://git.samba.org/ksmbd.git tags/v7.0-rc1-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a75cb869a8ccc88b0bc7a44e1597d9c7995c56e5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
