Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D9633D6F8;
	Sat, 25 Jul 2026 03:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784949163; cv=none; b=k66fUOdwRkMKqKthQxoj2W/7W+nj4A3EcrM9WpFL/nKY8Uku+CtXmg2rn3HqW7KAdZaPjh99cXHTcjIEEOj7P/lW4oF/LwWzoREPB5HSXGvu297hSShJrr4ps8N9MLioIhnccM0SR0uo3IBScs1cx4gI73XbmvMkUsqHow+IFms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784949163; c=relaxed/simple;
	bh=3yGfFXx+vuAiUOiprJL2fq3cchUq8DLHkizBJT+s1z4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=j6P15P1BVuT/4V44QrrnCeT2e8HayPlQrZ0VZ1epfmx+8XYJdYcCFgsRKh1NAdQdL9LZghkWpAtuC47dW0PEXy0y/faJKXJc6mFEhiUvYMoTzKjj2u3Py4/pyp6PUSUR4hhHXAuFv9FyXZe/ScrMco9TNfEjIVGzoSBUfJBoA4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iR8Kqkmw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iR8Kqkmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA7C1F000E9;
	Sat, 25 Jul 2026 03:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784949140;
	bh=uPwkmS45OHkTL5LZ3ziU0XVW4xwLpbB8nTHnFFCrBrY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=iR8KqkmwZye3/lmUJJsryURiS3hhIBuRUMqjZRks2a0MWXLaotz3eiv2Xu1aLnoCZ
	 6rnr/CycFyAlWjVB912U7zM6XUB39BXr7YrjArckwcXV3NG7ZhevvMQZDDUnG/tCPJ
	 /2MAQ7bdRorovQQclVGc+0HF7+gWifmA9V0NGilC3WnsPujkmb+u39c7DErhuaqH9k
	 SZLC/HF612DM0JNBrjx6o68uXCZi/B/OfBSS3NAN9gU4q9qStG6JFvf3FKgmvLKMOm
	 M1XFXCsTHLptwRTCPKAtscJQiHNcfszDrPYW52p6coK3cxQmQ5pB1lyg7v1+Y1wZ1K
	 JwBGx9Eyl4C7w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0BBA38111D8;
	Sat, 25 Jul 2026 03:11:48 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtZzu=3b5uNP5+DoUXPXJ1nm3rJnLamJjM3aM5BOtiB2A@mail.gmail.com>
References: <CAH2r5mtZzu=3b5uNP5+DoUXPXJ1nm3rJnLamJjM3aM5BOtiB2A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtZzu=3b5uNP5+DoUXPXJ1nm3rJnLamJjM3aM5BOtiB2A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.2-rc4-smb3-server-fixes
X-PR-Tracked-Commit-Id: 5e1b924808568e89c5cb132ecebe1824bd91af0c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8e371eff3f72afde801c36007fa15fc7dd5314f3
Message-Id: <178494910742.3393598.14352263968180438960.pr-tracker-bot@kernel.org>
Date: Sat, 25 Jul 2026 03:11:47 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 24 Jul 2026 20:11:43 -0500:

> git://git.samba.org/ksmbd.git tags/v7.2-rc4-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8e371eff3f72afde801c36007fa15fc7dd5314f3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
