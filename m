Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794953115;
	b=V9X37YNoOr6zjpvsrKCSqr+RRL7lJcVJhO6A6BlLeDYfy/a5+YEEMOWLWw62E2Zx/KJD
	 2OPhl4WbQYgvprL/r3GobiuN0TWMqwjBYGF8YrMfZEc85p4JrgrwXA2xZY3jTyszsaVos
	 cmp5thbTD+wLzmQuOvCp4/tc7xjzraHbOH64qf3U/5l/9kSHviNQ/KaQVhoub9mm60KaP
	 129GbF3ggyKWULB39Tu6LENSgDT0D5eTNUbDpBRp3tvNb6RHkys4ntiGejW1/NivKJut0
	 3HogxGaMLoXe0GFCH/57B7wM5R7eIa0vptmMXi/J2z1iDzRg3jk4L7vfKqQMbg1HnKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794953115;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=fBeEoMlsmvE/REb7qC02UXdbSPuGuFi96sIGhsuSRQU=;
	b=Joc3FYjbMVYezB27qTtdfUowbCPyUC6NQlGHV4tS+6ETfjTCzBWZ5PiPEe7l82epfW2y
	 vjOgvsePrkFZu9WQZ/0VgsPRPBWPjuZIFJmn9Och0Kc1Xj9AI98oJR7wB+7crj78vW5GF
	 EEURQ73wgz2BrJmrWksKi8dVX8Lp9Nd2G6/DxXfmd8hNLO7QaN+3fNKgsO7u9gIVBHFiA
	 aHt/hCXaUvNXccvC4o+czi4n0ACvCF8TsMR1qcZVbLHF6HKH3oDp3hgfEULnS05lF5Fwa
	 7NqTzOIWREambhC5pTxzYdgBGRfi81sQqhVBno1wtOpRLXeQLExtZZTk73wx3IO/O5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=v8T9vm0A;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD5A606A31C
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 22:05:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FD5A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=v8T9vm0A
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fBeEoMlsmvE/REb7qC02UXdbSPuGuFi96sIGhsuSRQU=; b=v8T9vm0Aimnl5EP1DrU9pR/E+4
	mFkO0ZTZ4GePNuxRkUqfAPTGmduojUGbUv96Rdy0fTPcE1LBCkQ2zaNny+Ohvyd9B2PEthOjZncG5
	GdZEogVlEs6cSbuwiloxeC3hOwI47nhX6Pqc0kKQHd1C57Vud0bnJu5KaH8K9nU7nnOGzRjYkorWD
	V0xb2zq7Sb0AkgtmnVyhex1eoz7MrShJCLDukRBCkzARHgTJaNuQTxt3pyO9Qm1aEcxrbacArA/9/
	ODTYOIPQI2jA8Em5tXxOTkCbavnyOK+CaA8EcQwtk/uLo0try3sRUW4k+Xhl8whGy4axafhQkqp7D
	h2O6Iu6A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xTRId-00000000E57-0lOR;
	Tue, 17 Nov 2026 19:05:11 -0300
Message-ID: <10b6ace14f8d6949d9ddc5195f2aa1f0@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linkinjeon@kernel.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, metze@samba.org,
 slow@samba.org
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH cifs-utils 0/3] smbinfo: add options to notify subcommand
In-Reply-To: <20261111022522.406718-1-chenxiaosong@chenxiaosong.com>
References: <20261111022522.406718-1-chenxiaosong@chenxiaosong.com>
Date: Tue, 17 Nov 2026 19:05:10 -0300
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

ChenXiaoSong <chenxiaosong@chenxiaosong.com> writes:

> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Add optional `watch_tree` and `completion_filter` arguments to make
> debugging easier.
> ...

Applied.
