Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1970376;
	Sat, 15 Mar 2025 04:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742014165; cv=none; b=ph3wZGEyNo4xOmUcFreyJwNoaSULPRUTu3sZ2GFEGvZoBIBdhqsL61yeAVJQCag6l/hkWM8M7y3RaKxGv0I48aHS6TMnkXqht01P2RQ2CumxGbLdeZmBKILYhpKgtGzSe7quUzLkGQjJIJWzcyDlsHALSx2av1NYFOTxY+EshJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742014165; c=relaxed/simple;
	bh=t2OIMGy8jJqpkQEODWNrk37SZ7s2+o4ugUUBdcZ5/94=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=FUcVRYNu1lmJONih8U3o2Sc7jsnANVT0jMa41CRzKCSxXdKeVq6LoPStYmZwhTPiTTGimjXcPkGH+fSFbFOH9TDyiml52RSV5ZfGhhGGWiawIwqEcMpwmQ0hM1t4dLhyWiPOmIQWhrGLFRCGExep86LG9ryz7gQd0srJlqL8n70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C4J1X7h/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C4J1X7h/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62104C4CEE5;
	Sat, 15 Mar 2025 04:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742014164;
	bh=t2OIMGy8jJqpkQEODWNrk37SZ7s2+o4ugUUBdcZ5/94=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=C4J1X7h/W9vq4KOP/+DrouM+OK8p5xXgCl1EkmyoF827JitZQvgVtb1LYPOODSs2w
	 2qfEtjqcKi0MTZvBrwpjzWVfEwpQ7qdjKwd9G3aniWlLyaEfbJRHBRT922JyX1y9Vx
	 b4kCEoGfFiNjsv4CRhNlxDYZUKKtnDmz1xUL3HW2YZcjAKVedNXYVelZJpxkV+62Qy
	 KyXtQ/EYVdp9pkGYE7ljKX+yrW07yMOkDHNqP7QOc5dOVQbR2pn6SqQI4UMELV7u4l
	 PwQ1wblFWXrQy1p2R4LeTj9uNoZR+QCgmdz8Vk3wfem+jSZP3QHZvCix0mlPRecpE5
	 oU/galjZUKR3g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70F32380CFE8;
	Sat, 15 Mar 2025 04:50:00 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msyWMiGJi2VK50A=h3dD9F06eS9M5c51oY0DiSTe0Av_w@mail.gmail.com>
References: <CAH2r5msyWMiGJi2VK50A=h3dD9F06eS9M5c51oY0DiSTe0Av_w@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msyWMiGJi2VK50A=h3dD9F06eS9M5c51oY0DiSTe0Av_w@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.14-rc6-smb3-server-fixes
X-PR-Tracked-Commit-Id: 3aa660c059240e0c795217182cf7df32909dd917
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3571e8b091f4270d869dda7a6cc43616c6ad6897
Message-Id: <174201419918.2481821.10021090562761702486.pr-tracker-bot@kernel.org>
Date: Sat, 15 Mar 2025 04:49:59 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 14 Mar 2025 20:55:37 -0500:

> git://git.samba.org/ksmbd.git tags/v6.14-rc6-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3571e8b091f4270d869dda7a6cc43616c6ad6897

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
