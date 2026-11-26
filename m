Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795706533;
	b=mSG2LuEwNiiqF2awlTPJc5DHi/tUBePZj9e0fUeI5I8ZPjG3VCTGUplIL03xvjFHYSmJ
	 Ju2wh7goDIIrmnsMcpOa+AgbCGTngsG5/KZyM0eukhEH5vx4ECVn+C4COcxgAGmbTm/fv
	 76poi1rNDCO/maPsiqdrcKlTnA3Pn4axE946IGzkce3eRXk3w3ga+2fIMYpKb5iLpEmaV
	 oJmG3Z1Gr7s/8t8zsIF6/qsEXFYGgs/OmZTkbJp6WJlriML5CzIrWTUY1IQT3HgZL/14x
	 cwc8xsX/DOwRvADK8X9fpCHS2sA+gmnqfI+6L89zZbvB4+DTC42hwMgaV1MpUm3LQ5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795706533;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=ncuZawS7SVY5pVLcDziAS6EDaFWu4Vhp8b82ELiJjoo=;
	b=kAHdYiNsfwUqeqR4MyIqMmyQ1WgZEPRU2mR2hOX/VgS8t0z6Vzm1KvKF9N+Ota4M9ayG
	 0FrqXB5MgPvOaksOHHmoGwPKXAo1RVSOSoScYwmP3wO3puZIX9yFf8X3UTv1ifpLqNmch
	 X/Fz5GvvxXWu6uP3EBXvYGkjhXAyibCA22GU+t62K1SHtFBgVKLMXEbVyRjGZDgA5eBBh
	 oJrHYzqe/N3ZriSJaUx5x9RNPQiO1rzWPWteHnLA/Xh883eanHpmlV0oXXAUzqvHdogWH
	 FRzEdjMbaXgyabqzEF2kmgXNTiwewiFS9GGuKrExfJczNbsU/EdZeVRmZAMwhmsv7jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=2PmJGLle;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285F5606A31C
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 15:22:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 285F5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=2PmJGLle
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ncuZawS7SVY5pVLcDziAS6EDaFWu4Vhp8b82ELiJjoo=; b=2PmJGLlewYEoSGIyKZJJwQyIDF
	AOSAgbzXK4vg2hI6pDjGsefMl1psT9O4ReU4iVuAuAn4dJ62H5zeAthKB/zroAPSXoEYXnFBJgV/1
	q+ulmwqWCIRlqnEgYvZdsGcWxEIbYcqrZTEGDrCJMnkrtz9xJo+F7sUj/K1U59sMbUdEc/IE073Ao
	nAsWmGKbmroon6WK9XjVdzCaZVQhJxFyJLgKSrj/H0rc/H1asgXSp5D/CUEsFbx9OXGw+gFTvQH4M
	abcupZxZg5L+MC1a+I5g5PHnEZIiSu+vSl3hBmL52DTxOUY/KSu5VlS9KsaE9j0ftPnWzd3S5FEEg
	PmfUOBjw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xWbIX-000000010et-0c50;
	Thu, 26 Nov 2026 12:22:09 -0300
Message-ID: <6dccc6ca08e055f4c00df3596391d940@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Qican Ma <goonsomeway@gmail.com>, linkinjeon@kernel.org
Cc: metze@samba.org, tom@talpey.com, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: protect server->smbd_conn with RCU and
 refcounting
In-Reply-To: <179550686494.38773.3803244405772043954@gmail.com>
References: <179550686494.38773.3803244405772043954@gmail.com>
Date: Thu, 26 Nov 2026 12:22:08 -0300
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

Qican Ma <goonsomeway@gmail.com> writes:

> Several paths check and dereference server->smbd_conn without holding a
> lock that serializes against smbd_destroy() during reconnect or teardown
> (including smb2_new_read_req(), smb2_async_writev(), smbd_send(),
> cifs_readv_from_socket(), cifs_prepare_read/write(),
> smb3_negotiate_r/wsize(), and smbd_debug_proc_show()). Meanwhile
> smbd_destroy() releases the underlying socket and calls kfree(info)
> before clearing server->smbd_conn = NULL, exposing a use-after-free
> window to concurrent readers.
>
> Annotate server->smbd_conn with __rcu and add a refcount and completion
> to struct smbd_connection. Readers acquire a short-lived reference via
> smbd_conn_get() under rcu_read_lock() and drop it with smbd_conn_put().
> In smbd_destroy(), clear server->smbd_conn first, shut down the socket to
> wake any blocked callers, wait for active references and an RCU grace
> period to complete, and then release the socket and free info in process
> context. Pass server directly to smbd_recv() and smbd_register_mr() so
> connection pinning stays encapsulated inside smbdirect.c.

Please check sashiko's review

        https://sashiko.dev/#/patchset/179550686494.38773.3803244405772043954%40gmail.com
