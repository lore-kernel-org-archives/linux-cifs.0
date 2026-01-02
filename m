Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4532F9D83;
	Fri,  2 Jan 2026 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767376606; cv=none; b=D9Co+xkKLkP7WE5mpEqecKh/76c4jscD4xs+FfSLrsgPE7Brm+X03CpJZFAr1PrCtXPlnEsCzVrP2wET0J6qA3+Gz+YO4mP0We0y5D2kWaaXrKwyEz4OGgZZmGBP0MdviGILINwOj/Y65jNs+5Y5WLV+sD43hZd2JSD242sxkRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767376606; c=relaxed/simple;
	bh=N28ldKO8sDSLHD0d6MJyt3gyEjrzUP1/KeGKkHya4Rg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=AAQrXaWj5RRbjONr9EnXtPwym1tdvUwDnsEMy5W9P9RAdXsMTW6Zq0cNDYe9PkHWsAPAsvUD0XjABAQ46NxjYeGpSkCAeifcxj26/dA06fQaoD9JcVNa1HGsCUdb9dVxNlb5KABiNp3Kabwat3uTUgoEoZw925J/zzVYDH2Aneo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=us6SuGp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="us6SuGp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4F8C116B1;
	Fri,  2 Jan 2026 17:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767376606;
	bh=N28ldKO8sDSLHD0d6MJyt3gyEjrzUP1/KeGKkHya4Rg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=us6SuGp80/DQejSYO5SeXY7+K6Z0DPA4fQ+WiVKGW3DOog/CrCTlEc0TgSUB3ud6a
	 fatHavQcJErqBsnM2D1lvackUB/D0FwEYAFcEeSHtnbn4LDo6EoSyxCnq59jBPaAzZ
	 ia41YZ+o+85C15b4Ek6C4czLQ2LG/5OkubqtVUfxmoWWop0cKsTI0EDRDCSCEBMKRN
	 IlqXa5/W8BUlhJQtMUd5ujPMNvsCKpT/piVbE5xRksH5frP5TaILodiecbuzkme6nj
	 PQzw5k09GLfaUG1Y9LsjK6R1/1ysY2YcalflP+iFbpL9/pwd4WbR9A/2YUflabyuav
	 Fx6wVMXU7JJlA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 78C54380A960;
	Fri,  2 Jan 2026 17:53:27 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtb82d1+_nY=Kk6F3VN-8V3sY8f-PXtK0E=sa_C6vgtUw@mail.gmail.com>
References: <CAH2r5mtb82d1+_nY=Kk6F3VN-8V3sY8f-PXtK0E=sa_C6vgtUw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtb82d1+_nY=Kk6F3VN-8V3sY8f-PXtK0E=sa_C6vgtUw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19-rc3-smb3-client-fixes
X-PR-Tracked-Commit-Id: fa2fd0b10f66b08bc44745feed1761d7c1539d6e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 047b4e783ce2af73b3287dfabfeaa51684932757
Message-Id: <176737640598.3971834.3560712920483781049.pr-tracker-bot@kernel.org>
Date: Fri, 02 Jan 2026 17:53:25 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 1 Jan 2026 21:54:08 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19-rc3-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/047b4e783ce2af73b3287dfabfeaa51684932757

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
