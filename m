Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91593AC00;
	Fri, 24 Apr 2026 00:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776989645; cv=none; b=layggix4v3OfAZH+VBTg3uA4N2KTIXQ69Ns+NL2LsJAwP1MGqs3ZFtaGWOBglZTjahZh52Pfwk1iOdibpDfJk+FQShoVphCu0vn2glMOx2wMpP/yaHGZcvDCnfiigPdU3Ok95qf2RxnPOl23vOGMm3YdH23icq6/k5euzIZGwH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776989645; c=relaxed/simple;
	bh=7P6TAoGXc4ymIfuKlLA447KAarNbwAYhYx3M/yWYncg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jG6wi4bi6882WR6n8TKg4HUAZXYZaCfyRBkSiRWOzw/QjBQNRF1/Sh51p6cRJg2w/ZWyTCuqwJgnH8QYQDN+Bm59uYbcDF3suy154bShCRCv6jygd+KZgepjx6Zbo8u75Iqud6CJlbqe8cLf9DCozb/wDhUGuYHxysGPpdYoKE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XdNO0Koi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XdNO0Koi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2CAC2BCB3;
	Fri, 24 Apr 2026 00:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776989644;
	bh=7P6TAoGXc4ymIfuKlLA447KAarNbwAYhYx3M/yWYncg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=XdNO0Koi+7XPZNVckmmRjcAQt8kGhnCKFvtCJfiZ11Zcy028sMFQYXiac0j9XrPWA
	 EdyXVmvwquH52YXhd5sMBJym4THYLRiN7G/fhZsks5bcsegtdG0AVC/j/vvmJuBkVI
	 8ZG9UrMEPN4Ywa/K0SSTAU5JEIabGcT2dceUEaoZ8QIBxK4t4zaX+VIQZZ8ICtVOb1
	 D01Z7c41bEHcAz2MDqy5HnLilsFrTsqBxQjB0mupT3Yq01NO5aCSLMZv45SNkyGezW
	 Iwo289zaEgSplGHtgkCMgjwY/qgRnClaZRuedaYucF0rt7gLdbuheZ4jn/ffaOp63m
	 q10VB0etfsxiQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FD91380A951;
	Fri, 24 Apr 2026 00:13:27 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mspnU4XxcU9Vr98PeY1iMVag9QpxdB72GO5t4EExbKkRQ@mail.gmail.com>
References: <CAH2r5mspnU4XxcU9Vr98PeY1iMVag9QpxdB72GO5t4EExbKkRQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mspnU4XxcU9Vr98PeY1iMVag9QpxdB72GO5t4EExbKkRQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.1-rc-part2-ksmbd-fixes
X-PR-Tracked-Commit-Id: 1249c01aa42160e40bc765ba5a3cde751491ff0a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bd1886d6e4ca6b84041d17ba6e11d0f85f7ee1a4
Message-Id: <177698960571.818077.1793387120526001488.pr-tracker-bot@kernel.org>
Date: Fri, 24 Apr 2026 00:13:25 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 23 Apr 2026 17:50:21 -0500:

> git://git.samba.org/ksmbd.git tags/v7.1-rc-part2-ksmbd-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bd1886d6e4ca6b84041d17ba6e11d0f85f7ee1a4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
