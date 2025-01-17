Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71431A0BFD;
	Fri, 17 Jan 2025 17:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737133857; cv=none; b=KfKn+3QFTDzuZMAhfGg3xyqo4z403eYyUvNSot9GFBLS5kN/WNSMyP4Gt8nEpI/xnQKzVyPWRCSgJeIJywSYfXzC1Mx1AcguVb9fNtppbYxkkjr8tr5yNe5q/c0t3CkzeX7Z8OAkKrG2O5mUzefupo3O7q+0+ouksWDblZ8xo2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737133857; c=relaxed/simple;
	bh=j8IgfaAgwLi1GxDDzlb5P2QSnENdSgNIq2sRhSTcDEI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=eomACFQGY8DtwSkoGSPFUEgHjv128LWLvsokc/HFUb2kChcqPow+Ud4nGUiKIMY0vqwaf5dmJABBJl+5GJEKowF7j8FRU6rdJ/uYaqHkECp3SIQ0sOkYRzyTaeUGNHkvZZ1wi5zvsKeCZq31Go743TUHHcnpA5MP7f6qQNjGwbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sxN8ys6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sxN8ys6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A386C4CEDD;
	Fri, 17 Jan 2025 17:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737133857;
	bh=j8IgfaAgwLi1GxDDzlb5P2QSnENdSgNIq2sRhSTcDEI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=sxN8ys6t65JyUT2mpEMP0cswxe+NrrI4d4eMjdS5N9UsGtbC5rzfhU9TMRMs7hkh9
	 QmSTKROX5J6gp/luvFC7oXxC9VPgfClUhel3Dq3c6B9HQHxvAyXiOrhBSS7CKt+kpj
	 Vsa6NuTIIwlgtdf8htugD+Hge/10kyIC7zxqE1XCOof+ofPQB3pXX/PGKAy7U12Ypf
	 yVhRqLJWljpWxZuqJLgV7jTcFeXTXzO2d5eIoZpueKnfKhQAuPMqbw4kdhks0k6GZn
	 WYIvH5zIkOeA37rYCdrPM/F5llDBZTpgxEPTGpQznD1p3WglNcBrWxAnnGsAJMypGT
	 UH8XokGgl6R0Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB05D380AA6A;
	Fri, 17 Jan 2025 17:11:21 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mu3N+w35w+z_UAK4gnriBD+2gxvemXXR93XS_wF9nMRNQ@mail.gmail.com>
References: <CAH2r5mu3N+w35w+z_UAK4gnriBD+2gxvemXXR93XS_wF9nMRNQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mu3N+w35w+z_UAK4gnriBD+2gxvemXXR93XS_wF9nMRNQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc7-SMB3-client-fixes
X-PR-Tracked-Commit-Id: fa2f9906a7b333ba757a7dbae0713d8a5396186e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9ca27296662e3eef9cf6c58bcf22a0490d217738
Message-Id: <173713388059.2196808.1296926026763843804.pr-tracker-bot@kernel.org>
Date: Fri, 17 Jan 2025 17:11:20 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 16 Jan 2025 22:49:00 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc7-SMB3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9ca27296662e3eef9cf6c58bcf22a0490d217738

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
