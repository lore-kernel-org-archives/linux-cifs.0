Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57142E88A5;
	Sat, 14 Jun 2025 18:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749924630; cv=none; b=nF7KO9d39Axl2wck3+Pe5CtnoMW4DYygk/Tx/mgZFbbl6LD9GaG9B0uyRjfVmnX6hyi37uK3Kf/T+tHo85nb0Y8BlW63LSmj/A2/h3FcsCEqlk4bYdb25Xu6ndm4Sc3w31BZQzyPwArt56n+jRLPjkjSBgQF/yhbd8Y1ZfRyfNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749924630; c=relaxed/simple;
	bh=W3ZVegxa7zn5SI3FjmlI2uyVT/C8vLjZUrmPAlIfOxs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=HfwKGIP0owUbUgB9dCvvzuINFmNhj7tmCRbjaqNsdQoL9cMTe4OomI9RuKv7XjCIwseVf1ya2OySjKgfsljrdjmUbXgZGu3Z8XkMVUXV2KtmnSp8z6F08lLYNPiumY3YhAu2eyZgjQDsD48yaP6UwSKjXN8MbEjgBebYxc/l5QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9IOP1D2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9IOP1D2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73D5C4CEEB;
	Sat, 14 Jun 2025 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749924629;
	bh=W3ZVegxa7zn5SI3FjmlI2uyVT/C8vLjZUrmPAlIfOxs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=A9IOP1D2IuwffTZLJrcjVTO40ASNEdKVzfbUFJKDE3uQJ4nOPX3/gn7RC5f8ySOMz
	 kEVUviUJ6v4NXwWzMTgArwSCNUXOHJhxUqXq23EWORiF0O+aTkVcekLen5WN1HO96r
	 nbPCPK0il0mBrYY2eGyApoNcXwzMAelUJXPKtg9l1GbFGjDKHU+fyXj5/EVwB7wxAv
	 ukIF+hi05kckr0WsnV/CgouDKe2f3GzirIGU8uVCizKbbkqoO9AzyZMaTXtS1I5FqP
	 fBpFAbbcM/BTpELaC4D9ZPH4yrlqxlZ96Ds4GyeOc5Gd7hLaMdyJuyTVIkvIzgvIK9
	 4gOKIo5ch0ruQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70B82380AAD0;
	Sat, 14 Jun 2025 18:11:00 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msg0f6EP24x6dQyt8CbGs9OD6EzQV7rOW0=8gkfLFvJ=w@mail.gmail.com>
References: <CAH2r5msg0f6EP24x6dQyt8CbGs9OD6EzQV7rOW0=8gkfLFvJ=w@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msg0f6EP24x6dQyt8CbGs9OD6EzQV7rOW0=8gkfLFvJ=w@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc1-smb3-client-fixes
X-PR-Tracked-Commit-Id: 72dd7961a4bb4fa1fc456169a61dd12e68e50645
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8c6bc74c7f8910ed4c969ccec52e98716f98700a
Message-Id: <174992465903.1140315.12648802612461512920.pr-tracker-bot@kernel.org>
Date: Sat, 14 Jun 2025 18:10:59 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 14 Jun 2025 11:13:49 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8c6bc74c7f8910ed4c969ccec52e98716f98700a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
