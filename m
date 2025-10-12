Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F452D5955;
	Sun, 12 Oct 2025 15:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282031; cv=none; b=fvcsPWLbY9fsO3fABQ4CRjB7FXDb0di0hYKdREScdRz4WXqJousPtequZXfryB+0duEmzGV+lwt1iPeAZgrq4DXHytzikb+UwbejW86DVC+2Y6skgkiHxBk/doD4jkawcUe0ltZP8VcQLXb+RhUg0RHnxtwE+y0kMR7ytWk76oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282031; c=relaxed/simple;
	bh=0jipzrpcnVOgT74CwCWD0FKFQxM2RdUoPYok6jhANYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eD2jC28XP0W4S5cKj7ObsALJ2U5QM78EV9ZEgprLmVDzTe+4TmWrPtUB6Ejl/O5o8yZ9/usXZiPZJzEHSjyMQk2Jo2PHPRwIjx6xc0MBXv0wpor9yBDKQXTjbhCBH2+9YLVEQmLnXO6yyJCjDJb5UZp9ssoKEAHunNJf21cfn3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281834t49ac9fc9
X-QQ-Originating-IP: 0qX3RFkM24JQCot8XnAwBekpEi2BqsyaHjNDTzFCqVs=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:33 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 2443235716937709161
From: chenxiaosong@chenxiaosong.com
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
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 13/22] smb: move file access permission bits definitions to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:09:06 +0800
Message-ID: <AF8B2D692DC13905+20251012150915.2992220-14-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
References: <20251012150915.2992220-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: MxZCU/CcMqmTxkwtizYCUR2bO2UuhlHCJlhrKu4Nh6VPQ+eYxVjeodB9
	+8hoI874LXwAhGt6+mBZBwjx8AV6ATDWt2Jv2/DilVAz1/JEpNDaXuTXeWUwM8FJr9z2tm/
	NAX6AYLuT4syyO3md9oDhqlgTNWEbprOwlbc1uXuCAFrOjK7fFfMRm29AvM66vM/pZXwlqt
	hGMQJZHZf2ImuCANjvtj2LqhGFpe3NNHYXU/l3subnufKTT9480SA2BiO9aCBGFwVOnBnE1
	q4jX9mByg7CNBUv2OUqJm/6s3JqaHjst7ZvVnKe62NfTx1fEuqDT3/JF0KKUvl4Re3bnip1
	2QQZh2eFIfYzhzqFUHJOMiCkK3P+mTBmRtoEEm3hpAWzCxG6eoPnJnO3gD6s9ALb+ab9QJ9
	LZfyz92rCXyjgXBNmL+kBxC5jTlzptLqsa5lm/5eBwaxHrfWXQozxY+aKw127nMyOBVJV83
	vGjmPmaIxAueG0JuLemicKKoDCg5LOW1+bSt2wz58/+VdSxUL+VLh+iF0kMqMhKc3l9qbGV
	POQuoa1TLMO0pvRgJ1oR5/Ye2tCVjBNo6bbsnFV0i/88L2kWtrOBnREL8YNH9NAUPEBqWxk
	FTYelASRhRKab8ItjW0ExqEiVk23IdhqDsFQMirPnAdAO4LQoXZkJOjKjAuPmwQeyeVcA+A
	7BGFPlFRYVckMqjTV2W4cZdW/4kzKczGpL0v5wLZ+jAIQvRL7Ad4y7TC+ElG9P4ZOblABRF
	o/V2WYTFnHrFUjpWLJApsyEgYv/4Wz+EjR0AdsPahzEiz5rMsY8sj2aIU0q/GESM9VeF0im
	ajUhXtuTtlwOpkabKSjnrOqkt2vXjUMKcdw9g/JBLNRC0eEC3cYmqSIKNtdZb8mtghny8wx
	kCfkB8sw+wJxP4DRQlhl8S3+8rvjq6jaFmyD3gI5Z/DMVhWZKQBAI+AVybdjwHh9uz+W2+T
	ozrAQRj3Tlw+At9wvJ01Vr4zZSuA+1Snyd5OfK4yeikMSaU25fgqrAf9DqRU/JiQab/7Ldp
	vVmVio1CbkWyQJSuy4kFn+Ww7OqjvnpqbPFeYLLA==
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
X-QQ-RECHKSPAM: 0

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

