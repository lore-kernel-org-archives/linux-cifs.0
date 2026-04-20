Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376233ACA59;
	Mon, 20 Apr 2026 13:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691291; cv=none; b=Qnk44twFBoiJELdZoxo/5TvCzvd1iLNlGTC8WLYOWTi6Ygdfi+wlqNGa2wcvob77joZtXaPwh+UpJNYOnjFA13nOm+zxVNr4Q3cvGndVeeC2kRw4sL4gvdcvMOh/dXRsiVzOdg5vHzexqIXroTlL6b/HVcgIdwjHUwUUOnB8RY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691291; c=relaxed/simple;
	bh=8LZ5bl+knt2OcJdfZuerLEqSkIkxSxyCfsrCyXvC3pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D762nLzCGXtcgEX5U/cXScp1NhrcTInItfpgzlK2aPjOmkrqgb481AZHGgXU9ugMpwgZ2cvm8GKk1Wo7kdiSWtmwnKiwA3kRbmccRoPNdcFo7tdR6mWJqYf1E2CRVKU/uLchJ8WxoCifFHGX7y64IIZjd2xeDIZM6G6Xt9EETy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aXsOwA3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXsOwA3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB0AC2BCB4;
	Mon, 20 Apr 2026 13:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691291;
	bh=8LZ5bl+knt2OcJdfZuerLEqSkIkxSxyCfsrCyXvC3pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXsOwA3NsQoFLxp3cwR66vcfiwp3mEf434XF1fa+C0zBVTX6nwVfD0qDcrAU/mjxU
	 wJl+V8qlgG4EfIeacSWZ4AQcyvQunffTp9rgBw1tomm2NHEYEOk7sXRz+Z1RPA4za6
	 mMlvy+i1ljSw5vXZnEBaAorgSblRxXJzlRmE8/tMTSJfmRMntwjcHba2PW2o87dOWO
	 GwOJaugc98LmUb8ZZN4JE2wtPS7SEQ6fkeOiuZT/OxWQZUuAKtQpG7PhUiSEC/EiAg
	 fcQw6I19y2z4GqZ4BZ8LGbPMrsn/0h7hOPhK3LXqd+/27QW1Rgnlw/w2RGSdOr+IHd
	 IsrWwc1IvDQtg==
From: Sasha Levin <sashal@kernel.org>
To: Robert Garcia <rob_garcia@163.com>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: Re: [PATCH 5.15.y] smb: client: fix potential UAF in smb2_is_valid_oplock_break()
Date: Mon, 20 Apr 2026 09:21:12 -0400
Message-ID: <20260420-stable-reply-smb-oplock-5-15@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260417063426.1101332-1-rob_garcia@163.com>
References: <20260417063426.1101332-1-rob_garcia@163.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Apr 17, 2026, Robert Garcia wrote:
> Backport of 22863485a462 ("smb: client: fix potential UAF in
> smb2_is_valid_oplock_break()") to 5.15.y.

Queued for 5.15, thanks.

--
Thanks,
Sasha
