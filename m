Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FE137C906;
	Tue,  1 Sep 2026 20:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788295876; cv=none; b=aTU7phQhHcmlIMeAW5ldDqxF9FmxJjvKK9pzhAiRYL9vQ1roADRJ5FTE4dHkAq2RRM2Q38RFTmahk+Y3AvjKsmPZUWgKaMJoGPCWmxLuEk+nAdjZkac0DZrqYCWZbmGvmQVA+TJlsPjkmSHi2vMEzY0CW8/MwG3IoRma1hvlF1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788295876; c=relaxed/simple;
	bh=zft0BQUTHFGoj8tWkGL1ZlNmDyiynalwQ6IC3Gu7yfY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=czm64F1bpTyjqiPJGkKcVslZ57KhcoSy++1X6inkjqbnHghDQXQOLFZlcLTdC07xtzLoVWzqDycY6jGkN42t8DTMUBayEYwARJXARgMPQikDosv6c/p0brWGE1VU9r4rP5IKOt+916k84PPAFaJFHp78nwLlj5AuJrvZxTgReEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dc60qxEk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dc60qxEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3061F00A3A;
	Tue,  1 Sep 2026 20:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788295874;
	bh=ijVjrJDoe0odP4aLLF2grpVT+8YBxdlbm81hi0D8WfI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Dc60qxEkSk1ukevfr2CZpsAQbSW1s1YszshBVXJvZXVIaeRMmnBIefUvzOdJZZAhK
	 NtiZ5fTOFm3OGbxTMA+NjxYWIWZlkRK02CzEfxb61w7l7FNLjmFumH6z0+HdDrfEcg
	 lf4N9GahiCAMLDC6ZcLYDzGPgAxnvIVcRJKf6Ot1JiB6f6f4Xw4qbn5s7RtObLqCn7
	 Fj1O5JxG8HKHubyn4c2c38VVNRvZ6jn8fNbZH5v0Z/SlCXQ6qw4UZPpKlTDxmxo7mU
	 LYfAtFh05B/F/aiwnfqfZVVOYdOhyt4DTh0s3/IdDJlPhE6Lz7rJqeTN7YrrTNoXh+
	 tN9rIcVdQxrTw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 57E2339253FA;
	Tue,  1 Sep 2026 20:50:18 +0000 (UTC)
Subject: Re: [GIT PULL] smb client fixes for 7.3-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <9b4b26eaff2ed89ee2da77e8d32881fb@manguebit.org>
References: <9b4b26eaff2ed89ee2da77e8d32881fb@manguebit.org>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <9b4b26eaff2ed89ee2da77e8d32881fb@manguebit.org>
X-PR-Tracked-Remote: https://git.manguebit.org/linux.git tags/cifs-fixes-7.3-rc2
X-PR-Tracked-Commit-Id: 4aa2c106aef4bf3dfd97c30842db0767b26e8428
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 89a312991dc6e638a36adc43ccb91dbc25504c04
Message-Id: <178829581768.1844278.17524989319092874931.pr-tracker-bot@kernel.org>
Date: Tue, 01 Sep 2026 20:50:17 +0000
To: Paulo Alcantara <pc@manguebit.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 01 Sep 2026 17:14:45 -0300:

> https://git.manguebit.org/linux.git tags/cifs-fixes-7.3-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/89a312991dc6e638a36adc43ccb91dbc25504c04

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
