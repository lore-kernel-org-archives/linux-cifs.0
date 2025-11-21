Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C08128A3FA;
	Fri, 21 Nov 2025 19:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763752827; cv=none; b=Sk9HJT0tCY2Y/UDNAtikHxpOIpL/VakOHyDvEOHW8ng8yvClrGz9Iiv5nnzE9iBhbt/kVlFEQW5PgFDYfitJ+Ye4W6NATr0Bpp/LnVFQJ4nHIid2oeAXcS9dYb/NKK9SAcrpO5bbhWVZ8rhLUMk5O3RlD6ftx9JHGhU6TCR5aTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763752827; c=relaxed/simple;
	bh=ECoKjQWZVcKqU6FfqOpFa4y0bRsTv2J3h90ft1vu1sk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=WBXEEDuGu55LVM0AFTp0IuD8yWeDIK+NPZYxfcPkeu7+aqyUPcLYRZnoCztMYVgrM5eRR1WWMDGz0UfvoNr4dTzILUPzhNMiObzulhJ7iYphYft6jvb9HNJTdf0ZpNn7mcS831SVm95IGg3KmgOTon0TxjzA/skjU5Mi1H1nm2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iyCgmvwb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iyCgmvwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD45C4CEF1;
	Fri, 21 Nov 2025 19:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763752827;
	bh=ECoKjQWZVcKqU6FfqOpFa4y0bRsTv2J3h90ft1vu1sk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=iyCgmvwbxQwG5U9JqjY03fBqs8CwkmiMqcCCZ3RZPRwSI+JOlJDtQ3asEtMIZ1wl9
	 OkcUfqcQcT9UwNRfYu6xLFKxDrGfFWH2m9lJjq7hSXqfrHtkWz1VEP8e7j8W2fYArv
	 3B8nhVR8m0fCp6SzME+Dn/+petBPOY61un3GHgRMTD74Xtzpx1Ll/Wx+tAVgTLYUrF
	 bZCSSlrEkFdAnko/l7rnkX7rjh2YT6J5Al7ERPJ7Bqq24clrmKjV+p2tJ5w9XQgyLK
	 Mu+s4KMP4Lwt/GzOXbLorStonliertt3r1cM7JxlrB/UTQLcXBwjXZsBZUT6gd85QD
	 dc8ROzeGTqc/A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33C303A78A5F;
	Fri, 21 Nov 2025 19:19:53 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms_sWbxSs4tq4kfLNwXLZVKn-TGOYRg1h+zQQSE=C-Fbw@mail.gmail.com>
References: <CAH2r5ms_sWbxSs4tq4kfLNwXLZVKn-TGOYRg1h+zQQSE=C-Fbw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms_sWbxSs4tq4kfLNwXLZVKn-TGOYRg1h+zQQSE=C-Fbw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.18-rc6-smb3-client-fixes
X-PR-Tracked-Commit-Id: d5227c88174c384d83d9176bd4315ef13dce306c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e3fe48f9bdf47e0de91ffb7ba10d94a6a7598e8f
Message-Id: <176375279188.2554018.6941384865693023499.pr-tracker-bot@kernel.org>
Date: Fri, 21 Nov 2025 19:19:51 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 21 Nov 2025 08:43:10 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.18-rc6-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e3fe48f9bdf47e0de91ffb7ba10d94a6a7598e8f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
