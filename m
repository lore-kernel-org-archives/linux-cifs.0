Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDABF307AD5;
	Fri, 22 Aug 2025 13:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755869784; cv=none; b=k8evVk2+LuVQR+5PfPWUAneEkw0Kz9ldqdsYgSMWp5SZ2/bl1uqpX4xh87G0p9E6Yky6ryrtWzAm2HN/7aiG2KI9hz1wo9PxYhCvTh8Q9Jtn2p+8oIW/4f8Hdjb/hfnAgy77hazg/Fkyvrt31xD8IHvQ9jCnQDnfBZUtJEF4aHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755869784; c=relaxed/simple;
	bh=kRjl4eBnBIKvnveHBPOxdFl3I1nuVmRA7RHQVb0KSKw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=NTgSMzfRCfv48tK5xITNlO+LA3LjXvi61Dk3mw0Zj+PJqZuT+sVOvmsUvP9kBjDoFW8B1bmExL92R48S6FkVSKshpSAQ/QT7DUpUwMhRIT1oUasyaIlw4rLdD4+wD4zujf9CGFHMUmNH1ZJ0t6C9KPe69cCxh/48ynzlHbYAxYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CHCPbeCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CHCPbeCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA06DC4CEED;
	Fri, 22 Aug 2025 13:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755869784;
	bh=kRjl4eBnBIKvnveHBPOxdFl3I1nuVmRA7RHQVb0KSKw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=CHCPbeCKMD8XzBrVhR11X+Y0IQZUlNynMTaI+BAiQyM/aIGbOams4dyDKdcX63+M4
	 2LXB9Jbk1tyfxQhXjl1AnnhGhqIPuae4N1nCdBcOjt3p3+CV+lcR06QkY/QX9kSKML
	 FEAPf8DQJ6eHa8kLBCuHkk8H19tgDbTajhhUPNJHiEWXrQL0A7B1LHzB2KzhHSpqFx
	 AVddMzZ4Zk4Ex3yztAeDk1F+HV8pLohu+DBFgypqN4BSpaKutjasPJR5fA4Qvzyndy
	 UwmzFNmo97Zju75y+d6SOMvUpgNULJSNCFyscJaBKfJy1Gpl3LHRFvlotwBxUjHidI
	 xElPfCF9xvSag==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAEED383BF6A;
	Fri, 22 Aug 2025 13:36:34 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtBRtF=ZtzjRWfdMwtvGzJ-oJ5_H2wfoBpkoZJJpfaebQ@mail.gmail.com>
References: <CAH2r5mtBRtF=ZtzjRWfdMwtvGzJ-oJ5_H2wfoBpkoZJJpfaebQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtBRtF=ZtzjRWfdMwtvGzJ-oJ5_H2wfoBpkoZJJpfaebQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.17-rc2-smb3-client-fix
X-PR-Tracked-Commit-Id: 453a6d2a68e54a483d67233c6e1e24c4095ee4be
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3cfcd57def3395d8e767698f3fb20146cb0c4ba0
Message-Id: <175586979352.1831455.9080034604393017469.pr-tracker-bot@kernel.org>
Date: Fri, 22 Aug 2025 13:36:33 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 21 Aug 2025 22:12:02 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.17-rc2-smb3-client-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3cfcd57def3395d8e767698f3fb20146cb0c4ba0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
