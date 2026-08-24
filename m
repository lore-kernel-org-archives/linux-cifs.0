Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74886393DF9
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 23:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787613052; cv=none; b=BJH3y+NhwheXIjC2k1Z/DHao/sSoC4XZ3GLhiXzSA8mXBJLIyut7kT1nqOzsiLIVlwE9yi5pyATf5t0938xFn8CH0yFKNlWMJlJsk/Rh449Si+jJgG++s7IqeJRzziqNFuSfTHi7A6gTQikWnohRcUJH84KWQFsqSUMK7BKtNHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787613052; c=relaxed/simple;
	bh=5t9dsbuq+qgw2KojziM1Prs8cfgeS4CA+6RiDPFBoyg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QttJmExLvYKnvBc86Nu/3cHK6DbCPe85CGEUyX/VF/C9XAqqJtAySn+f530r8wviSQhl7JaJqyjfsnysqhdU103YjX+Z2z9kCUL13g+OwI7TyWiBLvunrfFCgVPOJRSnnKKokWblWdra2Of4/GfyhYqDy9Py/uGXxpcQLOcWD9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XT/iciMN; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BYksmtZq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XT/iciMN";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BYksmtZq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787613049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RobU9rx3TEhmPVjz5f/pqmdAablkN1GTEF/dACTQJoY=;
	b=XT/iciMNLbwnKocLiDkG3EcaBpYI0Ia++OePmuFHxTQi0EyueV9YktNl4E5qyyZAez1Jeq
	SFNUjebJHShPLbP0gpj5tDuAg55KQtSJOoCMkOiOdHlgOa09DhwidC0Xe9xbXKIe0rlkyP
	lJE3HjYVaIdzPywirhrPkKwJpcyXruU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-26ap9A5ZNX-Bi_uSkyhBcA-1; Mon, 24 Aug 2026 19:10:48 -0400
X-MC-Unique: 26ap9A5ZNX-Bi_uSkyhBcA-1
X-Mimecast-MFC-AGG-ID: 26ap9A5ZNX-Bi_uSkyhBcA_1787613047
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39512608fb1so10085535a91.1
        for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 16:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787613047; x=1788217847; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RobU9rx3TEhmPVjz5f/pqmdAablkN1GTEF/dACTQJoY=;
        b=BYksmtZq9bfTkxelhj0R6aXnqGDc6D0qHMp5Gg+cQuhPt4914tDGhrBIQ4xw79qsZK
         KKEeh+cMEKuVxoeBzhMmXJG+qius/KLTK1L/OEM337BqOotHPrATbFcpudPd9KY35leD
         k4olJD6BLSlMJkHDDIwXbXL53I4Fvbu117zvWiK+6tjAjIbt0ta0bD72slfKpTW1isQS
         DgZDDY2QvVNbIzeGKllv2aAnjxSun+6jf6josAEBltvml3fj6KYIPJWJJw4QIDpKB4o9
         DDjS11v6vDIlnAYR+sP4O+wqzf5OmoxghEUKq59c94qnQpZAiKjkvCn5endaqlL6BJaU
         iq2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787613047; x=1788217847;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RobU9rx3TEhmPVjz5f/pqmdAablkN1GTEF/dACTQJoY=;
        b=YrpaCmYA1JpsXgvjYabD82HjtmaUUV3ThTaHCrHBomD+k+mQJeqdHwe9mAUCPaWpK7
         IfQYJwuPrBa2VavwzJg3wk8A3LS2rQW16TVYzzSqOlbvDclLZyjrUGxi7zWh4AIzQ14S
         SIUVQasfGIsefqNor0jXtTCf+oPwJGXXMKbNtTbTj1gMQyL5vs1N9NP0EoymQBHPZg76
         ZY4LB5kcrdr0nMcui51VDcjLr2SQItChLDaSUB8wJMBpBerF14niANa5Sp3pweW+ZSyz
         Hrl8Tz4jhBcpcEp/drKPOGxhtwYtcT0u3xHUD9jyy+vGljBcffDmGfcmVA8d3Zqjwfxz
         z9PQ==
X-Gm-Message-State: AFuF++lgTULBWjfJ0KawhGszHbqobNCVCwLtZacCaFJnHC5nN01ZU4Gc
	OLzbCRxmOEfKIYokvgKvwTO7yM3OrPLED6wqve+7gwhCxu6DXaKljEP6HMmN/CqoXkgr8ht/Znh
	A6irAIeFRZEbaQh6U9rvgRt/HmDfBey71kkIlgaH7EwG/il3hqqEqvDo07mtwxTpg+vQ6RWo1m1
	9ut5+rNUFjXSqR+SjYWLSJVn+akrVXWwePL7RB9tawVwtK4RU=
X-Gm-Gg: AR+sD10emBResDdErGX8jmIDazWfFiT1phxUv2BEvvmB1OZxs6Biq+4dFBIAWlTo3RS
	NZfXJfh++TO/zbwgkPpBVYHlNBhmtiQEcG6UjtKH2sloIV33rk9AlzNRlltf4QSdTNSgCSqQ4Bx
	L8M2xBTx1najSFidS9XmfwwqiR3KYUgwUXfqheIa5XpM0u16/M+3/cLNS4T2F++zY5isQ8GIJSr
	5D3uIuWPFipU9hMQrKy24i83hK38OKFVxguC1G4GRsCSvwBTGg35lDqXrHW1zw89/9D/jH75MI4
	yYXesVhiFWgMNa1JVjWTFS9tRYQTlQbjWgC+5Vmgtts6PrQwrIUcLi5+bGIr8fwCGeNVycoCVBJ
	WlnnWNa5xNeKuolAc5QRWYXUmEYAiJ7c6puMKnKot0203/IXawhh1YOCpje68
X-Received: by 2002:a17:90a:d603:b0:38f:5801:cd76 with SMTP id 98e67ed59e1d1-396463062dfmr4753108a91.3.1787613046848;
        Mon, 24 Aug 2026 16:10:46 -0700 (PDT)
X-Received: by 2002:a17:90a:d603:b0:38f:5801:cd76 with SMTP id 98e67ed59e1d1-396463062dfmr4752994a91.3.1787613046247;
        Mon, 24 Aug 2026 16:10:46 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32827662702sm1308530eec.10.2026.08.24.16.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 16:10:45 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	brauner@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: fix OOB pointer arithmetic in cifs_to_posix_acl()
Date: Mon, 24 Aug 2026 18:10:30 -0500
Message-ID: <20260824231030.3502884-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the ACL_TYPE_DEFAULT branch, cifs_to_posix_acl() forms a pointer
from the server-supplied access_entry_count before the size check that
bounds it:

        pACE = &cifs_acl->ace_array[count];     /* count = access_entry_count */
        count = le16_to_cpu(cifs_acl->default_entry_count);
        size += sizeof(struct cifs_posix_ace) * count;
        if (size_of_data_area < size)           /* too late */
                return -EINVAL;

The pointer arithmetic is undefined behaviour before any bounds check.

Add an access-ACE size check before the pointer computation, matching
the existing guard in the ACL_TYPE_ACCESS path.

Fixes: bd9684b042dc ("cifs: implement get acl method")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifssmb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f5aad5f61dce..fdcdebba8b69 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3345,6 +3345,9 @@ static int cifs_to_posix_acl(struct posix_acl **acl, char *src,
 		count = le16_to_cpu(cifs_acl->access_entry_count);
 		size = sizeof(struct cifs_posix_acl);
 		size += sizeof(struct cifs_posix_ace) * count;
+		/* validate access ACE count before pointer arithmetic */
+		if (size_of_data_area < size)
+			return -EINVAL;
 		/* skip past access ACEs to get to default ACEs */
 		pACE = &cifs_acl->ace_array[count];
 		count = le16_to_cpu(cifs_acl->default_entry_count);
-- 
2.55.0

