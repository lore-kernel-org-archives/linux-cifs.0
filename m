Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZJyQ4vPn"
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3E4D2
	for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 21:24:01 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1cf7a8ab047so27633635ad.1
        for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 21:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701062640; x=1701667440; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=55zaXsmumzrvVj2q6cpQGNFk0JSLlEbaJuDxQuCETNM=;
        b=ZJyQ4vPnKJBSSPqnQKR+ubzYaodyYPiyndW2sLaz7uvThX3jiJoILUbDCRvW+OD4dN
         6LMeCowLIo6UIarY88E1Dx5hF6G9gePdAJ39lfFcVEWhFowf3MEqSC7oajutStyXcsxM
         BK3bJbT07RBedMnVQzhnF0t6237xS3OVIopWh4wYOJ49VP02jCPRS2J7HkZLXYzNIAfQ
         OE/Po1r/cKRJeKpyyKcQv8xs3ULEdMYYdvis5uxwAWDUauE+Ly4vWybrCcjZxY4sGbsz
         LBbzqcQBktR53TDrCcZ6srtuQ6F5hnHXFRLKfUBNkQft0lGehIgHJKpASKfixUwl5r+h
         Bdxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701062640; x=1701667440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=55zaXsmumzrvVj2q6cpQGNFk0JSLlEbaJuDxQuCETNM=;
        b=c5B1n4qy66ZuWFbSdhTuVIZRY5ghsAS6y3yL+VDKtE8AF6GeCzk0qUj92GEEwMY3+j
         YyEBKeT4rxUpxbjWMYytvaj5CWnuzpxH9GsTVasa3KrbhOeop6bN45+E8gdEQQdA8j0C
         +BejO0lQG2JFwf2/1xI2kbxPAKCZmcgRPI5+srD5eg0stt3SnkBQ8Y7kpdY4y4DLbefy
         Y8WcvMYUrqyfyCbmNVJ7M22N+Xb28BS0dIX7luzyWSwd/r2UUkXS9Qg5HFfXGAm+6rfP
         5908agRhckm0UFZBPHqt2vmCYFnumVkvDtoYGIekbs5d7mrkTKSOjaHtL+UZhHClyZ5G
         vpOw==
X-Gm-Message-State: AOJu0YzO22VNfTc3DZIlhJJ78I7Zb0jdebFouguvyzuEW2Hsl9DJ6gqQ
	zdQArIq+MfEmoQ7f+Ed7iGv+rBQRSsk=
X-Google-Smtp-Source: AGHT+IECJ6GIynOtoT0XgFuHoaKWBivgMsAx3vVGiH6jyC044UFT1brQF19FmTyrwRw7pUBApPxfsQ==
X-Received: by 2002:a17:903:246:b0:1cc:3a8a:f19b with SMTP id j6-20020a170903024600b001cc3a8af19bmr10211069plh.14.1701062640338;
        Sun, 26 Nov 2023 21:24:00 -0800 (PST)
Received: from debian (c-73-109-30-110.hsd1.wa.comcast.net. [73.109.30.110])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e5cb00b001cfbd011ca9sm2820643plf.113.2023.11.26.21.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Nov 2023 21:24:00 -0800 (PST)
Date: Sun, 26 Nov 2023 21:22:37 -0800
From: Pierre Mariani <pierre.mariani@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, pierre.mariani@gmail.com
Subject: [PATCH v2 3/3] smb: client: Fix checkpatch whitespace errors and
 warnings
Message-ID: <353fe227f343ab14ecaf70f1bce009408543ba08.1701062286.git.pierre.mariani@gmail.com>
References: <3c4154d3192607277bc3a7453f05cbae8a7bba5b.1701062286.git.pierre.mariani@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c4154d3192607277bc3a7453f05cbae8a7bba5b.1701062286.git.pierre.mariani@gmail.com>

Fixes no-op checkpatch errors and warnings.

Signed-off-by: Pierre Mariani <pierre.mariani@gmail.com>
---
 fs/smb/client/connect.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 26e3eeda0c4c..b014488d5232 100644
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
@@ -2606,8 +2610,8 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
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
@@ -2752,7 +2756,6 @@ cifs_put_tlink(struct tcon_link *tlink)
 	if (!IS_ERR(tlink_tcon(tlink)))
 		cifs_put_tcon(tlink_tcon(tlink));
 	kfree(tlink);
-	return;
 }
 
 static int
@@ -2893,6 +2896,7 @@ static inline void
 cifs_reclassify_socket4(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
+
 	BUG_ON(!sock_allow_reclassification(sk));
 	sock_lock_init_class_and_name(sk, "slock-AF_INET-CIFS",
 		&cifs_slock_key[0], "sk_lock-AF_INET-CIFS", &cifs_key[0]);
@@ -2902,6 +2906,7 @@ static inline void
 cifs_reclassify_socket6(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
+
 	BUG_ON(!sock_allow_reclassification(sk));
 	sock_lock_init_class_and_name(sk, "slock-AF_INET6-CIFS",
 		&cifs_slock_key[1], "sk_lock-AF_INET6-CIFS", &cifs_key[1]);
@@ -2936,15 +2941,18 @@ static int
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
@@ -3174,6 +3182,7 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 
 	if (!CIFSSMBQFSUnixInfo(xid, tcon)) {
 		__u64 cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
+
 		cifs_dbg(FYI, "unix caps which server supports %lld\n", cap);
 		/*
 		 * check for reconnect case in which we do not
@@ -3677,7 +3686,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 	smb_buffer_response = smb_buffer;
 
 	header_assemble(smb_buffer, SMB_COM_TREE_CONNECT_ANDX,
-			NULL /*no tid */ , 4 /*wct */ );
+			NULL /*no tid */, 4 /*wct */);
 
 	smb_buffer->Mid = get_next_mid(ses->server);
 	smb_buffer->Uid = ses->Suid;
@@ -3696,12 +3705,12 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
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

