Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C1E34AB17;
	Sat, 30 May 2026 16:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780157836; cv=none; b=NB71ZKQSYlS3l9SYziGFAZZQLOD2SDkKlw9whGVo/YsXIcP4OhNUsVPDoCKLv+3zxLoDrh+rkqZ10HrV+oj4xUtlBhNH3RPs6BzRgL7T9G/a9f4ski2HUf8ZI53GyjFd00egWRDmGC5k5xYqXZAxvjS3X4qBOZe9DD5p03Qi08c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780157836; c=relaxed/simple;
	bh=eGsqoVSziLHqa5BAvDbyjZKO6o3KEAtYUAonC6s1K3I=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PJq5FTiARLv/T6JOcwcYR9/bH+gDR+JTUcie7PaZoqYpm9/eTNC5Y/w3Dlv1534r5qk5phiJZKCjmjLzXq++V5rQRMB019U23WZbFPfjLy2H8TawqZXj7OyBmj8zFe5EE4t0dH7a50Hpph6TNMx38TsmeauJBeYxYFm2srNcLL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DjjdQPXn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DjjdQPXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDCD1F00A02;
	Sat, 30 May 2026 16:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780157815;
	bh=OnVkrOMSq7w/+2oiD76llq1TaQkUiMqji3MCKxD6c40=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=DjjdQPXns1aHJtpTND4Z8Lo1raUX60v7U21l9eLvnMb07Kb+l7Tge/EqJ+KWtSyo7
	 REqJHJH/oU8hC3NC/661cv2g/W4qhe2WGXTdauAFAIRVKKYlqTfpim0CwVQjza9ITE
	 6YV8EiOJj3wnSRJpvlWdpEoyfm8FJ7mKjzxI8Zmy6EnIOCzPEDjT2ZTCE0Q0zPxHo7
	 1YhovKFuryXuqzUiZt2Y+ZDMNwR6c9ZyYRFOs73gbLv/yfGarXqp3XeBpeXijJyKHh
	 v4aLYn1iS3XIEtlDwFzJcx4HvpXLEUScUGwsM4AeKrFRZxst+kiiiFs4Ypg2eir6o8
	 qLi1xsA7jEWGg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93F18393021E;
	Sat, 30 May 2026 16:16:59 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muwEzNYv-g_A41PSTFJoOCW6AzBD5U1WCuzTrao8k9xVA@mail.gmail.com>
References: <CAH2r5muwEzNYv-g_A41PSTFJoOCW6AzBD5U1WCuzTrao8k9xVA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muwEzNYv-g_A41PSTFJoOCW6AzBD5U1WCuzTrao8k9xVA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.1-rc6-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: cc57232cae23c0df91b4a59d0f519141ce9b5b02
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1246c246d9f684599e1dd7498043062c89fb0a36
Message-Id: <178015781808.2653560.14082876548560956749.pr-tracker-bot@kernel.org>
Date: Sat, 30 May 2026 16:16:58 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 29 May 2026 19:00:41 -0500:

> git://git.samba.org/ksmbd.git tags/v7.1-rc6-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1246c246d9f684599e1dd7498043062c89fb0a36

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
