Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8146915D5B6;
	Sat, 25 Oct 2025 02:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761357784; cv=none; b=dcg7rIEe74qocT5xtaFAU00hPO4mhXUIYrnvRntG0Wok+Fpvh6+lckCptU9SYUsueDt5plj6gjE5OfwJLV5dRnqi4+shF94XzybDUXESoov+WjMHJ4UP2aJuY93YktfQk8zzBsIFZAxVvUst+9+S4QEH+5ids29dhwG+YDWtQH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761357784; c=relaxed/simple;
	bh=tyGt3FgH57Wfh/j1hCLM+hZGtfCJ6so9Pzr0GQ2A2VU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=LaKtZzdcKjcoBqt1kzBZmPvzNcsFljpbYvUx4GIBTa80BF4CqDBGdgjasbem25q4RSXbW/ycmG2UWQlc3qsCky4eCdeSfIt90b2F2YxPGh4YQul2FLn3T5Xrgm0Gg1TzRgTvVw/tSFN9WIJJ2bzNAaSXzZrfSelsTyZL/y+UIM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uI+vuXlA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uI+vuXlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59072C4CEF1;
	Sat, 25 Oct 2025 02:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761357784;
	bh=tyGt3FgH57Wfh/j1hCLM+hZGtfCJ6so9Pzr0GQ2A2VU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=uI+vuXlA0CiQqyWFOEVgG7CSFlFOj9VffnlP/WMiVNK4vkrDxeXknIWhfqD3F2Tux
	 VDb7WEXmbtH/t9PA0LFPnH1nXIGbNjlhwM93olL/7nDwD0kPdF5jIQ9omF1X7xE/yE
	 mDuoW7nVeT4pK55F0atNiKKsAClb4JiF9QP8ErXOuCl4JCmh64VW4QdgXreTjhlUoA
	 YdP394yJzjIqVNlQ8Hv6Qx9ykpSWTawVBb47mNrR3q1Sn6NVyOwo+JAH5HsoD8WQRx
	 wEkpSxXTGRm5ZUtTbDw6iFuYp1D20DA//g6OqBngRPR3Gr94xTDZmiKK8+NcNWEJgJ
	 jBTM1XrrxpO/Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 343BC380AA59;
	Sat, 25 Oct 2025 02:02:45 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muFRm0X_uYTFySHj-T7YZQhXZWVa4WzKny_YmEzXOhCBw@mail.gmail.com>
References: <CAH2r5muFRm0X_uYTFySHj-T7YZQhXZWVa4WzKny_YmEzXOhCBw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muFRm0X_uYTFySHj-T7YZQhXZWVa4WzKny_YmEzXOhCBw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.18-rc2-smb-server-fixes
X-PR-Tracked-Commit-Id: dd6940f5c7dbee7ae70708f4c8967c3c8cb1d965
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 566771afc7a81e343da9939f0bd848d3622e2501
Message-Id: <176135776372.4123084.552328422973549523.pr-tracker-bot@kernel.org>
Date: Sat, 25 Oct 2025 02:02:43 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 24 Oct 2025 20:10:57 -0500:

> git://git.samba.org/ksmbd.git tags/v6.18-rc2-smb-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/566771afc7a81e343da9939f0bd848d3622e2501

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
