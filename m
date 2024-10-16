Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452481D2F73;
	Wed, 16 Oct 2024 20:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729111886; cv=none; b=hQPc24bifQy5iECtX9eGspnN2Yzv4RN85gSsKMQ6kbW8BaY6leU2R1whF5KWuTvT3TdR+eXQ+Xc/R9KGA1PvPj7hG2bQ7b2kfUTCdwjhrnRpjt8t9Umed2HW30T1szJQysaLUs3x6ChZ6kQm3xYvHk/bmYlPdBSr+R9xHIjdgmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729111886; c=relaxed/simple;
	bh=ll7rKl2t8lmoeDjQxdINCWD5JInHosiz+8Z8N2OH1CU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jABHg58bboGQCkZGH2T9F7lc5208Qv0XcpKRmvQ0Kdo3QYhyRNbqec/TG8QaVVyw1dhPyKjheffRgYGoBiT35o8xJSaynnPb/z1EsKHoowgXKjWnV4KFbQgNGB2VN+sua/Noi+7X2k1wqIy7DPabGqiE319Jct4sZmwfnzqRn6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VgLM95+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VgLM95+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22128C4CEC5;
	Wed, 16 Oct 2024 20:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729111886;
	bh=ll7rKl2t8lmoeDjQxdINCWD5JInHosiz+8Z8N2OH1CU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=VgLM95+zqqjvj43adikedzwhYRx/Ahyuhk+62k3OC2U/HADuiCS0jF4lvDbo3837e
	 nF4jDZo+zhPQl4ZGxV4wOTMyZsVzJPnb5s4DwDGChwwxFMtHsl+/5+4PQwA3kXWQY4
	 O/y+K6ghJkHWvHjIL/UvZTXL6yUfMFUyFinTy/mbWksKFKYgEhO3BG4UdPNLa37Tet
	 Obf2aMOKEL7LZNON8JcXwu85/YbSzwgBTfU0uaDjO+yXzDoqPmihnpRUX9WW4+E1HF
	 j8COv4hxNOCDfQ6f5wxRabdKGG9Z05JnJCZHVExkb7mSYI0WQpNktUu1Nti1tFb9qe
	 LRpJQhi1mYcjA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADCFD3822D30;
	Wed, 16 Oct 2024 20:51:32 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mutxO_PamhMp0KBVs-0vn7BC9kBq+5BM6=n_ODg1WnHCQ@mail.gmail.com>
References: <CAH2r5mutxO_PamhMp0KBVs-0vn7BC9kBq+5BM6=n_ODg1WnHCQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mutxO_PamhMp0KBVs-0vn7BC9kBq+5BM6=n_ODg1WnHCQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.12-rc3-ksmbd-fixes
X-PR-Tracked-Commit-Id: a77e0e02af1c2db5fc040511aa78a58a52e116ab
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9f635d44d766b10b6fa5cc08b09a18de7de9ff42
Message-Id: <172911189129.1955101.3562838237978262143.pr-tracker-bot@kernel.org>
Date: Wed, 16 Oct 2024 20:51:31 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 16 Oct 2024 01:09:18 -0500:

> git://git.samba.org/ksmbd.git tags/v6.12-rc3-ksmbd-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9f635d44d766b10b6fa5cc08b09a18de7de9ff42

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
