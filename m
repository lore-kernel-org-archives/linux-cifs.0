Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207EA7081E;
	Thu, 16 Jul 2026 23:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784246304; cv=none; b=FBrY+/mFkbEXPOoIfT0K76ROVWF2eHiICGAqvqcp4O9BxXRR8jelt9Ea0acawxMd+c39x8x94FYUWD36J93HMHvAeYl2jqB8VD8ZV0JDS06YLdleNiq8QRzhtJiOU0HRpCO+Pb63u2+R0zRI+mxh/yXhD7l28TPJMDkY983UHws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784246304; c=relaxed/simple;
	bh=ipyJwlWlFek3B0wpWFMU/VSLbmfz8VRduSFfhJ+kq/8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=J4Wmg3063WVHY+BkfKZDDeStIcbHu02K5z5MeVdezt7LiLJ/AkPRZyFvPmH3++pTAAHe01Cba2R6tAxRc1u7wBueDuoCYRVaOE0supukyHMcRGshrsYBq0XKcxZQLrKndax+wQuDv2B6gjR4zjlKC2On5vdGrNiQX88OMl+nNY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZNtWumom; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZNtWumom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A6F1F000E9;
	Thu, 16 Jul 2026 23:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784246302;
	bh=Teg+P+a932vpksTHofRYni0jQHKittkdkoG8RAxUp0g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=ZNtWumomVeLAl6PhOJhU54a1Pp6D+JyNz15pCZuXawv81xnwzf6w58fhnJPeSwaN2
	 J6pvitIEdLKLJMbPitoyPSaGkfDtf7/ty7QdX0aHh+KtIRqZL9pckJNLyX0LJRSJn5
	 bHlkneFQe/JMWbSMvO0MjdOc6FHKXZ1s1knsiaqkGWAIiZyYuEmLJFmps0nexlcy9Q
	 KyqEvFKhxJQQbaY3kv28DrP7Njciz7YGHRHhyFkwC7fbo8H+YOCtPqHea7y3TslGVF
	 R25U05pmo2NgPqyku2CZnTz/ayPlM2f2vJCY6EZk+pw4ci8PBE+cEbbarLN7BMGPD0
	 iZBFWHZwZbp7A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0EB7380A970;
	Thu, 16 Jul 2026 23:57:56 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvYSLOu72Nv68a1uSNSPY-0j-jYtTDMe7JufX4FL3vCRA@mail.gmail.com>
References: <CAH2r5mvYSLOu72Nv68a1uSNSPY-0j-jYtTDMe7JufX4FL3vCRA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvYSLOu72Nv68a1uSNSPY-0j-jYtTDMe7JufX4FL3vCRA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc3-smb3-client-fixes
X-PR-Tracked-Commit-Id: d7d2adcd022baade5cab65ca492ce63421ce3a6e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fce2dfa773ced15f27dd27cd0b482a7473cdcf2a
Message-Id: <178424627540.1462041.3990712074192458472.pr-tracker-bot@kernel.org>
Date: Thu, 16 Jul 2026 23:57:55 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 16 Jul 2026 18:22:11 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc3-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fce2dfa773ced15f27dd27cd0b482a7473cdcf2a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
