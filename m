Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED76D17991;
	Sat, 10 Aug 2024 04:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723264606; cv=none; b=nhPVzRdNhmZZwIlA2XkHPCpQRqJ0MVw4FpFu85mh6MMQdiLN5EY1AjJ+rCAqr+28zn96lsE/UcKPcMU487UhIpq8XaqWVDX9YyfRHwHOMkGPfGpl7JyBQ+aSnoLPk4moL9jRdZLgj26wQASSbyStosoXRWCGIzaFB/Abdvpj2zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723264606; c=relaxed/simple;
	bh=sTOM66WN41Om0wBkWRNiVcRFUpwX/qjv9LUkKfbu4rI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ECbb8YDck19uS0Bj0gIgcCaIGnBdj+X/13N17cznzor70SSf7lUor4jO73ZRTfQp6jmeJH9kRrjJ7kKcsKedSv0nYgNxGmxAzpyBaveh07+X8mwuOTGnrWndX2hih6ZMU2UbPRaS233fZWW3Rnv3/erQ9Qp6qLvOFIetIXaCaF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QgNFgp8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgNFgp8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3723C32781;
	Sat, 10 Aug 2024 04:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723264605;
	bh=sTOM66WN41Om0wBkWRNiVcRFUpwX/qjv9LUkKfbu4rI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=QgNFgp8q18Bc/NX1F6bBCFS1OUquA48lJKWse9sspNEHUMpnuzKqwLXi2b0SBWyVj
	 lUYdPS2j3chRvGpgLXRJ+zGFNX2xKlZV0yWBLc7qUH/V3tuL0Vwdlh6AAZ2evQRfTk
	 ywF88+HQTbnQOorLKXZw1jp/IGT0nem00w4HveN8+YgNkGKNkQmgxhvIPzv18EDC6o
	 TVcP17oY0tiOLwbdF3GFZ8LHcLjOm113752E8rO0ebWwIgHSpxK6FEhPdB+NckNS7B
	 wioiLOQXMj/upg0PHpshpRakgCZ8wiuA4wW+m7Ok6TNg1mDKjip5abKd1H+ujRepDO
	 tICVC1WrgwViw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB178382333F;
	Sat, 10 Aug 2024 04:36:45 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fxies
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muBCqScmD8xaiN87Dw3Gab-g4Ym8r9TB+uEq5ukkT=EJA@mail.gmail.com>
References: <CAH2r5muBCqScmD8xaiN87Dw3Gab-g4Ym8r9TB+uEq5ukkT=EJA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muBCqScmD8xaiN87Dw3Gab-g4Ym8r9TB+uEq5ukkT=EJA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.11-rc2-smb3-client-fixes
X-PR-Tracked-Commit-Id: 36bb22a08a69d9984a8399c07310d18b115eae20
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 34ac1e82e5a78d5ed7f647766f5b1b51ca4d983a
Message-Id: <172326460440.4139126.19794059500483001.pr-tracker-bot@kernel.org>
Date: Sat, 10 Aug 2024 04:36:44 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 9 Aug 2024 20:36:33 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.11-rc2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/34ac1e82e5a78d5ed7f647766f5b1b51ca4d983a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
