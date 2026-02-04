Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0CB22D4DC;
	Wed,  4 Feb 2026 02:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770170883; cv=none; b=Z2xNtHDBKgrYMSt4r8FmAtudv9HYCvlMs1EL2XUUDIzZ/EWIYXzU0d8FLrzxZyTL0oMQWMhPWbWyEHLvwHdqtYX+fSXyJClDyrPFJUGwEn4QORSjmz3p9Vrxva0CoeIYawPl/ErJiIFJxslY+iyIH1A1deKAUHWjYNzlf/eHj/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770170883; c=relaxed/simple;
	bh=BoBF/7fo4gn/LN2kSYYyvLcVYXB39hvbOI0vch0Rn/I=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=XzQimCv/g2xj/APVpsZ9AmKUSMZPXSYwnOmdc+P2PR0AsV4TsYtwxXg1OSMjO9RrDutptCy2JetKIl0PvFvP4LQKTFw2omQy9WSdqm9T3wbZ8u+YOPlIXL9Bw8xKenNofP6nTcVFNTTkU1vS3g3H2jrBdl1NcegbCbuzzcsiVTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XTGFKvFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTGFKvFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F72C116D0;
	Wed,  4 Feb 2026 02:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770170883;
	bh=BoBF/7fo4gn/LN2kSYYyvLcVYXB39hvbOI0vch0Rn/I=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=XTGFKvFT2aqsH00a6B/Kd9+fI+3XE+wnsGRag6qbFWB/EBcrNC6RL+PvBpN/9Ucx+
	 c+IytFdprTP8zG9aRr5twN3z+YJkSqJtuSYl1OoptOXr+f3Y/EfXEHBf71mD9j3/8H
	 2TlKGjGDjfyAkJtS7wJEeuaX/bPrBBw/cWmqGZRQoGB20gCqv9t+KUeZuCW3aWEaUt
	 aw7ZfiIl+r4gteddsKnfEzckW5CUtthAUre9+w4aWQ7GOXm+1ke4lIK4RduCN1Ifqv
	 S3jqe0c1/LZyLP6sCSC7vlFPNfo569gPzHdt/oCNbG0GNapxURhoEBo6ZPWuldZpQ9
	 lD7qI58w/TWBw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id CE27C3808200;
	Wed,  4 Feb 2026 02:08:00 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muFeTGASj_7gRrhJq+=k8SA5aEz=oOHzxOfpHojLBsSHg@mail.gmail.com>
References: <CAH2r5muFeTGASj_7gRrhJq+=k8SA5aEz=oOHzxOfpHojLBsSHg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muFeTGASj_7gRrhJq+=k8SA5aEz=oOHzxOfpHojLBsSHg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19rc8-smb3-client-fixes
X-PR-Tracked-Commit-Id: 67b3da8d3051fba7e1523b3afce4f71c658f15f8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5fd0a1df5d05ad066e5618ccdd3d0fa6cb686c27
Message-Id: <177017087935.2142113.12083608326809791161.pr-tracker-bot@kernel.org>
Date: Wed, 04 Feb 2026 02:07:59 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 3 Feb 2026 18:13:51 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19rc8-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5fd0a1df5d05ad066e5618ccdd3d0fa6cb686c27

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
