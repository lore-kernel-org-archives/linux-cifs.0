Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A483217F55;
	Sat, 27 Dec 2025 00:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766795052; cv=none; b=O3v8onEpMije/2pnXQnEEltiQvJRSnh6bRBKPQNIsdKs6Czm5gHqsGdEDqpli5Hu1CqtDF78s5aal1KK8USPXmkuBnGwaV+wR9ZCn8FXdsbPMk99FDjW20Bpy6GKXaSu0zDJ/xfO+3S+Ql+XZ741hoP+iJb5BHRjK2YA3wuh6+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766795052; c=relaxed/simple;
	bh=o6tTkkARC848aIcBey9WWlO/mt4GN4HDzwhPF48FT2Y=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=niyvU3FSXoKpbtsPasMBowp89nGr56u99ZVh5jp5fvt1yw0vq5xYcYB1QwaSF4JWCVKmtp6pIB+eN85wkWylvqnu4wKhro4GLbNuHhxRI6J/NGbJ2aBczI+o+V0HPrqvhSZbM2E8bmJtb9A6eBnK0Li1JHDDbXqiYoLQP8rVw7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b/KJGOy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b/KJGOy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DECC4CEF7;
	Sat, 27 Dec 2025 00:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766795052;
	bh=o6tTkkARC848aIcBey9WWlO/mt4GN4HDzwhPF48FT2Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=b/KJGOy1ugBjo7+rY4CXbb46Lafmk4FPrnCYT6Fyo9pgohC+6CRpI+LN9iHHvLEzy
	 LCI46d47F0r4kjyoAgX9zTlIAWg6iQSHjxNT3+3wzwc3rRBVe0u6T7/atmfVlJ+Wsg
	 hVCzcnHzgNCRempuX5/TpEmPubxmn5EzDd0DwMxgPFdjAdlrvA+2Rn0+TYiD5EU7O+
	 QEt9Alv8cOxvGdlhfsKkNOyaiyPwS01CkC0zP0wws+EwdB5a+xqDsBuKTVMv+jSXLv
	 x1t8ZYbLGtxndxhLRRf9Z59s1mDMWZ19DxI3CcJGwOH0zrc17oRZ6Ngk86HKYIq7NF
	 d1euURmCiqHFA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 788883AAA6EF;
	Sat, 27 Dec 2025 00:20:57 +0000 (UTC)
Subject: Re: [GIT PULL] smb client fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvm777oSgR=O5Xjpg6V=cP9ADv+JbyPZBs_208K9LAshQ@mail.gmail.com>
References: <CAH2r5mvm777oSgR=O5Xjpg6V=cP9ADv+JbyPZBs_208K9LAshQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvm777oSgR=O5Xjpg6V=cP9ADv+JbyPZBs_208K9LAshQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19-rc2-smb3-client-fix
X-PR-Tracked-Commit-Id: cb6d5aa9c0f10074f1ad056c3e2278ad2cc7ec8d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 04688d6128b7c8b4ccec2913e7f2ff1c4437da96
Message-Id: <176679485596.2028187.9135038906339866044.pr-tracker-bot@kernel.org>
Date: Sat, 27 Dec 2025 00:20:55 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 26 Dec 2025 14:06:26 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19-rc2-smb3-client-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/04688d6128b7c8b4ccec2913e7f2ff1c4437da96

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
