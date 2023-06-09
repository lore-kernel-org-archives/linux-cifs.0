Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D0AFC7EE2E
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Jun 2023 17:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjFIRrt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Jun 2023 13:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjFIRrt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Jun 2023 13:47:49 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E032E4E
        for <linux-cifs@vger.kernel.org>; Fri,  9 Jun 2023 10:47:48 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-38ede2e0e69so826324b6e.2
        for <linux-cifs@vger.kernel.org>; Fri, 09 Jun 2023 10:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686332866; x=1688924866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4W9hKuQo1vg7Chz4fdL0TbJ2gmtpajiRwOA8OZd9rzo=;
        b=BA3ItHcw0hotJ10eDnw4Pqwzr8JblgryNCfW9CJ6I9axxhb2z37XgKlRBQbZywhdL4
         KGNdfbvocwOEN+230u0hgBStIROYIV9k0+WOtqaCyQie7SJXmOcJj/Ru9kpIVpP1gipb
         262J4TDsmZLnVQAioyQjw4lMAyOm9XWZGU0IbZrpkP39XXK4LjMZ5jG0hHl7V5qt/1bO
         0it+IenT5scI79z47xtlezEd/+pc5HXrmyRNUYBxyHihq/mz+4DPKE0nYQIyLCXld3S2
         hAeZzt2fFu8eX1iLxKnNqDIH0X4F+9fOzLqhuFXpcw3vP0PF8EwwiVB28P7jWUZoiYbv
         PSmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686332866; x=1688924866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4W9hKuQo1vg7Chz4fdL0TbJ2gmtpajiRwOA8OZd9rzo=;
        b=ENRLsQZj/h/t25t2SncC7qqLhquVEK29/qOZYlq7TswULMzpQZmY6xIzJNzQPwzUXe
         T+yqHhahXBsKC4N3A1/EExC5u4kZKscrYAwwQDFUOqDi46QmTnTOgHwhxpp8GC9S9pha
         t6nWNUxzW8ufppLtY5DUfAj0EpiGV1bq5OzHLcnfypXhXMG5rITpxFT5eOvnTIK5V8CI
         hpTQ3TnadYoKsLGshmx2LN87iQZgEtFRmh5OurbEsh17pgJhUOZbVPGjENYGnWqikel2
         Kf8TRKuzgsmlv6Hl+f0cErT3O5UHe7W3itzfDqJUBcWCGLynWaLctvxYF883D0XJYdMJ
         58Ig==
X-Gm-Message-State: AC+VfDz1TQr4DIJX+F2VdxLr+bzY0Uf6ZMwh7gos2g4CgqbT3WkDlBGN
        Hxi3f7wqgsYcbbGqbp70wNy+vtAXt8o0frHN
X-Google-Smtp-Source: ACHHUZ7b57tnjLp2zaKm7YNoqC/+UVLXLjT6xveTPegML5aYkZPAkR1y90yld95svgJMRtIzFn8RoQ==
X-Received: by 2002:a05:6808:f15:b0:397:f94e:4321 with SMTP id m21-20020a0568080f1500b00397f94e4321mr2448144oiw.23.1686332865782;
        Fri, 09 Jun 2023 10:47:45 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id m4-20020a17090a71c400b0025671de4606sm5003064pjs.4.2023.06.09.10.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 10:47:45 -0700 (PDT)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com, tom@talpey.com
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 2/6] cifs: print all credit counters in DebugData
Date:   Fri,  9 Jun 2023 17:46:55 +0000
Message-Id: <20230609174659.60327-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609174659.60327-1-sprasad@microsoft.com>
References: <20230609174659.60327-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Output of /proc/fs/cifs/DebugData shows only the per-connection
counter for the number of credits of regular type. i.e. the
credits reserved for echo and oplocks are not displayed.

There have been situations recently where having this info
would have been useful. This change prints the credit counters
of all three types: regular, echo, oplocks.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifs_debug.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 5034b862cec2..17c884724590 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -130,12 +130,14 @@ cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
 	struct TCP_Server_Info *server = chan->server;
 
 	seq_printf(m, "\n\n\t\tChannel: %d ConnectionId: 0x%llx"
-		   "\n\t\tNumber of credits: %d Dialect 0x%x"
+		   "\n\t\tNumber of credits: %d,%d,%d Dialect 0x%x"
 		   "\n\t\tTCP status: %d Instance: %d"
 		   "\n\t\tLocal Users To Server: %d SecMode: 0x%x Req On Wire: %d"
 		   "\n\t\tIn Send: %d In MaxReq Wait: %d",
 		   i+1, server->conn_id,
 		   server->credits,
+		   server->echo_credits,
+		   server->oplock_credits,
 		   server->dialect,
 		   server->tcpStatus,
 		   server->reconnect_instance,
@@ -350,8 +352,11 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			atomic_read(&server->smbd_conn->mr_used_count));
 skip_rdma:
 #endif
-		seq_printf(m, "\nNumber of credits: %d Dialect 0x%x",
-			server->credits,  server->dialect);
+		seq_printf(m, "\nNumber of credits: %d,%d,%d Dialect 0x%x",
+			server->credits,
+			server->echo_credits,
+			server->oplock_credits,
+			server->dialect);
 		if (server->compress_algorithm == SMB3_COMPRESS_LZNT1)
 			seq_printf(m, " COMPRESS_LZNT1");
 		else if (server->compress_algorithm == SMB3_COMPRESS_LZ77)
-- 
2.34.1

