Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C9B6FBE;
	Sun,  7 Jul 2024 01:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720316305; cv=none; b=S1r2NzHqNS1jsqx4QhGqSLH5oE1hEuZ4Pf+fbRteeeJiEGl8YkeXln62wwIGytCagx1nGgO2r49Z+qiICgrsxnhxB4bCK2xUqEGA5TQY7652b36E9Lcg9cM3nw42AeGGhEzkne4VdO8/RtebVmU36Mwr3KobbpEgbXf2jFgrZ0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720316305; c=relaxed/simple;
	bh=mjBq4nbkdNsg9RRrKIIsKngKw1fA2Ce9u2NM1Pp7WIM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=VuNhVi527a2Hn8LS04JL5XO7ry2zApNbtMsQf5in+L8qQY83KlDCwzgck/T7rmXQth1sRd5hdbM4j2e8i1UI3SVImeSUdYCUJuWwf0b8bHDUflHvcDUavqpESWuCjzOzQyCQlSrFxDVFFzvNx9pXV1pcRIIwml/ES27R3IIgzlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TYFME9qu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TYFME9qu"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F85BC2BD10;
	Sun,  7 Jul 2024 01:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720316305;
	bh=mjBq4nbkdNsg9RRrKIIsKngKw1fA2Ce9u2NM1Pp7WIM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=TYFME9qu0Dd2oQEDXhhmd7hjiB+uPR5iOGlt7Itt51NNUTqAgkvtX1gfIjQfyhcS9
	 hU6NVPBuoHIt2VGmLxjyEEsRqvOM9X9maiVuWk02xP0zLnQtwChtFTMlYHPNC80+vo
	 KU2vDm1ObzksoaU/cspr6cjAuLC5piCKkaak/98EB8SOENkXMoBicsZS5OMqXFu2rH
	 7ddmnM7Zlpbz+X0Upj6QH5SaZ6M4lEGphLCfmMtqMvjjqbv/A6dp2CIPrBj+aLxQMe
	 1LiF77iPykyrFxnk3TubEeTNCyloTIItOTjm+6pVgY0VBjOUNkRB2inMb/vMLRCTcd
	 T2GY548WD1PvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 04C5FC433A2;
	Sun,  7 Jul 2024 01:38:25 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msEqt_4VmncybOWBcADS96cPd19NjJnhtpkF7eMnAsSuQ@mail.gmail.com>
References: <CAH2r5msEqt_4VmncybOWBcADS96cPd19NjJnhtpkF7eMnAsSuQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msEqt_4VmncybOWBcADS96cPd19NjJnhtpkF7eMnAsSuQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc6-smb3-client-fix
X-PR-Tracked-Commit-Id: 08f70c0a930c00d25015fed7e3b7c5370d60be24
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 256fdd4b71f6e1b49a94f2e44cc2d113bc3f5d62
Message-Id: <172031630501.31798.16259075822453849091.pr-tracker-bot@kernel.org>
Date: Sun, 07 Jul 2024 01:38:25 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, David Howells <dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 6 Jul 2024 16:56:16 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc6-smb3-client-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/256fdd4b71f6e1b49a94f2e44cc2d113bc3f5d62

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
