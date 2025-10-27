Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484A42DECB9
	for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 07:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761549339; cv=none; b=hzz2aIXvt/TMGzbuqdnbunA8UuRLLNL363uBz2Yr+mVFk1+kk1I88HFFjzPUNCwZbaRiK7KlH+J17IJRXYmtGRS2cJQbWC283FWbdS+fjbQ1vIbAi9bNSx3B8Aii1zWnxNQ828NUBIjHNc7U0wxlpeHrl+pEcudxibyUVgJvgK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761549339; c=relaxed/simple;
	bh=jcKtlw24r23/zxNAv55pqMA0oSTDFIj+Wts7YElWdmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rc7PRT9Dw59hO4CmLM7SO0OtTwDNWdd4EgmwFyjD/s5zn1qXoi2fwvF4AabFR1W7a99bIzj5PKykD3Nm48Kwl+RVEKnIJyc6ON8hogb/1nIp7b3J243Ce/TN9DM0tZefCu+6eE7UjhrnlNur4JsLCSSFhibdN5Lv72Jp9tgE8Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EDrWsRe+; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EDrWsRe+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761549335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7jufHQq5zII8WMWUcSY31BH2TY4ZFV66yORSb/EnpvU=;
	b=EDrWsRe+x5/YR6ZAyPJHEHiEUdqMouQMra3Mk57EctYwodihbgovyEBf+/xStQ3Cfb2/Gp
	0ndMwrFx60AdhrV1OxlcBbfNNgSc0uTSXz77ZLEv7CwgJrW2g6slaw61R2tBmqOpXASEYU
	E22stvw5rLx6PyfbnROcKc/qFvvzuZo=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 06/24] smb: move file access permission bits definitions to common/smb1pdu.h
Date: Mon, 27 Oct 2025 15:12:58 +0800
Message-ID: <20251027071316.3468472-7-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

There are only 2 different definitions between the client and server:

  - SET_FILE_READ_RIGHTS:
    - client: rename to CLIENT_SET_FILE_READ_RIGHTS
    - server: rename to SERVER_SET_FILE_READ_RIGHTS
  - SET_FILE_WRITE_RIGHTS
    - client: rename to CLIENT_SET_FILE_WRITE_RIGHTS
    - server: rename to SERVER_SET_FILE_WRITE_RIGHTS

Perhaps in the future we can change them to be the same, move them to
common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsacl.c    |   4 +-
 fs/smb/client/cifspdu.h    | 112 ---------------------------------
 fs/smb/common/smb1pdu.h    | 123 ++++++++++++++++++++++++++++++++++++-
 fs/smb/common/smb2pdu.h    |   6 --
 fs/smb/server/smb_common.h |  55 -----------------
 fs/smb/server/smbacl.c     |   2 +-
 6 files changed, 125 insertions(+), 177 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index ce2ebc213a1d..5c3d8eb68868 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -654,9 +654,9 @@ static void mode_to_access_flags(umode_t mode, umode_t bits_to_use,
 	   is this but we have cleared all the bits sans RWX for
 	   either user or group or other as per bits_to_use */
 	if (mode & S_IRUGO)
-		*pace_flags |= SET_FILE_READ_RIGHTS;
+		*pace_flags |= CLIENT_SET_FILE_READ_RIGHTS;
 	if (mode & S_IWUGO)
-		*pace_flags |= SET_FILE_WRITE_RIGHTS;
+		*pace_flags |= CLIENT_SET_FILE_WRITE_RIGHTS;
 	if (mode & S_IXUGO)
 		*pace_flags |= SET_FILE_EXEC_RIGHTS;
 
diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 86167875574c..a063c98683bc 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -117,118 +117,6 @@
 #define SMBOPEN_OTRUNC        0x0002
 #define SMBOPEN_OAPPEND       0x0001
 
-/*
- * These are the file access permission bits defined in CIFS for the
- * NTCreateAndX as well as the level 0x107
- * TRANS2_QUERY_PATH_INFORMATION API.  The level 0x107, SMB_QUERY_FILE_ALL_INFO
- * responds with the AccessFlags.
- * The AccessFlags specifies the access permissions a caller has to the
- * file and can have any suitable combination of the following values:
- */
-
-#define FILE_READ_DATA        0x00000001  /* Data can be read from the file   */
-					  /* or directory child entries can   */
-					  /* be listed together with the      */
-					  /* associated child attributes      */
-					  /* (so the FILE_READ_ATTRIBUTES on  */
-					  /* the child entry is not needed)   */
-#define FILE_WRITE_DATA       0x00000002  /* Data can be written to the file  */
-					  /* or new file can be created in    */
-					  /* the directory                    */
-#define FILE_APPEND_DATA      0x00000004  /* Data can be appended to the file */
-					  /* (for non-local files over SMB it */
-					  /* is same as FILE_WRITE_DATA)      */
-					  /* or new subdirectory can be       */
-					  /* created in the directory         */
-#define FILE_READ_EA          0x00000008  /* Extended attributes associated   */
-					  /* with the file can be read        */
-#define FILE_WRITE_EA         0x00000010  /* Extended attributes associated   */
-					  /* with the file can be written     */
-#define FILE_EXECUTE          0x00000020  /*Data can be read into memory from */
-					  /* the file using system paging I/O */
-					  /* for executing the file / script  */
-					  /* or right to traverse directory   */
-					  /* (but by default all users have   */
-					  /* directory bypass traverse        */
-					  /* privilege and do not need this   */
-					  /* permission on directories at all)*/
-#define FILE_DELETE_CHILD     0x00000040  /* Child entry can be deleted from  */
-					  /* the directory (so the DELETE on  */
-					  /* the child entry is not needed)   */
-#define FILE_READ_ATTRIBUTES  0x00000080  /* Attributes associated with the   */
-					  /* file or directory can be read    */
-#define FILE_WRITE_ATTRIBUTES 0x00000100  /* Attributes associated with the   */
-					  /* file or directory can be written */
-#define DELETE                0x00010000  /* The file or dir can be deleted   */
-#define READ_CONTROL          0x00020000  /* The discretionary access control */
-					  /* list and ownership associated    */
-					  /* with the file or dir can be read */
-#define WRITE_DAC             0x00040000  /* The discretionary access control */
-					  /* list associated with the file or */
-					  /* directory can be written         */
-#define WRITE_OWNER           0x00080000  /* Ownership information associated */
-					  /* with the file/dir can be written */
-#define SYNCHRONIZE           0x00100000  /* The file handle can waited on to */
-					  /* synchronize with the completion  */
-					  /* of an input/output request       */
-#define SYSTEM_SECURITY       0x01000000  /* The system access control list   */
-					  /* associated with the file or      */
-					  /* directory can be read or written */
-					  /* (cannot be in DACL, can in SACL) */
-#define MAXIMUM_ALLOWED       0x02000000  /* Maximal subset of GENERIC_ALL    */
-					  /* permissions which can be granted */
-					  /* (cannot be in DACL nor SACL)     */
-#define GENERIC_ALL           0x10000000  /* Same as: GENERIC_EXECUTE |       */
-					  /*          GENERIC_WRITE |         */
-					  /*          GENERIC_READ |          */
-					  /*          FILE_DELETE_CHILD |     */
-					  /*          DELETE |                */
-					  /*          WRITE_DAC |             */
-					  /*          WRITE_OWNER             */
-					  /* So GENERIC_ALL contains all bits */
-					  /* mentioned above except these two */
-					  /* SYSTEM_SECURITY  MAXIMUM_ALLOWED */
-#define GENERIC_EXECUTE       0x20000000  /* Same as: FILE_EXECUTE |          */
-					  /*          FILE_READ_ATTRIBUTES |  */
-					  /*          READ_CONTROL |          */
-					  /*          SYNCHRONIZE             */
-#define GENERIC_WRITE         0x40000000  /* Same as: FILE_WRITE_DATA |       */
-					  /*          FILE_APPEND_DATA |      */
-					  /*          FILE_WRITE_EA |         */
-					  /*          FILE_WRITE_ATTRIBUTES | */
-					  /*          READ_CONTROL |          */
-					  /*          SYNCHRONIZE             */
-#define GENERIC_READ          0x80000000  /* Same as: FILE_READ_DATA |        */
-					  /*          FILE_READ_EA |          */
-					  /*          FILE_READ_ATTRIBUTES |  */
-					  /*          READ_CONTROL |          */
-					  /*          SYNCHRONIZE             */
-
-#define FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA | FILE_READ_ATTRIBUTES)
-#define FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
-				| FILE_WRITE_EA | FILE_WRITE_ATTRIBUTES)
-#define FILE_EXEC_RIGHTS (FILE_EXECUTE)
-
-#define SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA | FILE_WRITE_EA \
-				| FILE_READ_ATTRIBUTES \
-				| FILE_WRITE_ATTRIBUTES \
-				| DELETE | READ_CONTROL | WRITE_DAC \
-				| WRITE_OWNER | SYNCHRONIZE)
-#define SET_FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
-				| FILE_READ_EA | FILE_WRITE_EA \
-				| FILE_READ_ATTRIBUTES \
-				| FILE_WRITE_ATTRIBUTES \
-				| DELETE | READ_CONTROL | WRITE_DAC \
-				| WRITE_OWNER | SYNCHRONIZE)
-#define SET_FILE_EXEC_RIGHTS (FILE_READ_EA | FILE_WRITE_EA | FILE_EXECUTE \
-				| FILE_READ_ATTRIBUTES \
-				| FILE_WRITE_ATTRIBUTES \
-				| DELETE | READ_CONTROL | WRITE_DAC \
-				| WRITE_OWNER | SYNCHRONIZE)
-
-#define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
-				| READ_CONTROL | SYNCHRONIZE)
-
 /*
  * Invalid readdir handle
  */
diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
index f14d3d9aac22..9fe6fc4b05a7 100644
--- a/fs/smb/common/smb1pdu.h
+++ b/fs/smb/common/smb1pdu.h
@@ -75,7 +75,128 @@
 #define SMBFLG2_UNICODE cpu_to_le16(0x8000)
 
 /*
- * File Attribute flags
+ * These are the file access permission bits defined in CIFS for the
+ * NTCreateAndX as well as the level 0x107
+ * TRANS2_QUERY_PATH_INFORMATION API.  The level 0x107, SMB_QUERY_FILE_ALL_INFO
+ * responds with the AccessFlags.
+ * The AccessFlags specifies the access permissions a caller has to the
+ * file and can have any suitable combination of the following values:
+ */
+
+#define FILE_READ_DATA        0x00000001  /* Data can be read from the file   */
+					  /* or directory child entries can   */
+					  /* be listed together with the      */
+					  /* associated child attributes      */
+					  /* (so the FILE_READ_ATTRIBUTES on  */
+					  /* the child entry is not needed)   */
+#define FILE_WRITE_DATA       0x00000002  /* Data can be written to the file  */
+					  /* or new file can be created in    */
+					  /* the directory                    */
+#define FILE_APPEND_DATA      0x00000004  /* Data can be appended to the file */
+					  /* (for non-local files over SMB it */
+					  /* is same as FILE_WRITE_DATA)      */
+					  /* or new subdirectory can be       */
+					  /* created in the directory         */
+#define FILE_READ_EA          0x00000008  /* Extended attributes associated   */
+					  /* with the file can be read        */
+#define FILE_WRITE_EA         0x00000010  /* Extended attributes associated   */
+					  /* with the file can be written     */
+#define FILE_EXECUTE          0x00000020  /*Data can be read into memory from */
+					  /* the file using system paging I/O */
+					  /* for executing the file / script  */
+					  /* or right to traverse directory   */
+					  /* (but by default all users have   */
+					  /* directory bypass traverse        */
+					  /* privilege and do not need this   */
+					  /* permission on directories at all)*/
+#define FILE_DELETE_CHILD     0x00000040  /* Child entry can be deleted from  */
+					  /* the directory (so the DELETE on  */
+					  /* the child entry is not needed)   */
+#define FILE_READ_ATTRIBUTES  0x00000080  /* Attributes associated with the   */
+					  /* file or directory can be read    */
+#define FILE_WRITE_ATTRIBUTES 0x00000100  /* Attributes associated with the   */
+					  /* file or directory can be written */
+#define DELETE                0x00010000  /* The file or dir can be deleted   */
+#define READ_CONTROL          0x00020000  /* The discretionary access control */
+					  /* list and ownership associated    */
+					  /* with the file or dir can be read */
+#define WRITE_DAC             0x00040000  /* The discretionary access control */
+					  /* list associated with the file or */
+					  /* directory can be written         */
+#define WRITE_OWNER           0x00080000  /* Ownership information associated */
+					  /* with the file/dir can be written */
+#define SYNCHRONIZE           0x00100000  /* The file handle can waited on to */
+					  /* synchronize with the completion  */
+					  /* of an input/output request       */
+#define SYSTEM_SECURITY       0x01000000  /* The system access control list   */
+					  /* associated with the file or      */
+					  /* directory can be read or written */
+					  /* (cannot be in DACL, can in SACL) */
+#define MAXIMUM_ALLOWED       0x02000000  /* Maximal subset of GENERIC_ALL    */
+					  /* permissions which can be granted */
+					  /* (cannot be in DACL nor SACL)     */
+#define GENERIC_ALL           0x10000000  /* Same as: GENERIC_EXECUTE |       */
+					  /*          GENERIC_WRITE |         */
+					  /*          GENERIC_READ |          */
+					  /*          FILE_DELETE_CHILD |     */
+					  /*          DELETE |                */
+					  /*          WRITE_DAC |             */
+					  /*          WRITE_OWNER             */
+					  /* So GENERIC_ALL contains all bits */
+					  /* mentioned above except these two */
+					  /* SYSTEM_SECURITY  MAXIMUM_ALLOWED */
+#define GENERIC_EXECUTE       0x20000000  /* Same as: FILE_EXECUTE |          */
+					  /*          FILE_READ_ATTRIBUTES |  */
+					  /*          READ_CONTROL |          */
+					  /*          SYNCHRONIZE             */
+#define GENERIC_WRITE         0x40000000  /* Same as: FILE_WRITE_DATA |       */
+					  /*          FILE_APPEND_DATA |      */
+					  /*          FILE_WRITE_EA |         */
+					  /*          FILE_WRITE_ATTRIBUTES | */
+					  /*          READ_CONTROL |          */
+					  /*          SYNCHRONIZE             */
+#define GENERIC_READ          0x80000000  /* Same as: FILE_READ_DATA |        */
+					  /*          FILE_READ_EA |          */
+					  /*          FILE_READ_ATTRIBUTES |  */
+					  /*          READ_CONTROL |          */
+					  /*          SYNCHRONIZE             */
+
+#define FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA | FILE_READ_ATTRIBUTES)
+#define FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
+				| FILE_WRITE_EA | FILE_WRITE_ATTRIBUTES)
+#define FILE_EXEC_RIGHTS (FILE_EXECUTE)
+
+#define CLIENT_SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA | FILE_WRITE_EA \
+				| FILE_READ_ATTRIBUTES \
+				| FILE_WRITE_ATTRIBUTES \
+				| DELETE | READ_CONTROL | WRITE_DAC \
+				| WRITE_OWNER | SYNCHRONIZE)
+#define SERVER_SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA \
+				| FILE_READ_ATTRIBUTES \
+				| DELETE | READ_CONTROL | WRITE_DAC \
+				| WRITE_OWNER | SYNCHRONIZE)
+#define CLIENT_SET_FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
+				| FILE_READ_EA | FILE_WRITE_EA \
+				| FILE_READ_ATTRIBUTES \
+				| FILE_WRITE_ATTRIBUTES \
+				| DELETE | READ_CONTROL | WRITE_DAC \
+				| WRITE_OWNER | SYNCHRONIZE)
+#define SERVER_SET_FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
+				| FILE_WRITE_EA \
+				| FILE_DELETE_CHILD \
+				| FILE_WRITE_ATTRIBUTES \
+				| DELETE | READ_CONTROL | WRITE_DAC \
+				| WRITE_OWNER | SYNCHRONIZE)
+#define SET_FILE_EXEC_RIGHTS (FILE_READ_EA | FILE_WRITE_EA | FILE_EXECUTE \
+				| FILE_READ_ATTRIBUTES \
+				| FILE_WRITE_ATTRIBUTES \
+				| DELETE | READ_CONTROL | WRITE_DAC \
+				| WRITE_OWNER | SYNCHRONIZE)
+#define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
+				| READ_CONTROL | SYNCHRONIZE)
+
+/*
+ * File Attribute flags - see MS-SMB 2.2.1.4.1
  */
 #define ATTR_READONLY  0x0001
 #define ATTR_HIDDEN    0x0002
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index f79a5165a7cc..f2fbd651ab8f 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1149,12 +1149,6 @@ struct smb2_server_client_notification {
 #define FILE_OVERWRITE_IF_LE		cpu_to_le32(0x00000005)
 #define FILE_CREATE_MASK_LE             cpu_to_le32(0x00000007)
 
-#define FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA \
-			| FILE_READ_ATTRIBUTES)
-#define FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
-			| FILE_WRITE_EA | FILE_WRITE_ATTRIBUTES)
-#define FILE_EXEC_RIGHTS (FILE_EXECUTE)
-
 /* CreateOptions Flags */
 #define FILE_DIRECTORY_FILE_LE		cpu_to_le32(0x00000001)
 /* same as #define CREATE_NOT_FILE_LE	cpu_to_le32(0x00000001) */
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 810fad0303d7..df67b370025d 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -38,61 +38,6 @@
 #define F_CREATED	2
 #define F_OVERWRITTEN	3
 
-#define FILE_READ_DATA        0x00000001  /* Data can be read from the file   */
-#define FILE_WRITE_DATA       0x00000002  /* Data can be written to the file  */
-#define FILE_APPEND_DATA      0x00000004  /* Data can be appended to the file */
-#define FILE_READ_EA          0x00000008  /* Extended attributes associated   */
-/* with the file can be read        */
-#define FILE_WRITE_EA         0x00000010  /* Extended attributes associated   */
-/* with the file can be written     */
-#define FILE_EXECUTE          0x00000020  /*Data can be read into memory from */
-/* the file using system paging I/O */
-#define FILE_DELETE_CHILD     0x00000040
-#define FILE_READ_ATTRIBUTES  0x00000080  /* Attributes associated with the   */
-/* file can be read                 */
-#define FILE_WRITE_ATTRIBUTES 0x00000100  /* Attributes associated with the   */
-/* file can be written              */
-#define DELETE                0x00010000  /* The file can be deleted          */
-#define READ_CONTROL          0x00020000  /* The access control list and      */
-/* ownership associated with the    */
-/* file can be read                 */
-#define WRITE_DAC             0x00040000  /* The access control list and      */
-/* ownership associated with the    */
-/* file can be written.             */
-#define WRITE_OWNER           0x00080000  /* Ownership information associated */
-/* with the file can be written     */
-#define SYNCHRONIZE           0x00100000  /* The file handle can waited on to */
-/* synchronize with the completion  */
-/* of an input/output request       */
-#define GENERIC_ALL           0x10000000
-#define GENERIC_EXECUTE       0x20000000
-#define GENERIC_WRITE         0x40000000
-#define GENERIC_READ          0x80000000
-/* In summary - Relevant file       */
-/* access flags from CIFS are       */
-/* file_read_data, file_write_data  */
-/* file_execute, file_read_attributes*/
-/* write_dac, and delete.           */
-
-#define SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA \
-		| FILE_READ_ATTRIBUTES \
-		| DELETE | READ_CONTROL | WRITE_DAC \
-		| WRITE_OWNER | SYNCHRONIZE)
-#define SET_FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
-		| FILE_WRITE_EA \
-		| FILE_DELETE_CHILD \
-		| FILE_WRITE_ATTRIBUTES \
-		| DELETE | READ_CONTROL | WRITE_DAC \
-		| WRITE_OWNER | SYNCHRONIZE)
-#define SET_FILE_EXEC_RIGHTS (FILE_READ_EA | FILE_WRITE_EA | FILE_EXECUTE \
-		| FILE_READ_ATTRIBUTES \
-		| FILE_WRITE_ATTRIBUTES \
-		| DELETE | READ_CONTROL | WRITE_DAC \
-		| WRITE_OWNER | SYNCHRONIZE)
-
-#define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
-		| READ_CONTROL | SYNCHRONIZE)
-
 /* generic flags for file open */
 #define GENERIC_READ_FLAGS	(READ_CONTROL | FILE_READ_DATA | \
 		FILE_READ_ATTRIBUTES | \
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 5aa7a66334d9..b70ba50f1f10 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -180,7 +180,7 @@ static void mode_to_access_flags(umode_t mode, umode_t bits_to_use,
 	 * either user or group or other as per bits_to_use
 	 */
 	if (mode & 0444)
-		*pace_flags |= SET_FILE_READ_RIGHTS;
+		*pace_flags |= SERVER_SET_FILE_READ_RIGHTS;
 	if (mode & 0222)
 		*pace_flags |= FILE_WRITE_RIGHTS;
 	if (mode & 0111)
-- 
2.43.0

