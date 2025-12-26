Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146DA28E0F;
	Fri, 26 Dec 2025 19:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766778827; cv=none; b=loGUCgbcZI/6aprEd6rSsWmQ0TAx5oZQRLfBTktg4/I72RSvS3ef65d4ml6MvxXX9b2dk+v+OdNGHLhOTxHVoeIXS+wnrbm95UnY4pWFre6HQQcyEqvZbnMOyuxAxQQ9tZ7p3UAKR4L2RRYIml2gspNuuVi1k+LCJgvGKILr5Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766778827; c=relaxed/simple;
	bh=oer9JiJfg8/7t1PggocD2Eu3T5noLmzO07prhVEFO4M=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=qCLuYcdjkst8jbI4iM3DLVF2nAqNvSb0vP9QawF5KlIkQINmriQ1M8BVvnbBuDWzVKqX3j5IahPSISq+6YC/+tUCdJQYDD8YkMLBXkDZUvZv2dvVGSRliREY5zcwg74RxXTTHFXXSr/69+1Sm3EYlDwHL359ucnortynEceP520=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=osrDhN+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="osrDhN+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2424C4CEF7;
	Fri, 26 Dec 2025 19:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766778826;
	bh=oer9JiJfg8/7t1PggocD2Eu3T5noLmzO07prhVEFO4M=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=osrDhN+Usfa4WoI42xIkeWMxtD3pV/zkYD1+sSI4+zZQ0+HacAGKm5SSNW/bTZR6M
	 EH4sxT3l/GGRKHtcndGBjdw77Q1E6pTebe3hiLqTQT+cLnb99Pjg/MZMfJXRbX6g2c
	 xpP8gWK+/hqqbzMkIezcIfy1to6mW9hyR5xAsiBTBjuO+S5Nu9mt0fKeqqf+lcmBoE
	 o/nQe7WqRC+4UGcFeH4+R1auM74nyAyx2Uw55lK4D9BfOdfV9fg6/xcx/g+b0JjRLP
	 0sleZiNoEluLem89EqaKD8fiQqu78jqbT1i1K4AO4UM3lQqYHGLKaLQY45QuoUl+9a
	 eC3fDXID4+Ncg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 78C65380A959;
	Fri, 26 Dec 2025 19:50:32 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msp+pQr8o77F41w7vdiV369y2e=vfn2MC2P12zR7mLKJQ@mail.gmail.com>
References: <CAH2r5msp+pQr8o77F41w7vdiV369y2e=vfn2MC2P12zR7mLKJQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msp+pQr8o77F41w7vdiV369y2e=vfn2MC2P12zR7mLKJQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.19-rc2-smb3-server-fixes
X-PR-Tracked-Commit-Id: 4c7d8eb9a79ae5400eac19c4f6f0815bff674452
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e2cc6440895a57977ba818d4aaffcb59db7b66a0
Message-Id: <176677863106.1987757.9095902060491575312.pr-tracker-bot@kernel.org>
Date: Fri, 26 Dec 2025 19:50:31 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 26 Dec 2025 07:37:53 -0600:

> git://git.samba.org/ksmbd.git tags/v6.19-rc2-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e2cc6440895a57977ba818d4aaffcb59db7b66a0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
