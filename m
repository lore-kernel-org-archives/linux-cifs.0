Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFF92CCC0;
	Fri, 18 Apr 2025 16:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744994726; cv=none; b=ApbIa2r+/MKYQMSjZnTFLO1+DsEW3vtRBVUm0Cwu1veUAYcZgGjS60HXTgphJVXJYwG2inuqHkUbi4vsyxHXFXn5K23PF6KOz17qpaSZLaIcZDhKaIts4Hxgr8TR45z5zMpwlMvQuUGnFn2h+3IUvYnWDlvdGxu137epOLBsQZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744994726; c=relaxed/simple;
	bh=Gq53KdbK5QpUUjwnIObXO8DYV2SS4C2L6HTozxC34zo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=taT6ZgjmHSDEvfdaPsg7UPs76OimpPKoFUqgGUMnvfVQXowUlKTHhRxjUPXdPpiONkD0oedc7UAneNyvGZP27hKOhXfw3D38r29GRpn3DcvVUQgFkfFN4AJaRt3h5lkZLWP7xJJHvvuappCroJtaBFiV0inCpJE3T6UHp3zfUDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SXDUeidW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SXDUeidW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81451C4CEE2;
	Fri, 18 Apr 2025 16:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744994725;
	bh=Gq53KdbK5QpUUjwnIObXO8DYV2SS4C2L6HTozxC34zo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=SXDUeidWV/MsD7ZTc98o4YbblluNjVMqYFWWnyWjyeOPcX7H0mAy+4wtNv9jeHQok
	 NX5+UFhQ9O4sT4I+5nNCQiyAoM1mtxd7I16vSTEJ5OIRl8zMWNVSLPoz/UE+MGEn1s
	 rqQewHqwhgB7KonurxSgOZDzb9o3rpeSQGw7/row5mu9xiqOOyTI4CnQ+0AZNr+oI/
	 UnBZFuxl+CgETbGkqMjqy5oOdosKzFOwW43794iXRHy9BbBjwKqdzzc0oHiQxkFzpS
	 uZY4QsNdY2cTxoeJMJenxJ7vh+1mvnmqEq+ima2uiKaTB+lo66kbxVSaQiINcRqjAq
	 seHk3yUfDskBg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAECE3822E07;
	Fri, 18 Apr 2025 16:46:04 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msB5K8EdzYK3JXe5Rzo-yGpOk_y6qJghBOO770SpjHrDA@mail.gmail.com>
References: <CAH2r5msB5K8EdzYK3JXe5Rzo-yGpOk_y6qJghBOO770SpjHrDA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msB5K8EdzYK3JXe5Rzo-yGpOk_y6qJghBOO770SpjHrDA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.15-rc2-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: a93ff742820f75bf8bb3fcf21d9f25ca6eb3d4c6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7e74f756f5f643148ca5537bf2fee6767e4b0ed9
Message-Id: <174499476346.267730.154504230046472430.pr-tracker-bot@kernel.org>
Date: Fri, 18 Apr 2025 16:46:03 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 18 Apr 2025 11:24:24 -0500:

> git://git.samba.org/ksmbd.git tags/v6.15-rc2-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7e74f756f5f643148ca5537bf2fee6767e4b0ed9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
