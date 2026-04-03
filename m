Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502D7352C2B;
	Fri,  3 Apr 2026 04:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775189550; cv=none; b=G4GAvDqh4+QXDUNjV+U2De47HQpasKi0iH0/liDStyXN/Dx00K2KN1p6TxnjriGYM1syawlPku+S7JOygSuBn2zoSHjJazT33Lhk0DYCkDhqadOdLItb5iaTAXOkoJdxsk7IZbK1qbk0ZIrLuAZgpi4mFtR/TnRTLTfZqxFiBB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775189550; c=relaxed/simple;
	bh=tgkKc/284a5p0a9NWbFbZF/gZ+UXkj2RZ0go547+63I=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=SwlS1Qmbej5yybLvMlOqt4WPKWMeoN5HJUGK3hL9Q7f9q8T3wuZFQirehh0ZI+dbO3a8uYbKIikEOV3ROFI0t5aG0gIkqXkqrmu7kSiLe42ZwcC2ZxkGk9L9ejNbt0A5HLuAfT0vcEoIbif3AWn7UPKcuYnV3nMTRyxJ/rs5ou0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T7AWb2GO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T7AWb2GO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AABC4CEF7;
	Fri,  3 Apr 2026 04:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775189550;
	bh=tgkKc/284a5p0a9NWbFbZF/gZ+UXkj2RZ0go547+63I=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=T7AWb2GOVVBqn1WNgMds9VJz61hDPBblr4gIE1k+FB8+yFBrepX/fvQ4noSFuxR/q
	 S0ml53EvYDvCrqNtAu0ZdADnb7ERHauATlrJmj0WicvdhmXJn2UFn2Hd1UvUOGCGSP
	 W6NblJq7/BnM3TG5gMDb5QCzftzisUWnC66poB4D0QTPUkDvMqyWTKrBZ+9aaVpsiF
	 VunqYoR7k5O4fqIoz09XshyD4a5teXLrxqQqM5ZSPEdpchJ+jUVSx78g7SLaom1s3N
	 o3p+yf8fuCW7T+a1QzT9DQN/EDdHUoWVBofCXeYPk/tn7Yh5aylQZDKIiWqN1oO9SE
	 m7FhMIPxSP5cw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CDDD3809A09;
	Fri,  3 Apr 2026 04:12:13 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt3DJXG6L-x-4vuF8mf9Gj2=ZBtGrNwf=obHzOtXWd-7A@mail.gmail.com>
References: <CAH2r5mt3DJXG6L-x-4vuF8mf9Gj2=ZBtGrNwf=obHzOtXWd-7A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt3DJXG6L-x-4vuF8mf9Gj2=ZBtGrNwf=obHzOtXWd-7A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc6-smb3-client-fix
X-PR-Tracked-Commit-Id: 78ec5bf2f589ec7fd8f169394bfeca541b077317
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d8a9a4b11a137909e306e50346148fc5c3b63f9d
Message-Id: <177518953214.733087.4012738434041422454.pr-tracker-bot@kernel.org>
Date: Fri, 03 Apr 2026 04:12:12 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 2 Apr 2026 22:03:07 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc6-smb3-client-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d8a9a4b11a137909e306e50346148fc5c3b63f9d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
