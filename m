Received: from smtpbg154.qq.com (smtpbg154.qq.com [15.184.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A4329AAF8;
	Sun, 12 Oct 2025 15:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=15.184.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760281911; cv=none; b=gH5xwM6JnmlS4B1DevxAkFL4jmQNSSgqBLTKaZo6RDJqSnyiq5SYJzvEtXWTMoJf9eCOdiiYZtbJjW6OyBhVHTut+6dO1DNeIDk+GEj4+WsgE3KzR3dvkZ7gOW8AFBe7SSN2SCA8yWngwFHXO7PZwYt4cwxj1LPMk477fZEWGro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760281911; c=relaxed/simple;
	bh=kV6Tt6gzqKXi9CitHgRtyQsuEujD+nsj1u8QElwcN2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvAaS+9dWWbCp25B7f43l7oU3p0V13QsREe51SuxfCTA8JePp7jfvivsjpO/SYU4IZb5M9B3Hb8hIJIwUiUFuAt0h9JIQhGqDphCAZLK0AC5Bs558UfoPI2OKIcdeLiVcTBErv3K/mEnA929j2yn5EThhRvlQjVqlQBvGJzjrRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=15.184.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz9t1760281818t30d02601
X-QQ-Originating-IP: 4T3y8AdGX3KtkBO90drlOfE9sq7siHnM75Fkw+PEMIQ=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:10:17 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 831036991751228392
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
Subject: [PATCH 06/22] smb: move SMB1_PROTO_NUMBER to common/cifsglob.h
Date: Sun, 12 Oct 2025 23:08:59 +0800
Message-ID: <2AC3F0FD2E1F3D39+20251012150915.2992220-7-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: OH2bKVRJtexU4ZSOOzomo7gSs+T1nEFtYZMOuO4lbFrOUNKxc8qUuhpj
	8ZeXP0AT736JHPcHnfgGUoThC+P5UWBrpmO39LMv4qXdHCpJ3lx35BzNE2e26LWOFwW8zhz
	X9/5U7NQomw45J1RLbeSH7fWnuuE63GOvNDuFsK3q938UiLTpv/Dw95IsAfJYMniDQJH1Ny
	muE98PE+KWMOu9ImkpUaF01QWwL26x9Ug+HSORjofruXmEM6pmABWL44+84FqQ+1llTVrt1
	gZWltEPb4KaiRnTs0RFJuOV1eFBQOM/N2tuQ0pDkIU14R1mAAU9OY69FT/GHexcD8H4sA2k
	cE95BCAISfP1XVIGMnyv8bl7N674zHg1bElB9PWR7gzp0xI4zLRq9otDdm6gpgsQ3g1XH9u
	YGIqMJMa9D3eZMTT6nlobu9xhehHzV23tMtfQ8HnUS5l+LesgmJi8GuEsdwcXnLQZa5oIJh
	Da5dr8S1BNsaAe0IFgEyENufzAWoq3G5gnqQSefjjnqcgxk6IyyO0J/EuVSV0Mreg4sjp8h
	DKJZph2kbT1TuoXjwMNFFliC1OKp/561K0AQMBMs7P6so+cJiP0qNJ3QJRu3ye819tWtT9Y
	7RZo78v9+hlBfRSmOQKrCggByqaOHg+jIZ134eg+MIYgLhEXpZ4tl7o7cp3+lfMUciu4H0s
	8f5uYABl8+/bxmgx7XazEvnrcd3DIrQ1dx96GrbHxF0n4QKa7GfDvVVa4ZM6C0CrGl+CCFu
	DvxumviEk8ykc8W53ghDzS+BikngW1gp1BQNGkIErbaSAKX/NuQxjJ6XuYXlTfX8pHpRYNf
	aMHvREEklEFJQpzD1nN5su7vkWtD1IkKctAPD5VzqZBYIXDOIxLqxUdeniCWifeU7t2fKp8
	MKFW5t2Io1FERUjVgk0DZbjpz3VDFBXvUeEsqUwuEPB9vFhK5c85bgiK0+HvcMdNwmkUC+X
	MqkJBLR//f4yXv8vX0tX5cQMzBnLFVnk1ezKAgn3+HzMWZFjIGjVWaz3FVPmQy8np3IA=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-QQ-RECHKSPAM: 0

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Replace the constant of client with SMB1_PROTO_NUMBER, then move the
macro definition from server/smb_common.h to common/cifsglob.h, maybe
the server will use this macro definition in the future.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/client/misc.c       | 2 +-
 fs/smb/common/cifsglob.h   | 2 ++
 fs/smb/server/smb_common.h | 1 -
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index dda6dece802a..15be9d8738ab 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -318,7 +318,7 @@ static int
 check_smb_hdr(struct smb_hdr *smb)
 {
 	/* does it have the right SMB "signature" ? */
-	if (*(__le32 *) smb->Protocol != cpu_to_le32(0x424d53ff)) {
+	if (*(__le32 *) smb->Protocol != cpu_to_le32(SMB1_PROTO_NUMBER)) {
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

