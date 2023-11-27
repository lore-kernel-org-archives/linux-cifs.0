Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EddBnaaL"
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBA311B
	for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 20:52:59 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-5bd306f86a8so2569430a12.0
        for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 20:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701060778; x=1701665578; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BP9yAem4I4lZebSeh8gfMO8NQkE1HVsF4wxWOmIJcrE=;
        b=EddBnaaLtiMfs7hw3oxjAGrKuM0U3XtwxtXLd3HZPhD9Q0BhbJ8gNrRgz/ajyFtXY7
         dK6rPvRVPhw+F2AKh4SfL7q3Y2A3GAz6Hy+LnGfV+1VX7Fq2b5QhK3r8jEfJbN35sy9o
         DO2QWeNe4wn8VN98oMgiuOWTEyvd+rrDXcbMZ76qUxkpEQsIKHcCV9gm6e72XhdHs52E
         pFcxXUhPRZh/h9Yagat4NxSUNtqAJThWY3G7p178woduTzE0sI/PDLG6ftYe7VHr2+2Y
         qBVki536uwok+RUfZTZQRtHUm8S8tmfL0TNE2tYIU26eycPg7TY3EsmHxIXDY/MQQ6DH
         jGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701060778; x=1701665578;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BP9yAem4I4lZebSeh8gfMO8NQkE1HVsF4wxWOmIJcrE=;
        b=eRGIt9J76HmEO2pf2cZP7c+Jc9vB2X7Wx4hSlXwmKRVr779KxPHMKO1lU5F6L45JVq
         +1jApNAWOl0Ow3Rds5ZwuzUWx/1xxUw8jMzkVGWeHAQFmdfh8SPjXV/FgNiJJ5veVWs0
         3FVl0LG07scHk8hZcLGswBpP60bnIZT7qMn9HuxY/40vshyrsb5PiNEPlyC7mfu4Kcqj
         zqhufg9pdsf1WwFIhxmZ5j/CCM6CICBYtvjjSCLuOYzvCPFqc/TNcZXxQ8RejmFgRG2M
         xEZXnsiNCyPOAacuQkNKxxG8QoQW1Nky2x6f+yTkwvLza0ZNhkBP5hA3N/H2iycNieZR
         JdOw==
X-Gm-Message-State: AOJu0YxgGjRdgKqD2DC7hUZssrxa6NE+O61sMQjIO+IC7qB4EXs1FFmw
	O1jEDFox9vbokrpY9Z5iynTn+Wa6Xh4=
X-Google-Smtp-Source: AGHT+IHlrutzZCiElxyX/H0HE21qS0h/5gfvkPHb4MaH3PKvEYPyrnJmVuiDUDLJYZRlJLD/XNngQw==
X-Received: by 2002:a17:90a:a08e:b0:280:3650:382a with SMTP id r14-20020a17090aa08e00b002803650382amr10295225pjp.16.1701060778390;
        Sun, 26 Nov 2023 20:52:58 -0800 (PST)
Received: from debian (c-73-109-30-110.hsd1.wa.comcast.net. [73.109.30.110])
        by smtp.gmail.com with ESMTPSA id nh19-20020a17090b365300b002851466f471sm6541051pjb.31.2023.11.26.20.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Nov 2023 20:52:58 -0800 (PST)
Date: Sun, 26 Nov 2023 20:52:56 -0800
From: Pierre Mariani <pierre.mariani@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, pierre.mariani@gmail.com
Subject: [PATCH 4/4] smb: client: Fix checkpatch whitespace errors and
 warnings
Message-ID: <b8c930087bbe9f2a4771e9b5a007fd0208cd1b6c.1701060106.git.pierre.mariani@gmail.com>
References: <b9f9f617abc69d0a7ddb3109bc257073c8b165de.1701060106.git.pierre.mariani@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9f9f617abc69d0a7ddb3109bc257073c8b165de.1701060106.git.pierre.mariani@gmail.com>

Fixes no-op checkpatch errors and warnings.

Signed-off-by: Pierre Mariani <pierre.mariani@gmail.com>
---
 fs/smb/client/connect.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index a381c4cdb8c4..59f95ea5105e 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -482,6 +482,7 @@ static int reconnect_target_unlocked(struct TCP_Server_Info *server, struct dfs_
 static int reconnect_dfs_server(struct TCP_Server_Info *server)
 {
 	struct dfs_cache_tgt_iterator *target_hint = NULL;
+
 	DFS_CACHE_TGT_LIST(tl);
 	int num_targets = 0;
 	int rc = 0;
@@ -750,6 +751,7 @@ cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 {
 	struct msghdr smb_msg = {};
 	struct kvec iov = {.iov_base = buf, .iov_len = to_read};
+
 	iov_iter_kvec(&smb_msg.msg_iter, ITER_DEST, &iov, 1, to_read);
 
 	return cifs_readv_from_socket(server, &smb_msg);
@@ -1400,11 +1402,13 @@ cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs)
 	case AF_INET: {
 		struct sockaddr_in *saddr4 = (struct sockaddr_in *)srcaddr;
 		struct sockaddr_in *vaddr4 = (struct sockaddr_in *)rhs;
+
 		return (saddr4->sin_addr.s_addr == vaddr4->sin_addr.s_addr);
 	}
 	case AF_INET6: {
 		struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
 		struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)rhs;
+
 		return (ipv6_addr_equal(&saddr6->sin6_addr, &vaddr6->sin6_addr)
 			&& saddr6->sin6_scope_id == vaddr6->sin6_scope_id);
 	}
@@ -2605,8 +2609,8 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 			rc = -EOPNOTSUPP;
 			goto out_fail;
 		} else {
-			cifs_dbg(VFS, "Check vers= mount option. SMB3.11 "
-				"disabled but required for POSIX extensions\n");
+			cifs_dbg(VFS,
+				"Check vers= mount option. SMB3.11 disabled but required for POSIX extensions\n");
 			rc = -EOPNOTSUPP;
 			goto out_fail;
 		}
@@ -2751,7 +2755,6 @@ cifs_put_tlink(struct tcon_link *tlink)
 	if (!IS_ERR(tlink_tcon(tlink)))
 		cifs_put_tcon(tlink_tcon(tlink));
 	kfree(tlink);
-	return;
 }
 
 static int
@@ -2892,6 +2895,7 @@ static inline void
 cifs_reclassify_socket4(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
+
 	BUG_ON(!sock_allow_reclassification(sk));
 	sock_lock_init_class_and_name(sk, "slock-AF_INET-CIFS",
 		&cifs_slock_key[0], "sk_lock-AF_INET-CIFS", &cifs_key[0]);
@@ -2901,6 +2905,7 @@ static inline void
 cifs_reclassify_socket6(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
+
 	BUG_ON(!sock_allow_reclassification(sk));
 	sock_lock_init_class_and_name(sk, "slock-AF_INET6-CIFS",
 		&cifs_slock_key[1], "sk_lock-AF_INET6-CIFS", &cifs_key[1]);
@@ -2935,15 +2940,18 @@ static int
 bind_socket(struct TCP_Server_Info *server)
 {
 	int rc = 0;
+
 	if (server->srcaddr.ss_family != AF_UNSPEC) {
 		/* Bind to the specified local IP address */
 		struct socket *socket = server->ssocket;
+
 		rc = kernel_bind(socket,
 				 (struct sockaddr *) &server->srcaddr,
 				 sizeof(server->srcaddr));
 		if (rc < 0) {
 			struct sockaddr_in *saddr4;
 			struct sockaddr_in6 *saddr6;
+
 			saddr4 = (struct sockaddr_in *)&server->srcaddr;
 			saddr6 = (struct sockaddr_in6 *)&server->srcaddr;
 			if (saddr6->sin6_family == AF_INET6)
@@ -3173,6 +3181,7 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 
 	if (!CIFSSMBQFSUnixInfo(xid, tcon)) {
 		__u64 cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
+
 		cifs_dbg(FYI, "unix caps which server supports %lld\n", cap);
 		/*
 		 * check for reconnect case in which we do not
@@ -3676,7 +3685,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 	smb_buffer_response = smb_buffer;
 
 	header_assemble(smb_buffer, SMB_COM_TREE_CONNECT_ANDX,
-			NULL /*no tid */ , 4 /*wct */ );
+			NULL /*no tid */, 4 /*wct */);
 
 	smb_buffer->Mid = get_next_mid(ses->server);
 	smb_buffer->Uid = ses->Suid;
@@ -3695,12 +3704,12 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 	if (ses->server->sign)
 		smb_buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
 
-	if (ses->capabilities & CAP_STATUS32) {
+	if (ses->capabilities & CAP_STATUS32)
 		smb_buffer->Flags2 |= SMBFLG2_ERR_STATUS;
-	}
-	if (ses->capabilities & CAP_DFS) {
+
+	if (ses->capabilities & CAP_DFS)
 		smb_buffer->Flags2 |= SMBFLG2_DFS;
-	}
+
 	if (ses->capabilities & CAP_UNICODE) {
 		smb_buffer->Flags2 |= SMBFLG2_UNICODE;
 		length =
-- 
2.39.2

