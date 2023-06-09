Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC16C7EE25
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Jun 2023 21:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbjFIVaV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Jun 2023 17:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjFIVaV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Jun 2023 17:30:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B771AE
        for <linux-cifs@vger.kernel.org>; Fri,  9 Jun 2023 14:30:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9E1201F74A;
        Fri,  9 Jun 2023 21:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686346209; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=R/Gs3NEHd2mjsCwTkjcgLtoPXluS3eJ/zbZmhjWdftg=;
        b=iLP8DBpAc8AwID32j4P5vF3f12x1EicQ+hH/jIjVfgGqfeovknJy2DXynYdyl3CUAFMEr9
        UtEoeQ7rVAfxk/fVkMrMVzrWuwZY2g6fXViJq93xwFR/DJxe8Wx5RmugPm/B34k3junvtM
        /TuRo6jSClecYe2S1NbSp4N1gBzvhNo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686346209;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=R/Gs3NEHd2mjsCwTkjcgLtoPXluS3eJ/zbZmhjWdftg=;
        b=s8TQYT0GLTOWlMF2UhDMGuR4ZtG/9pFc0qXg76QDiEI3FdNRyuu1fBM9/coJaBR4/vy/SQ
        IvTjWXxfctY31cDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 168FA13A47;
        Fri,  9 Jun 2023 21:30:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XRMIM+CZg2TaXQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 09 Jun 2023 21:30:08 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH v2] smb/client: print "Unknown" instead of bogus link speed value
Date:   Fri,  9 Jun 2023 18:29:59 -0300
Message-Id: <20230609212959.32061-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The virtio driver for Linux guests will not set a link speed to its
paravirtualized NICs.  This will be seen as -1 in the ethernet layer, and
when some servers (e.g. samba) fetches it, it's converted to an unsigned
value (and multiplied by 1000 * 1000), so in client side we end up with:

1)      Speed: 4294967295000000 bps

in DebugData.

This patch introduces a helper that returns a speed string (in Mbps or
Gbps) if interface speed is valid (>= SPEED_10 and <= SPEED_800000), or
"Unknown" otherwise.

The reason to not change the value in iface->speed is because we don't
know the real speed of the HW backing the server NIC, so let's keep
considering these as the fastest NICs available.

Also print "Capabilities: None" when the interface doesn't support any.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
v2: remove dependency on CONFIG_PHYLIB by creating our own helper

 fs/smb/client/cifs_debug.c | 47 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 5034b862cec2..c5d9579e1861 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/uaccess.h>
+#include <uapi/linux/ethtool.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -146,18 +147,62 @@ cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
 		   atomic_read(&server->num_waiters));
 }
 
+static inline const char *smb_speed_to_str(size_t bps)
+{
+	size_t mbps = bps / 1000 / 1000;
+
+	switch (mbps) {
+	case SPEED_10:
+		return "10Mbps";
+	case SPEED_100:
+		return "100Mbps";
+	case SPEED_1000:
+		return "1Gbps";
+	case SPEED_2500:
+		return "2.5Gbps";
+	case SPEED_5000:
+		return "5Gbps";
+	case SPEED_10000:
+		return "10Gbps";
+	case SPEED_14000:
+		return "14Gbps";
+	case SPEED_20000:
+		return "20Gbps";
+	case SPEED_25000:
+		return "25Gbps";
+	case SPEED_40000:
+		return "40Gbps";
+	case SPEED_50000:
+		return "50Gbps";
+	case SPEED_56000:
+		return "56Gbps";
+	case SPEED_100000:
+		return "100Gbps";
+	case SPEED_200000:
+		return "200Gbps";
+	case SPEED_400000:
+		return "400Gbps";
+	case SPEED_800000:
+		return "800Gbps";
+	default:
+		return "Unknown";
+	}
+}
+
 static void
 cifs_dump_iface(struct seq_file *m, struct cifs_server_iface *iface)
 {
 	struct sockaddr_in *ipv4 = (struct sockaddr_in *)&iface->sockaddr;
 	struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&iface->sockaddr;
 
-	seq_printf(m, "\tSpeed: %zu bps\n", iface->speed);
+	seq_printf(m, "\tSpeed: %s\n", smb_speed_to_str(iface->speed));
 	seq_puts(m, "\t\tCapabilities: ");
 	if (iface->rdma_capable)
 		seq_puts(m, "rdma ");
 	if (iface->rss_capable)
 		seq_puts(m, "rss ");
+	if (!iface->rdma_capable && !iface->rss_capable)
+		seq_puts(m, "None");
 	seq_putc(m, '\n');
 	if (iface->sockaddr.ss_family == AF_INET)
 		seq_printf(m, "\t\tIPv4: %pI4\n", &ipv4->sin_addr);
-- 
2.40.1

