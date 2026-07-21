Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ED33BBFAA
	for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 08:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784622782; cv=none; b=glF5oqSz9C4j332J/x5LmTUZOS4purlaP23m385TrLCqI9Klbe5aeEa4qEbPmCz4BvxIkyDL2ohEqU6OmgrB1Rg3uJw1Xk60ajWJ5+EW3KIwBf85WEqhNyylaswem8ZY8ZCadeKJDKodzhYbaRpSlav+F4aXTstE4F/besnUQz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784622782; c=relaxed/simple;
	bh=TtjBUHNNwSE9/fiRO8cLBF8C7GBUqhAoYMhryOUhpfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RAn84mTgTyKpynp78SC74k4hafgb5K/dkUHbvo2zXhbgMSwE2p4oy13dZyZygW76A7sC1M6U0uUBAjGHwhH+WjyTXmdg1s9WUMkfNL4ZuzANLUHSEnovpUsrZdHHuZ1D4nAFUOoyPezLqpBryGhXB+p2MdSm7CYsxSTGSqiunoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Cq7+yOmv; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Cq7+yOmv"
Message-ID: <4021e03f-6d80-4a26-9112-1dc20abeed12@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784622774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JWxhNcJB/mBof8h9MaExEEg0zRaJgKb0GDl06d6/LVE=;
	b=Cq7+yOmvBIq46301s4pWm/fECz5Yq6hTf/IbHe499jNYj8DuWHqIwsGS4TGsTut027hQI8
	Rr/GIZ23ESfDiStA8SRP1Wnrae+e1DldZUO4DABEk2JvSGy6YblBkcaQxxYpKR431fAaxG
	rk7/FEniGNfnxr0dj/zwYYAvHyJ+g8JojbS+34wiLD55Cb7jbCevloxldyW3b4Yb7zmHOv
	Nv/knOn+j8SYpx0vL1ZAuESbU83mJpqUN4KKcCzcnhV6IsuEH38wfHyOGb4KXij1jq7CFo
	FtoP7QdRJXxqBmk6XNehq+TdUJLrzO6J7IfGZ117KGgQcx/OWmmKBmxDJeMeLw==
Date: Tue, 21 Jul 2026 16:31:59 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 xfstests 0/3] add generic/795
To: Zorro Lang <zlang@kernel.org>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 metze@samba.org, linux-cifs@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260720163502.732454-1-chenxiaosong@chenxiaosong.com>
 <al8nX7MnPDzmUA5W@zlang-mailbox>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <al8nX7MnPDzmUA5W@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Zorro,

The stat command uses the statx() syscall rather than fstat(), so we 
have to use a C program to call fstat().

On 7/21/26 16:25, Zorro Lang wrote:
> I might not have explained clearly during the review. I wasn't asking you to
> rewrite g/002 and lstat64.c. I was suggesting checking whether src/fstat.c in
> your previous patch could be replaced by the stat command in xfs_io [1]. Check
> `man xfs_io` for the "stat" command to see if it can fulfill your test
> requirement.
> 
> Due to I noticed you need information like st_nlink from struct stat, so
> `xfs_io -c "stat -r" ...` should meet your requirements. Please
> give it a try, if it works, it will make the whole patch much cleaner.
> 
> P.S. For a new test case, please don't use a specific case number (like
> generic/795) in the subject or commit log, as it might get assigned a
> different number when merged. You can just use something like:
> "[PATCH] generic: new test to ..."

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

