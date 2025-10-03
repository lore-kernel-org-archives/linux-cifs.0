Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0B827B357;
	Fri,  3 Oct 2025 21:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759527127; cv=none; b=kZqEmwL7D01Y16jfzQrRfbU+t/ufbAXmuogvX5ZbXttG59xQ1X//ovI+uT5GtCU7OlYeWvDwi4GwZsh2ZtIFcxeHHEZF+k+3mGlVxxjIFG+guQxFo2PBB0bS/TWn4Y2aJ/fxWyP73YCfNPpr2GkgIKUbadQWzIEkpdNx5I924wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759527127; c=relaxed/simple;
	bh=pdaPjIhkMcapZtju3PGAan1vdhIZh/4z4FNAwXHX9cc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TKhuqO2pj2kCI8vLZHbp3uRPpL7RfcL/UoM6KOh/2byQ4kfcvNgLL8cA9v6eWmShXn806yfRBjp6w4T6LWYpB22yDl67MQTjpDVnQe5nGCxER4MUlUMJDyXFwKkESCTkwCTPyBhumXzyBfXLA4srn2uF9KGj4KELUbmTFvcoL/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uU+7aNIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uU+7aNIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB30C4CEFA;
	Fri,  3 Oct 2025 21:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759527127;
	bh=pdaPjIhkMcapZtju3PGAan1vdhIZh/4z4FNAwXHX9cc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=uU+7aNIk8wXuM3s8Fdho+M9elUMHFTXbpjtGuFrpyLeWZWr2kxw4luB2okXx07yMX
	 lzHvs1go6aHoe9MbgpavGbpZNkhqVngAtWOWhz1RN+1JB3JHHpi/ar8XO7bPwqMrbv
	 t4rTxv8IJ2/WRN5Oj43gxlfoHTlYRkQiC86RxwCbnW8z7TjMWWMEUNt3kPfhYvvpiH
	 QjAHQ3yn7GKvJ00b4a3yNOuiOlm+ORJxaJmQanq6g3cpIcGY63qoxXrOM6nLZ3bh70
	 emifUHqiP7/OthsURYUFHveZtB9H8yDu98fwMVlMi8KDd1fhy3Cwel8fzU7nojBw0r
	 x6Hw66sNDYOLA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3687939D0CA0;
	Fri,  3 Oct 2025 21:32:00 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mv8=AvJBTE7cxz=BQsjrR8ZOVS_ZkvVSrLzJqrLiomX8g@mail.gmail.com>
References: <CAH2r5mv8=AvJBTE7cxz=BQsjrR8ZOVS_ZkvVSrLzJqrLiomX8g@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mv8=AvJBTE7cxz=BQsjrR8ZOVS_ZkvVSrLzJqrLiomX8g@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.18rc1-part1-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: e28c5bc45640bc851e8f7f0b8d5431fdaa420c8e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b3fee71e6673393d04476fbe0f4f03f97765e32d
Message-Id: <175952711910.82231.10268816409030486314.pr-tracker-bot@kernel.org>
Date: Fri, 03 Oct 2025 21:31:59 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 2 Oct 2025 12:20:28 -0500:

> git://git.samba.org/ksmbd.git tags/v6.18rc1-part1-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b3fee71e6673393d04476fbe0f4f03f97765e32d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
