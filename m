Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D6838F951
	for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 18:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787337677; cv=none; b=GeQ6hFhN5wMaSm7tfiLyI8oMeRqHMkVLxsk3DQuNuDnKgFhcY4U83npcY990WxpTGOOBdR6KJKJ/tElq7tAp6PaV1a70KpsReRS/PoNypAcAgHoVyDRdJOWYr9aoW2oYfBbsVsZhwlwfBwvWE1F1+FbKXaM56mfY4tQg9shKha8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787337677; c=relaxed/simple;
	bh=aq3UF1IMw9Ok8DY1O6O7mVQy51xAqypO6ynLdK/MhpA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AMi6UvF7r1rcy/WpeJ5/nhHQgdTV66SAyDVnIHR/HpLIMV3XG8qhGThlLhv3BGYuzFcrRzbn2yQwng1i//nwxUC8eLzGefp5M58gls5rstZe+Msg8AGdbJDz18yWS0/UGDlXNzj0NO/7X6YgKNP/ggb2NpDo4nOq0lAN7I39q2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fq944JDS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=c25pfgh3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fq944JDS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="c25pfgh3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787337675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/EWnA5fLGeouAkD9UPT/t+TlAaDY0RYXoJeYQBPeLRw=;
	b=fq944JDSVGOPFuFgfb9f6ZTM+zby9XINYAK1F2HUP9gl54jvQGk+7eSNwF1dJbzuTQk6iz
	hCwXSkWqS3/ubXamjXViv8bD/xtptIycmpRRfb+Ji5GMuTyAcWYJldeXRArAxb0w2AsjKR
	gsGyUnp5TYepeoMbugoIDhEQkZyxZcg=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-oHqIlyjtOS-MQgD_-NU5CQ-1; Fri, 21 Aug 2026 14:41:13 -0400
X-MC-Unique: oHqIlyjtOS-MQgD_-NU5CQ-1
X-Mimecast-MFC-AGG-ID: oHqIlyjtOS-MQgD_-NU5CQ_1787337673
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-836c4a54cbcso51885667b3.0
        for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 11:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787337673; x=1787942473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/EWnA5fLGeouAkD9UPT/t+TlAaDY0RYXoJeYQBPeLRw=;
        b=c25pfgh39e6uYOQg6HW6D1oaWRpIppLqjivPJYk7Uxs71ObxIELgHpHvlBmkViiiwN
         v2agNPj/gseVLJ8+AJdM9QAy3uJZvJBHz7RpTROl7hMZqKOHREhUNrMMwo5qTgkA3Wtu
         MaAcCjGq7PwkxYEUcY5UO3o1FGCaCpdxNIdjZbK+Wz1lm5R0DykuqcHhope2095VH6dc
         /ALo5eCH5h6aR/wn9gXOylp9k96ImaKxhrBnha9yiTnhk39NQsy5NdzLIm3QaA/eCaU7
         aQ0QWg2VJaEfQEi6abutkNKDkjweOSANRnFNNXvnjRKrr9+wF7GGnXJa56hI2d64SOMi
         EZ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787337673; x=1787942473;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/EWnA5fLGeouAkD9UPT/t+TlAaDY0RYXoJeYQBPeLRw=;
        b=CxyOgac2ojWXW6LLrRDF4Xv+msDWlVZY387MRYfhrwu5PiqRn0pYwKQS04JGrHf8gX
         cRlxSI2Jk/da4l2eVoGLAZKNjd5dWmAg5akJcFVfH1yrRHwIlb9JqbnQJxRk6FUfBunH
         T9/0ORY7ug0/6JBLEEFEteHj2MYgo0PE3fBg0E7/mvXIJH6ML+bAqaOKREJ12YtUzK2D
         4SvAbEULk5uBCw//g7McbQCM//QU6LnZ5v7zyXaenFyNBtopqAoGXQbmSOoQa+41LZWl
         rd0Af21rBnPSBG9IHeL1c61LR+7B25ZGbVPcS/sjsgCds/fYn6SpIFasmmy9POYGWuYf
         +G0Q==
X-Gm-Message-State: AFuF++l8slvHxb/H9ydNiFM271AkgVgqJ40vJzNS6B9fQqEymyNoiwGT
	RFaCQh/0OgpBM20ujM/PSzeDDGRM0OGePmBxknpm+e4zqKRkpjCTLTw2YOyJtvbBKLNGPwvTAD8
	3AjVBAxbHYVIDbMjtRTm0p3XhXCa3+/0+2ypqUSjO+J0kCwM9Lf7D3AhgcjtQJYVwN+vjGIlKGM
	dLzGrS5GxChdm2xpTwAiYcrKcN/mFFVQd2OrF6LSv7p1EUEfE=
X-Gm-Gg: AR+sD123CUIoXlzfnFcATMBm3mJd2w7myrwNN63QeZO6CURgmXWa8oPjZ/wbbiKcqBe
	FM/6Ki02T8J3mLLvdkj/YiAgoBZaeYBCdEHyrjx+u/3V/VM/5KUoT78+M7E2VSQNrZY1EdXqQkj
	hTWXKWcmffX/MKPXfUP5xvriREQZDk+fZtkC6uymSma1Tuy7acq64jdqBBY1rzhsfOyBq6N57tN
	L4qFBMVAkrAoeojNPRO40IKxSJYeQUCWEGldafjf/NTLLe8RvxHHoP3o0LyAdZshF/7Tyy81qYz
	BsEPbhmWByJCHyrKMA+y4q7jgbQIFbUDdvn8U7SiTKYI4Nl/VFMQzeV46bFpjCLCFr9xWUV6Pwh
	H5V6g3LsqRIbJc/FKIwAasPQTiFl114hkBLXGuPU6HkX9dW67n4+A0pE8nyBks5WXlw==
X-Received: by 2002:a05:690c:e142:20b0:81f:e7c5:f420 with SMTP id 00721157ae682-849f4e6652amr27269517b3.20.1787337673126;
        Fri, 21 Aug 2026 11:41:13 -0700 (PDT)
X-Received: by 2002:a05:690c:e142:20b0:81f:e7c5:f420 with SMTP id 00721157ae682-849f4e6652amr27269257b3.20.1787337672589;
        Fri, 21 Aug 2026 11:41:12 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84cabd2861esm539707b3.37.2026.08.21.11.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:41:11 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org
Subject: [PATCH v4 0/2] cifs: two size-management bug fixes
Date: Fri, 21 Aug 2026 13:41:07 -0500
Message-ID: <20260821184109.1834871-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These two patches fix independent bugs in cifs file size management.
v3 patch 1 (clear tcon after cifsFileInfo_put()) was already picked up;
this series contains the two remaining fixes.

Patch 1 fixes a premature i_size update in cifs_do_truncate(): when no
writable cached handle is available the truncation happens implicitly
via O_TRUNC in the following cifs_open() request, but the previous code
set i_size to 0 locally beforehand.  If the subsequent open fails, other
processes sharing the inode observe a spuriously zero-sized file.

Patch 2 fixes a loff_t underflow in cifs_remap_file_range() when len
== 0 and off >= i_size.  The computed length is negative, which corrupts
the downstream filemap_write_and_wait_range() range and sends a huge
ByteCount in the FSCTL_DUPLICATE_EXTENTS_TO_FILE request.

Changes from v3:
  Patch 1: Call cifs_invalidate_cache() in the if (cfile) success arm
    as well as the no-handle else branch.  The original unified if (!rc)
    block called it for both paths; the v3 refactoring accidentally
    dropped it from the cached-handle path, leaving the fscache backing
    store unstamped after a successful set_file_size().
  Patch 2: Unchanged from v3.

Frank Sorenson (2):
  cifs: don't update i_size in cifs_do_truncate() without a cached
    handle
  cifs: fix loff_t underflow in cifs_remap_file_range() when len == 0

 fs/smb/client/cifsfs.c | 11 +++++++++--
 fs/smb/client/file.c   | 18 ++++++++++++++----
 2 files changed, 23 insertions(+), 6 deletions(-)

-- 
2.55.0

