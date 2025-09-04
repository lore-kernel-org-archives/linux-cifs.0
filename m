Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100B913DBA0;
	Thu,  4 Sep 2025 04:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958749; cv=none; b=kB7THCckWXnCyZTJ/SKR4UdtK91SegmathrnavOw8+WBsBbs/pj5Br9N1/FrTbNbZcf1V+QLvvkh4CVk1vxvci7y8vY1q4dlCMvim103ETqctTiC0OX7VgrJ7/OZrU3AM6XC0PtF7AP59YhIhqC1OX0wPSpicVgceBbGF+giBD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958749; c=relaxed/simple;
	bh=2rS8iv+ps+vLspewdYhPCFfYCTypUpVKbqFnyyp9IW8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=cqkf6lOdtLQo9w7gboWXXqDY31p1rUVyeDH+i3Ys8jgygymsPhu6CK739n5gjJGgKCuBbGnwhefo2G0lN2LruTwnfSUOE8mE4/idS/BArt4S8ZoljJUIWrWKUE1uSdeo25la8thHDV6iH60rRkADmeom4Onh1dpTAH8RwGOfgwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TMq84EC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TMq84EC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4CBC4CEF0;
	Thu,  4 Sep 2025 04:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756958748;
	bh=2rS8iv+ps+vLspewdYhPCFfYCTypUpVKbqFnyyp9IW8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=TMq84EC0Z9UCSjn0w1T+zbXtcidVkLAjXv95iBxwlBB2LQBjgAt8+BatUSlcvASmb
	 532q1w2reI8Ga9QJ8TyQnS0sAeQrdvIXaAHUUGy5NbAoEVNI/djOkEMVW3b+Rw4c0n
	 A2WQfD52XjJF0qc9BVSb65CuLS2hVNJBiL1dyFWMm0Cs++8/F9rixkKM3WkO6/IkpZ
	 ZFG78FyRTAXUiAgRgDCm9tFeZjq272W3L/32iW1iBkqg8pb6meYI5MkDgBrrElCcSR
	 q2Bm2m6R2LTxP+KeN6NJjcghsDhCaewL0XvLQwqJE0a5uOrB7yrJtAyD9cN9Hu9zQX
	 k/RxFXx5ovqng==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADF2E383C259;
	Thu,  4 Sep 2025 04:05:54 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muAY1obqbwyP_KR_mZedEaARQhMyDyKenDv4UOW3cD4bA@mail.gmail.com>
References: <CAH2r5muAY1obqbwyP_KR_mZedEaARQhMyDyKenDv4UOW3cD4bA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muAY1obqbwyP_KR_mZedEaARQhMyDyKenDv4UOW3cD4bA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.17-rc4-ksmbd-fix
X-PR-Tracked-Commit-Id: b5ee94ac651aa42612095c4a75ff7f5c47cd9315
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 08b06c30a44555a8b1d14950e4462a52bfa0758b
Message-Id: <175695875329.1291187.8468229670413433380.pr-tracker-bot@kernel.org>
Date: Thu, 04 Sep 2025 04:05:53 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 3 Sep 2025 21:46:33 -0500:

> git://git.samba.org/ksmbd.git tags/v6.17-rc4-ksmbd-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/08b06c30a44555a8b1d14950e4462a52bfa0758b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
