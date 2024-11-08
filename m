Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340DF20DD44;
	Fri,  8 Nov 2024 23:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731108296; cv=none; b=nh1UwzPtGVSR0vwlWt3TuD+rgRymeZYZzRlnAU9x+UrEXAIFARu8Q7pEi4ZaEsBOra+4ujDwwlyDd+HX+0NUTU74ntbYtSkK2o0kRyd6ybx3mYq0mBGCxkidX2sZvbAKJe8xBRzqsZOcXMDX5eoBzl6DM4YuIY3nWywEec+PuKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731108296; c=relaxed/simple;
	bh=4Vq+8jey8qP/1kaO4LTLdaxwWbRLyublGzicKkwEQCI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=abj5SZ/SMhc5TxfcGwYgnvJFvQm21wpHIRP+eHiJOxZ2vSIxs4vbtXEBA6pkmbPg4LoWBP2MjWC9jzlNrLGU1bNz24n6hXbNY/COX6xq0v5vHp/55gSP6OIa0oa+2oBc0WatI5ZVqzpreIHNF+YYYax5GgMHczm24ZnNb6tc6Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CgGHyw4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CgGHyw4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C63C4CECD;
	Fri,  8 Nov 2024 23:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731108296;
	bh=4Vq+8jey8qP/1kaO4LTLdaxwWbRLyublGzicKkwEQCI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=CgGHyw4s6OxCsi8eUXQsObsyF8Km2BCwS5wHseUq9rn1D7kxDypNCEVxJxa4GAuSb
	 Ag+9my7wYHF6are/DAXHgJhPxeAmiZVgfxmuawiH9yOyeYBL2D8jNYInqFnj+4UbLK
	 3lju50xPj9VoISY4Ouy8okthRObWlfqmSwEghmLCjhEUF0/wUzbCFY5DHuJuzKbRly
	 LDrFPF+kYAEDHW8T8phsVjP4t7OYChixBhJxYld76RamSUyAp5uvKOD42gQGtdDyMA
	 PC5Rqhe3yPecx+QCNtb5fjzN5Yon5kalhe+1dkgq8Z1AJlx7sQWD6wnU6KwO565ns/
	 E9rymL42T/mRg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADE773809A80;
	Fri,  8 Nov 2024 23:25:06 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mu+pJMkChJBwgZ9mHjf6s8JxDAtfTU5fFcqir1rdqNXtw@mail.gmail.com>
References: <CAH2r5mu+pJMkChJBwgZ9mHjf6s8JxDAtfTU5fFcqir1rdqNXtw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mu+pJMkChJBwgZ9mHjf6s8JxDAtfTU5fFcqir1rdqNXtw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.12-rc6-ksmbd-fixes
X-PR-Tracked-Commit-Id: 0a77d947f599b1f39065015bec99390d0c0022ee
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1eb714c660eb136c47902d969fc162af9bdd52d0
Message-Id: <173110830524.2790059.17753009341968962778.pr-tracker-bot@kernel.org>
Date: Fri, 08 Nov 2024 23:25:05 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 8 Nov 2024 16:29:59 -0600:

> git://git.samba.org/ksmbd.git tags/v6.12-rc6-ksmbd-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1eb714c660eb136c47902d969fc162af9bdd52d0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
