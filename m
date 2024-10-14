Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA07A4204E;
	Mon, 14 Oct 2024 02:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728873541; cv=none; b=Xof4fCyDaTn/1Hdrj8lSKjzNucy6CMUhjDUf/TEzOy8wHhpOLXHJwzST2QTif+Ujt9s1kMlVT19RdloivaUuKK275ecdC6c/pdm6wUonkyc2iCZpT6NN5CHAOBpc0xLlnB8/LJ8PluNsrIW6nYy3nwpQeJMu4pnrw+UC16P/e0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728873541; c=relaxed/simple;
	bh=xoRNlGpZHacJYBuNeUX1sMAz6MkaCDXSUlbHz+Zes74=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ILH5Zf8Bb1DXE65sY/O77NW/fKqm95JUWjfc/3dWkJ8HXtEOfGyhR1SPrGSZ+HtUi97zr7h5cJthCzyTYUjGRmp9ap5bx2tUY2d+0SKJR3qLmj61XemaRoPBDw20sFDmwc5FTaqMLh2aMlLpzUcfKKidta47buNOjg2VNDmekMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DFeoqB1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DFeoqB1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B932EC4CEC5;
	Mon, 14 Oct 2024 02:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728873541;
	bh=xoRNlGpZHacJYBuNeUX1sMAz6MkaCDXSUlbHz+Zes74=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=DFeoqB1Z49Uu0lhSFpt/tnjNOvqBSINnywonzhOVNNhlzOBHsjHllQdH6ASumyd/9
	 6MG7CKac9snTk3u5Nm7i8JZXbpCYjF+ztI5mt2qjjmf1C2QRbhR5MHjh3VDwrsuyzq
	 YNdoCgaIYIluGfSdh8rwwjYdJQnH/N0LwE14VZ3H2HsXWstCYfNc5A+f6eiQU1iAR6
	 fmmsOQN1VD78EXWSI+U1xvWPOsHmKJpbacYHu2tFKojc1TYJtoTXvqxw1iopNgCCjx
	 21h4cS1sPORDBTTO/boQ+8iHfEdPwv+WXsvcY0Hnkx2BCVkIG4VYbRJSCYNCYWd4l0
	 U7GA8lfZjiuWQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB22938363CB;
	Mon, 14 Oct 2024 02:39:07 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtWduOymGy1QSUycG-v6k4p9g=gamROOsrs_dF9SLMbyw@mail.gmail.com>
References: <CAH2r5mtWduOymGy1QSUycG-v6k4p9g=gamROOsrs_dF9SLMbyw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtWduOymGy1QSUycG-v6k4p9g=gamROOsrs_dF9SLMbyw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.12-rc2-cifs-fixes
X-PR-Tracked-Commit-Id: 63271b7d569fbe924bccc7dadc17d3d07a4e5f7a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cfea70e835b9180029257d8b772c9e99c3305a9a
Message-Id: <172887354665.3903120.1163200773554833630.pr-tracker-bot@kernel.org>
Date: Mon, 14 Oct 2024 02:39:06 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 13 Oct 2024 12:50:29 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.12-rc2-cifs-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cfea70e835b9180029257d8b772c9e99c3305a9a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
