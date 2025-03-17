Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7D021D5AA
	for <linux-cifs@vger.kernel.org>; Mon, 17 Mar 2025 08:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742200864; cv=none; b=VQEyCnqr8r/oZEOVXQfsrtSMOtPzfZ3wlF6yYHsFTYHBrDo/FeEpC4olzC5G6F9pTO1oahLgAJeRvO9dPlzodnzBqmUMc1I2qafXOue211Y92zNIMqsG5h4yb6y93wxckEFQx/N1Riko5xIoQD+XOOcvNjkdrRJtyFLFUkLS6/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742200864; c=relaxed/simple;
	bh=zLYIoi9dYdoJtCR0bSrV8206gckhckz39HTHTMJ4Juw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QyTXeyx7cJaBIF1JnVnCtVuK7mhfD3QoEOgAe0RbPOjfSBumuSieKg7PCjKk79ZNdcvDahqmK2n005uvI6PMO2i8XvPKiWHDrdJAJ9daH/YkvpAGZbrf7/fM+m17nQFVnpCYNLiVtMpYs80lf0aUDVWM1t9KI8XzBYHXvG9+MGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b=Dg/gqSMG; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b="Dg/gqSMG"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-224019ad9edso22940935ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Mar 2025 01:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.com; s=cloud; t=1742200861; x=1742805661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0rIXAsZPT5w/tEmqI4U1ZCe7qRShLUgNuIADzxUIpZs=;
        b=Dg/gqSMGGX/oqn0D3N85fbmpTLfPyrVt/JN1o2BQVMRz5W9t5j1qscWwjQybiTFexz
         kTprSYJfQyEVuQMAI7F4JhgAKJlIjdU+7yBUnrkT3ckWfA68npH/JrQB7dlVyPHCWq4Z
         AFn/dBEjm3BlfnrKSZPtcu/22DXKwl60yPkV8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742200861; x=1742805661;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0rIXAsZPT5w/tEmqI4U1ZCe7qRShLUgNuIADzxUIpZs=;
        b=T2Khe6VgR1MQh5VbwC+2qghhJgjseXdRG1WRiK5/8wvQ8bR/6qneKdAu44l24vtWgK
         dzdeu3w0rJA3yfjgvkq9ZvWsiHofUbDI+W3S6m+up3CZpZydzaMQmmnHjkLzz1tYM6qo
         oxbDWsWgglwQsj193SX8SD+BWxFOkpaibdCUYRXAyYvo0Hw5EKZsSxvhAKUH+E5Y+0pR
         sJ92LQ6a0vmI+CzY0gpN6+gVGZT9oFCWMMA4mh3D3zpHSB0P4D9FV3+xFA6Cv/ASvTDa
         4W9VIVJoTc23y9V9hcK7/Q3GTavAw6azKShaiyEppqKef1aVlYuROkhT2I1ntqjvdHdY
         SzfQ==
X-Gm-Message-State: AOJu0YzQOYf+jX/iRZ8XA+OAmvwpgMb/mX7dQA1ej3cLD1XBZkGgJsC5
	EYt+uUfiV3yFG2QxSGL+guZdO/iR2GPIS0UE8w/2rMsEWxA5iTUzcGlU+qYkv683hLVt548KNb+
	tgdM=
X-Gm-Gg: ASbGnct0Iuz1FENqhBiJdLr10ClaXyYe7OYWgJp4Ws6FcgtotqXMg6gLwFvutnqIIoL
	br6Ew3RraJ7V8ATb2K1j1vso3jj7kC63R9+QhkLsK1acy429xookvdi+9gZ0mELOm64rFoizSXc
	woqP4HgskhecEmg8ABWjkZ8SPg8fZjdFQBmxZU9Me4VxXlHbUY8/oV//1XWqRcGbeON024F8F9T
	Jv/sZEEC5umZNtUWxRZQKY5Grqayyv0YtcjVkV+X2wT0ILaPVWKdms6CWJAPhxhPBUO92ceEB6v
	yIuUQZcEibDzurJQYATrdMLjblTCLB6MJR67Cmxqw8VHksVSKtOggzAciLxm8ErDeRs=
X-Google-Smtp-Source: AGHT+IElRBxzMTzHsJSwtFWFl9JbwXGmsjtWkmK6trHwmWRcJhT9vhqsrch9VuReC5Y/yn28+yj6ag==
X-Received: by 2002:a17:903:1446:b0:224:c76:5e57 with SMTP id d9443c01a7336-225e0ae708bmr147937695ad.39.1742200861244;
        Mon, 17 Mar 2025 01:41:01 -0700 (PDT)
Received: from localhost.localdomain ([154.91.3.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6bd5bf8sm69302555ad.253.2025.03.17.01.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 01:41:00 -0700 (PDT)
From: Chunjie Zhu <chunjie.zhu@cloud.com>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	ross.lagerwall@cloud.com,
	Chunjie Zhu <chunjie.zhu@cloud.com>
Subject: [PATCH] open hardlink on deferred close file return EINVAL
Date: Mon, 17 Mar 2025 08:39:14 +0000
Message-Id: <20250317083915.20004-1-chunjie.zhu@cloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following Python script results in unexpected behaviour when run on
a CIFS filesystem against a Windows Server:

    # Create file
    fd = os.open('test', os.O_WRONLY|os.O_CREAT)
    os.write(fd, b'foo')
    os.close(fd)

    # Open and close the file to leave a pending deferred close
    fd = os.open('test', os.O_RDONLY|os.O_DIRECT)
    os.close(fd)

    # Try to open the file via a hard link
    os.link('test', 'new')
    newfd = os.open('new', os.O_RDONLY|os.O_DIRECT)

The final open returns EINVAL due to the server returning
STATUS_INVALID_PARAMETER. The root cause of this is that the client
caches lease keys per inode, but the spec requires them to be related to
the filename which causes problems when hard links are involved:

From MS-SMB2 section 3.3.5.9.11:

"The server MUST attempt to locate a Lease by performing a lookup in the
LeaseTable.LeaseList using the LeaseKey in the
SMB2_CREATE_REQUEST_LEASE_V2 as the lookup key. If a lease is found,
Lease.FileDeleteOnClose is FALSE, and Lease.Filename does not match the
file name for the incoming request, the request MUST be failed with
STATUS_INVALID_PARAMETER"

The client side can return EINVAL directly without invoking server
operations. This reduces client server network communication overhead.

Signed-off-by: Chunjie Zhu <chunjie.zhu@cloud.com>
---
 fs/smb/client/cifsproto.h |  2 ++
 fs/smb/client/file.c      | 29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 260a6299bddb..b563c227792e 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -157,6 +157,8 @@ extern int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
 extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
 extern int cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
 				  struct cifsFileInfo **ret_file);
+extern int cifs_get_hardlink_path(struct cifs_tcon *tcon, struct inode *inode,
+				  struct file *file);
 extern unsigned int smbCalcSize(void *buf);
 extern int decode_negTokenInit(unsigned char *security_blob, int length,
 			struct TCP_Server_Info *server);
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 4cbb5487bd8d..0a66cce6e0ff 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -751,6 +751,12 @@ int cifs_open(struct inode *inode, struct file *file)
 		} else {
 			_cifsFileInfo_put(cfile, true, false);
 		}
+	} else {
+		/* hard link on the defeered close file */
+		rc = cifs_get_hardlink_path(tcon, inode, file);
+		if (rc) {
+			goto out;
+		}
 	}
 
 	if (server->oplocks)
@@ -2413,6 +2419,29 @@ cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
 	return -ENOENT;
 }
 
+int
+cifs_get_hardlink_path(struct cifs_tcon *tcon, struct inode *inode,
+				struct file *file)
+{
+	struct cifsFileInfo *open_file = NULL;
+	struct cifsInodeInfo *cinode = CIFS_I(inode);
+	int rc = 0;
+
+	spin_lock(&tcon->open_file_lock);
+	spin_lock(&cinode->open_file_lock);
+
+	list_for_each_entry(open_file, &cinode->openFileList, flist) {
+		if (file->f_flags == open_file->f_flags) {
+			rc = -EINVAL;
+			break;
+		}
+	}
+
+	spin_unlock(&cinode->open_file_lock);
+	spin_unlock(&tcon->open_file_lock);
+	return rc;
+}
+
 void
 cifs_writedata_release(struct kref *refcount)
 {
-- 
2.34.1

