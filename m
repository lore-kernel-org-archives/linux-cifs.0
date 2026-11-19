Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114030;
	b=i94hVrUWVZC4+sKLHPVm6xb7JIe9chDsqHiJRk7t1YVVJrYPpEsy1pjQVCc7mC8scNaU
	 dgWHBZZDyu+dmOe3y/Ma/h9GpoIWKs45od/Kbav7sbOUyDRMbHQnWmM4cJS49Ydy5FKO6
	 jLAoYIi/JAXe8kUazmjYl+hanKgB1NKofwYu4sIEMqeGkz4DRVle0te/bCkPuBCQteulq
	 214YppNVxsN7AOA6dkBJD3xKEJv9Uzi6kzAu1dpKV/8gkK6TnVCrPyJsNOH/wPdZXyUO2
	 bvMN5bM3kEqcn84Ywj5TqQYE66axU+x4m9jWBAbll2pXRgRfazB5SNLgsiye1iway0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114030;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=0iOOqmnpv5nazarF3B/y5K1vk4kasW+Ge4e0ADchsTM=;
	b=HgyW1S6p7dVYq3Cy95wkqRziKgx/3Heu2KYGTQnikoufwFn3xQ6wZUbyioYRhNCc+GgO
	 uTzodbqJm0UdQdRx+YWrjY1fTcALVDm1oKA1qDDZy816xklGwGaTj8tsW8n9ef0/8I1X3
	 /2shovZZgWVVSEN+Xbg2774sTNGVcZ66x/iCKXrXtpGoAAy/jDgGVo2UARgAxnWHQb/U2
	 XE4w1AY9FMQrUmBz9+kAflk4dTDs/DLqlj1dVjwIh59sjfMxdeQILg/lVxb5CU6vsAL81
	 IxwaL7GEJVTlT9Xp+T3OhlB9Q/KP/uAL/7i65pHtfSncLBnS7Bj0SSDnZ3qdIaM7lLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Am6p3I7c;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4382606A320;
	Thu, 19 Nov 2026 18:47:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4382606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Am6p3I7c
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0iOOqmnpv5nazarF3B/y5K1vk4kasW+Ge4e0ADchsTM=; b=Am6p3I7caZWF/HaYIfjRqPOp8Z
	gXWMhFAWbAnzEA63YBEhSAxdebGCgJ77ZOluIsAhKHYV4QlxF8tghnlf8M5kFBnFs/2F0br6IfsBT
	XLuqj6eQbab93RceaH3jTYv8l6Iv7HJ6KfSOZNl2rhb1EkqhtRuw5Hq1UujO7rbRXx9ydvptzkj9o
	KRsWAdS+YJVlDH1+0kXBGkr4kkmdVy6VuiSLRd30GEMWioWbnFjSMNyt8GhoVk2xdScAwnd1g+lCN
	z/4Z6zEjNPasDjb5r9iQACnbctQgnhgs36j9o7mcbg7nzcjJyl3tvXteZle14YJxjhyKnjXLJ/Q9d
	eGsrLwDg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xU79z-00000000QAU-3i2I;
	Thu, 19 Nov 2026 15:47:03 -0300
Message-ID: <152a019923a02a65186a1c305810c299@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: shyckless@gmail.com, linkinjeon@kernel.org
Cc: bharathsm@microsoft.com, samba-technical@lists.samba.org,
 dhowells@redhat.com, smfrench@gmail.com, ematsumiya@suse.de,
 sprasad@microsoft.com, linux-kernel@vger.kernel.org,
 linux-cifs@vger.kernel.org, tom@talpey.com, ronniesahlberg@gmail.com
Subject: Re: [PATCH v3] smb: client: don't use read data that failed
 signature verification
In-Reply-To: <20261119-smb2-readv-v3-1-f3a8a2eddb1c@gmail.com>
References: <20261119-smb2-readv-v3-1-f3a8a2eddb1c@gmail.com>
Date: Thu, 19 Nov 2026 15:47:03 -0300
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

Suyuan Wang via B4 Relay <devnull+shyckless.gmail.com@kernel.org>
writes:

> From: Suyuan Wang <stevewong@hust.edu.cn>
>
> When smb2_readv_callback() finds a bad signature, it sets the error in
> rdata->result but leaves rdata->got_bytes alone. Further down, a short
> read that reaches the remote EOF clears the error again:
>
>     size_t trans = rdata->subreq.transferred + rdata->got_bytes;
>     if (trans < rdata->subreq.len &&
>         rdata->subreq.start + trans >= netfs_read_remote_i_size(inode)) {
>             rdata->result = 0;
>
> and got_bytes is then added to subreq.transferred. So the last part of a
> file, or all of a small one, is returned even though its signature is
> wrong.
>
> Clearing got_bytes is not enough on its own. If the read starts at or
> past the cached remote size, for example because the file has grown on
> the server since the size was last fetched, the check above still
> matches and the error turns into EOF, or into a zero-filled tail when
> NETFS_SREQ_CLEAR_TAIL is set.
>
> Clear got_bytes when the signature check fails, as the retry path in the
> same function already does, and only treat a short read as hitting the
> remote EOF when the read itself succeeded. That is what commit
> 1da29f2c39b6 ("netfs, cifs: Fix handling of short DIO read") describes:
> "clear the error if a short read occurred without error and the read-to
> file position is now at the remote inode size".
> ...

Applied with the redudant 'rdata->result = 0' removed.
