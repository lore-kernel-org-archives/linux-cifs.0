Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6A51E1302;
	Wed,  4 Sep 2024 16:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725468392; cv=none; b=fsKsYEVkF/aZlwZNxmHuJX6Z6nvyU/e6Hz9BsQYkhTFc6pHHqMSCJdXJ/Te071gM37TFmWcOoHOAVdJHmV2R8yGFToyYQFWGGIKmAPzahNM5SlcID5ZCp+WDNSAuOwPszfM0Cfd9HLQzv0f+LfqN6NwD88j0/P1EDg9dH7HJPQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725468392; c=relaxed/simple;
	bh=UuI/p7JZ5bLBufMFsz/m6CDhPZMgtReWPrdg9633Vg0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=l3YE+kiCvGm2JIhlgVVRnsH8Y4cydAAQVwJymGbZ8X9hktJJZAJPbuXgajuIniBgn6U5V7a0eK8JNBOcnFQHW4BNyewFr1AkFPlvmtKJxLzhYv9zaf6EgCqsAVd45E0CO62tOlQmaa5oY2IPinUONDQXM27Lhiqt2giFv05OHoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fx/vXrQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fx/vXrQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34875C4CEC2;
	Wed,  4 Sep 2024 16:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725468392;
	bh=UuI/p7JZ5bLBufMFsz/m6CDhPZMgtReWPrdg9633Vg0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Fx/vXrQ71OR0c/7CyYp1HP0OVdeCLclwWbI6pPkEz66ZVdZo+8BCTiEZM7FHfLIX8
	 Phe7js6Iu75ixvgEn2C5ksq/tJO2IEAX7WM0b9DFhFTwbo6Dp15IrA6jbIm47xqNa3
	 590k+/flaQnNXntVcSbNmpfBBTKzzal1u8dt4tsSRDTK659ysRpRcU/Ps6Rvsoo7bZ
	 4sKFWY18hIrHyjwliJyc1yPEelAh+8X3CQbNeijWSMdrjhm6FFOLntL8rGZ5ACuvh4
	 B+gCDHA38GiwGzqH26carZNbMz5mx/jAwY0SfEQ/7zuAen3k/LONI/pXl311OD/1V+
	 Gf9mRo3nN/AUQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33DB63822D30;
	Wed,  4 Sep 2024 16:46:34 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msCnFTerrxda-e95d6xb5f9kLtEj8=h63WC7Mccj1_8NQ@mail.gmail.com>
References: <CAH2r5msCnFTerrxda-e95d6xb5f9kLtEj8=h63WC7Mccj1_8NQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msCnFTerrxda-e95d6xb5f9kLtEj8=h63WC7Mccj1_8NQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.11-rc6-server-fixes
X-PR-Tracked-Commit-Id: 844436e045ac2ab7895d8b281cb784a24de1d14d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d8abb73f584772eaafa95a447c90f1c02dba0dec
Message-Id: <172546839283.1094870.628726676988015456.pr-tracker-bot@kernel.org>
Date: Wed, 04 Sep 2024 16:46:32 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 4 Sep 2024 09:55:21 -0500:

> git://git.samba.org/ksmbd.git tags/v6.11-rc6-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d8abb73f584772eaafa95a447c90f1c02dba0dec

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
