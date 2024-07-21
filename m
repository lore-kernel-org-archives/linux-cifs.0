Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A42917548;
	Sun, 21 Jul 2024 22:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721602425; cv=none; b=KKimi+7199Wa6v55U5wZJWG321zDBPxzSU2ZmTeddMw2pMbGiC5JAqlqM4u5htQFI2TkKSIJ7c7aBauSQdhQQl9UX+ZvOFl0aVrBNS+o0KhNQLq5wnMEuBR4oUj4Ihg7OzpSQJrUP1RSFNX4FmbcTFdNY1wyNRJE17fF/On0hlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721602425; c=relaxed/simple;
	bh=lQeWBfPZ0N4VpTm04FhFl+R2LDPDVaWFPwY7sD6UcgE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=FdU04LiVweREeZrHXR/lcjzOKIoovER810GZhw7D7cYkommoK5N8xR+CgGSIN5p4ZczF0X4sEySgkNG3kYCKJtqvXMnp4Rj/PBj672LTrHT5dVq5Mh0Xpj9Sl+mLJ4qPruvcCor+2QON/z4ngyvLqbE6nbOlwwQ9wCBDFv99s2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rDRWXSd5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rDRWXSd5"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C6B2C32782;
	Sun, 21 Jul 2024 22:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721602425;
	bh=lQeWBfPZ0N4VpTm04FhFl+R2LDPDVaWFPwY7sD6UcgE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=rDRWXSd5646o4qa4/+fzkBMt2AZVaq54vJAptEJYE6u2PCcl2VSAJLZee1kN3Pe58
	 /X59oY4VSQBt2/5PS+L+52nLYSJLswz6QE6huiyb6vnrhgSziNV2V6BqPjIX/6Fukn
	 ZzaQxmrUWfrHvYOl++/sJSyeMCN9Wppdp1dZKnBM4jKBKmCIpKwH8KRWuczlIU8STw
	 Zi95sPBFaN8L7nTopJDRbohRyy+76JUeQ1AvYsQ+h9aU1SegvfnrevDV3yYOwpJkQm
	 q02YRyLeKy/ATOVUhxzAMOzqK1QhiuiMwwux+x98iaXzucg3o6mtp3Fizx2/3sBPJs
	 szdXU7bnJ4TiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74423C43601;
	Sun, 21 Jul 2024 22:53:45 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msA=eLHHR14qDo8opf13yGiSKp9D=hN2WzY8FuKPhNvog@mail.gmail.com>
References: <CAH2r5msA=eLHHR14qDo8opf13yGiSKp9D=hN2WzY8FuKPhNvog@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msA=eLHHR14qDo8opf13yGiSKp9D=hN2WzY8FuKPhNvog@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.11-rc-part1-smb3-client-fixes
X-PR-Tracked-Commit-Id: a07d38afd15281c42613943a9a715c3ba07c21e6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 33c9de2960d347c06d016c2c07ac4aa855cd75f0
Message-Id: <172160242547.10014.10825743392417934960.pr-tracker-bot@kernel.org>
Date: Sun, 21 Jul 2024 22:53:45 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 21 Jul 2024 14:48:37 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.11-rc-part1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/33c9de2960d347c06d016c2c07ac4aa855cd75f0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
