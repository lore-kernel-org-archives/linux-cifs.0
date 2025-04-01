Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269F618F2DF;
	Tue,  1 Apr 2025 02:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743472953; cv=none; b=YOZj64PcYEb/t5+6R18fcRR3DqQpGAbMjWoCa4wIxFdfxEebsVJBx6HFl4xHUc0fBMOZIAmIEc8GpNhTsSOOXT8nGfGjvYBOwVv1tYArcMkHL/5VOKpGRE64Hr5sKxqIlQSwSF3nozbH4X5Un33KAM2Q4fFIDKoFZ5e6+fWno6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743472953; c=relaxed/simple;
	bh=MnZDDuIkKLL1cTjqoiOjjjPCrcZdDkeP0012uQi52FU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=fgyYIsYiOlSmFMTy6a2vDkU/cHtPiftU8C5oas7O5RbqrqpSVmqoJQn1SImG1ZLnOANB72vDf52CY9lLMa76Zto5p0XceajqqEkm81m2Bim9KOVbhDDWbOOngEser5lzZzY5KvZmPZ7+1u4xDrgpI96O0ZlneeJ024MS5LHZjHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bpn/ciOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bpn/ciOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A13DC4CEE3;
	Tue,  1 Apr 2025 02:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743472953;
	bh=MnZDDuIkKLL1cTjqoiOjjjPCrcZdDkeP0012uQi52FU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Bpn/ciOk0VPGOkaIqqT8yxz2YCyvHvkUifqPqe5x7wKX1Knb3mQ+5amx/+QUHrlb6
	 0tvV+hAkOccvN8BKU7oeaOoMDc8/QYazvlcvwsOGhsSvGNhpIfRvP7s2nkQnXWhcQ/
	 IYWKXGFT4OtwR0V1B0c0S3/U3MM94F/AaZVLx5EL/ah5QAIRub7yrGf2KJUShTet7+
	 j9M8kpaxI7apaffLi2iWOIZ80JusASzT+4/sOD+bWhtuj29WANeh8j768ikvLKcVA+
	 EqZX+q3LtJDXJQ6XyMUMNhFPiKpcQsadzeJ0LLLs6NZ9XcXYG9IK6vGE3ht95Ry4T/
	 uQvXNr1I79Zyw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAEB8380AA7A;
	Tue,  1 Apr 2025 02:03:10 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtYV4wqDvgod+qrzv1+YQN_zzjvEh1TKTwPmtkBU5jC6g@mail.gmail.com>
References: <CAH2r5mtYV4wqDvgod+qrzv1+YQN_zzjvEh1TKTwPmtkBU5jC6g@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtYV4wqDvgod+qrzv1+YQN_zzjvEh1TKTwPmtkBU5jC6g@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc-part1-smb3-client-fixes
X-PR-Tracked-Commit-Id: e14b64247438e5026b2fce8ffd7cdf80a87e2bfa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8b175e2e189673643bf5b996335f0430faddf953
Message-Id: <174347298961.206397.17938911236324954878.pr-tracker-bot@kernel.org>
Date: Tue, 01 Apr 2025 02:03:09 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 30 Mar 2025 18:19:09 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc-part1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8b175e2e189673643bf5b996335f0430faddf953

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
