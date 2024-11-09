Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B0742069;
	Sat,  9 Nov 2024 22:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731189654; cv=none; b=eV5/1bTvm3jMnu1rWl+fwqBpVUPJ3e05S5KuhCpy+d25cP6LVdBFQxb3mal2AzdJVufFK/yPMDV/HdvChV/9xPkDgEPzOyXKUk+/SrUlb9VP48xlAoSrJCz/qdkH9pqjcIivYQtNE/xLAxAd3mQ4I4Ohpm+ej3bfHYTtgVJ1Sms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731189654; c=relaxed/simple;
	bh=DUnU4hrmC+pY1uqfIiWGbxHl79IOG6KseEtUwNfXR+A=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=BeulR93oB3hRTY4RH4PhCw46F6CvHJc8Z30XbjfwIf5hUBDiFf6RDcK7bLhXZIa2BywxTvLPXU/0c5aZeR9FoQXpPBybcR/XcucsEWZOxMMPLuxdaBV8ByuXKmXxnrHIo6bPtHm0YKk4ySvYrOiQ/LMl2TdrIux6lueMLhYCMig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M8VdOkOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M8VdOkOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C2CC4CECE;
	Sat,  9 Nov 2024 22:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731189653;
	bh=DUnU4hrmC+pY1uqfIiWGbxHl79IOG6KseEtUwNfXR+A=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=M8VdOkOJV0FE0A3gnMYrN/fATu0E5YNiFBPAcQ483Wc1MOxHH6AYlddWQxwyjvLog
	 vJWeCbZ/5H0e/pmAOJOSdndY/K163JWS3jGNkXJkxGDMRNoZU0sPwqqkHPTMELp+DG
	 titQkwqzKiR0HEXipVq3Bn0j2go5NM5BTIlpE5hWyabjhu4n1/YNXdhwp4wRAXjwQX
	 XFX7P0KZCEeu/dqCLPIlHAwYVQZV+BpeoI3CbM4U69VmFKfPvQerKB27xlrmGhat8V
	 tiDUDSTqOkJwrebyf++zG1JnOEpB9rAxUUd88p9drzm47dWCrh8VCWylYpq9ZgKnAx
	 g+ajo24EJOFXA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADCB03809A80;
	Sat,  9 Nov 2024 22:01:04 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muek3UG_akFmCon+NxksAUuWn9ZaY-AMiXSh9OLA8QvUw@mail.gmail.com>
References: <CAH2r5muek3UG_akFmCon+NxksAUuWn9ZaY-AMiXSh9OLA8QvUw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muek3UG_akFmCon+NxksAUuWn9ZaY-AMiXSh9OLA8QvUw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.12-rc6-smb3-client-fix
X-PR-Tracked-Commit-Id: ef7134c7fc48e1441b398e55a862232868a6f0a7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bceea667990a3c00d371a58120a457452b4c741c
Message-Id: <173118966332.3021408.17895186757090243569.pr-tracker-bot@kernel.org>
Date: Sat, 09 Nov 2024 22:01:03 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 9 Nov 2024 10:19:40 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.12-rc6-smb3-client-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bceea667990a3c00d371a58120a457452b4c741c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
