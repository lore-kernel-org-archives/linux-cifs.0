Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63DB2E371C;
	Sat,  5 Jul 2025 20:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751746126; cv=none; b=mZFEcb0t6C/yt1yA8Li6IbcGBQI8pIviExg0HNnNdB/laUok+K6UIsvOzo4PGygLoa7IAY0Hn4MW1TTcF8O2I/Bc23fusD2ZJdGCtTYGGS+lstgQXrybmwSipCfKh1AY8OzAKMD3Y0Kk0S0zHqCGjTuc5B7NTJCVyPcZ6aZg8N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751746126; c=relaxed/simple;
	bh=ZeYoZGv2+1Ybjuyv5mXSBCcSzFymNxCfYQBk0VC0L44=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=j/umUyV9DpxkCntaiSvNzLkEQRkGDDGHZkwHdkGx7L1rZ4zoESRoKZPj4Gpqf1IR6c5Ti2k7ql1sbhiiIimYWbj5J+5d26lNXwZ26JWmcG4T1a+2lLOuBzW21yQpyORXSWS7PryxTEpW/LC039Uhj5g/N5aeHlgcIWUbJ74mQhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p78MA55l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p78MA55l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883DAC4CEE7;
	Sat,  5 Jul 2025 20:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751746125;
	bh=ZeYoZGv2+1Ybjuyv5mXSBCcSzFymNxCfYQBk0VC0L44=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=p78MA55lIn5o3xj3XEPnnC5D0UaxDnSFGbVo0F9to+yjbdf7wUx5sj/XaF23xWDzB
	 ygxOKijoYiIWSUnsJBx6sI3XfS7n5FZavPBdu/taVEbo1uZiVL/QTCOtNKJV3mY590
	 +YBEf5YJbUd72PtCEtm6XqbwXoyafl3VxYbrh7o63yI28rGEQ82HHqfKdQgfrHS7GQ
	 yKjAlk5jawEHq3Xz59S3UbzLBE8uw2ZhzpgaCzdPy5F2T171CGY8Syyd/nL9ChcUN7
	 YuAFSR6NZcptOIYzHgTzAf2XmrKiTuxevq8HkvmwXie5cQsJAS65IeBfKjhjMyfIjk
	 q+i2mIRYZdPvg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70F1B383BA08;
	Sat,  5 Jul 2025 20:09:10 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mubFOMTrOVPwzq20wEx9u1dU1emymFptOGjB6rs8FTkjA@mail.gmail.com>
References: <CAH2r5mubFOMTrOVPwzq20wEx9u1dU1emymFptOGjB6rs8FTkjA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mubFOMTrOVPwzq20wEx9u1dU1emymFptOGjB6rs8FTkjA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc4-smb3-client-fixes
X-PR-Tracked-Commit-Id: 3363da82e02f1bddc54faa92ea430c6532e2cd2e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 05df91921da664ebba2752a7e45b63e3dddb85de
Message-Id: <175174614915.2526409.2157223097187419264.pr-tracker-bot@kernel.org>
Date: Sat, 05 Jul 2025 20:09:09 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 4 Jul 2025 19:41:02 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc4-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/05df91921da664ebba2752a7e45b63e3dddb85de

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
