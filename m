Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F95A6DCE1;
	Thu,  7 May 2026 05:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778130531; cv=none; b=JZ0GDaNmXnu6p27bbNFcM+IydErpQ09nsAiljEuD+sSLEsbHu+iYCWXm4oz3XRneDnwNcD4hdNR2mdRTANfnLtrmItcw7FRlozPAhPc75R9W/WXkg9os0CBWQMhUstV0Ukh2qmHwe2QNo/GjH+990UcNB2u2vXHJuSbna0P8XnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778130531; c=relaxed/simple;
	bh=QAa/NSLhtdsheJzw0nGUATR0I8XUD7pi87CrwkQ07/g=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=QNpH3eMG7AxqM5oVPqQJWIcXoPL1t/pocSv/TGlkQKR5xicGCR6O7LY34ThXVGQnbt+FD9TKn1VE81MEN6HYjZx35YDtS58VvPRhIoelwcdaigH+b6jIaZEniRjgqm+xAkTuYxeqytmbc0cAFN2QhjDdKj5w1S5PqATv2Uf/Rxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E2xoWMH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E2xoWMH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373A2C2BCC7;
	Thu,  7 May 2026 05:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778130531;
	bh=QAa/NSLhtdsheJzw0nGUATR0I8XUD7pi87CrwkQ07/g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=E2xoWMH7ndQM/7sErv/AB6O0chm1hyvJfgaLlup8rdjbsLyqqjoS01qlRmihz+qy5
	 9XtRGwmiGQoE8ZbSyL2EBruFlNc7FoGsL7xPs8NsYNhNANDURFVodyyugw3DKBKGy8
	 qyOpFjCOsLNCXVh7OUIjwwAH8hcrzYiASYDXKxUPIYIhLASN5g4pFy/vMhXb5pQ2AD
	 shD2r8xFjl4yAEY62rIfL8xVYoPaqcuhZEzA98LFoHqzeKLqLv6R7q2kKSYZrIJXQq
	 4nuGBBieebE5qxZBaLCh+6NerTqMZ7PX6D7yo1ZXwfNI1+amwoJnEs6E1smtdb1/OJ
	 Dhnujcac8TG2A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id DFC8439308A0;
	Thu,  7 May 2026 05:08:01 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server and smbdirect fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvUOGk9ajF9PFVOyqmXawktBYr9XE0qXT=kgQAvMjOx3A@mail.gmail.com>
References: <CAH2r5mvUOGk9ajF9PFVOyqmXawktBYr9XE0qXT=kgQAvMjOx3A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvUOGk9ajF9PFVOyqmXawktBYr9XE0qXT=kgQAvMjOx3A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.1-rc3-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 996454bc0da84d5a1dedb1a7861823087e01a7ae
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8ab992f815d6736b5c7a6f5fd7bfe7bc106bb3dc
Message-Id: <177813048049.3342676.9471860848529244995.pr-tracker-bot@kernel.org>
Date: Thu, 07 May 2026 05:08:00 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, "Stefan (metze) Metzmacher" <metze@samba.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 6 May 2026 22:57:54 -0500:

> git://git.samba.org/ksmbd.git tags/v7.1-rc3-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8ab992f815d6736b5c7a6f5fd7bfe7bc106bb3dc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
