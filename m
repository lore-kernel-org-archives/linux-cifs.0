Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B159E49427E
	for <linux-cifs@vger.kernel.org>; Thu,  6 Aug 2026 23:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786059799; cv=none; b=sYqwhDv6GlonKPwFmjtjpaeWuJahJiSNVgMG78Z2ca/00XX+wGa55bHD6ah25f9YMKagnW2zC6YQ2EP6jQDXRIOijdagI605bEsG959TUvlsDSkoz0ytnR8MMJ2N1AML2pw4nmT1wL+FOC4cBQbKkUe4d6ink94U5ugQBnzf26s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786059799; c=relaxed/simple;
	bh=ApiNRPTD0e/dpTH4sE6IKJC4jWIcl81cNwAEZuckU0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1vAjP4eqr8Gqh+HGqt0lkDPfxWOhLFaQQb7lTYNjMEzdg7ok1YFeGmqX+UgwlHbPxxYt/0E6nGIf7zguePbgXwY8TfI9NUa67kwpjZ/HVjzeWfOU3QkST7Qm+OrwhMgwfCeUi0suUPWL3VkMq++cXLL+QI/XPpHevuH0n43ifg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OMsTKhK7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XK9xuBf8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OMsTKhK7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XK9xuBf8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786059796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e1iFUSkJJxaXDGQzVMDBfKr25aoR61PK4Uc+XTa9ttM=;
	b=OMsTKhK77A/BcrwEcOVt0EAJeiQcUEhaM7A/SWI5fdfDRfrCl69U7hjKxW8uTRX82qPRkH
	gcu2w3lDdSpDWYe378VvGF5fWyrhNlLwOtW1nObfa/1CLmg8OJ9PQjA808LHbriaE7jpk+
	CGUYuS9+HJ7snpAFVE2IFTFJM7+pNsU=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-qknEl9tEPMiAV0RJWwh29g-1; Thu, 06 Aug 2026 19:43:15 -0400
X-MC-Unique: qknEl9tEPMiAV0RJWwh29g-1
X-Mimecast-MFC-AGG-ID: qknEl9tEPMiAV0RJWwh29g_1786059795
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-934993d0f39so333959585a.0
        for <linux-cifs@vger.kernel.org>; Thu, 06 Aug 2026 16:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786059795; x=1786664595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e1iFUSkJJxaXDGQzVMDBfKr25aoR61PK4Uc+XTa9ttM=;
        b=XK9xuBf8+sw1njC98oAv19mWDWw2y04lj6chq12VrqHLp4S+199Ixghxoru78SGj+4
         4XJ4+LnjiX8LxuRKBoTnB9avqulhxWJUGsZMBAKVlmv5oU7LZcyQZOAgTDZHNe7dFB2R
         hIYRVSvL1kwmnEnhRWSktL+rBii8D13KHNIaFVgyUV/xklGiyAP9o5h2//Tw+jrpe+XW
         PrvdieOMZJenaST8badzFqvGZSMC7ela5eVJsSdx/Vkq60aFOI8deae+xftDZP/o920X
         K8L/TiGPkshhaAOD7qFB2cmU2ZI4cBdm2ugAHKf/EzfpjAgCm9+RgwReMtICXCI62y0g
         phbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786059795; x=1786664595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e1iFUSkJJxaXDGQzVMDBfKr25aoR61PK4Uc+XTa9ttM=;
        b=fXrq9OmSGVlCG46rH67skUisk15L5VqBWDV8BgqFT//9CE1vTwMCV+SGKlRx9ReIcF
         0yjUCJzAG9OjD5FSYHY22oK8nrQYbWCAotiLBdboqIPrVqh4DwhKkhfu5sQoudOJ43G3
         IYyM1t0NBbNmoJCzgZwZUHOdldN/nzByciSxE4eNEhun5fcYikyb3nXq8WeKNKJVFAIt
         JATOfYO2Pdi9NA+ThkH1Ml1pRmVQriJXS78QIA4I5Qv7rfX9J1cuBSVUM11RhyuZG6wl
         9LbZMcoXj3a01DHf1nd2OmRfMShus20Rh9RWfew+iYjDiz5SpXHdc4lKbO4bXjAL0wix
         AzeA==
X-Gm-Message-State: AOJu0YyFx9KxT6TRg6MZZeLWAjkmM6UDw7yAgo1HkM9M49VKlmd9BlLs
	7xHkJsWgISxe9Ji7cI12os+X0sOWzjDOrMxuq26jbK4Q+rbux4JzYRguybSCiMNMNjJIkdJPyUl
	b8YGK2MjGT+4orVjOoSPnkxqm7xIVV1/6xCXLB6XSo7tMbvYjwmYNSzHU1Gshi96GLrn25ACcjS
	+i3BY22XJs6VrbR0t8PP8jOTXgoEUZ8phVHI7G1sBLCYTclEY=
X-Gm-Gg: AR+sD10fNBwyFc2nGbaUxPGkmxk5cIrECeCixR7uhlG8FI9OZagKB1Dh1Bo/MG27Sqi
	+YgOaEKMTpWCkDInL5W424KQm9M2h/PPgQmfzDVCJhRXzuDMTSUK9HdbFPhl2/Q2Ud1GpKxOdem
	tNLIkG7DLbEWJDXQqLbBtP5e3K9P/OUpF2nOGBVUpwZMOxKqCMhUVnk9TzyOzVRKOwGAPffkwtW
	qLETaDKJzKI6y9uZ5MmZClZWp7kIl6g+NfDZZdtAWo2Eyci37aZYi7BtIRSnUUv5S923p/6BdZN
	LmwN3CI8SzQ/gUvXrWsWdwmaEoBrJrX23artIJTLEMzWtViENISLk3RfcJpgr8QNypG2VGI6MUL
	EK4xbvqny7aXAaX3qVSBzip3yF64CujW5i23q02YX9e2k5RvkGTnFKdZFpuUUmXQygg==
X-Received: by 2002:a05:620a:ac1a:b0:915:e9c3:f1a0 with SMTP id af79cd13be357-936490e5be0mr1663850185a.12.1786059794867;
        Thu, 06 Aug 2026 16:43:14 -0700 (PDT)
X-Received: by 2002:a05:620a:ac1a:b0:915:e9c3:f1a0 with SMTP id af79cd13be357-936490e5be0mr1663847085a.12.1786059794312;
        Thu, 06 Aug 2026 16:43:14 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9366e03f05bsm26891485a.2.2026.08.06.16.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 16:43:13 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	stfrench@microsoft.com,
	pc@manguebit.org
Cc: stable@vger.kernel.org
Subject: [PATCH 3/3] cifs: fix loff_t underflow in cifs_remap_file_range() when len == 0
Date: Thu,  6 Aug 2026 18:43:06 -0500
Message-ID: <20260806234306.3662175-4-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260806234306.3662175-1-sorenson@redhat.com>
References: <20260806234306.3662175-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When cifs_remap_file_range() is called with len == 0 (the clone-to-EOF
semantic), it computes the effective length as:

    len = src_inode->i_size - off;

If off >= src_inode->i_size, this produces a negative loff_t that
corrupts all downstream arithmetic: filemap_write_and_wait_range() is
called with a wrapped range, and the ByteCount in the
FSCTL_DUPLICATE_EXTENTS_TO_FILE buffer receives a huge value, potentially
causing the server to attempt a multi-terabyte clone.

There is already a check for off >= src_inode->i_size at the point
where -EOPNOTSUPP is remapped to -EINVAL, but that is reached only
after the ioctl has already been sent with the corrupted length.

lock_two_nondirectories() is held at this point (i_rwsem write on both
inodes), so i_size_read() is stable.  Add an early bounds check inside
the len == 0 branch and return -EINVAL via the unlock path if off is at
or beyond EOF.

Fixes: 04b38d601239 ("vfs: pull btrfs clone API to vfs layer")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifsfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 2073b29ff969..bd4936711ced 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1413,8 +1413,13 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	 */
 	lock_two_nondirectories(target_inode, src_inode);
 
-	if (len == 0)
+	if (len == 0) {
+		if (off >= i_size_read(src_inode)) {
+			rc = -EINVAL;
+			goto unlock;
+		}
 		len = src_inode->i_size - off;
+	}
 
 	cifs_dbg(FYI, "clone range\n");
 
-- 
2.55.0

