Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C2C2853E0;
	Sat, 11 Jul 2026 02:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783735220; cv=none; b=fDW8RMc+HgCoJ0zMqRi8Vl8xrOJNOKpM+SmrzVQa27YSujicaS99CvMTySOgjZ9J3bgLpQ88nVSMueCHcuuYwv5HaBBoPefrOXzE7LaXL18P01H1IxWPop3wBPvuc0TS/fVebJFbarSYgTeID8wf2Rqb7yUdIqqaBjFYJy86Gvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783735220; c=relaxed/simple;
	bh=gagSZAvLCrzSFW8059P0cZPd6GyRXlyRJDfVNLCvwnI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=gWZPYRHeDqnf3bDUtNOv1MnCBC9/Edq/1fxzj9hGyMSqgHrlMIljISBR9OBnAkTpfTUQ1Qq5djgcuWhddi7uO60yFUX4CDaudw4wa21qGTD60Lh7xSo2kuiLg7NgiZ4q5z2kQug66gsMkELka66Uk6GM6b4pUUHW7ycQc3WrDbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0atNyA1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0atNyA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1B91F00A3E;
	Sat, 11 Jul 2026 02:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783735218;
	bh=+P2w66yh6KxPVwOM1rbl5IvKk5dyNiOJmO0mShHMVLg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=b0atNyA1Nzk7jhAzANtUk6bLsu+rF54vXqRS3dq0nZSHRr0hv/ds7mn+qKBrkieZ2
	 dxUNIhWJCxZY4ENmLrCIzyDSenqDO31tUfGKjaSwqZ9+mb9V09qvoEYr3y3vMf6iFr
	 J20tkzj/O7rDstvoLmb7F7fVLKx2GVc/r+mA93EaT0P06DSPzSslzjxJ85VD61JS1n
	 hzvOI4oK9h0nDXDbsa+cv7OWxBq2N4773qkSuCqWKvKCPVx8bhklIQFEhHsjftTmj7
	 HlTRR9B82Q82z4/IGBmOsoO1vh/ai0lO8uYhzBm7mnZ1FDi0NY5Dxoj8acCO8IUz2Z
	 TQPgAOpbk+syQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56B0639244DF;
	Sat, 11 Jul 2026 01:59:57 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msowam2AVfazUvVxhkoQ+PH=-Lx=u_U-nyArAnzUGrF8g@mail.gmail.com>
References: <CAH2r5msowam2AVfazUvVxhkoQ+PH=-Lx=u_U-nyArAnzUGrF8g@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msowam2AVfazUvVxhkoQ+PH=-Lx=u_U-nyArAnzUGrF8g@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc2-smb3-client-fixes
X-PR-Tracked-Commit-Id: d2c46c9f7a9baf80a322eb1d4494a70e535b637c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8eae393cbfd79311c0736a5012d2c5b546d3b817
Message-Id: <178373519588.951748.18266312149633672108.pr-tracker-bot@kernel.org>
Date: Sat, 11 Jul 2026 01:59:55 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 10 Jul 2026 13:04:22 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8eae393cbfd79311c0736a5012d2c5b546d3b817

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
