Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B872E338C;
	Sat, 15 Mar 2025 00:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741999207; cv=none; b=N7Fv6ayRu4uyuznlVzRLTljOn1FIyjYI8ewvpIfVVGxnNwcrZx4qgk76KWHtMpcZSDQnoIguMPTEU7iRidh4zJpZ1cVUiVLjZFFsBqxfX+aIDZErXGONja3yVkmwxuUDzx7v2PiE703ldUfilrv/8a9xp52hKnXfGevJNt+iUCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741999207; c=relaxed/simple;
	bh=25GfS5mAnxjNthtFT/dBVYnxNPldMw+vHEjHvfbbdsk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=eXHvILL2oDrFF0wDdyAKoBRrqe0DXLM7NttddRPuZxNWfIsc8fHfUAcq0DOwcGDa1GI1+TWRlSfF2/5DS9DN3S98AFX5xd0EuW8KAzWMwOqE3w2MNB6i1kEXjIneeiCgIsfPRoQjkJTkdBqCsoYUm24c8AbkoIl9gb6csgIcqDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nUlM9XdC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nUlM9XdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287E5C4CEE3;
	Sat, 15 Mar 2025 00:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741999207;
	bh=25GfS5mAnxjNthtFT/dBVYnxNPldMw+vHEjHvfbbdsk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=nUlM9XdCGYbNLDMUAvS5bCw1qjoOErF29B3uqpj96E1MVbwH6nmtCLRIP8Nb9XKRf
	 c9Ygte87/6sbVFweN3MJ1lerY+6Cbhuv5qZ3oPzSaNk/l4N/3Cw2nRyZU9NqMPMgpY
	 VR/KCCsvcJL8qGYur/QOAfsa01k7V0V7E5/JlYRnHN8clx2wlDpNRR/xMYI5NyY4g6
	 NXKrjOzg+QGxRuGFra3Bl/rYG8SAB77d9Z+Gsq0lFsJfYGVowt7lZ3Ep5zG9UFi0n4
	 8ej5qKWMK7RGGvU1nQkBGEX/Lx915RmHD9f+V6KbdEQ2isS6Y/qfPDgqDq5NlXRTeU
	 OVS7eNGLBbgsA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D31380CFE8;
	Sat, 15 Mar 2025 00:40:43 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtLERdeDNKxfDjHyHQuf82OOd-KXBq==5bOoBi8P7NrrA@mail.gmail.com>
References: <CAH2r5mtLERdeDNKxfDjHyHQuf82OOd-KXBq==5bOoBi8P7NrrA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtLERdeDNKxfDjHyHQuf82OOd-KXBq==5bOoBi8P7NrrA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc6-smb3-client-fixes
X-PR-Tracked-Commit-Id: 605b249ea96770ac4fac4b8510a99e0f8442be5e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a29967be967eebf049e89edb14c4edf9991bc929
Message-Id: <174199924168.2436000.17360732582871549346.pr-tracker-bot@kernel.org>
Date: Sat, 15 Mar 2025 00:40:41 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 14 Mar 2025 18:47:46 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc6-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a29967be967eebf049e89edb14c4edf9991bc929

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
