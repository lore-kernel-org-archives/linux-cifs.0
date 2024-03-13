Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D73383BD;
	Wed, 13 Mar 2024 10:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710326461; cv=none; b=Pr65I3rbWwyCCnqVXL/xlr5gYzxqZVxGZVZQUnwvChbcyqMDrHCjRZc/NLxC6rqWAn2NXURAl1+S7DI6ZpMoi4neo40oYhxlZU5xsr+l8MungYDFT43C6OHOT4av+d3ZI93KYxmx8Qf+LfXlEkCYUM8S0H0p/NzbG7yZ80mbLe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710326461; c=relaxed/simple;
	bh=iniw4FjfzHJdtwpcTqrZL65yCg8M9Kq+nWaVRTEzJ7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LGSPW6FtZPdPksZK8sI21aLClX0Lw2g4IUKrXtPZ6uVRkA2T8T56MZVwlDu/9Px//q3XXOvBy+b15sbFF1b9OfRwVvTX+KLH8b9HIGaL/iAL9K41e2im8Rid7SHwURR0gfuxyXcRrO6N6M39hRq+QyuQWcYoAyxE9eGSFhHNpp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V4KOQBJJ; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V4KOQBJJ"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1dd7df835a8so36844315ad.1;
        Wed, 13 Mar 2024 03:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710326458; x=1710931258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6MTmoXI1DvsvyziwsWc47N2vchUh9twoshfIbZ2A0NI=;
        b=V4KOQBJJPM9XSDSh0WHQR/Ev9Cm6dsXrgyOGNxIV9qwnyG7KNaMXn7MDdUwRxrQwMk
         JGiV3B5KI9vaXZXphjIC8FwAOxqlwhRxpHukupc1auC0S4kO0v+5E+O5gbSsOAOcNBZt
         DzUstrH1GQSIRFhvpC9Aii02Tdc05zawSoKRYsGlIfDQz6GvogmL8vJGpl/QngmakT8N
         N7mTHFKIxTVLCgS6QQInAbLWKwOg4ibRi+lSBB93HesOEnC86tadUemRMF7eZ2Mjajfg
         JBhH8yIDaeV9t0XdcPf1GBCNjUzT8y0SpSkI/PwPmuzWrUDpR7iDEZnQcokWiuKokQoA
         D/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710326458; x=1710931258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6MTmoXI1DvsvyziwsWc47N2vchUh9twoshfIbZ2A0NI=;
        b=wyoEXZomTlb6fk0hiNR/3lG66GhByGTcda1h2cgnLRaTLhe5J1u0msWjt+wxvC29cm
         gLi4Rdke5UoWzhx7b0+BKGp8FWOHaMnFQw/44FRR3iQijzMFLVZ+zZmxSBj+RTJmAzRa
         R1K66TXApRN50tbCWC0Z7r9fRVXLFofQVwX7z4GkY6HgLvM2V811aG4rSz1mFQ2U6K29
         KslSDWqBDiHZg3QpCDti1TLYEtQ83PW8SuiG3IJl74fdercHQDrZesL5uE5ZCp44bORv
         KbSV/6COL5hJDkkLqgFA1ZJH2H2cW79jlGz1DBteMst8KiLMWJ9lglXT5FL1bSmXjdDl
         lYng==
X-Forwarded-Encrypted: i=1; AJvYcCXrEHhWLcdMVSn1T8qYBAmil+xpIeJzJGtve6rC8ITLSm3Pe9cq7t2SuWzZYdJiteAnvDAh3uBet26pmgpQRj5jhXZePdbp
X-Gm-Message-State: AOJu0Yyg5rOmTEmw90VEhoRL/ZJuXxS/x5zSbWjlgho2BH5mo4dGKm2J
	BZhtw4OuT7AoF9KKofzl/8bpsox1PQc2YnihNZ0khruskzW5nmceqIZIw/3E+tA=
X-Google-Smtp-Source: AGHT+IHLGc6WF2afTyIgZU+HNVN527Kh1r1dFBHrijZ8ZZIu5s966ZxkKGm5flnZSAJGAa7AJpwM1g==
X-Received: by 2002:a17:902:f813:b0:1db:7c5e:f07c with SMTP id ix19-20020a170902f81300b001db7c5ef07cmr2573491plb.66.1710326458008;
        Wed, 13 Mar 2024 03:40:58 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id u6-20020a170902e80600b001dd88cf204dsm7175433plg.80.2024.03.13.03.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 03:40:57 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	Stable <stable@vger.kernel.org>,
	=?UTF-8?q?Jan=20=C4=8Cerm=C3=A1k?= <sairon@sairon.cz>
Subject: [PATCH 2/2] cifs: make sure server interfaces are requested only for SMB3+
Date: Wed, 13 Mar 2024 10:40:41 +0000
Message-Id: <20240313104041.188204-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240313104041.188204-1-sprasad@microsoft.com>
References: <20240313104041.188204-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Some code paths for querying server interfaces make a false
assumption that it will only get called for SMB3+. Since this
function now can get called from a generic code paths, the correct
thing to do is to have specific handler for this functionality
per SMB dialect, and call this handler.

This change adds such a handler and implements this handler only
for SMB 3.0 and 3.1.1.

Cc: Stable <stable@vger.kernel.org>
Cc: Jan Čermák <sairon@sairon.cz>
Reported-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h | 3 +++
 fs/smb/client/connect.c  | 6 +++++-
 fs/smb/client/smb2ops.c  | 2 ++
 fs/smb/client/smb2pdu.c  | 5 +++--
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 53c75cfb33ab..b29b57ab9807 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -346,6 +346,9 @@ struct smb_version_operations {
 	/* informational QFS call */
 	void (*qfs_tcon)(const unsigned int, struct cifs_tcon *,
 			 struct cifs_sb_info *);
+	/* query for server interfaces */
+	int (*query_server_interfaces)(const unsigned int, struct cifs_tcon *,
+				       bool);
 	/* check if a path is accessible or not */
 	int (*is_path_accessible)(const unsigned int, struct cifs_tcon *,
 				  struct cifs_sb_info *, const char *);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index ac9595504f4b..234160460615 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -123,12 +123,16 @@ static void smb2_query_server_interfaces(struct work_struct *work)
 	struct cifs_tcon *tcon = container_of(work,
 					struct cifs_tcon,
 					query_interfaces.work);
+	struct TCP_Server_Info *server = tcon->ses->server;
 
 	/*
 	 * query server network interfaces, in case they change
 	 */
+	if (!server->ops->query_server_interfaces)
+		return;
+
 	xid = get_xid();
-	rc = SMB3_request_interfaces(xid, tcon, false);
+	rc = server->ops->query_server_interfaces(xid, tcon, false);
 	free_xid(xid);
 
 	if (rc) {
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 4695433fcf39..3b8896987197 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5538,6 +5538,7 @@ struct smb_version_operations smb30_operations = {
 	.tree_connect = SMB2_tcon,
 	.tree_disconnect = SMB2_tdis,
 	.qfs_tcon = smb3_qfs_tcon,
+	.query_server_interfaces = SMB3_request_interfaces,
 	.is_path_accessible = smb2_is_path_accessible,
 	.can_echo = smb2_can_echo,
 	.echo = SMB2_echo,
@@ -5653,6 +5654,7 @@ struct smb_version_operations smb311_operations = {
 	.tree_connect = SMB2_tcon,
 	.tree_disconnect = SMB2_tdis,
 	.qfs_tcon = smb3_qfs_tcon,
+	.query_server_interfaces = SMB3_request_interfaces,
 	.is_path_accessible = smb2_is_path_accessible,
 	.can_echo = smb2_can_echo,
 	.echo = SMB2_echo,
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 608ee05491e2..4fa47c59cc04 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -409,14 +409,15 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	spin_unlock(&ses->ses_lock);
 
 	if (!rc &&
-	    (server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
+	    (server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL) &&
+	    server->ops->query_server_interfaces) {
 		mutex_unlock(&ses->session_mutex);
 
 		/*
 		 * query server network interfaces, in case they change
 		 */
 		xid = get_xid();
-		rc = SMB3_request_interfaces(xid, tcon, false);
+		rc = server->ops->query_server_interfaces(xid, tcon, false);
 		free_xid(xid);
 
 		if (rc == -EOPNOTSUPP && ses->chan_count > 1) {
-- 
2.34.1

