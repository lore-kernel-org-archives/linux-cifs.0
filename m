Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBA5156661;
	Sat, 17 Aug 2024 23:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723937780; cv=none; b=uYXsDY34+RnmE0MwLDNG1IkekeVOBEXvDUO39VkbC7iNEWH4VwfBcXlfC7nhPKB7K6PlMim/htZ+mp9VbMVkIRykUnBEmL2TpvU1v5R6SeugZB/7CVXAUsXyHX3vwDW2yf6PmymPk9mEPK+wtAEf34QkhurTFXvq7jc3yCbwTUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723937780; c=relaxed/simple;
	bh=/lKVvXmzMqbo23ZoWa6nHI2l4yY5ShCTLI7cBvrCdIM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=G0HkFGFp26SkKXSzoVTZVuwjk8R+1E668dk5fRREy8S4T6Lj9n3Iz6xAzlb8zP2YYDSTPK2Bd+873gcj1+pQayEwhqiqfziefsYtixyEv/LKxhJ3M7apOcQZo+DVnfRdY5FTwlzK8tanZ7HDfRUgzu2SRqilsuqRQMA3RbtS/hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZm6iX3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZm6iX3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56233C4AF09;
	Sat, 17 Aug 2024 23:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723937780;
	bh=/lKVvXmzMqbo23ZoWa6nHI2l4yY5ShCTLI7cBvrCdIM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=PZm6iX3pATRZ9b9twb0tUH5uTFVXrZF4YyVb0OIYldw8HTWvDuh/b74qDLxTLlMAK
	 /QzOWqKM4v4dEKiUC4450GORBScamIZ5u+qaq44439ZaRdyJ4TSWjCKqlNg8lSJufe
	 0tjuy6LFZadXVFfKXb8bCYLShstzxPmPobGGvEIdlQLZU9AalmZ99QV2TKzRWNuAiF
	 vFfJUDs+czoJC/PCiap86k2ue0N/kH7rvlFusFuh1cMZogddAQd7R4bhB2+DNPuNfw
	 VcA9WVQmm7fIEUDB534T/EnlYKCph7Kuj8MwThZFs8cTM6FJCdhDTFOdk6ep2lHi67
	 EbPzQ6X+OlFpg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAE1438231F8;
	Sat, 17 Aug 2024 23:36:20 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtMOk4B+Chvd=an04wjx0zG4NA_b0uSmsBV00qC+T52Cw@mail.gmail.com>
References: <CAH2r5mtMOk4B+Chvd=an04wjx0zG4NA_b0uSmsBV00qC+T52Cw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtMOk4B+Chvd=an04wjx0zG4NA_b0uSmsBV00qC+T52Cw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.11-rc3-smb3-client-fixes
X-PR-Tracked-Commit-Id: 5b4f3af39b6588e8de4444d8e1ccf759b40f9414
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e0fac5fc8b7657ee82a7d23eeac564182dbf51fd
Message-Id: <172393777951.3838684.4659085769681640134.pr-tracker-bot@kernel.org>
Date: Sat, 17 Aug 2024 23:36:19 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 17 Aug 2024 16:52:43 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.11-rc3-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e0fac5fc8b7657ee82a7d23eeac564182dbf51fd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
