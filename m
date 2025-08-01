Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184DE2E36F5;
	Fri,  1 Aug 2025 04:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754023961; cv=none; b=D1VKX9qybjZKsXMf1H69qH58Dx2cFUUkAd0Nan4NcKJpJAonREGWBz62XgwN9jCO5DwAMpjV3ihGXoZ/gnKVCGld+tGkKE53U7pQ2mO8/cdq0Vzyu8d2wCbnE1EYTozAMizhZCi37leMmY9WJ+cPkgiokiU+lRAqNSWO7q+NSR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754023961; c=relaxed/simple;
	bh=2R2Hj0w/AUIJTktPb3ir0jPt4x3qGXSiIC8wuo9emtc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=dviBQyM1QW/2flwnD1OFMYsEB8Z1dsundUxy3EuHIw81EFgXs2dRG3XirUw6goTlR+BHQu2WKpBlhjM/8+WLmxFFiyM0QRsDfnFFfDLvNfJfKbVFiAkVIAUvcYyTGD+/VBirtZybPjRZvZen0+RehwUBNk2jJsZzTjGANozkgxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbCw8hku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbCw8hku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF11C4CEE7;
	Fri,  1 Aug 2025 04:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754023961;
	bh=2R2Hj0w/AUIJTktPb3ir0jPt4x3qGXSiIC8wuo9emtc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bbCw8hkuVlPWfT2neJasuohq3fY7LdaQNh/z5P53QqgWPyELtdvcmDIdiPiJtXsca
	 L825HGGvllljQ8DfEJe5GEpV7Fd2VQcrjy0uRmHIg0UZjesDGMrbnHmhxEExnjOyAC
	 1RX06Xzc+1i9l/gvYqXgY+IUKM6DWIJLSS8J8cwSPgOVQ6x80c0+STXfSewpRVpNW5
	 56jvG+w+mrYj6dXt9v6DHgT/EF8zMr4unsE/ntfC/M2rtuoBR1a7loOJkOA/YrzwKF
	 Hq6MMM6InJRgSlEZ+uqCSaZU0i4fTPSBGBj1qiC8rVGGL3hbSLqy+1UtIIzKtagtSx
	 urRJb6wBP3mrw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADDFF383BF51;
	Fri,  1 Aug 2025 04:52:57 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms8tJChqqKxcfZSGsZ9NbDpx-t2cRjfwSD7yxo6JHxnbQ@mail.gmail.com>
References: <CAH2r5ms8tJChqqKxcfZSGsZ9NbDpx-t2cRjfwSD7yxo6JHxnbQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms8tJChqqKxcfZSGsZ9NbDpx-t2cRjfwSD7yxo6JHxnbQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.17-rc-part1-smb3-client-fixes
X-PR-Tracked-Commit-Id: 844e5c0eb1767d5f971b035f81203f939d8219d4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: db68e4c80d995b67a92460711038b9223166bda7
Message-Id: <175402397619.3436555.56937047001143807.pr-tracker-bot@kernel.org>
Date: Fri, 01 Aug 2025 04:52:56 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 31 Jul 2025 14:34:27 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.17-rc-part1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/db68e4c80d995b67a92460711038b9223166bda7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
