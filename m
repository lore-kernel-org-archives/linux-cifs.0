Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094FA10E9;
	Sat, 14 Sep 2024 10:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726308048; cv=none; b=pbUizHPkgvyRmkpW6COJUS98yGSlEazAh8jvqsh/qGbFWATgvbR3eeauJWqEjRG1BhZcj7MU2ArT2H2L6z62opwFPf+83x6h1IPtjHz9vSaB/XReFz60Sf5oHOEr1njkqyguorzkZDDt2RCIBvQjT/VHVvIUkuXEl3KOVN43G+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726308048; c=relaxed/simple;
	bh=SGN9FzkFa5v6MuAOBdU0q1CmwT/IL2vNr9TjofRCilw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=K7uRylqs2IVfWRutR4XjZ4g+DYGEc7mHb/Fh1o9jAiCJXXH/mi7/CTA+LbxqGSYdD8UtMH9FQqmXqvRoAIu3E33i4LA5gjMB9SXJzz4itNOkyM6uWVFbBMlhwueS1aNMuNn6XserrNNhmIboPy/nS1GhGjiZtVz+Fs5b8IgnAEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YAhLaFfY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YAhLaFfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD030C4CEC0;
	Sat, 14 Sep 2024 10:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726308047;
	bh=SGN9FzkFa5v6MuAOBdU0q1CmwT/IL2vNr9TjofRCilw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YAhLaFfYnVhqx6zg9Rem05nnYmsNl66u+i4mcGtF2Z6ssalMUwwjO4yUUXLN/rYk+
	 BR2nc4umMbTQrDGVOhwsA7k/pZLNXJ+iOYtPW4yN4tqW1tZTm5QKs60AoL3BGxjsgy
	 Uudxnh7TOuhT37zLAwW7VB2ZLzciXJBP+wgxriSvps9usJXjrGVymzyRfW70aeF/cy
	 2pepkmWwrHMFT1pI9Pcay/J/5+8+Rv+p0Km9kT6ajGU3eomFzUZFEwztFfkmGweqpx
	 uz+OfbwMW3sWKqlWcdzMC6qeW5sEiwHhHIsJ8M637FBUouJw+UoxRNYnfawCVwiIfc
	 wtzsYFKv0KA2A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 363013806655;
	Sat, 14 Sep 2024 10:00:50 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvA_0dp2NBd9Q46GxnqyZ43SaDFJp6aSVp4xFHWa4zX+Q@mail.gmail.com>
References: <CAH2r5mvA_0dp2NBd9Q46GxnqyZ43SaDFJp6aSVp4xFHWa4zX+Q@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvA_0dp2NBd9Q46GxnqyZ43SaDFJp6aSVp4xFHWa4zX+Q@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.11-rc7-SMB3-client-fix
X-PR-Tracked-Commit-Id: 5a20b7cb0d8d3ee490a8e088dc2584aa782e3355
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d9bc226584fa1a9319f4f26882f046e94cfa032a
Message-Id: <172630804871.2519840.2140613895454324581.pr-tracker-bot@kernel.org>
Date: Sat, 14 Sep 2024 10:00:48 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 13 Sep 2024 23:21:33 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.11-rc7-SMB3-client-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d9bc226584fa1a9319f4f26882f046e94cfa032a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
