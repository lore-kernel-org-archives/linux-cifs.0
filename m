Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A7E155A59;
	Thu, 19 Jun 2025 00:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750294307; cv=none; b=KdU48HC8iDnZ42rKB3CuGiOmIAAVbq3Y2AmKmLW7+TifbxQGSsV5Zp+YPtVNXc4YlnmlU+tZVEtJVbi9xMPCOhsaGJkFfTa1wxLj6FMBdJmqKiE5Zldk+18zVr/ihYXU/N2Low9mou4v+vzx0EL80HpdO+0yCi1BYe1clqa74AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750294307; c=relaxed/simple;
	bh=5S7L3a58aTHv6yplM9a2szXqqQCXU+CpZYPODNsq8do=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=tkgW+yk7jLGjkZI/znGe0dcy+3wlTH4CaNIlfM8ehR/pEzA5h1L79e+n4zQRzj3QlzOUbkhGfu5uDalRVyevipJ0ZDENQxJE+DhhzkRRzpDUmSlORzSl7b9bkkSbIWyE0Phfe3f25w/Cg/nTq98UX2Fqcki2MdgKvOxiDmiRPCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eefd1L20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eefd1L20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35348C4CEEE;
	Thu, 19 Jun 2025 00:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750294307;
	bh=5S7L3a58aTHv6yplM9a2szXqqQCXU+CpZYPODNsq8do=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=eefd1L20xSPH9MGtIFaGrxoQbV5zESuUJfQiSoEtyhqZl1bqNnU1ip6ypGmjsgb39
	 hbkQ4BNMbsUK3+msmeB4SfBlv0hIHgceAh9jnMD3S9e4myHNRLSFA+MGriiHzP412Y
	 8V3qsSWzapv3CB8O8qCxFJxeWKhLWruFblAD9maVsgzi4BJO/iQNz9WCcIifClv9qz
	 Bv/nM4F2VqOkh9U+LR6jGYnvK8Ld13RnlTI0fgKRhKIN4uUMwrPCar2zxOjtsJiF1a
	 dUQtZOC8nlQBPzd8/W0xyTRy/S05H1jE/KF81qZw8uuLGOWdS+MOVPGBEM/1pKqGoo
	 p8I3hNE0jY43w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADD263806649;
	Thu, 19 Jun 2025 00:52:16 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mthMn2x-R8-xiktKqJ+bYsCD4nBAHEyFMTsDgG-5_boTw@mail.gmail.com>
References: <CAH2r5mthMn2x-R8-xiktKqJ+bYsCD4nBAHEyFMTsDgG-5_boTw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mthMn2x-R8-xiktKqJ+bYsCD4nBAHEyFMTsDgG-5_boTw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.16-rc2-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 4ea0bb8aaedfad8e695429cda6bd1c8b0dad0844
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fb4d33ab452ea254e2c319bac5703d1b56d895bf
Message-Id: <175029433531.307467.2084801247772910640.pr-tracker-bot@kernel.org>
Date: Thu, 19 Jun 2025 00:52:15 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 18 Jun 2025 17:46:50 -0500:

> git://git.samba.org/ksmbd.git tags/6.16-rc2-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fb4d33ab452ea254e2c319bac5703d1b56d895bf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
