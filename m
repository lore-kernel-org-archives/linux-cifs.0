Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76841DC99C;
	Fri, 14 Feb 2025 22:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739573602; cv=none; b=NK9uy7q3khv1KYLNHUzjp447SB1zeZX7KumObZ/oduTNUwmbcrmeINCulkOvLu3hgI0UiWXQvrZF+Iv4AHDG10Mozsp9HtcJecmbTS5Msy1HxQu3BQqT9XWOuL6aEGtYudtC/aRR6fO7MqlgY/KT3L7hX3+agp4hgNnC2MSG6JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739573602; c=relaxed/simple;
	bh=dQ5EjayVlWhfx0uRHK+g7u3yCeaH9lZ+QGFetrQpCoM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=bwiH/6JZx9XuYRYveyK0gdfyenjjifVuX/zxIJqTSGq5uv3PpN6j2ht2isG1RLbzv7johJVfonOkzOi2mIN3Zig3UK1NV/E2prrkV5cnGvAiToHHJTC6FP1MBRJc8mw5mh2pCEhn1CfPYKa/mkp92S82lQu8K2lYN1xR0HAY8po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OIGQwb68; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OIGQwb68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA9FC4CED1;
	Fri, 14 Feb 2025 22:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739573602;
	bh=dQ5EjayVlWhfx0uRHK+g7u3yCeaH9lZ+QGFetrQpCoM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OIGQwb68Ch9qoi/S6/JLlkL3CeVdj5rul2ZCreZV0+Hc1f5ia2vM+JUhSI8uCsXnG
	 n5f01XrTTllHncqZfhttQEod/6K9/qtxC0kMF4aih5oUoDvneEBLG2wxjnW3I9H119
	 xFhhPIHdxcq63HarF3DylDyXXVJDbcsQzXoiVyRAWdNMKvMNwqCP84IbLGU0//4+R9
	 suTXEoCxdlFCwbWZZKUeCDQYVJsYVK9s+DhwQ8u3nal20H5Zr1DmxSgLeIxOe83f4Y
	 FHMMEjmojmZhjGYsSbU1Ut/7AgxtN2Mwg/m6YyXo8elhoIhdIVhUpec5Cdi1TtLfdu
	 qIrnpcfAAXraQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB0B5380CEE8;
	Fri, 14 Feb 2025 22:53:52 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvzsA_nUYZHs4mSwU0GOOBGjKEchyjBLrCaSRf7pPyMvw@mail.gmail.com>
References: <CAH2r5mvzsA_nUYZHs4mSwU0GOOBGjKEchyjBLrCaSRf7pPyMvw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvzsA_nUYZHs4mSwU0GOOBGjKEchyjBLrCaSRf7pPyMvw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc2-smb3-client-fixes
X-PR-Tracked-Commit-Id: f1bf10d7e909fe898a112f5cae1e97ce34d6484d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cabb162eb5ab02bf10809fe5025d437e99e119e3
Message-Id: <173957363141.2130743.12850630492360179140.pr-tracker-bot@kernel.org>
Date: Fri, 14 Feb 2025 22:53:51 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 14 Feb 2025 11:38:07 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cabb162eb5ab02bf10809fe5025d437e99e119e3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
