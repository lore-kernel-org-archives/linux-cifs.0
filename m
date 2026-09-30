Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D8A515886
	for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2026 20:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790801254; cv=none; b=W9duh1hH458jnRfyVBF25Dz2r6CzGbVpXhPcfm1UycWNW6MiLBnhYXtEsTYxxFsrMdUc1GrCTfa4Au/O9zvY/0qf+6reVFuHAYAFnqQXw7lpsnKZHc24pgZcvVytAniHbDi+fBZZWAKA6McSHNBX8gm3vQIszlgswoO/CaRbt1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790801254; c=relaxed/simple;
	bh=qQrzRo/rm72frvt0GFSzQdpNFSAmGF3L2cNdOsx5Qq8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LGmLUs39YtagvzTDCh8fmxzsISt9zpkD2xUMtmdCPGnF0R07yLkl1Cjsx3ZvJChCzgYyKiee+9dn1tq9ovqnNdsyp66zJOM+QPc1+XxgAdtoZwAs1tuooJZiGWZCHZebmw3tgvljjklDLPHUxFeuxVdd7dCJgQOUEl5SAR5OPTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bipyLQNZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=pgu0vrE6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bipyLQNZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="pgu0vrE6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790801251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+uA/cnv4x1TihM4U0TJtTPq5/hth5IOPncilpl/ZYVs=;
	b=bipyLQNZg25TFFaMKnkjqDo98OlLfep8T2QP0RrCaXh/BCNi64K79u99OQ71piuULd0GqI
	f+hqlFtOkKnIQwFFNAIyhzJciwCMYm8kpZ088vIZmyVrmwrjjHg17ZZ79l5FtVT5Z3QbsC
	w+Z6EGkn+FH8uBEfynlNS8whWgUptEo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-_ziBQOALMG2KLLY8Pn-9mw-1; Wed, 30 Sep 2026 16:47:29 -0400
X-MC-Unique: _ziBQOALMG2KLLY8Pn-9mw-1
X-Mimecast-MFC-AGG-ID: _ziBQOALMG2KLLY8Pn-9mw_1790801249
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93cb6391e89so66509085a.1
        for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2026 13:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790801249; x=1791406049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+uA/cnv4x1TihM4U0TJtTPq5/hth5IOPncilpl/ZYVs=;
        b=pgu0vrE6EU/rmKCwQYlV8Zp9+IZtPrgISnFkXZzdQMXGlDuzcdC7b+LPeuhzNR+VCk
         5szlRlrKnDsvopFQSZsptpFaRxxH9L85CANabpD92KQbuhT45KFq30skqcPgIFz3yvwA
         qX/Bos1+T+NxUx9kkVhiKs2GCNuYf5uCOc2NHky/QFFdvwy1ezE1GEmo2L1WxxmU7YXk
         3RQeq3RgOKHo2D/8hFasuJHMlDc0E3MkH4aLT/HlLvqJg0ia7f3Ym/jG1LIN0p7QbYnS
         SBLHBpgJwlo6fgH6JcrgnQFSQfKqzOFvNcBo5nbJfFe+qc0kcRtj4q/p/WgmLQqzZd8Z
         siTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790801249; x=1791406049;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+uA/cnv4x1TihM4U0TJtTPq5/hth5IOPncilpl/ZYVs=;
        b=Rqe99IbNqQSDQQDCc5nnEkKfghskl6aI7AGnWYV2vVVSq/4buJLapl+uSp184jpDZu
         S777kP1d6ihbglUML9mPl1X4uJuh6q7GGtKYWGlxvVCxQPtlKJaltuXUnbcsv5w60xWs
         ZKIrcVTMO75qrWW9XrPc4fIshLJYT0ZTTDzcv12s5FasgN0pEBSR1Y6BvR7qTuOKJ/Df
         J+iGHpTv4OuhD1NAXAEkbkJdu8GAeN2B35fwbjceW1FuzBg1oGrFEkeZNZSUTX90wBag
         5lGPaYmL5fpndUq6WmTaQoZ0X26sPcCW/Rm9h/fJ3o+g0kqv4bxbSiSQFWSzKIgjEuEm
         lP+w==
X-Gm-Message-State: AFuF++m0YArdj1UgNIsDttX3xq6dN55udklA2zSepLaKUiWBeRzyHZX/
	od8mEOld9rV5YKoILoks43HHgFQ112mYe8cUskIpHndGS8jIcbwowFKmKxok17OCy1GNRxSHBfL
	gZij/tOTosR0heXPu2FFqI8840D+jWB1ZTBFynjQpK8X7DvEHI/J6/5wehvaLR6tWXaeGYBIKGp
	S0s7aP6b2fsnO+eFcFdH5FlLn2LS2CBveM2CQyHjuLibg54FI=
X-Gm-Gg: AYBFou1/aGuTneHtE/+aw0yW+2EF0dKEb4Ls4HdgJVAFfA1YUS7+Om+E4BwGCN/k+4J
	4T3Um59hu3gTpFurPTCuia480ufW5iIuBpUuMAY0XYBdVVaZkClrukTNSyjYnfDmc26osJW/I3l
	YWYQ87hII8NdEZveY34pUIWCvw4a/RrbFVK3ncgZoiYpJsSqgv/txXP9zqO3FRqB+OrreMFBRO9
	p3equvmYpdEKuoUwGNmMB584IccAtMn/ButJgLMVcfugbNxGd0HfZuv+BPiMbNAW5S6cvmiWgFv
	XNRFVojAZ6IdG1Ral+Yn0zIQ7lZ9D9XZp5YrlMaj1HR/1PINW3PzVWDOHiP/Gr0aJMhx9qux65n
	UGNaVw74dArqAiObCV7Tq9YHSgmVuVcpg0hoUlVFmouPa9xJapJiml9XipfiJs3M+ww==
X-Received: by 2002:a05:620a:45a1:b0:93c:735d:692 with SMTP id af79cd13be357-93cac1367b5mr427232385a.27.1790801248588;
        Wed, 30 Sep 2026 13:47:28 -0700 (PDT)
X-Received: by 2002:a05:620a:45a1:b0:93c:735d:692 with SMTP id af79cd13be357-93cac1367b5mr427228585a.27.1790801247994;
        Wed, 30 Sep 2026 13:47:27 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93cb6556ebasm52169885a.30.2026.09.30.13.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 13:47:26 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: split cifsFileInfo bitfields to avoid shared-byte RMW races
Date: Wed, 30 Sep 2026 15:47:15 -0500
Message-ID: <20260930204723.1555769-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The invalidHandle, swapfile, oplock_break_cancelled, offload,
and status_file_deleted fields are stored in the same bitfield byte
in struct cifsFileInfo, but are updated in different code paths that
may run simultaneously, and are protected by different locks.  Since
bitfield assignments generate byte-level read-modify-write operations,
a modification to one flag can overwrite a concurrent modification to
another flag.

To avoid these races, convert these flags from a bitfield to
separate bool fields.

Cc: stable@vger.kernel.org
Fixes: 3bc303c254335 ("cifs: convert oplock breaks to use slow_work facility (try #4)")
Fixes: 4e8aea30f7751 ("smb3: enable swap on SMB3 mounts")
Fixes: ffceb7640cbfe ("smb: client: do not defer close open handles to deleted files")
Fixes: 173217bd73365 ("smb3: retrying on failed server close")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifsglob.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 79e4e84f8985..5c5b76a9e9fe 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1450,11 +1450,11 @@ struct cifsFileInfo {
 	struct dentry *dentry;
 	struct tcon_link *tlink;
 	unsigned int f_flags;
-	bool invalidHandle:1;	/* file closed via session abend */
-	bool swapfile:1;
-	bool oplock_break_cancelled:1;
-	bool status_file_deleted:1; /* file has been deleted */
-	bool offload:1; /* offload final part of _put to a wq */
+	bool invalidHandle;	/* file closed via session abend */
+	bool swapfile;
+	bool oplock_break_cancelled;
+	bool status_file_deleted; /* file has been deleted */
+	bool offload; /* offload final part of _put to a wq */
 	__u16 oplock_epoch; /* epoch from the lease break */
 	__u32 oplock_level; /* oplock/lease level from the lease break */
 	int count;
-- 
2.55.0

