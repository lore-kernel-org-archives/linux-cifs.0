Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CA3263F25
	for <linux-cifs@vger.kernel.org>; Fri, 14 Feb 2025 12:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739537018; cv=none; b=pFixMqmBNw2ZeCXeTBgHLoS8UwYCwqgIJW8xeYZtzFLjyBJSY3zGMafEcDbftXfNrtkQUoqSti+PXdo2Nn5m+oeK+ttu62nzL9hpjc4J0Pzjkrew6bCW9xHuwAFFKWkFhqWq2vNkkO300HppPL+l4Om9eqqiHsJx58UOAAR+Lkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739537018; c=relaxed/simple;
	bh=G3guDaBjJgsPJ3oBaGYFMvKewZ96n4/UDqyUnqjk+dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwJw1EUReaN5MkNrddR/S5uCOW1b9HRJpKWKR1UA+n4xULxD3cUoHveNDSVHx/GcK1cFb9yIU4O/A0rrDH++AUJohr2NqmKT15fg5WG2yP3XLFpmdEj0xwUorsCKL8AZF/RQTvNFEu/xSP2mZ2OInT3QAAmnqq1TB/t9FrNWVW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Co6CMPC9; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Co6CMPC9"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d19f5ce8a0so1382375ab.1
        for <linux-cifs@vger.kernel.org>; Fri, 14 Feb 2025 04:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739537016; x=1740141816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=54XIk6tW7SSLZXAC8fkcpYxaagxEO9/7LylwU0etiw0=;
        b=Co6CMPC9YD1WiD1RoP05W1bCXQ5LhBuFZWcNV4Y0/fKJp8G9067OlmeRi1dqhLY7W3
         3V4O7lcHQwFZ6GOWjeLjx5nvP7YMpMjsCmCsLp1eY01nE7C1SfuUyozGSj2szddkSJ4x
         J4EPVwvgE++i9DGWS/5lYJOtQHfaxRx5zbQHUH090eqs+u15TJ9CO/6fQEm1S9TmkG1H
         0v4gRPR0qOQl5tyj84PaUMc8W73fRT6a0VAHlg3GctGIpesouKiBNOmJqtqx3HCSB+BZ
         QUCLZqw8zYxofwwzpg1TRpAb0hJgkfHRJMwvvw44nsgkm7GEEPI8nWIUJpMz+lq1iJHM
         9DMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739537016; x=1740141816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=54XIk6tW7SSLZXAC8fkcpYxaagxEO9/7LylwU0etiw0=;
        b=guqw1+4LI/IuWpZEyTdr9dCw368jB9U7dlFiw75PgiIx13CA9KYPEt5FC/15ZpIEwE
         azaOzevGbh7ySyvOEvNnh6dqpC1XonglQ+QtR/G6ZRD1ecH93ly3NQjGm39Qf5w28O8W
         sE/gtHI+jJXG5NbOXR7wndlTtNVeKxua8MV0ZF3pJhuQEjWRbANZQ/AIEnukAp4KrwZs
         ksjJXNw24+6sh7Kok9ZB283LNKSOS6jv6fT5K0vDOjQ5BYYS1/OFyQPtNw8fcq/Q2GUN
         MhO6K0e7VU5TY9IWqBav3rMOqoyH7Lg03LuU7tKx7XiLqDlXyQgzIbVfozxWbnojpcsH
         PF6g==
X-Gm-Message-State: AOJu0YyT5uN1NeNrnfrJxsEh7gtkBSnpn4sBFLPXruzB93pFj6mADZMJ
	sTfYplgNC8lXMg2HdtuBVp4G4Fni3TPnbQhWKyO4CK7nW7h3YmR8PB7KKJxo
X-Gm-Gg: ASbGncsgP9GkWaITMbIfsGOKjh8T4wu8Yq6RsqhRHcL6C99pwvqnNhuV1yw042ZP20M
	I9wc0Gf+Yton/mOl0QFAhxxnz6GveC3dht4cjMc9a0Lz/6dATHbWvxLyUH7JMZSXJ2qbtFWFWYG
	UGqcarUgeZcgIO1e1dDomzdvtQYSIBldaoMNK2ZTx/x8ebWI4lI4KEbzRkehepSCBPBFoWfvtYX
	9ay1HkcW5608RjCxx7A2Xl1SIZd2238ax+y+/lNlT/DB2MZmKiYaFyfCKFkI8in27URrOhKARFL
	e7T+SpizBMHkRVhzA3vLF0w+NDEv2Uy6p3ybiU0wS5hp3YMpi9bIE4rQzYdgJybBG8R0puE0QlW
	BVQ==
X-Google-Smtp-Source: AGHT+IGQ0cBl54t0FsyormrAQjr+gCDUdEmNQewTOW7ReFRGgaZ6hS7Y3OXwQLyhDUcpAjk+3GmCPg==
X-Received: by 2002:a05:6e02:2161:b0:3d1:15c9:c15f with SMTP id e9e14a558f8ab-3d18cd2671bmr42967375ab.11.1739537016306;
        Fri, 14 Feb 2025 04:43:36 -0800 (PST)
Received: from linuxbox.oloxx3b4wsrernbskgt3tooxxe.gx.internal.cloudapp.net ([74.249.180.8])
        by smtp.googlemail.com with ESMTPSA id 8926c6da1cb9f-4ed281487c5sm795162173.13.2025.02.14.04.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 04:43:36 -0800 (PST)
From: aman1cifs@gmail.com
To: linux-cifs@vger.kernel.org,
	sfrench@samba.org,
	pc@manguebit.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	ronniesahlberg@gmail.com,
	bharathsm@microsoft.com
Cc: Aman <aman1@microsoft.com>
Subject: [PATCH 2/2] CIFS: adds min_offload and other params to cifs_debug
Date: Fri, 14 Feb 2025 12:43:06 +0000
Message-ID: <20250214124306.498808-2-aman1cifs@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250214124306.498808-1-aman1cifs@gmail.com>
References: <20250214124306.498808-1-aman1cifs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aman <aman1@microsoft.com>

This change adds more parameters for debugging into the status of all
channels. It adds the following TCP server parameters to cifs_debug.c

        - min_offload
        - compression.requested
        - dfs_conn
        - ignore_signature
        - leaf_fullpath
        - retrans
        - noblockcnt
        - noblocksnd
        - sign
        - max_credits

This is a logical follow up to a previous patch titled:
"[PATCH] CIFS: Propagate min offload along with other parameters from
primary to secondary channels",
however this has been tested and applies independently.

Signed-off-by: Aman <aman1@microsoft.com>
---
 fs/smb/client/cifs_debug.c | 47 +++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index e03c890de..64a565c46 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -147,8 +147,16 @@ cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
 		   "\n\t\tNumber of credits: %d,%d,%d Dialect 0x%x"
 		   "\n\t\tTCP status: %d Instance: %d"
 		   "\n\t\tLocal Users To Server: %d SecMode: 0x%x Req On Wire: %d"
-		   "\n\t\tIn Send: %d In MaxReq Wait: %d",
-		   i+1, server->conn_id,
+		   "\n\t\tIn Send: %d In MaxReq Wait: %d"
+		   "\n\t\tCompression Requested: %s"
+		   "\n\t\tdfs_conn: %s"
+		   "\n\t\tIgnore Signature: %s"
+		   "\n\t\tretrans: %d"
+		   "\n\t\tUse non-blocking connect: %s"
+		   "\n\t\tUse non-blocking sendmsg: %s"
+		   "\n\t\tSigning Enabled: %s"
+		   "\n\t\tMin Offload: %d Max Credits: %d",
+		   i, server->conn_id,
 		   server->credits,
 		   server->echo_credits,
 		   server->oplock_credits,
@@ -159,7 +167,22 @@ cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
 		   server->sec_mode,
 		   in_flight(server),
 		   atomic_read(&server->in_send),
-		   atomic_read(&server->num_waiters));
+		   atomic_read(&server->num_waiters),
+		   str_yes_no(server->compression.requested),
+		   str_yes_no(server->dfs_conn),
+		   str_yes_no(server->ignore_signature),
+		   server->retrans,
+		   str_yes_no(server->noblockcnt),
+		   str_yes_no(server->noblocksnd),
+		   str_yes_no(server->sign),
+		   server->min_offload,
+		   server->max_credits);
+
+	if (server->leaf_fullpath) {
+		seq_printf(m, "\n\t\tDFS leaf full path: %s",
+			   server->leaf_fullpath);
+	}
+
 #ifdef CONFIG_NET_NS
 	if (server->net)
 		seq_printf(m, " Net namespace: %u ", server->net->ns.inum);
@@ -487,6 +510,24 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		else
 			seq_puts(m, "disabled (not supported by this server)");
 
+		seq_printf(m, "\nCompression Requested: %s"
+		   "\ndfs_conn: %s"
+		   "\nIgnore Signature: %s"
+		   "\nretrans: %d"
+		   "\nUse non-blocking connect: %s"
+		   "\nUse non-blocking sendmsg: %s"
+		   "\nSigning Enabled: %s"
+		   "\nMin Offload: %d Max Credits: %d",
+		   str_yes_no(server->compression.requested),
+		   str_yes_no(server->dfs_conn),
+		   str_yes_no(server->ignore_signature),
+		   server->retrans,
+		   str_yes_no(server->noblockcnt),
+		   str_yes_no(server->noblocksnd),
+		   str_yes_no(server->sign),
+		   server->min_offload,
+		   server->max_credits);
+
 		seq_printf(m, "\n\n\tSessions: ");
 		i = 0;
 		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-- 
2.43.0

