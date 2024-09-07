Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74783D520;
	Sat,  7 Sep 2024 01:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725671358; cv=none; b=HkTIpglMDHcuozcvXzAREoPD64Whxyw8H2eYFB5Fz/zqFFRVwXdxMjHKSblPuVNRaYEWOSMYtpnJdCalDmsE9yxr7lvMSznnGWgU0NCF3UMy+QFKQBQdRt2rd0QhgHqYq4IHah218VBJYq4RknSEo6+tMRMRVtv60V8vt0G3WRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725671358; c=relaxed/simple;
	bh=Vwlz9sHbGtncXkORcvPFWSQnnBffMh/4AWMXpltCSkQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=NDQg+FMsUGTKSUnWsl/Y6Q9xgrUNIXVpAp3SHe7YPHLqaKm0YV5BSMrqsUmey/+ZYEGg2wUqzCAqkk+iASkbmDLl5OGELN7ZQg7R9SB7Zh6+72nNZhBRmipQLR01CU6WvojffEmO5XJXsZ5V1nTUlyHJkouavRUhBLe3N8JMeYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cQiSURjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQiSURjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55395C4CEC4;
	Sat,  7 Sep 2024 01:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725671358;
	bh=Vwlz9sHbGtncXkORcvPFWSQnnBffMh/4AWMXpltCSkQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cQiSURjZi6i3E7/UxqFCJnwPaG16ufDMNrBBiVEPai0ZPJhxCh5r5M2U+rafwYsCs
	 sEgcorCj96W4sumjFgkXWc1gMvjWqnlhBbVsUTbKxqr+pZW6po3OGD3TLpT7aqqYiL
	 Ua2Y1ehn0464ATQ/33Ithup0Y3zDLsQ5phqpGEleFJ8MX566I3xA3BO5NJnqJrXIuU
	 L60hJAF6PI5rXI58b3jdHVt0Z96O+Q2KX3m0naUoM1gB+RwEEGrx1u5jT3j9vh6LSS
	 L6VP2Du5/sZchvjCFkqFR1OkQcA440MeuKUjS0gdTZFhzbS5Jz1oLHv8snZAhCrgqw
	 PKDsaF7OSnIHw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70D9D3805D82;
	Sat,  7 Sep 2024 01:09:20 +0000 (UTC)
Subject: Re: [GIT PULL] smb3/cifs client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mu_sd0WC=c=eV-AS90-hH42-ANqyD1-BoJ-52oD-fMuOg@mail.gmail.com>
References: <CAH2r5mu_sd0WC=c=eV-AS90-hH42-ANqyD1-BoJ-52oD-fMuOg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mu_sd0WC=c=eV-AS90-hH42-ANqyD1-BoJ-52oD-fMuOg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.11-rc6-cifs-client-fixes
X-PR-Tracked-Commit-Id: ab85218910729b95f9b0acfebab55c2cab5f8ee7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a86b83f77797ad1289601beb9a9ea61ad9f593cc
Message-Id: <172567135886.2572367.13962068792974810643.pr-tracker-bot@kernel.org>
Date: Sat, 07 Sep 2024 01:09:18 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 6 Sep 2024 14:31:41 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.11-rc6-cifs-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a86b83f77797ad1289601beb9a9ea61ad9f593cc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
