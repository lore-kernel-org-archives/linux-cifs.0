Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794096084;
	b=hJSvLPt+lW8cBooeF6FyidLM7gUohSBp/XFaXn0F/pmv+7p9pyPWnEK+5KCCyolKnCx1
	 EMSrVkfH1AcxMyNt2gFioy0FjWdIt1UWsHOaEkC5fM7vigjgaQ76WRAwjRbuN6PiWYu/2
	 lc0lXO1F0ddxiW6hW+IIo0AVMO97rEJIPDPONdgk9YnUK9lz60OH0d3/Llvr7CnhsETBD
	 QNQhj9CKJZXIF+nX2y6yOhu+W7aFmHHqJ6RMBTI46sJqrVuM/itVIOucNfP3isg87dfNo
	 KsJvfGeQSalSDnuf4KiFdjOPOFcKOctNnQakH94Fiq+6A4Nvt7yvFq5HF0Wt1xTh76g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794096084;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=6EKlkLwyzMvIxBEofL4zVwqZ9UNZ0qM58dehzlrzLoY=;
	b=Ryc0XT+eY5JqpHRQGDZOCmoR1opGku+lx7EnbXYEtUtzb7XHtcM+5ZC2MqbGSjrOoUKh
	 kH/yNfOD9s3eRUC11qkiG/etmYhZ65sw+KXBqnMrwTbD3kIhfuzOi/azdvNGA+HYHZbAk
	 54TgZ6vegWNQW6C6CNnM9fbrLoFdDo2kUwyRVPet9IVK4/vH5fAXXM1TA5XgN+y9v8Is1
	 VC3XpTrbsgmImNNQGehoK+z/yH1dHNQ/36OVEeSheqOoWlmtmBF/+C/3jK1onZPNoKm1y
	 HFrPpyHApRoSojjeROtr2iLGEPipIDd/mUxS7h4FxHbIJfU5y0+Zn+AB14u8luJSPLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PPIkbRpL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E90C606A33A;
	Sun,  8 Nov 2026 00:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PPIkbRpL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6511F008A1;
	Sun,  8 Nov 2026 00:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794096084;
	bh=6EKlkLwyzMvIxBEofL4zVwqZ9UNZ0qM58dehzlrzLoY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=PPIkbRpLZDLDjg1gI8k/BcwafvASnTFec2DUeThz/xm9z38qIcEPZcQ7aMeiAUEu0
	 Lsb4HjwTVli4SbqbLklF09M7UkKopeWx3aRMwzNy2cu+6BOSyi8Jj+VjvRoF+MhTV4
	 ZE2n7nmnsgpxXNUiQsJ9oM/vQMS2369L+otmqBAZcn+JcRhU27cgbR0cdssyokEfya
	 J4T0PJ0EdF5iFEDchIgj2Kd7fLLLjp/3Z/C0q5zLLDvz19l9e3moT1ms/W+bamN1NV
	 kn5fYBwNYlf0od37vfb0rJVXoC3Ecg0ks7HxSRx2GWmOdbJ90dX3faAWG2brKIeBK+
	 zVS/1cNDJfjog==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 2122C380821F;
	Sun,  8 Nov 2026 00:01:24 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes for 7.4-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAKYAXd8CGBxMC5oBkw=H6F0rQh5ScxOeZMCEmm5pW+rPvZvVkQ@mail.gmail.com>
References: <CAKYAXd8CGBxMC5oBkw=H6F0rQh5ScxOeZMCEmm5pW+rPvZvVkQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAKYAXd8CGBxMC5oBkw=H6F0rQh5ScxOeZMCEmm5pW+rPvZvVkQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git tags/ksmbd-for-7.4-rc2
X-PR-Tracked-Commit-Id: e49296d51ccbf2ad0ed0484db1382f1d7217bd6e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7f75cd8ccd9588e969158c5dc92a8cc217663f5b
Message-Id: <179409608295.1384930.15240222601236948098.pr-tracker-bot@kernel.org>
Date: Sun, 08 Nov 2026 00:01:22 +0000
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Sat, 7 Nov 2026 10:00:28 +0900:

> git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git tags/ksmbd-for-7.4-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7f75cd8ccd9588e969158c5dc92a8cc217663f5b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
