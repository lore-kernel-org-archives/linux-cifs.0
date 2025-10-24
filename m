Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B16230CDAA;
	Fri, 24 Oct 2025 23:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761349767; cv=none; b=ZK5Dea69xQVXJq3WJDqes2HcgdYvfE5VV38fIGoZcbLNNx1IKd4V73swDolrT4WSrx6UrgKNIkg3FsIo3dKgyNiY+oLZhir99byg5fuzKrhoeTNrHwmr9hApxSxoJS0LNBDbxfHkuxxxQ4p/gqncP1lzn7J3psJ8vQYGsubhGZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761349767; c=relaxed/simple;
	bh=9R6mHUpp6x/gBf7H6tNBmy/ivsKvpZxD3g/J3sq0Nqc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=bLNH03QimpN13no+y/m/nTieayL0AA7kzlap8oU6BDcFHOOEEstn22nEoP7ecPHndJG0wrTb8oPC0cvAy2iEW5M8IX8YSkydZHsp0Uv+DwZaQwXeOA6vmg866dFxqPR1SFWKRCaOjdglDTBfA8NT+8KCXsFJnBSdOuO0KBt/tx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZNc5Cxhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZNc5Cxhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D5CC4CEF1;
	Fri, 24 Oct 2025 23:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761349767;
	bh=9R6mHUpp6x/gBf7H6tNBmy/ivsKvpZxD3g/J3sq0Nqc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ZNc5Cxhdrvacz2G49aQ7+92qYDUmunQ3vS5mknO+Kn9txbAXUSf2NGpLnKz1/ezyU
	 PLnBKicdMjwhfQQJVw/jS3/YbvMjhkGktP7AtKPFivMg+srIBhujYFmefj1zfVfwzk
	 kJQyzhr/KLVaTRVSP/gkxDZNVEodTqjQjEgC/fGG+qv2mTG7zL9R5O+rxsGRFOXJva
	 iwc/S5aTZSwParvnFjgdMNtj4YAaoexA6RG4eDdtuEBQb0ke/EfKUrjLDDwBXTbJtx
	 pMYzs000tP6/AXMjIRXpTor2Bb5bjHrsXDaA61YxRf9rOwUpT6eYcOemAeSzqovDMm
	 v/yLLH1+2lOLA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAEE4380AA54;
	Fri, 24 Oct 2025 23:49:07 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtRwOOJo1J_dR_2M4FwPcc1=LP1+NczMV8-PKJf+M=k-g@mail.gmail.com>
References: <CAH2r5mtRwOOJo1J_dR_2M4FwPcc1=LP1+NczMV8-PKJf+M=k-g@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtRwOOJo1J_dR_2M4FwPcc1=LP1+NczMV8-PKJf+M=k-g@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.18-rc2-smb-client-fixes
X-PR-Tracked-Commit-Id: 64c9471aa9ded2440bf182b1c71d3f93f80b2f85
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f2b246572699a66eded2cf7afc46f53837878f14
Message-Id: <176134974662.4096869.9726435977169822763.pr-tracker-bot@kernel.org>
Date: Fri, 24 Oct 2025 23:49:06 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 24 Oct 2025 09:31:01 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.18-rc2-smb-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f2b246572699a66eded2cf7afc46f53837878f14

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
