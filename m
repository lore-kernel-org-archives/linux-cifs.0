Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C047E2D130C;
	Mon, 30 Jun 2025 17:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751305255; cv=none; b=dMqsfi+3/txdWermeU/hkgMjyEgr2PPg94Ay1JWs9WfBAdXXOfxyPILVaK2MXUg7+Uny5G1pv0sVeuKVyuT7Zf8xxQseeKC5AcRCvfHpD+5BEljfEBab4WfVOiz1na/QJKF16OBEKcuf6tY4q5I1tUKNjDJDdB5reAPsoW+P92s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751305255; c=relaxed/simple;
	bh=lfP2FHWP/O5W+3GNh4TnpDGGr/QX9oS8+iL5LscHsPk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MlSkEWA9ck/loJQjgiFv22zhVa4vaahUw9EzdqPnyNX8YFNlmI/hnDfv6SUUo0qHewxJyMuTeQLso7OkPyNsK+fJ6iov1bbdgxmNdmLOHM4qnSeq3S1DuVMxepbXvUXjfk39PDNdMgJ+4Pqm/as2FTsFQbsL3SrR7xTqzSswbbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DBHsQzyZ; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DBHsQzyZ"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b31c84b8052so5880936a12.1;
        Mon, 30 Jun 2025 10:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751305253; x=1751910053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5POsxjRBKii8ak3c562uH2sc8k+/4ECyeM7umkTnQwY=;
        b=DBHsQzyZ9Q4XIjTGuwmtxjYdaKqLVdE1YVVw2dWkHuJPQB+R5sVIEumobMhAIUXV5M
         Ln0sOQ3h7xJNV654qSwO4Nxj8E5YuCQT7cZy/B9Baw7JO/IOpKgtO4I1kNljBjqKyJq+
         6U/xbyvrYk6DRJtyf/ZFnWece4Bs9grmaBRdPkQmpZ0xQP8KcJ6UKToDWvSguTVXo+n2
         87RlvHD0p8y2JDxRf3F0a0ogDXhv7kHEQq/VRVOt8PVgcOCGwvE7RzWk8NdTrBoXhzM4
         wMn5PBXtB+9GpTiIJfA7kbyTfrghl7S2TUaZQYwbGqnLywcvACPpiTtusqELDS20dD8F
         hf6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751305253; x=1751910053;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5POsxjRBKii8ak3c562uH2sc8k+/4ECyeM7umkTnQwY=;
        b=BPY8whKfsadbn47q7AE913lpIteyIH3Zf5DlyKiGm5Mal+GmEdBj5rBsWoHAtT6bsy
         8KsgWqOSFLE3SRH2g4o5iY1GU2+UcuunxoCy4mOL/ycu5mCYUT6VZUPTvupOunQI443B
         vq3x/XoK0SoAxzTdqxJuy0wyWhaqUP75KFMpfy7W3AfL16Y+D57wcqi56O61Vm9x+q3C
         73/to16pIqT7dgHb7SiGDVfWnc+7+xVWSVEOGQKLQk1EwadzGZxcSkVcmI6wb9vJ1A3P
         WhmjrTR1hankZgK/GHOOu9cRcjUXVDKwIjXDLTEOKnyGiHHZEMgkIBoElQpLFNQa1Y8W
         Lfjg==
X-Forwarded-Encrypted: i=1; AJvYcCVPuafzbWlMyb47tEMFdtD2BjBR8kyFv8MSINKZWMjxxuLLOeACKM3g1EGluOtuFUD8vkBJezcnMO89@vger.kernel.org, AJvYcCVuQx3a7wuCZuY3l9pmZqrOQLx+rj7NyG/ICU/xUPcFFPjjnP0HVpb6EO1sXIwHPhp54bT5BmAb@vger.kernel.org
X-Gm-Message-State: AOJu0YxBeR2MAQMgn+dvSFU9sR5zB8+v9lE70uRk6ooppVw+jWztfK7U
	SU6M1LtONsmoRWYD+xHtbtc0r++6E1Ir3YzLkZ7+O5o+wDxxjFN7zBW9
X-Gm-Gg: ASbGncuK0na+7PKWpQXrGT/JtMqY2sNPZ1sZsWnzMnF4G4oKOr571TFw/5hq1nm1qak
	Z6V0q8Xl7VnkOCkCVbuJS0AgASMMlpymMfD+XiiTYL7LcqPI4fMH7go5OBDJtqeH8Wlg66sR4qK
	gDxBpfzt5M1GLPrFk1v6Zp/UXksTfAWWOOO6qb7Cb0XIyjzK7q8xlT+qkUe3yennZECs/DiY/l+
	cbSfiSSqpXP55dvV3toNmIy8dDBaDojA7Qbbq4qi5QQjpzQmB4dKJE/MXIpZ6maAkFYS0MDaE6K
	Kl1k8eX0MqQ2RkBEs8oNlmhNwsW+Dkj0PCohUYXwpNhojl+zsEuiaZNuzsDgoqeDBdvp5NAOuFq
	LcQbPOBngGjLsQEeDxAhFuCPUpg==
X-Google-Smtp-Source: AGHT+IHnI2y0zb0xq0yD2yjxhxgGHbURwldavIuFzWhCxL/9A50uNzVPf4x/iLgvtziHSzTzD6/EiQ==
X-Received: by 2002:a05:6300:4cc:10b0:220:2bd8:cfd6 with SMTP id adf61e73a8af0-220a1a63177mr13268948637.40.1751305252813;
        Mon, 30 Jun 2025 10:40:52 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.40])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af557441asm10142333b3a.95.2025.06.30.10.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 10:40:52 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: pc@manguebit.org,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	dhowells@redhat.com
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH] cifs: all initializations for tcon should happen in tcon_info_alloc
Date: Mon, 30 Jun 2025 23:09:34 +0530
Message-ID: <20250630174049.887492-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today, a few work structs inside tcon are initialized inside
cifs_get_tcon and not in tcon_info_alloc. As a result, if a tcon
is obtained from tcon_info_alloc, but not called as a part of
cifs_get_tcon, we may trip over.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsproto.h | 1 +
 fs/smb/client/connect.c   | 8 +-------
 fs/smb/client/misc.c      | 6 ++++++
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 66093fa78aed..045227ed4efc 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -136,6 +136,7 @@ extern int SendReceiveBlockingLock(const unsigned int xid,
 			struct smb_hdr *out_buf,
 			int *bytes_returned);
 
+void smb2_query_server_interfaces(struct work_struct *work);
 void
 cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 				      bool all_channels);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index c48869c29e15..16c4f7fa1f34 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -97,7 +97,7 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
 	return rc;
 }
 
-static void smb2_query_server_interfaces(struct work_struct *work)
+void smb2_query_server_interfaces(struct work_struct *work)
 {
 	int rc;
 	int xid;
@@ -2866,20 +2866,14 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	tcon->max_cached_dirs = ctx->max_cached_dirs;
 	tcon->nodelete = ctx->nodelete;
 	tcon->local_lease = ctx->local_lease;
-	INIT_LIST_HEAD(&tcon->pending_opens);
 	tcon->status = TID_GOOD;
 
-	INIT_DELAYED_WORK(&tcon->query_interfaces,
-			  smb2_query_server_interfaces);
 	if (ses->server->dialect >= SMB30_PROT_ID &&
 	    (ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
 		/* schedule query interfaces poll */
 		queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
 				   (SMB_INTERFACE_POLL_INTERVAL * HZ));
 	}
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	INIT_DELAYED_WORK(&tcon->dfs_cache_work, dfs_cache_refresh);
-#endif
 	spin_lock(&cifs_tcp_ses_lock);
 	list_add(&tcon->tcon_list, &ses->tcon_list);
 	spin_unlock(&cifs_tcp_ses_lock);
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index e77017f47084..da23cc12a52c 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -151,6 +151,12 @@ tcon_info_alloc(bool dir_leases_enabled, enum smb3_tcon_ref_trace trace)
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	INIT_LIST_HEAD(&ret_buf->dfs_ses_list);
 #endif
+	INIT_LIST_HEAD(&ret_buf->pending_opens);
+	INIT_DELAYED_WORK(&ret_buf->query_interfaces,
+			  smb2_query_server_interfaces);
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	INIT_DELAYED_WORK(&ret_buf->dfs_cache_work, dfs_cache_refresh);
+#endif
 
 	return ret_buf;
 }
-- 
2.43.0

