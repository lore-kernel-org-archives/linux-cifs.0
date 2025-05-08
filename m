Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6770E14D29B;
	Thu,  8 May 2025 15:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719176; cv=none; b=sji8O8xLIa14G48CgAuLIqi3R+ZRhgIlVwNq+b7zNsNOLZWeYyC51h2qMOjT8ZKrk738t/2lh2T45GPP/KIDhK5/6BySgt6CwCQ1yaSWQVaOX8SL42kJ7NauTlARei3VdsJerSmckfBoSV70xLGI31gjLi/BUR6+Gw85aW7Nk6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719176; c=relaxed/simple;
	bh=vWcpRz07g8YiFtGjcMkVE1+gGLF5P2iFCeJZWDSLebY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=H+GnYwYLPcjaISJp8Y/VFEE2RZTBi3X7IdmvlkN8uvYes8jPhvSwSS2UxpZ3bmzjXdQH45hPIdbdzgrtYcz8WW5QGxsC+RbI7e6TfWaUtby94WrIYaqE5Oa7bOxSBDOSIt3nRXjs33IcsHicBZiIvKtRq/wB+vFgZsNsi96gpfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ccGz+ebv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ccGz+ebv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4551BC4CEE7;
	Thu,  8 May 2025 15:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746719176;
	bh=vWcpRz07g8YiFtGjcMkVE1+gGLF5P2iFCeJZWDSLebY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ccGz+ebvuumWX5J3nLva7N5P4JQgLesPRA9zAekziFbRMPTyE3C+rXj3PTlcztzhq
	 Is87IrXsnh6OtjZPUGH4Pp34127Ql7gt4yIDZwZzwSRvib0Kwxu4Pc/FOVF/CfGZDJ
	 CZUq2UI4GzKVdQIyYg6Ln70L3CKcYTndEoHNjjQxWDT4PVu4Ou74DfgsrJ9hBaoF9t
	 vdT35lZOj6fyaRyTsUm/adlSEWgpwV+kqNaFldcbItQgRTyyB55eQGU1vkFjsHWxgk
	 OHLreCPDi3BegHxQYEHs57PHIaXHuOiDD5eXD97ze4qKyWcNfHuLL3Pw9oKM3HGod6
	 QF4h4N4zCDHsQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D43380AA70;
	Thu,  8 May 2025 15:46:56 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mv5iu20LFsASnA=G3OUtrUAkp0CnKvckT+fbsYWzSAaLA@mail.gmail.com>
References: <CAH2r5mv5iu20LFsASnA=G3OUtrUAkp0CnKvckT+fbsYWzSAaLA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mv5iu20LFsASnA=G3OUtrUAkp0CnKvckT+fbsYWzSAaLA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.15-rc5-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 36991c1ccde2d5a521577c448ffe07fcccfe104d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 80ae5fb2296cf93add51368a96985ed9a18df781
Message-Id: <174671921488.2957681.8389590631473614991.pr-tracker-bot@kernel.org>
Date: Thu, 08 May 2025 15:46:54 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 7 May 2025 22:34:15 -0500:

> git://git.samba.org/ksmbd.git tags/v6.15-rc5-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/80ae5fb2296cf93add51368a96985ed9a18df781

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
