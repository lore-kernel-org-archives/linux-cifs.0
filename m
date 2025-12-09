Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1949E27E074;
	Tue,  9 Dec 2025 20:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765311872; cv=none; b=ebrrkkhqYHfy1qbGGHMin5zvBir02w5jsFFhfrs2Z6/f1ZBUsApsH3WjaLoFy2UVM8pcApkggxU70CfkTs2iMAThJom+zfqYpQEPvYKs5S6SGVQHg0Jl01VJ8wXMOTc7eEOVZyYr/PAedmj+ubRIamZWRSgKkWSqGP7Oet140z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765311872; c=relaxed/simple;
	bh=6XWvlvPflv/Mzc22o7NJ9UsoLaRdeD9TCBS9xCzi9bk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=WbqVrD6ifshQyKYq5aOkcKWhMoFvDG0t7Tbv+Lpz4bE6X7kWJ2TzbKYu7rlj7G/ir1qRuewiKQ7UWIe/5RDIEJ7gkwySzguhsAF4DIPbgjE8+6olA704reXx1Me4iadNqw9xHyYxLX33DO5dvaVJu7xz1AUdf5N6/Edpz0hBj+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NC3AJwNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NC3AJwNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED955C4CEF5;
	Tue,  9 Dec 2025 20:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765311872;
	bh=6XWvlvPflv/Mzc22o7NJ9UsoLaRdeD9TCBS9xCzi9bk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=NC3AJwNIDo9kJt4iX4BJtKGfV1CyF4qocynim2HBB6IUqfRImil5UC3fJxqnuXCkj
	 QwbOzLF3TOkIBpqRS4fVbWt0XSjAVPudnEAhAyrpRhzcb9+yVjXCSSI58izbC8KSP4
	 +HQm137Mpyh6QIWd9T1Ru9/4ay7y+KclqgZyxEtel9oBNP6017mOTNECHCHzwmgShz
	 Vqt5Szawp6bPT48KXAR0TMCnXQUlXEbtyctvoPKqRCVpB+jY5yZeq7ATL1i6XhZJQE
	 F1mhf7ndZg7CNn1E/S1LC+pTwdhIICthaR4qCwXS5JJwGHSgNNr6ln14CC1Dgk6m9T
	 tuGg+KU1GzKVA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3BADB3808200;
	Tue,  9 Dec 2025 20:21:28 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes part 1
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msaVyrK7m_FvOWn9mFp0PpGij2aeiX0VOrwiVMtjBq5dQ@mail.gmail.com>
References: <CAH2r5msaVyrK7m_FvOWn9mFp0PpGij2aeiX0VOrwiVMtjBq5dQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msaVyrK7m_FvOWn9mFp0PpGij2aeiX0VOrwiVMtjBq5dQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19-rc-part1-smb3-client-fixes
X-PR-Tracked-Commit-Id: d8f52650b24d9018dfb65d2c60e17636b077e63e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3d99347a2e1ae60d9368b1d734290bab1acde0ce
Message-Id: <176531168677.4113424.18057295505910694564.pr-tracker-bot@kernel.org>
Date: Tue, 09 Dec 2025 20:21:26 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 8 Dec 2025 21:53:51 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19-rc-part1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3d99347a2e1ae60d9368b1d734290bab1acde0ce

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
