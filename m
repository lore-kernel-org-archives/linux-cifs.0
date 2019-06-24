Return-Path: <SRS0=OUxG=UX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A627C43613
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 06:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4376420674
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 06:47:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cBxnlzV5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfFXGr2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jun 2019 02:47:28 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41678 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFXGr2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jun 2019 02:47:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id y72so6560826pgd.8
        for <linux-cifs@vger.kernel.org>; Sun, 23 Jun 2019 23:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=jxOVuy776EjJKq9do2QhMkrmK7SiQIFjfHM9jAZNsxQ=;
        b=cBxnlzV54+lu/bccNdlYqdm7EJdWgvnIzzB+hT0UKmgJqRTizrSwICgH4horJVWTI8
         Gv7vIJN65H8L3pV8XjLP9aLtKRmAydUoDxfdpHoKIAcUh78JMBcVrBs3LggAm3nBWDat
         7U+EAoa/hd+AaPpBgqz7tyYG9Cdw5qp4+d8Lr/aASAHAf2AnYo9oox2NXtU5lAuNJPVQ
         Eq7dngnZfh6PFmwVd1vInD8pj811WiMtXaITiyNW55n2GemFMb2NV7HnQaLlawAPALv2
         iyOa2YZCW2+zNhh09OGEIU6N/srmq3ZTn8bxm8NN/vxBctMn9YGyBah5f+HS3YvfTh21
         PSWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=jxOVuy776EjJKq9do2QhMkrmK7SiQIFjfHM9jAZNsxQ=;
        b=JX/EZOrt3fA3Rj8tRqbc0SCtie2Bpv5/kGPy5Z0hRNT12lUVTuerc3Pe0abIc1VBEF
         S7bMXZjznQ6fXATT9YX//91rib1z4nE3vvfVA7/HVLr7KhSeCI5K9w8+yLao3LumTXYa
         WcbGwIC2Kdd+9Hah9W3OgeZv0SishAXV1LjQIxtwS+ax8L016aPqM/I0zj3bMpytaB/Q
         0W0b7PnIhHTHyn475zFGS+ICFdSZ/qHby686AeL1UtZpEeO7Quruh0UjXa8iK2L25hpJ
         9S7F6UgxbKgy0KGsitDI6Ki85F/HISHR1xSXQL9riwHN+s43lRJBiRiaFEF2K4eA/gjT
         3VTQ==
X-Gm-Message-State: APjAAAXbFmGr3DmojpBwfrQ9dhfz26F39Vi12n7h8mV3OUXIeWjj4ca1
        6grBpVWpTK+Q1YBbG6NhbAb4p4+DBYvMhDsj3XTODrpE
X-Google-Smtp-Source: APXvYqz1FBchDBMB87HSQHyk3iPjuUJlZB9sp1Alz0Igwi0tmt/OingSkRkebyz9+E6d1bJUcxXl/A27x15+n9JFVlA=
X-Received: by 2002:a63:81c6:: with SMTP id t189mr19107651pgd.15.1561358847177;
 Sun, 23 Jun 2019 23:47:27 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 24 Jun 2019 01:47:16 -0500
Message-ID: <CAH2r5mtSKQtFRNHpiiPDqCwGGLNgooj_1zZiyG=5N+cpA0bQ2w@mail.gmail.com>
Subject: [PATCH][CIFS] simplify code by removing CONFIG_CIFS_ACL ifdef
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000007419c7058c0c2f13"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000007419c7058c0c2f13
Content-Type: text/plain; charset="UTF-8"

SMB3 ACL support is needed for many use cases now and should not be
ifdeffed out, even for SMB1 (CIFS).  Remove the CONFIG_CIFS_ACL
ifdef so ACL support is always built into cifs.ko

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/Kconfig      |  8 --------
 fs/cifs/Makefile     |  3 +--
 fs/cifs/cifs_debug.c |  2 --
 fs/cifs/cifsfs.c     |  6 ------
 fs/cifs/cifsglob.h   |  2 --
 fs/cifs/cifssmb.c    |  2 --
 fs/cifs/inode.c      |  6 ------
 fs/cifs/smb1ops.c    |  2 --
 fs/cifs/smb2ops.c    | 12 ------------
 fs/cifs/xattr.c      |  4 ----
 10 files changed, 1 insertion(+), 46 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 62ad5ed26de7..cb3096fabbbe 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -145,14 +145,6 @@ config CIFS_POSIX
       (such as Samba 3.10 and later) which can negotiate
       CIFS POSIX ACL support.  If unsure, say N.

-config CIFS_ACL
-    bool "Provide CIFS ACL support"
-    depends on CIFS_XATTR && KEYS
-    help
-      Allows fetching CIFS/NTFS ACL from the server.  The DACL blob
-      is handed over to the application/caller.  See the man
-      page for getcifsacl for more information.  If unsure, say Y.
-
 config CIFS_DEBUG
     bool "Enable CIFS debugging routines"
     default y
diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 51af69a1a328..41332f20055b 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -10,10 +10,9 @@ cifs-y := trace.o cifsfs.o cifssmb.o cifs_debug.o
connect.o dir.o file.o \
       cifs_unicode.o nterr.o cifsencrypt.o \
       readdir.o ioctl.o sess.o export.o smb1ops.o winucase.o \
       smb2ops.o smb2maperror.o smb2transport.o \
-      smb2misc.o smb2pdu.o smb2inode.o smb2file.o
+      smb2misc.o smb2pdu.o smb2inode.o smb2file.o cifsacl.o

 cifs-$(CONFIG_CIFS_XATTR) += xattr.o
-cifs-$(CONFIG_CIFS_ACL) += cifsacl.o

 cifs-$(CONFIG_CIFS_UPCALL) += cifs_spnego.o

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index ec933fb0b36e..a38d796f5ffe 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -240,9 +240,7 @@ static int cifs_debug_data_proc_show(struct
seq_file *m, void *v)
 #ifdef CONFIG_CIFS_XATTR
     seq_printf(m, ",XATTR");
 #endif
-#ifdef CONFIG_CIFS_ACL
     seq_printf(m, ",ACL");
-#endif
     seq_putc(m, '\n');
     seq_printf(m, "CIFSMaxBufSize: %d\n", CIFSMaxBufSize);
     seq_printf(m, "Active VFS Requests: %d\n", GlobalTotalActiveXid);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 786e07754107..dc5fd7a648f0 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1518,11 +1518,9 @@ init_cifs(void)
         goto out_destroy_dfs_cache;
 #endif /* CONFIG_CIFS_UPCALL */

-#ifdef CONFIG_CIFS_ACL
     rc = init_cifs_idmap();
     if (rc)
         goto out_register_key_type;
-#endif /* CONFIG_CIFS_ACL */

     rc = register_filesystem(&cifs_fs_type);
     if (rc)
@@ -1537,10 +1535,8 @@ init_cifs(void)
     return 0;

 out_init_cifs_idmap:
-#ifdef CONFIG_CIFS_ACL
     exit_cifs_idmap();
 out_register_key_type:
-#endif
 #ifdef CONFIG_CIFS_UPCALL
     exit_cifs_spnego();
 out_destroy_dfs_cache:
@@ -1572,9 +1568,7 @@ exit_cifs(void)
     unregister_filesystem(&cifs_fs_type);
     unregister_filesystem(&smb3_fs_type);
     cifs_dfs_release_automount_timer();
-#ifdef CONFIG_CIFS_ACL
     exit_cifs_idmap();
-#endif
 #ifdef CONFIG_CIFS_UPCALL
     exit_cifs_spnego();
 #endif
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 88c98fa15f39..16f240911192 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1871,7 +1871,6 @@ extern unsigned int cifs_min_small;  /* min size
of small buf pool */
 extern unsigned int cifs_max_pending; /* MAX requests at once to server*/
 extern bool disable_legacy_dialects;  /* forbid vers=1.0 and vers=2.0 mounts */

-#ifdef CONFIG_CIFS_ACL
 GLOBAL_EXTERN struct rb_root uidtree;
 GLOBAL_EXTERN struct rb_root gidtree;
 GLOBAL_EXTERN spinlock_t siduidlock;
@@ -1880,7 +1879,6 @@ GLOBAL_EXTERN struct rb_root siduidtree;
 GLOBAL_EXTERN struct rb_root sidgidtree;
 GLOBAL_EXTERN spinlock_t uidsidlock;
 GLOBAL_EXTERN spinlock_t gidsidlock;
-#endif /* CONFIG_CIFS_ACL */

 void cifs_oplock_break(struct work_struct *work);
 void cifs_queue_oplock_break(struct cifsFileInfo *cfile);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 1fbd92843a73..2ea28552f3f2 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3920,7 +3920,6 @@ CIFSGetExtAttr(const unsigned int xid, struct
cifs_tcon *tcon,

 #endif /* CONFIG_POSIX */

-#ifdef CONFIG_CIFS_ACL
 /*
  * Initialize NT TRANSACT SMB into small smb request buffer.  This assumes that
  * all NT TRANSACTS that we init here have total parm and data under about 400
@@ -4164,7 +4163,6 @@ CIFSSMBSetCIFSACL(const unsigned int xid, struct
cifs_tcon *tcon, __u16 fid,
     return (rc);
 }

-#endif /* CONFIG_CIFS_ACL */

 /* Legacy Query Path Information call for lookup to old servers such
    as Win9x/WinME */
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index d7cc62252634..65f72fd3d582 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -892,7 +892,6 @@ cifs_get_inode_info(struct inode **inode, const
char *full_path,
             cifs_dbg(FYI, "cifs_sfu_type failed: %d\n", tmprc);
     }

-#ifdef CONFIG_CIFS_ACL
     /* fill in 0777 bits from ACL */
     if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
         rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, full_path, fid);
@@ -902,7 +901,6 @@ cifs_get_inode_info(struct inode **inode, const
char *full_path,
             goto cgii_exit;
         }
     }
-#endif /* CONFIG_CIFS_ACL */

     /* fill in remaining high mode bits e.g. SUID, VTX */
     if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
@@ -2466,7 +2464,6 @@ cifs_setattr_nounix(struct dentry *direntry,
struct iattr *attrs)
     if (attrs->ia_valid & ATTR_GID)
         gid = attrs->ia_gid;

-#ifdef CONFIG_CIFS_ACL
     if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
         if (uid_valid(uid) || gid_valid(gid)) {
             rc = id_mode_to_cifs_acl(inode, full_path, NO_CHANGE_64,
@@ -2478,7 +2475,6 @@ cifs_setattr_nounix(struct dentry *direntry,
struct iattr *attrs)
             }
         }
     } else
-#endif /* CONFIG_CIFS_ACL */
     if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID))
         attrs->ia_valid &= ~(ATTR_UID | ATTR_GID);

@@ -2489,7 +2485,6 @@ cifs_setattr_nounix(struct dentry *direntry,
struct iattr *attrs)
     if (attrs->ia_valid & ATTR_MODE) {
         mode = attrs->ia_mode;
         rc = 0;
-#ifdef CONFIG_CIFS_ACL
         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
             rc = id_mode_to_cifs_acl(inode, full_path, mode,
                         INVALID_UID, INVALID_GID);
@@ -2499,7 +2494,6 @@ cifs_setattr_nounix(struct dentry *direntry,
struct iattr *attrs)
                 goto cifs_setattr_exit;
             }
         } else
-#endif /* CONFIG_CIFS_ACL */
         if (((mode & S_IWUGO) == 0) &&
             (cifsInode->cifsAttrs & ATTR_READONLY) == 0) {

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 88ab87df8b3b..b7421a096319 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -1223,11 +1223,9 @@ struct smb_version_operations smb1_operations = {
     .query_all_EAs = CIFSSMBQAllEAs,
     .set_EA = CIFSSMBSetEA,
 #endif /* CIFS_XATTR */
-#ifdef CONFIG_CIFS_ACL
     .get_acl = get_cifs_acl,
     .get_acl_by_fid = get_cifs_acl_by_fid,
     .set_acl = set_cifs_acl,
-#endif /* CIFS_ACL */
     .make_node = cifs_make_node,
 };

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index afe602bbe4c9..e48d328513b3 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2550,7 +2550,6 @@ smb2_query_symlink(const unsigned int xid,
struct cifs_tcon *tcon,
     return rc;
 }

-#ifdef CONFIG_CIFS_ACL
 static struct cifs_ntsd *
 get_smb2_acl_by_fid(struct cifs_sb_info *cifs_sb,
         const struct cifs_fid *cifsfid, u32 *pacllen)
@@ -2635,7 +2634,6 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
     return pntsd;
 }

-#ifdef CONFIG_CIFS_ACL
 static int
 set_smb2_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
         struct inode *inode, const char *path, int aclflag)
@@ -2693,7 +2691,6 @@ set_smb2_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
     free_xid(xid);
     return rc;
 }
-#endif /* CIFS_ACL */

 /* Retrieve an ACL from the server */
 static struct cifs_ntsd *
@@ -2713,7 +2710,6 @@ get_smb2_acl(struct cifs_sb_info *cifs_sb,
     cifsFileInfo_put(open_file);
     return pntsd;
 }
-#endif

 static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
                 loff_t offset, loff_t len, bool keep_size)
@@ -4236,11 +4232,9 @@ struct smb_version_operations smb20_operations = {
     .query_all_EAs = smb2_query_eas,
     .set_EA = smb2_set_ea,
 #endif /* CIFS_XATTR */
-#ifdef CONFIG_CIFS_ACL
     .get_acl = get_smb2_acl,
     .get_acl_by_fid = get_smb2_acl_by_fid,
     .set_acl = set_smb2_acl,
-#endif /* CIFS_ACL */
     .next_header = smb2_next_header,
     .ioctl_query_info = smb2_ioctl_query_info,
     .make_node = smb2_make_node,
@@ -4337,11 +4331,9 @@ struct smb_version_operations smb21_operations = {
     .query_all_EAs = smb2_query_eas,
     .set_EA = smb2_set_ea,
 #endif /* CIFS_XATTR */
-#ifdef CONFIG_CIFS_ACL
     .get_acl = get_smb2_acl,
     .get_acl_by_fid = get_smb2_acl_by_fid,
     .set_acl = set_smb2_acl,
-#endif /* CIFS_ACL */
     .next_header = smb2_next_header,
     .ioctl_query_info = smb2_ioctl_query_info,
     .make_node = smb2_make_node,
@@ -4447,11 +4439,9 @@ struct smb_version_operations smb30_operations = {
     .query_all_EAs = smb2_query_eas,
     .set_EA = smb2_set_ea,
 #endif /* CIFS_XATTR */
-#ifdef CONFIG_CIFS_ACL
     .get_acl = get_smb2_acl,
     .get_acl_by_fid = get_smb2_acl_by_fid,
     .set_acl = set_smb2_acl,
-#endif /* CIFS_ACL */
     .next_header = smb2_next_header,
     .ioctl_query_info = smb2_ioctl_query_info,
     .make_node = smb2_make_node,
@@ -4558,11 +4548,9 @@ struct smb_version_operations smb311_operations = {
     .query_all_EAs = smb2_query_eas,
     .set_EA = smb2_set_ea,
 #endif /* CIFS_XATTR */
-#ifdef CONFIG_CIFS_ACL
     .get_acl = get_smb2_acl,
     .get_acl_by_fid = get_smb2_acl_by_fid,
     .set_acl = set_smb2_acl,
-#endif /* CIFS_ACL */
     .next_header = smb2_next_header,
     .ioctl_query_info = smb2_ioctl_query_info,
     .make_node = smb2_make_node,
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 50ddb795aaeb..9076150758d8 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -96,7 +96,6 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
         break;

     case XATTR_CIFS_ACL: {
-#ifdef CONFIG_CIFS_ACL
         struct cifs_ntsd *pacl;

         if (!value)
@@ -117,7 +116,6 @@ static int cifs_xattr_set(const struct
xattr_handler *handler,
                 CIFS_I(inode)->time = 0;
             kfree(pacl);
         }
-#endif /* CONFIG_CIFS_ACL */
         break;
     }

@@ -247,7 +245,6 @@ static int cifs_xattr_get(const struct
xattr_handler *handler,
         break;

     case XATTR_CIFS_ACL: {
-#ifdef CONFIG_CIFS_ACL
         u32 acllen;
         struct cifs_ntsd *pacl;

@@ -270,7 +267,6 @@ static int cifs_xattr_get(const struct
xattr_handler *handler,
             rc = acllen;
             kfree(pacl);
         }
-#endif  /* CONFIG_CIFS_ACL */
         break;
     }




-- 
Thanks,

Steve

--0000000000007419c7058c0c2f13
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-simplify-code-by-removing-CONFIG_CIFS_ACL-ifdef.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-simplify-code-by-removing-CONFIG_CIFS_ACL-ifdef.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jxa0qhte0>
X-Attachment-Id: f_jxa0qhte0

RnJvbSA4NjViZGU2YTNhZmM2ZDFiODA2OWFmOWVkYTQ5ZTBjOTU5ZTBhZDVlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjQgSnVuIDIwMTkgMDE6NDQ6MTEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBzaW1wbGlmeSBjb2RlIGJ5IHJlbW92aW5nIENPTkZJR19DSUZTX0FDTCBpZmRlZgoKU01C
MyBBQ0wgc3VwcG9ydCBpcyBuZWVkZWQgZm9yIG1hbnkgdXNlIGNhc2VzIG5vdyBhbmQgc2hvdWxk
IG5vdCBiZQppZmRlZmZlZCBvdXQsIGV2ZW4gZm9yIFNNQjEgKENJRlMpLiAgUmVtb3ZlIHRoZSBD
T05GSUdfQ0lGU19BQ0wKaWZkZWYgc28gQUNMIHN1cHBvcnQgaXMgYWx3YXlzIGJ1aWx0IGludG8g
Y2lmcy5rbwoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQu
Y29tPgotLS0KIGZzL2NpZnMvS2NvbmZpZyAgICAgIHwgIDggLS0tLS0tLS0KIGZzL2NpZnMvTWFr
ZWZpbGUgICAgIHwgIDMgKy0tCiBmcy9jaWZzL2NpZnNfZGVidWcuYyB8ICAyIC0tCiBmcy9jaWZz
L2NpZnNmcy5jICAgICB8ICA2IC0tLS0tLQogZnMvY2lmcy9jaWZzZ2xvYi5oICAgfCAgMiAtLQog
ZnMvY2lmcy9jaWZzc21iLmMgICAgfCAgMiAtLQogZnMvY2lmcy9pbm9kZS5jICAgICAgfCAgNiAt
LS0tLS0KIGZzL2NpZnMvc21iMW9wcy5jICAgIHwgIDIgLS0KIGZzL2NpZnMvc21iMm9wcy5jICAg
IHwgMTIgLS0tLS0tLS0tLS0tCiBmcy9jaWZzL3hhdHRyLmMgICAgICB8ICA0IC0tLS0KIDEwIGZp
bGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCA0NiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9mcy9jaWZzL0tjb25maWcgYi9mcy9jaWZzL0tjb25maWcKaW5kZXggNjJhZDVlZDI2ZGU3Li5j
YjMwOTZmYWJiYmUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvS2NvbmZpZworKysgYi9mcy9jaWZzL0tj
b25maWcKQEAgLTE0NSwxNCArMTQ1LDYgQEAgY29uZmlnIENJRlNfUE9TSVgKIAkgIChzdWNoIGFz
IFNhbWJhIDMuMTAgYW5kIGxhdGVyKSB3aGljaCBjYW4gbmVnb3RpYXRlCiAJICBDSUZTIFBPU0lY
IEFDTCBzdXBwb3J0LiAgSWYgdW5zdXJlLCBzYXkgTi4KIAotY29uZmlnIENJRlNfQUNMCi0JYm9v
bCAiUHJvdmlkZSBDSUZTIEFDTCBzdXBwb3J0IgotCWRlcGVuZHMgb24gQ0lGU19YQVRUUiAmJiBL
RVlTCi0JaGVscAotCSAgQWxsb3dzIGZldGNoaW5nIENJRlMvTlRGUyBBQ0wgZnJvbSB0aGUgc2Vy
dmVyLiAgVGhlIERBQ0wgYmxvYgotCSAgaXMgaGFuZGVkIG92ZXIgdG8gdGhlIGFwcGxpY2F0aW9u
L2NhbGxlci4gIFNlZSB0aGUgbWFuCi0JICBwYWdlIGZvciBnZXRjaWZzYWNsIGZvciBtb3JlIGlu
Zm9ybWF0aW9uLiAgSWYgdW5zdXJlLCBzYXkgWS4KLQogY29uZmlnIENJRlNfREVCVUcKIAlib29s
ICJFbmFibGUgQ0lGUyBkZWJ1Z2dpbmcgcm91dGluZXMiCiAJZGVmYXVsdCB5CmRpZmYgLS1naXQg
YS9mcy9jaWZzL01ha2VmaWxlIGIvZnMvY2lmcy9NYWtlZmlsZQppbmRleCA1MWFmNjlhMWEzMjgu
LjQxMzMyZjIwMDU1YiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9NYWtlZmlsZQorKysgYi9mcy9jaWZz
L01ha2VmaWxlCkBAIC0xMCwxMCArMTAsOSBAQCBjaWZzLXkgOj0gdHJhY2UubyBjaWZzZnMubyBj
aWZzc21iLm8gY2lmc19kZWJ1Zy5vIGNvbm5lY3QubyBkaXIubyBmaWxlLm8gXAogCSAgY2lmc191
bmljb2RlLm8gbnRlcnIubyBjaWZzZW5jcnlwdC5vIFwKIAkgIHJlYWRkaXIubyBpb2N0bC5vIHNl
c3MubyBleHBvcnQubyBzbWIxb3BzLm8gd2ludWNhc2UubyBcCiAJICBzbWIyb3BzLm8gc21iMm1h
cGVycm9yLm8gc21iMnRyYW5zcG9ydC5vIFwKLQkgIHNtYjJtaXNjLm8gc21iMnBkdS5vIHNtYjJp
bm9kZS5vIHNtYjJmaWxlLm8KKwkgIHNtYjJtaXNjLm8gc21iMnBkdS5vIHNtYjJpbm9kZS5vIHNt
YjJmaWxlLm8gY2lmc2FjbC5vCiAKIGNpZnMtJChDT05GSUdfQ0lGU19YQVRUUikgKz0geGF0dHIu
bwotY2lmcy0kKENPTkZJR19DSUZTX0FDTCkgKz0gY2lmc2FjbC5vCiAKIGNpZnMtJChDT05GSUdf
Q0lGU19VUENBTEwpICs9IGNpZnNfc3BuZWdvLm8KIApkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZz
X2RlYnVnLmMgYi9mcy9jaWZzL2NpZnNfZGVidWcuYwppbmRleCBlYzkzM2ZiMGIzNmUuLmEzOGQ3
OTZmNWZmZSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzX2RlYnVnLmMKKysrIGIvZnMvY2lmcy9j
aWZzX2RlYnVnLmMKQEAgLTI0MCw5ICsyNDAsNyBAQCBzdGF0aWMgaW50IGNpZnNfZGVidWdfZGF0
YV9wcm9jX3Nob3coc3RydWN0IHNlcV9maWxlICptLCB2b2lkICp2KQogI2lmZGVmIENPTkZJR19D
SUZTX1hBVFRSCiAJc2VxX3ByaW50ZihtLCAiLFhBVFRSIik7CiAjZW5kaWYKLSNpZmRlZiBDT05G
SUdfQ0lGU19BQ0wKIAlzZXFfcHJpbnRmKG0sICIsQUNMIik7Ci0jZW5kaWYKIAlzZXFfcHV0Yyht
LCAnXG4nKTsKIAlzZXFfcHJpbnRmKG0sICJDSUZTTWF4QnVmU2l6ZTogJWRcbiIsIENJRlNNYXhC
dWZTaXplKTsKIAlzZXFfcHJpbnRmKG0sICJBY3RpdmUgVkZTIFJlcXVlc3RzOiAlZFxuIiwgR2xv
YmFsVG90YWxBY3RpdmVYaWQpOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZnMuYyBiL2ZzL2Np
ZnMvY2lmc2ZzLmMKaW5kZXggNzg2ZTA3NzU0MTA3Li5kYzVmZDdhNjQ4ZjAgMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMvY2lmc2ZzLmMKKysrIGIvZnMvY2lmcy9jaWZzZnMuYwpAQCAtMTUxOCwxMSArMTUx
OCw5IEBAIGluaXRfY2lmcyh2b2lkKQogCQlnb3RvIG91dF9kZXN0cm95X2Rmc19jYWNoZTsKICNl
bmRpZiAvKiBDT05GSUdfQ0lGU19VUENBTEwgKi8KIAotI2lmZGVmIENPTkZJR19DSUZTX0FDTAog
CXJjID0gaW5pdF9jaWZzX2lkbWFwKCk7CiAJaWYgKHJjKQogCQlnb3RvIG91dF9yZWdpc3Rlcl9r
ZXlfdHlwZTsKLSNlbmRpZiAvKiBDT05GSUdfQ0lGU19BQ0wgKi8KIAogCXJjID0gcmVnaXN0ZXJf
ZmlsZXN5c3RlbSgmY2lmc19mc190eXBlKTsKIAlpZiAocmMpCkBAIC0xNTM3LDEwICsxNTM1LDgg
QEAgaW5pdF9jaWZzKHZvaWQpCiAJcmV0dXJuIDA7CiAKIG91dF9pbml0X2NpZnNfaWRtYXA6Ci0j
aWZkZWYgQ09ORklHX0NJRlNfQUNMCiAJZXhpdF9jaWZzX2lkbWFwKCk7CiBvdXRfcmVnaXN0ZXJf
a2V5X3R5cGU6Ci0jZW5kaWYKICNpZmRlZiBDT05GSUdfQ0lGU19VUENBTEwKIAlleGl0X2NpZnNf
c3BuZWdvKCk7CiBvdXRfZGVzdHJveV9kZnNfY2FjaGU6CkBAIC0xNTcyLDkgKzE1NjgsNyBAQCBl
eGl0X2NpZnModm9pZCkKIAl1bnJlZ2lzdGVyX2ZpbGVzeXN0ZW0oJmNpZnNfZnNfdHlwZSk7CiAJ
dW5yZWdpc3Rlcl9maWxlc3lzdGVtKCZzbWIzX2ZzX3R5cGUpOwogCWNpZnNfZGZzX3JlbGVhc2Vf
YXV0b21vdW50X3RpbWVyKCk7Ci0jaWZkZWYgQ09ORklHX0NJRlNfQUNMCiAJZXhpdF9jaWZzX2lk
bWFwKCk7Ci0jZW5kaWYKICNpZmRlZiBDT05GSUdfQ0lGU19VUENBTEwKIAlleGl0X2NpZnNfc3Bu
ZWdvKCk7CiAjZW5kaWYKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMv
Y2lmc2dsb2IuaAppbmRleCA4OGM5OGZhMTVmMzkuLjE2ZjI0MDkxMTE5MiAxMDA2NDQKLS0tIGEv
ZnMvY2lmcy9jaWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtMTg3MSw3ICsx
ODcxLDYgQEAgZXh0ZXJuIHVuc2lnbmVkIGludCBjaWZzX21pbl9zbWFsbDsgIC8qIG1pbiBzaXpl
IG9mIHNtYWxsIGJ1ZiBwb29sICovCiBleHRlcm4gdW5zaWduZWQgaW50IGNpZnNfbWF4X3BlbmRp
bmc7IC8qIE1BWCByZXF1ZXN0cyBhdCBvbmNlIHRvIHNlcnZlciovCiBleHRlcm4gYm9vbCBkaXNh
YmxlX2xlZ2FjeV9kaWFsZWN0czsgIC8qIGZvcmJpZCB2ZXJzPTEuMCBhbmQgdmVycz0yLjAgbW91
bnRzICovCiAKLSNpZmRlZiBDT05GSUdfQ0lGU19BQ0wKIEdMT0JBTF9FWFRFUk4gc3RydWN0IHJi
X3Jvb3QgdWlkdHJlZTsKIEdMT0JBTF9FWFRFUk4gc3RydWN0IHJiX3Jvb3QgZ2lkdHJlZTsKIEdM
T0JBTF9FWFRFUk4gc3BpbmxvY2tfdCBzaWR1aWRsb2NrOwpAQCAtMTg4MCw3ICsxODc5LDYgQEAg
R0xPQkFMX0VYVEVSTiBzdHJ1Y3QgcmJfcm9vdCBzaWR1aWR0cmVlOwogR0xPQkFMX0VYVEVSTiBz
dHJ1Y3QgcmJfcm9vdCBzaWRnaWR0cmVlOwogR0xPQkFMX0VYVEVSTiBzcGlubG9ja190IHVpZHNp
ZGxvY2s7CiBHTE9CQUxfRVhURVJOIHNwaW5sb2NrX3QgZ2lkc2lkbG9jazsKLSNlbmRpZiAvKiBD
T05GSUdfQ0lGU19BQ0wgKi8KIAogdm9pZCBjaWZzX29wbG9ja19icmVhayhzdHJ1Y3Qgd29ya19z
dHJ1Y3QgKndvcmspOwogdm9pZCBjaWZzX3F1ZXVlX29wbG9ja19icmVhayhzdHJ1Y3QgY2lmc0Zp
bGVJbmZvICpjZmlsZSk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNzbWIuYyBiL2ZzL2NpZnMv
Y2lmc3NtYi5jCmluZGV4IDFmYmQ5Mjg0M2E3My4uMmVhMjg1NTJmM2YyIDEwMDY0NAotLS0gYS9m
cy9jaWZzL2NpZnNzbWIuYworKysgYi9mcy9jaWZzL2NpZnNzbWIuYwpAQCAtMzkyMCw3ICszOTIw
LDYgQEAgQ0lGU0dldEV4dEF0dHIoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNf
dGNvbiAqdGNvbiwKIAogI2VuZGlmIC8qIENPTkZJR19QT1NJWCAqLwogCi0jaWZkZWYgQ09ORklH
X0NJRlNfQUNMCiAvKgogICogSW5pdGlhbGl6ZSBOVCBUUkFOU0FDVCBTTUIgaW50byBzbWFsbCBz
bWIgcmVxdWVzdCBidWZmZXIuICBUaGlzIGFzc3VtZXMgdGhhdAogICogYWxsIE5UIFRSQU5TQUNU
UyB0aGF0IHdlIGluaXQgaGVyZSBoYXZlIHRvdGFsIHBhcm0gYW5kIGRhdGEgdW5kZXIgYWJvdXQg
NDAwCkBAIC00MTY0LDcgKzQxNjMsNiBAQCBDSUZTU01CU2V0Q0lGU0FDTChjb25zdCB1bnNpZ25l
ZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBfX3UxNiBmaWQsCiAJcmV0dXJuIChy
Yyk7CiB9CiAKLSNlbmRpZiAvKiBDT05GSUdfQ0lGU19BQ0wgKi8KIAogLyogTGVnYWN5IFF1ZXJ5
IFBhdGggSW5mb3JtYXRpb24gY2FsbCBmb3IgbG9va3VwIHRvIG9sZCBzZXJ2ZXJzIHN1Y2gKICAg
IGFzIFdpbjl4L1dpbk1FICovCmRpZmYgLS1naXQgYS9mcy9jaWZzL2lub2RlLmMgYi9mcy9jaWZz
L2lub2RlLmMKaW5kZXggZDdjYzYyMjUyNjM0Li42NWY3MmZkM2Q1ODIgMTAwNjQ0Ci0tLSBhL2Zz
L2NpZnMvaW5vZGUuYworKysgYi9mcy9jaWZzL2lub2RlLmMKQEAgLTg5Miw3ICs4OTIsNiBAQCBj
aWZzX2dldF9pbm9kZV9pbmZvKHN0cnVjdCBpbm9kZSAqKmlub2RlLCBjb25zdCBjaGFyICpmdWxs
X3BhdGgsCiAJCQljaWZzX2RiZyhGWUksICJjaWZzX3NmdV90eXBlIGZhaWxlZDogJWRcbiIsIHRt
cHJjKTsKIAl9CiAKLSNpZmRlZiBDT05GSUdfQ0lGU19BQ0wKIAkvKiBmaWxsIGluIDA3NzcgYml0
cyBmcm9tIEFDTCAqLwogCWlmIChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRf
Q0lGU19BQ0wpIHsKIAkJcmMgPSBjaWZzX2FjbF90b19mYXR0cihjaWZzX3NiLCAmZmF0dHIsICpp
bm9kZSwgZnVsbF9wYXRoLCBmaWQpOwpAQCAtOTAyLDcgKzkwMSw2IEBAIGNpZnNfZ2V0X2lub2Rl
X2luZm8oc3RydWN0IGlub2RlICoqaW5vZGUsIGNvbnN0IGNoYXIgKmZ1bGxfcGF0aCwKIAkJCWdv
dG8gY2dpaV9leGl0OwogCQl9CiAJfQotI2VuZGlmIC8qIENPTkZJR19DSUZTX0FDTCAqLwogCiAJ
LyogZmlsbCBpbiByZW1haW5pbmcgaGlnaCBtb2RlIGJpdHMgZS5nLiBTVUlELCBWVFggKi8KIAlp
ZiAoY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgJiBDSUZTX01PVU5UX1VOWF9FTVVMKQpAQCAtMjQ2
Niw3ICsyNDY0LDYgQEAgY2lmc19zZXRhdHRyX25vdW5peChzdHJ1Y3QgZGVudHJ5ICpkaXJlbnRy
eSwgc3RydWN0IGlhdHRyICphdHRycykKIAlpZiAoYXR0cnMtPmlhX3ZhbGlkICYgQVRUUl9HSUQp
CiAJCWdpZCA9IGF0dHJzLT5pYV9naWQ7CiAKLSNpZmRlZiBDT05GSUdfQ0lGU19BQ0wKIAlpZiAo
Y2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgJiBDSUZTX01PVU5UX0NJRlNfQUNMKSB7CiAJCWlmICh1
aWRfdmFsaWQodWlkKSB8fCBnaWRfdmFsaWQoZ2lkKSkgewogCQkJcmMgPSBpZF9tb2RlX3RvX2Np
ZnNfYWNsKGlub2RlLCBmdWxsX3BhdGgsIE5PX0NIQU5HRV82NCwKQEAgLTI0NzgsNyArMjQ3NSw2
IEBAIGNpZnNfc2V0YXR0cl9ub3VuaXgoc3RydWN0IGRlbnRyeSAqZGlyZW50cnksIHN0cnVjdCBp
YXR0ciAqYXR0cnMpCiAJCQl9CiAJCX0KIAl9IGVsc2UKLSNlbmRpZiAvKiBDT05GSUdfQ0lGU19B
Q0wgKi8KIAlpZiAoIShjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfU0VUX1VJ
RCkpCiAJCWF0dHJzLT5pYV92YWxpZCAmPSB+KEFUVFJfVUlEIHwgQVRUUl9HSUQpOwogCkBAIC0y
NDg5LDcgKzI0ODUsNiBAQCBjaWZzX3NldGF0dHJfbm91bml4KHN0cnVjdCBkZW50cnkgKmRpcmVu
dHJ5LCBzdHJ1Y3QgaWF0dHIgKmF0dHJzKQogCWlmIChhdHRycy0+aWFfdmFsaWQgJiBBVFRSX01P
REUpIHsKIAkJbW9kZSA9IGF0dHJzLT5pYV9tb2RlOwogCQlyYyA9IDA7Ci0jaWZkZWYgQ09ORklH
X0NJRlNfQUNMCiAJCWlmIChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfQ0lG
U19BQ0wpIHsKIAkJCXJjID0gaWRfbW9kZV90b19jaWZzX2FjbChpbm9kZSwgZnVsbF9wYXRoLCBt
b2RlLAogCQkJCQkJSU5WQUxJRF9VSUQsIElOVkFMSURfR0lEKTsKQEAgLTI0OTksNyArMjQ5NCw2
IEBAIGNpZnNfc2V0YXR0cl9ub3VuaXgoc3RydWN0IGRlbnRyeSAqZGlyZW50cnksIHN0cnVjdCBp
YXR0ciAqYXR0cnMpCiAJCQkJZ290byBjaWZzX3NldGF0dHJfZXhpdDsKIAkJCX0KIAkJfSBlbHNl
Ci0jZW5kaWYgLyogQ09ORklHX0NJRlNfQUNMICovCiAJCWlmICgoKG1vZGUgJiBTX0lXVUdPKSA9
PSAwKSAmJgogCQkgICAgKGNpZnNJbm9kZS0+Y2lmc0F0dHJzICYgQVRUUl9SRUFET05MWSkgPT0g
MCkgewogCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjFvcHMuYyBiL2ZzL2NpZnMvc21iMW9wcy5j
CmluZGV4IDg4YWI4N2RmOGIzYi4uYjc0MjFhMDk2MzE5IDEwMDY0NAotLS0gYS9mcy9jaWZzL3Nt
YjFvcHMuYworKysgYi9mcy9jaWZzL3NtYjFvcHMuYwpAQCAtMTIyMywxMSArMTIyMyw5IEBAIHN0
cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zIHNtYjFfb3BlcmF0aW9ucyA9IHsKIAkucXVlcnlf
YWxsX0VBcyA9IENJRlNTTUJRQWxsRUFzLAogCS5zZXRfRUEgPSBDSUZTU01CU2V0RUEsCiAjZW5k
aWYgLyogQ0lGU19YQVRUUiAqLwotI2lmZGVmIENPTkZJR19DSUZTX0FDTAogCS5nZXRfYWNsID0g
Z2V0X2NpZnNfYWNsLAogCS5nZXRfYWNsX2J5X2ZpZCA9IGdldF9jaWZzX2FjbF9ieV9maWQsCiAJ
LnNldF9hY2wgPSBzZXRfY2lmc19hY2wsCi0jZW5kaWYgLyogQ0lGU19BQ0wgKi8KIAkubWFrZV9u
b2RlID0gY2lmc19tYWtlX25vZGUsCiB9OwogCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMu
YyBiL2ZzL2NpZnMvc21iMm9wcy5jCmluZGV4IGFmZTYwMmJiZTRjOS4uZTQ4ZDMyODUxM2IzIDEw
MDY0NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAt
MjU1MCw3ICsyNTUwLDYgQEAgc21iMl9xdWVyeV9zeW1saW5rKGNvbnN0IHVuc2lnbmVkIGludCB4
aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJcmV0dXJuIHJjOwogfQogCi0jaWZkZWYgQ09O
RklHX0NJRlNfQUNMCiBzdGF0aWMgc3RydWN0IGNpZnNfbnRzZCAqCiBnZXRfc21iMl9hY2xfYnlf
ZmlkKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsCiAJCWNvbnN0IHN0cnVjdCBjaWZzX2Zp
ZCAqY2lmc2ZpZCwgdTMyICpwYWNsbGVuKQpAQCAtMjYzNSw3ICsyNjM0LDYgQEAgZ2V0X3NtYjJf
YWNsX2J5X3BhdGgoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwKIAlyZXR1cm4gcG50c2Q7
CiB9CiAKLSNpZmRlZiBDT05GSUdfQ0lGU19BQ0wKIHN0YXRpYyBpbnQKIHNldF9zbWIyX2FjbChz
dHJ1Y3QgY2lmc19udHNkICpwbm50c2QsIF9fdTMyIGFjbGxlbiwKIAkJc3RydWN0IGlub2RlICpp
bm9kZSwgY29uc3QgY2hhciAqcGF0aCwgaW50IGFjbGZsYWcpCkBAIC0yNjkzLDcgKzI2OTEsNiBA
QCBzZXRfc21iMl9hY2woc3RydWN0IGNpZnNfbnRzZCAqcG5udHNkLCBfX3UzMiBhY2xsZW4sCiAJ
ZnJlZV94aWQoeGlkKTsKIAlyZXR1cm4gcmM7CiB9Ci0jZW5kaWYgLyogQ0lGU19BQ0wgKi8KIAog
LyogUmV0cmlldmUgYW4gQUNMIGZyb20gdGhlIHNlcnZlciAqLwogc3RhdGljIHN0cnVjdCBjaWZz
X250c2QgKgpAQCAtMjcxMyw3ICsyNzEwLDYgQEAgZ2V0X3NtYjJfYWNsKHN0cnVjdCBjaWZzX3Ni
X2luZm8gKmNpZnNfc2IsCiAJY2lmc0ZpbGVJbmZvX3B1dChvcGVuX2ZpbGUpOwogCXJldHVybiBw
bnRzZDsKIH0KLSNlbmRpZgogCiBzdGF0aWMgbG9uZyBzbWIzX3plcm9fcmFuZ2Uoc3RydWN0IGZp
bGUgKmZpbGUsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQkgICAgbG9mZl90IG9mZnNldCwg
bG9mZl90IGxlbiwgYm9vbCBrZWVwX3NpemUpCkBAIC00MjM2LDExICs0MjMyLDkgQEAgc3RydWN0
IHNtYl92ZXJzaW9uX29wZXJhdGlvbnMgc21iMjBfb3BlcmF0aW9ucyA9IHsKIAkucXVlcnlfYWxs
X0VBcyA9IHNtYjJfcXVlcnlfZWFzLAogCS5zZXRfRUEgPSBzbWIyX3NldF9lYSwKICNlbmRpZiAv
KiBDSUZTX1hBVFRSICovCi0jaWZkZWYgQ09ORklHX0NJRlNfQUNMCiAJLmdldF9hY2wgPSBnZXRf
c21iMl9hY2wsCiAJLmdldF9hY2xfYnlfZmlkID0gZ2V0X3NtYjJfYWNsX2J5X2ZpZCwKIAkuc2V0
X2FjbCA9IHNldF9zbWIyX2FjbCwKLSNlbmRpZiAvKiBDSUZTX0FDTCAqLwogCS5uZXh0X2hlYWRl
ciA9IHNtYjJfbmV4dF9oZWFkZXIsCiAJLmlvY3RsX3F1ZXJ5X2luZm8gPSBzbWIyX2lvY3RsX3F1
ZXJ5X2luZm8sCiAJLm1ha2Vfbm9kZSA9IHNtYjJfbWFrZV9ub2RlLApAQCAtNDMzNywxMSArNDMz
MSw5IEBAIHN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zIHNtYjIxX29wZXJhdGlvbnMgPSB7
CiAJLnF1ZXJ5X2FsbF9FQXMgPSBzbWIyX3F1ZXJ5X2VhcywKIAkuc2V0X0VBID0gc21iMl9zZXRf
ZWEsCiAjZW5kaWYgLyogQ0lGU19YQVRUUiAqLwotI2lmZGVmIENPTkZJR19DSUZTX0FDTAogCS5n
ZXRfYWNsID0gZ2V0X3NtYjJfYWNsLAogCS5nZXRfYWNsX2J5X2ZpZCA9IGdldF9zbWIyX2FjbF9i
eV9maWQsCiAJLnNldF9hY2wgPSBzZXRfc21iMl9hY2wsCi0jZW5kaWYgLyogQ0lGU19BQ0wgKi8K
IAkubmV4dF9oZWFkZXIgPSBzbWIyX25leHRfaGVhZGVyLAogCS5pb2N0bF9xdWVyeV9pbmZvID0g
c21iMl9pb2N0bF9xdWVyeV9pbmZvLAogCS5tYWtlX25vZGUgPSBzbWIyX21ha2Vfbm9kZSwKQEAg
LTQ0NDcsMTEgKzQ0MzksOSBAQCBzdHJ1Y3Qgc21iX3ZlcnNpb25fb3BlcmF0aW9ucyBzbWIzMF9v
cGVyYXRpb25zID0gewogCS5xdWVyeV9hbGxfRUFzID0gc21iMl9xdWVyeV9lYXMsCiAJLnNldF9F
QSA9IHNtYjJfc2V0X2VhLAogI2VuZGlmIC8qIENJRlNfWEFUVFIgKi8KLSNpZmRlZiBDT05GSUdf
Q0lGU19BQ0wKIAkuZ2V0X2FjbCA9IGdldF9zbWIyX2FjbCwKIAkuZ2V0X2FjbF9ieV9maWQgPSBn
ZXRfc21iMl9hY2xfYnlfZmlkLAogCS5zZXRfYWNsID0gc2V0X3NtYjJfYWNsLAotI2VuZGlmIC8q
IENJRlNfQUNMICovCiAJLm5leHRfaGVhZGVyID0gc21iMl9uZXh0X2hlYWRlciwKIAkuaW9jdGxf
cXVlcnlfaW5mbyA9IHNtYjJfaW9jdGxfcXVlcnlfaW5mbywKIAkubWFrZV9ub2RlID0gc21iMl9t
YWtlX25vZGUsCkBAIC00NTU4LDExICs0NTQ4LDkgQEAgc3RydWN0IHNtYl92ZXJzaW9uX29wZXJh
dGlvbnMgc21iMzExX29wZXJhdGlvbnMgPSB7CiAJLnF1ZXJ5X2FsbF9FQXMgPSBzbWIyX3F1ZXJ5
X2VhcywKIAkuc2V0X0VBID0gc21iMl9zZXRfZWEsCiAjZW5kaWYgLyogQ0lGU19YQVRUUiAqLwot
I2lmZGVmIENPTkZJR19DSUZTX0FDTAogCS5nZXRfYWNsID0gZ2V0X3NtYjJfYWNsLAogCS5nZXRf
YWNsX2J5X2ZpZCA9IGdldF9zbWIyX2FjbF9ieV9maWQsCiAJLnNldF9hY2wgPSBzZXRfc21iMl9h
Y2wsCi0jZW5kaWYgLyogQ0lGU19BQ0wgKi8KIAkubmV4dF9oZWFkZXIgPSBzbWIyX25leHRfaGVh
ZGVyLAogCS5pb2N0bF9xdWVyeV9pbmZvID0gc21iMl9pb2N0bF9xdWVyeV9pbmZvLAogCS5tYWtl
X25vZGUgPSBzbWIyX21ha2Vfbm9kZSwKZGlmZiAtLWdpdCBhL2ZzL2NpZnMveGF0dHIuYyBiL2Zz
L2NpZnMveGF0dHIuYwppbmRleCA1MGRkYjc5NWFhZWIuLjkwNzYxNTA3NThkOCAxMDA2NDQKLS0t
IGEvZnMvY2lmcy94YXR0ci5jCisrKyBiL2ZzL2NpZnMveGF0dHIuYwpAQCAtOTYsNyArOTYsNiBA
QCBzdGF0aWMgaW50IGNpZnNfeGF0dHJfc2V0KGNvbnN0IHN0cnVjdCB4YXR0cl9oYW5kbGVyICpo
YW5kbGVyLAogCQlicmVhazsKIAogCWNhc2UgWEFUVFJfQ0lGU19BQ0w6IHsKLSNpZmRlZiBDT05G
SUdfQ0lGU19BQ0wKIAkJc3RydWN0IGNpZnNfbnRzZCAqcGFjbDsKIAogCQlpZiAoIXZhbHVlKQpA
QCAtMTE3LDcgKzExNiw2IEBAIHN0YXRpYyBpbnQgY2lmc194YXR0cl9zZXQoY29uc3Qgc3RydWN0
IHhhdHRyX2hhbmRsZXIgKmhhbmRsZXIsCiAJCQkJQ0lGU19JKGlub2RlKS0+dGltZSA9IDA7CiAJ
CQlrZnJlZShwYWNsKTsKIAkJfQotI2VuZGlmIC8qIENPTkZJR19DSUZTX0FDTCAqLwogCQlicmVh
azsKIAl9CiAKQEAgLTI0Nyw3ICsyNDUsNiBAQCBzdGF0aWMgaW50IGNpZnNfeGF0dHJfZ2V0KGNv
bnN0IHN0cnVjdCB4YXR0cl9oYW5kbGVyICpoYW5kbGVyLAogCQlicmVhazsKIAogCWNhc2UgWEFU
VFJfQ0lGU19BQ0w6IHsKLSNpZmRlZiBDT05GSUdfQ0lGU19BQ0wKIAkJdTMyIGFjbGxlbjsKIAkJ
c3RydWN0IGNpZnNfbnRzZCAqcGFjbDsKIApAQCAtMjcwLDcgKzI2Nyw2IEBAIHN0YXRpYyBpbnQg
Y2lmc194YXR0cl9nZXQoY29uc3Qgc3RydWN0IHhhdHRyX2hhbmRsZXIgKmhhbmRsZXIsCiAJCQly
YyA9IGFjbGxlbjsKIAkJCWtmcmVlKHBhY2wpOwogCQl9Ci0jZW5kaWYgIC8qIENPTkZJR19DSUZT
X0FDTCAqLwogCQlicmVhazsKIAl9CiAKLS0gCjIuMjAuMQoK
--0000000000007419c7058c0c2f13--
