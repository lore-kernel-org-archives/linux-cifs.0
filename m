Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABE237AA8A;
	Tue, 17 Feb 2026 23:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771372244; cv=none; b=fKYhaMexzRh+BEFaiwWU3MeoXmgqNAqZhUmD2JAmCh9SMayVgT6Zh+GQrEI9bX99ZdvV0HZ5xh1HEObaVMS+nCKJ1fHwrve3IdPt1hMvqKM5lGrpuA0qUkaewKmT3M23/4qUML710wK/KSuzj2hxEntW9VEYaD8U2/McHM5y07w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771372244; c=relaxed/simple;
	bh=D9zP7d0RTQdaIIhB1LVs0zK2GiB7/NoW6y5OPasgLfI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=U+Tc4+8CEy3a3jNTHyKNOG4Jjs6n23xp7+RLZNzXDC7kGzNDb93crzTp5/EJ3Zb5UFS497Wj9Yp30OvsrDljfisnrE4GUTKg28OZ7P8Si0+YPRIQ9UgJrTcQo1Y8f//QWSi3C7TQsyf8XIwpf8XZUWwDFMiukjOdfTY/i8jSrPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vN5mw+XV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vN5mw+XV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B49EC4CEF7;
	Tue, 17 Feb 2026 23:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771372244;
	bh=D9zP7d0RTQdaIIhB1LVs0zK2GiB7/NoW6y5OPasgLfI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=vN5mw+XV7wVuIhpLAEyG1uvIPC1gdjgQTg8IQVD4gnO/aPv+YciwpWApUnjE+zdai
	 /3TonvdRZiOCAuNuVz28duNuKi8Uft1nkSFOcdwk9Cw9ASh8Cm086RhOsmEOzMut06
	 SkGWT71OjSRnyeGk1l4nnEFAVlBqsO2AlkJjFVHcvzg66m8LFFVwg0XurCJiw//IqB
	 pKWW/fzqolV4nmkwf91UzR6H+Au6c8F9HnJWFips2feWzh3RMluBpfYHiUABa5syzd
	 51CvXTKo6UvZnaEc6v9+3QtYF1V+7UL7mOOKf7KM8au1EfK4aJ7kai0CWZEeiVtkUS
	 ytcZ4CpSnOSgA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0D5B93806667;
	Tue, 17 Feb 2026 23:50:37 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt+WBNhuWCOym8zPCfBFpxfoDF9O0gT0dbgt9q-ZJfxAQ@mail.gmail.com>
References: <CAH2r5mt+WBNhuWCOym8zPCfBFpxfoDF9O0gT0dbgt9q-ZJfxAQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt+WBNhuWCOym8zPCfBFpxfoDF9O0gT0dbgt9q-ZJfxAQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc-part2-smb3-client-fixes
X-PR-Tracked-Commit-Id: dc96f01d54cc7c785c98ee6e2b53075949ac16ed
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1d22968feb2095136dd5f03aae2832a6b6aa6628
Message-Id: <177137223591.738845.7058411465728163932.pr-tracker-bot@kernel.org>
Date: Tue, 17 Feb 2026 23:50:35 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 16 Feb 2026 22:54:52 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc-part2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1d22968feb2095136dd5f03aae2832a6b6aa6628

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
