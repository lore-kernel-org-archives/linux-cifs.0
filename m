Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46883A26B
	for <linux-cifs@vger.kernel.org>; Fri, 10 Nov 2023 18:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H4zbWemB"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28134C433C7;
	Fri, 10 Nov 2023 18:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699642072;
	bh=BvAcT6FSwgMjDhVShpBBx+YEQuVruPykhLqyCi7zZ2c=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=H4zbWemBxEck0tLq9X0csln5GMS+SHPDP8YX6sNFPS0wWjey3crzQfd/+SEO1XuO+
	 wLO59Uoy2uLz72BKB8DO5yyUI0t+S2qeT8MNiWw3MYHmNsd42xwv/bGq5gkV0+XDQy
	 0lWKKh9nKYPoa0wvkhBetI7ZzNfh5LDLILpTwGveoU4xa7cuYeYrsWDbGv965ful5O
	 wE4iq7brS/7r93HAjd5j1+e2wua4OBW9bhqki9jyptSOMcqjLN8EUFmk6fKCpv46wX
	 /BBInujg7J0iVF7/8uNGCPKMRbivuPRB6/gLdORpsxh9PsyAtQ73jr6oWQI3coZ+nN
	 VDWD3k9B3/heA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 164AEC4166E;
	Fri, 10 Nov 2023 18:47:52 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtQPWefhxpwgYUyVkyaSWL0nRurOc3qAV9XxbUN5dni-w@mail.gmail.com>
References: <CAH2r5mtQPWefhxpwgYUyVkyaSWL0nRurOc3qAV9XxbUN5dni-w@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtQPWefhxpwgYUyVkyaSWL0nRurOc3qAV9XxbUN5dni-w@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.7-rc-smb3-server-part2
X-PR-Tracked-Commit-Id: 5a5409d90bd05f87fe5623a749ccfbf3f7c7d400
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 826c484166f0f74bd8fc09220f99dc937c9297cf
Message-Id: <169964207208.13214.2578265116053072906.pr-tracker-bot@kernel.org>
Date: Fri, 10 Nov 2023 18:47:52 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 10 Nov 2023 01:16:47 -0600:

> git://git.samba.org/ksmbd.git tags/6.7-rc-smb3-server-part2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/826c484166f0f74bd8fc09220f99dc937c9297cf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
