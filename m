Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D9C2494D8;
	Tue, 14 Oct 2025 07:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760427032; cv=none; b=mBBJnuqIMuS+1BR9aaMrPfn1+GLmvqqLsCoMqDI3w+/kuD3NGxfwwda6GK329IAwFWP5qG0iEjucBtWwPaUnWFNIkP/64ymbiQ6v2ahoAy5N1DRbuK7TYWSYeRiIWfWrDMkiIvosUlZLFdVH26zSS69WZd0qDiECaatZfleupd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760427032; c=relaxed/simple;
	bh=0jipzrpcnVOgT74CwCWD0FKFQxM2RdUoPYok6jhANYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRCd6N2DR5ewwzgR/7PEs6Ds4zvHIgovcpatpbjHU0FIizsNiunxWBZreZlFb4t7sk2R7Hb55yUczR6vnQZGc8OuTHxUzDlRG0+ue5f5Wfr0RwQtKBH+uLcmE59ltY2c/3Jxh/F/A/PgQylBfBVEmsC2HhtHDqniRgmiDoUQc7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t/cYiBzS; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t/cYiBzS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760427022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BhiadZd0eLVaDCJ9iCbJOhOhaAl2OsCDQz9sL2LVPXk=;
	b=t/cYiBzSNX8gozHlsE90HQI4BUJl1gjIjzNi0rMP/9GeZ2HVsNVDQwxa3fpeFvr9/t3xIl
	5e0qRz4wLSb6bC74ZoCMAFQgND02q4EiopsH7vaivzoi2DZd+jsuqJ9kAjfOiJJuIKw3FL
	/qsrKGCRqfOIVck1eGQpUbyQP28cgqI=
From: chenxiaosong.chenxiaosong@linux.dev
To: stfrench@microsoft.com,
	metze@samba.org,
	pali@kernel.org,
	linkinjeon@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 13/22] smb: move file access permission bits definitions to common/cifspdu.h
Date: Tue, 14 Oct 2025 15:28:47 +0800
Message-ID: <20251014072856.3004683-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251014072856.3004683-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251014072856.3004683-1-chenxiaosong.chenxiaosong@linux.dev>
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

  - SET_FILE_READ_RIGHTS
  - SET_FILE_WRITE_RIGHTS

Perhaps in the future we can change them to be the same.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsacl.c    |   4 +-
 fs/smb/client/cifspdu.h    | 112 ---------------------------------
 fs/smb/common/cifspdu.h    | 123 ++++++++++++++++++++++++++++++++++++-
 fs/smb/common/smb2pdu.h    |   6 --
 fs/smb/server/smb_common.h |  55 -----------------
 fs/smb/server/smbacl.c     |   2 +-
 6 files changed, 125 insertions(+), 177 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 63b3b1290bed..ef12ae0fddb3 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -655,9 +655,9 @@ static void mode_to_access_flags(umode_t mode, umode_t bits_to_use,
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
index 9f42b0469d1a..a0883b1fda16 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -116,118 +116,6 @@
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
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index ca16741b5947..59e5425cdc8d 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -77,7 +77,128 @@
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
index f5c8c72b8959..40689c11e97a 100644
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
index a326809f7765..90015cd8fe4e 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -37,61 +37,6 @@
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

