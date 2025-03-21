Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5752B4206B;
	Fri, 21 Mar 2025 04:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742531659; cv=none; b=to6KrRlkkk9m+ccyYrPMHKAA7uA6BOqdeEgxxydenJ7Ot+HgVmo6NwHyHYskyWqLveTDQqIbRTmtPYoVaV2RK6k1Adind213+XKpkayF4tN6cNaayqQfySYEZmyituaAX4x5qkyrkRZ9m1AyXlCbdKmjh7+pcymf6Tx0bJSZCwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742531659; c=relaxed/simple;
	bh=EIC9HXTRuEQtdzBaeo/9xcZIAIQJ9DNIuQ8qi5F6I2Y=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=hE9FUoo3Bt2FytjjexrJwkFAaWDUkJbA9TSRBFpUunZ7+wvJgGZUoW4Xx01X12FDRmhnG8Fp4V2vpk8AnnNon5qdzerBqLm8ulZxlPLLKNEKelWp7+16iXXFUECK3SIdfMFLLDSFJ64U9KnQ613HgL941xgu+fg8BpwpZjdFQMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HEkjWjAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HEkjWjAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB446C4CEE8;
	Fri, 21 Mar 2025 04:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742531656;
	bh=EIC9HXTRuEQtdzBaeo/9xcZIAIQJ9DNIuQ8qi5F6I2Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=HEkjWjACCDYwveAu8X6zNtBomOb6QkXK+3UTjC7aILwEqsWZaTFH7dcLwoQhcHanT
	 UTROL/YGkiXOKVz9IHMbmH/M13SobOMjCaCi5P0hdK9v8bgfIVFoqoUQtKATClopPc
	 E8032rB0SPTDKmBX2MnqFrn78X+nBE1jTHE+wpH8kFHHl2IZdrG7QcegfrgfzRf2Ew
	 gqrjjK8u9W053dz6VrdemLvkJU5cXmXAXAKhEiCpHcB+ScIypG6wUGkXkB4aGDU7Vx
	 ks3PjCCbIPfHkmTrOd/Wa0AQYrYTQL3/fgaYXcOyWipfhbCI/FdgIbwe8NCg3VTWrF
	 RGCqF03efa4LA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAEC13806654;
	Fri, 21 Mar 2025 04:34:53 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msU7_yWYT+waaDx16Bi2ejPJDTUmeMczXOVF1+wPUXvEA@mail.gmail.com>
References: <CAH2r5msU7_yWYT+waaDx16Bi2ejPJDTUmeMczXOVF1+wPUXvEA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msU7_yWYT+waaDx16Bi2ejPJDTUmeMczXOVF1+wPUXvEA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc7-smb3-client-fix
X-PR-Tracked-Commit-Id: 7643dbd9db09fffebb4a62cd27599f17f4148b17
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a7ea35b61e37149963d975814104302fe8d69862
Message-Id: <174253169257.2013956.17698495532878786080.pr-tracker-bot@kernel.org>
Date: Fri, 21 Mar 2025 04:34:52 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 20 Mar 2025 22:43:02 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc7-smb3-client-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a7ea35b61e37149963d975814104302fe8d69862

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
