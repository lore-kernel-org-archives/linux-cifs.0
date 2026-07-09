Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B840831327F;
	Thu,  9 Jul 2026 23:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783640769; cv=none; b=heiXN5MEWKUHbkkEVO1cCpeZmaAmLBwptzkxH0u1cNQigQZ1t1K/JslUOhwAhsqObcPpg8bv2B/NwImYKd4xm8gQYxxN7X6yLb27PB9+3EE1cMnX4AoAX5MRWUufDlyZryCqTZ+MhLPFIb2f9VO3c5nMdp/8W2D1234VTKOtrLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783640769; c=relaxed/simple;
	bh=xT2ZnIAaRx0EUMD6BUNzNvvu7OjPNpL6+EicJcEMUqI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=SdCvrKKW6/b+GB1+N3wyDfITZxabTXx6JuT1+eQB/QV6HbqdBroXy7NekE2JwFHMxkDGR+Fj5PV5TmdSdlTezduYMQlELXRfU6ueqVP8k895m49jxvuUsCvulcZzjOM2ewLNuufxGKT0x66t2C0+3oUc3bWsvY9ISDMUqNsMn4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RMcC3C1K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RMcC3C1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585D41F000E9;
	Thu,  9 Jul 2026 23:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783640768;
	bh=/Km+399shYHSu9In2jZ8cHwcko7obK05gqI7eUCtLjQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=RMcC3C1KFHSo4mZbSEgsJd7kW21KJNc/hRXSM7lLISZ/v5nQ015N9cMzXc2Y0NcEj
	 lXvjyVvZ+ibE3Sl1rbnaKqnUuxGaSkD/GwMLYTYS5IphiZWwr++YQRewwc/k5bQ4JT
	 bk0u4SWYUi3Lh/PO4bu7h93kIxhZCmV325fWW1SVnY1gnOclsiTM7UdWN0S1J+IULH
	 zEC0+c6kdfkVPvij+ni48uOa1Ig1KZspTXMdGmS1CVw/yATquBDjpDdaMPCo4heSCk
	 VUEGvzi39wq4TPz8gL+EPKM3u153fNB5RvQhq8/qlNxs12KRTONT21ZwL+DdirN75s
	 eRijCxdaTZXng==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0D673924FFE;
	Thu,  9 Jul 2026 23:45:47 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muX5fYTtxMvj9DrdMmMEU2Oi+_nk2oK0zH+J4fRctrJLQ@mail.gmail.com>
References: <CAH2r5muX5fYTtxMvj9DrdMmMEU2Oi+_nk2oK0zH+J4fRctrJLQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muX5fYTtxMvj9DrdMmMEU2Oi+_nk2oK0zH+J4fRctrJLQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.2-rc2-smb3-server-fixes
X-PR-Tracked-Commit-Id: f49bca41c12f9f79d39dbf0779d0c672d74b09fe
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a635d6748234582ea287c5ffeae28b9b23f91c7e
Message-Id: <178364074640.4164809.3100273739839053193.pr-tracker-bot@kernel.org>
Date: Thu, 09 Jul 2026 23:45:46 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 9 Jul 2026 18:27:55 -0500:

> git://git.samba.org/ksmbd.git tags/v7.2-rc2-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a635d6748234582ea287c5ffeae28b9b23f91c7e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
