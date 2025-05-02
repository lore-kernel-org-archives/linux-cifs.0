Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AF4158DA3;
	Fri,  2 May 2025 22:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746223356; cv=none; b=tlSOjsvVngiKAzpjy7vaJFfHxgVNx4fA7x/ihlPxYX7ifct0wS58CpUhMJw0DqJzt/gX7U5C3VN/dln1ZDtTGOdL9plGmDKnb0pr0cclFq1vzAeU2lgGCnEeUFUK9bgr845aespLBTb7oLTXrdh0kWmCWIbhZke47ypv4A9Gq4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746223356; c=relaxed/simple;
	bh=xKFaFIhjjLaeU2dm+utRchf5z7uHb1vtiV/8ddS6c5k=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=dX0wJmftQOiFxObnJamOEN4Wx0cWf8jve17klVCKnJr5+UX9V5ufuKzbH2N4hGT4uZWtBiVpe5vll+syeInEAfiYo5/XbaVBed1BzpN4qINS5MpTTgff2w6pSLfzPgiomq82dFsd3Nq4t8RClFpPYaGxJcxD99HVvnNd0E03Tfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sJw+RE7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sJw+RE7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074E1C4CEEB;
	Fri,  2 May 2025 22:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746223356;
	bh=xKFaFIhjjLaeU2dm+utRchf5z7uHb1vtiV/8ddS6c5k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=sJw+RE7U0bWBEi0FPYwc6u9jmVM2319mABYPR0WyLz12MDgD/El7ZTnJ06rV96xuP
	 odRWHAyQTVw6g90qb4UHPplIJsulI9W9egzlV4NxMjZ0WSNUzpfMW2QU0MJVWoUp/A
	 YVPNz3MX2wUNpsiRdN34t6S7yhA1aZzDQKZ6gTwMuuyrzMYv5agpunuhDu0c/TIUMb
	 5zs6CKdsTGFDaPUuMMTPP4qyu7aDt/n6Wb6Lp/5oUy/IWbad5Ri+F4iiGGIE99qS+T
	 6AfYbdXamGT47UGJWjNogEaw/pGhb2or17Rck6D4PayMjpjj6x+Rz+VJk6YXALBE13
	 mJzuxs8tuHAXA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7128B380DBE9;
	Fri,  2 May 2025 22:03:16 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvFmxyPuxTOzGVvDOq1N3nYwh2ogj7yA-rrABdXgGpjbQ@mail.gmail.com>
References: <CAH2r5mvFmxyPuxTOzGVvDOq1N3nYwh2ogj7yA-rrABdXgGpjbQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvFmxyPuxTOzGVvDOq1N3nYwh2ogj7yA-rrABdXgGpjbQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc4-smb3-client-fixes
X-PR-Tracked-Commit-Id: c59f7c9661b9d3ee33a21d7b4f1dd4b77079e3e7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: daad00c063a1b3ae4a7814a6047009d471f21073
Message-Id: <174622339506.3739591.7378055221412590918.pr-tracker-bot@kernel.org>
Date: Fri, 02 May 2025 22:03:15 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 2 May 2025 15:17:44 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc4-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/daad00c063a1b3ae4a7814a6047009d471f21073

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
