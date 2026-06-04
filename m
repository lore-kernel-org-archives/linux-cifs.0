Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6431F2AD35;
	Thu,  4 Jun 2026 00:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780531563; cv=none; b=eX5NaxpAf+kgPZRbscXbXGhtAtpgTjJbdViZ7FGiYrpIJUMRHOPdC+OarGL5k+chB+S1On4hZC7GHxQW3E/iMN1RK1gFCALtBll3I8CYOt/QqF0xvOWvt71bDKfEmfp1crKiQ8GznlhSrz6giU0IWGsfvGGY6wnA67dWqdP/oJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780531563; c=relaxed/simple;
	bh=mi7E+At9QLulzwlQPILcHxfpu7UYlzt7umRN92a9IBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQ7G1VkBkweXGW3F0h6LHJmnoKcuoQJVfnvhtS62S9smQn1TcdaFMtkK++Pd9wK7jzuxddSrx+/3DUYhrvh1JS3vB1amk0/4x+KnD7fmIQeucPpu7SSIEDc4mgDor0k6yZDcVBIsI0ATFN9Q1mdTULjTY+O1K2sPLmkH+TP9uaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NZUGUTeh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NZUGUTeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63691F00898;
	Thu,  4 Jun 2026 00:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780531562;
	bh=dA8qdE9l+pRvTBAM9C2cL0PZzRAsR8Q17W2VthHAZBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZUGUTehfhkpma1CcR7/BVFVdQHw8FXBpMb5DH0qOEUa7dC4/ZzmCJZpnCQCr1Gkc
	 6+I4is3w7Us0bsqjjJumL2ahKX3/NyUlCyNhETtXjNWYqf7I6ajvDX5A7eGYfInKDa
	 JDDRn6ifmrAgvc88cWDgpWViveSYZqf7DbUdrabZAm38Maa5Do0tnBGUyHb78hW/rk
	 qgG3KthWNzW/OvVPE48fzwMRqvKJQ1PGb3hghV6+EjTtcweaWh23EbENvLqYGYgLWS
	 9CmZaCWU9wsBo7c4o9Q1wR6ox7CctYxxgqhdlQYV3t12h2lxqO2v10eWjRU+1Wmjsp
	 g9hp1p3mSupEg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	Stefan Metzmacher <metze@samba.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Pavel Shilovsky <pshilov@microsoft.com>,
	Robert Garcia <rob_garcia@163.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15.y] smb: client: fix smbdirect_recv_io leak in smbd_negotiate() error path
Date: Wed,  3 Jun 2026 20:05:46 -0400
Message-ID: <20260603210831.item015@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603081509.2027062-1-rob_garcia@163.com>
References: <20260603081509.2027062-1-rob_garcia@163.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [PATCH 5.15.y] smb: client: fix smbdirect_recv_io leak in
> smbd_negotiate() error path

Queued for 5.15.y, thanks. 5.10.y is affected as well, so I've also
queued the equivalent backport there.

-- 
Thanks,
Sasha
