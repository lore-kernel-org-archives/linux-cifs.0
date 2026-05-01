Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB76423E330;
	Fri,  1 May 2026 00:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777596378; cv=none; b=KfyRm2qkY51icujGD+Krv2WtgrFfKSEB/PbfgCc6v/2/vPTFtBclipbhH1S2RADZfnWQpNpN3CdcDfTO/Tyw7raeUUMTvU6ZV7sjKGd3o9w7IL8AOeVrBiKVPqUUZxMJVw691Fnd3LfmbwwlpGCfjRUhZFONV/EVyR+Uhs46GtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777596378; c=relaxed/simple;
	bh=DwV5ikbyfDmQX8elvyLeNH7DOfFIoSKFuzd5dr2xx9g=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=S79s4qzmbF17oA22QKE7izT3WPpOG3yAIOInT9ipouUGMcmKlxVVlbjH/0PIWM4+O0z6t/MZ5ABao0wbOh5gfRhKKj9KRDnTPYdEfQeU+0tQ0Sw+lE6A6vvhlq9AiJ8fU9WZ76dZOx/beju/te7eMvMSUW6j9orkVptYoyMZuz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GWSCYzzP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GWSCYzzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7FAC2BCB3;
	Fri,  1 May 2026 00:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777596377;
	bh=DwV5ikbyfDmQX8elvyLeNH7DOfFIoSKFuzd5dr2xx9g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=GWSCYzzPNdZxVVDiPuDRIm6pXnSkz10fyhCTzYmmyGi+O7/Vw7V4SQT8LGpHn7GVn
	 YI783BD6HPP78eAyONqDhOUAcOqy4OFGbiegmD04KG/r9Uz90I6m2OADv2bxJHXiYH
	 25gWYx2xETFBY3k+auPAbRAW52WFyWON+g0J4TIm/CoP1wU2MGctX/dVKNkDc4u2Vy
	 1xMi1Ftpp2s9xR2MzrDYjIOTp9pVP7W1AUjSi5A5GCaouSjN9QX/VTTJnv+edIj53Q
	 Wxe3zCr8YxHDKTZpGakRRW+mwQw/YulnS2I1ZPB5/3bDlqapxOVAyk1uAFWJFKH5W0
	 xjJ4DVgMyf6+A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02DB4380CEC4;
	Fri,  1 May 2026 00:45:33 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mugZbZGTBudyymjUYWkXSEBdAB_NaS=QN2upcb3FWGVCg@mail.gmail.com>
References: <CAH2r5mugZbZGTBudyymjUYWkXSEBdAB_NaS=QN2upcb3FWGVCg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mugZbZGTBudyymjUYWkXSEBdAB_NaS=QN2upcb3FWGVCg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc2-smb3-client-fixes
X-PR-Tracked-Commit-Id: c208a2b95811d6e1ebae65d0d2fc13f73707f8e7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 74b54e9b1084cc51e2b655500a174214d3c38c0e
Message-Id: <177759633151.3267405.10983129345236650036.pr-tracker-bot@kernel.org>
Date: Fri, 01 May 2026 00:45:31 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 30 Apr 2026 13:47:23 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/74b54e9b1084cc51e2b655500a174214d3c38c0e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
