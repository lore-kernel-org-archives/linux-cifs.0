Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126FF78F29;
	Fri,  8 May 2026 17:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778262857; cv=none; b=nud98R9m7Xbi57DuYbPwD50xz03GmbivQfXOP/+8u5XNK7U+wElbbhTqyON8A5/21Dt4ZKdLB/AJJQ2Z/4fJal+vPVuupcQg3jvuAKqa4S/rC3+N0bnhdPThe379LTdZ87S0g/QuRYzbN2LSspOarDKB/mv7mdI5sufNkvYZ8AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778262857; c=relaxed/simple;
	bh=2NEhaW+sGTSSULfLq98i0fMoh8nGVmxgbBHi9XWpYkA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=E8/6HWchizxxBuwMO9pAlmQ+9FQXZZTIGNOzxytUn0MKngo7ZcX9Bq5QhyVDqDqbxNJ0gK15gwKAMhxVZvlU/5t1ZrZEg0evC/U4rybOY2PlhSHd6swIDAohh0l0P/G0U4V7u2e8Fy6SdFVaRPG36hcyxAu24nDsHJ/WxVxRJ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SFnF7Cap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SFnF7Cap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E3CC2BCB0;
	Fri,  8 May 2026 17:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778262856;
	bh=2NEhaW+sGTSSULfLq98i0fMoh8nGVmxgbBHi9XWpYkA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=SFnF7CapV714B57b3tXTM6/1pnGV0Z+4rBPP2wgKiZaNvABzokfAFKkpNRktxSarJ
	 06athNgrBj14mYtwQcN11iXuboL5WlaNIJzRGlVsmahC3yy1JHtiQD5TgE7jzLSzAC
	 HaAQecoLn0wcNeKYtidTMkA43SoCTFq6uLIRdVw1fLA8vGI/qh83rEdbaACV3/NwL+
	 sqfdUjqvDGbL79K9NmlqOSf/bVjARH5zVVKQPp/zqcu8E9IYhzdDsmdNz+tM+9z0eL
	 8o7K8NTJpTy7uAmjnrrzGqE/x44ep36CpeLoEYlxt5lWiOIIOUzZAIa4LUATX6vsTQ
	 LR1ZUrnelqP1A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D066381197A;
	Fri,  8 May 2026 17:53:26 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtFDoX_ytAJty_t-OwuG0DacO2D-NOL3RHNFe+SdmnJpw@mail.gmail.com>
References: <CAH2r5mtFDoX_ytAJty_t-OwuG0DacO2D-NOL3RHNFe+SdmnJpw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtFDoX_ytAJty_t-OwuG0DacO2D-NOL3RHNFe+SdmnJpw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc3-smb3-client-fixes
X-PR-Tracked-Commit-Id: f98b48151cc502ada59d9778f0112d21f2586ca3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 81d6f7807536a0436dfada07e9292e3702d2bed4
Message-Id: <177826280499.786505.10338109349050848677.pr-tracker-bot@kernel.org>
Date: Fri, 08 May 2026 17:53:24 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 8 May 2026 12:05:41 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc3-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/81d6f7807536a0436dfada07e9292e3702d2bed4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
