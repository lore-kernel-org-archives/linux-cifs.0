Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10192472BA;
	Sat,  9 Aug 2025 05:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754716780; cv=none; b=NUQ/1UJXhmK572VBCn0GmjuyFO1AA+OlIY//VV2WzGTJZ6756PByd/Aa6J20hS9Ub9iaIR5gaZwVkR0qOJGQR6AfbHwy/CNKZiwWXn0fAn7+d83CTXV0nqU5hmL+bxdJAstvXCmSx1NhcRoeE+mpErkM5Tx5krZJ959pHZwpCW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754716780; c=relaxed/simple;
	bh=EM+2oaL8RvTEu/6IJb6Oow8SOix9OUg+LiiiqO6mNH8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=U3MIOj0bjKduXVu1fp965+en86fjRNtj99f0t77LgGWBhZxzE/B63Ix06+bqh6hIauBShQQho77NpyOWS1Pmh3G/KPNSny0dc0nyWx1gmScaEfsLq696HkIBAc7zs2hFXWNTPTh5G0DC4+qhYAhswFp4hgv4w5f8jihQtG88gXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OI8JWWfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OI8JWWfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BDDC4CEE7;
	Sat,  9 Aug 2025 05:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754716780;
	bh=EM+2oaL8RvTEu/6IJb6Oow8SOix9OUg+LiiiqO6mNH8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OI8JWWfEMRmmfM4mwBeXCysju7fUgJIXfoN7bUh1v5TyweerklfFnFM8KQZKkpqAj
	 j83KUxGRmT53ra69Ju1V0mx+vCce4ldQzUYzLFbtGsgGPXYnMUVjK+91xuRZV1bBP3
	 Nh4ek9jkaZL9OvmicW3JXSzd2hTbDGiXd4aA/Ct1iEAy1u616fUIgY4fJPVGsQl5Op
	 x6n5c+Ye5ZfSWpxeuPSdxR7s4MVz/gwn4y3FqiM7JTdUG1gLhU4PmNO1cj+T5SOn1/
	 l8ZDzVEHmJ4IGpvFm7iBTyoxYIcMZrSQ3qghv+UixBAQkteQhhhRDdJ1AQUhLKQmAf
	 quBfc+NL/HHtg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EACF9383BF5A;
	Sat,  9 Aug 2025 05:19:54 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtS_MJcNe9iXHv2VpC+dtf3G_9nqOqwosH5F2N60idrBg@mail.gmail.com>
References: <CAH2r5mtS_MJcNe9iXHv2VpC+dtf3G_9nqOqwosH5F2N60idrBg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtS_MJcNe9iXHv2VpC+dtf3G_9nqOqwosH5F2N60idrBg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.17rc-part2-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 8e7d178d06e8937454b6d2f2811fa6a15656a214
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 471025c9f7d601c1887fdc582b96138b161b802b
Message-Id: <175471679342.380510.14790392874800101748.pr-tracker-bot@kernel.org>
Date: Sat, 09 Aug 2025 05:19:53 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 7 Aug 2025 23:58:57 -0500:

> git://git.samba.org/ksmbd.git tags/v6.17rc-part2-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/471025c9f7d601c1887fdc582b96138b161b802b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
