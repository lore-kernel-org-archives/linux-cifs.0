Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC77B657;
	Sat,  1 Jun 2024 21:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717278006; cv=none; b=kNg4W8YH6MT2E4yCO4rBEnFX1M9fJdSYRxK/BqC+n3OX4NwWQcx4ZuQhM0HNjhYK7WJ4Z+QuYcOeelPM93jTFJqU7pliC4VlEe0nR4jfiatUPtMfxn6YgFafTSbjWOOw4kiDtm0WsE0lS9Fuq582JQqIqtzs7kTSsWQaDm3ohsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717278006; c=relaxed/simple;
	bh=m+etHiW6k+2IQY7bRLYoihQg+r9dVMhN7tANjY2hCnk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=VluMzgnE+DXCYsiadTvMW9CPVVkoHqYpd+wS3HfGr9FNussaqhcxmqD5v9BIIom40aPMcm0wB1v2AGQP0I/pSl/1bjg08gM6hrfZPKigRztpFQYMTmuR4XAoaIyyTkNToUc3vpwr0Jz8f8h6DWfMVCuIrnBFiPdTO2IzUasbxz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kmMJL9+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kmMJL9+k"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37D39C116B1;
	Sat,  1 Jun 2024 21:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717278006;
	bh=m+etHiW6k+2IQY7bRLYoihQg+r9dVMhN7tANjY2hCnk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kmMJL9+kYGq/S2zWRoc9bL/rjCwKfPco8A8wLAGaOdHFKR01+/smYQAz5dRhzZGXV
	 /n5MGSEmd8MVVQStelfU91JK5ZWBtNCyXcQwGgn3N341i6G7JsYBBve4ci/7qe4mno
	 ax3jKeNdbmmtVg9anKiMCRupjfhRDiA1EKwP9Jr94HdSfpN0D5S/DA5hgKeIJxFzjt
	 uckuLEsmqW4J86ZQlh4rUzBlQrd0J/WoAIUIdKAL5bgh3QTs2xiQXe68iqwi8DhOF/
	 32rMHhpYe0S/aoyWoNmO3OU12NvCXq0A8s0LfXer5s6MEJvk4hJ1w/VsGTa5JC9/Kj
	 Tv1JFHm23/KRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21572D2D0EA;
	Sat,  1 Jun 2024 21:40:06 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mstfGRS6XazUAM7uX=FkpJ+da7jesa1_8BcOvZgLx1RYQ@mail.gmail.com>
References: <CAH2r5mstfGRS6XazUAM7uX=FkpJ+da7jesa1_8BcOvZgLx1RYQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mstfGRS6XazUAM7uX=FkpJ+da7jesa1_8BcOvZgLx1RYQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc1-smb3-client-fixes
X-PR-Tracked-Commit-Id: 518549c120e671c4906f77d1802b97e9b23f673a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 89be4025b0db42db830d72d532437248774cba49
Message-Id: <171727800605.30089.2246135519790170864.pr-tracker-bot@kernel.org>
Date: Sat, 01 Jun 2024 21:40:06 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 1 Jun 2024 16:14:00 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/89be4025b0db42db830d72d532437248774cba49

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
