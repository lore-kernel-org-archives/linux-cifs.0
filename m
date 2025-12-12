Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EFE3168E5;
	Fri, 12 Dec 2025 10:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765534303; cv=none; b=iBiIG/WKq6IQBnu5Tj/T9qgs8Ub7jQBOnWly7ZZBzo9+KF9Ab2fyl0HPWb9NW/MtKUBbnXyjdaqsARXKvQo/GQ1eIvG5B0Lt2QasymIsv8piuPkYwWt+4urSPzOz+cI90icOSs/F1Vp6Irqeo5Vod87HwREqAKLiSv/96fmRuKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765534303; c=relaxed/simple;
	bh=3kFJnwY8+lB1Dopi9Ff1MMohqeniZPyTFPs1e7VSyPQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=RrscXm8p5KAG/rDQLQBpeDl1gOfxVVaRHKEalC5vtJDgc+5GQ5wSu7aHmSThunZLA5kS+EwgvQS9k/f5c5sc4mLrmUEjadQ9ZaIJdZBmzf/IcpJ0UuH6r7v794D09m4KfRl7mIgNiCZJGMbLIWwKmX1xPv5lQuoAvtedk9JZatE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R4eL/RAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R4eL/RAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54873C4CEF5;
	Fri, 12 Dec 2025 10:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765534303;
	bh=3kFJnwY8+lB1Dopi9Ff1MMohqeniZPyTFPs1e7VSyPQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=R4eL/RADm/0sjhOBoxNkSefhsK8BC0usnswntYj0aMaxusewNiaTC62j1ChxUJER3
	 hDwXOeLHT1W2D+an0tq5ccDtC0meIZS02Vk/aTZyfxO+JEoz2EMtZTUB/DAjwUj5uo
	 3d3y66ZmOmAJJysoEy77P+zj4zjHZVTLFXk6Zc6T2fNi0W/N4GA76YXXzDe9XOpyoB
	 eeMuCJUGTXKa4m6Up7r/yBpoB+XJNtaIMiPCkCXjZG+pYgO+e+ZQVu4WBThqZ4udFP
	 XJAVt8LCftwMINZpHt+GZy70FGxz9iYI8XWY4WU1CWwt2QJ/vasx/AHXHfUaTIqure
	 /JxOZ7e0wLTIw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F27E43809A90;
	Fri, 12 Dec 2025 10:08:37 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms9Xd8YEYzsw5DLYvayq0JyUqW4eSBUWwunzhNMVmJWng@mail.gmail.com>
References: <CAH2r5ms9Xd8YEYzsw5DLYvayq0JyUqW4eSBUWwunzhNMVmJWng@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms9Xd8YEYzsw5DLYvayq0JyUqW4eSBUWwunzhNMVmJWng@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.19-rc-smb3-server-fixes
X-PR-Tracked-Commit-Id: 2e0d224d89884819e6f25953bbe860ae6a49555f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ce825345dd63f62cdab80a8c45f943bb65511aa1
Message-Id: <176553411663.2108206.13994456797847564253.pr-tracker-bot@kernel.org>
Date: Fri, 12 Dec 2025 10:08:36 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 12 Dec 2025 03:05:20 -0600:

> git://git.samba.org/ksmbd.git tags/v6.19-rc-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ce825345dd63f62cdab80a8c45f943bb65511aa1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
