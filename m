Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CA226CE33;
	Fri, 23 Jan 2026 22:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769205832; cv=none; b=YLs5yYusiL/xiduruKd+lucoAgI5lL8O+4qwaZ3WjVen+/vFV9hADh13DpvNBWoOfmmoeW7CmrTWCEOf+aebmI5ZSUkv8//dHGYfuGV6ef36ncJ4RtkldXp4UEIRrEWnDXcCZC/aOvgkrVEY8WgZYoRT8Q/eq+/crhZIuxoII1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769205832; c=relaxed/simple;
	bh=ktQw8/UV9IQcfJIwShqyxhvfClbqW/hNL48qcBlfSXQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=rPTdhDJDqzXpgilyskQFrYnAczU9iLgwgjm4vbLlZjUulgw7rYXFtvH1Wnvw67fHvM9b69m/O39/vOKTNaroe/lrbEvzdsVhLhkyQ2E55JAmBhFAWd16i3fxtSxG4CQ1aqtvI/EhXwtEwLZcepqnZCvSI3sVqRu8U+T06AVp49o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/gY7fDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/gY7fDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E46C4CEF1;
	Fri, 23 Jan 2026 22:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769205831;
	bh=ktQw8/UV9IQcfJIwShqyxhvfClbqW/hNL48qcBlfSXQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=V/gY7fDJwK2WXIHLirk7zWreFYXTXWkB2pgHIkRzoOUYiqyp5vHjzZJuqBtalVe/6
	 rMc+AiN/8RUP6ykkqs2+JakBLKzKkfo3ljrRw6ooa1Fz2yPK98zDI+zB6YtllovsXL
	 E2fBJcBxxBlokDdzu2ihtmcca61DuOWy0bITkyX/cD2NFh7u3Y3YZsSSqi+oihRXvi
	 iZIQRMEgLvi0nmEeR3+l3cscrPKyCLZFs4tE7zd70naBBhHp56ZEp8vu4vGx+xVv98
	 ekmEpODMJ2HPZuuJIjWXzUe6wLKDewvhEUdDF3p0TRnTROYpFnJPzt+tIvOWDaUq/8
	 7vQaPn94/7UmQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8BEE43808200;
	Fri, 23 Jan 2026 22:03:48 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvaWKtqdCYTYv87mqdDzhy-Hw8vs5iTaWTryMzzD2hi9Q@mail.gmail.com>
References: <CAH2r5mvaWKtqdCYTYv87mqdDzhy-Hw8vs5iTaWTryMzzD2hi9Q@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvaWKtqdCYTYv87mqdDzhy-Hw8vs5iTaWTryMzzD2hi9Q@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.19-rc6-server-fixes
X-PR-Tracked-Commit-Id: 5914d98ff0f7f9ec0e3963dbe2773401b02888ac
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6d064432376627ff76f86e16b3fbc13c38e860c2
Message-Id: <176920582707.2729567.2013735540951042619.pr-tracker-bot@kernel.org>
Date: Fri, 23 Jan 2026 22:03:47 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, "Stefan (metze) Metzmacher" <metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 23 Jan 2026 11:50:33 -0600:

> git://git.samba.org/ksmbd.git tags/v6.19-rc6-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6d064432376627ff76f86e16b3fbc13c38e860c2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
