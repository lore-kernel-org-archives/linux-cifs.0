Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE193F8ECA;
	Fri, 26 Jun 2026 15:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782488761; cv=none; b=fRzTp6qqH3PkNUh+Z3KaA3/FgUBfolfooEZ60cTzGKRQPo1tPg2DVFS7NKCJzwxA/rjZOCfkUEH5oH+x5vqsim+bAx4wND6F7jTXFb6xKqdcuF4oihpXgpoJ9041cej+OysPk0xOOWcwh9EQgbzvbW9T4Ld5PaxXNHnIhgx1wKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782488761; c=relaxed/simple;
	bh=utC9C7E+iWDa6bWT/ZNi7gmkihmejOF1Cq6j0GIqkHw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=To5VtlnH9I+zZCqe3CKCgGiCqyexGRP9oqASwz10JhNWGt4xRZroL9RzWxRo97yD1TRtV1hONXvBUSYigHAoYEXPuN50iGEk6ESM2ktt0cKyAUJPAJYeniYrlk1hzaEovTSw3DOJfCvyRrboh5Lf4I3ZTydQS5avVmnODbXu8EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQL7FuBm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQL7FuBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515A61F000E9;
	Fri, 26 Jun 2026 15:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782488756;
	bh=hmcK5oM9MWyhhRidUnZ5bv2ctVijOMHCl2ftJ6SEsuk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=WQL7FuBmgdGYcEf7kG93/BhDRmzuFjYeWHGGgpCoaSQpvssl3kP6JtwHL1SFCSaSE
	 tzrcHVcSiHRPf5EW3JtC/IqPqqbjxpEs7n//npt0Kh+9h8+X9WE13TyC1ybqv/dFjM
	 OdOcN5jLX8gm7UyB5rg6PCeCyZ3hYARWgSlV/zF3Oqp2lDkck9pRvZ7id7NJYomt6J
	 RwpqzD752910gXwSH65T69zlvH+lLcqiCi+mzmiOOCuMKexkUEOHIqpRry7ktaR5x2
	 Chqmfn72Gs6WhAZeE5dGLawosH/3oN+2VUhH195BDHe4HPzPf9ToPg+DjHs414uknU
	 BKu9J1LOs5hCA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5698E3938C49;
	Fri, 26 Jun 2026 15:45:44 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mujFFjYs-5LTVycOv9AYVo6Pz0bd8VpPpCCtTpjGoPK8A@mail.gmail.com>
References: <CAH2r5mujFFjYs-5LTVycOv9AYVo6Pz0bd8VpPpCCtTpjGoPK8A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mujFFjYs-5LTVycOv9AYVo6Pz0bd8VpPpCCtTpjGoPK8A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.2-rc-part2-smb3-server-fixes
X-PR-Tracked-Commit-Id: da793cf6d60233f47ea5e7e9e39425d71dfcdb79
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 71fab6fa7615fdf52679a3f80795f33b7f7e61d6
Message-Id: <178248874287.1001923.1494458618432376081.pr-tracker-bot@kernel.org>
Date: Fri, 26 Jun 2026 15:45:42 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 26 Jun 2026 09:18:17 -0500:

> git://git.samba.org/ksmbd.git tags/v7.2-rc-part2-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/71fab6fa7615fdf52679a3f80795f33b7f7e61d6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
