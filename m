Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795082461;
	b=vZH4c7dE4e4iKLZboL5YD3o8betOv7bVi4i+qCM+JHSYm+o+7BzH0C9O1Jp1+vP9m86s
	 VwzmHNlSE1Pvj9Q2bUmS5pw1F0kquurqOfF4liGEST8XDnxr/Q2ojV4Drcw7ZFALp/Vs8
	 3pO9/aLExx52PFgzaCwV4pIZQePUZo3d8M7yaMgJ6oXg9dd3ORZd8wSDwP2qUoMFqFzu9
	 Ays0X2xhxZuBrv23UvD+A6EKHCSmBw7sKkYZGDqZz5NOurHkpJA743hVWI5V94jWIcx6O
	 9gXVLEBO1uF9rbMu33m7E9enKqLX/CO4MewAgas3zz9QNncwQGPhHTmFqjnwx85ij0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795082461;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bQXf7a2tchZd0sm6ejvBeIAXUJshrV4kEWj9Zx7JZ6o=;
	b=q3+o9HlvzjN8eKNy4AAnJFDnbj2FZehfAvVg6toKRZcv0nZDeMkXCe2TE0L0XpM0/MYC
	 enan2uQ8xDIqQSI8z6+LgMby3XQl+rtj0w8RE/bE+G4TVXfAETWPPeFCWu9oLgIXA6VIX
	 f0lO9am9+uVyoiMpSdNgLjo6qef+OGw27RRPyvd3gEJ4ewrC22WtlAxG6ulBf0mTCVe0r
	 fRf3gsfvPizDAA/+JCpt24HQHX2Vp6VxURKwhH83HdeuBhHKJIFye0mgxPqz/8yeCyatl
	 dhnx80jKn0KTEVQW99BJ2dbrP2Unq7Uo/kNT5d9UsCEGbZKE9gEXRCUCTNyCYKC588w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qQtx8HcI;
	arc=none smtp.remote-ip=209.85.208.181
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3665060A2609
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 10:01:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3665060A2609
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qQtx8HcI
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-3ab46699a09so18556621fa.0
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 02:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795082459; x=1795687259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bQXf7a2tchZd0sm6ejvBeIAXUJshrV4kEWj9Zx7JZ6o=;
        b=qQtx8HcI9xOYAewqsC1qeKXYpNZYkorGxO+WUf8GNlozJTjTfjp6RYu0ME9dnQS7SU
         QlKY2a5rrUaalMRM2QkFx1q2fMNmh0+6Kx9oHBLriNElluMZgw2IJqtD+3DSP2pgxNzk
         2TmsS6xkE/qzDTWdZfTpZ+KAbD1lTDxAfFCzr6drsaxvmeBYV8fzzvm70Eui4lhqXTnh
         HgbHImFNfpvHwHXydOauwOfe17ING4Q6TVfyd4rcZEWzKr9mr4fzMJ+Vemn7/3JBMyOg
         1EBPQX8TZZCNUbaVOuHs0Ki+dm4jvN/9bSy06FQShgIIqQcy0wSxBtWSC2/KV4f07jNA
         MUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795082459; x=1795687259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bQXf7a2tchZd0sm6ejvBeIAXUJshrV4kEWj9Zx7JZ6o=;
        b=xoRnGAq4afwFi+CtHh69o1rZm3xeJztZKMsb+q3ipKB/p83V0KrIA1G35n7kP+0Guo
         RSIOnDC/SfwOgP6h9xikpeZo9/E6b8U+CDMJiUDR28jpFQ1imFvP7QB7W8c5zQKmIP1N
         i+oZg38GkRaPyX8kUI2fIXiNpgupCGMWv+nSAIZMkPm+aiY6vQ3hYqd83qxFk2NGuSwd
         SuLY6Gvm/nvA3m5jLj6PCncJo36dgR9hUlkGQb+gTGLnwfjIDdYU0byytX8XU7vgR3NT
         0mQr6w9cUqPrElMnFNMggYcYE2+SCcHzPvBiQA/AakGRsjdfPfn177PlB8FLqySbHW9z
         pa3A==
X-Forwarded-Encrypted: i=1; AL+hErErG8kiM4BY2sISbXkdCWKlsITZq6cXG9Wr3e5v4lkr9fSfM5Ym4GD2q8CjojmyRjfbXjIYLdzAL93/@vger.kernel.org
X-Gm-Message-State: APuU4Z+zD7D6jOYtEWw5bd6ghLXwN6sxlnf1w+4el2GbyJ9susBkAad8
	w4dg6WvvdZHKB4o3Y1ouhyxzWm6s+cHRsgW4fJyEP0vSMM8Wk5EYCLFe
X-Gm-Gg: AYBFou22Xnj1ZC1/m5/TZ1XQJijDjw3zsO3gf+RCCkjr4sOW+me0QEQgdie0oYHoxPa
	4raycqDCveSC4niKqbjqgpbcDKZ+A6tAVx82DPTkRMjIX1G0dQYkACThcoFOcB27nVLn48+VJ1j
	lWUJ36fTrWheVX642b+Uc/mQgVyEdCefoHEnO31ZX6zH5Uk1ksBhYfMs6eZfDCJTC/uKKrwTqSS
	rxe0WkAWrHkSWcGOPp3OiW5aSidAb7ZwPVoDI8Vw5DNfskVbh78KaKseDtW9nhcL2FDLv+/gI+U
	QnS390/BJketfl0JWLEqLbTNvqJ8svqhwudxJCk7IFbFbvBLRJfMNSZlWgLW0NQGbtABRLUzt2J
	mN8uAunYaQ7fkvXVqplxPmvCHWlgwWPUiyyeZzHB4rAibANvmhoISHpSQa916Q/fyA716nExewX
	vRA/c/KkAVUH+ZwMGr6bWJ8oBY9a/BZs5yOdGXMVChnomktfPR0yyR/+7jT4hfEuKCffl2p12kS
	hjZKuB8vknLlNyqBiASgWGfkbiYOmNf+UTaigLgVjoX6Uxm56wjJ6oo91IjTsAM+DYUPMEDFo/5
	JL4bipUEftMhEuBFx85HpwpmhO/6pp0TukbrWy+/lUosLHSJT5E+kRmqC6QNdNbNWBTmqhcc4O2
	DS5V5VbzEDOHHmmQuHvO3NFVQoq1fFHb2S+DWXsd9qm8oPhm4FcDJ7CfHEI0=
X-Received: by 2002:a05:651c:1987:b0:3ac:7ad6:2003 with SMTP id 38308e7fff4ca-3ae670dda79mr17356091fa.6.1795082459145;
        Thu, 19 Nov 2026 02:00:59 -0800 (PST)
Received: from Lauri-G-Pro-14-M4.intra.lakuz.com (n2vuxeervp7z67jbft6-1.v6.elisa-laajakaista.fi. [2001:99a:2ab:bb00:352b:8deb:4901:b3ca])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ae6ea7c798sm8419451fa.11.2026.11.19.02.00.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 02:00:57 -0800 (PST)
From: Lauri Gates <lauri.gates@gmail.com>
To: Dave Chinner <dgc@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <christian@brauner.io>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
Date: Thu, 19 Nov 2026 11:59:43 +0200
Message-ID: <20261119095943.85048-1-lauri.gates@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <av4Hn9u80fs8iHZ6@dread>
References: <av4Hn9u80fs8iHZ6@dread>
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

On Wed, Nov 18, 2026 at 10:16PM +0200, Dave Chinner wrote:
> I really don't care if it is exposed by statx or file_attr; checking
> the flag through either interface will be orders of magnitude faster
> than using FIEMAP to iterate extents on every file to find shared
> extents. My concern with statx is coherency - it runs completely
> unlocked and so can race with operations that add/remove the reflink
> flag...

Thanks, Dave and Christian. Given Christian's preference and the
coherency point, I'll write the RFC against file_attr, once the
question at the end is settled. xfs_fileattr_get() already reads the
flags under XFS_ILOCK_SHARED, so the new flag gets that without extra
work. The answer can still go stale right after the call, as with any
stat result: a clone that lands after the read is missed, just as one
that lands after FIEMAP returns is missed today.

As I suggested on the 6th, the flag would take the inverted meaning,
so that an unset flag stays the safe answer: say FS_XFLAG_NOSHARED
("no extents shared with another file"), read-only, in
FS_XFLAG_RDONLY_MASK next to the case-folding flags. XFS would set it
when XFS_DIFLAG2_REFLINK is clear, and ocfs2 when
OCFS2_HAS_REFCOUNT_FL is clear. btrfs keeps no per-inode record and
would leave it unset, as would nfs and cifs, so their files read as
"may share" and a du tool falls back to FIEMAP there, as it does
today.

overlayfs needs care: ovl_fileattr_get() reads the upper inode, which
for a metacopy file has no data extents. The overlayfs patch would
take the flag from the lower data inode, and leave it unset ("may
share") while that inode is not yet known (the lazy lookup on
data-only lower layers).

Christian, one question on the shape within file_attr: would you take
the inverted flag, or would you rather keep a plain "may share" flag
and add a mask to struct file_attr that says which xflags the
filesystem reports?
