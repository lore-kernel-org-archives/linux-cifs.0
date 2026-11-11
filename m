Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794412840;
	b=YK+Ixcr7BW8IV3cGHasEnqKYiAVh51WUxSbCAcGYQrnGZRywRKESs1pKxRXIyuRkwXbo
	 2q9YJaCCi9SqCwNHXlW2ylGZ6kN6BGDuCRDpUfpYEhCO+KjKyS4PhTgMFj286w4FIQlJ+
	 GvLUv615wB/5Bzy9CKusR8KAV59sVQBPP78ZBYL24clSDnP/MmOZMZHDaZZNb4QU8IyKV
	 R/LtUm6xyFlXdjJpPcp6EuGebzQpWTKziReZ4SiYnU4sJU2udtZ5NSRq8Eb8FfNEFQLRG
	 RaYHARo2gXXRhPK7U1io/HTtuM5huKZaXJ5Qu3IbY3Sljjx1TZ5o9iqaotQQbS1YD3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794412840;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=AspvNDGkCkJ3NWLJZ31HBiF8pAd3ckj/t1KcoFiBMNQ=;
	b=PB9bkwfbopJEbbfjSt2yfnJZneFt3H9ve8TgZ9exoArAvhtfL5Xip8UOw1K2AHfv7LL8
	 6wouWjvlLRZ7/lVhIaDzvGq42xDordkTrbsEWQVNutzTlCqCcEDvUO1gK55zOFMUh2mDs
	 wbtyTDJ1lRgBY+abWGEZckCnzIZvdUh4Fp3S40YdSHjukxu8BHXdUlaPFGi4OgpcKICVj
	 v2oeF64uAD9zIvoBCEHEcQt60MFQnMBEPF2vXTni7a+XAJgMf9cHcX0cLAv3Y5DOgtBKm
	 31ux4iFd7a6bEi/KEB7mb5t+67kN8Ez8awh4H+9vGsg75rF6b14x16w/ul3Sb0XSm9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=afkDzEHG;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=q1qL97km;
	arc=none smtp.remote-ip=103.168.172.159
Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EAC606A326
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 16:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75EAC606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=afkDzEHG;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=q1qL97km
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 8609B1400181
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 11:00:38 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 11 Nov 2026 11:00:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794412838; x=
	1794499238; bh=AspvNDGkCkJ3NWLJZ31HBiF8pAd3ckj/t1KcoFiBMNQ=; b=a
	fkDzEHGaluomPGZP1G8gj9zjI3T0mdhkQwgzY4cNADJdtL8cSxyWlqkM/yFstZVA
	/8ZL/NUB9M3nR8i29zoqIs3cH5OT2rhQQFz2o+RsyaWD7ZVXx9CKDvK3MDgTac11
	dabYVnuBqmUXiCy6aNaLxTF934xPoIsBWzSv/hKu4zAUjw1UOxETjX/T+uUDjOFH
	hLMgg44nNonKyaEmvTgtQ3vZOGmPeoXvGnLT+FY0PR1nzlubTSVxlu6ft5SANRMu
	cJctJ0uPFOmauJvBaBlowgk4cC0PlO/UFeda8WuFf2l1G3Dxk1eaCdfh4I3KIodX
	KJYR4oYynyc+G79grV76w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794412838; x=1794499238; bh=A
	spvNDGkCkJ3NWLJZ31HBiF8pAd3ckj/t1KcoFiBMNQ=; b=q1qL97kmPYtBYgYYv
	5gajvuG6QwFLxISundZuWNkT0QVAoN51D79Xvl7QucJlkxuSaDCf2+IXL2JrmUth
	SuYJ/tUAfJ8cNMVA/w21Xji1JGcwYoUZvqb5bur/QkGwpkzxZ+2xoyF4Fok06SH4
	w2Q6BZcoIxq52B2zhAO0XTVKzbl8fZkzpXNnAty1rh/PUWWYIu6xedwD2+fzYhWK
	xXgzp+82qPXFGnxIYcnOFcQ8CrF46QpgREwdZ+8l0b0BJdbRaRy9l4DKfVXYLQER
	Zbyd7LcZvWxsbk9yv/KXLHrN+Js8By8TWHbevYbtimg5pCFILUtLZKh7sDr3tO2B
	HAGiQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794412838; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:EwbqS/DcG3NPIIR2KtLGoyOFEKUq60MKVNZ/zHtSgw6+d4b
	qlraKMUDNGO/TmkLYTX7z391TROuq5QI3LQ4xTCP1pxI6D/uIoTn1bshQLnYYNTY
	mUrLep2LDQZNuGMyxrWc3f15flbMMKr4BgVFX2EfGzFTa6f1548vKGaqanmZpxY5
	jwNEi4KNkTcaC+GTShi3CPLGuf2xU+cIAfhXIXtrG/M5AbzT+Deo6jGO6ENSWR4A
	YL9NcGccnH+Ph6jBXQ7Kv/ivOi8nr6EOY0Bp/5rFpITgZThslprGMqTAcjNfrQHJ
	ReIrSCBEbO4NclpSGAn79wToe6js/tkR7wCAj0w==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:/kRDEj1VEaC2NJgaYg5eQF710A1Pe0jHgn6B2QjUp8k=:Mdc/pp8kO3nuThRxpmSdvNYO3j128aXlX78VIoghsJQ=;
X-ME-Sender: <xms:JZH0athSBlCYFQZVmjPMoniji3lHgnS30OYzj9lHoL7X26vrA6LZ0w>
    <xme:JZH0aoDNQUmjxedoiLrI1bEjl_-LKxXjMyGNoUh14EAbR9otNL_rh6Am07Ptutu54
    WQQC9RGUpk7DEP6UIHeOPv2iH6Spt3G1g6gJ9_8xeHVIxNMRBNR9fbE>
X-ME-Received: <xmr:JZH0an7oZVW8vKsVC5vXFq4ZEEHkT3jCFl-QDeWv4MJytBwhoTGd7BPSQF8BAk4J>
X-ME-Proxy-Cause: dmFkZTGc6X1pUvRe543ASiFLgXt49mcvnM5Cjqw3BsQ6n9gfX39xWALbbqxtaONqPwhpdE
    VxOOkeWEEmhA8xFSk8iPWJqb0KILOP7BdvtxP9qS4fo1mQud/wWu3W9F5UuvLayBpvlSLy
    LKQ5l9jQTj0oj1NL5ie+DDajFzlVWkN4mYkWVI5PrbcB1vgg4vZOQOMh9W8ge6jRihj93k
    vmMSx2xlv17TpB2ZOwKZgxBV2VfbajR01HJj0W4bcNNAxi5iQMNc0G5xHqOutPsyHzZFsM
    Z0uNKJLwcAQpfQjKrvKiMKXH+HI7FGJBRAWcY1AQBQnVk3bLX/u9Q+X/5uu+SWO8zyQcMi
    OfIykN2e6s+Old8Ciu9i9dDQw0JkZeid+qrE8IOVA+BQCq579y+MJR+94rbYxuc9qt40zJ
    Wb6ucDzjlUiy9rIQTUgoOy8s2EMHraM+7RyZx9A0vvUlXzqGu3vmN+Amd05iMrPu7YKyuJ
    S3tH8ZVnVYVnRdQFoYz51ZDI+cvnExsmw3/WLKcgumT+we64PYydn1lC0GBWuU26BSobfZ
    jV091zYKOa6YQl6PER923EZIFQs1SLgK3IMbmr/TnhTDlqFqSWTvmho/IjpLkL9ZYalxkz
    sntT+UdsXaibJ1JrxWNKg+EWwUsJlYcVsTSx/Q6n9iKf4diQqogBDlB+OXjA
X-ME-Proxy: <xmx:JZH0alFC30XZ2d7GGkxXDD696K-feC66V3fHxeGqwOuH3hAK8e9t5Q>
    <xmx:JZH0aqDEyj9dK08pPyPrF0Fg5Y6bzDhEi444r_KA9Ae-ucJnjZrj5g>
    <xmx:JZH0aiz-9btSnleMKHrInDRGcNW84VDPMFzXfnyU4gufVP6GsdEffw>
    <xmx:JZH0am4E93nV6zap8iDdEm-73F4xAsl6xHjZNTS3no367A06uA_EFw>
    <xmx:JpH0anr6Us03r1TcNluJxQQr3xFSRE64yTFDYp2UH2i4Ljj6k19GWu7B>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 11:00:36 -0500 (EST)
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
Subject: Re: [RFC PATCH 1/6] ksmbd: don't ignore the owner and group of a descriptor without a DACL
Date: Wed, 11 Nov 2026 10:00:29 -0600
Message-ID: <20261111160029.4127378-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <86878858c5973b660bd04a65@groupi3>
References: <86878858c5973b660bd04a65@groupi3>
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

On Tue, Nov 10, 2026 at 09:02:27AM +0000, Jan Koester wrote:
> +	/* parse_sec_desc() rewrites type */
> +	dacl = le16_to_cpu(pntsd->type) & DACL_PRESENT;

Shouldn't the parts to change come from the SecurityInformation of the
request rather than from DACL_PRESENT? As far as I can see, the Linux
cifs client's chown can send OWNER_SECURITY_INFORMATION alone with a
descriptor that still carries the DACL. It does so when no ACE names
the old owner. Would this patch then parse that DACL again, rebuild the
POSIX ACL from it and replace the stored descriptor, though the client
only asked to change the owner? And in the reverse case, would a
request for the DACL alone still change the owner when the descriptor
carries one?

Thanks,
Ian
