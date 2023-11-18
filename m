Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E07419BCC
	for <linux-cifs@vger.kernel.org>; Sat, 18 Nov 2023 19:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nsa2H2P6"
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADC42C433C8;
	Sat, 18 Nov 2023 19:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700336699;
	bh=iPOzN9M4W3f0bjODzDe2uZ3OY8xdK/MklwqPBnFlIGM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=nsa2H2P6Bn5OYrrEQGh9baA1qRjxAngf7mB8zX2bUVxF3c6VhvWMP43kOzzuidCrP
	 q0isz2k7e4F6CHMTyhy2aYjfNzDe0xpaB9UqJ5H/IerMYp+F9FW9l7h5jV9lW/oL3a
	 EYicglCHvJZOBfrthyhtB/Kt+D0nWc4YIqbOP6/LMqsaArRhsjpg20bJ2qGaqeRfK2
	 /ScCYVhcYWzW3Xey9lhv6QqYN00TijxzHWJq1Lob9XDDbixXUUD7lVHwIYC4VFaLj0
	 JSuNIAxIpHwDE/ljtmrkfSIcoCbq0533NgJ1Kbe4IlhX37G0vtZs8YTKhMn4LZZLNW
	 m7c1hBxvh35/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99D09EA6303;
	Sat, 18 Nov 2023 19:44:59 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msETjR-mEd6PUkE-E=OTMFKh-jD2ucuHP=uGyLScZQCLA@mail.gmail.com>
References: <CAH2r5msETjR-mEd6PUkE-E=OTMFKh-jD2ucuHP=uGyLScZQCLA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msETjR-mEd6PUkE-E=OTMFKh-jD2ucuHP=uGyLScZQCLA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.7-rc1-smb3-client-fixes
X-PR-Tracked-Commit-Id: 5eef12c4e3230f2025dc46ad8c4a3bc19978e5d7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 33b63f159a435c6dcaaf2cd0f312b28c76b61373
Message-Id: <170033669962.17055.15504208894696400054.pr-tracker-bot@kernel.org>
Date: Sat, 18 Nov 2023 19:44:59 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 17 Nov 2023 18:37:16 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.7-rc1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/33b63f159a435c6dcaaf2cd0f312b28c76b61373

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
