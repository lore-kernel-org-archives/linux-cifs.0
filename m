Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794595180;
	b=MF9CZaMQiXbhbuRSFCM7IRbh7mervYuGL2Vmc8Ne59tuhaIkxH8EIHgJR8cvzkszyS6W
	 obMKVHAg/cln7otjfhFdWA10rC3cU8tcmgRUpQM7NKtHL8yNtWwcYcY9zKexbzMAq2zsa
	 lpwj2ad3p2rWzGkuJIWBT/rkoN8yHuCFkY5gPI4wb0i7Nejg2TA4N/BLqyqsKECaBPloj
	 K3zkUtBL+P9BCU+MCMuuOvVwa+FZ1vy3hq005HlTJXo8r/YsYxk9Bvax46EU5luocp4Kb
	 Smj/HMRW9cUMYm84ycDJ2XMNrECKtnBROHgBwGIzKhkigMHD/ZmSz1v+cwpTf6EZL6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794595180;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=wv23z+xItheor5swVqHxPfU5ZMgwYhfd4id4yMFTyJ8=;
	b=CJr+K8CUDsF+U+tqGC4pJyxqZgHS97I0LUyRpmuDsU6qPzH+7+IoTtrilm2QhLt1KxMk
	 kIYJLHts1LV4nx9QgmXuKIaeD/2JQlYKbz8xUr0ZuMvvwXSUZ9YMmE4jdqkNiZGL6oQFt
	 FTGqdn9me2BKg1QcZa7/dbRk2+z0rahHB3m8XhCNodjPP6IneImySkCwbBY/RbUGFs+RG
	 kzQFRotYuv5A8mW4tRfnpGzhf6xGkageM4XGHbaDOzg831AxbuiPA2nqCTGwnjzOAn/VD
	 nQUBnIsMuXqGeqLgfzs8KyczuxbwoYP8bLaPOA1hYn7vwF3efMvEriy08NkTle0rfKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NrT4untO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF86B6071039;
	Fri, 13 Nov 2026 18:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NrT4untO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1631F000C4;
	Fri, 13 Nov 2026 18:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794595179;
	bh=wv23z+xItheor5swVqHxPfU5ZMgwYhfd4id4yMFTyJ8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=NrT4untOez6Twbg0ubjU58ouUNc0LvqR6OZzJBuXGE73B73VXJTMgrI+5xEZ6AQyZ
	 KrgyOPPw+7WkIAJZy73B39CJCZvDgHkG6F4Bd/j2wORTf+VIVKP6BLcwi0HtkO0BwE
	 BgJglbgGfwVjOjJe8eEznZGqFpbn7oQmaWpXGVhd2IuamM3AFS53MX0vHEnVNv8ErY
	 30R6sxCbwlsAMCanVJn7ZVb3XYPOhJGMyyYY5X2oy2SRFSoCtKg75APwfk7llxNTDO
	 0u1VEgBiKijOZPi8/rkuyKschJ6879X99UpeGoWlmrSipQxes0wMZIaQ0klKe01GLI
	 iNBo6ZNLCSC1Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B453E392E998;
	Fri, 13 Nov 2026 18:39:39 +0000 (UTC)
Subject: Re: [GIT PULL] smb client fixes for 7.4-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <e7592016e8a893d7c859ba1e6ee0db61@manguebit.org>
References: <e7592016e8a893d7c859ba1e6ee0db61@manguebit.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <e7592016e8a893d7c859ba1e6ee0db61@manguebit.org>
X-PR-Tracked-Remote: https://git.manguebit.org/linux.git tags/cifs-fixes-7.4-rc3
X-PR-Tracked-Commit-Id: 25912ed3b75dcf5ff623dcb549b925dd0d0948f7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3db1c74a20f0552fadc2c6886a43feee8894fa19
Message-Id: <179459517838.1691752.14559133858484764698.pr-tracker-bot@kernel.org>
Date: Fri, 13 Nov 2026 18:39:38 +0000
To: Paulo Alcantara <pc@manguebit.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Fri, 13 Nov 2026 11:10:56 -0300:

> https://git.manguebit.org/linux.git tags/cifs-fixes-7.4-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3db1c74a20f0552fadc2c6886a43feee8894fa19

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
