Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36A778F26
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 13:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783691292; cv=none; b=LCYQ2PWzapUErrt2T33PrOiuqEVR28y4aR6lsFDC8Yu4RccYGzF2PCBUDC9mCbmPsp0AbVYQo/9UD3F7sjyrAaJnQhI/qUBq9cZDZuliT5aaBFE7vRoVaig9TBFLb/T5bjYFO7MMHtNuNZiBSSqGv7T8laW626Jvu4BtHBD/Foo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783691292; c=relaxed/simple;
	bh=ds+WsdpEi7oZyHbjA8JLco4Gx8semttP+OHBdfchtuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idOjrjlEoUYjeUMmh61ac5eFeu9OsMpx7/bSYPE5r+Mg+rYG3PM+vSPtYEjcXPUA3Lbw9K+hTHUjtS1o2t1YD3Gdmdi9Zd6elxOP18+w6Ng4RsNYNoSOmirFRnr2joQlUSqJQ/Y3x1pBwexA9LlW5nR5cF/kQoJC2l/IPx468mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P7+6ZJhU; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P7+6ZJhU"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84861fc51f5so760285b3a.1
        for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 06:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783691290; x=1784296090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ds+WsdpEi7oZyHbjA8JLco4Gx8semttP+OHBdfchtuo=;
        b=P7+6ZJhUAyFl/eL93ysieNKvVAVUVo7ZIzXsuTTXNmjIVmIgvqzQyy9zAQlJMyBVKT
         U+Q1RrpQc2CcITCyDB5XwBUiFf6TYIqIzYsacAzhaDFwvJfo1m1QTGS4L6nchdXu0FWi
         3BR/sXwFiMnv06pVanQTZUiwu6FxXrS6YfVUTYXuu57EQB1M169NNQ5GgaIBCFJKThUe
         JmOj8P3PxUwJZ6gpuGmBHr3O1ZSB5+AGjzTi0leGWcOkeVtgVUCXwDPH3Z+gj64ehl7j
         LKUYDHkzdN02UjdL23DdXlvqsXpqsAKwR4Q53aEmilDWqkNS1yIpugi7BGO/UZ6YNvwY
         kKqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783691290; x=1784296090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ds+WsdpEi7oZyHbjA8JLco4Gx8semttP+OHBdfchtuo=;
        b=r8qKIQXN0Hza8BNpC6/DWRORoRHx0YgO9HFWd4MYqq1WF9eQWtZA1Yz7+r6mHY0gwD
         Q+iHcm8pMmHUVL1udZgAHxXPUXDOyWzshmbnomxQH95i/MFCrgaWECtd6oHtyjvOd1ZK
         TOZjw9N6/rAGLysa/ZffvxqsNxK15wGNr4nu7C6Z+0bSIpleVZPggzEP4An1fO/+hFHm
         nZJCFiG4ueKWvCnKYOxqbdQTPMyQ1rXPzYv7o180ytfaRSDe0sooQTOEqqgv/3JXlvJT
         Ab40kMrxHMAFH7B73Pk8maaiW2pa+Hn3nN4pQ8obDH896Zwrgx99UrW5K5HTJWZhjUQd
         +Uiw==
X-Forwarded-Encrypted: i=1; AHgh+RqJKUhT3kl2ToFY640JacXTu3qS2lBMQlrBOBUWRYNyOTOyv2EDHv0fmm0aJB/PvmmovgNgP6bJp3Yb@vger.kernel.org
X-Gm-Message-State: AOJu0YwETAQVEFqQFspekorC8+bBK3Ms5Zt8hFH5f6SEpcm0bASqOlqW
	lFZUW6lUeSlwg83yDhUh1z09IQMgJRuU1knFP1c49sonRKGhhy+QDFLF
X-Gm-Gg: AfdE7cnFW2Zio41AIQUJ34efz3t2AuS3JKK/tRKCwNxtpQfPGfdhqddleF9XZwGAjVZ
	EtXXtJNCLjGlXU1/4NdU9PNOG36Mn6NG5j1gniFwygvbJYytbiE3nOumZYswBaP//A8399Sut5R
	naW2IbNRTRVkdGV/rQju+Bx9g97uRnHfGcuNW4XEs/cu7XczNtcsX54fX1APftgxVk2cRm3mhSL
	ZfGOyfsSfDEvDS1MEbdovG5fb3CbVXh7KcEgQrNGWHG4OrbzB0gKzPpegk/ZZpLY2VBOki5osDL
	E7+rm3tqhH6F9UJ1D9rYUSglDNRhYcoVk2G/O5IrWgccCcitCM8khO/pfl8HmqStVIah6m8kqW0
	tMikhKMlEx9RrdpaCxkKByHVtlqyC9b/pyZWVz770H7Mq8Nsv+0ZLry567A4sD/W5OyYrD44aAU
	oBQhCBA9rb3gimayGClwpEpxSnUuZY/yBcdHP2RepbCtijo/BFYgX25n7TPSSiEQ==
X-Received: by 2002:a05:6a20:d708:b0:3bf:6c04:a813 with SMTP id adf61e73a8af0-3c0bd1595c4mr14595018637.52.1783691290090;
        Fri, 10 Jul 2026 06:48:10 -0700 (PDT)
Received: from localhost.localdomain ([2405:acc0:1306:5177:5cae:28a4:5419:ac62])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b659666e7sm48830449c88.7.2026.07.10.06.48.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 10 Jul 2026 06:48:09 -0700 (PDT)
From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Steve French <sfrench@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@samba.org>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] smb: common: fix undefined shifts in LZ77 flag encoding
Date: Fri, 10 Jul 2026 19:33:02 +0545
Message-ID: <20260710134802.43909-1-acharyalaxman8848@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260709173019.36808-1-acharyalaxman8848@gmail.com>
References: <20260709173019.36808-1-acharyalaxman8848@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Enzo,

Thanks for the clarification.

My concern was that the current tree does not appear to enforce that
constraint yet, so the code can still be built in 32-bit configurations
and hit the 32-bit shift case. If the preferred fix is to make the
64-bit/little-endian requirement explicit at build time, I'm happy to
defer to that direction.

Regards,
Laxman
