Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792644319;
	b=NI5aQSUVXlrVFeyN1hFIsc1tp4QJ+YlyMrcyoKicTecKoNku3mKVzOUmbYW70WphDC5X
	 k/p5tr8EtYYc0ch+IFNv1v/ZgOxLOcnPefq5epXMVEKMgXHZuTGBo2pYbw1ZvLDgb6RrE
	 LggiavRANmNlSWZuuOe59WMf9svGujP0qtz5G5IU66d5Gfo8zyi59V0qR0LXhdDrXmf1u
	 WqID02sHAfHsyvwCF8RXL9Ud1EdJlJIQ5S8atuyeZWbQ5zBDD9KjDt3ym8v957yqpTKtI
	 5zQuWXb5Mnzw2SrWsNY9szrNK+qNJhR20hohgJgp9mtdPtjHSrvMIC06kH+Q4i+R4lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792644319;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=fvU/xT1n6WUXL6CIEnv7Qj8NyfoBmX5QYCSZ7an/E+s=;
	b=YXERkYgQnMtUQR+2xys1/42RSDLz4EjhxU4CwbhHpUeqoUouA/k3nWCe2OSp+tP432G6
	 craou5TEQnRW+qRvcC0RyRg0mV5tZ62MkWrMnFjx3++b4/d1+6cMFWGLMSGoIbn3g70lA
	 bJXGp8nPVbMK7jjm+jzLeqZR8kfoOSlbNv+9LlGAkh/aflguobAnVX2DZG477JAHEUMtB
	 jIyc9U2BiLtyOq4gohPlbIaTcVQQ39Iq5VfePClkGXCBpLJMVMKtWjEhU4FWUF0ate8Bu
	 q+FkQ7xek4PFPAyhS/1r3IWmGMEoIeCndJHKSQgHJT1qjWYOPjcPk/SLwXuIVz+hUjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kroah.com;
	spf=pass smtp.mailfrom=kroah.com;
	dkim=pass header.d=kroah.com header.i=@kroah.com header.a=rsa-sha256 header.s=fm2 header.b=SxVjzwhr;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=y3N5ZDAb;
	arc=none smtp.remote-ip=202.12.124.149
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736AF606A320
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 04:45:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 736AF606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kroah.com header.i=@kroah.com header.a=rsa-sha256 header.s=fm2 header.b=SxVjzwhr;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=y3N5ZDAb
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id C66481D000C9
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 00:45:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 22 Oct 2026 00:45:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1792644317; x=1792730717; bh=fvU/xT1n6W
	UXL6CIEnv7Qj8NyfoBmX5QYCSZ7an/E+s=; b=SxVjzwhrQEkqYQj07Ux288k0K+
	p0UsAA55oN/2oyQJyebLB7wcr72tSxwlZ+E87oRgdbw6caeenuVu6mh0wi82HAUE
	FuyAAGPtXbNsLwRgryJNBCwjN2mmodzQtyy3pzFd/E6L7huNzR73WZ3wYPk4IY2X
	t2Wxh4L2hW0wZnk9x2WyRsQDV5uYeD5sNg4Lj9mJmacloZQ5IatbKozxxS1AJyG1
	ru8HolVUOqooathEzImUBWQa37VR9dq/p7fUVp9EYpcbVwyfRf5DHD233F7klyC2
	kM6pQTW6DQ97/8RZoLhKalNS0TXXb9BF8utQZpH+dRknpmhFoR5PklXBiqow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1792644317; x=1792730717; bh=fvU/xT1n6WUXL6CIEnv7Qj8NyfoBmX5QYCS
	Z7an/E+s=; b=y3N5ZDAbTLdu6C7m8hRxSRoeJzcxHXBvzti60C9CmApQuY7iAe3
	VG7RWBnInVjBiwynGTiGz2g+nXtge6kSJxWJzIBLYIKT444rZrpDjIQFSOpmaKWI
	X1vL1EC7opW1d2y4gd+3RmWftRgm0tM489IoJtodq8KipOIxxbGiNFY/sI9P6QA0
	lDY+OcAW69eM6At2JHxVrauuParMFyXKNQFcrokrKX3VWJAKSg7Ywwj3Y84hWgMy
	MyPPOTaBlcNyzDDfAsWOvwaHMJDRZhTd+hbWpjYM6hM4vMMY5gxfz7Z05F2xxV/6
	FGREboCi++S4T0ThxkQjq37GsNOwfQAcqMA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=kroah.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792644317; d=kroah.com;
	mf=PGdyZWdAa3JvYWguY29tPg==;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:OOBfX4M3BFVe91o0rOUVYtdnqBKKuRW1Iek5navSoAk5D+K
	NjaS/G1i//JzTmdrLtCOrQsXCo8J3CRibr86VCqkGUq2lDYYjOUXtiYdSV0qMsRU
	3FphZu2o2YRk4QcP+mtTBuGLXLOI8N86cUiv7OMtzwbn4rogj683Bao9a+8f+X/z
	8ax84b0+6CQ7pWvaFznO39VsOAvwJaBFB4p4utkYbPNAzLVBqI2wud2shj+Q+9AB
	2Suk+2YQ3zfkQ4QT0dyg3YXf6bVWJkzG8JG/vgEldpF1erPFLKqeZbVK3x8i3/NL
	LsW2CDLBH7Kg8KW/vx+SbZSzEVIdaoJZUqG7/pA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:PrCCbUBgXSh3I25FKffQ3ihpERrYJMoFRGN6kYr3OXE=:fvU/xT1n6WUXL6CIEnv7Qj8NyfoBmX5QYCSZ7an/E+s=;
X-ME-Sender: <xms:3JTZaqjJ1Sv405xCMqt7SrLGs4fBRWL0pKVUlp2BU6i3ApP1WCeKLQ>
    <xme:3JTZapgKmjP5eZRKdAQVRD8AO6ntNX52s8BkJ2wuMgPBfliSyySQ3NasUl9NFme7C
    DX0jmR0qvw_EtDHG8sbke9_rUDXZE_qD4QsJsNFpECuedr9rQ>
X-ME-Received: <xmr:3JTZao4uN2ifIrleo_wIQ1Bjd79X0DOPdiTvnSainKDl3MuWNVjAB7av2i0fYYkAm_grCexxkapPNCsnT0w>
X-ME-Proxy-Cause: dmFkZTF/ZA7ZzxZlNxSmdfEnbbBE6/8h27D6RdTMZ+FfctkdAlJCzdGPQ7F0jAioJ+DQjw
    WKNtDOWzQykOmLNynO22Xm430sJUEC2wb4yfnmV4WWYA+E/iWL2nian719md6W7ic5/WFe
    /DPpMoZAg2Dmw4yaKRuXnRd6kA/AHZhSLbAyK4ogjbsMQrsf9zjgpetk6To8iVV3XmB50t
    gRYE67UZW/qN17pfdF02WCV01i8p7O7ra0N/bfHsPi9fbZXcmkkg6WuPordqvpAPMJ6jI5
    AVAu6Pyk72BTHdq96zNM7S2ZoqggrEt+A8BnKWZXe6qyJkMt8lxlHQXrFS/nkj5rd88wof
    VHdismL7qXKuti4nc6Cmcn5Rbf7gkApRRa3Y1j98WWkVfbBzpc+gK5BYulP5UQwJdwkspN
    NsTpexew6zyUPmRzA/Tyt9OckUJ5iR/h/aEO1NmeKWLXyLbD81VWLeMzRf7JU9Ngx1Ht7O
    HGQfW1LmmIPYWV8id85GtuEoL0JVxoFkvVuY5BdaQA+F7/eNS18bilmRWQs50H9sT/6pqZ
    D+7Je3uQT1uW0TNOjMJGoQY3mZ3vsDUIki0DDq8OABv7pmbPFzZUpAgYvFF4q01FJYsvBC
    hNo7zwoggm+7y0vUjFCAgTuQeU6fh4yTowE4HeFPX+Nb1+OPYHXmDtMCB5CA
X-ME-Proxy: <xmx:3JTZajSyoNN9DMAawFjkSpIj22ylf4sbt0wk5exq3GYz-42RzzLqEQ>
    <xmx:3JTZav_VdasldQOJwEP-69wOljj-UqldKfsDghnF8PdxC8APeXEDfg>
    <xmx:3JTZasq1u4TvzNJSVCwiMxy5QFvnw_LIAzRpaw1BH_cFJQbUuaUgOQ>
    <xmx:3JTZatXoJMrH7iIy8QAHdVrpmhl-G9iXuTtacviLMtJoabFAfTwH9w>
    <xmx:3ZTZag2RpmlODjYLX4TTnwPRZDRB76ckRewzllCwqhEdiWYovvO5QgwU>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Oct 2026 00:45:16 -0400 (EDT)
Date: Thu, 22 Oct 2026 06:45:02 +0200
From: Greg KH <greg@kroah.com>
To: "zdi-disclosures@trendmicro.com" <zdi-disclosures@trendmicro.com>
Cc: "security@kernel.org" <security@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	"open list:KERNEL SMB3 SERVER (KSMBD" <linux-cifs@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: ZDI-CAN-33774: New Vulnerability Report
Message-ID: <2026102244-decade-icing-82ed@gregkh>
References: <BYAPR01MB383076AC412E19C48CFBEAE980662@BYAPR01MB3830.prod.exchangelabs.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR01MB383076AC412E19C48CFBEAE980662@BYAPR01MB3830.prod.exchangelabs.com>

On Wed, Oct 21, 2026 at 09:36:37PM +0000, zdi-disclosures@trendmicro.com wrote:
> ZDI-CAN-33774: Linux Kernel KSMBD Protocol Dispatch Race Condition Remote Code Execution Vulnerability

And again, no patch, and a public list?
