Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0CE3E5591
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 13:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776175175; cv=none; b=ByhYDTz6y73cfslkIj+ys7B/fV3dQhTRdB+syHR81HjqF78aTjRp55I7gjbkCPCCk4K87mcUpsCQvbItkO+Vc5ED7Gs71RR6E0AHXJPZG+GH4YBs+nh4iyAT9LGSYEaJpxLFbwYpn5gFAKgK1OIE2D7htQTLAXsmbumCwVbHRbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776175175; c=relaxed/simple;
	bh=7fs/qpQj7CViKJpl1xKhLVHakBiwsBbgCOkyBzjRtuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7ByMzyl4DWajCvpeJIcS3LrV+gfiJTkbmAQJD4fDGxkinxQUt5LfNT4D07W21PeYrbq76cNHZ/6dmIstZBOPJm4lKtei82hN5Pr01L4/yW7Ak/uCbNhuqsO2SAcAkmBja4tIlFbEJclMd16cu+NKjLlpkTK1OO7onH1RMzVFA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZEmUOAo8; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZEmUOAo8"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b458ca2296so16962765ad.0
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 06:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776175173; x=1776779973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4CeNnh5BjM1nRomeWQoA26EkMPBAyik+6iryoO/A02Y=;
        b=ZEmUOAo8xufoXmZ4mO6c4MA4b92tejf/1ABlU/sPvr6+oTRZ8YthFxjIzoA1VRZE5k
         0nSKSvRUoPXUrM9tWdr4xcFcnbcHga6c82CG1KI155fA39Id9Ci62ZVWmYyNSGhlME7M
         Bs+PvcCJ+PI77S9Odh172MuNFIBWJ9gsSn/21DfEa5O4jEWv3MaoN41W08Yz4kL3+QLw
         zIiTdTPcBE+RsC80Hdq9Wx1n1Y+GTPFne6FgeTPL3Sc7be+S2NyvZHTH3Ba73m1UbdUw
         tWd5Lzrj4fmN/r2QDIyxf+x3ij0apRpovz+iMAEm0q2TuSXa9+ICGfMlxPipwYirMOXX
         /WMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776175173; x=1776779973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4CeNnh5BjM1nRomeWQoA26EkMPBAyik+6iryoO/A02Y=;
        b=U5DaqsrZNvrvAJvhIgJedv4VkJTRKhIkXa1oQ59qXpA7h69PSeJ0CCkYZD1QwI6TJj
         ATkO+d5h1JiJNYgLZ9rnpTaqA1FJkSatqmisC8FJS+j2VSDqyCSOmkm8PuGNpSzwMVa8
         FH9ItS6on70LzyMOtnNkPXI5bJnuvF6LaLatcZ6p3ua4leLM2oR+sP2r+jZ6X/YejOVk
         5EOwrqowtl2YBDnbvNYdQQ3M27jix2ffgnKUV0TvO6PYpEEG9eUF9wrlMcqV34ramqch
         ZFZEEXlmeL/77F4XdnJY3UeV8q9n3aToKt0eTRsgZcIkpb28WlAfg17A+oFZ8o1nefab
         S4wQ==
X-Gm-Message-State: AOJu0YwkmqO8hIH4iVFOSydfzHJw+iWCC1MNwjSN311dJ71jpKXPCtq+
	VdOFntpV3fCThNXX2ehGANh5qvz36y+9lCyhxPbS+k5TaGzSe8IeXLTcmL9a5Q8km5w=
X-Gm-Gg: AeBDieuZyMhGzz9Z5m4IOCXuRJzJtmYh2fsA0FDlTBSGuZhjcAIRDQAf12x8evxebD6
	voMlagXt24sV00m6q6N2czSSj9LmfjQIuYB/kBYkUrayF8A6YwWdy1buproYHBIlkf1i2MZfQKw
	VzL5UUl22+godQVGqd18CrrT0wYCHVtUyxE9+TbsJzcYA5PjqQdZ4O3S3HnPJtLK/5zVbLj3gH/
	AtkdppmGqarTFBeBbfgcLgR3MkSKR1QxpLKtXlyGRgIj0EnSaqWWfqABvtZPOnKTxxAr1Aa3jGN
	bs8Em8oeU1EvUM+ox4Wz1SNLNTntWAwRHoVtk++h1ZDv8fh/SbVRXSeAfLs5aTB2x05BN30ECow
	SpEhQzJHUVy0t2idn6ENgHqMsJF30ii5ph+A5jknU3EluRFpXTeaw54XWP2zm86QCAHUsKdFHfN
	n2RwZYxMR2EHm5lFQtctzs0l0lNAeo30q4dT4L9+mM1nyT6bgkAQ/I
X-Received: by 2002:a17:903:1ac3:b0:2b2:5ec6:dcf6 with SMTP id d9443c01a7336-2b2d5938b38mr173244845ad.8.1776175172888;
        Tue, 14 Apr 2026 06:59:32 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.184])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b4612e60dasm59779895ad.38.2026.04.14.06.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 06:59:32 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 4/7] cifs: define variable sized buffer for querydir responses
Date: Tue, 14 Apr 2026 19:29:15 +0530
Message-ID: <20260414135918.279802-4-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414135918.279802-1-sprasad@microsoft.com>
References: <20260414135918.279802-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

QueryDirectory responses today are stored in one of two fixed
sized buffers: smallbuf (448 bytes) or bigbuf (16KB). These are
borrowed from server struct and are not sufficient for large-sized
query dir operations.

With this change we will now define a new buffer type specifically
for cifs_search_info to hold variable sized responses. These will
be allocated by kmalloc and freed by kfree.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h |  2 ++
 fs/smb/client/file.c     |  2 ++
 fs/smb/client/readdir.c  |  2 ++
 fs/smb/client/smb2pdu.c  | 14 +++++++++++---
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 709e96e077916..8d089ba08e3e5 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1394,6 +1394,7 @@ struct cifs_search_info {
 	bool emptyDir:1;
 	bool unicode:1;
 	bool smallBuf:1; /* so we know which buf_release function to call */
+	bool is_dynamic_buf:1; /* dynamically allocated buffer - can be variable size */
 };
 
 #define ACL_NO_MODE	((umode_t)(-1))
@@ -1907,6 +1908,7 @@ enum cifs_find_flags {
 #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
 #define   CIFS_SMALL_BUFFER     1
 #define   CIFS_LARGE_BUFFER     2
+#define   CIFS_DYNAMIC_BUFFER   3    /* Dynamically allocated buffer */
 #define   CIFS_IOVEC            4    /* array of response buffers */
 
 /* Type of Request to SendReceive2 */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index a69e05f86d7e2..6a1419d59ed5a 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1546,6 +1546,8 @@ int cifs_closedir(struct inode *inode, struct file *file)
 		cfile->srch_inf.ntwrk_buf_start = NULL;
 		if (cfile->srch_inf.smallBuf)
 			cifs_small_buf_release(buf);
+		else if (cfile->srch_inf.is_dynamic_buf)
+			kfree(buf);
 		else
 			cifs_buf_release(buf);
 	}
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index be22bbc4a65a0..b50efd9b9e1d2 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -732,6 +732,8 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 			if (cfile->srch_inf.smallBuf)
 				cifs_small_buf_release(cfile->srch_inf.
 						ntwrk_buf_start);
+			else if (cfile->srch_inf.is_dynamic_buf)
+				kfree(cfile->srch_inf.ntwrk_buf_start);
 			else
 				cifs_buf_release(cfile->srch_inf.
 						ntwrk_buf_start);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5188218c25be4..49dca84b169e6 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5625,6 +5625,8 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
 	if (srch_inf->ntwrk_buf_start) {
 		if (srch_inf->smallBuf)
 			cifs_small_buf_release(srch_inf->ntwrk_buf_start);
+		else if (srch_inf->is_dynamic_buf)
+			kfree(srch_inf->ntwrk_buf_start);
 		else
 			cifs_buf_release(srch_inf->ntwrk_buf_start);
 	}
@@ -5644,12 +5646,18 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
 	cifs_dbg(FYI, "num entries %d last_index %lld srch start %p srch end %p\n",
 		 srch_inf->entries_in_buffer, srch_inf->index_of_last_entry,
 		 srch_inf->srch_entries_start, srch_inf->last_entry);
-	if (resp_buftype == CIFS_LARGE_BUFFER)
+	if (resp_buftype == CIFS_LARGE_BUFFER) {
 		srch_inf->smallBuf = false;
-	else if (resp_buftype == CIFS_SMALL_BUFFER)
+		srch_inf->is_dynamic_buf = false;
+	} else if (resp_buftype == CIFS_SMALL_BUFFER) {
 		srch_inf->smallBuf = true;
-	else
+		srch_inf->is_dynamic_buf = false;
+	} else if (resp_buftype == CIFS_DYNAMIC_BUFFER) {
+		srch_inf->smallBuf = false;
+		srch_inf->is_dynamic_buf = true;
+	} else {
 		cifs_tcon_dbg(VFS, "Invalid search buffer type\n");
+	}
 
 	return 0;
 }
-- 
2.43.0

