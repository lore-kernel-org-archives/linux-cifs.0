Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5840D2EC0A6;
	Sun, 12 Oct 2025 16:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760285952; cv=none; b=aAnP4mj6N7dT52JGRjQDAWsr395h6cA0U85zZsoelDmDg2wTKOKMUmkIIrPGtqbqOa2lle5zkelkNnc7/ljpbbDHugXK+WjmZE498dFp0v09UVT18m7jj2+0VHk8JPfd1NhqK26V/VGMzV6Y0qAsZxUkRBoFGME8L82mg6z0Ccg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760285952; c=relaxed/simple;
	bh=aIPSHapUj79vhPrBmRJ9AVe1MQuxkmkJYsP/82h50xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUEj5SIWRFmBGlNYhbrg9Me7ZIMRBLweVTIfsSX8iS1ZIYeVBgUo3t4Oncj+V+e9InoJn3RRWiZF3qwkWkg0FUsQg/mgOus5l0mGwJarLAN2R537ugsFfGhZvI1Dp4ICFrM07yNp0NBfjjaD7tJY8d9Du/an5vnHL92yqgUXzAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285905t6d4a9fbb
X-QQ-Originating-IP: 8spMUJACftzZkW9xsqk9YVC2Ad1tWTHHhp6+LwxlXQ4=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:24 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 15088085253703853393
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
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH v2 06/22] smb: move SMB1_PROTO_NUMBER to common/cifsglob.h
Date: Mon, 13 Oct 2025 00:17:33 +0800
Message-ID: <66942D4891D3E571+20251012161749.2994033-7-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
References: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: OCFGt05vYz7Ym+ixKr1Rf2uiJD5ldkeIO5V8tQdwJ1JOCWAIw4hdXcjr
	0MU/nVlWWyR6KQ44smTbYkp1CxHE1cOw8IdYdQee9tDHZ678aqthxAOSYEE40HAJARSvp7s
	tWJqXXnyoK2M9jV0fnC2au0LOqclTqQJcGr3x1kq/KUclZtJ97cw7IhaXoovJzxi5tDfyOh
	5U0VaEomc8tEv/qv+1eUb57R04VPS3h7nLPu4hoLJblmmimlrtiMDF+eqfpGZj4s48/RnOv
	FLjE9eEQcjiX2lQJ0ZEwNzxTlbK7Kki0Xi2pMrV3sL/71MgwqGRq/SS4k+7gCGOl0SHP8z3
	6o9V6pG7Zp6ymWTWKbuBKAexbbOTjGKN7p6ReDA3PCJY3N1h1pjjjES603nPNgxT7CcO7gJ
	CU3508YmKU0mxtF0DIWUTBMp0qLllXDRUeyKgJWPmaD6VeTCVrqTpQ4AHKJJBT3c95Kk0Cb
	ibMP2/NIf+ce9oq03Rx9lHqoBmDJV1E/HPMXfE1KYt1s+lsiGlpUJBQextxziWuxJgAWSZO
	vyac4uiL64gvGHDagLFXdihMFuTvzggAWbWjKz1OUmpX6t9d+o9vMv2lKBOq38l+sdbYp9u
	WzhVWuaXqM1UDOxJhXC+jOrUUyil5hDIg8F3yErso0uRoJcVygL3BuRTLsZaTzY7JaNtNoH
	vqaYYHtDe7KkgnsheV7L4IzY2tBs0vziknsUCQeWsYSQp2JWpAmYMRRXoNEhHK7iQkfaM+/
	PGNnNmBh3yJR4QEt/aKLsSc+nqGQra9idYolihW5iD/7g4O+ndlTkdkQmYIr9PXxOseesV5
	Pyc9M2KTKXFeuVfjmnEKfKmo6d5tOjp7+ir/6jmV912SQqWcYSDnguKTtJ9LG7XjlBzwzJF
	G8sD9ZRFlSRhUR+AbbWvIA8BrR594R4fb3J11HHMyE8pAxJlnC7c5orSY9wlNPs2nnKSxSD
	DjPap0FCWC4tY0afMEIwoUm766maWpElROnU61ZKsYEMfJp5+oS8tlkUyWaGEHVpaRPhlAZ
	iKKsk/3oUZdPJSZjcFwgGxTcU15y6s2YPBRLwr5Uyrdr+OmGxeUC/4ISmb/+OtZwD6D8zrT
	Q==
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
X-QQ-RECHKSPAM: 0

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Replace the constant of client with SMB1_PROTO_NUMBER, then move the
macro definition from server/smb_common.h to common/cifsglob.h.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 fs/smb/client/misc.c       | 2 +-
 fs/smb/common/cifsglob.h   | 2 ++
 fs/smb/server/smb_common.h | 1 -
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index dda6dece802a..68607b7a68ca 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -318,7 +318,7 @@ static int
 check_smb_hdr(struct smb_hdr *smb)
 {
 	/* does it have the right SMB "signature" ? */
-	if (*(__le32 *) smb->Protocol != cpu_to_le32(0x424d53ff)) {
+	if (*(__le32 *) smb->Protocol != SMB1_PROTO_NUMBER) {
 		cifs_dbg(VFS, "Bad protocol string signature header 0x%x\n",
 			 *(unsigned int *)smb->Protocol);
 		return 1;
diff --git a/fs/smb/common/cifsglob.h b/fs/smb/common/cifsglob.h
index 371160fec1cd..5928d35c7f30 100644
--- a/fs/smb/common/cifsglob.h
+++ b/fs/smb/common/cifsglob.h
@@ -9,6 +9,8 @@
 #ifndef _COMMON_CIFS_GLOB_H
 #define _COMMON_CIFS_GLOB_H
 
+#define SMB1_PROTO_NUMBER		cpu_to_le32(0x424d53ff)
+
 struct smb_version_values {
 	char		*version_string;
 	__u16		protocol_id;
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 9c0db206624b..6d427dbed5fd 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -151,7 +151,6 @@
 		FILE_EXECUTE | FILE_DELETE_CHILD | \
 		FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
 
-#define SMB1_PROTO_NUMBER		cpu_to_le32(0x424d53ff)
 #define SMB_COM_NEGOTIATE		0x72
 #define SMB1_CLIENT_GUID_SIZE		(16)
 
-- 
2.43.0

