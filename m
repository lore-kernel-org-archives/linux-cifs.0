Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4052853FD
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 12:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778760223; cv=none; b=Sxf6OBG2aQwsdg4cnT0/DE9v5wYf7CLlWF8UJ3E4zXk1SWZhv2TJhHEVXoGcwQwcOhKl7WWmB042KfrLXmSyWa8M8lzEZZK8uJM+xO1VZXg4/doD8qZE3mIUnJ+O6hM01Ek9ABixnXnhYeRwi97b1r++FBmkrXzRk9K21yH00sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778760223; c=relaxed/simple;
	bh=MoFp3Iyqugdztla4DmBnclZXM4x6Ynsg6IyRSupxblM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B1d4gQ2Et1TG5B6KINLgz1Ewc4mvPceYQFmm1MWs4LZZYp8xg0br7d5jRW4Bvisv1Q3zQE16eK5akgS1pX2zioKnOj5tnGCW57kbnkHJFatEHa++KpciOHtpO+vdRTua15QLRtXsGluCD4nR69Sni7L4ixB6vmkJ0C/ncm3ieb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lru/54H5; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lru/54H5"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-48270ea6dd1so2619314b6e.3
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 05:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778760221; x=1779365021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1pwmBpJ+Ay/gUdKa6ifXgmSXC3e4hfZp9GQxRuj1q8c=;
        b=Lru/54H5sop8uFcPFZHsqamsNVNFTRfqskzOxCV6+ThWA+G12YxvCXJ/WXZs2x3oit
         4QoMo6w1/eyT3tlmI8kRALdR+3rlgNpmxKOVTQiGfWejEbpeAAHANtCQf1E2+NrIgB/H
         t7cenpl9Pj9TtCmEmgwZ7HkOYlOXb04RpzllWvaSxPvK1Kncakf7KEf2MrQ2OJcdA+9F
         QOAv/tG1CqBeL/BG3F1L7lILNUf/RnDEeZDzmzahSFCcD0IcCZMl6+RFO8zWzM6JPtqh
         tloQrWJKLEiBNZ1xRRjMf3+Yplj1SOSSESHxxJHUzIjkzRxj9J1CxB9QBzGFEtKnuYUL
         X8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778760221; x=1779365021;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1pwmBpJ+Ay/gUdKa6ifXgmSXC3e4hfZp9GQxRuj1q8c=;
        b=E0GExAY0IbQRJJ/9TnJawmuBD+ck/avDJDb8kMAIgDdK6BziXc/fPd08Jt82vvq8oc
         dC9+0sQtfUuUGm1vPWz8m1I04SuRYX2XBvVxptKOnWCzxciXlUfbIwoB6903YPGWEou9
         2XaynuAOzS3fbMSk+tHQ3Ny/ToC8avGus1Xn5KTNL5AZRFnw7F0mD5nVE7PKAmhJXudM
         R2WoVpn2PFl8rEDOKJ/jMYjuNS3tRMB7kZPs3WqMNx+Ula3d9nrDhnDQdMGFSMAJYn/T
         jo4faFM0iCOp5QsGFW5fbt/EchJ/J7xmFw6TP+x1u3wvxvqP3hWVTxbVVrW4q5osBFCt
         fp6w==
X-Gm-Message-State: AOJu0YyblcgvpVWZJ1EijPcRAtyjF5nbAgRNLCgi6R2wtxpO13/91uFj
	VIXuMhbDWDi1LYxOvIMQWdrgodnkB35FM12eiZ9+qYjTCRS9YAVKV8sN
X-Gm-Gg: Acq92OE73PDjSzCfWiUiz6dEC1KYnxqRZssM06Nm/FJp8V1qgpzsEfVA6DFwBg3ydHS
	ILzgBnqWAdwRai+l9MH5YH3+uMuCF/eG+R9OjdkeHlgCgK/2mMuFMP7q2Bga5QzatxF98vKe33l
	SD5FOu5WDbdefDrFwVxjuuaaBm8/0gKf+j9uYYXsWxQV8GrwsnhF0tSIJm4GHgsLwKKb5o6vyQz
	vIAstpnkzkGTcq85l/xRLzDGjhof7GIux1mqV+KFBcxDdIoxgWMZObmZ7c5LfYewxU3XpZLaTZx
	eAzN/2EbPPhyFjJyzpMcz+TUT6q5i0DNk/NrNoV/Ugz35JtYT464opVQbGYbg9y85BV3gg+F5Yy
	wlsc/TVw9hXt3xsv58SMOrmLJPmv5dgbbz4/PTiwbprTogCT6Qm1TadPaa71Pn/Jrrh+6CsHajm
	RWBLNWAQcP15be01auBhuWf4PcrCjCAB3//FnTsDkykzPQhIXDHLPl2cqvOn8dJMvL1tI3T3rph
	1TU2b0f/jnHfSk=
X-Received: by 2002:a05:6820:8c8:b0:694:8cd5:10c9 with SMTP id 006d021491bc7-69b78e3c178mr3598323eaf.51.1778760220782;
        Thu, 14 May 2026 05:03:40 -0700 (PDT)
Received: from jeremy.kali (srv1619992.hstgr.cloud. [2a02:4780:75:55a3::1])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c90b3d0bdbsm21074436d6.24.2026.05.14.05.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 05:03:40 -0700 (PDT)
From: Jeremy Erazo <mendozayt13@gmail.com>
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] smb: client: avoid integer overflow in SMB2 READ length check
Date: Thu, 14 May 2026 12:03:34 +0000
Message-ID: <20260514120334.2925013-1-mendozayt13@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SMB2 READ response validation in cifs_readv_receive() and
handle_read_data() checks data_offset + data_len against the received
buffer length.  Both values are attacker-controlled fields from the
server response and are stored as unsigned int, so the addition can
wrap before the bounds check:

	fs/smb/client/transport.c:1259
		if (!use_rdma_mr && (data_offset + data_len > buflen))

	fs/smb/client/smb2ops.c:4839
		else if (buf_len >= data_offset + data_len)

A malicious SMB server can use this to bypass validation.  In the
non-encrypted receive path the client attempts an oversized socket
read and stalls for the SMB response timeout (180 seconds) before
reconnecting.  In the SMB3 encrypted path, runtime testing shows the
malformed length can reach copy_to_iter() in handle_read_data() with
attacker-controlled size, where usercopy hardening stops the oversized
copy before bytes reach userspace.

Guard both call sites with check_add_overflow(), which is already
used elsewhere in this subsystem (smb2pdu.c).  On overflow, treat the
response as malformed and reject with -EIO.

Signed-off-by: Jeremy Erazo <mendozayt13@gmail.com>
---
 fs/smb/client/smb2ops.c   |  4 +++-
 fs/smb/client/transport.c | 15 +++++++++------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e6cb9b144..373820498 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4721,6 +4721,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 {
 	unsigned int data_offset;
 	unsigned int data_len;
+	unsigned int end_off;
 	unsigned int cur_off;
 	unsigned int cur_page_idx;
 	unsigned int pad_len;
@@ -4836,7 +4837,8 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		}
 		rdata->got_bytes = buffer_len;
 
-	} else if (buf_len >= data_offset + data_len) {
+	} else if (!check_add_overflow(data_offset, data_len, &end_off) &&
+		   buf_len >= end_off) {
 		/* read response payload is in buf */
 		WARN_ONCE(buffer, "read data can be either in buf or in buffer");
 		copied = copy_to_iter(buf + data_offset, data_len, &rdata->subreq.io_iter);
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 05f809904..fdf4e50c2 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1158,7 +1158,7 @@ int
 cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	int length, len;
-	unsigned int data_offset, data_len;
+	unsigned int data_offset, data_len, end_off;
 	struct cifs_io_subrequest *rdata = mid->callback_data;
 	char *buf = server->smallbuf;
 	unsigned int buflen = server->pdu_size;
@@ -1256,11 +1256,14 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	use_rdma_mr = rdata->mr;
 #endif
 	data_len = server->ops->read_data_length(buf, use_rdma_mr);
-	if (!use_rdma_mr && (data_offset + data_len > buflen)) {
-		/* data_len is corrupt -- discard frame */
-		rdata->result = smb_EIO2(smb_eio_trace_read_rsp_malformed,
-					 data_offset + data_len, buflen);
-		return cifs_readv_discard(server, mid);
+	if (!use_rdma_mr) {
+		if (check_add_overflow(data_offset, data_len, &end_off) ||
+		    end_off > buflen) {
+			/* data_len is corrupt -- discard frame */
+			rdata->result = smb_EIO2(smb_eio_trace_read_rsp_malformed,
+						 end_off, buflen);
+			return cifs_readv_discard(server, mid);
+		}
 	}
 
 #ifdef CONFIG_CIFS_SMB_DIRECT
-- 
2.53.0

