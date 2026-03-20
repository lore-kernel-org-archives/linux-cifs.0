Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F2A3C9ED1;
	Fri, 20 Mar 2026 16:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774023959; cv=none; b=qXMz5SdNJ6kj2w2670QbTzQ9AbF6D3HTc/CfiZEGvtO+5l7+i4+F7cf8ip8F9vwKn9D8J1N9YvT+Puf4NtYcMHi66RVE7FEl8nOtgz5GXBZ5BBl0+ppmgdIDGeDwYGJHXT4KLbOqkOcj4N9dtwhx5crZ9kLVGNTTg2Rz1ya4UPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774023959; c=relaxed/simple;
	bh=QWYFkz59bJy9eUMphdKyLUPbjcJwwjNIFtZ4fSFhLCE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Sk3qu1LS9/QeUJigaVmCLzc8yyaDpKkkhbnvnyA95eqzYICyu7JK2TXzlwGiiElpqup0GnST8wCLvc+TiR+ybEpmjxjxUJWx2ydc1Hu/d8Z6DCUjtrJqMjvxnZYWiKBzV+SffLpzBLgYprTE+t3jF9Sb5RlkjNiwHPve+LBcOiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aJ96hKEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aJ96hKEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77046C4CEF7;
	Fri, 20 Mar 2026 16:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774023959;
	bh=QWYFkz59bJy9eUMphdKyLUPbjcJwwjNIFtZ4fSFhLCE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=aJ96hKEulRgfyFaQhAVBRyETRYop+z7dc7i74yDTJOtGHAbVpXAhO6xAztATU64k4
	 DhvBo8Hj17SNxKWVPyvvnORvQvMGttPZe8wB7Pehc+6W1j0R3g/1eC1q7j+h3NDq6g
	 ujffwv64zB/nJb/1e9rT0/Aq+/ezBUojw//dieD0HrOH2QWSe0JIhEOF3X2aplJiqe
	 G+L+yIFXzyfek0EhsxYj2wUvCIBvlgdaemH0hQDSCNYAW6MF3/01wrALPhn8y9TyUJ
	 fiZZVywEKwerAnuj+FXVyhaMQYKAshjlucAer7bZHosQRhYPlC89/HdWOIQ5ulr66I
	 RnetxjTM3JHUw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02C84380820D;
	Fri, 20 Mar 2026 16:25:51 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvhA988KqzRzKhB4S0EaRe=ZJyK2-__O4A3uYjoO2iQGQ@mail.gmail.com>
References: <CAH2r5mvhA988KqzRzKhB4S0EaRe=ZJyK2-__O4A3uYjoO2iQGQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvhA988KqzRzKhB4S0EaRe=ZJyK2-__O4A3uYjoO2iQGQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc4-smb3-client-fixes
X-PR-Tracked-Commit-Id: 23b5df09c27aec13962b30d32a4167ebdd043f8e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7006433ca2de80e4aa7d11dceb3124335cff5a43
Message-Id: <177402394965.2556506.8070560699328014024.pr-tracker-bot@kernel.org>
Date: Fri, 20 Mar 2026 16:25:49 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 20 Mar 2026 10:59:04 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc4-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7006433ca2de80e4aa7d11dceb3124335cff5a43

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
