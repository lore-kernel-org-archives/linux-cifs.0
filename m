Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C52B1EE7DC;
	Thu, 27 Nov 2025 04:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764217686; cv=none; b=MJJhhgYwHvlpO9mnhamuyyQ69Ms8JFyNujbjRnKxq8r5a7i6zRePNVmfMv1zfTE2j6+f1mTWTISqc40EiUGNEErrx5I3RpZEC00HBaBC5VTciECJ5LsYb3bqNFcMJ8695csi6J2RBM4kHeya96zTGZVXyGcLBocvXGbvXULL2P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764217686; c=relaxed/simple;
	bh=ZFICrgHGMt4cZlfcTYxQ2rbg4lhgVJdea5xn9gBls0Q=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=gJ5IhvN1EQH3iCE3y1aOEhQuymzbRVzuMMk9puVvxmngLrN/CIcfRc5A0AE+PPtCnMGGV5r7Xv7wMeA4WKzZa+ZJSIkyN1EfEPTW4QwFjOpCvZz5zZAKH3Oa76xDMG2sTSGvhmHf3x5XU7FdmoSLnWbtH0iM2cPBzDP4M9Kbrrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rPB+9UaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rPB+9UaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB18BC4CEF8;
	Thu, 27 Nov 2025 04:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764217683;
	bh=ZFICrgHGMt4cZlfcTYxQ2rbg4lhgVJdea5xn9gBls0Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=rPB+9UaMws6avoocinB2eqG3shk7Kj7ZrT5MQYZkxZSKnjAggrwtAt2QeqrHOqzZx
	 ZOMMkUYlnJdDgFndJRen8PhUTyyH6SqfeBgATflCCKiQ0TBZt/sYpw9GP1FD4mWFqo
	 Gubi7hcCJxgaKv0unj608gZBiX/MJ3eQOQHHP062Scs5zan/hTTxdAdxAZ/nxRV8m0
	 aBfyJkU6BwmcMA8QvyeugOZvSYPpGT4cSGD4fGrLujeYv6GdRrSsTfghIIl1fX3n4D
	 AXAN3xiyr4ik4g/9GZu9fDskr/DbTFbwapgBn9edH0VB82bxJZy5sBn45Tlc6pUM6d
	 Iaa3nPSjfnUIA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE03B380CEF8;
	Thu, 27 Nov 2025 04:27:26 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mscsSWyptKojMFVYGS+F=9obcUFoApwQ67cXQVgkCn=0w@mail.gmail.com>
References: <CAH2r5mscsSWyptKojMFVYGS+F=9obcUFoApwQ67cXQVgkCn=0w@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mscsSWyptKojMFVYGS+F=9obcUFoApwQ67cXQVgkCn=0w@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.18rc7-SMB-client-fix
X-PR-Tracked-Commit-Id: 3184b6a5a24ec9ee74087b2a550476f386df7dc2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 765e56e41a5af2d456ddda6cbd617b9d3295ab4e
Message-Id: <176421764524.2417581.12855955953782583776.pr-tracker-bot@kernel.org>
Date: Thu, 27 Nov 2025 04:27:25 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 26 Nov 2025 21:04:12 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.18rc7-SMB-client-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/765e56e41a5af2d456ddda6cbd617b9d3295ab4e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
