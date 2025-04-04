Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FAE2CA6;
	Fri,  4 Apr 2025 22:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743806114; cv=none; b=lDNhZTmnJrt2vJFDOWalhwxi1VxgqWC2eJgspKXICMMmS7gwMd/oytkm55FbXUo5g+3KomDWJ6JS4YYy9frR1S/GfNzNiBW8j0CyJxsj77jx9PPTBjdDsv+MfOihx8vGj4xrzqCD5F0tZhNMzUsFYDjVJzaU/MAK8n3EouI4jow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743806114; c=relaxed/simple;
	bh=Bqhq5x4MyU5RKA1rydjfrLPOMzHkrqVwcDDSmswHrZI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=BjOZ24sL03bT2gOUq4U1ZdBx9CnzvdECEEozeJnX+IvjiwR7vKeOUDAHcBdMMH/X56apD0NrflGYx2bvtsY1Nci0iQlBCcOX7JM+z84ef09PXf9KAnnUnP2QNzHlyNkHxEqY3GBxQZs65fxE+WnNhKaDeR7ciR2J6ZCuz2DqNUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p/k4wKA/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p/k4wKA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD465C4CEDD;
	Fri,  4 Apr 2025 22:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743806113;
	bh=Bqhq5x4MyU5RKA1rydjfrLPOMzHkrqVwcDDSmswHrZI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=p/k4wKA/V/PXFe++QHEXiDXCanx/tHGwfdUWIViEKo+oiPG7R/GRcS55ZqbS/kmHE
	 JdPNUYgPI27xiyXH5+XyMM4burlX0C8tvY2BOKfgC2mm3OFWKNQlLVdG0iFa557n0e
	 +kdIjso1K+BWyBuwCZhoeCpxDRDmZs8lS0gKrC5UcaFUNn64GaswfMJpDhs12j8z1y
	 VnBjxdSLmC/tvLFDPr/zD6Brv2vSE2Bz6CASq2kZF7x4vlR+9L0A+aKl6R6gNALtUf
	 NJcAUC8i+I/jt504gLQZHMmWKzplVRhAwKgV6A9FXYhQWh8hRlzqiD4wY0YS/B8XbM
	 qPnXDFXOv0qrQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33E563822D19;
	Fri,  4 Apr 2025 22:35:52 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muz6e_n10Yia4R686nJsgqvzgpBVQ5vKk4oQe4tL-Wwqg@mail.gmail.com>
References: <CAH2r5muz6e_n10Yia4R686nJsgqvzgpBVQ5vKk4oQe4tL-Wwqg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muz6e_n10Yia4R686nJsgqvzgpBVQ5vKk4oQe4tL-Wwqg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc-part2-smb3-client-fixes
X-PR-Tracked-Commit-Id: 827a1bd9af9df6a4023736ff52475b2a5395d91d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9f867ba24d3665d9ac9d9ef1f51844eb4479b291
Message-Id: <174380615083.3459750.16087945652693205043.pr-tracker-bot@kernel.org>
Date: Fri, 04 Apr 2025 22:35:50 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 4 Apr 2025 17:10:47 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc-part2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9f867ba24d3665d9ac9d9ef1f51844eb4479b291

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
