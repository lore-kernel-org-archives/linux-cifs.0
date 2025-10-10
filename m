Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579DE30147A;
	Fri, 10 Oct 2025 18:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760121914; cv=none; b=krjWeyh4NgLOAjIOSsYSybAFNiEC1nt2j/x5HMH7QDP+kiZZ6UuBiwXKj33szRPtI9kUSPb5KzzQ26oEZ4e8KSyti+fPsp5JftXMqA1yD6MAG0fiYbju5QVZANQedVJcV0FfSjPbiqttepJQtEOD3MZhm9igr2AtJr6z3MRVp38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760121914; c=relaxed/simple;
	bh=DDGTASEoABfCWfI2Yc7cOPTiHuwLBpxmuwI7z3I4dCE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=R9HYwAf4auPrc4jDn5oanOQGArPKvYk7ljBsosNsyW9LeFtsNsSCBB5+pXfLY8Zm6zp4Oflf3WPH6djkOj28rjDoIFP215ktzeZP3ZjcOw8q7PFirAY2CZ8CaX0ANuTS5xIkZBh6g0FrvBag5wzoMdaqEz96WCjbGbgKDioJxz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i1hvBgHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i1hvBgHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD52C4CEF1;
	Fri, 10 Oct 2025 18:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760121913;
	bh=DDGTASEoABfCWfI2Yc7cOPTiHuwLBpxmuwI7z3I4dCE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=i1hvBgHOm7u0O3g1e5Ljzv8iF7PRPOYjfUgTxeLhMoiKt9QjwIsHea3JbKHPFkjsi
	 Z1dDOLX0M7Ia2CaBIfKzTt4tAyyq2+tmiY93Q2rsN31CKdi7E7S/hjgk/FJs0NQZTM
	 rqaxtwdP6TvD7PK2LCNOk3xYZ+oqR8W0YcUSxWdFkyhaYCdz/FkW7M0Yr1OrXWwT+s
	 Lop7VlJ0hCnW0vam8BSr/8Jv+DFDTTTsBXrbtIRtI5ak7eDRKF3sladNJBns6EZvdr
	 Q/UEgalimnb9zqIv3I/6hjxAXhp+l4JJclBMh2C5DIa0h5R8qNvF6/X3hGFrEtfLiS
	 NOkP5q7K/abmA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 71BB43809A00;
	Fri, 10 Oct 2025 18:45:02 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msx5Nkp5PBAAF_Jzzdq87S+dt4VmdUjKHvTGjq6ejKHjA@mail.gmail.com>
References: <CAH2r5msx5Nkp5PBAAF_Jzzdq87S+dt4VmdUjKHvTGjq6ejKHjA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msx5Nkp5PBAAF_Jzzdq87S+dt4VmdUjKHvTGjq6ejKHjA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.18-rc-part2-smb-client-fixes
X-PR-Tracked-Commit-Id: b30c32c784bf29735dabff15443a5feeafd26d1c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 91b436fc925ca58625e4230f53238e955223c385
Message-Id: <176012190097.1082823.18132836918041256481.pr-tracker-bot@kernel.org>
Date: Fri, 10 Oct 2025 18:45:00 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 10 Oct 2025 11:21:06 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.18-rc-part2-smb-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/91b436fc925ca58625e4230f53238e955223c385

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
