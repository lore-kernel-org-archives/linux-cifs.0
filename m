Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61A4272E6D
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 02:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786070532; cv=none; b=PkguYpxLZBRCRKpfJ5f2whT5ekGdGaQni331ShyVR6BOkKcvYNHIE+czM9bckQywwNRDeghORNOK9V+J+wc0+GUFPwZcN0Adw6SA4ifBDGIlQxDL0uTrA6TUnh753jHmhayhpPEusFwDRwT3csqiMNc8dOYS5NSVztrCrNm7wjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786070532; c=relaxed/simple;
	bh=kgxsvT+DuMSi29x7SRx4HaGBZ3ybkYKALfE/F+NbPz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fu0NQlI1HwUiV5nli79zAncCvd0pdND2b0ynzR0gP3FIEABb5NAsPPZkdFCkOojapoOV+2GNZe3JCorqYnrqVOIZ/8DtDkMK+BWzKUnbzlFhsXJk95Knj0n1UJCJTHmS8Z0iPEevIlP/vPU1yR3wnUyxlz9nQilgJpTnkSTOgJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TPyGBSle; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UfnZgiwA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TPyGBSle";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UfnZgiwA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786070530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=upLfN1zf/6q/h0s/Qp6bFvb8YmQpGLWatarZ7u1O79Q=;
	b=TPyGBSleZ8RTu7c0RBLLio09P1QAzmVMhlu7dH2Mw0h11B6Y366BlQTQUEYl3sD+4pZTyu
	JNZwm4H2h20veLtVTptCJH45xLYd/uzxAXljsTArBMms6rKXUK67B2Qqu4Kljc0ycDPPcY
	Za5dvO7nuD2OGeO/CJypA0pauy6HAxY=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-ANglC0_HN_uDzuppjgavzQ-1; Thu, 06 Aug 2026 22:42:08 -0400
X-MC-Unique: ANglC0_HN_uDzuppjgavzQ-1
X-Mimecast-MFC-AGG-ID: ANglC0_HN_uDzuppjgavzQ_1786070528
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e9e741693bso1604375a34.0
        for <linux-cifs@vger.kernel.org>; Thu, 06 Aug 2026 19:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786070528; x=1786675328; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=upLfN1zf/6q/h0s/Qp6bFvb8YmQpGLWatarZ7u1O79Q=;
        b=UfnZgiwASr+ZjtJMOCR/zpztOoNJAhNNdcSqzaeQLfC30F7P9xrirXfdtXbyP24v+Y
         sYT1SbiH8O8aaJ6io946PU7RCOzf3SyyvtxTx9m8DljUXtNdv4aUKx91XkqW34Z1LLWF
         3Hg8sP0tLEf5KvNx39KcXxwNPipCrJo1S0FxhqLwAQw2AamhgUvUpKqYb1RApOQ8JvGU
         i0WXSOooe4IEF6eeYQM0naaGQnm47aUcf0keDrlN+AQbGICELpsSHVLdesD585Hp5qrR
         qE1LKkS+e/eYqp96QHq9zRT3CIpQ2ph2kF5Ff0MFHDpNccNYvcsTfH176CO02qSUyi0I
         Tn5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786070528; x=1786675328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=upLfN1zf/6q/h0s/Qp6bFvb8YmQpGLWatarZ7u1O79Q=;
        b=MkqjSH3BYt+wWwiOpmsJz+Oss0xVOjzjwUSWk/3krEz+8Nc6BTz5wL2nBdLU92dpa8
         8ubrZqWkw3sHdoDTssyndbPbXQ2tsAPw0nSjP/UMBAhn2qpYdfBddTuv4YJfQyGJv9RS
         yf0Tzey9LGLJROnkT+IoYwG1abCq2v4m7oeRwK6zdFg6mYBeFZTQlkozzD1Mhl7EMyhd
         QGLgYoXWrIGhbrcsq/I8p/ZqhcVKv6xERjHYA9SOtZGMO2MVb7U2JHW7bus9unWoP8Fm
         PoK1wubSYd+di7pVX2hZaqa62LD2OwPO1c3D8NyOQgH7qbAhakJ0g/ddXZAhpimtvxzY
         sIrA==
X-Gm-Message-State: AOJu0YxtXFCdhb/dbbN0VEDMKBvYyE8TYplwVisNpMZbl3ofubdHSr/5
	MDyPC7Bz5R0DPOD4ZBxjFzHY3X2Bt6/L3SEm4L2WsPUsMulYmmrmBsJK5eOXMOyRVbYvvItPSya
	PSRqp7/zoN3ey+PLJBIHso+iHhxsQm/2LHbCbP4RopM6Kw1QR4bEGDUT1q3A+PSQXKDLRuVABxP
	LBtAfiB5wVa0blta4XD/bxC8NLvlMv28Q7M3fkFgfMBwRuGe0=
X-Gm-Gg: AR+sD10BdxmmdDqEA5QWNpON3jMlwQGf6BkIeJeDSQrpLlP1jEHtUyZJRsQVD7KZh9l
	ZH3Ib7h3s4HnVSPVCG29T/p1bNNI1Wl3V6suufK6Nw+Vc9A3Xv4iFWjmqgQRTSCz+9i0sVxYZwC
	pQSsVwi1AHiXFzaXwBdu2ZoqmQDE1ChXNcdnf1KXSAG4GkYv+QVcEQ+zH6NeFbNLeMxSzqRvYEq
	/XoHg/MdzT/vLt01KcXAEF9/yEef8uYv4ifQdORFNchXBHNj+DKsX666S6h2p6A6WT8N4YHmEOa
	1EQESuk2hkvHOM75y1Mij0CY+QI4XkcJLOwzvn2GyZ7VR2Gmz0VcR7rsFjlibHQ947aXXehw5hT
	5MghcY9y9KuhoCfObZ2Tn3A/SK19003tv4u50YKjLPHpRz8Hz4+JEhbRff406XpUudA==
X-Received: by 2002:a05:6830:6189:b0:7ee:347b:679 with SMTP id 46e09a7af769-7f1e5ecf12emr12242888a34.13.1786070527993;
        Thu, 06 Aug 2026 19:42:07 -0700 (PDT)
X-Received: by 2002:a05:6830:6189:b0:7ee:347b:679 with SMTP id 46e09a7af769-7f1e5ecf12emr12242850a34.13.1786070527453;
        Thu, 06 Aug 2026 19:42:07 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f35b563887sm356182a34.3.2026.08.06.19.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 19:42:06 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	stfrench@microsoft.com,
	pc@manguebit.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2 3/3] cifs: fix loff_t underflow in cifs_remap_file_range() when len == 0
Date: Thu,  6 Aug 2026 21:41:58 -0500
Message-ID: <20260807024158.3707995-4-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807024158.3707995-1-sorenson@redhat.com>
References: <20260807024158.3707995-1-sorenson@redhat.com>
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
index a1dacc7d8f74..c8e2347aba5d 100644
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

