Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBB62F0C49;
	Sun, 12 Oct 2025 15:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.154.54.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282707; cv=none; b=LXLB1NpWnAC/FqLYV598OmmDm9D85pkc0gWLdqzd8r6/1U4X9vhdRDzymq83kf6lYQTa6F+az7h4JyQ3mjN23Z1Vsswko1oimNIqDSmHA9DCJDTl0a9E/mAC/ieEtQTv1C8Q4PFXVPJStIWd3/Ab5QMHe/IGiHpKmjR9OlcrP8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282707; c=relaxed/simple;
	bh=0jipzrpcnVOgT74CwCWD0FKFQxM2RdUoPYok6jhANYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pW72UZsXan4otVyTNgecXQaBx1tb8lHxxwbayfl1rnYpnAT0To1rUibSBcF+7S6sAVBs0F6cZ6IW8MC7WaQvOc9NUB09ZYw+LZvBPtOfP1rSK6JRzIeuAEHfeml+pkk2AyQta6JsJ9Kri3ABi6nsjijTpHxXxPUr6Zz0LrsVqSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=43.154.54.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282612t0319cf40
X-QQ-Originating-IP: OdgH6tQljr5TqxoVV57rg8Df1br8jCg6SUHh2DslQq4=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:31 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 12378977562450041719
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
Subject: [PATCH RESEND 13/22] smb: move file access permission bits definitions to common/cifspdu.h
Date: Sun, 12 Oct 2025 23:22:38 +0800
Message-ID: <BC28FD4B3516E522+20251012152247.2992573-14-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
References: <20251012152247.2992573-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: M8BaT0GEeXPx0Uow4V6WvW0+qO90EIpLORrR6IMbXvb9CwKezmKmchQr
	aVC+SBlxyMBZyFLwCc4yWPOLVtGQY0JEMXJ6ECP3+qrv3iRQSVKb3LTt3pswkR7wq32qQvs
	ujRpCowPBstBmO8/w7YoK+BQ82sAdRDPLiWFp7s1lgdAhnfK3M2Xge0p43k9tEuTPKMy96t
	O3sc4IQ78ZleezHXSrYMQ6+9fb5VZoG4V82vs0eXp7jqYN/GS2yOg6ZB3GIpPO2HOHMMRkS
	qDOKI8tjl5JTwlBzcNUqPdDL8rKt/muyNMo5czaQec+biMLA/YGJ1BY3uoOX/rciU2CTPAg
	hjydNteGnXDRJ6SBP+pe1QT5HXYEuSfaQzJ1kH8QfsMFsqYPxYsO+gcM/pR71I2kpMbC4Ja
	LGEqz9wRv6z7l/2jyQYcXcYXOAw4wkWWzeXk6pyH9mLd8c0m/jjgnR3VBuzbdjbumMi1FXr
	3D/OpBHrArU+DJNyRjULSwV9Wxv7Cdv90Vhbr2RORyTIFSr/yfhvbWF3e8ZGx66hYdT+c1X
	MJZzTVWb2Igq/dv539+lg5YF+SIfE6vmE2qdnE93x9XLZZlrsMXFdcinXfryxvTcHjSm/jd
	EvMPkbR+3PqQb9iByp7WGrneaQcAfY0ZKCveibm8Xl9ArwuOv6h2133Y8XLuO9xw6K0p7gV
	vjvpyzsgGWP9kP8GC64sAxOmzKPc9EG6BgB28SvmvnlvkFwM5I42xjeGVCaGF1UIG/Gr1Ho
	ST5vqpJKZPUaqFh03rF+vDYKvB/XL6ZHVRGaSotrU0Th2dHCpLsV3PLSNjbJO1zjarTffEf
	fP7ovIuZF/V7i3sipDTyeJJMfWnBB5K0vMxcbnQKeIVkMgfCSbw8/Top4hjKYuu4tb6qAMB
	dg9RXAKU712d+8BotsrqkS5OljAlxdfd4W4WZ/xY9G1i7JldPYgX8+kOyJu/eb5xOYRu+o5
	vewpPq9BIF4psXkIXyxoQgSWbskq77MXE/jYz2krhJznwGK2r4RFnT30uavHVGqas6jGJN1
	mtwd201cldVSU+C077Nr74Ds0AEUwuu3QVhvTF0ZKRZJszRAS9XYulR+kvlZbzzVNvf6zrR
	+kZ3eantDIFajOCK8HOtQVKUWRoekIkCarKhNsb5sIj
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
X-QQ-SPAM: true
X-QQ-RECHKSPAM: 3

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

