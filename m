Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A731A9FBA;
	Sun, 31 May 2026 00:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780186543; cv=none; b=o5FG0Jv6MdkS5c8Fm1Mr3ElE4aZ9qr78NdCtMetbn91EJQBlXW4lx0kOBLne2RyRtu++ZFnz0WHRPwGr5RmgszcXBIyNQ8lKdGpkda9pTiJwECupBvY6bnbrtV+dsHMEOBxjKNg24ej8BtSsqnQyVFCNmmEk2qdU6cm7muRYsmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780186543; c=relaxed/simple;
	bh=11kPNW2rZCWcm6zkEkS11grVCaM4PzvBAInsUoVBqrg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=uLPxb8x0UO4x0VHTAtiCPgf73CWxxFKLMWJDAFt03eZqLUc9qbwzuA0J7KSh5lgR9hspMd0pdHXmI1Mmr9xwHDhOicZVDn3qdy21ajw3Y5atOlVFRw4X0T7m/HOOoYE7D55UzafX/VkfpHqUD/9uN+YW26H+MzJi5x397Ct31W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ftzF3DUo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ftzF3DUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A371F00899;
	Sun, 31 May 2026 00:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780186542;
	bh=6AVOLMxgvrq4k6cVBaa1mpOORXsex8PZ5aKFgqmQh2k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=ftzF3DUoHtvEdEitDnNMEgnipl40S/t1i175OFRfLjKtISL7ZFMhGnl81nBSC15St
	 ebJ6lmbPRkxAhVruRASmuVyVqvkBb8Mb0uigsR/BeUiDxPsmlj9MgprEQl5oTKyxIG
	 AUw7mMmYe5dlHho1UOCl1UayGS8NM6F4gRsVrw1593KyA+US4fwkci7Iyb5Xuwsdn0
	 CcHK5NFCh4PpoRXHqIklKakn2vRMlW22I9a5WeDAGWOrU24aSYhyiLy+U7woJfvi+t
	 z8sa4oPJsx36QBoOWZhpALSY7d114yIB1lcjb5klPYBqyf/HuQt3I01rM0ribaNw4N
	 ccvdvmZZ/FvhA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93BAD39302C0;
	Sun, 31 May 2026 00:15:46 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muLLb7n5GEOBo-Us5zXO7Gc5OU--UmA+f+i0vfMuo6eSQ@mail.gmail.com>
References: <CAH2r5muLLb7n5GEOBo-Us5zXO7Gc5OU--UmA+f+i0vfMuo6eSQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muLLb7n5GEOBo-Us5zXO7Gc5OU--UmA+f+i0vfMuo6eSQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc6-smb3-client-fixes
X-PR-Tracked-Commit-Id: 9d2491197a00acf8c423512078458c2855102b66
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 174914ea551314c52a61713b9c4bde9e42d48073
Message-Id: <178018654516.2748150.10860247601733974933.pr-tracker-bot@kernel.org>
Date: Sun, 31 May 2026 00:15:45 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 30 May 2026 11:42:32 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc6-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/174914ea551314c52a61713b9c4bde9e42d48073

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
