Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33FA18E00
	for <linux-cifs@vger.kernel.org>; Sat,  9 Dec 2023 20:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vGh5Ex3h"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B040C433C9;
	Sat,  9 Dec 2023 20:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702154057;
	bh=g4MWFVst4anvyJd7lfKmr0KWl7rxcGNlgzOvgLzAZcA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=vGh5Ex3h6wLAjYXp7LFntwhwDTnmacg/u5ZV+4ycYd14YmBp58EzKjLEMyGSxGK4U
	 VTyg0UG2yEMgYQH2zu5MOvyBVvKmDYrCcuAnYkB9oeMFrN5WcRIgUykC2AbtWyh+kL
	 iMCvi8rJhSNNFBZB4tQF0awsTd1u0ZZtRB+c9Pe8MAne6kThyRWNU6sYgrvOIF9bVQ
	 h0AmkXT5S7AxlM5ydaONgzVjlDV0j7G27FSn3BSfzyKRpwi2fqCiqlqbrHYyS0IWGv
	 6YXEG2fP0gBhHGEUmuD+Z8u8sPB2j/8++Pm5VQ4dkQB9ZUaZm1Q5Csff2bfiBxe5Mb
	 AUdr0Gi7WRndQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79A99C41677;
	Sat,  9 Dec 2023 20:34:17 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtBLhwXUy3KtDxuqAnUJnxav=GFsR+V6ejp1XHpYaDmrQ@mail.gmail.com>
References: <CAH2r5mtBLhwXUy3KtDxuqAnUJnxav=GFsR+V6ejp1XHpYaDmrQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtBLhwXUy3KtDxuqAnUJnxav=GFsR+V6ejp1XHpYaDmrQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.7-rc4-smb3-client-fixes
X-PR-Tracked-Commit-Id: 04909192ada3285070f8ced0af7f07735478b364
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2099306c4e1d5d772b150aeac68fdd1d0331b09d
Message-Id: <170215405749.1707.13043642209572031850.pr-tracker-bot@kernel.org>
Date: Sat, 09 Dec 2023 20:34:17 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 8 Dec 2023 16:26:48 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.7-rc4-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2099306c4e1d5d772b150aeac68fdd1d0331b09d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
