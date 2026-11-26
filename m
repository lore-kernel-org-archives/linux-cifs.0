Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795706199;
	b=S/yBBBhtBUivO52AsHYzzvP5MdhhXiHQ5TUUEJRDum2nmIoXDrQ0Yt0EzAJrJEqYqdU6
	 eZwymGJ2QD2E90ZZmoak1Vogaz/gJGRrr4O34qcsO30jOFaj6r4eU/HLI3X9ybz/8Er6g
	 Acp9Ze8eBGlc/bmyVJON/FL3jEeXaUqgNvJ99FXK/HHCKFCZiJbP5oCZUYOwEODTXtFBJ
	 HO9hrjGcIFpWZD6vsYt13BbdkzgixWCcnWhpkryslYT5ktlxpDXrqxe2OsyGEKLBawZZb
	 bxrwksm+jQhWhyJPVwzBEooTrdDdzA3iusfc65nJ3YMVu1WSvmh7wanXayiigMQ9hZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795706199;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=sixOopG3N+aAmp8tcYT7iqcVjx0ABnponMW1gxlEYf8=;
	b=Zhj5u6933cKUsOC4ZbaA/Y5kxTZp3mD11L/T5hVOs9M4Mi5TsU8vxK5QfDZlwxvVU834
	 m8dHBrXoMXkX40eWE5ZWQ97VRtCa5y6UX/jBvgYUmVjh69oKlmskdYdn2Ug7f4Pj9FGfP
	 UGqWuRPcUD08fWeQ5V9ujDG5CNQHUCpA/WKQsRsndty85o5M0Po0nDzjGbi31120SJTI3
	 3HBGw8rOzyN0XH8oXvqciFc6iLnkZgHFRAyg4FJ6HZFKbNanVY0PlM0JVMdHdr6l/U4Xb
	 K8c7hIGtVh6XNbAfxJFXpALA6+ORjaPyluw757NK6nLMoIXslBSUEly881vsE9iaNog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=F5B9FH1G;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CD2606A32C;
	Thu, 26 Nov 2026 15:16:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8CD2606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=F5B9FH1G
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sixOopG3N+aAmp8tcYT7iqcVjx0ABnponMW1gxlEYf8=; b=F5B9FH1GFg3Zy4Y8kO0CCFXlsJ
	5D5tMVOHwA5D9RsHtqz4XKlDf07Crnz4M1NXi90mLr0xsaPqdswhdqUPWKdRRfG78AZ4dmNB51Yy2
	xECgi8K+6FVF5nVTmjha8KqDpNGc9OnA0YCIiFK26hNBeL/Gmoa1/H5kOGf8JsFbxQXFC4RZSnut3
	Mz+hHRPOcQhwwEPwdZvqbz/ixTVoBcN+TPo+kpfQEQhhWfYMx/3RAkIbdcz1vDi+ZdUs7Ig/bjDof
	VD3tKeDnxAQCJRLGHeAzXS/Bh/rmHnS9X4o5sPiyLX82wxBTLqYkgxnJLsE3SEekYgM9HeCdSSJvv
	sQwRRFfw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xWbDA-000000010dJ-1p48;
	Thu, 26 Nov 2026 12:16:36 -0300
Message-ID: <f9ebe90b823ae3e92bd0baab2d0e997e@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Abdifatah Suruur <suruurism@gmail.com>, Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, Abdifatah Suruur <suruurism@gmail.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: reject oversized SET_INFO data
In-Reply-To: <20261118122718.17236-1-suruurism@gmail.com>
References: <20261118122718.17236-1-suruurism@gmail.com>
Date: Thu, 26 Nov 2026 12:16:36 -0300
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

Abdifatah Suruur <suruurism@gmail.com> writes:

> SMB2_set_info_init() copies the variable-length set-info data into the
> SMB2 request object without checking that it fits.  The object is
> CIFSMaxBufSize + MAX_SMB2_HDR_SIZE bytes and the data starts at
> sizeof(struct smb2_set_info_req), leaving 16492 bytes with the default
> CIFSMaxBufSize.  A malicious server can return a nearly maximum-size
> security descriptor; id_mode_to_cifs_acl() retains its ACEs and adds up
> to five new ones, producing a rewritten ACL around 16.8 KB.  A chmod()
> or chown() on a cifsacl mount then makes the memcpy() write up to 336
> bytes past the cifs_request object, and the overrun is also read back
> and sent to the server.
>
> The worst case is much larger: if the server returns a security
> descriptor whose owner and group SIDs map to 15 subauths, the rewritten
> ACL keeps the original ACEs and replaces both SIDs.  With 817 ACEs the
> resulting SET_INFO data is 62256 bytes; KASAN reports a slab-out-of-bounds
> write of 45764 bytes past the 16588-byte cifs_request object on v7.4-rc2
> (where the earlier undersized-allocation issue is already fixed):
>
>   BUG: KASAN: slab-out-of-bounds in SMB2_set_info_init+0x47c/0x6d0 [cifs]
>   Write of size 62256 at addr ffff88800ee28060 by task python3/86
>   The buggy address is located 96 bytes inside of
>   allocated 16588-byte region
>
> Reject data that cannot fit before the copy.  This covers SMB2_set_acl(),
> SMB2_set_ea() and the other SMB2_SET_INFO callers.

Please check sashiko's review

        https://sashiko.dev/#/patchset/20261118122718.17236-1-suruurism%40gmail.com
