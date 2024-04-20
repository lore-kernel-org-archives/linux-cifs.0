Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C59663E
	for <linux-cifs@vger.kernel.org>; Sat, 20 Apr 2024 00:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713573864; cv=none; b=mmjQqP1WxU/um+a3oZqCr34AH7G0aNecqIVpTCpd5BgZOXn0JMVrdeFl5nNn3Hpbnk1dkITz4d2xn7Tb9rpB5DJwBXpHNvKQxNsGAJQj3eNGYDnB87AUdmydarZ0hDgWwfRSk8i0+be/F3Ym2XGCatVI4LVkvI9/pyx/cNNoeXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713573864; c=relaxed/simple;
	bh=j2pcebCxufoux91u2reVH/Wn9XVZUHTOC9BYSU8FbZw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LCc8otiE79t9sN4p1H9aEgi+LrQ4BVJg1VMu685AJc/ynJCf/FRp/qNgaSsrC8I8NyjVtujrpnE8qp5Xdwid5mrXf6sMysPNILU1uumaDC2bExZ6Zg59u9PD5/FSvXVPj45M69ngdJnuFWxqceZxJzFygX0qvkyeEUUX3djL1+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2a3095907ffso2078347a91.0
        for <linux-cifs@vger.kernel.org>; Fri, 19 Apr 2024 17:44:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713573863; x=1714178663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3c/n/KZbWxE5eabbcvmudSmxIL6Xk6nK3s0o+32vEeE=;
        b=ZA+oLWnDnffTBzyZ2sgtZfrIIII0qjUSJy4yFoB9kMkQVkWDquGEu52YMMm6ytAWJ5
         KY6oKnxmHeQu/waCxjdXdjjxJIpfuAck5Ju/KVI+9K/ZRtb9fJ/ZsskZz10XTR5+W/jl
         WStxLKjoIIcsudL2P1CiTEz00+pJjku9O5r78Q+r/6mFGfGtv2S73InGYh+7HFNJibji
         M9myPzKU29t+h8ZNRtyAtFzNHc+ePflZsel/ud/9msZbDcJwDQRymEhq7zb/42kzcvkj
         15+iO7vmSLZbtsZiXbmXzNEFeFqntaeE1oZaUDbblGOVACSTjDvGgYZlg+JltIwaZHV0
         2O1g==
X-Gm-Message-State: AOJu0YyyzteD0fLyLvVauLIlLcxpS3Y+uUz/N1Agp/mzr6cqHu89XdGy
	dMCjVVoIimV4WPdIOIoVUOrnNAN/4g6W7JeIWZQDJ8s0rtzk1ltppAwgTA==
X-Google-Smtp-Source: AGHT+IHS5576GXgrl98Y0fPOEb8Ow3N1Vyzhr7ZU4pwIlqoAeW68obg2UtL3xz23XCHaP/ejzIVqPw==
X-Received: by 2002:a17:90b:88f:b0:2ac:40c8:1ed3 with SMTP id bj15-20020a17090b088f00b002ac40c81ed3mr3812901pjb.5.1713573862545;
        Fri, 19 Apr 2024 17:44:22 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id e7-20020a17090a77c700b002a55d8a99d5sm5405317pjs.22.2024.04.19.17.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 17:44:22 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/2] ksmbd: add continuous availability share parameter
Date: Sat, 20 Apr 2024 09:43:48 +0900
Message-Id: <20240420004348.4907-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240420004348.4907-1-linkinjeon@kernel.org>
References: <20240420004348.4907-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If capabilities of the share is not SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY,
ksmbd should not grant a persistent handle to the client.
This patch add continuous availability share parameter to control it.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/ksmbd_netlink.h | 35 ++++++++++++++++++-----------------
 fs/smb/server/smb2pdu.c       | 11 +++++++++--
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.h
index 686b321c5a8b..f4e55199938d 100644
--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -340,23 +340,24 @@ enum KSMBD_TREE_CONN_STATUS {
 /*
  * Share config flags.
  */
-#define KSMBD_SHARE_FLAG_INVALID		(0)
-#define KSMBD_SHARE_FLAG_AVAILABLE		BIT(0)
-#define KSMBD_SHARE_FLAG_BROWSEABLE		BIT(1)
-#define KSMBD_SHARE_FLAG_WRITEABLE		BIT(2)
-#define KSMBD_SHARE_FLAG_READONLY		BIT(3)
-#define KSMBD_SHARE_FLAG_GUEST_OK		BIT(4)
-#define KSMBD_SHARE_FLAG_GUEST_ONLY		BIT(5)
-#define KSMBD_SHARE_FLAG_STORE_DOS_ATTRS	BIT(6)
-#define KSMBD_SHARE_FLAG_OPLOCKS		BIT(7)
-#define KSMBD_SHARE_FLAG_PIPE			BIT(8)
-#define KSMBD_SHARE_FLAG_HIDE_DOT_FILES		BIT(9)
-#define KSMBD_SHARE_FLAG_INHERIT_OWNER		BIT(10)
-#define KSMBD_SHARE_FLAG_STREAMS		BIT(11)
-#define KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS	BIT(12)
-#define KSMBD_SHARE_FLAG_ACL_XATTR		BIT(13)
-#define KSMBD_SHARE_FLAG_UPDATE			BIT(14)
-#define KSMBD_SHARE_FLAG_CROSSMNT		BIT(15)
+#define KSMBD_SHARE_FLAG_INVALID			(0)
+#define KSMBD_SHARE_FLAG_AVAILABLE			BIT(0)
+#define KSMBD_SHARE_FLAG_BROWSEABLE			BIT(1)
+#define KSMBD_SHARE_FLAG_WRITEABLE			BIT(2)
+#define KSMBD_SHARE_FLAG_READONLY			BIT(3)
+#define KSMBD_SHARE_FLAG_GUEST_OK			BIT(4)
+#define KSMBD_SHARE_FLAG_GUEST_ONLY			BIT(5)
+#define KSMBD_SHARE_FLAG_STORE_DOS_ATTRS		BIT(6)
+#define KSMBD_SHARE_FLAG_OPLOCKS			BIT(7)
+#define KSMBD_SHARE_FLAG_PIPE				BIT(8)
+#define KSMBD_SHARE_FLAG_HIDE_DOT_FILES			BIT(9)
+#define KSMBD_SHARE_FLAG_INHERIT_OWNER			BIT(10)
+#define KSMBD_SHARE_FLAG_STREAMS			BIT(11)
+#define KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS		BIT(12)
+#define KSMBD_SHARE_FLAG_ACL_XATTR			BIT(13)
+#define KSMBD_SHARE_FLAG_UPDATE				BIT(14)
+#define KSMBD_SHARE_FLAG_CROSSMNT			BIT(15)
+#define KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY	BIT(16)
 
 /*
  * Tree connect request flags.
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ee4b2875a021..355824151c2d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1988,7 +1988,12 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	write_unlock(&sess->tree_conns_lock);
 	rsp->StructureSize = cpu_to_le16(16);
 out_err1:
-	rsp->Capabilities = 0;
+	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE &&
+	    test_share_config_flag(share,
+				   KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY))
+		rsp->Capabilities = SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY;
+	else
+		rsp->Capabilities = 0;
 	rsp->Reserved = 0;
 	/* default manual caching */
 	rsp->ShareFlags = SMB2_SHAREFLAG_MANUAL_CACHING;
@@ -3502,7 +3507,9 @@ int smb2_open(struct ksmbd_work *work)
 	memcpy(fp->client_guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
 
 	if (dh_info.type == DURABLE_REQ_V2 || dh_info.type == DURABLE_REQ) {
-		if (dh_info.type == DURABLE_REQ_V2 && dh_info.persistent)
+		if (dh_info.type == DURABLE_REQ_V2 && dh_info.persistent &&
+		    test_share_config_flag(work->tcon->share_conf,
+					   KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY))
 			fp->is_persistent = true;
 		else
 			fp->is_durable = true;
-- 
2.25.1

