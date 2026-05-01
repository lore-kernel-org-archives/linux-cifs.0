Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B963603E8;
	Fri,  1 May 2026 20:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777666995; cv=none; b=T6aZndqOzhx1yKXdPsNlq6cs/tFKkQwsL+W5el9nU98OxLhz2xhVRRlSpt/AS8cIFVzcdmN3mjrlZEwUYgNhljRE7LiidOS83HCA6C601J++CcTaep63euykISTC6lHmzE5xHDwlqOsxkJekhJbViWMmDRaY8kfjgSvJHBYgLgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777666995; c=relaxed/simple;
	bh=5XTZVL6wd7isDTILqB932bhisYulTJzRYjeg1lh5Buw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jW1AM5WNY7L1djxiShcrct/7nw2dM4pfKT4dL+kY68nHFrRPr5SUPwONejEGjljuGSYY7i+j9l/W3YJCUz3T4GIDshgLAUpAMRCSg0MR8/Py98pgSjkJsjd0jQafQimlLftNWnKS9A5qZakewigLTmwUwq1uILVL3/AejcBECkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZ4hMj03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZ4hMj03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CADC2BCB4;
	Fri,  1 May 2026 20:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777666994;
	bh=5XTZVL6wd7isDTILqB932bhisYulTJzRYjeg1lh5Buw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=nZ4hMj03ttP/a8bZo7gut+XKnVIhm3652Q3+DVOjcvPIAv3NNH+Gyz/doxXcbQAE+
	 tXvcF99XD8dLcH1uEBVUoWl4XkVKcKct93wxkgn33T5jCXrv1++jE5yacblyW1QX6C
	 t1fVmDdNsemXtnnp7yLUOPSs2/9KOCl4Fv4p5XXmmhiUtv1D6fOcB5Wck+HUl1ZfUt
	 IJ2L3EfTlkY0ZbYVP93u0NKkJiO53AXUdZhfWarKyg7xLOJr8vPmfNZmgZtCWQAR3K
	 gMsnH0FrF8oaOHRji2PJYveyHQ1L+k5XkQDxxkn/L2D5agFCWB7UJg91UVd0ChDMxK
	 8sdl5HoYbIpdQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02D72380CEEC;
	Fri,  1 May 2026 20:22:29 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvWVFyYF0szBX0aqOjFViPq7f9QEyF=UagFASZqVkqtxA@mail.gmail.com>
References: <CAH2r5mvWVFyYF0szBX0aqOjFViPq7f9QEyF=UagFASZqVkqtxA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvWVFyYF0szBX0aqOjFViPq7f9QEyF=UagFASZqVkqtxA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.1-rc2-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: c444139cb747bf6de1922b39900fdf02281490f4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 227c3d546e963874198aafc0cae8c3e8c24ae4ee
Message-Id: <177766694748.3609975.13176574709407449792.pr-tracker-bot@kernel.org>
Date: Fri, 01 May 2026 20:22:27 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 30 Apr 2026 20:58:06 -0500:

> git://git.samba.org/ksmbd.git tags/v7.1-rc2-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/227c3d546e963874198aafc0cae8c3e8c24ae4ee

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
