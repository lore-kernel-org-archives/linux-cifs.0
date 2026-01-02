Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992C12BE032;
	Fri,  2 Jan 2026 17:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767376609; cv=none; b=ZiDHGnUYGs037XS1gx08OK/kJ4vTzY6Y9IBY+VqT4ePCq81pIYyCau7iGQoZnfWDsI7G5p9rYNTu9nFxPEEQ8qa6zXiSYtyI6aYSo/8YDrj6tZjiZLRKmykMSU01fZLfWMfvFBYPKOPHHVoj77TrZP+a3le9KV1ozhK4gC+u1+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767376609; c=relaxed/simple;
	bh=q3/1iBX1MRB2ozI11HT/JbSyHih3ovXBRtYj0t/o0Kg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=o39pX3hXKUA432pNvyq7dwoDilbsYf7+cuXBf7Qy+95lvUhBCUhy9knOYKRkILrD3/L2BJGFmPvwS3zvWzF/85JlZSZ0DU/KNiu6g+xWdLuf//x8WqU2FLvBAr1d75eJ1Vc7cnF3ALwGefUrP9dOzJo48zKTBblLosuam3UnNmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vApp38Kn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vApp38Kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD1CC19421;
	Fri,  2 Jan 2026 17:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767376608;
	bh=q3/1iBX1MRB2ozI11HT/JbSyHih3ovXBRtYj0t/o0Kg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=vApp38KnmIKZujGzaYwBE47ISpmDlJXsubmNocKM4uhfJQnKUB1w7qhMv23/bWDNN
	 CP++M+Pl6D2GsiW+tcMP5N8NSD5oUFgLwCafPRFi8r8R3cemBb7ZkCgDFlG6kYDs0F
	 MZaCocDoWjyXcvmdhTkT0KCTUUjTtCKUObEX4fZ38p/xc6DGqAYdUYDP/PP+zhvXzA
	 fVFXfxCp69Kku+KGxAolWYoq0l/iEVIECpZals0Py3x7a44O4rvchOSJLj/qa9S+Gu
	 9/0VtpnzUByaq03U7W4gHpMUMwrWi0vnYnaQNofe0+uJCySOwzR+5kkPK+d6NbKl/J
	 /KLTpmgVXeVHw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 788CB380A960;
	Fri,  2 Jan 2026 17:53:29 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtZfrePFu5F-xiQXaaE_piwoe1i=BkpwFmve_ywKiCpsA@mail.gmail.com>
References: <CAH2r5mtZfrePFu5F-xiQXaaE_piwoe1i=BkpwFmve_ywKiCpsA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtZfrePFu5F-xiQXaaE_piwoe1i=BkpwFmve_ywKiCpsA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.19-rc3-smb3-server-fixes
X-PR-Tracked-Commit-Id: f416c556997aa56ec4384c6b6efd6a0e6ac70aa7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e3a97ab1bbc36be6467fd606c0af1120b6146ddc
Message-Id: <176737640796.3971834.17501196255447746084.pr-tracker-bot@kernel.org>
Date: Fri, 02 Jan 2026 17:53:27 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 2 Jan 2026 08:37:03 -0600:

> git://git.samba.org/ksmbd.git tags/v6.19-rc3-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e3a97ab1bbc36be6467fd606c0af1120b6146ddc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
