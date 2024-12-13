Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBE318785B;
	Fri, 13 Dec 2024 05:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734066021; cv=none; b=PvFretmYB+SifYG0hdNtLKRb0JlYctO+3+IsPOU2E5v3ljRTHA/ObzraiNM3TclBN51aoBJq8ILn2+loIFcD6jaPVOfnuNmrdcr4A3zdiBPnm6OXUVUUJe4zCBBOO49PQcNdJm/nhNBdTz4moCFiCH663EhnKHPgDrIjj7+tMyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734066021; c=relaxed/simple;
	bh=qDoL1+QrbqfMbxYD6dSKYrokkrLz4JTTUT9bfj0Kzvo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=XPJvvyjUPB50gQwoN1rQbJ22tIpWoHAmrVJs5oacb0ES6rEYKvIhBr/cL/U7ubHDY48p5aV59bREl3A+jt9JdgjlSEEKJcz/2c6rhd55hSWrNNwo9Chxv88Nj+bh0RqDVeOvT3r86T+mBlWEv0MbzSpQA1AulmF8vVa+XIxUD/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A+QFOikY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+QFOikY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4AEC4CED1;
	Fri, 13 Dec 2024 05:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734066021;
	bh=qDoL1+QrbqfMbxYD6dSKYrokkrLz4JTTUT9bfj0Kzvo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=A+QFOikYhO9mXk15Kim0pF8i9Z4ruMniU2eZoQNkhRE1HtjBdvyNGVZ+gx5+NaQzv
	 /ULdqkN8BIsC2TmjlYwaiPoevSPOy6jQDkg5fWmUXsqbYu1dzs+vLwfn8gvb/5HvPs
	 H3Y1gs26pFZ1yTRDyY2dggrf1MTcOQyi9GkJ3jR9SaB2wj9RGxAdffZUqZ1U7Rydj2
	 iXhOzE2y0UZHyBpxkTeKpkanmVMAASGvV5xurV4gV5+7EITjZQxWCjPWg0RrFVNqx6
	 mw0Z22jGDiQw2NCz5gDg5cMa4/C9QB0+x29Cdy4hDU2aZR5kdy3554tn09cZKTtFU6
	 A9UkgsjupC4mg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB05A380A959;
	Fri, 13 Dec 2024 05:00:38 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msa=s5=5tsTP5H1=8ruzKTaHs59xyORk0URRsWTb4Xg7w@mail.gmail.com>
References: <CAH2r5msa=s5=5tsTP5H1=8ruzKTaHs59xyORk0URRsWTb4Xg7w@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msa=s5=5tsTP5H1=8ruzKTaHs59xyORk0URRsWTb4Xg7w@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.13-rc2-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 21e46a79bbe6c4e1aa73b3ed998130f2ff07b128
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f932fb9b40749d1c9a539d89bb3e288c077aafe5
Message-Id: <173406603754.2542567.2529214842266031747.pr-tracker-bot@kernel.org>
Date: Fri, 13 Dec 2024 05:00:37 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 12 Dec 2024 17:47:08 -0600:

> git://git.samba.org/ksmbd.git tags/v6.13-rc2-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f932fb9b40749d1c9a539d89bb3e288c077aafe5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
