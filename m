Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D80639
	for <linux-cifs@vger.kernel.org>; Sun,  3 Dec 2023 01:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GpfgFyDM"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67AE4C433C7;
	Sun,  3 Dec 2023 01:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701566687;
	bh=jCGb32HC2ZtbjbIrvtAjY+kCdo+v8JJzQNSaJCvjfpc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=GpfgFyDMa6aNCA40Pcdb6Kl7I/dnZAPY2wCuQ9jqlZQsZqvjWLfuOZEsFAUj5WbOr
	 qj0Fip7aad6nKmZsRK5wtm8WirTzoxUy0cYpPV71/ATMT8+lcXylzabedpTGpAXDg5
	 tvfzmHLqd5vqRMkjbjm2ycrjnYC/Wm7QmXB+IYP+iZS9jQNdKoR+29cN4yfqXJSda7
	 uvBiuNqD36unKssIuxYW8hZakQCIUoOKhWmG9slrVPVI4TkfoxRfQ1IUdfOds3m1er
	 5iMg0yXgJI78sQAuO0AljeVaN0+SweyqcGBKO11Ieh6vEXkXZMMrWiiaLIdOwCqCS0
	 nxPq4zSK8AYuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 54F1CDFAA94;
	Sun,  3 Dec 2023 01:24:47 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muZp5cizyqC94OT0KkwfKkUBAA0cR3J-0nMxprFpQYwfg@mail.gmail.com>
References: <CAH2r5muZp5cizyqC94OT0KkwfKkUBAA0cR3J-0nMxprFpQYwfg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muZp5cizyqC94OT0KkwfKkUBAA0cR3J-0nMxprFpQYwfg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.7-rc3-smb3-client-fixes
X-PR-Tracked-Commit-Id: 0015eb6e12384ff1c589928e84deac2ad1ceb236
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 968f35f4ab1c0966ceb39af3c89f2e24afedf878
Message-Id: <170156668734.5793.14675332190606854573.pr-tracker-bot@kernel.org>
Date: Sun, 03 Dec 2023 01:24:47 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 1 Dec 2023 17:59:05 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.7-rc3-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/968f35f4ab1c0966ceb39af3c89f2e24afedf878

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
