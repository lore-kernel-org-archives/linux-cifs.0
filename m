Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765AB38FA1;
	Thu, 19 Sep 2024 05:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726723217; cv=none; b=dxLIAtEyBFsAz+JNUNQ02pIDgIXy1lavTNzZO5ERhNVdVtO0XwmL9yIz/OoJEV/qwR/T7pa0Jt26RV0frXf0y435J8E4rTe8YaevKQLt9YiAx1uy46lIdUp4fSgRY5/DuTTW5XomboiRkoHFQ9MZbGPguYZxTRrzuuiNfcjy6iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726723217; c=relaxed/simple;
	bh=lXI9XAw3YgoXa1gKNdr5f2LFaerSlBGtXg4YXVHXMBc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=guYZfIbb7r7DRv4LzLQVbmYCR8U/bQBhUa49uuz+4l52d0B6UfR3HtrNDngDiaXDg4G73IUP31IHa8gxJLf0Y7gQpPc3Aq7Bp5/uDj4SEdV6b0JJPPpa+W8AU0zY5VrwQ8T+FaSTzh6XRMCc6TUtjupnyL+zBWKOUMXXoJgjGYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pYo0OLvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pYo0OLvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B039C4CEC4;
	Thu, 19 Sep 2024 05:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726723217;
	bh=lXI9XAw3YgoXa1gKNdr5f2LFaerSlBGtXg4YXVHXMBc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=pYo0OLvzi1CA9PTpL2Nj50yzBd9x7UEzPAgCEnwFIZeyjuqyCGXcR4YOfW0dZUI2w
	 8IzHamJtR7xB7WooEGgI7LBlkl7lmk/d3yQHCj6tyKbnGqDdXoICjkANt48Iee2QB2
	 SjPCnUgtj+0hIALVsFwdPwI0ux1KN9shPrDx2G+nkvhnopHaM7eT7ovA4nBkMiBZYx
	 8SIkJaBhvoCIcEdrpkp170XHbc4v4ToeyJwr6SYDKKnSB1Q6KBpsMUolcpv4sZdnBV
	 GOpRVExiQP/w3SBoQAMkmRjU1B5hYB4NMKhQ0i+yX7K1gNKNND2J5RpwaNakEtM2O+
	 wyAXp9yVybCqw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 73E963806651;
	Thu, 19 Sep 2024 05:20:20 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtbB4soi6ZYq_ajFy_RaHRm=DdUTfNNbnj0UtfXF5dmEw@mail.gmail.com>
References: <CAH2r5mtbB4soi6ZYq_ajFy_RaHRm=DdUTfNNbnj0UtfXF5dmEw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtbB4soi6ZYq_ajFy_RaHRm=DdUTfNNbnj0UtfXF5dmEw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.12-rc-ksmbd-server-fixes-part1
X-PR-Tracked-Commit-Id: c5a709f08d40b1a082e44ffcde1aea4d2822ddd5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 39898f092589dcfbf1a51d04c6167e0401ca45b1
Message-Id: <172672321939.1036593.278879981163663600.pr-tracker-bot@kernel.org>
Date: Thu, 19 Sep 2024 05:20:19 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 17 Sep 2024 01:23:30 -0500:

> git://git.samba.org/ksmbd.git tags/6.12-rc-ksmbd-server-fixes-part1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/39898f092589dcfbf1a51d04c6167e0401ca45b1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
