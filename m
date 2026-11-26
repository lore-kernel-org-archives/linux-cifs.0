Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795710808;
	b=cOfgQbNgP5V8SSTvjWZVb9NCrU4ctGphXxwemRlrdxk+zhLVXKI0RG4onPCDOntJ4WSC
	 KLY5mWLuO7J8lUUYrsc/oI6/LEQHARVnbQ/9l4BF5xyAHoli2UHXC/WmrZsqeC6MdfxXz
	 BNqsXnIQG0kBGOR6zd5yVm6/90ZD1C6OxJHvknXU9ZsH8+fz/+3HGKWg+lHZPbvNKNC1c
	 FTzkZTfuwG2HF8JhTO6tYo+5+LDiFquv2Qr/Lytz3VB7Qa3vK5eSLGjLQxV8t6BFdsh/C
	 uyFIqJ2uoIIdgLdizV1+U7W2Ghh5OxNFAxCO2aAGTxK0Ox3//Sz+g5N9eI+YdnczmMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795710808;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=dhIoKBHu+s9eGhpUl8MPT+BdJSBCQ8Fgjd1re9ERgvg=;
	b=WvosqBeCm9CETVLXkYCHTG1QfU/iY1k0qmYRe/4wSFxeFV4QjVNchUNWqov96TzTjhCJ
	 FtoKwfLb5Vbimsc5mrpV7Ntq7vashldiCPuqOqk7QKp/0FCWFzVsVsBK47yz6J8kl4NJp
	 TX9y9Yu/GzYpCHeJorIrDHIudBlwsf7OpCU2RqR9VEO3CXZWskwMraqLskObmeVJM9De8
	 lNBbz08aCVEQLqY0H978saXbLOAuRsf8RjMEyblsn9XmYtpnNCVAJA3C4CS21hEYS59sc
	 0cWOr36ZToYQZK4Wqii/KEl2kJLEjMshYx/PJelTXigFCMK0Ah1HBYYch7RB6aN+K6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=MJLv86FY;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0414606A32C
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 16:33:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0414606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=MJLv86FY
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dhIoKBHu+s9eGhpUl8MPT+BdJSBCQ8Fgjd1re9ERgvg=; b=MJLv86FYIjUT8bzGvPrfmidqLQ
	81gX0XuYvVV9HkAjdzK5fMP8XFYdi2z82GGlXDnCy3cE6IsPWtpiKE3dYHiogjP6DRgo2wZ4fokg3
	ibEoTduwH9wHtSEZbWecCgua2MSXwghLJWvrzG/cuWJsjODfCluCFQEqeU3J7cFyl7pqT/Ocr24hL
	MiX9Yp1r+1QNTCnzU7EF5BoGQAEgZalZIFxIlM4qblCTcAq8wy7FsA+3wewib+5NxQvlfekGb9cNk
	lCmZJLUElKtoOGtyXfVDzlrBPPHPSX1Gyxka889GbJ8m2laISF44voUop2Dox+hLkmrKxBXTptuQM
	kcIIyamg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xWcPQ-000000010vy-0u0D;
	Thu, 26 Nov 2026 13:33:20 -0300
Message-ID: <1d2f2b0e10aa7b79fae23f844fd6000d@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Qican Ma <goonsomeway@gmail.com>
Cc: linkinjeon@kernel.org, metze@samba.org, tom@talpey.com,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: protect server->smbd_conn with RCU and
 refcounting
In-Reply-To: <179570960786.92818.11235763422476856997@gmail.com>
References: <179550686494.38773.3803244405772043954@gmail.com>
 <6dccc6ca08e055f4c00df3596391d940@manguebit.org>
 <179570960786.92818.11235763422476856997@gmail.com>
Date: Thu, 26 Nov 2026 13:33:19 -0300
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

> Thanks for taking a look. I have sent v3 addressing the sashiko
> review: cifs_prepare_read/write() no longer take and drop
> conn->refcount on every I/O subrequest. They now guard on
> server->rdma and read max_frmr_depth under rcu_read_lock() only,
> which is sufficient because smbd_destroy() waits for
> synchronize_rcu() before releasing the socket and freeing the
> connection. The refcounting is kept for the paths that actually use
> the connection (smbd_send(), smbd_recv(), smbd_register_mr()).

Thanks!
