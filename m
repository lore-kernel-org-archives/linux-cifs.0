Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792712373;
	b=ZMXofAxFkw8mugOICGJMIye1qVxNd8HzGDwLTIt65Sc9zVDRbME8scevlADzqa5dUlLB
	 n5nakrpBngEd2udA7sziEbEFhb6Mhv5U+gpwXlolgHFtdIYv9Cy9AdeFIxZHNtY83e6b7
	 TZ1i14CY5JT1v6CLtMOatSrGTSZvaw/HPGKfZvQrVjWriZzOaAhvBiXOUZbtlzhVwy2WI
	 DirM7ehVDlyF8p2GA+nvW1D23QgQS+JnM3B0vOHka1h2njCLroFk34My2fdPTEEIMFQqk
	 nmBDVrEtEmDI9DxZawyPkWrns3URz5tjlRj8dms0JwKRZRhoy3eyG0KoIyAG1tEhnSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792712373;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=nwUqiJzXQfzRThilJn+0Xsu1dCkAMl5eqYtV11vxTFE=;
	b=Fnbtpx+OF2vW4WqWv1oSyd2P9FWqXzjHViLOpejxTss2zdbSF/0Thu9ifuW3L3XSgxe6
	 4YwWmQe5x5Ky6vbkiCeRyBMErx5X7YYAuJQDSFRtxZWGBHAsHthBVRfUq9C/7gH1VYtqf
	 kVSuUplp4W0ccQ8huVKVru7peKjZiqhIZ3AgMtzd/D9JiVCYrxZDdekYFEIM4mRErC/+S
	 KC+J+BGuKIP67btP/Qt4c+ODWaC6w/p6B2vir0tQIZoqlCkJu5BCjVbqB3N8IJ1eRhGdH
	 FoA9XUH+kVrlet0wbf2NXGGcl8aEwC90sMvIeUmc4/CzifSZezuovlV/RsmAxHbLS9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Rc1803wy;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AD3606A319;
	Thu, 22 Oct 2026 23:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9AD3606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Rc1803wy
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nwUqiJzXQfzRThilJn+0Xsu1dCkAMl5eqYtV11vxTFE=; b=Rc1803wy6IcuR1dc42nP6Ytk9K
	iFcOAKzr0j/69qjlvy19zh3bXCR7/zhoRcwCIV6wr2kgrDATfdccbIC87f2OpN2AdygjWjnH+oDcO
	ToyG/s1ldbHSYFv2UMB1CkFBGsubzdTrsmzPebdmSvaT9irFOPknJS0CfqOni+bSUZhhu1xM2aj2w
	1A4k0S2zO00YOV4uvTXMwDPfht5upnJ7MA/IZ7RZzDftG0FY0GunAW8QgVwdlj2u4RGpL9bDrMHlL
	6LhoDmRe0NTMljKpmgNf+q6VC7K/tyt2epSX3X8m8inYs1shF3IfYf+Ekvrzaug/OjumZZR2DlI5I
	hdUfDwNA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xK2Ne-000000002m9-2qKl;
	Thu, 22 Oct 2026 20:39:30 -0300
Message-ID: <95d900581112fc82d188478be73cc83c@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Abdifatah Suruur <suruurism@gmail.com>, linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb: client: validate the data area in SMB2_read()
In-Reply-To: <20261022035329.17871-1-suruurism@gmail.com>
References: <20261022035329.17871-1-suruurism@gmail.com>
Date: Thu, 22 Oct 2026 20:39:30 -0300
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

> SMB2_read() copies le32_to_cpu(rsp->DataLength) bytes from
> (char *)rsp + rsp->DataOffset without checking that the range lies
> within the response actually received. A READ response with
> DataOffset == 0 makes smb2_get_data_area_len() zero the data length, so
> smb2_check_message() accepts a frame as short as the fixed response,
> while SMB2_read() still uses the server-supplied DataLength, capped only
> by CIFS_MAX_MSGSIZE and the caller's length.
>
> A malicious server can answer the synchronous read used by the
> mfsymlinks (or SFU) symlink parser with an 81-byte READ response
> carrying DataOffset 0 and DataLength 1067, making the client copy 1067
> bytes from a 448-byte receive object (KASAN slab-out-of-bounds; up to
> 16 KiB in the general case).
>
> Clamp a zero (or header-overlapping) DataOffset to read_rsp_size, as
> handle_read_data() does for the asynchronous path, and reject the
> response unless DataOffset + DataLength fits within rsp_iov.iov_len.
> The SMB1 helper was fixed the same way in 5be5bdda5863.
> ...

Applied.
