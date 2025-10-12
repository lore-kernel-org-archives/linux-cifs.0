Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.65.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4461C2EDD6D;
	Sun, 12 Oct 2025 15:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.155.65.254
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760282673; cv=none; b=V2e6fib0RRjmsB4emFk2Cy6nZBAdviQ+I6nnqhO+Z5TysKbjG2UV+r2Za+v9xqoL2pPapotfP8aZU9t7AucZAbPiFOMaPkxdYYrWPIp1FcVHeTwf/0f29WcCxkvnAkbtOY6AN6LFS+4oXk3kZWuEtgCS7terG7q/0FDcoqHDOFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760282673; c=relaxed/simple;
	bh=fUKthNy2wlDGAqzuUnZdkSIU7ZaaNp3xh67aJrzdFvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yx3WLlYZUZQ4XSqXAFdOgoXnwjTsf/zPNTarRfmHcBV23/uOa/T/c3dvmizgdVmvLCSIQD4CYy88OD4Avbi7TyCv4azfHsTxrDYWDq7nKJ9kIJLA4FUIj1czbrrUHVWpt6w90qrhmHLJuRMthW8EHszMmPNmPJvbBWdFL4Tq0GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=43.155.65.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: zesmtpgz3t1760282607t0748f230
X-QQ-Originating-IP: kD22IJkaGa+JVEBzM1Ey9RJPVR/aPuHzRaegwAwVlrE=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 12 Oct 2025 23:23:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 8893172405107320436
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
Subject: [PATCH RESEND 10/22] smb: move resume_key_ioctl_rsp to common/smb2pdu.h
Date: Sun, 12 Oct 2025 23:22:35 +0800
Message-ID: <070E98BAA8DB648C+20251012152247.2992573-11-chenxiaosong@chenxiaosong.com>
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
X-QQ-XMAILINFO: OZGW2/3qAmIfqJpqkUSBquOFHEjvlP/oo2HUPGsnVpGrw7s+Vvq1rYHo
	6bgFTMl8kd4o1W0KlgNVZndtpC5ztQHXFRcZcAMCEFgvYbjs7F5F7WPVW5Em/mXuTyU5C+5
	w3rmsD122CFAX48s3PbgnSe0tjk7z8Y2ca4zi5dllj/ArDNPPPJMvDGZ34kKDDUGxIGKGNE
	Cve1FUD3P2FRpYqGxDz4r1VMxVRpL2euFxMs95JRiJQ9Z0gAt62xQ0443MNMcApFWsWCl0z
	Q7W8gb7uJWePr+dkStxKM0JrMj9noGcCU3m4935pn1imNu55gu2GeJzQTdbAmMLErYR1Yq1
	YNA8eUllAxUDlr9wAzSBdgGBFgxCdw5QTuKzcsBCUcakIlHdmgn/gMz6RJfX59O3AMSZRVe
	vufGRVk0V6qoNU5apkSVyMAmIFSaOB7xAEJhJ+/hrmZAAy7v7uvPzlDORwxusyjZQyDMX3x
	cJPx2jLCW3SiEEoHWaVpoEBbJZt/7sgqJJU8XdA2MtzP8ShbPdPxayHUJMIl41x/UdQLLoR
	5ecE8/91JFmqX80GHGynoxyfYurO3HOkD29JIwpQ2IArhQzKf2N7lQJsHcljQl/eI8VCH2p
	cf3zhvpEHrPWjnVkZo4sQeaBRtvjXV1uHuxm/4BXrD3xmTGemgktJ6GzGmwk1yFV128mYGr
	e1lIguKC/V4JaxJI76bGOOvE8UMlF0Bzq98w5ZV4//A3cM79QyMTVnrv25skD3+GygOxjNk
	JwSNZbUjEbRp5F1WE6SWHqzW7bBdeieIYM1sRM+K5A3OVwXmIRHPVjTa5q0AJi8uUtzprYd
	6/jWdzleZ9Cb2lFQq7HPnR6i2lhctiva7KreES7TnOZCrp1WGN+5lvwoe7BHyj+IKqaKkem
	X17kTvYnUxY6W5eIwvM9B8IFbiyJJiOBMBA7+/tD+dXcvfWDcp2iCl4IGa8vKQJu5YK3GoZ
	pjicsjizx/bGdlhGmxgUVqVJYDn8XskBavlFfTa1jODkcJgmNA9CE7IFXKlGiIiS3EScfxc
	ftB4cFZjzj285lqmD5yIj/7NZC6ap9nDwoO5RBA9Goa757ZPcTWnMyA5qpZYfJ4qtDoPaz4
	8HV26SEb8m3tIicgLgWOUZu4yw7hGVe1g==
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-QQ-SPAM: true
X-QQ-RECHKSPAM: 3

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Rename 2 places:

  - resume_key_req -> resume_key_ioctl_rsp
  - server: ResumeKey -> ResumeKeyU64

Merge the struct members of the server and the client, then move duplicate
definitions to common header file.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/client/smb2ops.c |  4 ++--
 fs/smb/client/smb2pdu.h |  6 ------
 fs/smb/common/smb2pdu.h | 10 ++++++++++
 fs/smb/server/smb2pdu.c |  4 ++--
 fs/smb/server/smb2pdu.h |  6 ------
 5 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ea9709d81851..8da5fe4efa2d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1528,7 +1528,7 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	int rc;
 	unsigned int ret_data_len;
-	struct resume_key_req *res_key;
+	struct resume_key_ioctl_rsp *res_key;
 
 	rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
 			FSCTL_SRV_REQUEST_RESUME_KEY, NULL, 0 /* no input */,
@@ -1541,7 +1541,7 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_tcon_dbg(VFS, "refcpy ioctl error %d getting resume key\n", rc);
 		goto req_res_key_exit;
 	}
-	if (ret_data_len < sizeof(struct resume_key_req)) {
+	if (ret_data_len < sizeof(struct resume_key_ioctl_rsp)) {
 		cifs_tcon_dbg(VFS, "Invalid refcopy resume key length\n");
 		rc = -EINVAL;
 		goto req_res_key_exit;
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 9b5880e60a4e..77dceca20240 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -191,12 +191,6 @@ struct crt_sd_ctxt {
 	struct smb3_sd sd;
 } __packed;
 
-struct resume_key_req {
-	char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
-	__le32	ContextLength;	/* MBZ */
-	char	Context[];	/* ignored, Windows sets to 4 bytes of zero */
-} __packed;
-
 /* See MS-FSCC 2.3.29 and 2.3.30 */
 struct get_retrieval_pointer_count_req {
 	__le64 StartingVcn; /* virtual cluster number (signed) */
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 857e6a577e84..15932ee05c98 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1421,6 +1421,16 @@ struct copychunk_ioctl_rsp {
 	__le32 TotalBytesWritten;
 } __packed;
 
+/* See MS-SMB2 2.2.32.3 */
+struct resume_key_ioctl_rsp {
+	union {
+		char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
+		__u64 ResumeKeyU64[3];
+	};
+	__le32	ContextLength;	/* MBZ */
+	char	Context[];	/* ignored, Windows sets to 4 bytes of zero */
+} __packed;
+
 struct smb2_ioctl_rsp {
 	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 49 */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 846cca45195b..200bce13b467 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8115,8 +8115,8 @@ static int fsctl_request_resume_key(struct ksmbd_work *work,
 		return -ENOENT;
 
 	memset(key_rsp, 0, sizeof(*key_rsp));
-	key_rsp->ResumeKey[0] = req->VolatileFileId;
-	key_rsp->ResumeKey[1] = req->PersistentFileId;
+	key_rsp->ResumeKeyU64[0] = req->VolatileFileId;
+	key_rsp->ResumeKeyU64[1] = req->PersistentFileId;
 	ksmbd_fd_put(work, fp);
 
 	return 0;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index eecd1f1f5505..3d000c5d964b 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -151,12 +151,6 @@ struct file_object_buf_type1_ioctl_rsp {
 	__u8 DomainId[16];
 } __packed;
 
-struct resume_key_ioctl_rsp {
-	__u64 ResumeKey[3];
-	__le32 ContextLength;
-	__u8 Context[4]; /* ignored, Windows sets to 4 bytes of zero */
-} __packed;
-
 struct file_sparse {
 	__u8	SetSparse;
 } __packed;
-- 
2.43.0

