Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57283330663;
	Tue, 10 Feb 2026 00:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770684642; cv=none; b=QMzLXIf1x4+13r/37yHoiKhWD5WcGAZ113opbrfbgLgiaMxs+Q7Or2Dwz+XFHlCJ7wJHn0PKV/fhwewN8b7S3n85x3y9wiGXlxhsjT6UgOs6EjeX7Kbx64eS0L4tsbYtg/2kXVmfcY/41Hy8j5MKiQJOTbejQvGlCHyShHv15ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770684642; c=relaxed/simple;
	bh=oeTlIv3fZhL76Zm6PAgDY+PXT5VYz5qeGbidt/SkYIA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=iinjSP1wZHlTvYvD8S7xahWnBooFt8Fro4LyEhVofZ753aNgDzTOMsUniPBF9PUNJY7o/R7iaRhvc6Sw11j1FVdBIW3KfianwKFnbHBy4EXNu5D1WCME+iybhA9mIo4bESUOGiO357qV4BZlOPE8+vb3C2Rw1TmcGOIzZ+5J1DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=maMYqoiQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="maMYqoiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E505BC116C6;
	Tue, 10 Feb 2026 00:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770684641;
	bh=oeTlIv3fZhL76Zm6PAgDY+PXT5VYz5qeGbidt/SkYIA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=maMYqoiQwpAFT15+o9hWqjHrDeAxxWHYhCc9XUhgZslMBvWoaWRS5sv/rUU8FFotN
	 /VfOJTv5iIWgrb40+Hop9By0bAS5cyo80C/7J9f7Cg4RA4I0RNxYk4IR/mVxLfSxuq
	 5a7Xk9WrjgZyGSI/eRjf/j1160rpKVnP06HxAQ7dP427nWFPp/tXEI5IQwJfK8melY
	 fXsSoM7tLTi035t1IIIXc2NJYBH71ZSO4dSHBL+7isI763YS9GQuqdnnrMiJfArKlc
	 T+BW8m42CBIRT/EKJBI0HxeKXmVd18KXa2RBm2AKOdFdkFtYxAP6osLctn2jRC3pF4
	 PwL58u3nFmP0A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id C2295380AA49;
	Tue, 10 Feb 2026 00:50:38 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msuFqDVtb8_HnGin3PyLZ7h4CUnU3yh+ZV_Za_sEWPdhw@mail.gmail.com>
References: <CAH2r5msuFqDVtb8_HnGin3PyLZ7h4CUnU3yh+ZV_Za_sEWPdhw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msuFqDVtb8_HnGin3PyLZ7h4CUnU3yh+ZV_Za_sEWPdhw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc-part1-smb3-client-fixes
X-PR-Tracked-Commit-Id: 95080648ed52c6b97153ad989252576a3c070036
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8a5203c630c67d578975ff237413f5e0b5000af8
Message-Id: <177068463735.3276324.1052283080114184351.pr-tracker-bot@kernel.org>
Date: Tue, 10 Feb 2026 00:50:37 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 9 Feb 2026 15:56:46 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc-part1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8a5203c630c67d578975ff237413f5e0b5000af8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
