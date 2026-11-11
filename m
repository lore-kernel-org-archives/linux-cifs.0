Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794412962;
	b=KXi3slsd53UQtpGVmt3BtpQ8XzHXmu8/RlFvJtAg0poW3CLDbMJHxocc2S7Cbivj47Ab
	 fN7Q83vtp2fOAgI7Vr7dEycD2UHL40VmhFincqXKBeNkG1vPKLknICsyMOfe4wSytCeHE
	 xXcc0spVj2ZYTPnKnf89ov4pi1nn5HkHaKFahfCNimvxxr3+ohr0NKaCObn9rJWskyInq
	 iIu3ZDQ1jNy/iBQRBYBJx59QpaF6ROi7Yq2aEmUaZwsFq/9oPxd+q3rVRBiI5+dlJX822
	 D5THzyH5Jakkcf9SQrTrpCpDSwF8ulynRNKthKd7JbA+hW+onJZbbJGwzy0zb1RdbgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794412962;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=VXlHvLrk5SjAjwoJFCfGABg6Gr4cfCjK8WyiPcugm80=;
	b=ydBWkN6L+1uomXDhpviaaOefGUKzhpJlVDBH5mmBjOuTpGvccGsn8f03uOz4KQPAvBoa
	 G2GGMm7hZ5L9Z6Orj/POKFUfs23IfQRs8Tu0sJwmfMLkaYR3v1UGG/3/wA59FCRogVOKs
	 p15NoFfaJgzgza6aMQ6d4o4LV4dgPvmNvFVm078yPVJhN3XFu8ytlpBQY2JRSrHywyHFD
	 wuicMB6Dme5YyN2ssRfbC1xM53ymepkj9kiLU1LWa80AqXtYIJVbkLMKb02vo0rGkO7D6
	 eaqLdiSnUrDPCT5EvaXv7TxsnDubwnE5h55lbQXA8T2KpB6QVsOZD/uvxd32m/8NqUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=DF2v05z2;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=vr3LyT+6;
	arc=none smtp.remote-ip=103.168.172.146
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F88F606A326
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 16:02:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F88F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=DF2v05z2;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=vr3LyT+6
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id DEC5DEC0602
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 11:02:40 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 11 Nov 2026 11:02:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794412960; x=
	1794499360; bh=VXlHvLrk5SjAjwoJFCfGABg6Gr4cfCjK8WyiPcugm80=; b=D
	F2v05z2ss63PAVhVoNDKpDTTY6UdOflVH7j1T1sblV637icN48ONY81f9Vu3VYzp
	oGBx4jb8AYhzjTqRgLlJLWkA8YExcvVeHGTOGXH4HA6PU/UGtJcu+eHSsJXMjhh1
	OG98uv9d8xaCDTrNJyLYGxe72wfSQ3s2cxBuUP9m/F19Eyx8wP9NODN17CxCFZmw
	ktlyTJ4JeET/X1C+WmNve3f1/ZyGea4DCg2ECtT57m73k9q0SVyNuXACGDefV1U7
	imi51BsslVgjoUp9FrL51Ihg3iNu8vz4//1rAXr29D98gyupoFws+LoiahkPCWMY
	OcxwpwccF9CvuBbeR+0pQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794412960; x=1794499360; bh=V
	XlHvLrk5SjAjwoJFCfGABg6Gr4cfCjK8WyiPcugm80=; b=vr3LyT+6JwGuJaLRs
	tdHa+/zz9niUMkuKLz8SNsyfn6eRMLiaeaqsTBUDl3xn+hcu07CTCOZqFaPBYynN
	k/eZnWneQx1OQOw1yHiDSCf91cEB/E+hYqif6UYpZRXGloOWxLb2Iwzh1Q/9bBRt
	CDLeYrpQNIAcQg4Vdff2ik/ObXFTPZwO9wotW0mTCu3lNVSa4GQNd+e2k7K34OQK
	n0m+lSY034ooheLoxBJTnQivHI1Skq1y7OIBB+AQX3+Qdpd4b1Z6YGa8g4tzCGjS
	PiC/erKyAN4LbEKmA0wIdmdY/K9yxW9dM+fINqv9O4QbR9ZSs8WYiDmIve3wvHXm
	E8bcA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794412960; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:UsbVl66EfmvNAawsc6M0R3g304ks5BkvNUxDuVjwouyx5MF
	2ZuWNXKbAVEAt3A6zkItmkQFKBsReWTWmIzQfzsCgpLrn5LhFW+GvFA+pVW3veem
	9CXQxyJJlO0jya2nqfV4htC4oqU93rUgdS0RtAehaWl4BnDq7vciWu23Mn8zfHaC
	1zp+ioBuSpbBV7lY9Q+BilZLm3yI/3vs364rESqUBo7H/dul4Vy597zWEHhQ4blh
	XCoQFsA4CkACGlzk7a3XOTEd8KaXwn8VOOsyRqlVVgmRts67LV7Qwg/3p0yt3PPI
	7aWAW0+8kLYAHxm1HJRGO33HI87emIS7mIiIYpA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:hsCQhag23nH4elGa8straBEAUZ8V7KBD8JuIDWgYnS8=:vKat5FSHjbFb/AwbssyQrD/nFh/JxoV5QqbU2B/L/8g=;
X-ME-Sender: <xms:oJH0at2lklOnIXTLPb4BC3GIg59eMEeHionjUEQLsOjwsd9ZH79DdA>
    <xme:oJH0aqGkM71NvlFWrkFH4E8ATCq8mG8pk7zpu6kLVA8ISJFaAGm0GAvZ_b2MDGdHP
    PFKpjHgUIVR92UZdHRbcIYBFsC80zzX0bfGSefFkFJ06JEf0T0gy5ru>
X-ME-Received: <xmr:oJH0aosnEus2aRuOsGyjCWpYsYebGMvaVCAyItgP3fO1OvnaQSnzP5oxQXs1gkEb>
X-ME-Proxy-Cause: dmFkZTGc6X1pUvRe543ASiFLgXt49mcvnM5Cjqw3BsQ6n9gfX39xWALbbqxtaONqPwhpdE
    VxOOkeWEEmhA8xFSk8iPWJqb0KILOP7BdvtxP9qS4fo1mQud/wWu3W9F5UuvLayBpvlSLy
    LKQ5l9jQTj0oj1NL5ie+DDajFzlVWkN4mYkWVI5PrbcB1vgg4vZOQOMh9W8ge6jRihj93k
    vmMSx2xlv17TpB2ZOwKZgxBV2VfbajR01HJj0W4bcNNAxi5iQMNc0G5xHqOutPsyHzZFsM
    Z0uNKJLwcAQpfQjKrvKiMKXH+HI7FGJBRAWcY1AQBQnVk3bLX/u9Q+X/5uu+SWO8zyQcoq
    z0qWGgkYzo7Q8bpbfwDEbRFZkcDgf4s8sBUzYUIpji0qpS72eVkkoh3NSYfc+TNUgi2Qb8
    qIte6dR7XvJ2PexBUI8TJg72tyYo9b82EOwxDPTYvGH9eXhFLjj4IEcNbWvhH6rqqNkvLy
    NFzzuPBnw/1No0tcFbT7Nun+jjpLM0lDVV4g7GMW2fF+EBEQCTemJsNSjMg/jPFuANimyP
    iZkCu1P2r9H6pw2kepCeyCF4hRoLZrL6R7JtBQwEns8suNJHRWIA+5eaYEjTKleaUyxe3P
    8v3qVhw4TeJpQgT1rKd5hB2QlT0QIx9JWbW/foL9fGUFPyqs1zVN3mXj7b4g
X-ME-Proxy: <xmx:oJH0atrI1yachLXybiQid8NGRaKTZ0PVM88jZn_Z1gQV3-saCsbbRQ>
    <xmx:oJH0avUixyZOTFlUJCOyQLc5Z2WMWltmAV8JmCLGsYRbxJFozXnjSA>
    <xmx:oJH0al2Ghn7-U_gFqHVzYyWV6Y2afYHjVdYF3LiCUmS-Yu-PTZ2MCg>
    <xmx:oJH0aksHCTfQysJscafK_IC2fJU90OPPrTf-cvhzWpr_JRQC4nmPZw>
    <xmx:oJH0aicYvgmDK0ykD4XycAalfNx_LZbt_SrA4uHxrkB2oicX9MS5Jg73>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 11:02:39 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: jan.koester@tuxist.de
Cc: linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	brauner@kernel.org,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [RFC PATCH 2/6] ksmbd: keep named ACL entries effective when a DACL sets a POSIX ACL
Date: Wed, 11 Nov 2026 10:02:35 -0600
Message-ID: <20261111160235.4127613-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <13deb997dee36bdc7f75e2ae@groupi3>
References: <13deb997dee36bdc7f75e2ae@groupi3>
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

Hi Jan,

On Tue, Nov 10, 2026 at 09:02:33AM +0000, Jan Koester wrote:
> +		fattr->cf_mode = (fattr->cf_mode & ~0070) |
> +				 (acl_state.mask.allow << 3);

set_info_sec() seems to only log a failed set_posix_acl() and carry
on, after ksmbd_vfs_remove_acl_xattrs() has removed the old ACL. With
this change, would the chmod that follows then set the group bits to
rwx on a file that has no ACL left, giving the owning group rwx in the
file system?

Could the mode be set first, with the owning group's permissions in
cf_mode rather than the mask? A successful set_posix_acl() would then
set the group bits from the mask entry. Should a failed
set_posix_acl() also be returned rather than only logged?

Thanks,
Ian
