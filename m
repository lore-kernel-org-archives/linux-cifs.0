Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6078F385521
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 21:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789335922; cv=none; b=j6Yzi0HEXaSWCv6aCBcsSny3llIF5GYPwHA7IqEahZJH6sTLZlFGWw1cofS/+LWT9FegSu06blSz9k0n/cpO2L76BkOsKQ8aHvXpquX/Kn5KNI6mbNu9tFFBXzsCgrQfS2PMDD5Q77u9OayXeXvmM/riyYInvV6SMNW+h9plUE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789335922; c=relaxed/simple;
	bh=4zCloib2puLCf5z4fuIkh2FycdVT5JedBfx4vl3oUZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OF6aQCw7lU9+OMo0IpR+y5I0ZRgKIYh12Wu3hNsgv1+As+0QURrd9HI0jCpJ6aFWhR1lOWuEXCkg+ZhOAQInAQMUTzdGCXG7NhneIeu3BjsB6q9TgDox43c/zJJ+BOxwt0Qu92duvTQISqqiF85kU1NEDrf5N6OOT2hdVIS6qWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UNO/WbJ3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=npSwwsAy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UNO/WbJ3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="npSwwsAy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789335919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3sKwO9/x5Nx61QLckrIYySPgWI2cpKIvUfOEXgYJSL8=;
	b=UNO/WbJ3nFA8fEyuGzeL4MaKqUq1xofxSpoOVzT8aVP83KY4MVyvcQrlcmXLmucPxBe9ro
	txc5r4oDp2cUzSBE/JmFM8CFYS463/JFvOJ1YtcnNVmOZ38f6INPtu12wkU6SuINjjk4re
	/5RTI0bSLGpXxQKMZ5xpDZ+1mHHXs30=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-wQF2UUV8MdqEweP45_HFSg-1; Sun, 13 Sep 2026 17:45:18 -0400
X-MC-Unique: wQF2UUV8MdqEweP45_HFSg-1
X-Mimecast-MFC-AGG-ID: wQF2UUV8MdqEweP45_HFSg_1789335917
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-90e8472ee1eso55587016d6.0
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 14:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789335917; x=1789940717; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3sKwO9/x5Nx61QLckrIYySPgWI2cpKIvUfOEXgYJSL8=;
        b=npSwwsAyT93vBL4S450qpbsCjBK98ETZJdCuH9Qv0qglHHvofAPW/Pm/yyhdZoqgme
         cA1PRv25V81Py90N5gYMFof7AjY0XxnSGoAJRxm9xcgCD8udR7mSwh26n3HuVAHdULYF
         hEIeQ7sKAqEqfPZPU6vIu2Yv3iL1//zSO/CusKLmbvgnDXCitd/OX66MK4tt7uRTu/+d
         JufqykuA6ouBsCy8Bt+sLwo4mAz3PFfR6QJ8Cc6pxWBzDmZwCd3kGUeQfQyL9Q5BQnh3
         P/qONjoqWR79RY+yerBjryPGlYkE62nu17igYRmC7lDFEo2X1rLwokuG6I9ydD4bIjDl
         pKBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789335917; x=1789940717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3sKwO9/x5Nx61QLckrIYySPgWI2cpKIvUfOEXgYJSL8=;
        b=HkM9bLCQXN3uitMIMpXuYLnRBlvg4X28OY2S1iMSFZwiBAxu4YsMbVDWqwg3Lftrga
         /4+Dw8cSKhm4DWL+tdaq4FJLEXnYTqF4Gevf9RTuGTbiMOgrDIxoCk+0Myql2XoKARxE
         TzyeRjafZVCNRAvTSEEl8VuX0lyZso6AVhZuXedOZd/ESEtJsInDJPH2O1vm1f9h9P0v
         GTcgJ5XwbHznPnZeD0cjJtVvtn1OfAzG+jzpPTTbCIjY4ew0CDvIcOYnnKjtNNZixrgk
         ViT+MyMRh3qX89VqM3b0SzHjY4L2wVM7/2iUNDnNlwycqvcsDZ4lBfatAR3WTPMiEuTF
         T8Aw==
X-Gm-Message-State: AFuF++k5ripgu122n/ghHsN69nV+dgg6YrbgKyjnaPihNHVr5HYEmCvX
	iW3QOD1NmobNjGnDT8L3Lar5lTV09/4g2EYbdc2t2rUvihO40TqX22U9SyAkqqsL3qrEAGYkTJg
	k6OeDOPlzCIiAU9ceJmJQDsisuEwNQLF36gZu5Ltz5Ur39s2AMuVKIEFrsbonv0cbx/+L4jJ0nO
	IFyqO22rwuGUILI9nDPLRo+dAHc3DabyvfLdo15WergROzU/c=
X-Gm-Gg: AYBFou1suYajCV9g16t/6Yiz4NRH+waOLvQman6PAwYjIVyJidanm6N+amWGQb/PDIU
	S3xFyYw5p9TE3TTaikLIJ8fYENv61hvpfqI8ErOPgI1noAGK1FI6iWnv07khaNIPGLHyVK4n8Ea
	ECv+N0cKNYakX5gfQmWqZwo9Vxfozxzl/IXzLmsS4uMrE+T1bYLqFuy/MzLOkHSR2YvC/oUKmaV
	pMjhhH4Pzm+PokHhVDPUCJh+Nit4T7mIqLpaGJUS0/MtZ7s43ygik0/C0QKQRa6vZdqbBxolVWX
	feK23f4BQ8F131jfZ5JdokYO7DYEi1Bj2mVXp8jdWGv8znrgDN7bvJf/iZOCNVnuwGcG2bFKuHb
	nqbPxNz+X75ebQipn+0DjSTv1ZZcX45gmDsitTThughfX4jvOg0hRx81myxsjJhEXEw==
X-Received: by 2002:a05:6214:e88:b0:912:1fca:531d with SMTP id 6a1803df08f44-9122e4cf515mr97866d6.2.1789335917488;
        Sun, 13 Sep 2026 14:45:17 -0700 (PDT)
X-Received: by 2002:a05:6214:e88:b0:912:1fca:531d with SMTP id 6a1803df08f44-9122e4cf515mr97546d6.2.1789335916999;
        Sun, 13 Sep 2026 14:45:16 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f49444bsm78581126d6.29.2026.09.13.14.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:45:15 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Subject: [PATCH v4 02/10] smb: client: validate minimum PDU size before smb2_get_data_area_len()
Date: Sun, 13 Sep 2026 16:45:00 -0500
Message-ID: <20260913214510.3071370-3-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260913214510.3071370-1-sorenson@redhat.com>
References: <20260913214510.3071370-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__smb2_calc_size() calls smb2_get_data_area_len(), which reads
command-specific struct fields to locate the data area. However,
smb2_check_message() only validates StructureSize2, meaning a truncated
response could cause smb2_get_data_area_len() to read out-of-bounds.

Add smb2_min_pdu_len[] to track the size of the fixed response struct for
each command with a data area, and reject PDUs shorter than this minimum
before they are parsed.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2misc.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 9068175e57cd..22afc203a1ef 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -85,6 +85,36 @@ static const __le16 smb2_rsp_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
 	/* SMB2_OPLOCK_BREAK */ cpu_to_le16(24)
 };
 
+/*
+ * Minimum received PDU size for commands whose fixed response struct is read
+ * by smb2_get_data_area_len() before the packet length is validated.  Must
+ * be non-zero for every command where has_smb2_data_area[] is true; zero
+ * otherwise (guard in smb2_check_message() is skipped).  Keep in sync with
+ * has_smb2_data_area[] above: adding a data area for a currently-zero command
+ * requires a matching sizeof() entry here.
+ */
+static const size_t smb2_min_pdu_len[NUMBER_OF_SMB2_COMMANDS] = {
+	/* SMB2_NEGOTIATE */       sizeof(struct smb2_negotiate_rsp),
+	/* SMB2_SESSION_SETUP */   sizeof(struct smb2_sess_setup_rsp),
+	/* SMB2_LOGOFF */          0,
+	/* SMB2_TREE_CONNECT */    0,
+	/* SMB2_TREE_DISCONNECT */ 0,
+	/* SMB2_CREATE */          sizeof(struct smb2_create_rsp),
+	/* SMB2_CLOSE */           0,
+	/* SMB2_FLUSH */           0,
+	/* SMB2_READ */            sizeof(struct smb2_read_rsp),
+	/* SMB2_WRITE */           0,
+	/* SMB2_LOCK */            0,
+	/* SMB2_IOCTL */           sizeof(struct smb2_ioctl_rsp),
+	/* SMB2_CANCEL */          0,
+	/* SMB2_ECHO */            0,
+	/* SMB2_QUERY_DIRECTORY */ sizeof(struct smb2_query_directory_rsp),
+	/* SMB2_CHANGE_NOTIFY */   sizeof(struct smb2_change_notify_rsp),
+	/* SMB2_QUERY_INFO */      sizeof(struct smb2_query_info_rsp),
+	/* SMB2_SET_INFO */        0,
+	/* SMB2_OPLOCK_BREAK */    0,
+};
+
 #define SMB311_NEGPROT_BASE_SIZE (sizeof(struct smb2_hdr) + sizeof(struct smb2_negotiate_rsp))
 
 static __u32 get_neg_ctxt_len(struct smb2_hdr *hdr, __u32 len,
@@ -233,6 +263,16 @@ smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
 		}
 	}
 
+	if ((shdr->Status == 0 ||
+	     shdr->Status == STATUS_MORE_PROCESSING_REQUIRED ||
+	     pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2_LE) &&
+	    smb2_min_pdu_len[command] &&
+	    len < smb2_min_pdu_len[command]) {
+		cifs_dbg(VFS, "SMB2 command %d response too short: %u < %zu\n",
+			 command, len, smb2_min_pdu_len[command]);
+		return 1;
+	}
+
 	have_data = false;
 	data_area_overlap = false;
 	calc_len = __smb2_calc_size(buf, &have_data, &data_area_overlap);
-- 
2.55.0

