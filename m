Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AE5DF
	for <linux-cifs@vger.kernel.org>; Mon,  4 Dec 2023 05:46:14 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1cfb4d28c43so15264355ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 04 Dec 2023 05:46:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701697573; x=1702302373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PeR37fcAbicitRZp7Gmnp01Jn8WXjAkJGJbK/59zB4M=;
        b=W0IOpbfXmAN5h5FgVNijmv8kgDa2fL0Ffz/2CNpape0udU/vKhcCA61iuzaQRmIYjH
         yKdFfNdJopnLCtkinwb9B7qhSoK1vAqEZ9aRh2re1GPr4mCyL6mo59xFAcKeCMnXQCAa
         S4V0WTf7vM+AJ+mZxK1MITexFl0plOHusfkBYYVh8WFGF+TOqDGmx3uzap4sot0z6hiK
         V/SR+GWnLlw5dgjxEYhZBHD71BESpHXg4nJmyVVG4U5WVoKduMdrwUoVKjJp5V8XFJHN
         JLdlG7JnBQANaoToNjD9mc++mv49f8O93+PZoWkSFh9GgXee8a8f4RYDuRoUCJEm2hkx
         ph/g==
X-Gm-Message-State: AOJu0YzzMWIPTvCNdd87BikUrbAFkA6FbPX8McHpbUORrF875ie8FwKK
	ykMabnh753Nw79TaU4Mc5wcksq7LMes=
X-Google-Smtp-Source: AGHT+IGB+Do3ptMqQLeMA9MtS/UtXb46G48qG2uMsf8NVIDJjIINeMSaaCc9AQUQCdPWU6bPHXX6PQ==
X-Received: by 2002:a17:902:e851:b0:1d0:9471:8084 with SMTP id t17-20020a170902e85100b001d094718084mr1193798plg.99.1701697573254;
        Mon, 04 Dec 2023 05:46:13 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id m9-20020a170902db0900b001cfcbf4b0cbsm8428475plx.128.2023.12.04.05.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 05:46:12 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5/7] ksmbd: lazy v2 lease break on smb2_write()
Date: Mon,  4 Dec 2023 22:45:07 +0900
Message-Id: <20231204134509.11413-5-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231204134509.11413-1-linkinjeon@kernel.org>
References: <20231204134509.11413-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't immediately send directory lease break notification on smb2_write().
Instead, It postpones it until smb2_close().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c    | 27 +++++++++++++++++++++++++--
 fs/smb/server/oplock.h    |  1 +
 fs/smb/server/vfs.c       |  3 +++
 fs/smb/server/vfs_cache.h |  1 +
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 55ebce4e91c0..d6263599ddd2 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -396,8 +396,8 @@ void close_id_del_oplock(struct ksmbd_file *fp)
 {
 	struct oplock_info *opinfo;
 
-	if (S_ISDIR(file_inode(fp->filp)->i_mode))
-		return;
+	if (fp->reserve_lease_break)
+		smb_lazy_parent_lease_break_close(fp);
 
 	opinfo = opinfo_get(fp);
 	if (!opinfo)
@@ -1112,6 +1112,29 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 	ksmbd_inode_put(p_ci);
 }
 
+void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
+{
+	struct oplock_info *opinfo;
+	struct ksmbd_inode *p_ci = NULL;
+
+	if (!fp->f_opinfo->is_lease || fp->f_opinfo->o_lease->version != 2)
+		return;
+
+	p_ci = ksmbd_inode_lookup_lock(fp->filp->f_path.dentry->d_parent);
+	if (!p_ci)
+		return;
+
+	list_for_each_entry(opinfo, &p_ci->m_op_list, op_entry) {
+		if (!opinfo->is_lease)
+			continue;
+
+		if (opinfo->o_lease->state != SMB2_OPLOCK_LEVEL_NONE)
+			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE);
+	}
+
+	ksmbd_inode_put(p_ci);
+}
+
 /**
  * smb_grant_oplock() - handle oplock/lease request on file open
  * @work:		smb work
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index b64d1536882a..5b93ea9196c0 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -129,4 +129,5 @@ int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
 void destroy_lease_table(struct ksmbd_conn *conn);
 void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 				      struct lease_ctx_info *lctx);
+void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp);
 #endif /* __KSMBD_OPLOCK_H */
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 9091dcd7a310..4277750a6da1 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -517,6 +517,9 @@ int ksmbd_vfs_write(struct ksmbd_work *work, struct ksmbd_file *fp,
 		}
 	}
 
+	/* Reserve lease break for parent dir at closing time */
+	fp->reserve_lease_break = true;
+
 	/* Do we need to break any of a levelII oplock? */
 	smb_break_all_levII_oplock(work, fp, 1);
 
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 4d4938d6029b..a528f0cc775a 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -105,6 +105,7 @@ struct ksmbd_file {
 	struct ksmbd_readdir_data	readdir_data;
 	int				dot_dotdot[2];
 	unsigned int			f_state;
+	bool				reserve_lease_break;
 };
 
 static inline void set_ctx_actor(struct dir_context *ctx,
-- 
2.25.1

