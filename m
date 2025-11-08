Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0F9199D8;
	Sat,  8 Nov 2025 18:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762626156; cv=none; b=bC8EQloIWt1XT831N63YveEfbT0zg3IrOJC8/jWKbVvocI2tOVMkOJuPfwi6YFVqu8qgnXgOD4riGwR9cfJbxtTjCC5EjVXxSlVzeqCvq9Wi8zTBEjbfEQXPtmR4/xNm7EE9MmyhSDVH5wJFo6AwREEzl3dXQN4X+NSkm66mVE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762626156; c=relaxed/simple;
	bh=WWJP7mnE8OBwKwnq2yGacQLELzPqbbjpSGRZKxXttfY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=W75h1RcNvf9Td32RawTZbeoHzgu5xzDSktOeAF+hCJsMNHpP2kftKcP0Z6MkHKFnkoIn4BO4HMIWusDZnXs62eWLViHEfTrS6Qiy8BR9SU8VJGHWUesEpDBbA4J7J+/ouc/PcASw8WkULyh6kN0M6pOsJ8kEV92RCq1520N6I6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gD4eV2VF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gD4eV2VF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390ACC4CEF5;
	Sat,  8 Nov 2025 18:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762626156;
	bh=WWJP7mnE8OBwKwnq2yGacQLELzPqbbjpSGRZKxXttfY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=gD4eV2VFOWe0SuYhlf0v8AF/TmqeD3eE1dn2IGVDkJlBlFB41YT2dENCGft08Y8+t
	 0XjcqKO4NUFago7ldsLCa7xQhHJMM0E2QfS/73jVAvg+LvuAqzis4GaQaxCybaYkLw
	 ve9moRI0O/lUVkAwvVqOGQoYwKPXD67ZHBaaN54yCGUVLx7CjSwOQgSRVvBW4IxJKH
	 T1ZGNh8G67xr3c+MDOIcEeNScMchIEEsDin97bc98QYRf9FEEZ10mD9vNa5UkyQoOw
	 JbuHwv00Y6gcC6gYDjELIbxwSUbpw63SAzMYKn5uG1i4Y2kptoky3TQ+PJmwUEnhDR
	 ofnljHTwVK7jA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 341AC3A40FD7;
	Sat,  8 Nov 2025 18:22:09 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms=O10HuH9SvW59h=J50dmLUsqYTKoD8jqAvcn16aergw@mail.gmail.com>
References: <CAH2r5ms=O10HuH9SvW59h=J50dmLUsqYTKoD8jqAvcn16aergw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms=O10HuH9SvW59h=J50dmLUsqYTKoD8jqAvcn16aergw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.18rc4-SMB-client-fixes
X-PR-Tracked-Commit-Id: 4012abe8a78fbb8869634130024266eaef7081fe
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7bb4d6512545a792a6cd8d6c8be5718920b9b11a
Message-Id: <176262612781.1378508.12713937216519114972.pr-tracker-bot@kernel.org>
Date: Sat, 08 Nov 2025 18:22:07 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 8 Nov 2025 12:15:57 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.18rc4-SMB-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7bb4d6512545a792a6cd8d6c8be5718920b9b11a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
