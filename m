Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC529334699;
	Thu, 16 Oct 2025 18:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760638006; cv=none; b=aqKTh5jNwgBijZcFw8fxlQfC9lInNPC5LkqnskXusomQhETM6OeBdXpu+0Vg4+T6cv+pAp8kjMWBg5moq74qFS6w1Cz4llTjmJ9vBl//u8P4UGMxZ6YS60pESOcAu8cOZalNw8GZm1mcEyRLzaTt215AtwIolEPXyPZTGnv1xf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760638006; c=relaxed/simple;
	bh=+8FvuCCUytIdDE2Yj+2A+/yBrj1qioY8iwsBM7sdffk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=twpKOeY60dc6ZxPAS3RHSgROEFXipJE+kBmANmpIhoMKcKn470r7mMkR/afCX6z9aC3OhLGn9DK4oTngQoLuFfTL9fJOlq5LFnz/7QZQwrNya3+p6kJXkyW6LODXHJpvo9xgpKlWAv25hYdNSYY0UffH8J95QmWxda63/tlqGlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=huwuglOv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="huwuglOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42BEC4CEF1;
	Thu, 16 Oct 2025 18:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760638005;
	bh=+8FvuCCUytIdDE2Yj+2A+/yBrj1qioY8iwsBM7sdffk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=huwuglOvGiA4nvGCCiig7thjvUBFR4XTLy/rpB/J4YuC5Ysby+o3LhmfIzR/0C6yb
	 VjojCYjkzciyizw8tibW2y1QwvzJwwYY7DFEXZ0WlakV3lkKRRwc1Tkk6g/yt4ph5W
	 SDRP7aqLK7HHzCuSagIAJqkKIJWZHcUYpPhEYbV7BxyXjX1eN0WzdPdBBEeNEkgfYt
	 Ne5/RX0TH+Vvs8tBuBpdhcFEG9Hh/w1/BjaQTV3t87+WJm9B7iLHP5ynK91Qdjty9f
	 KusXh0q58HZhGhbflTZwvB8gxTuIi976Sfp9l9qxS1MWt89+Hw/8ZNOeANjLenjbbj
	 dWq7H31wtS9bw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33CE3383C261;
	Thu, 16 Oct 2025 18:06:31 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt98+bMTuyp+AuEJMi8rCo+2PTxy=a8a_gXi4AyLuSG+A@mail.gmail.com>
References: <CAH2r5mt98+bMTuyp+AuEJMi8rCo+2PTxy=a8a_gXi4AyLuSG+A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt98+bMTuyp+AuEJMi8rCo+2PTxy=a8a_gXi4AyLuSG+A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.18-rc1-smb-server-fixes
X-PR-Tracked-Commit-Id: 88f170814fea74911ceab798a43cbd7c5599bed4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 05de41f3e26237bc34822268f958be1820bf968b
Message-Id: <176063798965.1846882.17102269813455110723.pr-tracker-bot@kernel.org>
Date: Thu, 16 Oct 2025 18:06:29 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 16 Oct 2025 11:52:42 -0500:

> git://git.samba.org/ksmbd.git tags/v6.18-rc1-smb-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/05de41f3e26237bc34822268f958be1820bf968b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
