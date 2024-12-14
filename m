Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3ACD531;
	Sat, 14 Dec 2024 01:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734140395; cv=none; b=q4WedWfT8B76kRtcCh1FSv+WEeQSRvO7JhVFv8rSRKGjBVih3Ub1hHi9xILPgIimqWY2l7jcE17CzHUjMkMFsb+A2FZcEdqdAMhb2KJ89MmEYgAuoT63IXEHZMf1hesIvIFv1gFHN8nhRl4kSxyMhY5iuLOSyYtHtH43GKbF1PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734140395; c=relaxed/simple;
	bh=pzaB567QgIwrOWKRyuPccND2jrgrQaIvllP8TOxmWhQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=aIHmJBGPVgbqhVA2p/ezq/QIlitGARWNf6dbk5gNBPYVEoH6SeNAlOzYOooTvaSj8S+vTPw1HVXbdYxQCFQQam7UL+vB1CvzOAoVgaf8PJ6PFnzza5Q7v6RUdCvQAep76eb04cBj0gyX2LfXd4k8hLV1fCk3ibbYpDyhSNsn3Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GRZoRh6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GRZoRh6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD95C4CED0;
	Sat, 14 Dec 2024 01:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734140395;
	bh=pzaB567QgIwrOWKRyuPccND2jrgrQaIvllP8TOxmWhQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=GRZoRh6ufLl+NSt9PtTYG0gyLPW3y4UxI1vdDyqTF1lfpb9XPmbWWaWVCdmsLz4Xf
	 UhQ7l83ABB7xBKfECTsjU3ma/AIBd2OB/CTQpvYSTaEcrE+tV/5Sgjie6JO6bpFAvV
	 3Fd8398cM5QOu9i+/hfVVQ+FTalDhz9I+Wo82q1+01MpK9EUUXG0UxFesvqP5kFqSs
	 p5wPzQd8gw0yhkyGAELqS9PdxqUUZTgY4U+aVCUe6tW8Q8DLOQpzYhE1O2kSUsgSvF
	 UAOADGZJqZOt8j/eqnLnyFyk69eXAyIKufFJCvOrs8NSV6tF6V3Gs70h18wHN/miuB
	 AO7Cjt5nRpjjA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE6D6380A959;
	Sat, 14 Dec 2024 01:40:12 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mu+0egy3V0bVRO+OiXbCa+HT5FLA6LKAiJZ2LD85vNvQg@mail.gmail.com>
References: <CAH2r5mu+0egy3V0bVRO+OiXbCa+HT5FLA6LKAiJZ2LD85vNvQg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mu+0egy3V0bVRO+OiXbCa+HT5FLA6LKAiJZ2LD85vNvQg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc2-smb3-client-fixes
X-PR-Tracked-Commit-Id: 633609c48a358134d3f8ef8241dff24841577f58
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a446e965a188ee8f745859e63ce046fe98577d45
Message-Id: <173414041155.3219585.10629172751497157903.pr-tracker-bot@kernel.org>
Date: Sat, 14 Dec 2024 01:40:11 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 13 Dec 2024 18:04:51 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a446e965a188ee8f745859e63ce046fe98577d45

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
