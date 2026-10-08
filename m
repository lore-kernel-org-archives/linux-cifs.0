Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973494DE72C
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 15:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791473161; cv=none; b=TtwWTalbLT27wqgNYgHWGquwzrtbo9nBqghXkffdZvPQwLF7aHcpvZ0e8p6zIrlyyGwISKKWYDdDtZx09YSDIxSLQ9P+9izsM28/krvXfiyuY6nsrr1WEnRBGk0xVrfEAukV5eUdOm8hrmyGzue0H06Jy+evRMYJZyaayDQh7tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791473161; c=relaxed/simple;
	bh=akIA9HKvdnqYj1abtddudSu/lZvV7C2DIR6qkupg0bU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NdcoUYGmxND+KunVy0QQLx0jYsw0IEUUF0qz2E/CjwKE1FNhwY+ReZvuG9fiafMET9X2c5AnabxIaHESYfaSSS5BXatOTjgIkDpDWK7KQjROdZ3ODE0YK0yBHCjnIasXzZzqVlYfjHYOqGz/fr7AONmfxhnZE0ujMi6TO3YL+ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oYO+BefJ; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oYO+BefJ"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cd15c885bdaso64209a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 08 Oct 2026 08:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791473150; x=1792077950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ou7YAs9auQtCgureArfNimBtTqCetiWpq07A3Q9+Ygc=;
        b=oYO+BefJbmkUxkN65wLvSl6bSuLmWsDAz7rOpkm4otIRDeveK1YWm2eMme7pkaVpMq
         YD6JF+EGx3SP5ymmP6QLew3PpC4d9OT7VdWznqOm7J354lferDkzlKoNh3KIA3RJvlpW
         EC0J8IQ/36sbkx9D3wpm5MQrTnZJRs3MDDEDb4R+vogJnT2PZikcZ9kWBy5J5awUnNWP
         00MwVw2xFIwhdwORe4iMdphjoQcN44ZAHNsacfNawIdRg3ZVtL1W2mAB41XFZge8Vumw
         mHeYWvXRBDCdfdRnvNbBnRGdmV8tQ54yYwQWPnHZ6Gt25Y56S++AJTLJbekmFozJ9Ooh
         JG8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791473150; x=1792077950;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ou7YAs9auQtCgureArfNimBtTqCetiWpq07A3Q9+Ygc=;
        b=LueoQqZB4jaw8C8AwBEtlYX900Us0xFfOLlaM7MDvRRiDdKMwFHkgiEX2s5dfNxKKz
         vhl3gjlGC1UjA8P4kka5gnLSjTAFfZWG5EJsDrsZmJpbMySnrgHBPWurnbYq/LGX6JUO
         uxUxnP4D5BqCPBl7yDsaZ8Opc+NyJE9NSD78yAISARlc46Yc6grJZiDqdun23VC+20i3
         TAFGYG0V9GbW8fMfQ4tjt7R8aSTWLwtiD8j4lyYwwLOaa8YyG2GYtjt9+x7sgsez5WgE
         XMTq8L89WhImkc1UPtQQRe3YwKJQXWaamNWoUS+7ryVPqXSJZ1R8fdsjRTXG+7lEdDsV
         AsPA==
X-Forwarded-Encrypted: i=1; AKwUvBxSKlibTRsno4LyO9C6SsgMSPrH+70Bhs5qATuo2OdBzJSU//a0aSgGQ7zA9Q3zZA2sJeXJidKUirYR@vger.kernel.org
X-Gm-Message-State: AFq9FYIJTY7vtwI61SJo6GrekejudvgrbrKkfqyOv7qV1Sz5LR23m99C
	jRam+UazFXW71Z0fzKRK/++vp4B+BniXUXidLBysqtTYIG/v8vYGZXa3
X-Gm-Gg: AYBFou0YrP8U4b6WNExtF42w3B4SZQ0Av/BqUO905oTftJskI+4Pbueu3gDfiZ413/J
	G3+VtY05AE+Pc27y50rbLNhD/DgLsN60oZjWdF4d2Bx2eq75PYqi/bpytU/+X2wIUMZTNnlhVmn
	t/upj6bK4zzOvRF5KiAkyfNnwPWitBjzUC581/D1tpFNqe4efBtO7WKkj5DkIgh7Vp0bNiulhl8
	7xjDooE6vQ4gU8LjkpudlfLe4R5jSZ7Rt0VFYxSFuEltUWAmqr86GoVNl4z3rJOw67YVJshhNZ7
	PoBzkaeDubGuU09CffoFeXz6Zff06muBg2y6czZ0gBCphHom2yU0s+wRCMapsZn7wog1fjfAwsi
	Pr6ByiA2IGjAU5i5baPCQFn+8pnhdvRodTiff1PEEg+5fecf8WTlRiHsAXXPcaYs57mFcYY6UIn
	LM1FrHJb5eB5K9n/xIsPT2r7nLkyziDgjfXhSM3vjQwk0X7I9KFzptQbEuNYFRceg=
X-Received: by 2002:a17:90b:588f:b0:3a7:a463:54bb with SMTP id 98e67ed59e1d1-3aa9a386cb9mr4276553a91.5.1791473149396;
        Thu, 08 Oct 2026 08:25:49 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9f1c17b63sm5554792a91.12.2026.10.08.08.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 08:25:48 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH 0/3] ksmbd: fix three named stream bugs
Date: Fri,  9 Oct 2026 00:25:34 +0900
Message-ID: <20261008152537.4147299-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Namjae,

This series fixes three independent named stream bugs:

  1. A read at or beyond the end of a non-empty stream returns
     STATUS_INVALID_PARAMETER instead of STATUS_END_OF_FILE.
  2. Opening an existing stream with different letter case keeps the
     client's spelling in the handle. Later writes and removal can
     target a different xattr from the one that was opened.
  3. A write-only FILE_OPEN_IF on an existing stream can replace its
     value with an empty xattr when the value-length lookup fails with
     -EACCES.

The series applies to ksmbd-for-next at 5d2b1ab54e9a ("ksmbd: fix
named stream write and EOF handling"). Each fix is in a separate
patch, with its own Fixes tag and stable Cc.

I built the resulting kernel with CONFIG_SMB_SERVER=y and tested it
through SMB2.1 in a QEMU guest. Reads at and past stream EOF returned
STATUS_END_OF_FILE. A stream created as Foo was read, modified and
removed through foo, with one named stream in the listing. On a 0222
file, a write-only user opening an existing stream with FILE_OPEN_IF
received STATUS_ACCESS_DENIED and the original value remained intact;
without patch 3, the same sequence emptied the stream. The same user
could still create a new stream.

Patch 2 has a minor textual conflict in linux-next with the VFS tree's
const mnt_idmap conversion. The resolution keeps both the const
qualifier and the new actual_name argument.

Concurrent creation of case-variant stream names remains a separate
issue.

DaeMyung Kang (3):
  ksmbd: return end of file for reads past a named stream's data
  ksmbd: use the existing xattr name for a named stream
  ksmbd: preserve unreadable named streams on open

 fs/smb/server/smb2pdu.c | 10 ++++++----
 fs/smb/server/vfs.c     | 17 +++++++++++++----
 fs/smb/server/vfs.h     |  2 +-
 3 files changed, 20 insertions(+), 9 deletions(-)

-- 
2.43.0

