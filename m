Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E21F38B
	for <linux-cifs@vger.kernel.org>; Sat, 20 Apr 2024 00:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713573861; cv=none; b=nsO8QrzH5uhg5chVsZgVNNmWTUSuqIq40KV6QXEj2br8eT06t07aVAouvHjzBlynfWfabKdljZpruuqrbkof99CuMal9R1l8esfD5MCBLz6GVJWqRTeMCj29+8qs/up1yQjNdWnKJAtuolaB3fVdyy1MSwbAj48LSjt3A8gLiQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713573861; c=relaxed/simple;
	bh=NW+P8PTL7FI5UKU3OM9gWwMGzvD0sG4o/qkWPl8czJY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M9UHORaJ0jBJ9Sk4DRWsXQyOIuPYmg+vlGL5rn2WpE4e/BiOvYXK2s7RNFSVrHS3nYHNFS7f6U+ig2wVSsBHA1fOlxONtWRvhvmYgOQ3WnSqhnFtJVw/biJ33lbaGED0ArDNkvKx83uGbSwzVFBH6GdodCrSUwsKdsnu+FOBj78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1e4bf0b3e06so25090985ad.1
        for <linux-cifs@vger.kernel.org>; Fri, 19 Apr 2024 17:44:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713573859; x=1714178659;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kClqf59vhRPbaijRUW+m9DbgufhofG2WdcwyTgCW9QE=;
        b=tY2OCSkZXkJck/9o9x4T/8Fjj9/rW+PeH+y4FTFtT6rejdHLg6GDA/UfiyCxOfP2BJ
         NioW9Y7p0TE5BUeMB+EMyAq5taBqO3colYPtCF3PA9hQDVaErvR3ieoL82pd2OVm13Bs
         TtBRzvHBAuJUgygbdvjd2UefyReZjjxaGjyXJCwALxNKBToysJF4z2sJQlwIS0/wKJw+
         TuSaS/XNQCu+CIm1fUB/LaTah4/7hW9p6CWXyfXHxQPYmrXSsp4o6WYwmgq/nHJbd5hs
         h7mMVzVfgST1vbiMixWU2fXYFzzYKldpuNrdZKNQNuz9lfDz52NCVcJ1UIzLHOzOknXh
         bb7w==
X-Gm-Message-State: AOJu0Yxu30MdniMjBqNRXhu/9tO66xt1myzDP61rLot2/Xsk2L24B0ap
	RbojWPhP1BInlRKsi0i1v+FSXJZ1lqIi7/UpKoyCcyeIEB8250v37fLgWg==
X-Google-Smtp-Source: AGHT+IGF0/lKwIZ+iyiP1jodwhwr1zJeVFNkpjZlcjxTkKXnwabOmMGf/FWBH5/cFQn5n9NmSGXjjg==
X-Received: by 2002:a17:903:2308:b0:1e3:cd8c:d370 with SMTP id d8-20020a170903230800b001e3cd8cd370mr5064040plh.44.1713573859381;
        Fri, 19 Apr 2024 17:44:19 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id e7-20020a17090a77c700b002a55d8a99d5sm5405317pjs.22.2024.04.19.17.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 17:44:19 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/2] ksmbd: common: use struct_group_attr instead of struct_group for network_open_info
Date: Sat, 20 Apr 2024 09:43:47 +0900
Message-Id: <20240420004348.4907-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4byte padding cause the connection issue with the applications of MacOS.
smb2_close response size increases by 4 bytes by padding, And the smb
client of MacOS check it and stop the connection. This patch use
struct_group_attr instead of struct_group for network_open_info to use
 __packed to avoid padding.

Fixes: 0015eb6e1238 ("smb: client, common: fix fortify warnings")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/common/smb2pdu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 1b594307c9d5..202ff9128156 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -711,7 +711,7 @@ struct smb2_close_rsp {
 	__le16 StructureSize; /* 60 */
 	__le16 Flags;
 	__le32 Reserved;
-	struct_group(network_open_info,
+	struct_group_attr(network_open_info, __packed,
 		__le64 CreationTime;
 		__le64 LastAccessTime;
 		__le64 LastWriteTime;
-- 
2.25.1

