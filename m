Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794736084;
	b=pZC8rRfXpVXfs7Vpi7hd/0doZdvy5J7qAUOsWEBnS5YEeaXMf/KUhtyBLR6UkanHwjno
	 0niZw0Aa3TN1c9tixZrA1AVOD6AyPQUWiAcSrvxCmZRmbmHP5r5SmTU+Ww/iO5mrS6GrO
	 0K0EYLIS1xUMsWgIsDrJXLVEwMr0uIA4F9WUcqjt4ZqwfpL2AiSiiLkE1xqxWIugtBWbb
	 SotRBvVx7iZy5pox7nQoT5um9Ls6QNZPiMHj8sx/59yQ3bjC3bZoHrAFFnVoszVLXKWiw
	 HwUpVpCQH9cXfe/hry5hCeBoqwcILe/te9/kTaViwTAAH77VhJWzUwPiebssE1mQLUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794736084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=AlZgloI6wwHeCon3TkjYRmDAZCVeVDQbpt8xdWpWa7k=;
	b=ZaQIs9FRXEE+CQtk0/8ociGdqebSRHFz7IOQPW7tg/XwlvpkJjDTK9ltaDLKEsUglwOj
	 yCWfs0eM/tXptHsDfpBTAdYBuIlA0bOAxw049+KkE5XpkbdT9cGQ5skPd3cH3/Sc8A39D
	 6O3x8tvLTwTpfx9Ygpo2IPkIrtnindtZ32wB+Ur2m60PZunQBWQ20CjziDp+Xd4D/19fN
	 zybj9qVF2IYqTqaU4fauE9ZHIwRlRc6FqV2JIsDieEC0BH+w+KTqhAzgrII5X/x0vJstf
	 SKgy1CCWYnv7Z7sg1PVSOEhgph26HM0g9qu0vA6Q0ngfkE2iCPFD9fPUohxYEqoY8wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W1H3Xh7f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6575D606A31D;
	Sun, 15 Nov 2026 09:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W1H3Xh7f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E581F000C4;
	Sun, 15 Nov 2026 09:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794736084;
	bh=AlZgloI6wwHeCon3TkjYRmDAZCVeVDQbpt8xdWpWa7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1H3Xh7fTWmxgEDoPdba3IDvkSnN2nqv6vQx4FoIUavc2pjruROFXyHRjmA9YR5OT
	 mSjCW7LSqq6LXwILyoWVsb510KY9WFV9Z5zm3UR20Kg/OYo8Nn5wfP8GFLPXrWX2KN
	 3gQgl+V7KOxDnWlV7OXGhCVwf8TCdZS648j7bmWYYB6RTOfMN+ZxqtJjI0+j5uF/sZ
	 xW31g0VCi5X8YWi3SNCekgZpNuuaBwSdC2oNiwciM+OHDdXHiYDpX26cL++pAWauLi
	 Upf/lgkarx+EHDlS3IG1H6OYgR8tY7AsOs2TYz5Liq/SM2mQwXcqUh0+tGawkRPh6X
	 GjOwKM7bYkNcg==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	icb@fastmail.org,
	mike.michalo@gmail.com,
	wangzhaolong633@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] ksmbd: protect CREATE metadata updates against filesystem freezing
Date: Sun, 15 Nov 2026 18:47:37 +0900
Message-Id: <20261115094737.8532-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261115094737.8532-1-linkinjeon@kernel.org>
References: <20261115094737.8532-1-linkinjeon@kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 4e45cca31d4e, smb2_open() no longer holds a write reference
after path lookup. The CREATE path still writes EAs, security descriptor
and stream xattrs, inherited DACLs, and initial POSIX ACLs.

Request write protection in the xattr helpers and hold a reference around
the initial POSIX ACL updates.

Fixes: 4e45cca31d4e ("smb/server: add ksmbd_vfs_kern_path()")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 10 +++++-----
 fs/smb/server/smbacl.c  |  2 +-
 fs/smb/server/vfs.c     |  6 ++++++
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 1b8471d75afa..d8da0b259cfd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3719,7 +3719,7 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 			};
 			rc = ksmbd_vfs_setxattr(idmap, path, xattr_stream_name,
 						(void *)afpinfo_empty,
-						sizeof(afpinfo_empty), 0, false);
+						sizeof(afpinfo_empty), 0, true);
 			return rc < 0 ? rc : 0;
 		}
 		ksmbd_debug(SMB, "XATTR stream name lookup failed: %d\n", rc);
@@ -3729,7 +3729,7 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 	if (!test_tree_conn_flag(fp->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE))
 		return -EACCES;
 
-	rc = ksmbd_vfs_setxattr(idmap, path, xattr_stream_name, NULL, 0, 0, false);
+	rc = ksmbd_vfs_setxattr(idmap, path, xattr_stream_name, NULL, 0, 0, true);
 	if (rc < 0)
 		pr_err("Failed to store XATTR stream name :%d\n", rc);
 	else
@@ -3944,7 +3944,7 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
 	    sizeof(struct create_sd_buf_req))
 		return -EINVAL;
 	return set_info_sec(work->conn, work->tcon, path, &sd_buf->ntsd,
-			    le32_to_cpu(sd_buf->ccontext.DataLength), true, false,
+			    le32_to_cpu(sd_buf->ccontext.DataLength), true, true,
 			    true, true);
 }
 
@@ -5075,7 +5075,7 @@ int smb2_open(struct ksmbd_work *work)
 
 			rc = smb2_set_ea(&ea_buf->ea,
 					 le32_to_cpu(ea_buf->ccontext.DataLength),
-					 &path, false);
+					 &path, true);
 			if (rc == -EOPNOTSUPP)
 				rc = 0;
 			else if (rc)
@@ -5280,7 +5280,7 @@ int smb2_open(struct ksmbd_work *work)
 								    &path,
 								    pntsd,
 								    pntsd_size,
-								    false);
+								    true);
 					kvfree(pntsd);
 					if (rc)
 						pr_err("failed to store ntacl in xattr : %d\n",
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 04dd4a6d7092..0ca093de83c6 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1443,7 +1443,7 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 			pntsd_size += sizeof(struct smb_acl) + nt_size;
 		}
 
-		ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, pntsd_size, false);
+		ksmbd_vfs_set_sd_xattr(conn, idmap, path, pntsd, pntsd_size, true);
 		kfree(pntsd);
 	}
 
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 0c95d4668370..09dad151360c 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -2334,6 +2334,10 @@ int ksmbd_vfs_set_init_posix_acl(const struct mnt_idmap *idmap,
 	}
 	posix_state_to_acl(&acl_state, acls->a_entries);
 
+	rc = mnt_want_write(path->mnt);
+	if (rc)
+		goto out;
+
 	rc = set_posix_acl(idmap, dentry, ACL_TYPE_ACCESS, acls);
 	if (rc < 0)
 		ksmbd_debug(SMB, "Set posix acl(ACL_TYPE_ACCESS) failed, rc : %d\n",
@@ -2345,7 +2349,9 @@ int ksmbd_vfs_set_init_posix_acl(const struct mnt_idmap *idmap,
 			ksmbd_debug(SMB, "Set posix acl(ACL_TYPE_DEFAULT) failed, rc : %d\n",
 				    rc);
 	}
+	mnt_drop_write(path->mnt);
 
+out:
 	free_acl_state(&acl_state);
 	posix_acl_release(acls);
 	return rc;
-- 
2.25.1

