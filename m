From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [CIFS] [PATCH 1/3] Remove XATTR improvements: Improved Linux XATTR
 support, support POSIX XATTR CAP
Date: Mon, 6 May 2013 10:03:21 -0500
Message-ID: <CAH2r5mvbpYFOOGGXKaPeeamVa--VsGR26HQHJ+bTz-6z1mdsFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The Linux cifs client has long had the ability to set xattrs to Samba
and Windows servers, but two problems have caused compatibility
problems:

1) setting an empty (zero length) EA, which Samba and Windows
interpret as removing the attribute, rather than having an attribute
with an empty value (which can break Linux apps)

2) setting EAs for namespaces other than "user." (equivalently "os2.")
or ACLs (POSIX ACLs and CIFS ACL are supported) such as for SELinux
(helpful for security)

There was a posix xattr capability flag (unused) and posix xattr
setinfo level reserved for this in the CIFS Unix/Linux Extensions, so
this patch implements support for them for the kernel client (will
work on the server side with JRA next):

1) checks CIFS_UNIX_XATTR_CAP (0x00000004) on the POSIX Share Flags
and if the server supports this flag, will use the
SMB_QUERY_XATTR/SMB_SET_XATTR (infolevel 0x205)

2) SetEA for level 205 looks identical to SET_FILE_EA infolevel (level
2, long supported by Samba, Windows, OS/2 and most or all NAS) except
for two required changes:
   - the full name including namespace of the EA is sent (ie
"user.myattribute" rather than "myattribute"). Note that EA names are
sent as is, not codepage connverted, to match Windows behavior.
   - removing an attribute is specified by setting EA flag
FEA_DELETEEA	(0x40). When FEA_DELETEEA is set EA Length must be zero

This first patch of 3 adds the base support for sending the new
infolevel, and adds removexattr support.  The next two will add
setxattr and getxattr support to the kernel client (subsequent patches
will add server support, which is expected to be very small due to
overlap with existing code for SET_FILE_EA infolevel)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index e996ff6..6faaf4c 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -2512,7 +2512,8 @@ struct fea {
 	/* optionally followed by value */
 } __attribute__((packed));
 /* flags for _FEA.fEA */
-#define FEA_NEEDEA         0x80	/* need EA bit */
+#define FEA_NEEDEA	0x80	/* need EA bit */
+#define FEA_DELETEEA	0x40	/* delete EA, EA length MUST be 0. POSIX only */

 struct fealist {
 	__le32 list_len;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index dda188a..8f403ed 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -459,7 +459,9 @@ extern ssize_t CIFSSMBQAllEAs(const unsigned int
xid, struct cifs_tcon *tcon,
 extern int CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 		const char *fileName, const char *ea_name,
 		const void *ea_value, const __u16 ea_value_len,
-		const struct nls_table *nls_codepage, int remap_special_chars);
+		const struct nls_table *nls_codepage, int remap_special_chars,
+		bool is_posix /* if posix try to set using newer xattr op */,
+		bool set_delete /* if posix xattr delete flag should be set */);
 extern int CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon,
 			__u16 fid, struct cifs_ntsd **acl_inf, __u32 *buflen);
 extern int CIFSSMBSetCIFSACL(const unsigned int, struct cifs_tcon *, __u16,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index a58dc77..7bae6bc 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -6208,7 +6208,7 @@ int
 CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 	     const char *fileName, const char *ea_name, const void *ea_value,
 	     const __u16 ea_value_len, const struct nls_table *nls_codepage,
-	     int remap)
+	     int remap, bool is_posix, bool is_posix_delete)
 {
 	struct smb_com_transaction2_spi_req *pSMB = NULL;
 	struct smb_com_transaction2_spi_rsp *pSMBr = NULL;
@@ -6259,8 +6259,10 @@ SetEARetry:
 	param_offset = offsetof(struct smb_com_transaction2_spi_req,
 				InformationLevel) - 4;
 	offset = param_offset + params;
-	pSMB->InformationLevel =
-		cpu_to_le16(SMB_SET_FILE_EA);
+	if (is_posix)
+		pSMB->InformationLevel = cpu_to_le16(SMB_SET_XATTR);
+	else
+		pSMB->InformationLevel = cpu_to_le16(SMB_SET_FILE_EA);

 	parm_data =
 		(struct fealist *) (((char *) &pSMB->hdr.Protocol) +
@@ -6273,7 +6275,11 @@ SetEARetry:
 	byte_count = 3 /* pad */  + params + count;
 	pSMB->DataCount = cpu_to_le16(count);
 	parm_data->list_len = cpu_to_le32(count);
-	parm_data->list[0].EA_flags = 0;
+	if (is_posix_delete)
+		parm_data->list[0].EA_flags = FEA_DELETEEA;
+	else
+		parm_data->list[0].EA_flags = 0;
+
 	/* we checked above that name len is less than 255 */
 	parm_data->list[0].name_len = (__u8)name_len;
 	/* EA names are always ASCII */
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 09afda4..38de709 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -1,7 +1,7 @@
 /*
  *   fs/cifs/xattr.c
  *
- *   Copyright (c) International Business Machines  Corp., 2003, 2007
+ *   Copyright (c) International Business Machines  Corp., 2003, 2013
  *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
  *
  *   This library is free software; you can redistribute it and/or modify
@@ -69,22 +69,35 @@ int cifs_removexattr(struct dentry *direntry,
const char *ea_name)
 	}
 	if (ea_name == NULL) {
 		cifs_dbg(FYI, "Null xattr names not supported\n");
-	} else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)
+		goto remove_ea_exit;
+	}
+
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
+		goto remove_ea_exit;
+
+	if (le64_to_cpu(pTcon->fsUnixInfo.Capability)& CIFS_UNIX_XATTR_CAP) {
+		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, NULL,
+			(__u16)0, cifs_sb->local_nls,
+			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR,
+			true /* posix */, true /* set posix delete flag */);
+		cifs_dbg(FYI, "posix removeea of %s rc = %d", full_path, rc);
+
+		/* If unable to remove with posix call try older xattr level */
+		if (!rc)
+			goto remove_ea_exit;
+	}
+
+	if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)
 		&& (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN))) {
 		cifs_dbg(FYI,
 			 "illegal xattr request %s (only user namespace supported)\n",
 			 ea_name);
-		/* BB what if no namespace prefix? */
-		/* Should we just pass them to server, except for
-		system and perhaps security prefixes? */
 	} else {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
-			goto remove_ea_exit;
-
 		ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
 		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, NULL,
 			(__u16)0, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR,
+			false /* not posix */, false /* do not set del flag */);
 	}
 remove_ea_exit:
 	kfree(full_path);
@@ -151,7 +164,8 @@ int cifs_setxattr(struct dentry *direntry, const
char *ea_name,
 		ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
 		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
 			(__u16)value_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR,
+			false /* not posix */, false /* not delete */);
 	} else if (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN)
 		   == 0) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
@@ -160,7 +174,8 @@ int cifs_setxattr(struct dentry *direntry, const
char *ea_name,
 		ea_name += XATTR_OS2_PREFIX_LEN; /* skip past os2. prefix */
 		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
 			(__u16)value_size, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR,
+			false /* not posix */, false /* not delete */);
 	} else if (strncmp(ea_name, CIFS_XATTR_CIFS_ACL,
 			strlen(CIFS_XATTR_CIFS_ACL)) == 0) {
 #ifdef CONFIG_CIFS_ACL

-- 
Thanks,

Steve
