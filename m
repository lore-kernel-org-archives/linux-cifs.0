Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EB71E5B68;
	Sat, 18 Jul 2026 04:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784350504; cv=none; b=c1NdFBcH0BTq5cnw1Z4QzM8oHcRZggBeo5TrEwPWKlML+j1LFuppk7z1q3pQPexyVuQvGRBjLRrlBcDhupMB9UN8QlXgBq9W2Plg5/9Mg+3ZrWGe6ZGWi1qTvDjWW+PnXUMEMgEWYNJSj5UMni6zXLww0dzLI82Bx5NSYs5y+b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784350504; c=relaxed/simple;
	bh=9Fd64SWb4tZesLROBkB7GYr2F+2L7Z0TSqU44YsnDEQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PDnIt6Dtsi/H0gU7cuO7wf7/3wCZt8m6RGyj3+cym54SUdz1MjfM4F950aYJbmXdvyRQPpb77vUMQyUVpPKOqPefXcxXcctoY0D3eWndqA38AyUoJy2sPK9GHnU+BoMnQzk1q5EDb+7FWU7vfWuD8yO6UbIjiDixrbA3tpdNnas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HKeWLPHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HKeWLPHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19F41F000E9;
	Sat, 18 Jul 2026 04:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784350502;
	bh=6oqvdY5OMOlD4FzzGK0WihQNEcldhbxR90a063JYL4U=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=HKeWLPHDRRWtE1fLFggNMQjt3y+yfpjIKjOkeWAE4rjsV7v0v5aLZsDBJrqSqkaTF
	 I+JQxHDqrqoH35EajI7nno+w8xSeMUPHgn/o84xnvestkcQRI78sK0MuuTX6XyuRa9
	 MW6wRkKPEfx9io2QMMgEAq1upyVTGJJy3fmo6sTN96BONoAhWvfbWtK976zwffRXIQ
	 34oCkGh93lPJQ14IJrFjWH66kVU2aACMKWliVsOfvQ72RPhbTttpgkPzshOykSAjTx
	 hQ4shaIkSDx3E70hhjRwBNyFc6qh6k61Hy8vFGB4kmO3y7Q0nIj26TJgSiXch3Sc5f
	 9ZdHLs6UeRLPg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198153811955;
	Sat, 18 Jul 2026 04:54:36 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mv5dhHd5Z4YXTM4rPNTV4hD5dApeqsrurc-VErRoi5URw@mail.gmail.com>
References: <CAH2r5mv5dhHd5Z4YXTM4rPNTV4hD5dApeqsrurc-VErRoi5URw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mv5dhHd5Z4YXTM4rPNTV4hD5dApeqsrurc-VErRoi5URw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.2-rc3-smb3-server-fixes
X-PR-Tracked-Commit-Id: 15b38176fd1530372905c602fde51fe89ec8c877
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1229e2e57a5c2980ccd457b9b53ea0eed5a22ab3
Message-Id: <178435047475.2413748.9950233130809862442.pr-tracker-bot@kernel.org>
Date: Sat, 18 Jul 2026 04:54:34 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 17 Jul 2026 21:46:06 -0500:

> git://git.samba.org/ksmbd.git tags/v7.2-rc3-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1229e2e57a5c2980ccd457b9b53ea0eed5a22ab3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
