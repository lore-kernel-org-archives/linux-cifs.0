Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573951A3A80;
	Fri, 15 Aug 2025 14:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755266781; cv=none; b=Mj6MMZgNmlFmdsD7EVQIF/C2hYK7etHa9Dm1w4xLvv3tNq+W96pPktsL76JwqJd6YGRrlHuRiYzstMcKzieScDxU+9nRxXjR2LX+U6SE+SnXxp55TSfDjeptaNl44HXaS3sFuE7F0k3gLcZuRVZVu8nCXcb1NyDA8DaP7AMpwkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755266781; c=relaxed/simple;
	bh=mz8BcQAidgZTzJpEETP27hLPaHrcJ0D2ABt3tlYl4Ow=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=GG9qgz/O8ho8AiguNLkdgReQ3FIU91WSUWk7WtowHhGzbBSlbNxgC08VeOOL7BFzYAySyrC212Rk98wv4FGduZ26yMMctvhvcVx1MYYeRNowu1evaRFglfMwYDaxF9WcY1KZ9lnBMbKThSxKDhBQI6kVygbQhq0sBBJWRlYNEgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PCfdTwFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PCfdTwFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2942C4CEF0;
	Fri, 15 Aug 2025 14:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755266779;
	bh=mz8BcQAidgZTzJpEETP27hLPaHrcJ0D2ABt3tlYl4Ow=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=PCfdTwFPET0NWdOR0+zktiuyP+1wKtJ9zWfqOwtt4xIYZLq/XbtiGx6Nhvi5Fd9tX
	 36mPJG5ao14qyc8t4XKf+UaQBLBdBf/jO1CG596Kr4WQwUi2dXt/A16T67ZeNQr3OC
	 6xVYr6yCrTxhQXNUurYkshEsY3EjHS6HQHOWnjr+azrbTlwYtSxcm+SOcUFfsEDmDl
	 oYjmgEwneV3GZhP4HhoxvXpU4Qtq/5cTDgyOxSAqX5cgknARdBT8taF43WFFCUOX2+
	 z2fAJ93yiMsRtFEMzr6A+WYaPxafGGKQw2xq4+g1EyrjS5AkrctvqJpDdT9pV5bR8E
	 P6lfFfTBBhgzA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3415C39D0C3D;
	Fri, 15 Aug 2025 14:06:32 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtRBY-kVFHxA+w2mgvyG_f5cnbtMqxDgAQjDeecC1jyKQ@mail.gmail.com>
References: <CAH2r5mtRBY-kVFHxA+w2mgvyG_f5cnbtMqxDgAQjDeecC1jyKQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtRBY-kVFHxA+w2mgvyG_f5cnbtMqxDgAQjDeecC1jyKQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.17-rc1-smb3-client-fixes
X-PR-Tracked-Commit-Id: e19d8dd694d261ac26adb2a26121a37c107c81ad
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 55ddcff7358aa7cb20ff71fd2ec3131133b1fc3d
Message-Id: <175526679088.1083334.10659189674454812210.pr-tracker-bot@kernel.org>
Date: Fri, 15 Aug 2025 14:06:30 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 14 Aug 2025 22:06:13 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.17-rc1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/55ddcff7358aa7cb20ff71fd2ec3131133b1fc3d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
