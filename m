Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC313769FE
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 07:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607139; cv=none; b=WD6xLPyV0HmZGTdIH6iJcQBCNkTBPJuLEFgjmMDbiAS8Q/vRs0V1qIrvNmiMnPNklfhqdQU8sssE8QUS5GnIbS/dK6H6PAoyOOn3efT9JJ9U6hJsy1cx431fWAgXDZYdp/NsOhyAiFmDrGSt1JcgVu4kxm3tVaqziLSGwBkgUto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607139; c=relaxed/simple;
	bh=zf6Wr9y1zfNQ1mcaAxfblI4AbOEqkhreDlGpCRyxuyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKqeOmaUhIto3mbeH3frI3ULrj9JBVoJPpbSXN8CIuiwH+vS/IvRWclWEF0+j6QUI+TGzTn5u+WLm/AgFid26lUvIrEbvdP2BFY2DGaQKc+CArdYE572eKRW2qxcrb+i7/56Y4neUaMTKh+FlNbJt0YQn8E/3FVEhW0hZWW1HFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pXgSuPwC; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pXgSuPwC"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cea3004256so23222005ad.0
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 00:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607138; x=1787211938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V4TT4vASaoNjxdNkcJy0oxbt8P6KkuX59xKLfqRuGQI=;
        b=pXgSuPwCwjGIhIqaK1QuzyxR9BEPbwltGijLpFUup8a/5H4/lWyxGeUOguFWTgq6xK
         eSIhbk6SXPjKbTmZwJIFj8SMcoTBrpq6zdZvzFHxhPXOuNJDz/17Q4upnRi0uuphB5h9
         Plz8wJzp3AJPgA95UNpOpyTZoojXhab+qHLOivogF5maMUNk5JpQ3gu8hVL1N7zSOA74
         ChtCeEOR4UyXbHZi7yB7yT8RDuKuRhsxmL9e8gapQHKuJd2zGOOBE0Gr/2YJenalbT7z
         AtPTYP09IYEm+pHOag29ktpBCJY2sS3eUBphNGvX3JKESt98MrnRhVMEaRdt0YMJaqBu
         7Dbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607138; x=1787211938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V4TT4vASaoNjxdNkcJy0oxbt8P6KkuX59xKLfqRuGQI=;
        b=SQtSHCudSmofToNyz34QH0JJljwLJNNRSFX0Wf3436c7yOjfLOujOJpCUqWj9/gTQy
         PWNz2xxXkZBD/PoTXi7CH/3oj4W9CDqoYmbTfniJJBgX1LlFO35I8WcSYaLKiBSkKMJ+
         8NYbV5UxvQxxwbRp/HQu+wIVs/Bx547QO6KVSxIUIVWo/lZNCVxW9tCo81sc2nPR1Bm5
         VI/FOoFuy5yP+D+uGVnQMG46R6+Mvlp+j+Fqe2+3i6XoHaQBPgLoxWJuUvMMfWQT+fJM
         Is5l4dMvUzt1zfcNexadLXWvelyh3pBkvfooLp6xZPE/bDN1y8nDafecQNk6nYWDxPcj
         ympw==
X-Forwarded-Encrypted: i=1; AHgh+RqJaUC2EH6EOd34nECB/sG/eRU4BxwWgf1nM7TBC8Ly8NfFFTqxhi0aPA+Pd6Pf+aVzyr4TUAYaNx9Y@vger.kernel.org
X-Gm-Message-State: AOJu0YywFK4OqpDa5ydBzf7AM3P9ky4Abe3y+9atxjzLXvFcuee54bab
	j8Si8c8b1Ap8OdWVn6ifF7Z+S7seCYulqY36tSnsT95yxx+Zp/f34Tzr
X-Gm-Gg: AR+sD12ZUf1T3gF392QLBJacMKKsD27VY3HFsm6F9GGL1Rk8JS9AaSmol99q7Hq/FrB
	TFJxUwHQwtLxtTMdDb25KJwxTtr2/qF/GjIfV1z9umUcenuhbraTvTMbeedqeXEvPehKLA41s0o
	1xc+QQ6beLZ3Qn6QX8etKZUoQmGA48VLOutOBbv/q+REwRuIVbpj2R/dMoOIgfQUAnC3V5V7vGR
	AANrcsmUBgIc9ETYPV+8B1OlOyt8c2569vtenkEBUmf+fqTXGe9iwz+7Pf0cUIVhfapLVCLa4m9
	lagmKX4aW0+/YyUlpLPY4coTmNov11VYnPcrwpEoWszfQJII1rGf27wd0iUiNVBpy3LMr+07R9u
	SgsEqKPZXz2Wh1KtWn5DKQRettFsfUK9fnvUDthVEdJdyp3HhsUEoFUZt+TVFFKMoNMzv71REIu
	PqR8Wcnyg2M1EC+ZbSkLFBLH2aF56NOvdBVInzZnJc8HAXgsyjRVsFHJqXNC9PMN0342v0fUvrK
	I/LY+mqp08F/MJxRtpBXb+wcvMKaePmtdb3uYBq40RqkR4Hm94QcQo6xXLoT55SWV9e45AkHQP/
	H7cJlyoLOnyHYoQq
X-Received: by 2002:a17:903:2b0d:b0:2ca:9d5a:8b6c with SMTP id d9443c01a7336-2d37d57c45cmr46985765ad.5.1786607137895;
        Thu, 13 Aug 2026 00:45:37 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ec022acabsm4587594eec.27.2026.08.13.00.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:45:37 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH 6/7] smb: client: move struct tcon_list to cifsglob.h
Date: Thu, 13 Aug 2026 07:45:16 +0000
Message-ID: <20260813074517.607275-7-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813074517.607275-1-rajasimandalos@gmail.com>
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
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

