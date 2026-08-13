Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C55446859
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 09:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786614193; cv=none; b=s2WOWtb3Ztk+wG71qq0B/Re6S9ctdVoicpbTOnqG+dPfxNxjA2V8FiwolomPJX366B36hBX91RptMlytJ/E+oBcCw9c2myqh/p3/8WLlo55A9E23O6NVjC0f8RkT4vM695Vmtbv2Mx6McSxm9CAn7DmrP1ZW/tuSeclA6Q/FR58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786614193; c=relaxed/simple;
	bh=zf6Wr9y1zfNQ1mcaAxfblI4AbOEqkhreDlGpCRyxuyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxDW1mdyGkTsgRoK2ZktZjDJCHrOscxl/Ine/gesAD56JugiG061AX1M89FWPq5gbb0goQIrEfWfHeGPsVCPUpi9HXXPC47kERZWIC9pHTcAApOM7fVOrEBPwVcWclVerH1pgynzkY9heAqQt7RN+miXWGYZXnMhzvjulU3TpyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UD18HZbL; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UD18HZbL"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso2762333a91.2
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 02:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786614192; x=1787218992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V4TT4vASaoNjxdNkcJy0oxbt8P6KkuX59xKLfqRuGQI=;
        b=UD18HZbLc7sTD+S4TLZ5RPex457YgNquI85LQ8sHCBL4k6oWRwgkyUO2pt4082Mf9I
         u7mPU0+jCaqbx/URgtH2d4COdCwY9wrKdju3FUhUOQ5s+0k/XYQ5T3t/mNjcpfVj7Zu6
         JHqQTAo448BLLDbBAUKnYI4WWHdwfbO88T3VlFoY9/9gz8rvfHHN6FFhN+H6OeLO6aji
         f8V4nQQr+Ca0UpkrjH5rwTN/s+NWAUwFDkQyq5+XFnpzfMZ+Ffinn65cH1pUJWS13uxD
         mQvFYTXxOtHMVk6y1g7QKPLDqvcEI23Lg4iFrH9aAa0uFvFkyPfDMIx4moMPLuOQBpTc
         Zfhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786614192; x=1787218992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V4TT4vASaoNjxdNkcJy0oxbt8P6KkuX59xKLfqRuGQI=;
        b=AIGwd7RqLpk5P+LjL0+8vNTmxbHGTIOHtsWegfQJV1WHqijzI8zCCnqS5sLpRMKpCM
         F0jtHv/53ZyFsuFtUDo19b9qcvXYpxZcz5a9ZgDbL7GA0x8F+vCgSQQRW/hF94P8c37e
         pwRfgb4cYSEEF41tjbMVuaJ6szFJt5obBkhgEV+3PCZ0Nv6W8T1LF8n6/3NoNWz8uFgm
         GNWZ2sVp1v13TPSEj7SJDThze6+vtO1RiMkHrafzmklQ9gTvyeA/799zJWuFIjLCt30K
         UtewEeyiIUOXF9QqfuZwYFJxOftaLd/J6tcD9KiG2aiV4+6z39Fej/JAzofa6t5lNVxn
         gnRg==
X-Forwarded-Encrypted: i=1; AHgh+Rqy8wOpC8Ez3KOMj8ZLfZMt8HanCY7+q2TaAcNQPT4uOkYi6MkvNcErll0wAS3G3DPL93iV9LhPlQPs@vger.kernel.org
X-Gm-Message-State: AOJu0YxsxvOnKlnL69JEuI46K9xy6N770lbSFiQE4iMMIo0Aes2GfGh2
	EAM25eQDX50WRxBkeqYUIG5CF0wFRglVjFhjwdWglyrjkJcNjOhXxpZO+1UP7A==
X-Gm-Gg: AR+sD13cc17gUT7PM1xfHyB3Itmz2DhrwGxiuElRvPzVf5RVIjdvnyzQeODDeHD3OmB
	W4AL8yQHnibP7rm8yo6f/sAuwid8pzWpjimyWfFQiIy9IRQ6Ujo7jyeiIIgvlwdh8CoLSlvSA7j
	IQ6EXaM+vWMwRQOzGoMz66sy5l+9nacq/PkgyDxg+7YGD5TubEXHJebprrRtBHUFCTr6DXShSAS
	jdlGrmKxNrpUssh0vbzDudKTGHsneCL5VA9huGm2lgt0bAzAxC8KjY3JUL4kS3/Ckxu89yEewNr
	r71bwhnMrG8QRDFFuUbd2E1NgKs/sOk+9fC6HQWS0OAC2569XMqfZLxfXskvjmzitBtWO/kpeb7
	QwMZNCWEmMp9fsXzmazAJfIc2CEsB1oriEfFkYmJMxtte2Z7zm3E1E4p/q79UDjrkjocz/GYpOg
	pqInZYnbBqc8t/QrV1lBahb1gOsp0OsQAUXyqOPbV2tvH6N1v0KsPJ0VwbBxNy8A8H33jePrbXl
	2CJv12a2auInlJqL+kjVCU1H1IAV5vZVrTX5WdKhX5g0g6U2HvZiTwYX9h1XgReBWMz+Qzn8mrP
	Rn+FufxEUDF57e18
X-Received: by 2002:a17:90b:1f88:b0:38a:c3f:3b87 with SMTP id 98e67ed59e1d1-3931e26fbeamr6095175a91.12.1786614191750;
        Thu, 13 Aug 2026 02:43:11 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ebc760524sm6409135eec.1.2026.08.13.02.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 02:43:11 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH v2 6/8] smb: client: move struct tcon_list to cifsglob.h
Date: Thu, 13 Aug 2026 09:42:49 +0000
Message-ID: <20260813094251.666373-7-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813094251.666373-1-rajasimandalos@gmail.com>
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
 <20260813094251.666373-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

struct tcon_list is a small list-node wrapper that pairs a list_head
with a cifs_tcon pointer, used to safely iterate tcons under a
superblock outside tlink_tree_lock.

It is currently file-static in misc.c, used only by
cifs_close_all_deferred_files_sb().  Move it next to the similar
struct file_list in cifsglob.h so that other _sb() iteration helpers
can reuse it instead of redefining the same shape locally.

No functional change.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cifsglob.h | 5 +++++
 fs/smb/client/misc.c     | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 79e4e84f8985..3bd2a588e7c4 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1812,6 +1812,11 @@ struct file_list {
 	struct cifsFileInfo *cfile;
 };
 
+struct tcon_list {
+	struct list_head entry;
+	struct cifs_tcon *tcon;
+};
+
 struct cifs_mount_ctx {
 	struct cifs_sb_info *cifs_sb;
 	struct smb3_fs_context *fs_ctx;
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 46e1382e8e04..7fb38f92cd5a 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -28,11 +28,6 @@
 #include "fs_context.h"
 #include "cached_dir.h"
 
-struct tcon_list {
-	struct list_head entry;
-	struct cifs_tcon *tcon;
-};
-
 /* The xid serves as a useful identifier for each incoming vfs request,
    in a similar way to the mid which is useful to track each sent smb,
    and CurrentXid can also provide a running counter (although it
-- 
2.43.0

