Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792946780;
	b=M/BzxvcWZrXI7Tfg2R+uQ3SFqnFT38XJxPB5CBg7sDr3KRbgTz4tOAmG/8NSGsSmE14S
	 cfGGARGWnmhxITjo90BK+ULeVkKfmndEDC63OnBomRO2bPJjj6U2I8kv/rA0do7nJl1XE
	 Si8qC9PjS9a8Qvm1JrT95edv5arfQrBBbt8owVRX++xB2wvPANpeL4NKXhBWi4pEegZ2e
	 U8rrYWrOXrg1Koj4Y3t7vbAQJM/GePRnMoJWeBwuPPhRFrGN94hOWT2b93NlmXNuYtR3z
	 mDAXp2Voh5c34n9UAPVX079pMtMYUQREb6C8rDOQHlyaml35UhCZgBgYPyyIf1nwkHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792946780;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=xG6MrCXFC7R3FF1J0tGLDByvgSJFyVyerh9PIkr8DcQ=;
	b=CKWNLt8dOlg913gxrsGE0dIM2KTD6xn0DvqQOxIir6YFwIi9Xcre9x/yse0ZYSNiyCP0
	 nGkPJ/mGqPQ4zSQBpNFN4y2/+56RDeXNWBIK+2a77vuPGXWNC2Eg9S7Wtg9j7/iZRAtP0
	 5NPKpf/MH+aHLSaF9GP2lpByGGbKabPEwB26aiqqxUA4Zl6r/8kV/WwaOO5B+SipMO3Km
	 PHfBdh3A+x5SRiZuH1GheuuvPqPCZJH4OFdqPKGFS8RBzYayyKQz0UKO7X93IS/xWwZ4c
	 3IxJsGVyMbcjujRqR1vom2PYSIJm+30pi94am5YQOvWqdaFNRMAyylbL4tJr6zpr3Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pDcw8uF4;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAE0606A31B
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 16:46:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9AAE0606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pDcw8uF4
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3acdcfa2bd3so1701382a91.3
        for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 09:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792946779; x=1793551579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xG6MrCXFC7R3FF1J0tGLDByvgSJFyVyerh9PIkr8DcQ=;
        b=pDcw8uF4GXPFER2LwaLozrGEMlbRBWKIeeQRXypzbGoXiU2il/EY4Jp8WMYpcRy9n7
         X59rvLqfsIFCCLPxBMo85Scvjnr4hiaVWdq58uNUMRTmui43HzAWTmynNFKl5yPFr1D9
         B7SRvcrdvY2dNLPOj+6zaWnbC68Jp7AoXyFvT9Qv+SB90I9jshGp+MneCKKlpmAwKOw5
         vrh9okELyJboqZNLJ1t1REfejeqzpO+w0XFFfyahdcz7G32t5nqmNQkdedyabXxezkaF
         HlLr+OPZecTXT4yZZSF80dfp2QzQbGu0lSKviqAEjmnTMOw+o/fsxZe/raIIPwalBIt6
         1PTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792946779; x=1793551579;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xG6MrCXFC7R3FF1J0tGLDByvgSJFyVyerh9PIkr8DcQ=;
        b=ulvIjprf8CwTwNbrn+Fwn+hfGbwppiaKEJSEJVx3nOy/avSrlDS/fLziSZuFZjAULi
         Cxy2aP8vJ+vwi0stTMIhVWr2lwCzvhq/KOQG0DqFucszTqP2bxGxeogW37sf79kqPAhS
         4i78TOFPRIw8gCZOiX/gu5zVrBuHlzmlGVR2OnDHomRnHi3ISyjT9UjJacaN2r6upqCw
         YPEpBiUvKtnRyqce97qf1V31pBzKw2mmOAFnZQGZmQtmuNY9GjnIsKayT70ckwGKkFg1
         /27uqLr8L0vTHPxtxHJdK5W8232tLeM8sLzfY50fikjmqRbPcLtOkOTZAcyIvqa8BFGP
         coKg==
X-Gm-Message-State: AFq9FYIPU3hKToOvX18bvS0r9EMf56sVfIgyunz54LQUScLC7YYPpa2z
	XyzKPiF+TxGX5D2nYk7ku+dfEu80c5OGmg46znhz1s8CaG45CIY5DyOa
X-Gm-Gg: AYBFou2snIRoUY3CZbieajxKjYHxDnOWfdhR+0IrggAOGWOkp4Eo7iU7GJjMt9rwghZ
	KnpfqSJAc8ANJq6c8s6Y6IXVHP/KvxXsxiAB3tVATz+Uj4SSm6MnUEXmDxvc5aUHGkcbzoimlg1
	Q96DdZxxGaJVdq8rksZ7LRE5z3DhfKIy0fXwsGQ9UaBsxOOtPRyvA1t+OnV2owcxpGQP5lqKyIJ
	YUWmfqu8O2GoQig77LHQwZApAFjy/DP3i82M4d7UNc4+djTezDe298pse0r3nm+EQ+6BFPJZZkg
	SGiLCuzhF+JxlFK7qSRv/yVry+lKQOeIwDFmbr8PexYrZCPT8zXyRiU8lqLMd9PwzeZIpUm+1EH
	3SxkE3BW8XBOVS0VZq4+MmIZG1xc0b18XCEbQOwBVQXbLYPSwN9tsl8xSycwnf0TvH873jsu4Ft
	v2xNyctmYxwzsbUP3GoyAOxeSfPyjoAlld0YGoP+HYSo0ZH8A/yBaZxQq40J8gjNW1CFLOikPgd
	DgK3yqMpJ4DqwYc9Qie2Mo2wxPp8qG7GmbZcExya4ablnvf/PVMGV7z4+PrpfzBzGAv6K0ryHvH
	ImdnBoZksztL+CMmKrQEzjm22RBF
X-Received: by 2002:a17:90b:1c0b:b0:3aa:6b5d:a018 with SMTP id 98e67ed59e1d1-3adeb104d43mr3872406a91.67.1792946778932;
        Sun, 25 Oct 2026 09:46:18 -0700 (PDT)
Received: from Terra.tail0ac356.ts.net ([198.176.50.208])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebe6946dsm5285671a91.4.2026.10.25.09.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 09:46:17 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pavel Shilovsky <pshilov@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	co+3a967895833044fc@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: handle unmatched encrypted read responses
Date: Sun, 25 Oct 2026 09:45:59 -0700
Message-ID: <20261025164559.439328-1-bestswngs@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

receive_encrypted_read() advertises one MID before decrypting a large
response, but it does not populate the corresponding bufs entry.  When the
response MessageId is not pending, smb2_find_mid() returns NULL.  The demux
thread then passes the empty buffer slot to is_oplock_break(), causing a
NULL pointer dereference.

Initialize the output count to zero.  For an unmatched response, account
the credit grant from the decrypted header and leave it unadvertised.
Publish one entry only after finding a MID.  This avoids sending a partial
linear response through generic unsolicited-message handling.

Cc: stable@vger.kernel.org
Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle compounded responses")
Reported-by: <co+3a967895833044fc@bugs.sh>
Assisted-by: LLM
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/smb/client/cifsproto.h | 2 ++
 fs/smb/client/connect.c   | 2 +-
 fs/smb/client/smb2ops.c   | 4 +++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 00168839c..fb181e727 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -88,6 +88,8 @@ void cifs_wake_up_task(struct TCP_Server_Info *server,
 		       struct mid_q_entry *mid);
 int cifs_handle_standard(struct TCP_Server_Info *server,
 			 struct mid_q_entry *mid);
+void smb2_add_credits_from_hdr(char *buffer,
+			       struct TCP_Server_Info *server);
 char *smb3_fs_context_fullpath(const struct smb3_fs_context *ctx, char dirsep);
 int smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx);
 int cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index b6e98eb31..d47f166e2 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1221,7 +1221,7 @@ cifs_handle_standard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	return 0;
 }
 
-static void
+void
 smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
 {
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buffer;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index cb4fd09f9..6f75e6620 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5236,7 +5236,7 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 	INIT_WORK(&dw->decrypt, smb2_decrypt_offload);
 	dw->server = server;
 
-	*num_mids = 1;
+	*num_mids = 0;
 	len = min_t(unsigned int, buflen, server->vals->read_rsp_size +
 		sizeof(struct smb2_transform_hdr)) - HEADER_SIZE(server) + 1;
 
@@ -5306,8 +5306,10 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 	*mid = smb2_find_mid(server, buf);
 	if (*mid == NULL) {
 		cifs_dbg(FYI, "mid not found\n");
+		smb2_add_credits_from_hdr(buf, server);
 	} else {
 		cifs_dbg(FYI, "mid found\n");
+		*num_mids = 1;
 		(*mid)->decrypted = true;
 		rc = handle_read_data(server, *mid, buf,
 				      server->vals->read_rsp_size,
-- 
2.56.0

