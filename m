Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795096024;
	b=nVIHwgw3JrPMMdSR6oosseQxoe00zDYgha7zeZEJ6cilT84o2umf+ADOENhcq+FZ3zTW
	 UTQ7Q4l7baS8gCyi2yAMd9YF01O3QjNViV3UiGxmYi7N5LP2KLqYGTHmQe/XTwE/Q6Rp8
	 ybEsuetOhwKUk8pY4hj8cl6Sr3Sf10lH+0otBEwoo75WnJP0uShke4BvKHqwTMIjWGNQ/
	 IiYfEuunKz6KlaGFiyfOgfb+GMLFGgXUX5wIUe6vTPERpbwZM7am/YoagWN5fbvFS+E25
	 HMKzAFQDo4viPRurHZUkQBetAGIhM5QfnxYv9sq1EVh49joYI4E/Wggw0QTDr9VF6Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795096024;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=Z7jDqe7+LzAopxnu2HKkLbTVJ3N8yzBNce6l658xMqA=;
	b=Ma4ET2T7mBwaRk80jzAQDcYjkh4kRhoFoJpmIG8jWLtgmiH2NIAsv6GYNUsTfJ5ZSkrN
	 FGhMeoKkmmWchhNgHC40e/p+XZ33sJAed/dIIhONdHHMxkt7F2kEChWyJfu0B9GPwSf0w
	 D2K5BjAO5IREGbTI3iOw/2ie5calNTSB/rnL4UtaovRGMGnmwT0kw704fqXLLUme64Uu+
	 bLG+pRTmnWeFmu4mef4a4mtnS51FkMUrE8fkw8q8/Ttmy3ovfebWcsVZmyUDZNNh29DaL
	 O3aGNjRzqChg3FjurR1Nnthddng2MnW2rJ4C1QlXch+NxuY4a9tDQ0MxjCpola0ePRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Y0fameXp;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DED606A32A;
	Thu, 19 Nov 2026 13:47:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46DED606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Y0fameXp
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Z7jDqe7+LzAopxnu2HKkLbTVJ3N8yzBNce6l658xMqA=; b=Y0fameXp07tOMpY0/LGxXPQlJu
	TzGNnYGxJ/QNt3jMuloKJ4NxxnzE4jp8GjeU5yyymiiluhRHrIA8UL+sf2nocP5Wz5Rhn8EKmWyUT
	BC28GHCvvYFMLRkeZFlfruxG1mpEqogRqaNVEEFFPz9LLKrt7JnR9S+ec1GSgh4n/iOzF9v47So+W
	d6XOYiAN+WgHj6x9cZiq9mr1cKIOfQ8vyp3kG/Nui0gB+1D+U4XCYeq0YEBhU8rQc9W/CJP/FFd/B
	WDD4uVH4J4Tj0Dd9YGt5CwTsIcIDS72qTeNsA5gDJrNU7EoOlDrivOgKdsdTRbVzwGISc9iRccOWc
	+hjdrmfg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xU2Tb-00000000Ofd-1EP8;
	Thu, 19 Nov 2026 10:46:59 -0300
Message-ID: <8f92dc00f05e67e7fe0dc35a4263299c@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, Allen Pais <apais@microsoft.com>, Rachel Menge
 <rachelmenge@linux.microsoft.com>, Hardik Garg
 <hargar@linux.microsoft.com>, Adam Kim <adamkim@microsoft.com>, Siddharth
 Chintamaneni <sidchintamaneni@gmail.com>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] smb: client: fix unmount busy dentry/inode races
 on openFileList
In-Reply-To: <20261117001733.192399-1-sidchintamaneni@gmail.com>
References: <20261117001733.192399-1-sidchintamaneni@gmail.com>
Date: Thu, 19 Nov 2026 10:46:58 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Siddharth Chintamaneni <sidchintamaneni@gmail.com> writes:

> This series fixes two unmount races in cifs_kill_sb() where background
> paths walk tcon->openFileList while wait_var_event() is waiting on
> cifs_sb->outstanding_rreq and take new cifsFileInfo references that
> outlive the wait, causing busy dentry/inode warnings and panics in
> generic_shutdown_super():
>
> - Patch 1 counts queued oplock/lease breaks in cifs_sb->outstanding_rreq
>   from cifs_queue_oplock_break() until cifs_oplock_break() completes.
> - Patch 2 counts persistent handle reopens in cifs_sb->outstanding_rreq
>   in cifs_reopen_persistent_handles() until cifsFileInfo_put() drops the
>   handle reference.
> ...

Applied.
