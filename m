Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795191013;
	b=RLYm5vIdn6svNeKzpFMhG4L/uxb95seCtN82vpUJyUD3CZSTcCUOMfb5K2SDW/WTKNdI
	 Hr9Qx1eWybHvDVNeMF5V+aULjiIMmrkzrG9Y0GXQPM8SALWqEDwOQhWJ3Sl1+9ccz0FKo
	 x+Uf5daBkq61zSS/i9agvwtld7yzRK9LAhF5Q2jm1nDDU1adDY9kvZTLEvtppJ/OVKjD1
	 ntfFp84JTdUbSWGJOEQFKhSiZObC+ELGPAx1PjBU2n/7FxSmSh/ciKm4dAEwieGJH4iZP
	 6qGDQTL+DlGzhuKBUJNTD1v7VwVP53AJwWHZe9JZiOMEw6W/VeccN3vpPD54E1q0DBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795191013;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=r90S8I7ByqQ31Mb5MlfpoY+efCNR/G3wb9Kbrudb0P8=;
	b=iyC9wBiBlHYANvncNyU6TvP0i/HYOr4qFh4GDjgYYJp7R4oCD8MEo9tduzOhCwIXSXQr
	 Web7XEHOZyAnSWc41sE12zvN5mvoo9Yx8DbtY2xI2Pz3r8mgHPCQ31BmxcBEaYgo7hOUs
	 Y0BSUXPRKoPmjfQCOEMPywxDGeX0AWeUZPC4xcZqUDiRFBFjhaKM4KP6fFFijbVUm6tPk
	 OBdxFLMwXHRZ7LouFCcjHvXtuTSFH83eyayaIGiuKL8vZYEgWtWPMuV5A9BCK4e6v7tAy
	 3opo1N3L6shZ9S3Veq5a6U0bLqKiVnSSC9rHeu8B02q6dxWYsIWIwOKJbzJpF/zKqbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=Vp0vu7T2;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=ZSDQjvoF;
	arc=none smtp.remote-ip=202.12.124.145
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0B9606A336
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 16:10:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C0B9606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=Vp0vu7T2;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=ZSDQjvoF
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id E6B7D1D00538
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 11:10:11 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 20 Nov 2026 11:10:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1795191010; x=
	1795277410; bh=r90S8I7ByqQ31Mb5MlfpoY+efCNR/G3wb9Kbrudb0P8=; b=V
	p0vu7T2ItJpPC+i0uY9lxQTKtGyVk4zvEqDJWxgHMMrG0Dh6DNzA66E3LJ3gCrea
	SKx0D1MSSGcTNUy463Yav3sdL/BywDoGs/LISUci6ynu8BZNNktNImHnDFORMpOQ
	pcCU+RNnQcJ93Vyt6zzkymSBcKINYWMIV2uZavZx5ox2lEjoDatTWrfkUr5ScBfp
	bZ4FGZNndmc6ZzCKR3N3o44VpbbMrRJP8Um+ggO0GPw3smayqzoqeWxbramnA4+T
	+D1ipzYWfILfrEmbxpBGhwDzC3UQzhutkNY5m7ZHFsn4iZQIJsr+nUJcERVsBhKV
	bexzquFEqwebAyIMr4Vsg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1795191010; x=1795277410; bh=r
	90S8I7ByqQ31Mb5MlfpoY+efCNR/G3wb9Kbrudb0P8=; b=ZSDQjvoFzH3HEtoxY
	RJ3S6xqzM5gfZapcHL7e0AkisMzw/yWmitpZlDjc/LH/CGvpLExpLiqH1neu85cD
	tnswgWnoqywMDKldaescN0umNf2ZXdfihPmbethatxgtYmiodEBG7gZr1Zh+1bFt
	WT7VWH0DrSKWvASjmpZAuqUIC6sp3QGaWpe/976skVx/GAsEm+U6QtzIlIrF+vv3
	3J7DQBSdtKpoxubgd/i8OLOybnseJJ+/yfo5nUToGifL8xO17JyBaB2HsxQl5bjy
	Wa/PT5mDE/Y0opaPvarXkb11uzRszxsbEdH/Pd8sZKaby8dtY/EwHVSMc4xOpiNQ
	MTP3Q==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795191010; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:QNQ5ZfiYpTaBG6l6pOIC5VNYMTyjw53oWkYNr6KP0ZyoIOa
	kFqmiwUM9eSzJvXsOUJ5ZZ1thQHi9n6TEENc8e/ARgS75aZdBAO+31MwOSua1+2a
	J47I+gmBzbudWcYPSikLmsgPChtYGUqR4sZMSDoF1qz7t9SGXuIU9OdgXlp/FH67
	XarOyD5VcJvEM/LrnrXhRP2DwAz98Cq+LBT2sB7CBRIFI6FdLpfK2Da+ZaF+uG/p
	GErenz7azjUI7f+pVvMfG7ImAPiAqkwxKyVe+/3iwjkPN+BdfZ/YvFfzKj8IUYWk
	Aewd6e8/IBBHA3N1bHIBYW8tfajeeDSwrr/zokQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:C+aABKr6ZVNkSoEsxfz9/IGVyHOqZR4NRiGIOo82PkQ=:k4UgfqEb7kBwikSWiSlMSMhCklDg9momfAmhT+blq9E=;
X-ME-Sender: <xms:4nAAa9Hg5h794a29gc8MdNX013lcD6Co2ZDDxm2tcTB5IDUuWcb7ug>
    <xme:4nAAaxZ6XqPSHxSLg9z-B5LolEqiHmJ64l0HqHSwlawsS7DCcXKmUL0powkcwX_Ec
    Tl6B2VYlcIgoOAi3Ol5Q578hyo-q6yJLqwBUBeFD32OrraAO6HO_6ck>
X-ME-Received: <xmr:4nAAa1V9vqQOgqFqNlKLnNhlEIsHLS3U6gtMUIhEU1xNyXXQDQC5P6wWLP4_Ocip>
X-ME-Proxy-Cause: dmFkZTEJMSIK507JX1WlIoGmbblvDxILZ3aLfjrxHFJ+54dwSXe3vTUiwlIiRz4iAksGYk
    vog1AbDFu/gNPNX6xB9pr1vdfwceWzxcJ0kcyVfLghOTJVVNrLBFnEaHpqkad6X7W0hnIo
    JKxXx7MoGE8rTrCWrjf4P90bWw7tEzzIAmnnn63DuQ1/ccasVPmgXDTlq5O7/KKdTEXYAP
    hiKLh+eAlMB5PeyW0Dlri5SRD0I8IgKeE57tlZODBGAOzlR99PZZ7kmSGx1hZJndiLhlCD
    NPqgw/fdl2nR6h9RLyYwqRxr5BrUhEbgcYEPtKYDKE8Ke746JuiY1OdCTBAay0l3ixwWdN
    BJSOrY9s3X9YpXanbj9v74yDeRwefs/+DC0RFraz25wh0ngIzY+QRTWCKMM/d339iymdzt
    8m7jUj96VaeIUd+zMqkJyPxE/KRDsBvR75TehJBRvhK34lGo5zTfiUY6X2J4uMTSi3JZ6J
    pqWXxFkSzLlL8RheKiNCBRVLzywwoYf9RQo452Z3PP4dc0sOJQM1KJp8Om45Xi8E6JHdLx
    lYHETdrWzVTeQtlzRjtx6H5DHpqUAqqByKcGMv4QM59uyLVlbhKsZT0i2hgxB1sat2O0Qd
    aW7HnqJ9ipW9op9AaJIXEWh6b6E9iXrwVUjeNJLQ+8jA98h+XEplGUTalYAg
X-ME-Proxy: <xmx:4nAAa_nY-v7zlRMXxwyyLqgSBtBOEmfFZsHkUv5d0e5c-OHRBGtOLA>
    <xmx:4nAAa4CmiAt7Vepusv3o25N_8tXCWUkqIhgZmzS3ZFPy0VzZhZLGuw>
    <xmx:4nAAa2jifQ26WCI6JEXLJGMIxiHL6U4RdgnO3E76Om3Ay3ofvLiFuQ>
    <xmx:4nAAa9wmpkIy7rQNibS3Le8WIh1q2p-JytjGqgRcV1E_lpHgFLEwjg>
    <xmx:4nAAaxvf5cXvWGWpZDSom_X8kOy3xoX0f4mO8LiJ0cGtn6PCWKfrGL1o>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Nov 2026 11:10:09 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: dennylin0707@gmail.com
Cc: linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	hyc.lee@gmail.com,
	linux-cifs@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [PATCH] ksmbd: refuse to open an append-only file for writing without O_APPEND
Date: Fri, 20 Nov 2026 10:10:01 -0600
Message-ID: <20261120161001.4272-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120071553.28739-1-dennylin0707@gmail.com>
References: <20261120071553.28739-1-dennylin0707@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

> +	if (IS_APPEND(d_inode(dentry)) && !S_ISDIR(d_inode(dentry)->i_mode))
> +		*daccess &= ~(FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE);

On an append-only file without a stored NT DACL, a POSIX CREATE
request for MAXIMUM_ALLOWED | FILE_APPEND_DATA still opens the file
with O_APPEND. smb2_open() sets that flag from the original request,
but this hunk removes FILE_APPEND_DATA from the handle's granted
access. smb2_write() then refuses append writes with
STATUS_ACCESS_DENIED.

Without the patch, the same request can append with an append write
(offset U64_MAX), while writes at an explicit offset are refused.
With the patch, the open still succeeds, but every write on the
handle fails.

I think this is a niche case. I had to write a custom SMB client to
reproduce it, but it does represent a behavioral change introduced by
the patch.

Thanks,
Ian
