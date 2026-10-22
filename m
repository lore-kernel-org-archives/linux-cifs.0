Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792642352;
	b=Tb/SagSLyg9Rejm2syA68NnZNPPSnDnh2phhZprnDa23xnK/lSQYX6qq+0+Y3bPXaNXA
	 Lf9AS2cO/w55LNPFRCC8dm3kp3ocRLwWFL1mfc4xnIemxrgSwnYuBhLnjbygPuDe90o0a
	 Yy6EMC/AIvNNejYati22I2vsMyJtmXkHbvTiI8Z0ybzvGZzjgNj0Kbw5K41xRsEAn2Fd3
	 AdzFDCOw2oluVNhjE94wBnz3y5CI9F4pmQUa4LgHAXSqR+0xFN6qw7fLvvrGde0/PSxUS
	 5TbBJte7gTTqAXSCHbd5rrKOXnWGjppt+B4HrLQDWCgf1wQkOeKk05ytFjshj2umhSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792642352;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=d+O7Dkr5gSsXrS8hwwvE3xGFoOZ+WROQM7tFy95u0ak=;
	b=q1X6ImX0VPw0tnrOTiYeeo5rvhH0gbd+5wa8Lmx90ZRNtphxT8vgUMz0wigb7cN+V5sF
	 9KpxwVO1c83txUMSL1FZwnzSJovQcKqMP9MgguWHwNGOpOcbF65if+wb6pSPNuwO52hR5
	 HK+x4iOXzyKL4A8Hc93CHCI7AyFMW2jJTERnGzO8OEZhGpEkOC580Nq2dl5pprphjRz3/
	 mjMnDEl6SBWOD2o/w36RWwNniRw+iMGyvyYKEHtKHzkVJabCiSjL6fUv51vFZ1xoc1gvO
	 9BTdEV0qqiHklUR3J7P6VM+RMkoYE74o1ciJIBj9oZHuAFlmO+EqlCn0yIlz6+iPTeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=KtjrY0f2;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4D5B606A332;
	Thu, 22 Oct 2026 04:12:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4D5B606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=KtjrY0f2
Received: from mac.lan (unknown [4.194.122.162])
	by linux.microsoft.com (Postfix) with ESMTPSA id 8634220B7166;
	Wed, 21 Oct 2026 21:12:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8634220B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792642342;
	bh=d+O7Dkr5gSsXrS8hwwvE3xGFoOZ+WROQM7tFy95u0ak=;
	h=From:To:Cc:Subject:Date:From;
	b=KtjrY0f2cmtpolqk6LP+2vtTWx2MDNG5CyBBKh+b3t6qW2/aGToGslkmFHK3TG7qA
	 uHBq7WakD7raErHsiDO2f90FGJOFDsltPjQ17AfoLm+/c7SyvMFId/zm6Rc2xpd0hn
	 4KFtKX5fiXNE5bv3xiEC1ZRpwK9aQML9vwGXEUh4=
From: "Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	AutonomousCodeSecurity@microsoft.com,
	Cen Zhang <cenzhang@linux.microsoft.com>
Subject: [PATCH] ksmbd: fix parent dentry lifetime in directory enumeration
Date: Thu, 22 Oct 2026 00:12:16 -0400
Message-ID: <20261022041216.8988-1-cenzhang@linux.microsoft.com>
X-Mailer: git-send-email 2.55.0
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

ksmbd_populate_dot_dotdot_entries() builds the ".." entry from
the open directory's d_parent and passes that pointer to
ksmbd_vfs_fill_dentry_attrs() without taking a reference. That pointer
is only valid while the directory stays under this parent. If a
concurrent rename moves the directory elsewhere, the old parent loses
its last reference; a following rmdir then turns it into a negative
dentry with d_inode cleared, and after the RCU grace period the dentry
itself is freed. The worker still holds the raw pointer and
dereferences d_inode through vfs_getattr() and vfs_getxattr().

A remote SMB client, authenticated or guest, triggers this by listing
a directory while that directory is moved under a new parent and the
old parent is deleted. It can be done by the client itself with write
access or by other concurrent writers, triggering null-ptr-deref and
slab-use-after-free on a KASAN build.

  KASAN: null-ptr-deref in range
      [0x0000000000000000-0x0000000000000007]
  Workqueue: ksmbd-io handle_ksmbd_work
  RIP: 0010:xattr_permission+0x9d/0x160
  Call Trace:
   vfs_getxattr+0x9c/0x1b0
   ksmbd_vfs_getxattr+0x82/0x100
   ksmbd_vfs_get_dos_attrib_xattr+0x7f/0x130
   ksmbd_vfs_fill_dentry_attrs+0x435/0x650
   ksmbd_populate_dot_dotdot_entries+0x25e/0x630
   smb2_query_dir+0xcf9/0x1a20
   handle_ksmbd_work+0x5f1/0x1c80
   process_one_work+0x90b/0x19d0

Fix by using the dentry reference counting APIs: take the parent with
dget_parent(), take a matching dget() on ".", and dput() the dentry
once ksmbd_vfs_fill_dentry_attrs() has returned or the pattern does
not match.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Cc: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
---
 fs/smb/server/smb_common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index ec6ee56293ce..8e44b15a4177 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -478,16 +478,17 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 			if (i == 0) {
 				d_info->name = ".";
 				d_info->name_len = 1;
-				dentry = dir->filp->f_path.dentry;
+				dentry = dget(dir->filp->f_path.dentry);
 			} else {
 				d_info->name = "..";
 				d_info->name_len = 2;
-				dentry = dir->filp->f_path.dentry->d_parent;
+				dentry = dget_parent(dir->filp->f_path.dentry);
 			}
 
 			if (!match_pattern(d_info->name, d_info->name_len,
 					   search_pattern)) {
 				dir->dot_dotdot[i] = 1;
+				dput(dentry);
 				continue;
 			}
 
@@ -496,6 +497,7 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 							 idmap,
 							 dentry,
 							 &ksmbd_kstat);
+			dput(dentry);
 			if (rc)
 				break;
 
-- 
2.55.0

