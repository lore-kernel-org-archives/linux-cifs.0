Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF18EB64DA
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jul 2023 08:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbjGNI4r (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jul 2023 04:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbjGNI4r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Jul 2023 04:56:47 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D32D198A
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jul 2023 01:56:46 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-6686ef86110so1085255b3a.2
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jul 2023 01:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689325005; x=1689929805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YvM1hWXocwOKRbWO7noznsaoRmtbEVDUR9rHc9KMkoc=;
        b=WXd5h1smw+kNcnCCw8CoeKepBavQMUqAnON/M/u4cPrnd68xp1lTezrdEr4RZwwUDG
         GyPL7kQlEyxwZsWg65mY6yuty1uuZjg9sWF/lcp63ziEBLmDKiaIn52CFeOSsA+XQfdk
         +6Agtn2ta/eupQorGDFrQT/+HGCRhXyO/ww/4/afHmLsL9B/zOnAThHNEOb+HV4cIlAw
         vh/jtqzSwyDP4GqLvMXt6P6AsCz/ZWaCmYgDA1NwVIQlv0AvzVckFknmkzZR5Ooyhtx0
         h+92hJmjZZxrb+fgGsV5z8g8m2mBDIl9eecFDSyqjpDyk7iFxDxVFLnTmD4M3369UrY2
         TWpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689325005; x=1689929805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YvM1hWXocwOKRbWO7noznsaoRmtbEVDUR9rHc9KMkoc=;
        b=gqSVZUubuN1TLygOHRjo0teHr4pBRXxkqa/Uo5XWmVCGdO9/Ymt/7SsBRhDDwqzDm3
         8CDlPu3aq5a0hTgz1eEJozmPoucijVhOIqBfY46hT2CLdbtw4OWpXsS6uvGJgUS6ig1D
         fiqA1vcWxl4TCV+1Sc4of3mX6NsVvjw3Tg2KokqbHWt1cPtW6ArYpK3OvtvVo0ANDKx6
         Z3GaSbda8+b+HwmsG+2MY/cjL/JNMAiZtE7EYdWRVaf9KIs5MN+7gKaOHTG9bsNRU3R8
         u3Muqd9Buq0H5NmNTs/UlHVxz1F8gPgH9kDEbzESyUdxB5isLWNtUKKsFO75UwF5/xjC
         AzkQ==
X-Gm-Message-State: ABy/qLYZ2eMkK1kb17tMqxRJgGBWsaElXquOjQ9KM8BcWMm8dULqFic2
        p+ONhRLbu5JngXZkfVt1kiil8voU9EZVEg==
X-Google-Smtp-Source: APBJJlFPHCCWLOkMnieQEvpNilH8A0NnevZjQ6A0NMVh2nXzwPinfHcZOO29/f31ilKWhQpDo9JCdg==
X-Received: by 2002:a05:6a00:2196:b0:682:759c:644d with SMTP id h22-20020a056a00219600b00682759c644dmr3654707pfi.27.1689325005275;
        Fri, 14 Jul 2023 01:56:45 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id c11-20020aa78c0b000000b006765cb32558sm6702838pfd.139.2023.07.14.01.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jul 2023 01:56:44 -0700 (PDT)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        bharathsm.hsk@gmail.com, pc@cjr.nz
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 1/2] cifs: fix mid leak during reconnection after timeout threshold
Date:   Fri, 14 Jul 2023 08:56:33 +0000
Message-Id: <20230714085634.10808-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When the number of responses with status of STATUS_IO_TIMEOUT
exceeds a specified threshold (NUM_STATUS_IO_TIMEOUT), we reconnect
the connection. But we do not return the mid, or the credits
returned for the mid, or reduce the number of in-flight requests.

This bug could result in the server->in_flight count to go bad,
and also cause a leak in the mids.

This change moves the check to a few lines below where the
response is decrypted, even of the response is read from the
transform header. This way, the code for returning the mids
can be reused.

Also, the cifs_reconnect was reconnecting just the transport
connection before. In case of multi-channel, this may not be
what we want to do after several timeouts. Changed that to
reconnect the session and the tree too.

Also renamed NUM_STATUS_IO_TIMEOUT to a more appropriate name
MAX_STATUS_IO_TIMEOUT.

Fixes: 8e670f77c4a5 ("Handle STATUS_IO_TIMEOUT gracefully")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/connect.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 9d16626e7a66..87047bd38485 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -60,7 +60,7 @@ extern bool disable_legacy_dialects;
 #define TLINK_IDLE_EXPIRE	(600 * HZ)
 
 /* Drop the connection to not overload the server */
-#define NUM_STATUS_IO_TIMEOUT   5
+#define MAX_STATUS_IO_TIMEOUT   5
 
 static int ip_connect(struct TCP_Server_Info *server);
 static int generic_ip_connect(struct TCP_Server_Info *server);
@@ -1118,6 +1118,7 @@ cifs_demultiplex_thread(void *p)
 	struct mid_q_entry *mids[MAX_COMPOUND];
 	char *bufs[MAX_COMPOUND];
 	unsigned int noreclaim_flag, num_io_timeout = 0;
+	bool pending_reconnect = false;
 
 	noreclaim_flag = memalloc_noreclaim_save();
 	cifs_dbg(FYI, "Demultiplex PID: %d\n", task_pid_nr(current));
@@ -1157,6 +1158,8 @@ cifs_demultiplex_thread(void *p)
 		cifs_dbg(FYI, "RFC1002 header 0x%x\n", pdu_length);
 		if (!is_smb_response(server, buf[0]))
 			continue;
+
+		pending_reconnect = false;
 next_pdu:
 		server->pdu_size = pdu_length;
 
@@ -1214,10 +1217,13 @@ cifs_demultiplex_thread(void *p)
 		if (server->ops->is_status_io_timeout &&
 		    server->ops->is_status_io_timeout(buf)) {
 			num_io_timeout++;
-			if (num_io_timeout > NUM_STATUS_IO_TIMEOUT) {
-				cifs_reconnect(server, false);
+			if (num_io_timeout > MAX_STATUS_IO_TIMEOUT) {
+				cifs_server_dbg(VFS,
+						"Number of request timeouts exceeded %d. Reconnecting",
+						MAX_STATUS_IO_TIMEOUT);
+
+				pending_reconnect = true;
 				num_io_timeout = 0;
-				continue;
 			}
 		}
 
@@ -1264,6 +1270,11 @@ cifs_demultiplex_thread(void *p)
 			buf = server->smallbuf;
 			goto next_pdu;
 		}
+
+		/* do this reconnect at the very end after processing all MIDs */
+		if (pending_reconnect)
+			cifs_reconnect(server, true);
+
 	} /* end while !EXITING */
 
 	/* buffer usually freed in free_mid - need to free it here on exit */
-- 
2.34.1

