Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793569473;
	b=Re8QlcCz8zj7OVH2PCcXproRUr12WOOHOjT/7YxB6gWqZStJc087r+SNCCi4/Q3k8G1+
	 IQWvNqNehzI/JMBsWLS9Eb6PlsFThKfVUUc7eNCUNT4XvaBjrLsuwbMQRtnkiz7a3IDyD
	 iDv6zSyTAz9nNpW1WnBnzOSKq329G+Ogfn4hu4wkpCupdSpdlw6noY0OrlLGqTUkTle4q
	 AYLnecuzQM3BcL/RgWRkQa+zx5LuJGakUP21XBpsuDLncr4OnogU8yP6eH16G8p4B/75B
	 B2U7Gog+oiMcBMro89/Ks1nzvU/y68Xkdy9g0CZpEkPKjcmdCu/k7JltFGqDLGLluTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793569473;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=1mMVj/Ylp3Zajqhxi8SVpg1+8G54F1N0w5aojxYs+sA=;
	b=KpW8/AVpnr1OFJASG0+fgTysSlDjKUTq1x5LyxK/h6B/wb1JG1HqczWrzEvQYBkAdVJH
	 tMCsZwL0d1pUSPQ6TPYTbYkxj1eccVyCh96w37dYUychldKW0r6C9uCmotvr0+3XosUwA
	 EzM/Fs3u1UW4WOvh8u9zf8GQ1mQDVYqeDVjkui1fgxqneodnheUq2VthK/xrZ0gC2q2Jc
	 wVZT0ZrFWzm5PxdS3KrUJZSaE/Xzjo/SJ2H4Rh7fOBnjDwjKBWJCP+Mt1LQIvr6z3vMZC
	 CRVWOxacIFRPPPfoGJ15bJQqiq7hAjXysQEg3leNvdKVhEtBrkcVJbd+peWFQHQr/Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=AE7ESmBE;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b="qs1HYt/q";
	arc=none smtp.remote-ip=202.12.124.144
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA3A606A324
	for <linux-cifs@vger.kernel.org>; Sun,  1 Nov 2026 21:44:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8EA3A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=AE7ESmBE;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=qs1HYt/q
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id D73E11D001CC
	for <linux-cifs@vger.kernel.org>; Sun,  1 Nov 2026 16:44:31 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Sun, 01 Nov 2026 16:44:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1793569471; x=
	1793655871; bh=1mMVj/Ylp3Zajqhxi8SVpg1+8G54F1N0w5aojxYs+sA=; b=A
	E7ESmBE6MDWnJYpCWrVoCtT02gtzn9NTvwMgTdQLAVXpaqkLfdprHvXCk+hWw3Rr
	kJseJgZJFHcb4LrtdJza5j83J0USbsdS2pJNE/LFkJvRmQaJhUmy0vrV1ACL+YhB
	vtuazn397TFJyNEUAX0urpWDOlkPLKrIAYURFRH9wtKLnXOn8fL1G3uwfbF45Z6i
	iktXULjLjUWTGAgoDpsGDtYWvz+pwCMo/sM4lXOmJOaLFWkdVOd+VrrXN4DPl6YN
	SzVvW9iHWqeFQ4zRbifW2R1wZ0jZgkI+vzLP29dYdJhN5a5ocE/B4wfUNr13h3ty
	UoKymClKGyy9DcWS9C6sw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1793569471; x=1793655871; bh=1
	mMVj/Ylp3Zajqhxi8SVpg1+8G54F1N0w5aojxYs+sA=; b=qs1HYt/qSsqGmuJxz
	swYVYH9gVaA7p3NTG/mQG6XEAmkaYpUQBfKlPKVU0cFF3DxXkN9Leb2YrZLWPmgP
	MGM8X32lhCzyXpGX95vZkLEwO5CQWe3UQBv/2mz0JMq0V43wDI1Sd8KXcL5U6IAb
	SnHA9Jewbv5ZvDPaNuh0xuz0nWyiMBNvXaRoAXQ1N3UwUB2bdaUcUi3C7bFwD0hJ
	1UljXX4y529kzVGIXp8LLJGJOWMuEkHQuXvhvFFTIeH07UZ5arutP3DCzsUy0wgV
	BHV/AblUTtDZyRz6tkIMmxdVF1p4g5W15gER9pTZH/WNC6/iCq0JDcHNHfEJPJun
	uTTuQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793569471; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:Aiq3nBLeSEPilQhcFACJYaOJrJXKtzznDSmLTgdwseukwUB
	7nqmxkNDkU5t0Fv6IzIZDj1qa6WySE/Om1xFW75gUSrlXHOYtYGyVLgbd82F/2tn
	eNAJve7THldLQzDZ68eF5E/wtlFu6BGrr+gBpt0awZCPWdRm8qD6yGMJtiCp0yHR
	XEKT4uES2n40ZuClQ9Kub+tXaXp8CNNyB5/2TWtcVk37Qh+cpfw/2wNrkbH0I2Uw
	Hm0WYZ1aq8TdKOK9JH1iitbUpubSBgepxD2zK4ZxKx9+QBJPXArPeOXy4aXtCu+g
	aScKLtwCsS8IWoqgVy2+eEwMfUN0xa7zGUgzM/w==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:s3D0c4wDMJC0cXlZMBmVc9tbHXMHJ9R/y4awmIrt6vw=:1mMVj/Ylp3Zajqhxi8SVpg1+8G54F1N0w5aojxYs+sA=;
X-ME-Sender: <xms:vrLnauYsv5Wmzj6LdN9_ERDEvm7soB60-BDiWfgT2REDEEi1jJJ3XA>
    <xme:vrLnaqsxskBrCJBV21CTkdiztgn3ZW-7nj-ya6uEw4alOEy7RxOPBW-BzieoVQBRe
    zhgxwtGoIjpivQGBuOdmGqeBNLEnbThKo4orET_jTlJnAaKul7rtQqt>
X-ME-Received: <xmr:vrLnagOXmB4hO6mCQmttswZ_JOqLa7iqV4m0YNlSxL6SNSRUR2Tg3STDfkoe0n8H>
X-ME-Proxy-Cause: dmFkZTF3NaYCNjGh8GDiquiV6BKvLn2bMNkt+4G+za2RoAktBLWK4JKctLjCjO6hCq7GZ3
    7rnwthsvRlCv9UYVVrRk2loGsJl/F6CzE3Y9g/blAALzQq7ks4iNzx1pAEH39xpCVQjwek
    Qdvo+MRPAD6cZ5hbNV2cUyyi7rLPkDTTUiY0Q8K3T/RShhsHjaiUw1eZL0+wfnzlh58JrI
    zi5S0J6vutAyLNbOY/gRvta14zWuOVd0MrR5Xq1Ftmz4VmdX5u7yXtdViF9qBunFVxYfQI
    dXx4BY3mmXk8NIHWwjfPkKgSADDBBEvOWzA2U7xHjITY8hzbTtHKrAj00CXwbo8WMj/2iN
    U0Yngt/+ZCSV+YnN2kFxMjmgg0EqXvU0snjVa3O/XapJlMJpmEjOn+G0XgVWULXMRkmRCW
    5ZCksZ0Uoyc69Ta+4AqkpulLhMP9UNsOpYnig+WtCdZ7kNio7xBOif3bHkQcjzxXZNjD2e
    8QGhV6Y9sh0eT+FnXUmmY4G9YgvQDSmH/63M4qoWyCZJFkzW8JWCz1xGW29GZb/sA5RATX
    J+YXciU+QW0cDBORN7B1wKWWnRfDs1uTV+G63thGA1pZLSMdgbRUF+jIXMgD34d1eXdwKb
    ytVlbF8dFX8wzr88oUFe118J9VEBQwjhKIn1FCdrJZk6mXZy4YU9WusG535w
X-ME-Proxy: <xmx:vrLnah4dmX5CsJhLJURZK3OgnP7s8UZrLj8H18o3F9lhDA2qjddv1w>
    <xmx:vrLnamTQCmGoyAr_D0NC2J__DmbJeqPzVNjQifnLQg4rXNNI0R268A>
    <xmx:vrLnauCW0tsnLxnCFDTCxC5dP2lIKzNAyulz76wciRMUce-vaqLsKw>
    <xmx:vrLnamFZ-w1lPa-ZDwXHP-cyDX0CWumwBdEw4oRfVagiXCmZ-Jy_uw>
    <xmx:v7Lnam11NSn8WAy7S3IHtTvHz5rMOobZ7zdNBWJQBZ4ah9bkrz9hiJoO>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 1 Nov 2026 16:44:29 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ksmbd: enforce the DACL permission check on delete-on-close opens
Date: Sun,  1 Nov 2026 15:44:20 -0600
Message-ID: <20261101214420.731352-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAKYAXd94Fe0awVpprg+41Xc+S+nr79g1jU75oeH4Trd2WWwSqg@mail.gmail.com>
References: <20261029140535.260498-1-icb@fastmail.org> <CAKYAXd94Fe0awVpprg+41Xc+S+nr79g1jU75oeH4Trd2WWwSqg@mail.gmail.com>
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

Please drop this patch.

I checked Sashiko's comments. It found two real problems in this patch.
While fixing them I found that checking delete-on-close opens with
smb_check_perm_dacl() makes some valid opens fail. Other issues need to
be fixed first.

I will send patches for those issues, then resend a fix for this bug
once those patches are merged.

Thanks,
Ian
