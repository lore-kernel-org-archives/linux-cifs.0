Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980D4433D5;
	Tue, 24 Dec 2024 15:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735052934; cv=none; b=T0ka5hJvf7PUjFcAFmJazOz05qWXX3oL/KW0WtFIJtVr+AahA/5Ri26AJi1wlnIK/pLUJB653khF8G6ECp2bs5zXDmmpPYd8/rBfZ0b+YvKzGMqa6sZeiXuwz7kJ6R0j/RVh4rmGvCHf+32vV+MvwoQ5T9bagHeFiVKtHgDkQKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735052934; c=relaxed/simple;
	bh=t+eTCTW8q86a8W3zzragF/IFMO+Udsti7SmsXAau0ZY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Ahl3FOs+ipBdyAf0PYpsNiTTxrIF1SCVMhjZCjLrUN3JuT2aBK08KproCClrls+Pvf+yrXQVTmZhnCZGf69TNlzzh+q/lmKQQcIOfWrJQ9SSyb6diPFM82uuHcshqQawWK7YnOJ4Kk1gzFasSm5elKzkdMPNeTDeJTnk4DKZrCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HwNRi38S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HwNRi38S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB500C4CED0;
	Tue, 24 Dec 2024 15:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735052934;
	bh=t+eTCTW8q86a8W3zzragF/IFMO+Udsti7SmsXAau0ZY=;
	h=From:To:Cc:Subject:Date:From;
	b=HwNRi38SZx6Jxmvq+E6VbhGyrEAlYf8FJqoHyc90xUr8pY5SjJ/V/Siu18asW0/q3
	 8NQBnNQMJUd+DB9ElVP2LcmS4BSZYHr/9CKNiC7ki6b67M6O3xMV+cuG6namp9zaDl
	 TeOPxUOz4ln9qzmDhB89paUyRpp5vSOxSniKsKNY+HPUh2uHOxrYWbEMR8PUF1yxF9
	 z1yZQS182vgy9UDWmpJZgFaEv5NnPb7llF4UwTWqNMMbI65jnFcethr4McGj8buhSm
	 bJ+OjCdkjebZ5LbAR6mdVkEureDHBqukRfOQpOBtMckSdELO0eUEbT8lhjlrVAspdh
	 XAyFXsSEc5UMg==
Received: by pali.im (Postfix)
	id D14AD988; Tue, 24 Dec 2024 16:08:43 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Update description about ACL permissions
Date: Tue, 24 Dec 2024 16:08:29 +0100
Message-Id: <20241224150829.3926-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There are some incorrect information about individual SMB permission
constants like WRITE_DAC can change ownership, or incomplete information to
distinguish between ACL types (discretionary vs system) and there is
completely missing information how permissions apply for directory objects
and what is meaning of GENERIC_* bits.

Fix and extend description of all SMB permission constants to match the
reality, how the reference Windows SMB / NTFS implementation handles them.

Links to official Microsoft documentation related to permissions:
https://learn.microsoft.com/en-us/windows/win32/fileio/file-access-rights-constants
https://learn.microsoft.com/en-us/windows/win32/secauthz/access-mask
https://learn.microsoft.com/en-us/windows/win32/secauthz/standard-access-rights
https://learn.microsoft.com/en-us/windows/win32/secauthz/generic-access-rights
https://learn.microsoft.com/en-us/windows/win32/api/winternl/nf-winternl-ntcreatefile
https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntifs/nf-ntifs-ntcreatefile

Signed-off-by: Pali Rohár <pali@kernel.org>
---

Anyway, I see that these client constants are copied also in server
fs/smb/server/smb_common.h file. Maybe they could be deduplicated into
some fs/smb/common/* file?

---
 fs/smb/client/cifspdu.h | 77 ++++++++++++++++++++++++++++++++---------
 1 file changed, 60 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index f4c348b5c4f1..3ad1bb79ea9e 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -190,38 +190,81 @@
  */
 
 #define FILE_READ_DATA        0x00000001  /* Data can be read from the file   */
+					  /* or directory child entries can   */
+					  /* be listed together with the      */
+					  /* associated child attributes      */
+					  /* (so the FILE_READ_ATTRIBUTES on  */
+					  /* the child entry is not needed)   */
 #define FILE_WRITE_DATA       0x00000002  /* Data can be written to the file  */
+					  /* or new file can be created in    */
+					  /* the directory                    */
 #define FILE_APPEND_DATA      0x00000004  /* Data can be appended to the file */
+					  /* (for non-local files over SMB it */
+					  /* is same as FILE_WRITE_DATA)      */
+					  /* or new subdirectory can be       */
+					  /* created in the directory         */
 #define FILE_READ_EA          0x00000008  /* Extended attributes associated   */
 					  /* with the file can be read        */
 #define FILE_WRITE_EA         0x00000010  /* Extended attributes associated   */
 					  /* with the file can be written     */
 #define FILE_EXECUTE          0x00000020  /*Data can be read into memory from */
 					  /* the file using system paging I/O */
-#define FILE_DELETE_CHILD     0x00000040
+					  /* for executing the file / script  */
+					  /* or right to traverse directory   */
+					  /* (but by default all users have   */
+					  /* bypass traverse privilege and do */
+					  /* not need this permission at all) */
+#define FILE_DELETE_CHILD     0x00000040  /* Child entry can be deleted from  */
+					  /* the directory (so the DELETE on  */
+					  /* the child entry is not needed)   */
 #define FILE_READ_ATTRIBUTES  0x00000080  /* Attributes associated with the   */
-					  /* file can be read                 */
+					  /* file or directory can be read    */
 #define FILE_WRITE_ATTRIBUTES 0x00000100  /* Attributes associated with the   */
-					  /* file can be written              */
-#define DELETE                0x00010000  /* The file can be deleted          */
-#define READ_CONTROL          0x00020000  /* The access control list and      */
-					  /* ownership associated with the    */
-					  /* file can be read                 */
-#define WRITE_DAC             0x00040000  /* The access control list and      */
-					  /* ownership associated with the    */
-					  /* file can be written.             */
+					  /* file or directory can be written */
+#define DELETE                0x00010000  /* The file or dir can be deleted   */
+#define READ_CONTROL          0x00020000  /* The discretionary access control */
+					  /* list and ownership associated    */
+					  /* with the file or dir can be read */
+#define WRITE_DAC             0x00040000  /* The discretionary access control */
+					  /* list associated with the file or */
+					  /* directory can be written         */
 #define WRITE_OWNER           0x00080000  /* Ownership information associated */
-					  /* with the file can be written     */
+					  /* with the file/dir can be written */
 #define SYNCHRONIZE           0x00100000  /* The file handle can waited on to */
 					  /* synchronize with the completion  */
 					  /* of an input/output request       */
 #define SYSTEM_SECURITY       0x01000000  /* The system access control list   */
-					  /* can be read and changed          */
-#define MAXIMUM_ALLOWED       0x02000000
-#define GENERIC_ALL           0x10000000
-#define GENERIC_EXECUTE       0x20000000
-#define GENERIC_WRITE         0x40000000
-#define GENERIC_READ          0x80000000
+					  /* list associated with the file or */
+					  /* dir can be read or written       */
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
 					 /* In summary - Relevant file       */
 					 /* access flags from CIFS are       */
 					 /* file_read_data, file_write_data  */
-- 
2.20.1

