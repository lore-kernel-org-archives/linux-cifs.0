Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAAB1DE8AE;
	Fri,  7 Nov 2025 16:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762531573; cv=none; b=qvGNd/zOEw6689Eyt1C+lim++C+1ZFamsv3fG5E2IuhZCoHoJVLqS7KmtZOjWrVsmVDOVmWT3D4LACi34QZdFQkS1oJguLvoa5xPX8Maah7EjjWCJD3rgG79qJ6SQuM7a0dBt4vyurmG9wbE9G1OweAtC5suFY9FExfLPnOBYoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762531573; c=relaxed/simple;
	bh=IbYFBmCZplc9qIPFR5xCSla4ktk/n5evxzNuo7Z1HuI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=qWcrQgpEYGU+KBHYNrGr2PhB5GGwlm0S/655cle1+4heEJv7rIyq7ZrY2V0UzxmWZkVVgkqT0/bSpUgCggSAWdJDB/HTydzfnqkntD9/fckd/WJmMLfIeS2yWUuwkE6Y6xMloaCDrfNgQtJUDTXeEf3Btkf1QEpM7HoXPKPUqy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tknFbYyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tknFbYyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AC0C113D0;
	Fri,  7 Nov 2025 16:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762531573;
	bh=IbYFBmCZplc9qIPFR5xCSla4ktk/n5evxzNuo7Z1HuI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tknFbYyKpXETTT9bo96ev6wwtmuBT1UWOhFk8KuZcb24cY5/MU4iv/qSjFJ9asCMo
	 QZgM2Z0yfnVnehTVd0T6r3yto42Sf+I7vXKdGU2wliIQvc4uuR2kzpAZaVB3IysIcd
	 WXuNY7anNTKRREYPrUYWj66vFWSGcAfAzpbd7YCLq06EiwaIfWVd7oxjD7Zgxlx6zX
	 PbZeo5TJ813eWBHiuYMXz3aLHKEsuo5TCwzWQKPmU9UyTkdYqP+5mtxFIGMj0pC8qF
	 RaKaMUKbKvP5onszWHEXa17BpLlICOavd5LyQyvErviSWr5V6tF8fppu1g4dgoIRXK
	 xGAR40G+67kog==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE09E39EFFCF;
	Fri,  7 Nov 2025 16:05:46 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mujzgdeMzwHrTaeK8fBNrpjcWyHCQkNq5Lm85ADL2pYew@mail.gmail.com>
References: <CAH2r5mujzgdeMzwHrTaeK8fBNrpjcWyHCQkNq5Lm85ADL2pYew@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mujzgdeMzwHrTaeK8fBNrpjcWyHCQkNq5Lm85ADL2pYew@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.18-rc4-smb-server-fixes
X-PR-Tracked-Commit-Id: e6187655acfa2dd566ea2aed4522083f0bb940c3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cff0a1be08ae4ee609362fc6500cec4724e79e18
Message-Id: <176253154526.1077315.2845099986659131481.pr-tracker-bot@kernel.org>
Date: Fri, 07 Nov 2025 16:05:45 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 6 Nov 2025 20:41:45 -0600:

> git://git.samba.org/ksmbd.git tags/v6.18-rc4-smb-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cff0a1be08ae4ee609362fc6500cec4724e79e18

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
