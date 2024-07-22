Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847F78F54;
	Mon, 22 Jul 2024 03:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721620453; cv=none; b=p0+2ZD70/rkDMpw5WGjz7Soq/TakYUW1c6Se1d1qo0qGWwVlVT1f1hMAV4haPlS0N3HwBEQ159bE5NpbHubmbvlRDkx8WYku4aYS8v3v42rQD56s3NZG9w8nvAnZ+2l4UjCOTSNkwxz/wG/JwQR9f1ElMmxS+cO2QbuMcLjrzo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721620453; c=relaxed/simple;
	bh=Xoq6qHMX+MFIUpU2RNgAxLP06VEW4/UnwJYIPdJ0CtM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=u34YrfOujFWlmOVcjLoIepbjMqzK8tRkU2Jfxl5EljCaUOJ1kg4L96wVMR24Ww6Q6ZGxmWl7fF6Znx2/X1XXfNzgVKg3mvJY8Kk/l87w/4vsL31rkpaRudSxAcr3FsHJPvnUuMwVUxEDPWkj+IAYdwws6IM99z4ghcmHOQUcuP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fgqzr65j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fgqzr65j"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1472FC116B1;
	Mon, 22 Jul 2024 03:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721620453;
	bh=Xoq6qHMX+MFIUpU2RNgAxLP06VEW4/UnwJYIPdJ0CtM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Fgqzr65jBsFtGoAgeT5mPXAD1c81JrUYZhp0h30Bjm7J2aFKqWSp+u3e+Pr3vVqno
	 P+SrqKqLHNdP5l7p55ahEEoimXkxlFysGkR+gOejQFHd2ii2DKcFU5bP9VuD7iTqPx
	 vAVEhsPPn9aW9ju8HbW5cz8/nO1ESG3aehNklpvDO9B3dxs7PLOWq6biExCoE7Rzbt
	 fcQDy9HhqDad0ua0LI4J710DOUIT2KXyFUNWQx4fttSidG/YCp1W6U3hwAR/srklk6
	 5WWvEGxRBuVs1R7xyqx2ebEdkTqGfst2+ol9vtFnJiHyfqrTtYsCR8TjqrTMXMHHG4
	 bCjdFA9g6vwjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A403C4332E;
	Mon, 22 Jul 2024 03:54:13 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvap+qkuW-vOa--d+hsqEfhmFcpFWfaL6W1vAWjjR==5g@mail.gmail.com>
References: <CAH2r5mvap+qkuW-vOa--d+hsqEfhmFcpFWfaL6W1vAWjjR==5g@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvap+qkuW-vOa--d+hsqEfhmFcpFWfaL6W1vAWjjR==5g@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.11-rc-smb3-server-fixes
X-PR-Tracked-Commit-Id: d484d621d40f4a8b8959008802d79bef3609641b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 933069701c1b507825b514317d4edd5d3fd9d417
Message-Id: <172162045303.5805.4583824994254146369.pr-tracker-bot@kernel.org>
Date: Mon, 22 Jul 2024 03:54:13 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 21 Jul 2024 18:55:51 -0500:

> git://git.samba.org/ksmbd.git tags/6.11-rc-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/933069701c1b507825b514317d4edd5d3fd9d417

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
