Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1061D9A79;
	Fri,  4 Oct 2024 17:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728064204; cv=none; b=GUMblJt4IFGaoKAhODojA/0c7jXF4IdXRYNE3aboK4PIGfVc2rvNa3Bx0hS+U8vKlS4Pp0CXYi1oVzTAmKJvWMKyC8K3o2opdJrZV75qb4wlMJ1nZ1w5kARAALKLPV7AwTStQ2I2eyMizxJ+dx00AAQA1S+DtdmLDP8hUgtTmC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728064204; c=relaxed/simple;
	bh=qK3Swpueuuru2GuaX4ypEESZFU6fbikFCmKiOGi7MYI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=OyYZbrTs6IThe8S7y6vbR6FA20W7oS//kETOD1uaiCYbyrY2abRtTx+3ToOMJ1BQQUi4TIOvMR7AOkBPm2LaNslsAWVdH3wgmKlEm6+ywdV3SsivANsept8gankXc2jIuN0RwrS7ASHHbaFo0AkCRcyLRapw/aXhHNc7HZFtoHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bsCKN98o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bsCKN98o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED4FC4CECD;
	Fri,  4 Oct 2024 17:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728064204;
	bh=qK3Swpueuuru2GuaX4ypEESZFU6fbikFCmKiOGi7MYI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bsCKN98orwKwJcoaFDa52cyYXKRmdgiLN5iZOpUn0oTqAn6K0OreHMh8PTlYySY1K
	 FwArXXHZWJ3CARgMAoqRBZpibnBaKdx3H1/8nAxw4ji3lEjDHyMI1DWuxw4rvc0+b1
	 r3KAypz0xCe4fkMajQpJOPHT7DxHvwnP5htGur4Pu/jIQ0urd4MLt7UHgYouGuWoqH
	 bzKgyCGY3zvBrblm8PI0lf9J6K05V6folMIj/LINGbCd0AF2uUlhEQOw0XjicQLY0V
	 Z/6zwsRhA+vGqOslzcW5eM3uqpBY1Zn7haWVeTbLdbriMQFAhFglJb6pTpL7I/eQoo
	 Tc2c54EMeFhxA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F37F53ACF641;
	Fri,  4 Oct 2024 17:50:08 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtkbzY5hRNZQH4TzLV8gP90ni=Zk-DsSpEC4_uEWT6_Bw@mail.gmail.com>
References: <CAH2r5mtkbzY5hRNZQH4TzLV8gP90ni=Zk-DsSpEC4_uEWT6_Bw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtkbzY5hRNZQH4TzLV8gP90ni=Zk-DsSpEC4_uEWT6_Bw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.12-rc1-smb3-client-fixes
X-PR-Tracked-Commit-Id: d3a49f60917323228f8fdeee313260ef14f94df7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b7a838ee7e8904c14e5d6ca2d0029bbad70fb761
Message-Id: <172806420790.2676326.17689044083270518167.pr-tracker-bot@kernel.org>
Date: Fri, 04 Oct 2024 17:50:07 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 3 Oct 2024 20:36:17 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.12-rc1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b7a838ee7e8904c14e5d6ca2d0029bbad70fb761

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
