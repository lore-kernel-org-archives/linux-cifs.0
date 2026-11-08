Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.150
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794151970;
	b=EirtPTkl2d8bEzFiDMjYbqZTdpCQ/XyXyVs4IG46zW4nPvhYGncmcsjVsQRHB5mmbjuo
	 QzmzPz6Rml7rDITxgV3JB46AN+LPUA2LtySl28fSdMbnSGufz1UFET/XVciwug2zXotC2
	 dnP9nHMfjOzZ9y+2lvDd8/QaF3jwSNE5+bD74JcV4bCkmEvDuOR7ZFWSUlIHoMC84pFON
	 AIYKVVGd+iULRadUF2EFMxtfmvtc1kXgfNCtEdIQYmy2VHBQk/pnOsp0kXxSCgUZ3QbVy
	 kMS/+QFDq9AC53I66wiMKNN+2GfGl7oyyjPHC+Ds1GMbF23lkZ+XJ9bxKl7x2rTavCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794151970;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=IWjf1AfjlvBEBqa2V97/k6eHgPBBCNVpKuDQDK/AS+w=;
	b=ntYBixTzOE2SfL1KrdR6uXqB/MH4Ggm+twZhi1h7CnMQnTewsSNzT2FdIrc5jFPecvas
	 +p+y72olgH0uX68BAP61RnRnovOEn9gZ3I+NuVT3cl2DY1Pv14Aegm+9gZqSl9rXntOKt
	 spqnuLcGs2uD5ad8lniQjruzprMJjuRB0fZh5YaQzGjA00MY1leEo6cw3p+1al5Csc40H
	 NEssr+pZJC/iXOjRAwrAHgFYaP33qRFJBdixfz49lemI0dR64ejdKjZmIoGcwCeIddmXQ
	 bCSmSSXJ3v2lARhBVcv9rUwfcYHAC4oi3a5QAbEhxN0ipMxVWsJURPMAIxeqeZiasaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=juanpmd9;
	dkim=temperror header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b="iLYsUZ5/";
	arc=none smtp.remote-ip=103.168.172.150
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA007606A321
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 15:32:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA007606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=juanpmd9;
	dkim=temperror header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=iLYsUZ5/
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id E0CC0EC010F
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 10:32:48 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Sun, 08 Nov 2026 10:32:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794151968; x=
	1794238368; bh=IWjf1AfjlvBEBqa2V97/k6eHgPBBCNVpKuDQDK/AS+w=; b=j
	uanpmd904A/PKtjay1twWmVYn+LjLq8Z4EpSCpz1713N/MubOSxFNULLHzq+zrIH
	iK5w94fEB617L2DlUXnOzP3wtUerPWuAcS37P8+LgfrzsMAWN9Wr/ed3WzaGlIk/
	3hU2BdQLxwh3+D6tam8W9wA361NMGBAm8FYX+wR3nbNbTnCzuGIjVoGasDCjVrO+
	FLA87ffRTCmR5AGP8IQRUmFt3dYZ+ysKEBF+OYVIoxIorQ1HprWpcHcTe0gJ3yu7
	hxJu/sGmUgAjQwkUocudX+pA9Oj/sBGcHAizL7o9/LrpJ6pt51UvhAE/FZkmG7xd
	p9gGFHYa+c2wVcUerhgdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794151968; x=1794238368; bh=I
	Wjf1AfjlvBEBqa2V97/k6eHgPBBCNVpKuDQDK/AS+w=; b=iLYsUZ5/PZtwKiFq6
	hw6CkbPXwmcvrYFGXZMMqgsE0WD2zDvYBFaXXFoYjmOgMn26Va1PDALqZbAJ7n7V
	FwgLDIO+e6OrniC0ozeaXSQfgfqojINQ9bijecbXuW6L/bnJ4iazKJrjrkthhf2z
	xSYy1v33HLo7DxQibeQklBBeBr50JLjtnq89sqGCHVuc+NLMjP+z+T+fc/eSmGc9
	G44bOAxhIwlJoUumytfuSve/Zni97weSgaTqXb5X6jBUEpAXAdxLICkRf9KEHr5/
	n5GI9pi10v2kAAfMQqlsMIPMlfyZ6R8Rw6ADYC9LSbSPC58oVOJ3j4Jo03uPyjyD
	HC6ew==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794151968; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:0erlCQTxcGeqoIf15XXBtXJCm8cpkkUxsRY2XNeVo5NqCo6
	jXd2gHj2o5khbynzorbfDW7L5uRW6PmrCjtf350cxlS9JNkxEHdExhT0ElObovPw
	eraYqTP6M9Ga2lOoZY5n+vSG5NOO5kFFZKY41HbzSnaXKEGcD2/L8Cjl1+7kMh2F
	Bg89Ir4W2OCxvuUBZQHuq6KO4k2aBwLzgItVKqh7YDN/EsLjiNT2UKiQ7MSG/BUW
	+A1KRcMiTH2Y+8qRLs7l/9SxWDfH39wXy6phqEmAbsjS2vaJn6ROvkBG6xZN+vfz
	9YPWBHhuiKad1hjWzHche4bX3/P+dAUv6aoZcpw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:RzI4OTwwEH3piNtUMQ7ntJzKRuMBmcmEVNm1nNW4LZI=:IWjf1AfjlvBEBqa2V97/k6eHgPBBCNVpKuDQDK/AS+w=;
X-ME-Sender: <xms:IJbwam2wBhsOibvXqMEZtRj-PtPuCayV0MKZflKMKB4uzXckK6FdCA>
    <xme:IJbwalEKj48axdrX4cKRkDjYncn5ArzxTlqX1CaStubIaxoqH2NlIAZBfCBUEJxIb
    NZff0U0ZCJzbmplAP2tWbGDSTL1LamWiHLa6xbK87krCpb8u_pMO6vl>
X-ME-Received: <xmr:IJbwahF7m-bVY0kPJEFw0ZhCTAQJ7KxFVVHh2MCNjxVwqSYjkF1ToD5-pdoAgFAq>
X-ME-Proxy-Cause: dmFkZTGXtPw9IbYjRI90tioqN+XYJaZFp9uHtO7kO+rf1dkgOSWkF+rSciOirlZyy3cUMZ
    esrl9uyueXiCArMs4gni4GuVdDbLwA17L7Poa1DD76yUiWBS1NKHC4LHtIabYvyakugriR
    NtOla0UhU8j7yvemQzzvBvHipnIXYuicfVueNBJ7PtyTX1TcNQTiaqDkU8Hwe2nKP3ONMR
    cNI06jjga9teXolAokOSQm0I9/6Cmb332AiOIqfJQ565CdiYhjc0ruQSpxbvd2Kojiu1qq
    rZkws9WF+1BfyAIqU29KyCx7Sx4PFcjTPl/CvXXWV+uX6jweCrjEzC9Tdp6eYtsM2yC3Nc
    39Bo0XiIr2AojjWVvq8Ct8H6OhFrvK1AdABT7nUChCx+gxlPF8aRhK8riqjk3IxKuZImFO
    Y566kfzThLwfZOgbux48Eg5SQZhxsQJZftvo3cSuxYVkbOYrH/0+QA6u3UnRMwvhMgryue
    CPdwkte4buyCOGKjlmc7/t9uBoeXBpcB7m+pUARCFwFFhBkKmYt73KcFZ5OhqyzES/jg25
    rB33Lc4m2j49ezJ1IXYqysnTybbvLJYstgcztOtP8pI9k4kVOKkdNYESU6dzRem1ZAfHtF
    9eF0I2rIixfVl7A3lYCMjuTbd7lyir7geAZaOiPPjNUvp2RhHsvko1sALRTg
X-ME-Proxy: <xmx:IJbwao6MJEUFfy0vMUJRKUAhFjzrKkdmmbRpF543a-z7b6dKnxP5iA>
    <xmx:IJbwamxB3YQ7R6k5aDqxcMrpqc6UV4g09FDh9xq3O0fpxGeucY7EBg>
    <xmx:IJbwanOYGGB1ASbQ1Ka6Y6pPGisE62ca23Wm-KnbxwdcP_1Y4ZS_kg>
    <xmx:IJbwaslq9MiXVYiuBxSz2uY30N3b4g5tZbZyYUCqhZRizGRcnFi3nA>
    <xmx:IJbwak8NyvbmMGLd1pJAxQgsCym_v0L_zZpGE2zAHZIuc1rQ4qudT9ty>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 8 Nov 2026 10:32:47 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [PATCH v2 1/2] ksmbd: evaluate the DACL in order for explicit access requests
Date: Sun,  8 Nov 2026 09:32:43 -0600
Message-ID: <20261108153243.1881152-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAKYAXd-jNcP61uk8wm2xq6dtuw4_Cf-r1WDdUHSBQLJzdkOF2w@mail.gmail.com>
References: <20261107231941.1824289-1-icb@fastmail.org> <20261107231941.1824289-2-icb@fastmail.org> <CAKYAXd-jNcP61uk8wm2xq6dtuw4_Cf-r1WDdUHSBQLJzdkOF2w@mail.gmail.com>
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

Hi Namjae,

You're right, thanks. I confirmed it for guest and anonymous sessions,
also with patch 2 applied.

I'll send a v3 that records whether the DACL has an Authenticated
Users ACE and skips the POSIX ACL fallback when one is present, also
for sessions that the ACE does not match. The ACE still grants nothing
to guest and anonymous sessions.

Thanks,
Ian
