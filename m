Received: from na1pdmzitismtp02.tibco.com (unknown [160.101.131.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190BE36A340;
	Mon, 22 Jun 2026 09:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.101.131.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782120311; cv=none; b=a6MXsUwppynjYnIOyFESxyGuTtpToe81w+4d/DLRDi0DJ2dA4xN/qTM30AO0pNLzRnR4tG1a0pFdvbAf2ESnyISGQfLYqh0n8WpAgaf/nkvgUSvfiU7O99NoLju5hEm3rgC7I9H6Ob0MCD8YuhFbw4aB2AMnNWkimrh+kF8P0SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782120311; c=relaxed/simple;
	bh=hgHtiBF9qj+HFF36fS1tMtaMVSziudFs/y1gC5tEk0s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ox8mbAwiAnOqFcZDy05fG8MF/kc2LDAkkLbh+tpsgM2IDU0nWmSLgWgkq7YrBVcWogBpgt/bdGlzRme8e+c80gKAXeqFoR6Rzg5oQ/0G06pqsiKcDa9IXcHJlOsvShR4mQvOP4NFSOB+V2jcwG7AvB7w6+YZCaytb1r/+EqxVds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; arc=none smtp.client-ip=160.101.131.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
Received: from eddie6.eng.citrite.net (unknown [10.113.40.46])
	by na1pdmzitismtp02.tibco.com (Postfix) with ESMTP id 497BA81C4306;
	Mon, 22 Jun 2026 05:13:28 -0400 (EDT)
From: Chunjie Zhu <chunjie.zhu@citrix.com>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>
Cc: Chunjie Zhu <chunjie.zhu@citrix.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] fix smb client defer close causes file corruption
Date: Mon, 22 Jun 2026 09:14:49 +0000
Message-ID: <20260622091450.2668504-1-chunjie.zhu@citrix.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Test environment

 4 hosts as smb client, 1 host as smb server
 smb client hosts, kernel 6.6.138
 mount options,
  //10.70.48.15/xxx /run/xxx cifs rw,relatime,vers=3.0,
  cache=loose,username=xxx,domain=xxx,uid=0,noforceuid,
  gid=0,noforcegid,addr=10.70.48.15,file_mode=0755,
  dir_mode=0755,soft,nounix,serverino,mapposix,reparse=nfs,
  rsize=1048576,wsize=1048576,bsize=1048576,echo_interval=60,
  actimeo=0,closetimeo=1

Work around

 mount with cache=none or closetimeo=0

The Race Condition Flow

 Step 1: Host-01 closes file

  Host-01:
   file close (eeefe8d0.vhd)
   -> CIFS defers SMB2 CLOSE
   -> Handle H1 stored in deferred_closes list
   -> Lease L1 (RWH or RH) still active on server
   -> Entry: { path=“eeefe8d0.vhd”, handle=H1, inode=I1 }

 Step 2: Host-02 does hardlink and rename

  Host-02:
   hardlink(eeefe8d0.vhd, 0f11b74e.vhd)
   -> SMB2: Creates new name for same inode
   -> Server: inode I1 now has 2 names (link count = 2)
   -> Host-01 lease L1: NO BREAK (same inode, just added name)

   crate(eeefe8d0.vhd.new)
   -> Entry { path="eeefe8d0.vhd.new", handle=H2, inode=I2 }

   rename(eeefe8d0.vhd.new, eeefe8d0.vhd)
   -> SMB2: Replaces “eeefe8d0.vhd” name → points to new inode I2
   -> Server: old inode I1 now only accessible as “0f11b74e.vhd”
   -> Server SHOULD send: Lease Break notification to H1 ← KEY!

 Step 3: Lease break delivery is not reliable

  strict locking off, level2 oplock

   Host-01:
   -> Lease break not received or processed
   -> H1 is in deferred_closes list (not "active")

   Result: Stale entry remains:
      { path=“eeefe8d0.vhd”, handle=H1, inode=I1_OLD }

   Host-02:
   -> Open 0f11b74e.vhd in readonly

   Result:
      { path="0f11b74e.vhd", inode=I1_NEW }

 Step 4: Host-01 reopens file

  Host-01:
   file open (eeefe8d0.vhd)
   -> Kernel checks deferred_closes for “eeefe8d0.vhd”
   -> Found H1! (matched by pathname string)
   -> REUSES H1 without checking
   -> close or reconnect, flush buffered writes
      slient corruption?

Signed-off-by: Chunjie Zhu <chunjie.zhu@citrix.com>
---
 fs/smb/client/fs_context.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 0812af001417..4ed33de0a00d 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1300,11 +1300,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->acdirmax = ctx->acregmax = HZ * result.uint_32;
 		break;
 	case Opt_closetimeo:
-		if (result.uint_32 > SMB3_MAX_DCLOSETIMEO / HZ) {
-			cifs_errorf(fc, "closetimeo too large\n");
+		if (result.uint_32 != 0) {
+			cifs_errorf(fc, "closetimeo must be 0, deferred close is disabled\n");
 			goto cifs_parse_mount_err;
 		}
-		ctx->closetimeo = HZ * result.uint_32;
+		ctx->closetimeo = 0;
 		break;
 	case Opt_echo_interval:
 		if (result.uint_32 < SMB_ECHO_INTERVAL_MIN ||
@@ -1795,7 +1795,7 @@ int smb3_init_fs_context(struct fs_context *fc)
 
 	ctx->acregmax = CIFS_DEF_ACTIMEO;
 	ctx->acdirmax = CIFS_DEF_ACTIMEO;
-	ctx->closetimeo = SMB3_DEF_DCLOSETIMEO;
+	ctx->closetimeo = 0;
 	ctx->max_cached_dirs = MAX_CACHED_FIDS;
 	/* Most clients set timeout to 0, allows server to use its default */
 	ctx->handle_timeout = 0; /* See MS-SMB2 spec section 2.2.14.2.12 */
-- 
2.52.0

