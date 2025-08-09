Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21E61D618C;
	Sat,  9 Aug 2025 05:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754716793; cv=none; b=cgvafM+ts0jJ/uIDmKXODT7Glkrj16YHESA65VwKPtHof6UCOqAyKb55ld0fjiAP0mqPDaLk/N2HJAFbA7fpuGVrLJ6xiij9O77eCrDVIgYwG/DhEdHQfhkJfDASpwSW2sDaS2Sk8Rb7mU8Jtcpl2OJHkEEK3Vix8T7E4+4kE30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754716793; c=relaxed/simple;
	bh=gHHzsHnRhrXXzuIAu1R9b5lMh6B6ebrPoasrmJKaiTE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=np1LK5FVsQiXzFNxzFOdO12P0EuuAHocwYyaoW77yHcQlNFXrAUVu90Lg5qzg/Rsomjb48PkKHyk7bk1qDGAQtGMRCYAI8b6LXXhJIFhfbrxd80JgGvxRIbXQRWvq1wFIBs3N+cpplAWaZESDCsTMRmzWTSR3ra4BFgM4cpbzZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ELfinH/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ELfinH/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D613DC4CEE7;
	Sat,  9 Aug 2025 05:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754716792;
	bh=gHHzsHnRhrXXzuIAu1R9b5lMh6B6ebrPoasrmJKaiTE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ELfinH/ccErmm2ZFMukHUW54CmV2nD/wM3lwxpAJv/5xVVcGMJBUk1MgeijC0gO5B
	 VDt6qrdQ0cOSuaEfVulBkuI1zzI4/SxWxd6HJbJZEpikBbwWKEO6eyi8Hs3KkTuwzQ
	 v15DsQ4Bq+tmI1dBzntQzqYRLyXA1fa4DPi8/S67+XJdR+/skZy8NkS4zeLv75GI0v
	 5eAcIC8+9dugVVbilqgAC81AeP2eE+kW2LdU15pEl+KO4KebiNfDWrx1TGfmbZrTBk
	 O+V6PRLyc7oqrouZw5yEj1CKBp9b5iYK2madPwmxQED+Ns0Du23rKU6eeGAC2bWSGA
	 sTk/xm9mR2sVw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D63383BF5A;
	Sat,  9 Aug 2025 05:20:07 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtLo02s=t_PUh99CniXe3qLaWBypkxqJO8gj1zqwyUoXA@mail.gmail.com>
References: <CAH2r5mtLo02s=t_PUh99CniXe3qLaWBypkxqJO8gj1zqwyUoXA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtLo02s=t_PUh99CniXe3qLaWBypkxqJO8gj1zqwyUoXA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.17rc-part2-SMB3-client-fixes
X-PR-Tracked-Commit-Id: dfe6f14aedbf59bfb7145de5c7da908583ae50fd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cfaf773b7946fa911e311acd3b82d61c7a9e42c2
Message-Id: <175471680570.380510.1573323379572550196.pr-tracker-bot@kernel.org>
Date: Sat, 09 Aug 2025 05:20:05 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 8 Aug 2025 16:21:57 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.17rc-part2-SMB3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cfaf773b7946fa911e311acd3b82d61c7a9e42c2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
