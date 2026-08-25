Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6236D3446AD;
	Tue, 25 Aug 2026 19:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787687527; cv=none; b=hWYhLmHHBCYkNIQ7J93R/r0iQPCzJMAWeSl3B/tH5x3i/HOwl7NEuLdyUvRa1EAiDpjl+HdYWWO1qbkioc4UQHBxrtY21exl4iDJrO9UFCjLec8wzffwQGgTwyddPHZY9BeY9DXbOxSE+dTf7Y3nuoCpmq5ITG7b7gFuudUCo9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787687527; c=relaxed/simple;
	bh=335mqJujf66rLU8LQrO+4qWz6nSI/9+1N+Hhu4y38FM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Ao9GTXCRaZ8bvVcjnqQpAv04inKxmIRmPKScMBrbiXx9QeEAU5YSfC02DYMzrulxSXhVL7UJSB/0yZeaxweKtn0dQEzxYCk3qk5FDNyWbloXuc+pUGBOVvesOUoPezw0ZvDpZ0q1kihIvDtO/j3owqXd8kMP0HdCcSiQsvZJl8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EHmk9AOu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EHmk9AOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6D11F00A3D;
	Tue, 25 Aug 2026 19:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787687526;
	bh=s9nc83PVHH7g8E2BryRaKeoKz2SFxfu+lXZjPG1COsM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=EHmk9AOuRnMXWYroR6D5nzYA50/DGGeE2orD/bqmELlfCeqVg9F7pkI7cPuC4F2LE
	 DU8upafa8KVrTod9I83GoEfbc+7ZJX1HfrQZsqBbUEkqFqZd4LfARnlnnk+fSNqUEr
	 aCmCjmrE1RoK8P7D0SE+7p6dSMqIPhrQvywMyZbe3vYcm7jUFRYeEyUYtWBU3507Kx
	 RtyYzR+aDJ+usUkACxtHHrrvoqXQ1o6B6WoIa6CiYUlIuEBZ1fo2NtdSobJIiTPqCc
	 udGRHasBfTFl4tyXdBYAv8YuD3vlZAeBS1+opTfgCkaxmYTq5D9oBM3tal2Llj9s+I
	 1ekdv9umpI/cg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 568AC39253CD;
	Tue, 25 Aug 2026 19:51:14 +0000 (UTC)
Subject: Re: [GIT PULL] smb client fixes for 7.3-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <d2674464b7dc751afe232f31411d5379@manguebit.org>
References: <d2674464b7dc751afe232f31411d5379@manguebit.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <d2674464b7dc751afe232f31411d5379@manguebit.org>
X-PR-Tracked-Remote: https://git.manguebit.org/linux.git tags/cifs-fixes-7.3-rc1
X-PR-Tracked-Commit-Id: 6c322f5cf7476ded7a9a20f7be72462065a03c68
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ce14fe4cd756d2ad75a1f5b53816872b4e69f7cc
Message-Id: <178768747293.4034242.9925128084330846721.pr-tracker-bot@kernel.org>
Date: Tue, 25 Aug 2026 19:51:12 +0000
To: Paulo Alcantara <pc@manguebit.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 24 Aug 2026 19:06:45 -0300:

> https://git.manguebit.org/linux.git tags/cifs-fixes-7.3-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ce14fe4cd756d2ad75a1f5b53816872b4e69f7cc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
