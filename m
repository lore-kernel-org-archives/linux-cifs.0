Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D41185B48;
	Fri, 18 Oct 2024 18:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729278000; cv=none; b=WF22plURSBtd9Ol7GuQ63geJOtSBqm3ebcJbXKuHrTAFxM+Z0J6HE3LSTORq0y5AEHPGw6iwQOQRCNO8sn1U2uEYh49yMYQQH+ITuFLJyZxDWEauUZs/cxdO2rLw75taxx3ECro4kTE49wC2cxgk17hbCZh3QxBCtYdxTiJ3HCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729278000; c=relaxed/simple;
	bh=0aG0Vdh39Bpjw/ze8sXOJQx0EwB/LjnoHP4xrp3JZhU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PAaRj7VrSuVIb0pa3w4ZxmhH1gp7FhBBxwm0uM0UfwFtK17WSgGF00dXTIlsr9LqaLfFa9ZhID8nqIAO8e/0e82ke2Zv/Mck69gVP1pFrQIe2kOhP2bkh+NxjaNpGRDAcnWjbMt0qPltXcKXJM7NeDivWQfYAIOFqcIkNzFC5gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gL5Ahir1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gL5Ahir1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE50C4CEC3;
	Fri, 18 Oct 2024 18:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729277999;
	bh=0aG0Vdh39Bpjw/ze8sXOJQx0EwB/LjnoHP4xrp3JZhU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=gL5Ahir1sygyksLSTK1EuP9rkBRkzXNbn+1lW4Fu1ZbxJ+vBZq4cHIdBGfVsBaMnb
	 19Gg/0uTnydWxAusz24odNb5ClA7D2Zbxl868T7qzTMtsjWtmcNsSRaT9U2yIIgp7/
	 x5znB9J//e0nsf4eucgylRiRDSN8Pbjj5DXOc5HMyima3v8GGoTb8eVrEMYSlbww8N
	 tkoezADhK4Faj5Iqm25zbfkPCVy4PxWL6XQWjL7gifyC0mwWbMm1avy0XGRPKNp3h0
	 giUJfMsKtnLaydGd5YpAcTjEEgIdI1M9ostEDNjuawJOkIOYp9d7A1psSP6kAPsB1i
	 tQkUXBJvF5qtg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB8973805CC0;
	Fri, 18 Oct 2024 19:00:05 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvOjw1o6RcYu8OHCANy+Z2+9ONS+tYjRFbX_o3QgT95Kg@mail.gmail.com>
References: <CAH2r5mvOjw1o6RcYu8OHCANy+Z2+9ONS+tYjRFbX_o3QgT95Kg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvOjw1o6RcYu8OHCANy+Z2+9ONS+tYjRFbX_o3QgT95Kg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.12-rc3-smb3-client-fixes
X-PR-Tracked-Commit-Id: 6aca91c416f626fc0c5146cc4450ea86b831f3dd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b04ae0f45168973edb658ac2385045ac13c5aca7
Message-Id: <172927800438.3206390.2616348466005175783.pr-tracker-bot@kernel.org>
Date: Fri, 18 Oct 2024 19:00:04 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 18 Oct 2024 10:00:27 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.12-rc3-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b04ae0f45168973edb658ac2385045ac13c5aca7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
