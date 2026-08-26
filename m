Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DF93101B6
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 15:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787758349; cv=none; b=lcDILT/spZGW1wWIZDD0rCk69/Nhs64tSKt0x0LnkGo6YnRN1EqgSmOzl6zT4JP8eI99T5jXOOcALdduBZdds6wVhD+6vpj6m5v4RjwRB49sWrO1jYWD2u17F95wdcnE4p/974tjlaOLiTravykf0L+gB7eQVvOdmTWHBiuFPrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787758349; c=relaxed/simple;
	bh=EhvDNaCN4ln1V4VGK64WbgDj53Eqm+A//1Pik0bbpSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzU8qXh7CwL6zz2L0//MJMnIj3wfLRh/Ccwn49O2JIHDiFHcpqm8DaKiECWMb0sY7JSZpeTKGfS4NHp2hIWVmPjc9K49eMNXn1Uod9aKZxGGYeZJ3g3uIoosPnvkTiDK/J3RS1Ru9pUHD26K4Sj966rfZ7IWOBsbDiXLMsMYOxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aG+2tqj4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IXWQvPtB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aG+2tqj4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IXWQvPtB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787758344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIVhAaiWo8zlaMZvR5jj4DeJp4hplmxQu8aOHpcJh6Q=;
	b=aG+2tqj4/Y3CPyDElO6TjepfUvOIiPsoXnQUhG/7AKjimyxHV+QR5bhZn4Iq4NCF3T6EaD
	Fw6K8wdx32xQ9bt5UaLC6iGvSxKiDcmF2hY4pMb1c6M3VWzgX2e106tJp12oOM/5G5hHwV
	tVymb+h15O1I2HBIDWHieM0Q/cV5HpA=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-7CZ-eMcvNp6ttMebMbyd0A-1; Wed, 26 Aug 2026 11:32:20 -0400
X-MC-Unique: 7CZ-eMcvNp6ttMebMbyd0A-1
X-Mimecast-MFC-AGG-ID: 7CZ-eMcvNp6ttMebMbyd0A_1787758339
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-66c70f73f8dso2693516d50.1
        for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 08:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787758339; x=1788363139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PIVhAaiWo8zlaMZvR5jj4DeJp4hplmxQu8aOHpcJh6Q=;
        b=IXWQvPtBInzAHelSwoQ0ocQJsh28NgJtKecYWFRdIe0U4m4Nb8uzvsVXd9wQ/8jNif
         1xnzLpGWRGjcuSxnPezB3VZ3W9tK886te+nQGORJS6AYIU0Kxn0OiqvU50LTpMtKI8yS
         i7NB8+QcEblRnazutgCQxC05ShsQUkE0uJ0j+2ST9+BstQSQs+H++L5P4z1caW8mDtmg
         VuHP+pXBu3ThJg1VLRr3zJZy+bzRydsNV1jJjNjHj1Q+jXlaiZyVOd5+aT5i9tg/hhat
         NyIxMb4RyPNgyumu7L2B4XQSsgjFmDWo4ZH2cvIwqVFPJ400K3N+bAPwZ5O/2nZ3pTov
         +q/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787758339; x=1788363139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PIVhAaiWo8zlaMZvR5jj4DeJp4hplmxQu8aOHpcJh6Q=;
        b=D6Q2zb7tmDsyjRdj/zHNmk5Jxg1Km3k98SNxfDKqSE+k6KUFkcyiQQBYgEku/oHr5I
         CzWRuK8Q/pKbWRxOTlCRJM5jmTbwSUr+2icMglSvoEE1FMknQTaOpcWVij5ws3pNFaDh
         BZki78mYxyjaIZ+vQwOQz+PK4sKfK90L7bLpscG33Vpk+Y8wzVwiAp9fILmAobRf/Yst
         yIZb+u8Qm7gcQpr9AgNDAJDsFxyqyPeKTw/Wg7bwKZzoCKHhtrMrvuiSUWnCOkKzP/t0
         xxsADwYmJClC5ES2TE/XvljyvqwDVm6+qagscq27g9EPpNQe3mvcQMQObC5Eh+HZjgQ8
         73Tw==
X-Gm-Message-State: AFuF++kbZqppT6SCNJxNEqKytzFNuyC6HVFcHyttJDx6PvH+A8Q8IHdt
	2u52JplsAdq/WIq1KA/yRg0gGWc34PPadmSHv4yGJF9zYEjI13Q9WHI6tlx/tE4fI+iTY2TADH0
	BfLuqHCi8tYfyuRTZu7Y0CwojaX93lpzlDXVbKBAcp7kynAh2inyKqMhjMjD5OInFw2GOPk1jFB
	kh1NxWJiH3DuAWosAN6b29EWRm2WaX+qfWDgTBQjLXULLAjA0=
X-Gm-Gg: AR+sD11x3PW09+WOEdhVj2/NtbwRf3O4QvaqOynC8pr9FbH74iyaLgAUjeP2nliSgIP
	KD92yE2SQM8GnriG+NnGBx434DNvsnmP37LH0HDYDGpVk2cMaf+NO/IkVfO1BoDeUMlrDTyUIE+
	keLKOGA8ec3I7pTGn500kEtkHexBBQJg4TaZrRflUEsDxuNFTZHpelzGlhQFXZzpp8pGJTvlWmx
	8Me5vfByl6qGuwuXaBwVuqDnluZf0j87i7bt020IDICvGnz9fkI3lvmNimSNOT3wJzfusyp/Zye
	2w3asJH6PozPAkL5oR0V0GeNAmZjAeGw3I1jhF06aeuZYiZC85rwgqyWr4HbkrcvlpDxu8jFe6I
	KSXyQzzJ7dim28KrYhLRW9LNeKFVq23678giH23iM/gYSB94Gsr+qjtiNWvfoJXQ8eg==
X-Received: by 2002:a05:690e:dc2:b0:667:a285:7624 with SMTP id 956f58d0204a3-66d257cb15dmr2890852d50.35.1787758339464;
        Wed, 26 Aug 2026 08:32:19 -0700 (PDT)
X-Received: by 2002:a05:690e:dc2:b0:667:a285:7624 with SMTP id 956f58d0204a3-66d257cb15dmr2890778d50.35.1787758338012;
        Wed, 26 Aug 2026 08:32:18 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66d24592f24sm1598209d50.6.2026.08.26.08.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 08:32:17 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 05/11] smb: client: fix missing lower-bound on Next field in parse_server_interfaces()
Date: Wed, 26 Aug 2026 10:31:41 -0500
Message-ID: <20260826153147.4112943-6-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826153147.4112943-1-sorenson@redhat.com>
References: <20260826153147.4112943-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_server_interfaces() validates the server-supplied Next offset
against bytes_left but not against sizeof(*p).  A small non-zero value
passes the upper-bound check yet advances p by less than one struct,
causing the next iteration to read misaligned, overlapping fields.

Add next < sizeof(*p) to the existing bounds check.

Fixes: 7d34ec36abb8 ("smb3: fix for slab out of bounds on mount to ksmbd")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2ops.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1bc3f8266eda..9065c94e5ec6 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -785,9 +785,9 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 			break;
 		}
 		/* Validate that Next doesn't point beyond the buffer */
-		if (next > bytes_left) {
-			cifs_dbg(VFS, "%s: invalid Next pointer %zu > %zd\n",
-				 __func__, next, bytes_left);
+		if (next < sizeof(*p) || next > bytes_left) {
+			cifs_dbg(VFS, "%s: invalid Next pointer %zu out of range [%zu, %zd]\n",
+				 __func__, next, sizeof(*p), bytes_left);
 			rc = -EINVAL;
 			goto out;
 		}
-- 
2.55.0

