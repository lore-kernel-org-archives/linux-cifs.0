Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E9238E8DA
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 02:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784688594; cv=none; b=Bzv9XndLiyW76f+6qe4TlOsSb5RypJWq9DHpomfAlTq/RHGaJDLG9CwS1aArfdVcOW37hhIwxqc3r01jkgxLCFtHvmAvQbNn287F0+kSdm88VZDP/cenLjXfvh+3Elkx+wbg9UqzQczxY/nmV2iIBb0y1LV5xbUP+4cKe/xyFSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784688594; c=relaxed/simple;
	bh=SHY3opjHnuRagYcUhN9K9wCo4lS3QwJc5qVE5nkxbvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=A2L/xI4tJ/t4F1+5LoyC2wSE7ZPXQeBnkS3YxB1sSjtfTGM4XRuuOcQ4PfzbS/uTec/4aavCD8SreZwJgZNZsafBvY4BsuriTabeCxA2l6B5muip0yJgBTUB0fm7q2LUdd7fZ0P5WdUJqSNHNRW3+8sGlsMd1iVC39g8avuPg1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=tIhEe/sN; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="tIhEe/sN"
Message-ID: <7ac56d75-1033-4039-8485-afdd57e21731@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784688585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gXLYQgPKmrfBOY0YgOKwCzPt2DFoEy1eTW1xaR2k2TY=;
	b=tIhEe/sNfY6saDUHQ7H9H1vIQ/0LikQuKV8AQeZUwj1PZFblrx6EimqVSNgl00e95uBmTS
	O8Q5WqTEXhIjyomZVJ+5Bu2u0d88Jr0wqA8zbSMLmY0W9tEXgiYCa52+ySAPmasKz0hwfp
	KEkO6upTM2tpwOWh5KsRWBVHSaQYd5sOCu85s1uVnCGr6CF81BeGbneuU962SW5XF4XkBa
	JwTXxh7OwrLbhD5OICzsQJxx33cILhd81K11STDgN8BZhObRWnkCqYdFarrdot3B4Hh+sV
	5JWg4huzquhIrSGMdMgT2ghawXHk6q/OlVQKGLfIee/ze0H8qtoniCdYviBZ6A==
Date: Wed, 22 Jul 2026 10:50:00 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 xfstests 0/3] add generic/795
To: Zorro Lang <zlang@kernel.org>
References: <20260720163502.732454-1-chenxiaosong@chenxiaosong.com>
 <al8nX7MnPDzmUA5W@zlang-mailbox>
 <4021e03f-6d80-4a26-9112-1dc20abeed12@chenxiaosong.com>
 <al_e-tLidEugZyY2@zlang-mailbox>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org, fstests@vger.kernel.org
In-Reply-To: <al_e-tLidEugZyY2@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Yes, I checked the xfs_io source code, and it does indeed call the 
fstat() system call. Thanks for your suggestion! I will send the next 
version soon.

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/io/stat.c#n552
https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/io/stat.c#n166

在 2026/7/22 5:21, Zorro Lang 写道:
> Please note that I have been talking about xfs_io stat subcommand all along, rather
> than the coreutils' stat command. I suspect there might be a misunderstanding here.
> 
> xfstests inherently depends on xfsprogs, particularly the xfs_io command.
> I just checked this for you, the stat subcommand in xfs_io does indeed use
> the fstat system call [1][2], not statx, and its -r option will print out fields
> like st_nlink.
> 
> Please double-check this on your end, make sure it works for you.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

