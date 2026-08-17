Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E341229B38
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 17:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786987017; cv=none; b=OqHzX+jjhhGa3zJH9/bZVMngJQQ8QtixpPbE6cX1FBtoztprcuBAJotkPNXkcW4p6nf68PjBO7+0p0NKPubjl/1gP208/NiaBFbcnzng+UwE/fvY6+wljuo/zF3OdvFVFSQU7SH/jRX7mU6FDfncRUUEhewvDAQID1i+/8VDZws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786987017; c=relaxed/simple;
	bh=lRYoPmV0LW14tEpSfCnlYYSJ4dk5knGBrnW7LNwSzbo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L11xKPj/Wwd3qSvGzi8BTUPa7gyQu6L0wZZxUoe7nwaXpjnh8qpbvOSY0BUfrWdCxG5B+ZsoNGnqPcrh4Y2OA28H540PGHNRxaUjSKqv1u1Y0snYfWs0Xzb44R9wNWG6kTFJobX6pEuX2xae+vUrgPyERZCSM5/Z6/p0fpYhquQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G47n6OWS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EhTht0Kj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G47n6OWS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EhTht0Kj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786987015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pvxgPz+LBnG3ZfLOKG1tZ8Ig6q31TfKHpwszxp39SfA=;
	b=G47n6OWSe0UNyBnqtHRK6FDqX2u4vF3+Hz6YlzXUDiwgUcKV0K2uZsS+NkR3iaqyoTWSVo
	mhxmZ28VI0ur+Jo8Woi86SHOewHA+DAxRxpSH87/qmk0aSiFF6g46yEO3WLSQIN44hgpQ8
	rXrcz4z1w5fvYV4h79egF1QIiF/xsGM=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-32-hksR8SttMwygc5YhXbmUBg-1; Mon, 17 Aug 2026 13:16:54 -0400
X-MC-Unique: hksR8SttMwygc5YhXbmUBg-1
X-Mimecast-MFC-AGG-ID: hksR8SttMwygc5YhXbmUBg_1786987014
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-4412c255fd4so4042449fac.3
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 10:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786987014; x=1787591814; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pvxgPz+LBnG3ZfLOKG1tZ8Ig6q31TfKHpwszxp39SfA=;
        b=EhTht0KjFXzpQN+LqvFJvHjggE30IBgPC7mwt/DfYAv0YyLOuxpdE6dYTW9kqLlvX1
         Ba8oDzsqyHNu4YDXnzHYfJ5T2J34b2iQHhCZshLa/bWdY+3UFKYzfLV4bWsUfzcCjyxv
         6ri4Ysh5KuS17N1mGkFo+5tRH+13+bKtqDTB8OVNQgAa3e3fhDhZc1PVAk7r7pMzBmDe
         fXZbNbCn2sb3bOc3RyUAsW8XGeCsrN86wmdbfNBkEt1ilQkMmIyVkT5GcLkWU53ilzVs
         AubUWexIUNsecxIIgKubxZ8kwRoVAnhdsrrn7QRt3nNUPTEKHsih03D+KronHPCZMvLc
         OdHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786987014; x=1787591814;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pvxgPz+LBnG3ZfLOKG1tZ8Ig6q31TfKHpwszxp39SfA=;
        b=jQa9meK1t8/HPKZCCMM/dnM2H3foM0ycEviGJh3AoWIdYeguffkcAL7SwAOtDdAS4/
         zKB/mLgDXALdLSkk6FjhEbYXajnszPQAkKfUkOikaSpKLxc9YeluwsUZZJLbWDnpkzyc
         W8CtwxRiV78Spnh7ZKbLUgk0eYBz29lUEQShgoW+m7bMRcMv9/i8egyOETR0q7XyjoAF
         GrfKdG/oy+d8Nd+wr3YF0Y5G009CFI8bR4uzU6rIme8orsF8bOSePUslicKFweTsllvf
         pvBPDFprS6ex8vBk/+mYu0p7I6HhSE8C+mX8jDPiwdRfe9nnmXOKffrHEP7MUgN+jMvX
         5EGQ==
X-Gm-Message-State: AOJu0Yz/rdrODs1IqLyWvbkP6z6AK6yMGq7YnW8DV6SzkVPYf+3UluPs
	gbooks4jRsXExeAZOlTLoh7uWpwNKOI1IPtTC4fQNHc+ViisM8zZeTh4SeBQdVcoGPKHxpHBZKz
	R5Gs21T6mWsKG1WrMpLLYc9iKz7m6KcAv+RK0+7NP+/bsLN9pbb8ZsJ8mZg3K5ZYMvudqRf2zZR
	rVIbbqEUsFsFzi0uYpC11SYjPGi+lMIw8cRynvmjtrXbMyJ0M=
X-Gm-Gg: AR+sD125PXd0Himi2wKbbSYsfrNuMJ0XABo3o2KIjVVQZDCQA6pDO68yk+HUHnBUalq
	+KsyI+V46f4o87H0acKkQW4il0/6sv3CIT8lyMEqJe8Jou9ZHLBSuhK8UdemaMrLnzTFIcmEnMu
	CUpqTnIh4yWmjEr0hj4uM4Cib6D9Dl3OolOQGREFRXmM+zxpOYHdPaffPSf4U1YGuojZjg0JwOV
	efMyGji3QxhPL9a9zS8w22RNXYRQSXnZCM7UeFSmwlylgEoGTqY0QmCGUSCC9AJC4Vdd/dST4Z2
	U3Bbm0K/DcjHDaVJS2mlZ0xpIocJEMNZ20p54GN6q0uoVNhCfgc8YX+/S5856VvNKoTA2MxeNPq
	2cVLWpg3nwu/DrM80qd0NBCq8ii6FQ8jvbhpyq/YkiBMuk00VHUI9JwhmTt0YrPaGeQ==
X-Received: by 2002:a05:6820:811b:b0:69e:b8:ffe4 with SMTP id 006d021491bc7-6b11e366456mr1792260eaf.32.1786987013832;
        Mon, 17 Aug 2026 10:16:53 -0700 (PDT)
X-Received: by 2002:a05:6820:811b:b0:69e:b8:ffe4 with SMTP id 006d021491bc7-6b11e366456mr1792204eaf.32.1786987013354;
        Mon, 17 Aug 2026 10:16:53 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f41c0b9546sm2233876a34.16.2026.08.17.10.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 10:16:52 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	stfrench@microsoft.com
Cc: stable@vger.kernel.org
Subject: [PATCH] smb: client: fix ALIGN() overflow in symlink_data() error context loop
Date: Mon, 17 Aug 2026 12:16:51 -0500
Message-ID: <20260817171651.212730-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The check added by commit 7d9a7f1f96cd compared the post-ALIGN length
against the remaining buffer, but ALIGN() itself can overflow: for
ErrorDataLength near UINT32_MAX (e.g. 0xFFFFFFF9), ALIGN(x, 8) wraps
to 0, so the subsequent bounds check passes, and the loop advances by
zero bytes leaving 'p' pointing into stale data.

Fix by checking the raw ErrorDataLength against the remaining space
before applying ALIGN(), then checking again after.  Since raw_len is
bounded by the buffer, raw_len + 7 cannot overflow, so the second check
is an exact post-alignment bounds guard.

Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index f35b6488d810..fb2fccbe8667 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -61,7 +61,10 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
 			cifs_dbg(FYI, "%s: skipping unhandled error context: 0x%x\n",
 				 __func__, le32_to_cpu(p->ErrorId));
 
-			len = ALIGN(le32_to_cpu(p->ErrorDataLength), 8);
+			len = le32_to_cpu(p->ErrorDataLength);
+			if (len > end - ((u8 *)p + sizeof(*p)))
+				return ERR_PTR(-EINVAL);
+			len = ALIGN(len, 8);
 			if (len > end - ((u8 *)p + sizeof(*p)))
 				return ERR_PTR(-EINVAL);
 
-- 
2.55.0

