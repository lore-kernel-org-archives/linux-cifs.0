Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524B21A0BF1;
	Thu, 16 Apr 2026 02:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776308054; cv=none; b=OkClQzxg/khXZsaKsvJpY9so6HeZQgsu4fQW3ofPNpOAyws+1YhEqG6evExA7pxQtbjX7NE+f5mG5uc8vjFRwTcvJ3s/qnndyHDrWAQGcxSb8aTwhTdwDb9eUVwvcSL5oAVhNMNrmCe4wA+nV5MbwNaBLmEI+vxd05dgrwj75yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776308054; c=relaxed/simple;
	bh=ya97CDrpq+3rzcuO+8GqEnhX5OYao40J3DWyDA2xrbI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=c13WYD0OLvtFPj8w5opbj3dSxYcI15DBhz3gPZm3zTNCWA3OGfRxRpH9kiHW90bk7WdVT8qenT4bcm88iHr2XVWy/A6zEZ4eaSy7I3FEM9HmZsLg2+GIvRyJfeROmcG4SZPH2pbhwBO2UTwfs01gYCHmf1aaJdzNBEvKgUhxolk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EH4aQZo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EH4aQZo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFB1C19424;
	Thu, 16 Apr 2026 02:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776308054;
	bh=ya97CDrpq+3rzcuO+8GqEnhX5OYao40J3DWyDA2xrbI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=EH4aQZo0RognKlvrW/oyEUvELNF+bwNQMN0TnR+M9AG9UHRsg3LFLPs2HPn9MmyUA
	 r8ZDYjfjbUs7sqRE835OcFzqPg74Scj0p6+0zSCWgEklDeUaKFE3mLl22iYL5sj2rc
	 LTVklSIZL/seIPoqCkG78GDUtRIEhEI7BXJA0azRF6ilN3jYUYiNQ8UlyYnVuoVFNI
	 2ZrRQFs9Bavtb8FzR43TX+1bmjlQ825fB7xGy2Oh6nm6oI3DynxqKE2L9Gs3sZRMPo
	 +VNz+LD0hgmW2nP58awcskEPOd1o/Di/Vb19XH4bgNH79SxiR3zoLAYLHfPkJVIfwW
	 Da92lnCAdQm/g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FE08380A964;
	Thu, 16 Apr 2026 02:53:44 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtZvz3OW5V_H8Q+mxvY5xeaNb4JVhCxz9ZsUj1FiEGXkA@mail.gmail.com>
References: <CAH2r5mtZvz3OW5V_H8Q+mxvY5xeaNb4JVhCxz9ZsUj1FiEGXkA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtZvz3OW5V_H8Q+mxvY5xeaNb4JVhCxz9ZsUj1FiEGXkA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.1-rc-part1-ksmbd-srv-fixes
X-PR-Tracked-Commit-Id: 2de35d992ba1e4017ec21cde06a85ca7fca94810
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 048091722259b6e8d2ef3b138b0c121a2afabe61
Message-Id: <177630802283.2583492.7025934694157947942.pr-tracker-bot@kernel.org>
Date: Thu, 16 Apr 2026 02:53:42 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 14 Apr 2026 10:11:11 -0500:

> git://git.samba.org/ksmbd.git tags/v7.1-rc-part1-ksmbd-srv-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/048091722259b6e8d2ef3b138b0c121a2afabe61

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
