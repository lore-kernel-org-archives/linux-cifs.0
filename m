Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C9614A627
	for <linux-cifs@vger.kernel.org>; Sat, 18 Jan 2025 20:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737230665; cv=none; b=flbatzWqeYj7W6GeVH5lwVqJ6M6HnyvIf5sXqkxA3dpykU4BQQvV3M+9o7xI6/J5f6AQeTLfCPiqKSWot0kDvKXU/Mp9sGcPh8K4jRDCezwFiYke3EZzg8+agvMj4QNWXEenEPvYu+Glu5y8FV49aGm8Ep2j8G+DH6dTV0Yq0sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737230665; c=relaxed/simple;
	bh=RhdgjStzVBqlo1m5evFdbM5745CIGO0VbOc67EK8h/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NUTbI5IxdzZgJYs25ZrzTI50Wm0vv7OkRb9t5B87U2kRJryWj4y0A9/28t4uU8Zpi7R6YTnWJBSA0io7+OAZYsiqAJJDFBi8p97ESmym6ji9jwXLVr9m0BjBYz1JSUTKyXpELLpa387aRPFOWRxI75Bgk3AgUDBiYbIUmT2fsxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LSca1tbI; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LSca1tbI"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43622267b2eso31281225e9.0
        for <linux-cifs@vger.kernel.org>; Sat, 18 Jan 2025 12:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737230661; x=1737835461; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XBADp6g93ZWQfjmIVv+lg8DGdk1UNRD39g0JZ3QtEoo=;
        b=LSca1tbIhuXBmU4Z1FiP+ramOylkZBgJvL+9/FfafIDthH6we4d56ssPzcNll+TK66
         lrEi6xKmrJt53DrF0nLoMBvqsnPWjrv1pPicj3XvgePhyuo1Yq5Y9lgKSd40AZx0QrUg
         LXHSnWGf5KiOgUn9za7FGfuDQbofVNO127Of6pjyzSuf6irqNgHfFg+oJ/bC+1bY2MHq
         CcE3dLHM7IERxI9U3eJPGBjQ7cDRZkvb7Ba09u+pafBE5jRA+s9H3itXSkZgHEvH6C0E
         rkhQ/nTd/2E/2mIa3pYYnle/oobqPI4qqXVy1DhhKlVB+XtTAD19tOh2krpfbVbVtkS5
         ksBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737230661; x=1737835461;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XBADp6g93ZWQfjmIVv+lg8DGdk1UNRD39g0JZ3QtEoo=;
        b=qsSp8l57UMQqp/a+mAV/9OCTnKm5AqHvMDawQJvH1vklLX5uHTyr93BsRL/JuhY4Qa
         +dHOHdwan4mxbeIG0BhnbiC9yN84VftEH3eF3DhX2ALCpr5Qa647/n5j+ZnsaL+7cfNE
         OljB6JkovsXo1kIkr53Upb/uujUHT9ajCiyKVZUJ9zmUq/JWqHssr8N0dtecEOWWivVC
         HVu34H9qTcqbKeLLhz7Brvv1MJj4n7MKQIis1xD0ntqzVeOtSQyPgE/CXt9b/8oxJwPy
         JQ5x0Gh7pHesvkO4RmXkCnhKoHr1uBCvCaJDh7ludBSxf5lh84S2wOQJip3pRkgd3gZY
         6YAA==
X-Forwarded-Encrypted: i=1; AJvYcCUmaOes/s0ZpalPFWyoQfWGcIwbFp2qCLeJ5Tqk2bj8O6u7s0hwGDdX16qKLWd4u4rX4KvXuW0ClA3w@vger.kernel.org
X-Gm-Message-State: AOJu0YyemIAQrb7poktknCtUymobSROAsgFg8Xr/N85JBiZp/Y0t87+8
	Z21bSSBE2DX/yBbw7fYvy3mqlO+5TuNkL6MWYj262WVotval235j
X-Gm-Gg: ASbGncuqzDyUIXNMUU/qVKuPUwm7Tku9v+Z6aIV8sJpQIk6K3Vg9X74FsxQd0c+1/OI
	2nmv8lnCU+1rOYwikFCQ3et7qVYyqhYSJiq+XoMeaJ2Q9MfN6imEYsOnIqbaedhrxYSbhmJ30Xk
	pxLZEhyiSkC4/Z9P9z+3LGpkLYd1qJ+heJIf1nLzM+AUoysocw0eT5MOwG+kzGxO3Qo1WXC9TK7
	Xus8+MbHGwR4G0G/3PLhZ5WNJ1mYP6ZZPWOfy3j46jy5N/XFWjwRZSJss1BzfXCp8eYT5uK/u1u
	WDM=
X-Google-Smtp-Source: AGHT+IEbettSL2aivUM7xzh0We2E6IcWPbek5Tbq8C2pRdifr51bEN8tgofFudLheBOrYQdZ6pqOlg==
X-Received: by 2002:a05:600c:1e1e:b0:434:ffb2:f9df with SMTP id 5b1f17b1804b1-438913f0a7amr75023575e9.17.1737230661407;
        Sat, 18 Jan 2025 12:04:21 -0800 (PST)
Received: from localhost.home ([2a02:a03f:e6d8:fc01:121f:74ff:fe57:106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3214fbdsm6081235f8f.19.2025.01.18.12.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2025 12:04:21 -0800 (PST)
From: Ruben Devos <devosruben6@gmail.com>
To: sfrench@samba.org
Cc: pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	Ruben Devos <devosruben6@gmail.com>
Subject: [PATCH] smb: client: fix order of arguments of tracepoints
Date: Sat, 18 Jan 2025 21:03:30 +0100
Message-ID: <20250118200330.21020-1-devosruben6@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The tracepoints based on smb3_inf_compound_*_class have tcon id and
session id swapped around. This results in incorrect output in
`trace-cmd report`.

Fix the order of arguments to resolve this issue. The trace-cmd output
below shows the before and after of the smb3_delete_enter and
smb3_delete_done events as an example. The smb3_cmd_* events show the
correct session and tcon id for reference.

Also fix tracepoint set -> get in the SMB2_OP_GET_REPARSE case.

BEFORE:
rm-2211  [001] .....  1839.550888: smb3_delete_enter:    xid=281 sid=0x5 tid=0x3d path=\hello2.txt
rm-2211  [001] .....  1839.550894: smb3_cmd_enter:        sid=0x1ac000000003d tid=0x5 cmd=5 mid=61
rm-2211  [001] .....  1839.550896: smb3_cmd_enter:        sid=0x1ac000000003d tid=0x5 cmd=6 mid=62
rm-2211  [001] .....  1839.552091: smb3_cmd_done:         sid=0x1ac000000003d tid=0x5 cmd=5 mid=61
rm-2211  [001] .....  1839.552093: smb3_cmd_done:         sid=0x1ac000000003d tid=0x5 cmd=6 mid=62
rm-2211  [001] .....  1839.552103: smb3_delete_done:     xid=281 sid=0x5 tid=0x3d

AFTER:
rm-2501  [001] .....  3237.656110: smb3_delete_enter:    xid=88 sid=0x1ac0000000041 tid=0x5 path=\hello2.txt
rm-2501  [001] .....  3237.656122: smb3_cmd_enter:        sid=0x1ac0000000041 tid=0x5 cmd=5 mid=84
rm-2501  [001] .....  3237.656123: smb3_cmd_enter:        sid=0x1ac0000000041 tid=0x5 cmd=6 mid=85
rm-2501  [001] .....  3237.657909: smb3_cmd_done:         sid=0x1ac0000000041 tid=0x5 cmd=5 mid=84
rm-2501  [001] .....  3237.657909: smb3_cmd_done:         sid=0x1ac0000000041 tid=0x5 cmd=6 mid=85
rm-2501  [001] .....  3237.657922: smb3_delete_done:     xid=88 sid=0x1ac0000000041 tid=0x5

Signed-off-by: Ruben Devos <devosruben6@gmail.com>
---
 fs/smb/client/dir.c       |   6 +--
 fs/smb/client/smb2inode.c | 108 +++++++++++++++++++-------------------
 2 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 864b194dbaa0..1822493dd084 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -627,7 +627,7 @@ int cifs_mknod(struct mnt_idmap *idmap, struct inode *inode,
 		goto mknod_out;
 	}
 
-	trace_smb3_mknod_enter(xid, tcon->ses->Suid, tcon->tid, full_path);
+	trace_smb3_mknod_enter(xid, tcon->tid, tcon->ses->Suid, full_path);
 
 	rc = tcon->ses->server->ops->make_node(xid, inode, direntry, tcon,
 					       full_path, mode,
@@ -635,9 +635,9 @@ int cifs_mknod(struct mnt_idmap *idmap, struct inode *inode,
 
 mknod_out:
 	if (rc)
-		trace_smb3_mknod_err(xid,  tcon->ses->Suid, tcon->tid, rc);
+		trace_smb3_mknod_err(xid,  tcon->tid, tcon->ses->Suid, rc);
 	else
-		trace_smb3_mknod_done(xid, tcon->ses->Suid, tcon->tid);
+		trace_smb3_mknod_done(xid, tcon->tid, tcon->ses->Suid);
 
 	free_dentry_path(page);
 	free_xid(xid);
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index a55f0044d30b..274672755c19 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -298,8 +298,8 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				goto finished;
 			}
 			num_rqst++;
-			trace_smb3_query_info_compound_enter(xid, ses->Suid,
-							     tcon->tid, full_path);
+			trace_smb3_query_info_compound_enter(xid, tcon->tid,
+							     ses->Suid, full_path);
 			break;
 		case SMB2_OP_POSIX_QUERY_INFO:
 			rqst[num_rqst].rq_iov = &vars->qi_iov;
@@ -334,18 +334,18 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				goto finished;
 			}
 			num_rqst++;
-			trace_smb3_posix_query_info_compound_enter(xid, ses->Suid,
-								   tcon->tid, full_path);
+			trace_smb3_posix_query_info_compound_enter(xid, tcon->tid,
+								   ses->Suid, full_path);
 			break;
 		case SMB2_OP_DELETE:
-			trace_smb3_delete_enter(xid, ses->Suid, tcon->tid, full_path);
+			trace_smb3_delete_enter(xid, tcon->tid, ses->Suid, full_path);
 			break;
 		case SMB2_OP_MKDIR:
 			/*
 			 * Directories are created through parameters in the
 			 * SMB2_open() call.
 			 */
-			trace_smb3_mkdir_enter(xid, ses->Suid, tcon->tid, full_path);
+			trace_smb3_mkdir_enter(xid, tcon->tid, ses->Suid, full_path);
 			break;
 		case SMB2_OP_RMDIR:
 			rqst[num_rqst].rq_iov = &vars->si_iov[0];
@@ -363,7 +363,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				goto finished;
 			smb2_set_next_command(tcon, &rqst[num_rqst]);
 			smb2_set_related(&rqst[num_rqst++]);
-			trace_smb3_rmdir_enter(xid, ses->Suid, tcon->tid, full_path);
+			trace_smb3_rmdir_enter(xid, tcon->tid, ses->Suid, full_path);
 			break;
 		case SMB2_OP_SET_EOF:
 			rqst[num_rqst].rq_iov = &vars->si_iov[0];
@@ -398,7 +398,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				goto finished;
 			}
 			num_rqst++;
-			trace_smb3_set_eof_enter(xid, ses->Suid, tcon->tid, full_path);
+			trace_smb3_set_eof_enter(xid, tcon->tid, ses->Suid, full_path);
 			break;
 		case SMB2_OP_SET_INFO:
 			rqst[num_rqst].rq_iov = &vars->si_iov[0];
@@ -429,8 +429,8 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				goto finished;
 			}
 			num_rqst++;
-			trace_smb3_set_info_compound_enter(xid, ses->Suid,
-							   tcon->tid, full_path);
+			trace_smb3_set_info_compound_enter(xid, tcon->tid,
+							   ses->Suid, full_path);
 			break;
 		case SMB2_OP_RENAME:
 			rqst[num_rqst].rq_iov = &vars->si_iov[0];
@@ -469,7 +469,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				goto finished;
 			}
 			num_rqst++;
-			trace_smb3_rename_enter(xid, ses->Suid, tcon->tid, full_path);
+			trace_smb3_rename_enter(xid, tcon->tid, ses->Suid, full_path);
 			break;
 		case SMB2_OP_HARDLINK:
 			rqst[num_rqst].rq_iov = &vars->si_iov[0];
@@ -496,7 +496,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				goto finished;
 			smb2_set_next_command(tcon, &rqst[num_rqst]);
 			smb2_set_related(&rqst[num_rqst++]);
-			trace_smb3_hardlink_enter(xid, ses->Suid, tcon->tid, full_path);
+			trace_smb3_hardlink_enter(xid, tcon->tid, ses->Suid, full_path);
 			break;
 		case SMB2_OP_SET_REPARSE:
 			rqst[num_rqst].rq_iov = vars->io_iov;
@@ -523,8 +523,8 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				goto finished;
 			}
 			num_rqst++;
-			trace_smb3_set_reparse_compound_enter(xid, ses->Suid,
-							      tcon->tid, full_path);
+			trace_smb3_set_reparse_compound_enter(xid, tcon->tid,
+							      ses->Suid, full_path);
 			break;
 		case SMB2_OP_GET_REPARSE:
 			rqst[num_rqst].rq_iov = vars->io_iov;
@@ -549,8 +549,8 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				goto finished;
 			}
 			num_rqst++;
-			trace_smb3_get_reparse_compound_enter(xid, ses->Suid,
-							      tcon->tid, full_path);
+			trace_smb3_get_reparse_compound_enter(xid, tcon->tid,
+							      ses->Suid, full_path);
 			break;
 		case SMB2_OP_QUERY_WSL_EA:
 			rqst[num_rqst].rq_iov = &vars->ea_iov;
@@ -656,11 +656,11 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			}
 			SMB2_query_info_free(&rqst[num_rqst++]);
 			if (rc)
-				trace_smb3_query_info_compound_err(xid,  ses->Suid,
-								   tcon->tid, rc);
+				trace_smb3_query_info_compound_err(xid,  tcon->tid,
+								   ses->Suid, rc);
 			else
-				trace_smb3_query_info_compound_done(xid, ses->Suid,
-								    tcon->tid);
+				trace_smb3_query_info_compound_done(xid, tcon->tid,
+								    ses->Suid);
 			break;
 		case SMB2_OP_POSIX_QUERY_INFO:
 			idata = in_iov[i].iov_base;
@@ -683,15 +683,15 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 
 			SMB2_query_info_free(&rqst[num_rqst++]);
 			if (rc)
-				trace_smb3_posix_query_info_compound_err(xid,  ses->Suid,
-									 tcon->tid, rc);
+				trace_smb3_posix_query_info_compound_err(xid,  tcon->tid,
+									 ses->Suid, rc);
 			else
-				trace_smb3_posix_query_info_compound_done(xid, ses->Suid,
-									  tcon->tid);
+				trace_smb3_posix_query_info_compound_done(xid, tcon->tid,
+									  ses->Suid);
 			break;
 		case SMB2_OP_DELETE:
 			if (rc)
-				trace_smb3_delete_err(xid,  ses->Suid, tcon->tid, rc);
+				trace_smb3_delete_err(xid, tcon->tid, ses->Suid, rc);
 			else {
 				/*
 				 * If dentry (hence, inode) is NULL, lease break is going to
@@ -699,59 +699,59 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				 */
 				if (inode)
 					cifs_mark_open_handles_for_deleted_file(inode, full_path);
-				trace_smb3_delete_done(xid, ses->Suid, tcon->tid);
+				trace_smb3_delete_done(xid, tcon->tid, ses->Suid);
 			}
 			break;
 		case SMB2_OP_MKDIR:
 			if (rc)
-				trace_smb3_mkdir_err(xid,  ses->Suid, tcon->tid, rc);
+				trace_smb3_mkdir_err(xid, tcon->tid, ses->Suid, rc);
 			else
-				trace_smb3_mkdir_done(xid, ses->Suid, tcon->tid);
+				trace_smb3_mkdir_done(xid, tcon->tid, ses->Suid);
 			break;
 		case SMB2_OP_HARDLINK:
 			if (rc)
-				trace_smb3_hardlink_err(xid,  ses->Suid, tcon->tid, rc);
+				trace_smb3_hardlink_err(xid,  tcon->tid, ses->Suid, rc);
 			else
-				trace_smb3_hardlink_done(xid, ses->Suid, tcon->tid);
+				trace_smb3_hardlink_done(xid, tcon->tid, ses->Suid);
 			SMB2_set_info_free(&rqst[num_rqst++]);
 			break;
 		case SMB2_OP_RENAME:
 			if (rc)
-				trace_smb3_rename_err(xid,  ses->Suid, tcon->tid, rc);
+				trace_smb3_rename_err(xid, tcon->tid, ses->Suid, rc);
 			else
-				trace_smb3_rename_done(xid, ses->Suid, tcon->tid);
+				trace_smb3_rename_done(xid, tcon->tid, ses->Suid);
 			SMB2_set_info_free(&rqst[num_rqst++]);
 			break;
 		case SMB2_OP_RMDIR:
 			if (rc)
-				trace_smb3_rmdir_err(xid,  ses->Suid, tcon->tid, rc);
+				trace_smb3_rmdir_err(xid, tcon->tid, ses->Suid, rc);
 			else
-				trace_smb3_rmdir_done(xid, ses->Suid, tcon->tid);
+				trace_smb3_rmdir_done(xid, tcon->tid, ses->Suid);
 			SMB2_set_info_free(&rqst[num_rqst++]);
 			break;
 		case SMB2_OP_SET_EOF:
 			if (rc)
-				trace_smb3_set_eof_err(xid,  ses->Suid, tcon->tid, rc);
+				trace_smb3_set_eof_err(xid, tcon->tid, ses->Suid, rc);
 			else
-				trace_smb3_set_eof_done(xid, ses->Suid, tcon->tid);
+				trace_smb3_set_eof_done(xid, tcon->tid, ses->Suid);
 			SMB2_set_info_free(&rqst[num_rqst++]);
 			break;
 		case SMB2_OP_SET_INFO:
 			if (rc)
-				trace_smb3_set_info_compound_err(xid,  ses->Suid,
-								 tcon->tid, rc);
+				trace_smb3_set_info_compound_err(xid,  tcon->tid,
+								 ses->Suid, rc);
 			else
-				trace_smb3_set_info_compound_done(xid, ses->Suid,
-								  tcon->tid);
+				trace_smb3_set_info_compound_done(xid, tcon->tid,
+								  ses->Suid);
 			SMB2_set_info_free(&rqst[num_rqst++]);
 			break;
 		case SMB2_OP_SET_REPARSE:
 			if (rc) {
-				trace_smb3_set_reparse_compound_err(xid,  ses->Suid,
-								    tcon->tid, rc);
+				trace_smb3_set_reparse_compound_err(xid, tcon->tid,
+								    ses->Suid, rc);
 			} else {
-				trace_smb3_set_reparse_compound_done(xid, ses->Suid,
-								     tcon->tid);
+				trace_smb3_set_reparse_compound_done(xid, tcon->tid,
+								     ses->Suid);
 			}
 			SMB2_ioctl_free(&rqst[num_rqst++]);
 			break;
@@ -764,18 +764,18 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				rbuf = reparse_buf_ptr(iov);
 				if (IS_ERR(rbuf)) {
 					rc = PTR_ERR(rbuf);
-					trace_smb3_set_reparse_compound_err(xid,  ses->Suid,
-									    tcon->tid, rc);
+					trace_smb3_get_reparse_compound_err(xid, tcon->tid,
+									    ses->Suid, rc);
 				} else {
 					idata->reparse.tag = le32_to_cpu(rbuf->ReparseTag);
-					trace_smb3_set_reparse_compound_done(xid, ses->Suid,
-									     tcon->tid);
+					trace_smb3_get_reparse_compound_done(xid, tcon->tid,
+									     ses->Suid);
 				}
 				memset(iov, 0, sizeof(*iov));
 				resp_buftype[i + 1] = CIFS_NO_BUFFER;
 			} else {
-				trace_smb3_set_reparse_compound_err(xid, ses->Suid,
-								    tcon->tid, rc);
+				trace_smb3_get_reparse_compound_err(xid, tcon->tid,
+								    ses->Suid, rc);
 			}
 			SMB2_ioctl_free(&rqst[num_rqst++]);
 			break;
@@ -792,11 +792,11 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 				}
 			}
 			if (!rc) {
-				trace_smb3_query_wsl_ea_compound_done(xid, ses->Suid,
-								      tcon->tid);
+				trace_smb3_query_wsl_ea_compound_done(xid, tcon->tid,
+								      ses->Suid);
 			} else {
-				trace_smb3_query_wsl_ea_compound_err(xid, ses->Suid,
-								     tcon->tid, rc);
+				trace_smb3_query_wsl_ea_compound_err(xid, tcon->tid,
+								     ses->Suid, rc);
 			}
 			SMB2_query_info_free(&rqst[num_rqst++]);
 			break;
-- 
2.48.1

