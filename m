Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9203E367F4D;
	Fri, 17 Apr 2026 04:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776399098; cv=none; b=Tn5n53i7hbjQj98VS7E8ZRJnqn8Dal7LZ7J88FZNQPyFGBsdmFrJK2FFaAEeSALNeSQ4HwpRonSjs7YutYsyiyl2u0QUo2363oSGPj2dw0sTjIPGrLr3T/ZzhlIc3dxJTFycKhvQD2PNv11uUyN59TGNiB8z425EAnyo0uCH++Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776399098; c=relaxed/simple;
	bh=G0TgcoubKa+qFv6/zJ0ijDGdFhOwyBoMsmmvntAxFb0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=L7LVvaHtsVXEnvPdf/DM/ANDivpPJ6t1uSL+S9epmc6UwUZ8flm+9xdo/nt9glwGe2VIvtL/DHzvbe0mWIrE41T4ESaOh5Q3qW/HaBlrreoulymDyoVtFhr2u1oOhNFpVtWsngB67jN5dm490L8d9taRjGa55gIILT0v0CBR+Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/iOtFEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/iOtFEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C9DC2BCB0;
	Fri, 17 Apr 2026 04:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776399098;
	bh=G0TgcoubKa+qFv6/zJ0ijDGdFhOwyBoMsmmvntAxFb0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=U/iOtFEx0moCxRclv6NzjgjkAkSvhfbdvGG5mSQ+mhBq2s3SbMtru+p9+aTSW4hxB
	 r9enCGEvIEDdtMRemB5tIJIpPJ91ncDZq2BPU3+FZtgOPKcB13rMKKrcVD7DYKJyiF
	 rXKKiLgCLskI08Z2cwTZPaEzohRiLPxQd4VQq4KSL4UHGRCImg2DWW2uCszftmBVVA
	 wszNo6DrIIcz5tTO5GFTF+ElaeX4cQmelwbKlcH/TTfBDXXNtZ+ZeL3pzPZlKgWQC1
	 GA3ynZ0W0XLDt70RPrzC3FTF4VAh0Cq7z0iwMrbWVehz687AG6EPgHOgP5sg2Q3fzr
	 QcmMW4SYPrKnQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BE8AC380AA7D;
	Fri, 17 Apr 2026 04:11:07 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtbfUNKWr4E=yeUgYQhBF=OikCAtxwhJGgUJmr3g0Q1jA@mail.gmail.com>
References: <CAH2r5mtbfUNKWr4E=yeUgYQhBF=OikCAtxwhJGgUJmr3g0Q1jA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtbfUNKWr4E=yeUgYQhBF=OikCAtxwhJGgUJmr3g0Q1jA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc1-part2-smb3-client-fixes
X-PR-Tracked-Commit-Id: c09fb907a2822864b7da866461fb33f10713b4ed
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0b2f2b1fc0c61e602a6babf580b91f895b0ea80a
Message-Id: <177639906668.3519243.847504076119410250.pr-tracker-bot@kernel.org>
Date: Fri, 17 Apr 2026 04:11:06 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 16 Apr 2026 12:15:49 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc1-part2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0b2f2b1fc0c61e602a6babf580b91f895b0ea80a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
