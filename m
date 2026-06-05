Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5E72D6E58;
	Fri,  5 Jun 2026 17:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780680776; cv=none; b=YTPWnUaqz1XX1/0tObYBwpWGNjZ7W88b37wV772b7yTJPoKkakiTubR8mM+/y4zVSpAiPKnlCq2Ycf+za0sYVcPGYsb7LG8Mx3kL+b72ZewaHtHjjuasolXm2gh+YIywCTH4T2nU/GDw6WqjyDEV7N7RIx8ZoAu7VIqBHYYkvmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780680776; c=relaxed/simple;
	bh=taHJa7B8gaji+nt/vdr+D+bgAaLStZ1r3vJ44dc4Ftk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=FYfyD6hI9M89FSPBS63q11Nkr+bD6LR9yKBSPDzmDXx0/Tf9uq/0aSBlGCFwmr5qz5+j908C0RFp/fK0RGcIuF70gYjE4rKbC0Ah8VmLqSMzN4uymCd07V4mUsNcvQeECk3QPcGpxvU890Gk4kVqwNffv8+Mm6NwSwYi5SwAJck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YnGAiAgz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YnGAiAgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C459F1F00893;
	Fri,  5 Jun 2026 17:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780680775;
	bh=YVe1VeCszBiPDHSWCeRNs7KSIxxkZFDMHHRbrnRoyIg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=YnGAiAgzBAzaSE15yzjQiFbhwqFuvj5KMJmobdGkrcDw1DVo+TDEr841dQYwkBKd/
	 V4YhJ1PukSIM3tsJGhYa+WoHdRwoHFxW9EOA9u8yNvVoy9nkMO5YVhWDrBQtyRLA6p
	 tXzlzs+DnIbll3wkt8e1GcWMuDENXfnoJfCNTmFYPEIK5qu4SR7qnXEiGW/uaJUuM8
	 zxm0uysWinwIu5ccADFQGUXHM9MevXXe2XuM8kbV0Q4afxty+G0SuMM+/P5uN3C25/
	 rUAW907UG9XS/SSzYDDyiSly0Aco4ZS2VESQkeuIxy3TGBGUkZMOiixZvdkd84SNnh
	 bOAyWQj3SQ1wA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 569943930BAF;
	Fri,  5 Jun 2026 17:32:57 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mu5c04vjOemsf8_c8htBD772sjRkLgNNtX7+bBk66Kg1Q@mail.gmail.com>
References: <CAH2r5mu5c04vjOemsf8_c8htBD772sjRkLgNNtX7+bBk66Kg1Q@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mu5c04vjOemsf8_c8htBD772sjRkLgNNtX7+bBk66Kg1Q@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.1-rc7-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: f580d27e8928828693df44ba2db0fffdbe11dfea
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e4a9638a0b2295fc6b69500b25d01510aa8d66ac
Message-Id: <178068077597.3853150.2635520681545702068.pr-tracker-bot@kernel.org>
Date: Fri, 05 Jun 2026 17:32:55 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 4 Jun 2026 20:05:18 -0500:

> git://git.samba.org/ksmbd.git tags/v7.1-rc7-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e4a9638a0b2295fc6b69500b25d01510aa8d66ac

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
