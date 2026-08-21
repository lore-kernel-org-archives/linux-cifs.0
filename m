Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769663A1D0C;
	Fri, 21 Aug 2026 20:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787344051; cv=none; b=BN7e/3NKfMUBQAW9PxoL4871YvrkGt0SYcmg6RTkutwmb7Gs9WJC/0sJLTtM2fztOh9VblPlG2lVN03MDAgvTLiBnA8lfm1HUQqQ337S05I7Oih7S/6NhWWmJBRjC564kSFkAze8hEWj4+yOCgYs2T9YnIMeyVhUy3aJHeXptFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787344051; c=relaxed/simple;
	bh=UWB8XMODTFYbXmgTFBhNhxoFRYH60hWJ9gWc5pIalwg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=aHgfey/9K4XKLJhRmuPTdq5isRIT3oEtYDKrtwWCP9m2QLmIpotqE0Qw+Yc9Mih2ql2B9ZvDE0/ya8NeOiYhRoUJa6wXAXCI6ItJkQB2efzE6zBI8bP3F+GcPgFVl51aEnUhGEFDkz87hrvArLFG6eQ6SEoxDQURTh6RkUbNucQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QTOKphLw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QTOKphLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B63F1F000E9;
	Fri, 21 Aug 2026 20:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787344050;
	bh=1UbcrIU2LNd8x6MHjaCAlACa0ihgwuepKkjHGk2DAGc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=QTOKphLw2kMGKqpOHdDyIjFrv1qMeG/q/h1To6CXQFaFTRk9gWdZJAOQ96oZvYy4c
	 5hWuba63HOgAtTvWltzNEczDsCPZeOPIY2ggp6XT7KYhiqrhZ6oNFWQ8S68mZULq/N
	 h/MTXNganJcgmdynCAJPvG3LPTFfiyFUDir8nvcPjogpkPEhPmcnKWRoPmso1BOqOJ
	 elt0O9snKbyMTSGCnODIdvN78ofahq4lZpX/x2XZVQGaf8Xz7bIJ3lt7Y6PTI9yi2O
	 QPqh/CYHIoOvZwrVrRtIF/N1hYpTLFPsqPJHlVzQ4+1izWriGwa1qDYLb8J4qRZ1kA
	 mCzYLPSqsCK3g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1988F380CEC4;
	Fri, 21 Aug 2026 20:26:41 +0000 (UTC)
Subject: Re: [GIT PULL] smb: client: replace Steve French as CIFS maintainer
From: pr-tracker-bot@kernel.org
In-Reply-To: <87d3741519271261fe69701617b20dd9@manguebit.org>
References: <87d3741519271261fe69701617b20dd9@manguebit.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <87d3741519271261fe69701617b20dd9@manguebit.org>
X-PR-Tracked-Remote: https://git.manguebit.org/linux.git tags/cifs-maintainer-switch-7.3-rc1
X-PR-Tracked-Commit-Id: 934753d26f1ed7fadeedf1b9e7df6fe75de303e8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 614b9fb585f143d65162f17f1a4b4ec4cbdf5794
Message-Id: <178734399969.1471056.5104582056257829878.pr-tracker-bot@kernel.org>
Date: Fri, 21 Aug 2026 20:26:39 +0000
To: Paulo Alcantara <pc@manguebit.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>, Steve French <sfrench@samba.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, samba-technical@lists.samba.org, linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 20 Aug 2026 22:03:39 -0300:

> https://git.manguebit.org/linux.git tags/cifs-maintainer-switch-7.3-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/614b9fb585f143d65162f17f1a4b4ec4cbdf5794

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
