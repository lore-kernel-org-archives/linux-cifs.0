Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D080382367
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 06:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776753616; cv=none; b=KY9j8qVfEms8oZ3QU4epAldlc6qIhyZx0tv8XBOTqHhYHtNPV5M7ZfoOpMviCO9Y9iOZUEDOrmnoBBC6yMs5McuvT2F+e4zz1RQfrHrl3KOjgGl3hKdszKJoaO0JVu0eWlYziFqcE8ZxPr/fBqTArdNVxyvzk2mW2Ze8Z9DbHkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776753616; c=relaxed/simple;
	bh=7fs/qpQj7CViKJpl1xKhLVHakBiwsBbgCOkyBzjRtuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1O5W2wmcrwsPQjVfLDXPbrA10bx0AXh8/N4O2cmpirWeeM42W7S9GYFYC7qPsxXRvSbSmNYszrcQaH+R2GKDo6mkTUPyC2RkUf78Ca8V57CJaXc6zeXg4D86sB9GbfvFcRI9nyl5dVh/xjmtrhCfpgCUVBZIUBAiGsfXPstyic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LXn/U81g; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LXn/U81g"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c70c112cb61so2588495a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 23:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776753614; x=1777358414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4CeNnh5BjM1nRomeWQoA26EkMPBAyik+6iryoO/A02Y=;
        b=LXn/U81gWSKCGN+SfQbzySDGqSsSDUU+23nwcb7EUyTQ/LqMXWwwmAZqOewiq5UkAW
         Dbf3hjvAKHAUWs77kzL7+hHCvWrFXdfNVw/ePPcSEqTPcXAJ4dO7m8wiy8I3eRPLkuXI
         SY9vBo5lP9eYcx6oQJyzoDQLRZvYHWFczijpoonMGbhcnHUqobrwD8imqCLKh3zDA9C8
         e8hjCJugANyhRFpug3MXwIXaXiMdiXnSLiq2bkIkDqbm9apWwelByUciYc8fnB6/w0fP
         5kRdETj9OEMHh4pxJmvSoft73mAv/BjopzYxQLSEOknaJrVwgI332jUHdbRwT+j0NxI/
         XtLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776753614; x=1777358414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4CeNnh5BjM1nRomeWQoA26EkMPBAyik+6iryoO/A02Y=;
        b=FRJsC3gi+iBspdN9sumqLyKOJnM1iGUJGhwBjoUB80LIkhoFGJZD6gGRSgKT7cXB/0
         hlOfbio3koeMdpXIDtMF6hbL5UPqSTDK+40VVhO5mgmV/OUedKRIzzbSrevQbFmTRMKY
         pVyDzLuAwG111BOHp5GMM4UsjocoKdntPOt/JRzDiiV1dqvoXRKHhqVgyvKfQoqG+0dc
         FPRuonn8E8THvdQp/p5b0YscGTVE0fFHSbvvC/Ax+Gun2D/umjfCa0WKCIt7Dqn9yC1/
         7b7i9szUMYEqFEEGfO5+MgQOg6z3doxAtdYb7aoz5fc7hPWbGTScWyj+d7KLrW4hR27T
         SFNA==
X-Gm-Message-State: AOJu0YxY3qvk8xi2Iqd9uK/gONVbC9PjsKkURpxZYUm7LVF4FYKoE7OH
	g/0KzmWQU3S5Pi5t5cuu0I5yd0D6ch2z/dNvViMcJAng3dsRTqYOxcXTkFtSvx1WDIo=
X-Gm-Gg: AeBDietl4r8WmLfKiUc96dTk+ytkmNr5BMcrTDRArbzcj2wk+DS6mXPbR1rPqGJqoIq
	Sr4Z0XukFam2Rg7dj3GOqGSNHEkUnXm+9wT9GsHvEmFn3olItKYtEV322dxqVWO1yqC0MK7AUid
	ZENZgTPGlrG6knpWp1IwbrkoLifJiEK7/36bFW7yJdNljRi9rIexXb4kz/OIjvmlIUKoRsC+T5c
	a5a0J/a7PyBFUQIK85Mbu/Ax/LcZIln/KBrpZtg8Qf8C+HcXEIeAOu2biyXZUFX8/QeA/lGjW1v
	TXo3m8U/B7lFkGFjfkjEq9QT2JujmmCvhppA5gDMgGEznHOe6oRAUgPP/5kxDj8gEmBL5tQKeFn
	/ThvIV91cahGoFkskaPTRTpf7KaQqGn0g1KyR57U2/XfPsdYXM96zm6uZ52GDLWpcW1FoPsxqAY
	TwqSybTS7b3XoUEZaOAAXpRaJOQKIA5kWSR7k1IokkucOwU3svScGgI8HDV4UxuaxM
X-Received: by 2002:a05:6a20:12cf:b0:398:ac0d:9a0b with SMTP id adf61e73a8af0-3a08d93976bmr18359927637.50.1776753614526;
        Mon, 20 Apr 2026 23:40:14 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.184])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7977031729sm10032811a12.25.2026.04.20.23.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 23:40:13 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v2 4/7] cifs: define variable sized buffer for querydir responses
Date: Tue, 21 Apr 2026 12:09:52 +0530
Message-ID: <20260421063955.99164-4-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260421063955.99164-1-sprasad@microsoft.com>
References: <20260421063955.99164-1-sprasad@microsoft.com>
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

