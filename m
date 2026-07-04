Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB272253EE;
	Sat,  4 Jul 2026 02:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783130564; cv=none; b=lzLRVIpT4HBQ23XoeZy7z2WE9eS0VF9jMu71bqit8kad043vCl81+JfyXhU5Of9rfKCS8YLFRlnPiZWkoqdSZ/tYuSwHpqS8aUjaKUjIVO2hgIMrX+83edVz2iWD58JveTNV8al/b4fF/D93bq87TsCZe1HOLfsozYEtr7zWzmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783130564; c=relaxed/simple;
	bh=Y4Ik9D77yiXgt49BBT/fdVrIrOXnLBr8ZuIm1E+IxuM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=qLZl81bU/sWUdFp9oEggmKe4E+Sy0tdN1w6CR+0vG8JF6ezngK8Z4Ywora+acaIh+KvRWTkAqWUd0RylDeqYoT06aLZHtmI+ctt3OSyv6h27fSnKguaFwI69gfXcfqbULLMFRtsUvNHabmpMoBOqQvG1XXJHAFPiZ5QaL5gHIw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IN1UyzDx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IN1UyzDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523FA1F000E9;
	Sat,  4 Jul 2026 02:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783130563;
	bh=LUkUfWBjkB6Mb0cYbK4r9BeGH5PpjnS6KLegKoB1ds0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=IN1UyzDx4kGXiGFuI4m3u/JVl4USucmKQhUsdfQneUz9nST9xnvtivpiC0MBCtuhQ
	 k0qcu3rRSM16bPjvLTDSCq2inN3SYopnjRB4+RM+WsGwHdjBYLQifLmmIn2fLDCLSV
	 kaH21ZyZm9Az4FpZ7gHnUnPTo+wLabu7Ydxncwn9RcidILmOVvUpz6gbFUASbn5ofQ
	 4XkNRZJjc7LllGId8PLUUFjMJiMnqXvwktsKcw5t8kMIOW8nRxABNv8TuqQ1tzOKY8
	 DyfQLpf2mwEsLsYXSZ2cWHaUWyRyunPEY5zhVMuoiGp2AlsXg8iSTjC/Z/7SlWQnNI
	 JSvQyTvkWb+VQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 939833939F31;
	Sat,  4 Jul 2026 02:02:26 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt596rpemKQBEQx_7SO0ZteTBiA=ud5VvycFgkLrQmA6Q@mail.gmail.com>
References: <CAH2r5mt596rpemKQBEQx_7SO0ZteTBiA=ud5VvycFgkLrQmA6Q@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt596rpemKQBEQx_7SO0ZteTBiA=ud5VvycFgkLrQmA6Q@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc1-smb3-client-fixes
X-PR-Tracked-Commit-Id: c16b8c4cfb4fe2244cc33e469a93c1ab8684146b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6cf48bfec934834ade6e0f5745f9afdbddbe446d
Message-Id: <178313054524.3392227.850085047986558184.pr-tracker-bot@kernel.org>
Date: Sat, 04 Jul 2026 02:02:25 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 3 Jul 2026 15:46:58 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6cf48bfec934834ade6e0f5745f9afdbddbe446d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
