Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792980461;
	b=QMot2KntFibt4abcNUbyR4q4mGtRHRU1sybS87mFeTe0y0dOPtczHgv2qB8JDIu44+cA
	 LLp1+3Bz2JqGmFMBEtituXBeSXpgh0cnZGEPFLLfiPIVIELV43GBwZ9dwrOqJ9eAH8XBX
	 wIBWIBd6SQs+TTBgyczxt9ldRsHeDuL2gcuHK8LcLXgCGABeR2xm+UrGcdGJWznB2UxHR
	 +cQvrlBrtcLKB6QS3Xld+izdBd2zY+FrYHNEFkUrzOEKiecfnDLOp3hwsQILy/gV+ng3V
	 FrdnIvNOEgHLEZXCtO5Wl4+o2PKxZcPfpWgoUktPJRFikC1Qp53K9fcmGbwIx/AsuUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792980461;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=wrYLQqwyy3Hoa1pACuTY3uded+px/BQQLgQ13pnpqio=;
	b=unVNReWjxgpe4k0YrnUVqeUCF1uiLGa8ohYPh1hGJhSDBi/Ot9lly6GH2MGoqUUiRR+o
	 4daUIc0KsiqT0j0Dy1Ixv2kD7m0eri/ggQYLdsg0zLCKndEQCOJsgStDbnnT6iVXXxEvG
	 fm0ohGxiHdF1tnXjTyMyN6UfT2IuuGNb7KnVK/4pYU01MqklGOGdHvGYI3Qg7HrlU0FHb
	 Bp/r/bOCSCqPc3+QS4AJNbao8Wbvzb9BitsKGKKY8aJV2rG+2bWrEJQLjpAf1lFM0mfuO
	 BEhiEw+jeOXf6JMumuU2pzDbyU8I+Yx2gBYyvKXvYooUB+tK0/RpeaP5V1+jbSdo5eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VLQbPpWQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718D8606A31A;
	Mon, 26 Oct 2026 02:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VLQbPpWQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5831F01825;
	Mon, 26 Oct 2026 02:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792980461;
	bh=wrYLQqwyy3Hoa1pACuTY3uded+px/BQQLgQ13pnpqio=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=VLQbPpWQe+NtW9PC6LvIgvEh3AB5AmK44W/yX2CN3Znvxq0cvehxqXcZ5NBVpc/uc
	 pKCstW3Y1TPe7NVoCgbyXDIYVDioF18TY51M2VCpETeXa+swlKwZeNu8SO8TmcdR+s
	 b92eHJ8Jk/GoUW8ccFFMeXQkq+Ru8Db+dFcnCpYYZu+w8TpMVnq2Bm/cRaG7p6xuDw
	 RmZTCco2g0yuaUfoJmfw+lJipNTl1RxQKkS/gJZUu/5roIC0wCcrFNqjPicu6tCDiu
	 o6roxcaGbsXjjtAU7B99scRyJ2/HApMvnNZs1UBAZtYfqJUeTr4jKMAj0+1WlWxTtl
	 mwc21mKnNJ2Sg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 442E939EA760;
	Mon, 26 Oct 2026 02:07:41 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server update for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAKYAXd-E14WN6OkWLtkuDBqRE00WS9zKQBmm01iJ7k1wavLw-Q@mail.gmail.com>
References: <CAKYAXd-E14WN6OkWLtkuDBqRE00WS9zKQBmm01iJ7k1wavLw-Q@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAKYAXd-E14WN6OkWLtkuDBqRE00WS9zKQBmm01iJ7k1wavLw-Q@mail.gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git tags/ksmbd-for-7.4-rc1
X-PR-Tracked-Commit-Id: 2c36c4a86104d763ee798d4a89e2d3384b4cd626
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4e1b4fdf6113b4eb9564bdf3b76ee3c3132da7d4
Message-Id: <179298045986.2358720.11292210101928983278.pr-tracker-bot@kernel.org>
Date: Mon, 26 Oct 2026 02:07:39 +0000
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

The pull request you sent on Sat, 24 Oct 2026 13:15:01 +0900:

> git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git tags/ksmbd-for-7.4-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4e1b4fdf6113b4eb9564bdf3b76ee3c3132da7d4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
