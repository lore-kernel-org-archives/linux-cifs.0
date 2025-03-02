Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACC023C9;
	Sun,  2 Mar 2025 00:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740874363; cv=none; b=ElmqPQ2/WdsGhR8SqEvKLvL207bdGBXj137wkBcpkZH0JeKbGiBMl3h3EIGQ3Ts6J2Cpx5fiItxGKx6N/WIZkz/B2Ka1oO9NHMqVkxZXpG4rR1kxfyQDHmLCHLuTihNC7ldi6/cv6phoLRlbUokMKJoAMPaj5HO3x87iuRE/qTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740874363; c=relaxed/simple;
	bh=eggE07wPyiYabfDTmPqk6NY83YLuDQYKDzr+xeLbziQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=LHuStaaCKT5darepu/Q6nS+4DRSozygpp/Q3UG3o35S2RharU0SbQrEEYdylT4YErrkzXlf24ZcDTKq/Ba7amByaw4fn6qiqnTi0d6zpaHao8sOOyJh8M45FmI5vH1LDxLe6c9rReugxwI6wIUGhvrw6/q8zoDPuN/xqA57ehvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tgUXsv9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tgUXsv9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7977C4CEDD;
	Sun,  2 Mar 2025 00:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740874362;
	bh=eggE07wPyiYabfDTmPqk6NY83YLuDQYKDzr+xeLbziQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tgUXsv9taDPDdgIRcLotXJtPwu5nGBBmkfr0A6LdKuUpnsWHLqSEwAjgq3ES50dSE
	 Cu9dp+u0prT9xRh3uJ0pCZNoOWca5LLCexpMIr5sbzr35smJD312iv9Ybn7Eyk7XdP
	 4CjZp7L4MR7p6FZdEtEnqzXsk4+py2T/FYXvbI8hCGkPuHnSP0EpNltqcGWbVIclqk
	 0CDY0sBrDvHEdaIYZITx7OVNypYU3RNQEc1YKI3M0iropE9K2yobayOjpkBKLbCRt4
	 OKeTPmPocKpflaID7/DRDyZzSRCfC65KOPxt/Dt+uOuXPa2b2mI5h7vc7kahchfuzL
	 vRXV7VyQzEnHQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 712D5380AACF;
	Sun,  2 Mar 2025 00:13:16 +0000 (UTC)
Subject: Re: [GIT PULL] smb client fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msEB9nwoZOq70XWmHPV98_gy145DKoY_wiDRwP+N2wOXw@mail.gmail.com>
References: <CAH2r5msEB9nwoZOq70XWmHPV98_gy145DKoY_wiDRwP+N2wOXw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msEB9nwoZOq70XWmHPV98_gy145DKoY_wiDRwP+N2wOXw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc4-smb3-client-fix
X-PR-Tracked-Commit-Id: 66cb85c441cd9c44b193ff75b4d0358fccdc6b9c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ece144f151ac7bf8bb5b98f7d4aeeda7a2eed02a
Message-Id: <174087439507.2526550.1365886616006138523.pr-tracker-bot@kernel.org>
Date: Sun, 02 Mar 2025 00:13:15 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 1 Mar 2025 18:03:47 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc4-smb3-client-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ece144f151ac7bf8bb5b98f7d4aeeda7a2eed02a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
