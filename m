Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2513FADF8;
	Fri, 26 Jun 2026 15:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782488754; cv=none; b=KKBfsG4ZedTv9QX3IxXh07vjCSFBhRG7blN0AUkD13vP5ZXkJk4TnEBv7lBByZNLmG7/JC6wiKjwjvNzRfl34HpSwz6bA3T/pRkm7lBOKRNzt9wm3qIkqiKlSxCY2EmJ5g/RJY8YoJxC1Q1WacGT0DvGDIZR92UtXek+4z0hnnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782488754; c=relaxed/simple;
	bh=XLAK1XOrnVXB5SWJHh1NlPuR3YoADTzZMBPDsYRweSc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=mhZCJtYA1tsjiORI7169gx9jK+/JTnCCYrRv2L2sT94qzYUbvjz5wbmXP0HvcU27CpJmTNCrokZFk7TLlfVdListeKylNT06iW5PglIVvqRoI+NV7iYlBHKH9SiSOJ8kG/DYgIUUPyYHzVLNtT4zU7WbiGrLimwCYyn3mWqaOms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ddDSG/8t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ddDSG/8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151691F000E9;
	Fri, 26 Jun 2026 15:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782488749;
	bh=w1sqEioF/hwHE2XmeN22NL5+G9YzUQeZOiTftacG1tQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=ddDSG/8todnHI9OPiC6cQx6Ro+e1hDBvR10/WbeP9QUGxSjmkPtN7B52f3l6wiHjy
	 f9/NYxlWjVIkJy6weqCv2U1YD7f6lc1XZFqq7iuFv7w0RvQtEDiVb7akimuJIYILLV
	 mAhxKPIFGOr4GcH7WIu1Hf3PDExQJIpvmPl9Zd+TJ6Mb755GIY6DrP/lXETtG0FCKQ
	 AqmGKRNt2WDKmWbISvuE2P2KseOUejMU5+IPaB3rndDR4rUo4CzG7aAxR1xOwWBGBA
	 fiWTpeGJpOQbLkOXW7bjWsNGGPOpWYBR9dn63fFaiymUy6Q8Fz+kDFHBoMsN7JjHu3
	 RBv6YFmqXJEIQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19AF53938C49;
	Fri, 26 Jun 2026 15:45:37 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvMvo-Lmj+XHHpnGm6_iiJTW=e1N_f+uuFUpN_=3omycA@mail.gmail.com>
References: <CAH2r5mvMvo-Lmj+XHHpnGm6_iiJTW=e1N_f+uuFUpN_=3omycA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvMvo-Lmj+XHHpnGm6_iiJTW=e1N_f+uuFUpN_=3omycA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc-part2-smb3-client-fixes
X-PR-Tracked-Commit-Id: f53208233b2acaafe2af99c63c02481b2f5bcb39
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ad054be8117d06838b4d904dc57e0807768658cb
Message-Id: <178248873571.1001923.16371322285876937653.pr-tracker-bot@kernel.org>
Date: Fri, 26 Jun 2026 15:45:35 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 25 Jun 2026 16:28:26 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc-part2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ad054be8117d06838b4d904dc57e0807768658cb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
