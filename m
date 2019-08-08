Return-Path: <SRS0=GDvn=WE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 030B9C433FF
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Aug 2019 02:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2C6F2171F
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Aug 2019 02:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbfHHC7F (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Aug 2019 22:59:05 -0400
Received: from outbound.smtp.vt.edu ([198.82.183.121]:39422 "EHLO
        omr2.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727984AbfHHC7F (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Aug 2019 22:59:05 -0400
Received: from mr1.cc.vt.edu (mr1.cc.ipv6.vt.edu [IPv6:2607:b400:92:8300:0:31:1732:8aa4])
        by omr2.cc.vt.edu (8.14.4/8.14.4) with ESMTP id x782x3Yg012994
        for <linux-cifs@vger.kernel.org>; Wed, 7 Aug 2019 22:59:03 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        by mr1.cc.vt.edu (8.14.7/8.14.7) with ESMTP id x782wwCl022004
        for <linux-cifs@vger.kernel.org>; Wed, 7 Aug 2019 22:59:03 -0400
Received: by mail-qk1-f200.google.com with SMTP id c79so81335724qkg.13
        for <linux-cifs@vger.kernel.org>; Wed, 07 Aug 2019 19:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:mime-version:date
         :message-id;
        bh=zLYlHCKM9FGswpyNMjK6L6TymLo3lRrXDEvQNOBcxFo=;
        b=roKftGsS/mHjSEQcw7bO5bkSf03lbX9HV/vn4YalLOA/rlLUd4yAVuF6rlaccykAcT
         kbuGQISAZgQJLCl+bYsJ/MfTx4q9lJvbuHUDI+8lAsU3BwMSYPgyOexkvZ+3COBT2MbC
         U/QrmQLJQLe4pUoOL37Cu3K9U32+iwGIDPlkrmHEUDjsbUZTVx7fQnaOfl78+2k1EWF4
         l2I/HFWQSDpnr42F7b8/DLt6bW3+JDD6w43WaD2EhidFSBOSFgiM4v/kZJunNLA5Xlq8
         VBWIbG/Ab7+tEvL0GR0eoMFgv431fofDxTUk2AMBLnkJXMI2bt9Pf/pl40rBgRpnBfnx
         Uvcw==
X-Gm-Message-State: APjAAAXclqhM7GvN0CDbtAapvEftpVZhDFlKBuR79fjqPzKlYU4BWmLU
        GkW1TfSWDXRJLDcBJAG4t0xvnHJg0Y0cCQLJm522TthGpyGWXQWy1l8XI7uLQ6N3JGJH9r5ietQ
        vV6+J+sAUonuYHYYHXH6gyxtbbW+sTQQn
X-Received: by 2002:a05:6214:3f0:: with SMTP id cf16mr11221220qvb.211.1565233137915;
        Wed, 07 Aug 2019 19:58:57 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxGVT1G6h48UB1aM9okZpkv063eU7ZGRdbyHXQF99oG3xhZr3oGbbDxdl/nkv0nFhYuGKlbqw==
X-Received: by 2002:a05:6214:3f0:: with SMTP id cf16mr11221212qvb.211.1565233137493;
        Wed, 07 Aug 2019 19:58:57 -0700 (PDT)
Received: from turing-police ([2601:5c0:c001:4341::359])
        by smtp.gmail.com with ESMTPSA id f27sm3031586qkl.25.2019.08.07.19.58.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 19:58:56 -0700 (PDT)
From:   "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Steve French <sfrench@samba.org>
cc:     linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs/cifs - clean up 'set but not used' variables.
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date:   Wed, 07 Aug 2019 22:58:55 -0400
Message-ID: <39561.1565233135@turing-police>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When building with W=1, fs/cifs throws a lot of 'set but not used' messages.

  CC [M]  fs/cifs/file.o
fs/cifs/file.c: In function 'cifs_lock':
fs/cifs/file.c:1698:8: warning: variable 'netfid' set but not used [-Wunused-but-set-variable]
 1698 |  __u16 netfid;
      |        ^~~~~~
fs/cifs/file.c:1696:24: warning: variable 'cinode' set but not used [-Wunused-but-set-variable]
 1696 |  struct cifsInodeInfo *cinode;
      |                        ^~~~~~
fs/cifs/file.c: In function 'cifs_write':
fs/cifs/file.c:1767:23: warning: variable 'cifs_sb' set but not used [-Wunused-but-set-variable]
 1767 |  struct cifs_sb_info *cifs_sb;
      |                       ^~~~~~~
fs/cifs/file.c: In function 'collect_uncached_read_data':
fs/cifs/file.c:3580:20: warning: variable 'tcon' set but not used [-Wunused-but-set-variable]
 3580 |  struct cifs_tcon *tcon;
      |                    ^~~~
  CC [M]  fs/cifs/netmisc.o
fs/cifs/netmisc.c:120:40: warning: 'mapping_table_ERRHRD' defined but not used [-Wunused-const-variable=]
  120 | static const struct smb_to_posix_error mapping_table_ERRHRD[] = {
      |                                        ^~~~~~~~~~~~~~~~~~~~
  CC [M]  fs/cifs/smb2ops.o
fs/cifs/smb2ops.c: In function 'smb3_punch_hole':
fs/cifs/smb2ops.c:2942:24: warning: variable 'cifsi' set but not used [-Wunused-but-set-variable]
 2942 |  struct cifsInodeInfo *cifsi;
      |                        ^~~~~
  CC [M]  fs/cifs/cifsacl.o
fs/cifs/cifsacl.c: In function 'sid_to_id':
fs/cifs/cifsacl.c:367:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
  367 |  int rc;
      |      ^~
At top level:
fs/cifs/cifsacl.c:89:30: warning: 'sid_unix_NFS_mode' defined but not used [-Wunused-const-variable=]
   89 | static const struct cifs_sid sid_unix_NFS_mode = { 1, 2, {0, 0, 0, 0, 0, 5},
      |                              ^~~~~~~~~~~~~~~~~
fs/cifs/cifsacl.c:62:30: warning: 'sid_user' defined but not used [-Wunused-const-variable=]
   62 | static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
      |                              ^~~~~~~~

Heave the unused stuff over the side.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 78eed72f3af0..bcd5eb301230 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -58,8 +58,6 @@ static const struct cifs_sid sid_everyone = {
 /* security id for Authenticated Users system group */
 static const struct cifs_sid sid_authusers = {
 	1, 1, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(11)} };
-/* group users */
-static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
 
 /* S-1-22-1 Unmapped Unix users */
 static const struct cifs_sid sid_unix_users = {1, 1, {0, 0, 0, 0, 0, 22},
@@ -85,11 +83,6 @@ static const struct cifs_sid sid_unix_NFS_groups = { 1, 2, {0, 0, 0, 0, 0, 5},
 	{cpu_to_le32(88),
 	 cpu_to_le32(2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} };
 
-/* S-1-5-88-3 Unix mode */
-static const struct cifs_sid sid_unix_NFS_mode = { 1, 2, {0, 0, 0, 0, 0, 5},
-	{cpu_to_le32(88),
-	 cpu_to_le32(3), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} };
-
 static const struct cred *root_cred;
 
 static int
@@ -364,7 +357,6 @@ static int
 sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 		struct cifs_fattr *fattr, uint sidtype)
 {
-	int rc;
 	struct key *sidkey;
 	char *sidstr;
 	const struct cred *saved_cred;
@@ -426,7 +418,6 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 	sidkey = request_key(&cifs_idmap_key_type, sidstr, "",
 			     &cifs_idmap_key_acl);
 	if (IS_ERR(sidkey)) {
-		rc = -EINVAL;
 		cifs_dbg(FYI, "%s: Can't map SID %s to a %cid\n",
 			 __func__, sidstr, sidtype == SIDOWNER ? 'u' : 'g');
 		goto out_revert_creds;
@@ -439,7 +430,6 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 	 */
 	BUILD_BUG_ON(sizeof(uid_t) != sizeof(gid_t));
 	if (sidkey->datalen != sizeof(uid_t)) {
-		rc = -EIO;
 		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%hu)\n",
 			 __func__, sidkey->datalen);
 		key_invalidate(sidkey);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 97090693d182..f16f6d2b5217 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1693,9 +1693,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	bool posix_lck = false;
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
-	struct cifsInodeInfo *cinode;
 	struct cifsFileInfo *cfile;
-	__u16 netfid;
 	__u32 type;
 
 	rc = -EACCES;
@@ -1711,8 +1709,6 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	cifs_read_flock(flock, &type, &lock, &unlock, &wait_flag,
 			tcon->ses->server);
 	cifs_sb = CIFS_FILE_SB(file);
-	netfid = cfile->fid.netfid;
-	cinode = CIFS_I(file_inode(file));
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
@@ -1764,7 +1760,6 @@ cifs_write(struct cifsFileInfo *open_file, __u32 pid, const char *write_data,
 	int rc = 0;
 	unsigned int bytes_written = 0;
 	unsigned int total_written;
-	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *server;
 	unsigned int xid;
@@ -1772,8 +1767,6 @@ cifs_write(struct cifsFileInfo *open_file, __u32 pid, const char *write_data,
 	struct cifsInodeInfo *cifsi = CIFS_I(d_inode(dentry));
 	struct cifs_io_parms io_parms;
 
-	cifs_sb = CIFS_SB(dentry->d_sb);
-
 	cifs_dbg(FYI, "write %zd bytes to offset %lld of %pd\n",
 		 write_size, *offset, dentry);
 
@@ -3577,10 +3570,8 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
 	struct cifs_readdata *rdata, *tmp;
 	struct iov_iter *to = &ctx->iter;
 	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *tcon;
 	int rc;
 
-	tcon = tlink_tcon(ctx->cfile->tlink);
 	cifs_sb = CIFS_SB(ctx->cfile->dentry->d_sb);
 
 	mutex_lock(&ctx->aio_mutex);
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index ed92958e842d..657f409d4de0 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -117,10 +117,6 @@ static const struct smb_to_posix_error mapping_table_ERRSRV[] = {
 	{0, 0}
 };
 
-static const struct smb_to_posix_error mapping_table_ERRHRD[] = {
-	{0, 0}
-};
-
 /*
  * Convert a string containing text IPv4 or IPv6 address to binary form.
  *
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 64a5864127be..f5bbd1d7753e 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2939,7 +2939,6 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 			    loff_t offset, loff_t len)
 {
 	struct inode *inode;
-	struct cifsInodeInfo *cifsi;
 	struct cifsFileInfo *cfile = file->private_data;
 	struct file_zero_data_information fsctl_buf;
 	long rc;
@@ -2949,7 +2948,6 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 	xid = get_xid();
 
 	inode = d_inode(cfile->dentry);
-	cifsi = CIFS_I(inode);
 
 	/* Need to make file sparse, if not already, before freeing range. */
 	/* Consider adding equivalent for compressed since it could also work */


