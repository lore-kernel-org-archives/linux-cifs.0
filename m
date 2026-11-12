Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.136
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794516977;
	b=gpzBUIA9Yba8BQLm7t5xt9Gcd0TovR7YXRYyjBmSXT1159h/pULl6F7xm49FnZWy96D3
	 Xg/k34Dep2bxc2UeGhUZjOAK2sJ7EzW344VnqkAdXT4pJwSXehB9GO4QDNRmWWHdZA7I0
	 DoZVXa//VVDKraLcvDKqK4S70b8as4lY+pMS5RIHHFG0XqvB1Li6aZA5GvrEq6oMjrs+Z
	 FEt+8t4TnocTRA9YGj+P+tprHxTvnXpvFZ+LNrunfAGyjq4JRLyGi+0k3oemoXhot6cUV
	 B6LX8uTfGZe1i892w4eVqFfxd3gYyNmDsUtlxBh8LRlLnT5VoMs9YFIWyDh665n5Ymg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794516977;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=iJ29OM5qVMg3SIcWH9IPi0t+ZcUFCBUMo/7eDRtwZfo=;
	b=HLovk6VkrX+64Fa9Tv45sO7+v0G7vq6Xs0zSahl7/4CkQzG6RjS5RPZhm5HeWCCVIhcN
	 CqyHqPFIpDF3D/JOEQ7xduR3Gtgkbr50hzqLkAzQmNSecdXZxdkUAQfo+8CiDx8qfSFWy
	 7T0FbD5gCRr+3bl/Sxu919qO7W0jms4+D5TicPSEn9IrlanLITW7hTmNmw3HMYHElhtyL
	 wyWnxfxvNwGBDMuDs9v5uxI2WcLvxLFsJDK3S48o4d53T/t/nfwLpSxapJkLPgeuNZsk/
	 mLdkGf/DvDS/7Yk5Ie3mNIo3J8JtR7GLN1wQqUkfD/RpLF+0oBTcJ0hLCc0hsJbfW/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b="CT/h2ZWp";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=SU4eEKOx;
	arc=none smtp.remote-ip=103.168.172.136
Received: from flow-a1-smtp.messagingengine.com (flow-a1-smtp.messagingengine.com [103.168.172.136])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17B0606A321
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 20:56:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E17B0606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=CT/h2ZWp;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=SU4eEKOx
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 221411382B76
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 15:56:16 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 12 Nov 2026 15:56:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794516976; x=
	1794524176; bh=iJ29OM5qVMg3SIcWH9IPi0t+ZcUFCBUMo/7eDRtwZfo=; b=C
	T/h2ZWpJIYE6PXEfqqKq0Kg6mviK4jJazhzQm1QY5Evl90/ARdgEKQda6OBIfTxr
	3GWC6zBu/Nrk/LgdZ7PXfdJgwmhCq4/YDhd10HvZwlF4vtzh6LLXLVPuPatwCxJQ
	eMCNwlNihZ7Zq9FAh0SqfwlBjZblDmfcFU160msw1co+TifzVjBHVe0QTM5DvYaK
	77M6m3jFHUSXb0Ee/vYvkUYv8jly/YfX0gfB+tksA6/ZCY9Rfke8SrCzqnx2KUrn
	KpqcIthFvITKv70o6LMJ8XoNzME/9iKkMZHKbVP1V4qTNYWjG/FVwq6yZI4OC9Fp
	eeKKec+sAH5FOtfXSm67g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794516976; x=1794524176; bh=i
	J29OM5qVMg3SIcWH9IPi0t+ZcUFCBUMo/7eDRtwZfo=; b=SU4eEKOxKPDohX3MX
	H/uijNhceZy8OcZ5M8y0ShgpA9ZF6klux46+GMQ0x1xxmFNrvZc1VA2rkhtXFM1m
	AZpBTfcjKCmlVAG1C960wDZOlsUNg+Wc9mTookBaURiimiVD3Y9bYi8LZ4XlmdnU
	iEk7pbZ4BQGUHsaMND8dmHLpz+jRxQPXweQUp9+Kqq0PYcVOL+n3Hzp/cyH111RD
	NrY4AuV+txDT+Rzk1Jqv1umH3kG+577rjecyYqEwgy3qHUJkyY3UV/A7Zq3RmPzu
	KlcsX56QUYZbt9Djc7tiQ5uk03411v72UT7NZ7kT6sA509k4pMvR078xK+GovRsr
	HQDow==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794516976; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:bTDuFj6lFmTs+S2tLfJKdeHyz9B5nruJ3UC9HNVwpgrxnyt
	2AubrEQPCQZ0awldx+9L5dpmEOQqOSfmPmDuJqEplaeb4mS4XcxIyEjBaYzxo2Wv
	wbwHCaYoWFufDeuIBSap0Ix18ubdKmmj+wktSIsv3tFw4Kd4iCZ/qUmXh+Evb9j9
	4rAYIOADY9Tf9MN4paMFvaO9VtuIwTuR09zN887runMEuXPwE+34C96CCkveOW5l
	ARXnUEOPfP5n+g3MR5hKSi2OGWuLS/64R1p68I33OJYjsl5f5YoCZFDTsw37bifA
	sA1p8Fc7aMPSlkc1tw9kgFwVXcKNzd1IIzaOzDg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:kGG/S0Sc/ZpvHR7ouMeB9R4zu/SY/DC6UJBVYolYAUE=:iJ29OM5qVMg3SIcWH9IPi0t+ZcUFCBUMo/7eDRtwZfo=;
X-ME-Sender: <xms:7yf2auiJs56D7bYLbLjTSqatrAyOGQOZMLV3DJog8n3R8P6jk2CRbg>
    <xme:7yf2avuV58CADJp3eBA7yzKQg0bK66s4iUbqAMovYhgDfISV6poXviaCBFSx6m8uU
    G04nTCT2o_gkK1CDi4z_X0mg-ztrIPPVvE7q0kaRLPr2WDmBAQm4TI>
X-ME-Received: <xmr:7yf2akQyc2hyPyP-V2t5waGh1iqkI-LrOwL0WkMR8j5ofTwZPlphls3un_M4csBX>
X-ME-Proxy-Cause: dmFkZTGMEpMZHbHnsDEa31aNnb7u0pgpRkeY++XjQxdxHdZueVzxOzMod3h8IIDBIcetLS
    QK6rcxHtu/7Flqsgg41/sVMG9EFT2RQ2dCJCsnVNlqOocUCmYy/hiFek2LdWOeudvsiw5p
    /NRTf2Elop6p0TIaWyvocZ9t3bH/SiTI41DkWeYd6Ca1qGDH2d6sqjN2d5lSvBxyn5nl+u
    yClBILGZf8rYi0sTdXkhoCu49pIboWFAZCGwAGMIA8NIfq/PdH8yBeDohsjBr3QZtVZsEO
    mz+SY9QnZojZoyv0aEc5W3+FC/nJC9ogWMH57YyvjBCykyM3atpqsFk42ZrFKZFp+QltGE
    dE/dCzhhDp6kmGZY0ha27K8D2ifAaWXd5yc5BE3CSrqX6GA50x3yBqtJFCcGHrfN0f7n1D
    sgTdNJPhjdC64/mkvJRNXYP1iQoQSji3PaO3F0CMT1Pxk9/wPQYtW+oC9fE3yEPkMa+zbF
    JQSboQu8fjYU63l/KlZJ/9prQx9uqQCNbAI74uTx6IzM5VagnOwsWsIKXZNFqA6+rg5P9N
    hI1gvEzY4JoijcmyihKvFpl7AwYd0LwuW30Ho/LhBAA86TPiI4Q74+G5rz3Ptmr7tXiml9
    u/6RBJftzw5kEgs805ObGqeoeRVrnK/J6+xAA959r7UjgFjcQoAsd0UxOkag
X-ME-Proxy: <xmx:7yf2ar3eMpnjyIgMqM0JFdEK1q7YmJ0H9cSAYQifoL6ottCHHHoPvA>
    <xmx:7yf2ahsA3Z78mOrVRe0AOCfMrkVeW2SYN7w4E2h3QAZzGXAk4oHMbg>
    <xmx:7yf2aphIfkNhoii5xAJlGc5AW90S-wQfDA65RbS92AiqnKXoF4kD1A>
    <xmx:7yf2aq82qoFxOjp3hGkLdR_TxPM77SaTdsotzM77UUDlscfY4SEg3Q>
    <xmx:8Cf2av062lzNh_jLueQmFnwTTHsGqghOsi0rUE_HX9f1YOps4Khz9zWv>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Nov 2026 15:56:15 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: mike.michalo@gmail.com
Cc: linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [PATCH] ksmbd: sign the last response of a compound that ends early
Date: Thu, 12 Nov 2026 14:55:51 -0600
Message-ID: <20261112205551.1668102-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112194744.47047-1-mike.michalo@gmail.com>
References: <20261112194744.47047-1-mike.michalo@gmail.com>
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

I tested this with the ksmbd code from ksmbd-for-next. I sent a signed
compound of two ECHOs whose second NextCommand covers only that
command, so the compound ends early. Before the patch, the first
response carried a signature that did not verify and the second was
not signed. With the patch, both responses are signed and verify. A
normal signed compound gives the same result as before, and the
connection keeps working in both cases. smbtorture gives the same
results as without the patch, and KASAN reports nothing.

Reviewed-by: Ian Bridges <icb@fastmail.org>
Tested-by: Ian Bridges <icb@fastmail.org>
