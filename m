Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9850036213E;
	Thu, 18 Jun 2026 17:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781802298; cv=none; b=BJj8BTNGnxGRZGUmYJccWOaS3VyJ+P9M6tbSgPBbHK3f/neFQQEaSYZF07VktIacYx7o9VY5bXkRI8twpiQZF+PMPrcDsDXBbJHrH3fJT18Y91qsNX9XwMI1xNxjqnCc5101ipVAgTH0zsFH5UoEDcpuOR3Wm26sGCPO76EBPMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781802298; c=relaxed/simple;
	bh=tRI8iUSWPHtXnt5ZZSwHbA2+7dquKsA8w6YOaB/nZVk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=eiFp7On8RkbWLPBTgVNQSCWzJx8G9AbJNZByflZNfmZLeygIQnBNgkO77RfwqS1rKe1ilI3rQlvhqBazgNgCPTJbaNUOS6xDMvtzl7DhmWuI43ck25CKX9AovgnM8WUw2GZehMvdhvYrz5SttQa3fxVGXgzOA4UUmWBp6pB580E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UEgdn/aa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UEgdn/aa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200771F00A3A;
	Thu, 18 Jun 2026 17:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781802296;
	bh=IqBRtZCI/NsPTVVl1aoo7qHXaY96Z767t+/fHSV+ST4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=UEgdn/aanIPTXM1pxKSquDFgo51mEFecdLm31RnzTMzkSEyoaEROvUhdvGRBeOVdg
	 q8JppZb/Dpkx6eNE2J0/9loKy1tuAfoT/xK5WBJ4uWskCptJ/qQZMO0dMfJI8jfWGX
	 UxMxUVz0DAFhh5mx5yt8b6yn16X0d9V4jl5+YhU2KX7rJ9C4swwtZKxLKTSWJd3PtE
	 mcKToK31LbofHUQwKqMkXJLgc4+tfZX2lq5sz6pjZybfpNn8xhMrhcLMHSEORsTpm8
	 6SWJLdIGP5nr6aONjPNn7QKp12DxIv26exD1+9AADk1FkUibLNNYoAJRB77/qQATnd
	 4jAQY8/3ue9RQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D09533A566ED;
	Thu, 18 Jun 2026 17:04:50 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msgSAsroCEL14oXfCzC7iZFUmqQaZtT_cTx-1vgE56h4A@mail.gmail.com>
References: <CAH2r5msgSAsroCEL14oXfCzC7iZFUmqQaZtT_cTx-1vgE56h4A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msgSAsroCEL14oXfCzC7iZFUmqQaZtT_cTx-1vgE56h4A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.2-rc-part1-ksmbd-fixes
X-PR-Tracked-Commit-Id: 1c8951963d8ed357f70f59e0ad4ddce2199d2016
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dac3b26eae7bee261fa05f20c3fcc24988a7c233
Message-Id: <178180228936.2987783.16802748096398251707.pr-tracker-bot@kernel.org>
Date: Thu, 18 Jun 2026 17:04:49 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 18 Jun 2026 08:58:16 -0500:

> git://git.samba.org/ksmbd.git tags/v7.2-rc-part1-ksmbd-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dac3b26eae7bee261fa05f20c3fcc24988a7c233

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
