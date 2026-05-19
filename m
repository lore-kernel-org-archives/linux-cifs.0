Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECC24F7987;
	Tue, 19 May 2026 16:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779209536; cv=none; b=Kbl2iqSAXfzFyxTfSAtGDW1fQZP4Rr8ou5Vo3+B6o1jJnpf37I/WLsrOAa2aMINqfApeEe6cr/ThoZA8f4fqJR9V2WLT6xw3A4JjdtqohtNa4rvb5T8DaVJFkB299f7013fJZp0TEcF/aXaR45iKY6ILYBkaFqbfCFOCWdniZRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779209536; c=relaxed/simple;
	bh=s2qM/7EhAQmXB9sIHJllM/U0cnb0DjM3F53qYupO4SM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=CN/nbxBROKSX2+Mg2xpAzWxqwaS8Eoy4FqeSZgvDy+tQjy6xeC3UPsp0HMhu9dyRWfIHwitsuhOcfuPb1VfPEf9oTQ8m5vX9YxseuFicuniFGkLi3u5qwoxRs86oYtaldtEKECG44/fx91r9SL+mQ0a3zkqSh3UK5bHIXAJj6mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W9dcNf5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W9dcNf5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245F7C2BCB8;
	Tue, 19 May 2026 16:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779209536;
	bh=s2qM/7EhAQmXB9sIHJllM/U0cnb0DjM3F53qYupO4SM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=W9dcNf5P2cmmQGN6F4b+zgl8gfy3+0PtgZ5MCBe2HbiAV+PDNNvSsp0UM9Oah1Hlt
	 rxkLHMBX30GplHSbEhiRR83mEth616gbcQNTmkFK5fusgCOTSSmpSGpjGFamdjHKJ2
	 ku33bi9I+cVUwhymyfFDFzPuhO0djvX+S2josc1LHAFf2WpJu24gVzQIbQVdZ6knS/
	 vQgkskImk0EAbBE81wuf96jDkRRsavjj3TsrU1sbHxLKjuA3T4LeEq+EBGLuRRx8Xf
	 QviKBNq6UGzH98NTscq1akXdP9g9RqJ1PVZ1X59TV0zz0h3Xt1D3jVcrFemTF8vRWx
	 tgGaGQFTEL9pQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56A9C3930E36;
	Tue, 19 May 2026 16:52:28 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvFfOokS8h86vit_yKvnA48k3bqXEz7AkXyaVZb-mLeZw@mail.gmail.com>
References: <CAH2r5mvFfOokS8h86vit_yKvnA48k3bqXEz7AkXyaVZb-mLeZw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvFfOokS8h86vit_yKvnA48k3bqXEz7AkXyaVZb-mLeZw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.1-rc4-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 4b83cbc4c15f09b000cc06f033f64b0824b6dc87
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1a2ab0feaa23147e347b4d4cb79cb3fc392118eb
Message-Id: <177920954707.2806224.15395165969576608871.pr-tracker-bot@kernel.org>
Date: Tue, 19 May 2026 16:52:27 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 19 May 2026 09:46:51 -0500:

> git://git.samba.org/ksmbd.git tags/v7.1-rc4-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1a2ab0feaa23147e347b4d4cb79cb3fc392118eb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
