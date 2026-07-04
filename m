Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1A2199385;
	Sat,  4 Jul 2026 05:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783141245; cv=none; b=bYBXEQSDuGzYcmgcxqoyqM11x5v3wqnss9gYlyP0BhZZGS3Q9QpxDgszJN5EYcVAHXejnMzS121UmWJFqHnrfiKWqIA6JgZDKT1x0jO2Cux6CXxBjzxtEC9mUpWrP0YrI77A+gcCHmO6crfuJ1Ioa+Zl/VaHNxBAjDj3d8nlph0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783141245; c=relaxed/simple;
	bh=Xw4j6Q51mzB8QHCvmK4EdGBXmK34sptGIyh6t4u3CHE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=cioVDpM0Ta94ZP0nkSx5WND01UvdVSAERtKHbyHaH/Fwaa6wqju9amlaO6Ic7myMjgIYx5vRGywXIRca5m78EBM0u5ugkVzgGWJoSEAkJiaaMmPRvJVkfFdPr/qMT7CDSSVLHQmoiGiB2Qq4aypX0JdBXnItHCfKBcDJRLzK4JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ga3Av+Vo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ga3Av+Vo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072F11F000E9;
	Sat,  4 Jul 2026 05:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783141244;
	bh=pbiSMBttIsaY7/L3q0Q8UFCX5Y6jcOmYHR0DWBafCzI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Ga3Av+VoB9sjnRU7SQ9wtfaa2bzIX0p9cdA5mI+RBET4WJ9D8Pg57HWOibCkAS4c/
	 YGHveLMAJk9Kg4UhsgUww2zxJeTMhv1yqto532D45I9IljsBFr/dW6fPTD8jTHJ1Gc
	 tOyzVU0ktmFvNHjcVGP9FWS1gtS/H2lDnvkQoNZsaCc9Lj3P7IHngFO6o4jj93Q6rN
	 //MLSy9I8Q0pppyG90n+laY/cMiQYQOVwsJOJ4lUmUf65bSdg9X8iQaRMS3FpeqzG5
	 uACZw10S7AEkh6DXBtC2jop3ZGQ9lxmuUaGWtyR81OA92wLPC5/MWctwG1UOs6Q9lD
	 1hNc9Q+h740kA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1D3933939F35;
	Sat,  4 Jul 2026 05:00:27 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muk1fnO80SZWJpmt8_Q7uhRw=2-GcKYs1WppF32nfjo7w@mail.gmail.com>
References: <CAH2r5muk1fnO80SZWJpmt8_Q7uhRw=2-GcKYs1WppF32nfjo7w@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muk1fnO80SZWJpmt8_Q7uhRw=2-GcKYs1WppF32nfjo7w@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.2-rc1-smb3-server-fixes
X-PR-Tracked-Commit-Id: f363a0fb134a3eb9e47368b1edbd251fd76be84b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1e9cdc2ea15adf4a821eefedabf6c0c8cf0b6a55
Message-Id: <178314122567.3436977.1826344924409177796.pr-tracker-bot@kernel.org>
Date: Sat, 04 Jul 2026 05:00:25 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 3 Jul 2026 20:20:11 -0500:

> git://git.samba.org/ksmbd.git tags/v7.2-rc1-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1e9cdc2ea15adf4a821eefedabf6c0c8cf0b6a55

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
