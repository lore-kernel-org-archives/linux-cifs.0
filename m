Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F23B37F73A;
	Fri, 27 Mar 2026 20:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774643998; cv=none; b=nIliwNdwswpD+nNob710voQI3RGTTkXVCULMSB/P9nVH0K/bmy801C/EpFhhuC/T4qi2FB3eXCKQrgFyv1exXgEgqDXicZCF1h6FK1BnegbspKJ5HYah2NnbL7dG7WArWN0sSYc8E495pZp7DwUsb0E62oNDWwHfmAKkLAKGS08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774643998; c=relaxed/simple;
	bh=YcTH+lMW/RPGIv8TdI+gIW6DFH7JtK5rrD2CgsPoUbE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Ud4RvhzbHDAfM+WoccniY7UeACoy9ev45zGxea0sExMluZvLnlb3ZcBfAs7hvMU0ZPESHssoOjLmp5jn90EbD4FAK2GFl0TYX5UifL+JSTzF2hYLHr8+Lad9WH6dAEwiQIuWG2eCAuFXAT7ykeiXqGy7D+I0Ke0Sw3FcXpqSL2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D1m3AJVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D1m3AJVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24F5C19423;
	Fri, 27 Mar 2026 20:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774643997;
	bh=YcTH+lMW/RPGIv8TdI+gIW6DFH7JtK5rrD2CgsPoUbE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=D1m3AJVjCuKCK9Ca4uCRc//djrfTt57vV54+zmFu+GI0FkEvU6t/u3Gy4VhMEAUyV
	 V5HjqWe2MLJhVJVzxOwBVA45ZSfjWAJXlyk1ZZe2SKoxAT4giANLXM35C+Ld1ceapo
	 dvgv9BXAay/u7wc+ad4iGMiLcsyR1oTDIKNN5ZB+O4YjtER3nN8EMGENPI3pEpgSVQ
	 DpywAh1RYYEVD59yZAhVGg5F/3F4cxyyjIIi2gcR2AW3rJByiakM+uK3bxY99T7uRM
	 N7pSS5VqaXpIb2y19vJlqGAECYuxE6eKaZPWmq7yWiK03ZEVbzzsmL9MuYuGc7bswy
	 EZ7hsChkNVTTA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02DA53806928;
	Fri, 27 Mar 2026 20:39:45 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtec6-ByETs_C308WcPAJAeou-qKGtSGnn_28-ZSAzyFw@mail.gmail.com>
References: <CAH2r5mtec6-ByETs_C308WcPAJAeou-qKGtSGnn_28-ZSAzyFw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtec6-ByETs_C308WcPAJAeou-qKGtSGnn_28-ZSAzyFw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.0-rc5-ksmbd-srv-fixes
X-PR-Tracked-Commit-Id: beef2634f81f1c086208191f7228bce1d366493d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 34892992d0ed45b4b0547f25e01887b56959fd5f
Message-Id: <177464398357.3654421.2336105886959074729.pr-tracker-bot@kernel.org>
Date: Fri, 27 Mar 2026 20:39:43 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 26 Mar 2026 21:32:24 -0500:

> git://git.samba.org/ksmbd.git tags/v7.0-rc5-ksmbd-srv-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/34892992d0ed45b4b0547f25e01887b56959fd5f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
