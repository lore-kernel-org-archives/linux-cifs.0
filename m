Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DED1161;
	Sat, 24 Aug 2024 01:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724462677; cv=none; b=hiyCZ8Iuslonu8CCzTOswJsuIGIw9EwUuy0CqYSRxXZlT1qZ4SIz/ioIAusDRIAS3suMjqj7ikw1OvvcsgWaQZ3FpAcdN2YD2ofx9TbO3sfvnC2cLiKKoZ1SxS7H7bGt2nA1LJfAHUA5BsNKiTbAn7/3ODEtNmqIw9Fy68pZxIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724462677; c=relaxed/simple;
	bh=lrb2NREsAdVP7/tjJCs9rDrCo5fWQrYzZbK0wdJkD28=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=qmp9FS32VzJBtqrvPjWX6iMsfw8yO0rBwZRnvSWy9BxUOBUrRuIOO1no83yJOEjTHsYRwYoCsnMxhRb4UD8Zp8rJCxIkzMCrWbLZIxVrqh/DLdHr1oajxorftGrQwnPvXC8vm9c7Yqmq2t4AuWtvWbgLdgSk5joVzMCAEZhXQC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hp3BatmK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hp3BatmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34035C32786;
	Sat, 24 Aug 2024 01:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724462677;
	bh=lrb2NREsAdVP7/tjJCs9rDrCo5fWQrYzZbK0wdJkD28=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=hp3BatmKaBY5NZGiWHZm0oiGbfnYeudDW4jMCYRgQhKSP2MEjt6G9Q0P9Z9QIpd8F
	 ig5I2x999ApomJxk0Dv/vItOQzpMdPyswwXBzLkEdiLt6NJpMYRsQNeWXHDE8TJl1k
	 6xQ0khiWHCy9OwJyNmoAF1Nc+94vzeMVYVF63LzEqxe4gCIWnrva7Ttw1G7gtYZ3I0
	 CuIzIJkLgW52PdfCMzOnb6zHrU4JR0lbO7CPr4nX4rQVSPHFQCIw8g4VtcSvCRoBmG
	 LNXzrYcFGQXm0Ny4cPWSI2lei3/1b2RyuhE6Mluhp7hJ3QWfJ0MqnwGn0lBXHA0tIO
	 gOw95fzKXrUAw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 342723804C87;
	Sat, 24 Aug 2024 01:24:38 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muykPAu=GaXaHRsfK2nU0jkREv4Pqd6cM5joLDbT+pZTA@mail.gmail.com>
References: <CAH2r5muykPAu=GaXaHRsfK2nU0jkREv4Pqd6cM5joLDbT+pZTA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muykPAu=GaXaHRsfK2nU0jkREv4Pqd6cM5joLDbT+pZTA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.11-rc4-client-fixes
X-PR-Tracked-Commit-Id: 5e51224d2afbda57f33f47485871ee5532145e18
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 66ace9a8f9b4dedc44045c1e47accf148c7cb5fa
Message-Id: <172446267679.3127411.17230524686396238034.pr-tracker-bot@kernel.org>
Date: Sat, 24 Aug 2024 01:24:36 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 23 Aug 2024 10:40:19 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.11-rc4-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/66ace9a8f9b4dedc44045c1e47accf148c7cb5fa

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
