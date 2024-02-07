Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233A6F9E0
	for <linux-cifs@vger.kernel.org>; Wed,  7 Feb 2024 03:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707277335; cv=none; b=a+Hr33PiG/R6Al6LipbNXCrYipbdWoWCfh8LeS3Le8y/jPjfQQOzJWnrMk8CdMz+7rZaTVepBok2HCxiicrC4r6CHLNdbEYiDSL9NIMXggqyPGyxpP41woI2i9/d0t1/zhKj/8A01d3IqQtygi9p1IrMtW2FkmHTouSZVih7zGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707277335; c=relaxed/simple;
	bh=9vNu/g1H4X56GBNfPaJ98ucJ6MfjcIHc58zxKvH7fjw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kXlp55Y48rDEBiz5iMvS0cMNRvpIh74W5rFp3ipVEaFzfZJIljvkFhqpF5dTChas3z3FB1+SfzigrwWsws0KYr9cmTKO6hbwGQ6RQBqMEi1n/WI7wESK/Otb/JOtP8nNHMvx5PyiIWmbwLN11rIVUEnNKsVtDUz+8SvoZPVf5XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=uZkUllQ9; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="uZkUllQ9"
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 53FBD3F15F
	for <linux-cifs@vger.kernel.org>; Wed,  7 Feb 2024 03:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1707277329;
	bh=83byukkMuZI8bBZSu2i3o2wpl1c7nxgPKD5JicOweKA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=uZkUllQ93iLqdOpISGirOaj+XMBbOnlx8JDyRPP9DYiL2kH2DFWJylyf2Emea80sg
	 eSd12cwE3F0HJE6xolbRtH8xEVrjO+YNVkhtvZgE1VgBbjwowHejidWxSdN823UwLQ
	 JiojsFskI8oJPAc5LdCpq6yG4AJ1sEHG05/oKSDL7siT8NKWqi/OtoAuDXJMuzr6Op
	 dvs0rtkzwtwuqOZ7gZfHE5kE7t0aCqO77XTGvfdlIUe0/fzQkpyU9PaBqX5JDXKr4x
	 Z9CHyWKDRDmBhs98GLN+pq5olS8hN8vicYYJFo8Jbh973YGQ6wIWBKziqCA0RAIf+8
	 q6DkSFZuIlsnA==
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3bfc3be1b8eso267457b6e.0
        for <linux-cifs@vger.kernel.org>; Tue, 06 Feb 2024 19:42:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707277328; x=1707882128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=83byukkMuZI8bBZSu2i3o2wpl1c7nxgPKD5JicOweKA=;
        b=snUHDpCu0/BxfuYDM2pfzK5zWmbwJNab5JjkMuBvBbcF3dZMxi5hxo6fyu9+NgzMMj
         5CjhQ71eWZ5qp3rD1auXWJKwX3l3PXWdxbU9IroQLH2HR7qgYkqLb8nC/NfWpsTnalmI
         2jnU1rHwYKroENZmIDCniobT7bwA7PhWJzcMg4QPVju6pypZRslLotwgxLw4UODKNL82
         QwFRnLZQDRFY1cTIvelHuS7Ms+OeLxQ2xzRlY0ZWU1nCrMdmPVhRhDd3F3ahLnatUFhs
         ZzC+Sh19TxWFnfhDBWWHEVNGwe8ye5I65NK5ESAqv34fBy0iFf9DKNE9lpLOIzkam9VL
         vbgA==
X-Gm-Message-State: AOJu0YySP3p3JzHneP+5LCsLoe2uSlRqz5dDbjp/79JEr5AqL81tgJTa
	X61sdE1Y/JlibYHQq9fDXcJcqqxeX7udUCDEtNm6HGj5OEPkjCQh8M95BJjXNmnPAJ/hlE4YRY3
	ca/tGcLfVsRmF3gc/ij+Z0BLf+Q3c7S5Fy1UwQTklVuE4QEXLtBJfBwA8I1sR9Ch7EjEOmifh9V
	Q=
X-Received: by 2002:a05:6808:3020:b0:3bf:e5be:316 with SMTP id ay32-20020a056808302000b003bfe5be0316mr3367284oib.25.1707277328300;
        Tue, 06 Feb 2024 19:42:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEl5tQ+tnd65K3ioqLqXcfx/YgUz5FwiOdyLjTSTTsLVTqJk7UGxc9TVw0uiDNsFlpb6VJFdg==
X-Received: by 2002:a05:6808:3020:b0:3bf:e5be:316 with SMTP id ay32-20020a056808302000b003bfe5be0316mr3367273oib.25.1707277328020;
        Tue, 06 Feb 2024 19:42:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUsoKNg5uY44VAQpw3Bq1Z6w0Fw1bBY3L3mqnPUkNy+DA8MUr3ZbkfqeUYfyBrsnL56PAr/Rcb1SGMB9fZn0ZXwoZHCpMFOb7abHFH1+k9z7Lz0PNv0/7UDDC9vR3dc
Received: from localhost.localdomain (222-154-76-179-fibre.sparkbb.co.nz. [222.154.76.179])
        by smtp.gmail.com with ESMTPSA id h19-20020a056a00171300b006e033804fa8sm297140pfc.101.2024.02.06.19.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 19:42:07 -0800 (PST)
From: Matthew Ruffell <matthew.ruffell@canonical.com>
To: smfrench@gmail.com
Cc: dhowells@redhat.com,
	linux-cifs@vger.kernel.org,
	rdiez-2006@rd10.de
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
Date: Wed,  7 Feb 2024 16:41:17 +1300
Message-Id: <20240207034117.20714-1-matthew.ruffell@canonical.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <CAH2r5mswELNv2Mo-aWNoq3fRUC7Rk0TjfY8kwdPc=JSEuZZObw@mail.gmail.com>
References: <CAH2r5mswELNv2Mo-aWNoq3fRUC7Rk0TjfY8kwdPc=JSEuZZObw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I have bisected the issue, and found the commit that introduces the problem:

commit d08089f649a0cfb2099c8551ac47eef0cc23fdf2
Author: David Howells <dhowells@redhat.com>
Date:   Mon Jan 24 21:13:24 2022 +0000
Subject: cifs: Change the I/O paths to use an iterator rather than a page list
Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d08089f649a0cfb2099c8551ac47eef0cc23fdf2

$ git describe --contains d08089f649a0cfb2099c8551ac47eef0cc23fdf2
v6.3-rc1~136^2~7

David, I also tried your cifs-netfs tree available here:

https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=cifs-netfs

This tree solves the issue. Specifically:

commit 34efb2a814f1882ddb4a518c2e8a54db119fd0d8
Author: David Howells <dhowells@redhat.com>
Date:   Fri Oct 6 18:29:59 2023 +0100
Subject: cifs: Cut over to using netfslib
Link: https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/commit/?h=cifs-netfs&id=34efb2a814f1882ddb4a518c2e8a54db119fd0d8

This netfslib work looks like quite a big refactor. Is there any plans to land this in 6.8? Or will this be 6.9 / later?

Do you have any suggestions on how to fix this with a smaller delta in 6.3 -> 6.8-rc3 that the stable kernels can use?

Thanks,
Matthew
