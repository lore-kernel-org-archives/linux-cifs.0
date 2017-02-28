From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v3 6/7] CIFS: use DFS pathnames in SMB2+ Create requests
Date: Tue, 28 Feb 2017 19:40:33 +0100
Message-ID: <20170228184034.18771-7-aaptel@suse.com>
References: <20170228184034.18771-1-aaptel@suse.com>
Cc: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170228184034.18771-1-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When connected to a DFS capable share, the client must set the
SMB2_FLAGS_DFS_OPERATIONS flag in the SMB2 header and use
DFS path names: "<server>\<share>\<path>" *without* leading \\.

Sources:

[MS-SMB2] 3.2.5.5 Receiving an SMB2 TREE_CONNECT Response
> TreeConnect.IsDfsShare MUST be set to TRUE, if the SMB2_SHARE_CAP_DFS
> bit is set in the Capabilities field of the response.

[MS-SMB2] 3.2.4.3 Application Requests Opening a File
> If TreeConnect.IsDfsShare is TRUE, the SMB2_FLAGS_DFS_OPERATIONS flag
> is set in the Flags field.

[MS-SMB2] 2.2.13 SMB2 CREATE Request, NameOffset:
> If SMB2_FLAGS_DFS_OPERATIONS is set in the Flags field of the SMB2
> header, the file name includes a prefix that will be processed during
> DFS name normalization as specified in section 3.3.5.9. Otherwise, the
> file name is relative to the share that is identified by the TreeId in
> the SMB2 header.

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 93 +++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 77 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2fd93ee..059da05 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1528,6 +1528,48 @@ add_durable_context(struct kvec *iov, unsigned int *num_iovec,
 	return 0;
 }
 
+static int
+alloc_path_with_tree_prefix(__le16 **out_path, int *out_size, int *out_len,
+			    const char *treename, const __le16 *path)
+{
+	int treename_len, path_len;
+	const __le16 sep[] = {cpu_to_le16('\\'), cpu_to_le16(0x0000)};
+
+	/*
+	 * skip leading "\\"
+	 */
+	treename_len = strlen(treename);
+	if (treename_len < 2 || !(treename[0] == '\\' && treename[1] == '\\'))
+		return -EINVAL;
+
+	treename += 2;
+	treename_len -= 2;
+
+	path_len = UniStrnlen((wchar_t *)path, PATH_MAX);
+
+	/*
+	 * make room for one path separator between the treename and
+	 * path
+	 */
+	*out_len = treename_len + 1 + path_len;
+
+	/*
+	 * final path needs to be null-terminated UTF16 with a
+	 * size aligned to 8
+	 */
+
+	*out_size = roundup((*out_len+1)*2, 8);
+	*out_path = kzalloc(*out_size, GFP_KERNEL);
+	if (!*out_path)
+		return -ENOMEM;
+
+	cifs_strtoUTF16(*out_path, treename, treename_len, load_nls_default());
+	UniStrcat(*out_path, sep);
+	UniStrcat(*out_path, path);
+
+	return 0;
+}
+
 int
 SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	  __u8 *oplock, struct smb2_file_all_info *buf,
@@ -1576,30 +1618,49 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	req->ShareAccess = FILE_SHARE_ALL_LE;
 	req->CreateDisposition = cpu_to_le32(oparms->disposition);
 	req->CreateOptions = cpu_to_le32(oparms->create_options & CREATE_OPTIONS_MASK);
-	uni_path_len = (2 * UniStrnlen((wchar_t *)path, PATH_MAX)) + 2;
-	/* do not count rfc1001 len field */
-	req->NameOffset = cpu_to_le16(sizeof(struct smb2_create_req) - 4);
 
 	iov[0].iov_base = (char *)req;
 	/* 4 for rfc1002 length field */
 	iov[0].iov_len = get_rfc1002_length(req) + 4;
-
-	/* MUST set path len (NameLength) to 0 opening root of share */
-	req->NameLength = cpu_to_le16(uni_path_len - 2);
 	/* -1 since last byte is buf[0] which is sent below (path) */
 	iov[0].iov_len--;
-	if (uni_path_len % 8 != 0) {
-		copy_size = uni_path_len / 8 * 8;
-		if (copy_size < uni_path_len)
-			copy_size += 8;
-
-		copy_path = kzalloc(copy_size, GFP_KERNEL);
-		if (!copy_path)
-			return -ENOMEM;
-		memcpy((char *)copy_path, (const char *)path,
-			uni_path_len);
+
+	req->NameOffset = cpu_to_le16(sizeof(struct smb2_create_req) - 4);
+
+	/* [MS-SMB2] 2.2.13 NameOffset:
+	 * If SMB2_FLAGS_DFS_OPERATIONS is set in the Flags field of
+	 * the SMB2 header, the file name includes a prefix that will
+	 * be processed during DFS name normalization as specified in
+	 * section 3.3.5.9. Otherwise, the file name is relative to
+	 * the share that is identified by the TreeId in the SMB2
+	 * header.
+	 */
+	if (tcon->share_flags & SHI1005_FLAGS_DFS) {
+		int name_len;
+
+		req->hdr.sync_hdr.Flags |= SMB2_FLAGS_DFS_OPERATIONS;
+		rc = alloc_path_with_tree_prefix(&copy_path, &copy_size,
+						 &name_len,
+						 tcon->treeName, path);
+		if (rc)
+			return rc;
+		req->NameLength = cpu_to_le16(name_len * 2);
 		uni_path_len = copy_size;
 		path = copy_path;
+	} else {
+		uni_path_len = (2 * UniStrnlen((wchar_t *)path, PATH_MAX)) + 2;
+		/* MUST set path len (NameLength) to 0 opening root of share */
+		req->NameLength = cpu_to_le16(uni_path_len - 2);
+		if (uni_path_len % 8 != 0) {
+			copy_size = roundup(uni_path_len, 8);
+			copy_path = kzalloc(copy_size, GFP_KERNEL);
+			if (!copy_path)
+				return -ENOMEM;
+			memcpy((char *)copy_path, (const char *)path,
+			       uni_path_len);
+			uni_path_len = copy_size;
+			path = copy_path;
+		}
 	}
 
 	iov[1].iov_len = uni_path_len;
-- 
2.10.2
