Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233331A9B33
	for <linux-cifs@vger.kernel.org>; Sat, 30 Nov 2024 18:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732991983; cv=none; b=Fwpcl1HVlB/w36CTVrOq3Upi9x696/gINbuotHQuA59YqTFzpkWMK08AzPZDlWjeL1yh++kachppT1WnQRDKUh2aoSCGlZ9PemTlkS7+ycp40jvbCywd8Q1YidK9OpQ4f82KjFvrJzYZ6X+YM+JYN+E32KMdoDNr6kZ0uBlN3xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732991983; c=relaxed/simple;
	bh=S+fouQGE7qXP55mHbtpfWEXufoEL92OVA1ruVQKZAvs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=DCuZIMlrp8vgHqTezQh2+4dS/Z0HQYC3BmoRH7BYE9c1hO+wvMsCXVBCY7PqsrdrVsj1GtaK7o60BgVT8rj1JPdo95wv3/lIbj7xoNzWcZK80OCQkGm62399z1SuY8xvMoFl0S4QnFAYggpgwwddkhZx0bpinJHa8k5Ztm4lHq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3J+Kn9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3J+Kn9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CE9C4CECC;
	Sat, 30 Nov 2024 18:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732991983;
	bh=S+fouQGE7qXP55mHbtpfWEXufoEL92OVA1ruVQKZAvs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Y3J+Kn9p164enyNx6leJwpFy03FJOZSpfyyzJTcWp9BimQqUirrvq2gKuiI9MB+bq
	 1Z7Mt73vzg47IfHfLQ5INWHOnMjvExXB/0MsPju3Arv8soZyp1m2GqYoWm9sVXBZBS
	 L9Nev5V51s5JZPb1UeS96Fev+zI5/EK3oDcIqhUmDmxVs8vqGSkdMWTfq94mnChBbb
	 e7rkheim5KiPyHt7Gpj356b8Q9YR6W0EcUK8jvrPvqqhHQlvgFwCrKM0VmIHzWk9O6
	 U9b/O7os9EHvqmv0DPW0d0iWxKQPg/xNJT1oxaC6cKbv10p6BMO+s+qghxf8fkBh8r
	 uCzFn8d9WCqpg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAFE3380A944;
	Sat, 30 Nov 2024 18:39:57 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms2Omc5gZ_4CbTYMUAHzdadb3Yz7hLg_e92ZEnUQDYHgA@mail.gmail.com>
References: <CAH2r5ms2Omc5gZ_4CbTYMUAHzdadb3Yz7hLg_e92ZEnUQDYHgA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms2Omc5gZ_4CbTYMUAHzdadb3Yz7hLg_e92ZEnUQDYHgA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.13-rc-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 9a8c5d89d327ff58e9b2517f8a6afb4181d32c6e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 109daa2356efe73491e32a3b2431c8bf57a6c58e
Message-Id: <173299199658.2451487.8524643130289256847.pr-tracker-bot@kernel.org>
Date: Sat, 30 Nov 2024 18:39:56 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 28 Nov 2024 16:32:45 -0600:

> git://git.samba.org/ksmbd.git tags/6.13-rc-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/109daa2356efe73491e32a3b2431c8bf57a6c58e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
