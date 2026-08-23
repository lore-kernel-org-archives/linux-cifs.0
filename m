Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126503A3E98
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 18:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787511528; cv=none; b=JwSDBF6wVLvtvwuyVLgZdK/YgfKP38PlvkRrHZDFRlOV1RtdAJsycn+RjWfKG3OKeX/8f3eh2BUzkHU4LV/9lA+hz17H67DcwJNHrLIL2CvBGzFUvZIskEiJvxSAV5KNoDkcy+BKDQCQuCuJFt2/Pri/CLJXV/Q+SgACujy82D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787511528; c=relaxed/simple;
	bh=EhvDNaCN4ln1V4VGK64WbgDj53Eqm+A//1Pik0bbpSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3TNTjDyfCXBCYUtlMef17MdRPl3G201YcJYfeFmKxloZuHckXr0qqMD6jJ2/TeFUA86AWmatSzoy/pDGBFJutNwBaaLThuIVHDFVnPdbPkd7uCODhSx5lgzegN8Xc2Btux0xR8W81LvQm47qProk2tQy8Ds4L2jssNl4xKqjKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VZYdDnJU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=pjS2ireH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VZYdDnJU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="pjS2ireH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787511526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIVhAaiWo8zlaMZvR5jj4DeJp4hplmxQu8aOHpcJh6Q=;
	b=VZYdDnJU7Or5e63pSfx3MgCicGyHTroiT09JERqM32T43tnD9+1f7h/0+lvQg6vX87ySA2
	WK4n+0XR340AeSMXClxN+kRg5wbMisu7t7VGYEyxmZk7Fp1EeA5KyxiaVzl6dRssOVqjsR
	GZDsf6kzvMk8QnVyYhH//rS/zivps6E=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-HGUkAhuSNxCIPJSBy74_4w-1; Sun, 23 Aug 2026 14:58:42 -0400
X-MC-Unique: HGUkAhuSNxCIPJSBy74_4w-1
X-Mimecast-MFC-AGG-ID: HGUkAhuSNxCIPJSBy74_4w_1787511522
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7e9dee2f7b5so7285800a34.1
        for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 11:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787511522; x=1788116322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PIVhAaiWo8zlaMZvR5jj4DeJp4hplmxQu8aOHpcJh6Q=;
        b=pjS2ireHtnP5aFLmoHbqCumnqL41dtMlglCI2tV2sPg4jmq2A+ixWdRFHhVhJbzm/x
         u0uCtPXOEjh5THN0aO+hsJBLSWLqK7qOCgKxMsTub47CE7kC0YATYrTqc1tGk5l1yu2A
         UVpnrnbXTnNwDrqz6CInAlAuSZ0rpcUtykH4FI8yHCATypuhdBxvxL0WK5874XgHi3Jk
         glSrUE1+9em8yp0jswJcB95rpkKDvHJwjfcFpcXW//r2aTTDg++zkJSfs3vYoXSfBpEV
         SpwmTVXR/WrxD7viaKdJY+Ls7DdYTuQEEFTIuK7/QqV8JGmb6XN9ScCtXjl9100Up03I
         L7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787511522; x=1788116322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PIVhAaiWo8zlaMZvR5jj4DeJp4hplmxQu8aOHpcJh6Q=;
        b=iO2kBgLRSrLEqD5l8IzR2mccq42QyCanoit6ORRyWPGMds6pEWFdHgRx1OOUAtI6nW
         9nCTDk+rc/agrAZmaRBSMhW5S3BZENARkczfu/rwzAPsRdKsyFrNwvogMo23xsZKP2vn
         78zYTWPCZG5sMacgQ2nnV5E8ErxR7HOndvtAFAV5TQq58630ZlgHJnOsaMfV2GF1By0F
         j0i0ExSXjpLliEr7Oy+1N/GO+fYk/MdiuBJjuMTU1PW0eRhV7v/zLRzm34/eVRkjmW5o
         vHmVAe431Ac7yI++7EGm6pAez3G9GEA4F2eDIB6Wl/q5HsynmweT5q+YUiL1HSj5x1O7
         Tldw==
X-Gm-Message-State: AFuF++lbN6ArNiB4Ibz479iwiybPwQfgIaSXUf1n7mrlxHHG30KBiJzh
	65wKKM+fFEuLpL6LfCBaVvf/XaxW4+/gfbpSfbYXgAoLu/G/j6dZj2JuK5qTPGEt9no2HUEP1zb
	UYpFhf55eZX5sX4tfK754KWZxfQivM+9B46TeApgrtPWaGct+jO2Rqn1IVecVN+1PSQK9rhKahK
	uEC40MUocU+WRtupvtcAgACuoNOYesQ5DUBRcudWyH6CmULkU=
X-Gm-Gg: AR+sD10jFkdpwHIDHUeBUQFknROqHHwTUZvGvanNOvFzJuLwJzwvwAAH+SeAHu2YR3i
	74nxPekE5D10LO5TR6ZGmIoDqUGJM2cjm5APydIS2jURnwySruZcJAWx2gXl0f5CjBYh1boZJyc
	67OQPsKrIv0DxSdrabFgebPxKQB/DAps/g6g8sPGffoBcRpMABgKozovi3RCRlq23dLwNN93ATV
	xN7PhOT1kDSDu7bow2seEsHCFqBW6Q/mS4iuO7X4pfQWNTMym/QG0d9aTgor3lo+mTkBp2NjMBN
	QFcwJCamY7NVcpwxQ8M0wobIITOX28eg2f70oniuqHAeshG56mRGxQR1PFhaXyotCm4r60/dCRd
	Nsvre1LSvOO/I+Y79IFK3oAXv9We+eKu6yQj0xNbqEpjtwNOJP027pHE8HqRxmFS5QA==
X-Received: by 2002:a05:6830:4995:b0:7ec:6749:f38d with SMTP id 46e09a7af769-7f46132209emr22697919a34.0.1787511521877;
        Sun, 23 Aug 2026 11:58:41 -0700 (PDT)
X-Received: by 2002:a05:6830:4995:b0:7ec:6749:f38d with SMTP id 46e09a7af769-7f46132209emr22697876a34.0.1787511521340;
        Sun, 23 Aug 2026 11:58:41 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fb1db63sm2518710a34.12.2026.08.23.11.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 11:58:38 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 05/11] smb: client: fix missing lower-bound on Next field in parse_server_interfaces()
Date: Sun, 23 Aug 2026 13:58:01 -0500
Message-ID: <20260823185807.3115901-6-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260823185807.3115901-1-sorenson@redhat.com>
References: <20260823185807.3115901-1-sorenson@redhat.com>
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

