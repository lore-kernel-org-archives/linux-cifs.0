Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0DA336884
	for <linux-cifs@vger.kernel.org>; Fri, 18 Sep 2026 00:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789691616; cv=none; b=p+bTd3Pcivc7xzdQj9CBQJVrOcLJ8Z3Afc8IhVclRK+kWOenHEtBVPfq0xXUd3EfGji5avOAEKpnxK56NEih+m1qxArUbYTvqEpverSKpnrfqCG14/RGJMBaUg8dDFzn3s2m+YorMYyfVnR7XhH1w9sIhRxVW4O1kZbF4tXULdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789691616; c=relaxed/simple;
	bh=OaRiEJu4atHniZ69WA7py5r58HEAXTPcIoVxpK3a2d0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xg5zdyGWbKlrgIao8oW0MqjgAKFlyOiEQkWSEQGz2PfkGuy2yi9it4FyevxJJ8/gLI7QtCzxIP3C9DX5nVKjr7Jl33cvDrEA/oMPxYp79OdOcULrK1EGvZ5YQNrHp2TPsY7YQovUbuLvNpBLqV2gBWupsi6j98+OMUJFfGDl508=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bTWic2IW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hVhbUc08; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bTWic2IW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hVhbUc08"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789691613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Mr7JPQ7cAKM9KbsSYSken92+dByUvyo6IiwGLWbzzyk=;
	b=bTWic2IWO5qusTPkak/Dwd5Lb0DFsrm7sYo5dFk5+t3t3OWVhurbPPqAVoS4YF6nrsAbQb
	tQzYcvZltub/fIrWgfZbHRzxra0fopFlok9dtE91lpqiB3WyjVt1RtBSE53ZH6yqnvoQUs
	2TZcJ8de+rt2zttFQgQNPGp1bWsfPAI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-Uuj_A4Y5N8S65ZOXlAY93g-1; Thu, 17 Sep 2026 20:33:32 -0400
X-MC-Unique: Uuj_A4Y5N8S65ZOXlAY93g-1
X-Mimecast-MFC-AGG-ID: Uuj_A4Y5N8S65ZOXlAY93g_1789691612
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-530d028f779so1976151cf.2
        for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 17:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789691612; x=1790296412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mr7JPQ7cAKM9KbsSYSken92+dByUvyo6IiwGLWbzzyk=;
        b=hVhbUc08m+7oQmgYm8Ecwh0zZX0mLJ+qAjlJcxwYXZ0IeYGwaHB0n0wg6ZUccJ0K4/
         nuILe+sWpbF5y0f08Ku+0UzSb0CztUzaGd4516xoJ2no8EZWuHjh/ikXYtj4idcIJna1
         JmJIdXTK81/Vgdg3KWWWznvvFWY4opMgBsJ/1EdCs2X667yjvUnlPdcK4QchRydOfJC/
         dhcRTv38eo0W87sT2XYSjqXRJcNyTeTag5ElQksAEwjy+yvBS2hF8d9gC6GgTBtFptW6
         vRF8PAiUSJ9zpL5VZvVxV0AirW2uWh4oEnP6xcTq+E4lfVtvUBmR682STNmBCh2Ksnog
         8lkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789691612; x=1790296412;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mr7JPQ7cAKM9KbsSYSken92+dByUvyo6IiwGLWbzzyk=;
        b=iwV53OEvbsYrLlKcADPEuSsK4Jd/6OyA4c/WLtPkA8c4rFC/Mny192bwZcz08peDEL
         nLhr6ZLlrHd/9XeS7rPG1hQoSbGXn81QbZ4lqediY/59hMMms1hVGoQiv4VbOK9vHi0H
         +v+tyjA8enyMZY14qg2oGx9sKEeN1b+awsWRYquWP/KlyE5q8AXW0eeRZ2WX4MM162BB
         dFd81JXdbYG5jO/Ihnc3ASllA1CnoE+8yWXx5WU31Z9jH2F8lC458ZMaXLcnR4G9vykL
         gL1EwMtVORC8U6t3AQOdomrOqWG/SoDyXG7McL5kKZff10e+6JIjL8fe1Hp14yIK2OtH
         OO7Q==
X-Gm-Message-State: AFuF++kzx4altsEE1vNpwHpaePC8Obcs/MUomc9OjnHUlUUhaaTLT0hU
	pvObn0QddzpaeYFgjNwcPG4pqXwLzICsPVIDCnmXMY9xmupsQyeMvrNrN2j0v2OPYM5AiV+XvRn
	GBVRBUPH0cRk0wSe4IDBSgrTVmgsupEOZGxSh0wluMTRWu87aVICHsw9rghK6hZv8I/eNRgtOgF
	+6//Ev9jfwedJUeqvNge4JZ0OT6Mpj72iDncN2r48ySOZDeyw=
X-Gm-Gg: AYBFou2JV9YHBr9nyVH/Tn00+DYT9ISgOmdj5KMcQ7B6VFHlNFpwiNw7iYHTvBmv7YN
	X0xvp7QNb6MzlSawkpcrfTn6wzeHrjmPdwIRiXEmzsZFoWLlJTVtbmY7bkhkRH2OL+2hO+8e9Mh
	Woiz+S3alQY1SzIQ1TE8bIMDWcaJVueKL3iqolzxaSKk2X2T47KTSUHQSg8c5sYxEl0xZjHSVpy
	7Jrx/MK3H8OTINgny577I17yjddWVlHoogwBSidtLzJlC35loqCH0/tUOWucFBoY0JwNWa8BB/+
	xbgbHp/wovDOOB08TRRHOKnMWHdZhHO7/ueiaiJ3MoctKAZ3j9x9006tQ5ehZjfray8wm4UyeJn
	Nq+NU5+DMZ1lnKzboiPYKIXdFObGI8XMPI8V9feoL/ltinegVxmRPiOTRMdOaXacbKA==
X-Received: by 2002:a05:622a:1648:b0:530:b2e1:8e42 with SMTP id d75a77b69052e-5329e512f81mr15558261cf.61.1789691611476;
        Thu, 17 Sep 2026 17:33:31 -0700 (PDT)
X-Received: by 2002:a05:622a:1648:b0:530:b2e1:8e42 with SMTP id d75a77b69052e-5329e512f81mr15557661cf.61.1789691610776;
        Thu, 17 Sep 2026 17:33:30 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532a19d261asm729761cf.18.2026.09.17.17.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 17:33:29 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: fix potential use-after-free with TCP_Server_Info->hostname
Date: Thu, 17 Sep 2026 19:33:19 -0500
Message-ID: <20260918003327.2539470-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The TCP_Server_Info->hostname pointer may be updated during a reconnect
event. Accessing ses->server->hostname outside of the srv_lock is
unsafe and can lead to a use-after-free if another thread reallocates
the hostname string.

Fix this by replacing instances of cifs_dbg() that print the hostname
with cifs_server_dbg() across multiple files (smb2ops.c, sess.c, and
smb2pdu.c).  cifs_server_dbg() correctly acquires the srv_lock before
printing and standardizes the output by prepending the server hostname
to the message.

Fixes: 4659f01e3cd9 ("smb3: do not log confusing message when server returns no network interfaces")
Fixes: a6d8fb54a515 ("cifs: distribute channels across interfaces based on speed")
Fixes: f591062bdbf4 ("cifs: handle servers that still advertise multichannel after disabling")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/sess.c    | 5 ++---
 fs/smb/client/smb2ops.c | 7 +++----
 fs/smb/client/smb2pdu.c | 5 ++---
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index e095f41b5882..5c2c9cabf7ef 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -192,8 +192,7 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 		spin_lock(&ses->iface_lock);
 		if (!ses->iface_count) {
 			spin_unlock(&ses->iface_lock);
-			cifs_dbg(ONCE, "server %s does not advertise interfaces\n",
-				      ses->server->hostname);
+			cifs_server_dbg(ONCE, "server does not advertise interfaces\n");
 			break;
 		}
 
@@ -395,7 +394,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	spin_lock(&ses->iface_lock);
 	if (!ses->iface_count) {
 		spin_unlock(&ses->iface_lock);
-		cifs_dbg(ONCE, "server %s does not advertise interfaces\n", ses->server->hostname);
+		cifs_server_dbg(ONCE, "server does not advertise interfaces\n");
 		return;
 	}
 
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 3464470d3297..08ea340f01b6 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -632,6 +632,7 @@ static int
 parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 			size_t buf_len, struct cifs_ses *ses, bool in_mount)
 {
+	struct TCP_Server_Info *server = ses->server;
 	struct network_interface_info_ioctl_rsp *p;
 	struct sockaddr_in *addr4;
 	struct sockaddr_in6 *addr6;
@@ -666,10 +667,8 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	if (bytes_left == 0) {
 		/* avoid spamming logs every 10 minutes, so log only in mount */
 		if ((ses->chan_max > 1) && in_mount)
-			cifs_dbg(VFS,
-				 "multichannel not available\n"
-				 "Empty network interface list returned by server %s\n",
-				 ses->server->hostname);
+			cifs_server_dbg(VFS,
+					"multichannel not available - Empty network interface list returned by server\n");
 		rc = -EOPNOTSUPP;
 		goto out;
 	}
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index dea05aeb53a1..bb30cfa156aa 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -173,9 +173,8 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
 	unsigned int chan_index;
 
 	if (SERVER_IS_CHAN(server)) {
-		cifs_dbg(VFS,
-			"server %s does not support multichannel anymore. Skip secondary channel\n",
-			 ses->server->hostname);
+		cifs_server_dbg(VFS,
+				"server does not support multichannel anymore. Skip secondary channel\n");
 
 		spin_lock(&ses->chan_lock);
 		chan_index = cifs_ses_get_chan_index(ses, server);
-- 
2.55.0

