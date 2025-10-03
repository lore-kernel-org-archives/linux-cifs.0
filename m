Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AE32DC34F;
	Fri,  3 Oct 2025 21:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759527129; cv=none; b=f1p1YJ+Kx9yPk4UPOvyRwJSSVzI7pvxXU6KEOvjuNUcGNQFUTjHhXbjMtu4NgBcxW8SBBzxnd6wReDr57PQWOU/B4gwSKPsf3inlEBXcZM4/yO4U4EYQ5RiL7wb9SyVpbXp5UsTJiMxgaELfaoxmhwn21/OcWnPZeIVAHWGDxNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759527129; c=relaxed/simple;
	bh=pkaTb3nVsDaeisTZGJFWs7rbCOdYlRNnMiW3yUKHZXw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jhBRAgKIF1Brycx/rD3eTw+kz3nnjCZ1zbyE2jfIXinfajBuyTm0lNGiiHn84Veavq7pQkx0yF5s/30IbigRR2IPPTwmc5XIVMX8xOwNGuQoU8JTa1goo7gJtabi1N9cuOEE8DaBwsPiqqMzPiUiN6YM0A5l67u8aXNT4P/50Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tP/X2Y4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tP/X2Y4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C66AC4CEF5;
	Fri,  3 Oct 2025 21:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759527129;
	bh=pkaTb3nVsDaeisTZGJFWs7rbCOdYlRNnMiW3yUKHZXw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tP/X2Y4jGniG79d5BFPTnpmnDX1TOgwh5L/7oLUDJnYTwfOaXlaRMlrB6oSmbISe2
	 fp1Y/hMRwUz5+V0+rCaRnA3FLmhhgVUCkdUD4/izIejC5P1+4RAdbEUGczJZgCYD45
	 +BV0k+I+CBwUqlkE3EMOAsa1ay+wLvlDYTwkGmkRZ7HdMoZ4Gu3OUU4EZkdtVTFsjA
	 +3Lkcxeo4/UDj43dk1THU3v1dSgOCFXpgBdaUVXA+wBvPAG2VTSQtlnSIvM/Ss8Gzr
	 UpK+RCxZQut3JeTqwG9+4Z6+VwpfZJ2LS/5tRoCMZ51d4IzxQp6JwWjuAaTvFAopUN
	 iwaqcVC0IaoWg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EABA539D0C1A;
	Fri,  3 Oct 2025 21:32:01 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muO=jZMFwi+Hnr9mvvT+8wQqOFJgBZ0ArZhRZQNccNT=Q@mail.gmail.com>
References: <CAH2r5muO=jZMFwi+Hnr9mvvT+8wQqOFJgBZ0ArZhRZQNccNT=Q@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muO=jZMFwi+Hnr9mvvT+8wQqOFJgBZ0ArZhRZQNccNT=Q@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.18-rc-part1-smb3-client-fixes
X-PR-Tracked-Commit-Id: 37e263e68c5e27d5f1fbc1377f64f9373dc5bf15
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 63e62baaa72e1aceb422f64a50408bc9b02a6022
Message-Id: <175952712077.82231.10584586384393631324.pr-tracker-bot@kernel.org>
Date: Fri, 03 Oct 2025 21:32:00 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 3 Oct 2025 11:02:59 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.18-rc-part1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/63e62baaa72e1aceb422f64a50408bc9b02a6022

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
