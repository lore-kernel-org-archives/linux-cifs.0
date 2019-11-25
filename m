Return-Path: <SRS0=nVbX=ZR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC13C432C0
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 12:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D571E20674
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 12:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfKYMQl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Nov 2019 07:16:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:54462 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725868AbfKYMQl (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 25 Nov 2019 07:16:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4ED03BA3B;
        Mon, 25 Nov 2019 12:16:39 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v2] cifs: dump channel info in DebugData
Date:   Mon, 25 Nov 2019 13:16:36 +0100
Message-Id: <20191125121636.12385-1-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <CAH2r5ms90gOG9JdiC20YcOaTajnmhHLP6j3aAiVO+FD9c7TmmA@mail.gmail.com>
References: <CAH2r5ms90gOG9JdiC20YcOaTajnmhHLP6j3aAiVO+FD9c7TmmA@mail.gmail.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

* show server&TCP states for extra channels
* mention if an interface has a channel connected to it

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---

Changes since v1:
* make it work regardless of CONFIG_CIFS_STATS2
* use %zu for printing size_t

fs/cifs/cifs_debug.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index efb2928ff6c8..05376bfa5938 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -121,6 +121,33 @@ static void cifs_debug_tcon(struct seq_file *m, struct cifs_tcon *tcon)
 	seq_putc(m, '\n');
 }
 
+static void
+cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
+{
+	struct TCP_Server_Info *server = chan->server;
+
+	seq_printf(m, "\t\tChannel %d Number of credits: %d Dialect 0x%x "
+		   "TCP status: %d Instance: %d Local Users To Server: %d "
+		   "SecMode: 0x%x Req On Wire: %d"
+#ifdef CONFIG_CIFS_STATS2
+		   " In Send: %d In MaxReq Wait: %d"
+#endif
+		   "\n",
+		   i+1,
+		   server->credits,
+		   server->dialect,
+		   server->tcpStatus,
+		   server->reconnect_instance,
+		   server->srv_count,
+		   server->sec_mode,
+		   in_flight(server)
+#ifdef CONFIG_CIFS_STATS2
+		   ,atomic_read(&server->in_send),
+		   atomic_read(&server->num_waiters)
+#endif
+		);
+}
+
 static void
 cifs_dump_iface(struct seq_file *m, struct cifs_server_iface *iface)
 {
@@ -377,6 +404,13 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			if (ses->sign)
 				seq_puts(m, " signed");
 
+			if (ses->chan_count > 1) {
+				seq_printf(m, "\n\n\tExtra Channels: %zu\n",
+					   ses->chan_count-1);
+				for (j = 1; j < ses->chan_count; j++)
+					cifs_dump_channel(m, j, &ses->chans[j]);
+			}
+
 			seq_puts(m, "\n\tShares:");
 			j = 0;
 
@@ -415,8 +449,13 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				seq_printf(m, "\n\tServer interfaces: %zu\n",
 					   ses->iface_count);
 			for (j = 0; j < ses->iface_count; j++) {
+				struct cifs_server_iface *iface;
+
+				iface = &ses->iface_list[j];
 				seq_printf(m, "\t%d)", j);
-				cifs_dump_iface(m, &ses->iface_list[j]);
+				cifs_dump_iface(m, iface);
+				if (is_ses_using_iface(ses, iface))
+					seq_puts(m, "\t\t[CONNECTED]\n");
 			}
 			spin_unlock(&ses->iface_lock);
 		}
-- 
2.16.4

