Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB39634889B;
	Fri, 14 Nov 2025 18:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763144439; cv=none; b=VpytGjHg8vNoo5gyygayVllQMWcQlAi4Pe28ZN2EWloyoC4WDIwSDdKqXeuiobY20j9coie5dSTVNi7hcM8bqX0HQ5W4GDA4K3V5U/UqLSpvJtF7I0eh+sM1e6IhZdIPLCTVHGQCvQmuOjEM6b8Vj0JgMAitwa0v3AbVdT5JD1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763144439; c=relaxed/simple;
	bh=sONxbDjfGElNLuX/BVZ8sJnU17fWVkedEI3NQIS49ps=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=BL/Wf7Ys+1oYwgrVX6Ks0muvxNIJZzGwFFtTVXO00OrNgDgPMgyizZQXw2Y/ugIyumoWfewDFgm9ohdJT6m/5NVT8+6U/xUHttxJ8yXqJlxPdsYjh7aiTY4JRPkmlsQMBz0OudcqXj2T8WZMclcxA0Mrk+D+UG1wLr3pZTo0IwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z2KTCvrH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z2KTCvrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB557C2BCB0;
	Fri, 14 Nov 2025 18:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763144439;
	bh=sONxbDjfGElNLuX/BVZ8sJnU17fWVkedEI3NQIS49ps=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Z2KTCvrHlhpDmf/RjxQoMvIo+M0HniR/nW6YHVTAUQ0K7MZjTS67uPdbDsXmzH5LM
	 pwgBUHbiVoOLgrwznPH8iSSuJy6MXAGnch2BrrnxuCl9/JaiwabtWigPN/s7YLO/qS
	 vQPW1bVuhI/ddMhe/oxM/4NT0lyMnDmm66zejn8Bi+DYTTL0L/Um46saiWvKO5mvQI
	 waLgtTyCjsqmmiobwa/uP86sv4G15ckydwSv45doX/yky3ufh6xUgJ9KtRBtRksbP+
	 6w71ZgfUmQECYW2FJEnYHCwU6bkNvsfwIeqBamrzSj0M/+HFwLvpktOXeufOXDRSqB
	 pHNAau7cXslbQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 71F6C3A78A5E;
	Fri, 14 Nov 2025 18:20:09 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvo7wL59QnXL5aBiwYYGMg9oqf4LtO1bu+AX0ym5YFQ9g@mail.gmail.com>
References: <CAH2r5mvo7wL59QnXL5aBiwYYGMg9oqf4LtO1bu+AX0ym5YFQ9g@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvo7wL59QnXL5aBiwYYGMg9oqf4LtO1bu+AX0ym5YFQ9g@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.18-rc5-smb-client-fixes
X-PR-Tracked-Commit-Id: d93a89684dce949c2ea817b6f07feee9a45241a7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 95baf63fe81e5fc91d194019f5aec8ecd9c50bb6
Message-Id: <176314440883.1790606.2961751129177236804.pr-tracker-bot@kernel.org>
Date: Fri, 14 Nov 2025 18:20:08 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 13 Nov 2025 22:23:46 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.18-rc5-smb-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/95baf63fe81e5fc91d194019f5aec8ecd9c50bb6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
