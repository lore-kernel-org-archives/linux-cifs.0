Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774C4155725;
	Sat, 19 Jul 2025 05:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752903621; cv=none; b=FXoI8itOtHBL7Vzjz8pXFCLqd3EPW/aSJ6XCoiJn/iFw5Pr+HVbz1TN7ppHa2lWiI0FYf9wDiB/UsubmMfBrpBUPzTXYk8oNNtiGF1Hcp6kIMSt1BZcmMyZMuEfPq0Y9+4UYkVih4jFMIkw9TulLjofHd8W542YKxDZx4R+oYsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752903621; c=relaxed/simple;
	bh=B21l7mWWon97pvNsLueKpMRCBi23QWvVfwwzR14OSY8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=dY/8h0qX8V5AeN/BWLr5peuE3uf97B42RkLsNZ1Tq1CKTwdVh13cTFQcG8iZ3Bwa2NY9XnW6qNi2TfVcceIRkCIz8I9eLjJGTZujaQFMkDIe1H3Psa5WBD5Q/57HzxeNndyYWvGmSFeMFevxcE5leSI8UlOOgmG4Ejpgq/ABdwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2Ma3C8b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2Ma3C8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36D9C4CEE3;
	Sat, 19 Jul 2025 05:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752903621;
	bh=B21l7mWWon97pvNsLueKpMRCBi23QWvVfwwzR14OSY8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=l2Ma3C8btR0Wi5OhfQi7gEi7/HR3wrvdLp/TvDsW+RT8T1momLyjyRl6Q8xaQzLGC
	 bHcmlbCWDGJ9doY5ntMnSP6n6jIW+YZFDrlGbkFZgwEMji4UbwJO1X+iqiqNckazrO
	 9qgGurFkh2SQhaN2FxhiTXV7+djobrQYbkHgALOp13hdNE1WH5E+C2gmk6YyVd6g3Q
	 AH0WArLVzPx/IyC+5Z9nquve1MKx9uUhO+f6N8YxNF3uWrrHh8ZwMlJOybuKFnTi6T
	 Msk3/zBXX4xjAsk/OxmOS4N4jkA7+lPCCt02xHB9xXYZ6z5Ef0Gxbrc1Tz0vFRuNoW
	 7sw7jmajJb9Aw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE18F383BA3C;
	Sat, 19 Jul 2025 05:40:41 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msnypvFXCtKuDuA=kZX6vCTVaXVF3OmvLRTZoWwYGrdOg@mail.gmail.com>
References: <CAH2r5msnypvFXCtKuDuA=kZX6vCTVaXVF3OmvLRTZoWwYGrdOg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msnypvFXCtKuDuA=kZX6vCTVaXVF3OmvLRTZoWwYGrdOg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc6-smb3-client-fixes
X-PR-Tracked-Commit-Id: 8767cb3fbd514c4cf85b4f516ca30388e846f540
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4871b7cb27f480f6ecce804f81d4b9ee27281dd2
Message-Id: <175290364026.2894363.1607484167644581553.pr-tracker-bot@kernel.org>
Date: Sat, 19 Jul 2025 05:40:40 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 18 Jul 2025 23:02:49 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc6-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4871b7cb27f480f6ecce804f81d4b9ee27281dd2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
