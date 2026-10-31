Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793405426;
	b=C2cCMRS7XQvVPhYtpDbfzwfITK2OLBlrvhCMHi+WZd+OKExuSVlfSXpuGd3C63fa20m/
	 /bhkJZjUd6S7Wv1Is1q7kpWNA0SnHeJeKKezyEVNeO3feuLDuwLIXO5wYMEKN9ay1awwk
	 3tzosvD1e/r/+hG4eb87Bsm7RSoAuyc6LyY+Sgl/ZGvzuydboKfN2uz3mwa9ehh/80I+b
	 YGcmZ1/hgMrUL5J3HvZ/Yicb1LRBA+yyj6thSjWlm3mOvXJsYHxFweq0ZHxZoJrQ7hQwZ
	 G2BTEuDYLfZXpNOR1sKeRK1wSUQtS2f3MI471Zi5BhEny8ehel1Bv1Q8Bv7OJx94B1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793405426;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=saEPjU/S7XppPr90nci1NdZBa8hTlDTlak7chG2GAVQ=;
	b=KvdZLsfv05myw+01929Ib6xGNShBr1vBcO5M8qDdWeRD2VzqZlNdY+uoySoBhSp6VKcv
	 OKgmukdUoGBeSQMWeKviyfCIzfpBha/a51VrEQpI0WKg5ODy9ix94TZx4iZLB9WRzGfcr
	 BI0vKUwfkqepcZED+zKxuOcxCv299Q9hJyAAQ6sfEqoMg8cR8ynpBxBqVZTjnJ6NsvUVD
	 TpZ0Lkl7OtTVSXilMtTpEt8onPFwS5IU55rQMH9+gd5RfjKT37bYsfunjJULx0ZVBRw4S
	 aptVI7c5tNO26BZaLGdcE4rsnd6j62iGZGGXwWP1QOI5QlMjY55X1MpE8FstaJb3WtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aCSsiNX8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30445606A31A;
	Sat, 31 Oct 2026 00:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aCSsiNX8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2BA1F0093A;
	Sat, 31 Oct 2026 00:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793405426;
	bh=saEPjU/S7XppPr90nci1NdZBa8hTlDTlak7chG2GAVQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=aCSsiNX8TrMcc9cyOlQUms6DJwd9mY1izrxzFQK2HVqt1PU+t24kBxr5dSemZvXTD
	 hom96b/F143Yvz57rN4CT6rCZcQu3T2GvdNm0bSieXkNvGCSmZVrDQUbNP94DgVJ0n
	 S4tb8mL0JmJD8+pSQD/5HIEz0n2cLCQ/SlQDoQ1YyhWVtto8ylUM5I2yFk5Y5KYuK3
	 1/SMksFzWfOB/29Az5vbk9KJGlhqWvjOu3cD/zcFgl//CU0qbVkd15ujc6KRwzZjA4
	 hDCoBAUbzPIjX0Ze5dQrEamkj/QF4OCMotilKj8yGv4SyVRS2EwvwDpNiDG7d7t/sG
	 V7v/yvnTYXGvg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 031DC3800478;
	Sat, 31 Oct 2026 00:10:26 +0000 (UTC)
Subject: Re: [GIT PULL] smb client fixes for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <d18e86791a96cef6259f9f23c9714576@manguebit.org>
References: <d18e86791a96cef6259f9f23c9714576@manguebit.org>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <d18e86791a96cef6259f9f23c9714576@manguebit.org>
X-PR-Tracked-Remote: https://git.manguebit.org/linux.git tags/cifs-fixes-7.4-rc1
X-PR-Tracked-Commit-Id: ddc7a7e1eeb116ccaf010a6f1fb6ab927f3f888d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 51b4bf5fe7c90ebf08599b9a3c7620b4a3fd4b22
Message-Id: <179340542457.1842865.3352319552930251348.pr-tracker-bot@kernel.org>
Date: Sat, 31 Oct 2026 00:10:24 +0000
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

The pull request you sent on Fri, 30 Oct 2026 20:26:33 -0300:

> https://git.manguebit.org/linux.git tags/cifs-fixes-7.4-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/51b4bf5fe7c90ebf08599b9a3c7620b4a3fd4b22

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
