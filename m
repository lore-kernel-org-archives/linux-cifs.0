Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795709614;
	b=pciB2fLnJRaZRIA4419tKwLrXEtRNs+JKoQSnJTWC7ua1qkJZlLx5/J7i/ADzp5iPNhD
	 iLgkHYRmcifK3Flrj21j81axhvQN4u4Sm7yDh/MU4nQ5HbGPnY2hrW/WkKaZ+jXmoubVr
	 Fg7IU/zEJ67wp9qqDEVUh/giEqxSdCbvb3Fr794pfaecgEpf2ygMIvBPSh2e+42dCJ+wc
	 nJFWrhCtrUZ5U7+sfsVMw91QEDJy5zoLMG5twdWKDTaa7B2NtwRGVaKZHmMrfBxzh9Wh6
	 h/w9zU0M7HhFwZU4a+Yqv8+LInB7fI/ormZlF9OXqNZyDEWbFfns8ZlmFN22rzAkebA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795709614;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=byRRAONo97mtVvsHyxSpKRRCaUsqe+3CRcAKZm1FeE8=;
	b=WVDoXsOgDSO9+d0IVU1t+T4Y/n6Yd05c3zqTVqCfpwUjlUiAR7oR/ZDRt2WHsXRotg/3
	 ge2sQXEg3JvUQ4b12T62R7R0R5YRlLoNmvR0CZDC19aAEBRNxlBc+j7COSlpg0NTWFK6h
	 rexV1VSsZE5zroY+Gzq2YfW2ev6/aEScBjw4A2kOZFfxOBWxaC2/yChjx8ID80L8JDIfU
	 JLKxbVOnEq/Ux2cJPayryTgq5YcH5DPKKcJZc0hZ2+2WPC74AwbXN+F10YQwMPq4HqhUw
	 e2W2XrLW0Siw6LQPJrWtiA8SOcaudzGNbtoQPIOQZHr4JQpO6orusCTWijXvCZh2IBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YFOQR2BX;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5100F606A31C
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 16:13:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5100F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YFOQR2BX
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2f046b0adc0so41365915ad.1
        for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 08:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795709613; x=1796314413; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=byRRAONo97mtVvsHyxSpKRRCaUsqe+3CRcAKZm1FeE8=;
        b=YFOQR2BX2/mbb+EI5YDThUZslV0q0AUotMJQd80MdeC6bSDm3g2/svsmh5chOg9Bd1
         3/tKnYovamK7uSZcrW7KsVhW3EE9OtS7wr7N0RhJO3JCSw1CjxUN6MDB593Z8D66na0Y
         N9vck1Rx2K6qoyyJ/D70Fr/qiOy0os7Uw28XXoDOaqFHbQie3DM32y5Sv+p/IvQzIlIO
         JH9vn7ofM4TrXT2fwjYgjYxNvoZyU+uu+rLokKhG/35wqhvrZwcBe6yzQh05/5uCp8ek
         Z9AzSLWKMGihDfLxCmr/bU9jRH2ts9mchWuzeL0jnOjQi6eCb8clMs/IUsoKKSGujjQG
         +Xiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795709613; x=1796314413;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=byRRAONo97mtVvsHyxSpKRRCaUsqe+3CRcAKZm1FeE8=;
        b=cJJVi+uGa2xlg4oEwBtzduJHGpxtOJ0xtz1J0SM8jb19pQ3rIP3hAUqMEhMjByCwga
         wCha1bcXQMK4l4khG9N8gokclA+kS1fnoNA7QDiBZCOIxlOqQpGqkQeUKcDuNiKWnYym
         CVs+vbiYonVofAyNfBaetloTN7ecaTPT1tOriLL06VHKwNQioF9mnZ/zwFdwS/q712r8
         mln+syK+86wcCDwcbFk0V8DL7KO02FA0fDAsdZHZJ054FvkRi7Bc37g1bLp3i5lB+UkV
         iZo8SWpGxpKFyRgoYlGrGtv2rdm5tEbfd9B8BR661sjMSvcjCiywe7pCVTIbR4EyQG59
         KS6w==
X-Forwarded-Encrypted: i=1; AL+hErFJmWimohCS26LujfpAudwU0m4nEpZBlVOfie3n8KQLMhxSBbVYtyPARJybdQQSy2aBn4fYcTaiypXt@vger.kernel.org
X-Gm-Message-State: APuU4Z82Kietq3p/CzzCjaPYedW4ce5XEiOpJspAgzUYFBPzhfOGkI+N
	x0er83C7eH30idWr82kDTPJa4ctgWfHKvjXUMbGRHqFnl+7NU+j/Fxz2
X-Gm-Gg: AZFdTZeDouLntcfj6i+u58LsQlbk2S/Z0Z4lrtnrdXvtUHzJ1FIQmy5PzjIlesrPQAE
	p1Qt9ZQtGRdbNdTu5BUWWiLsbNwqqGgRBDLeuyqB5caQ8y86Um8s9e3dnXYdtFoE6jPHVIMh7Jw
	uklZPSwsJ5RGP7QQJibhSfWi9aTGXBDkqlWThRYITp3UnbTt8oE0/yFz8MOfwkK4YldTwPgM6gh
	zxO/hlGf0KATcnOAULdS/3fIQmB4X49+JpjiuD1s0ApGnIbOts5dtAdvZv5TFg/VFNKBrxUAcKd
	yjVaJrXrdC342DHd2iDlWNwuBtGvYo+fg0YQRjsy8KpfQ2cbQF676hu7fDEv5pBxWHhNXSHR0r1
	pWy1Nfh6nHuggB/6Oc8dBOl/31RPm90FCK7ZfVSoJmI6zfES5PV4XBxgHNUIdFv8ixX0GrajU7s
	RAZBafsAAoqGI+hMNCd7SmCmkhc04yfrTlGXASKw+6UZkocLN5/tA5WuLhV0TkRCWDUMG/umsnb
	EMF84eNz3b/fmw7ectEmNu7LR4HW+O2GkvJYFNlv6JeNaRzYTlCtiITHACTu7bL5CDRhuP0md+J
	hfF0WTtev5n5zj/Fm+6sG5cmrWGOiOn2AMiJAGEBCmdueT4za7KrOu84iafDndKlk/aukQtGa4F
	gcuLkbzkm4LY73w==
X-Received: by 2002:a17:903:2b0f:b0:2f0:3278:706 with SMTP id d9443c01a7336-2f03f181867mr193078845ad.54.1795709612952;
        Thu, 26 Nov 2026 08:13:32 -0800 (PST)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2001:df6:11c0:e720::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c1f42sm105524555ad.25.2026.11.26.08.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 08:13:32 -0800 (PST)
From: Qican Ma <goonsomeway@gmail.com>
To: pc@manguebit.org
Cc: linkinjeon@kernel.org, metze@samba.org, tom@talpey.com,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: protect server->smbd_conn with RCU and
 refcounting
Date: Fri, 27 Nov 2026 00:13:27 +0800
Message-ID: <179570960786.92818.11235763422476856997@gmail.com>
In-Reply-To: <6dccc6ca08e055f4c00df3596391d940@manguebit.org>
References: <179550686494.38773.3803244405772043954@gmail.com>
 <6dccc6ca08e055f4c00df3596391d940@manguebit.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi Paulo,

Thanks for taking a look. I have sent v3 addressing the sashiko
review: cifs_prepare_read/write() no longer take and drop
conn->refcount on every I/O subrequest. They now guard on
server->rdma and read max_frmr_depth under rcu_read_lock() only,
which is sufficient because smbd_destroy() waits for
synchronize_rcu() before releasing the socket and freeing the
connection. The refcounting is kept for the paths that actually use
the connection (smbd_send(), smbd_recv(), smbd_register_mr()).

Thanks,
Qican Ma
