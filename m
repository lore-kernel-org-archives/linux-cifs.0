Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793424138;
	b=ynkS/vn0BEz8tP0BxyuSA/XRPdgLWcDUoySzjK6Aa1Jebw69huRoNnO20WO77LRVzUVu
	 162VpcTwzHPaR+zMgu/htU7uzr3yfzd44Rqr6pRO7NLKFvfHpKQGVjKyQREFy9FLvzaOC
	 UuWlpuYwH91p2D/Ofx6o1mEBYE9P3JrqWZf4e2shqfZ2O394c5Eh5hDzo/bLVNGybgsGq
	 N1chsddHvXlLHBik302ICTrhyMak7QIPaMURPdkbcNoYprSLzEINgsU8zKf1b1Ety1qTX
	 +CJb5TxJw/cLTsCKGiHhdpY39EznYZW0mgtjEBxevCzza7vrCgY1hvZRkzbTc8Ae8Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793424138;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=9fnAuwEowpBv5Y1KpZXUjDxWK1xGR5erPzsz0GAPBMw=;
	b=yZK45DnclZhkio6V9g7L9skWCsil5GR1UeAkSy+tZspqWS27KocZ2W8joQ00Jt/b1EW5
	 NNawX0rV45me9r7YwDxKbaYxsvGUzDyOaqw5bAlvRowbzAMDB5m6Q1MXN+tGlTRWuIuAx
	 /5ae0DnV8LAxQoyAm5SefBRShw73wObSNBDAYzv8/4kc0P6B2kYzUINnTFTRL1LE3GWsI
	 ++0wKcrLN/0IYfK5SYL6noz+F7HDyZevr3QMljjkhP2LldwiteC2MLYgR+KmTwd1UED9H
	 cDhv55ZbPFA4+wV3S1u13vFl123QyOJ0UX6Q7/wcOim3jZFLfkQ1+dAJuXKJYnxF7Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lbWyObN0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038ED606A320;
	Sat, 31 Oct 2026 05:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lbWyObN0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D439C1F0093A;
	Sat, 31 Oct 2026 05:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793424137;
	bh=9fnAuwEowpBv5Y1KpZXUjDxWK1xGR5erPzsz0GAPBMw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=lbWyObN0vMqOsAZpIXIMJdP2iu/bP23F205GQaYirZI+11pgO0uGWTw0tAIJ9oCX0
	 dCloBQXfwK/UaGzG9rB9WNPbApOfZ0kVESUTRBUfPsVxhgZmqcdLAaOcOqPCSpupm+
	 coTPB99PTfI8PYGXynUCS9yufd0z1yvOOjXRncx67+Bqn1IiT40pGj2pHwwLa5yIA/
	 H1NwQ/+oHlWz5Hj2iU9Vkl92I94dr4++d/YKze9WFlHVwUX9SND5f4OZry6sdCO7wB
	 Qo4NYjxnm5uxjsmp+NL/GxwviA6crFyxUDDjggMBA9bw74J3K5KbxBCAX27EFOzChS
	 U5zqsX0L8kkFQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id C50D1380047D;
	Sat, 31 Oct 2026 05:22:17 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAKYAXd98nDs6_4fhaMwn1gbTSsRkNoLefr+ZCxC+RV16j1rEwA@mail.gmail.com>
References: <CAKYAXd98nDs6_4fhaMwn1gbTSsRkNoLefr+ZCxC+RV16j1rEwA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAKYAXd98nDs6_4fhaMwn1gbTSsRkNoLefr+ZCxC+RV16j1rEwA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git tags/ksmbd-for-7.4-rc1-part2
X-PR-Tracked-Commit-Id: 206fc30f71b005156085fd8523ccc84a2c67791b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 36aad21d50d1af3f6954bb0c988257a908202477
Message-Id: <179342413646.1961943.9690364672748754760.pr-tracker-bot@kernel.org>
Date: Sat, 31 Oct 2026 05:22:16 +0000
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

The pull request you sent on Sat, 31 Oct 2026 10:40:17 +0900:

> git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git tags/ksmbd-for-7.4-rc1-part2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/36aad21d50d1af3f6954bb0c988257a908202477

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
