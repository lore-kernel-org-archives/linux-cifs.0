Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C1BF4FA;
	Sat, 23 Nov 2024 05:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732341523; cv=none; b=O/d8AL1Wmr4eOxQdMECT+CS8nKCMMqD/3XbyHu4wKQM6VDmgJcKolomF1KGhWxMBNR2dd9W6HJtkMDcFFFlg0BaU5envLpZ8a+NCQzVy3n8AqZLdjHu/anctcrkKd1bRC2FXWNDeZ7rumrgSav/IV4YAMeZWIO5voSK8IaH9cD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732341523; c=relaxed/simple;
	bh=WfBFjLp/lwAU0aBTLDEUjK1u+TudbvM9JvD0nh8iztU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Vv8W2jQCAN4OpUWWgvrnjGZtnKxRi213cM7DZ+CXM9yQIyOKLV3TLPUh3f3TMC4rQfIE51M7wTZ75dYjf7OXBAH/R8CVhNLOAnz8mMmrUGbt1xJDcrlh9Jupgj5u9VDIeWoN6CXrMANe9xPTaEHwxrU15SLfvL9e83FNdnDt22M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BMoJGP2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BMoJGP2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DFFC4CECD;
	Sat, 23 Nov 2024 05:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732341522;
	bh=WfBFjLp/lwAU0aBTLDEUjK1u+TudbvM9JvD0nh8iztU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=BMoJGP2ni2Y/AESXXsztoOiNc94CnT3yN7DwZ3rBukZAiyY6XC96hPBnvWLmiHPyd
	 4sU13pjHX4kR5W/GHVXyB64NUqWG24Q4nodvMo1Na0Xt6L9J405Itcex3sjVvwoqN9
	 LmqY7fRSRO5cnbPf+BU7XNygebI1GmAnYtycEPOF1lUFFLHAZBJXdxnz4Qr9WwDJVV
	 z/BTqaW+0ymPECTIUW5KXK+3lY90PQbgoV3dpYdhSSMe2E6Mgxgb9FtJaFhfDUhBrj
	 2zTazmsSDGzsCxzEEgj3SYK9HoDYyCZy84kBBhOYuW7BPKM9Z0YIIFR5d2oREg6FoQ
	 Vh4UXb/SaacGw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAFFB3809A01;
	Sat, 23 Nov 2024 05:58:55 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvA00Q69_YqTQFgG-AmBx8N1BdxA8MM24iknf9DSrnyGQ@mail.gmail.com>
References: <CAH2r5mvA00Q69_YqTQFgG-AmBx8N1BdxA8MM24iknf9DSrnyGQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvA00Q69_YqTQFgG-AmBx8N1BdxA8MM24iknf9DSrnyGQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc-part1-SMB3-client-fixes
X-PR-Tracked-Commit-Id: a9685b409a03b73d2980bbfa53eb47555802d0a9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 228a1157fb9fec47eb135b51c0202b574e079ebf
Message-Id: <173234153446.2919735.2265291372555044533.pr-tracker-bot@kernel.org>
Date: Sat, 23 Nov 2024 05:58:54 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 22 Nov 2024 16:14:22 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc-part1-SMB3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/228a1157fb9fec47eb135b51c0202b574e079ebf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
