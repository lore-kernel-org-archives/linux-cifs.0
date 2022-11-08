Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAECFC433FE
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Nov 2022 18:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbiKHSOU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Nov 2022 13:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233978AbiKHSON (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Nov 2022 13:14:13 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FB915A01
        for <linux-cifs@vger.kernel.org>; Tue,  8 Nov 2022 10:14:12 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 77F171F38C;
        Tue,  8 Nov 2022 18:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667931251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=gDzW7Lj2G87D8hIPmJZwM+i8tJodGbhnssTVrZsaI8g=;
        b=w5n0o0Ol7dDE9DnLEUKyVw2aEWIS8sbbTMd/0r829q74yacx/7vKL8k0dP8kMhgYCLHWyO
        EeFvOjR5KCQQ3m9SUoDMIpkPHIK+NOMKT0jiJmd65nPT1JuAjsRrTmMKgN5mRkCBvcdenF
        mWdsTbGxnvliJNp7kHdP61jo4Sqrics=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667931251;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=gDzW7Lj2G87D8hIPmJZwM+i8tJodGbhnssTVrZsaI8g=;
        b=rMswpfDuBG00LiZLcvHWj2C1beRJINz/p8wkrBk0BlEkEuPlA5y/+wcx/8Q178LIY7Nw+B
        Fs3hj4d8WUH7HYCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F3728139F1;
        Tue,  8 Nov 2022 18:14:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Il6hLXKcamOYNAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 08 Nov 2022 18:14:10 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH] cifs: print "Unknown" instead of bogus link speed value
Date:   Tue,  8 Nov 2022 15:14:05 -0300
Message-Id: <20221108181405.21810-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The virtio driver for Linux guests will not set a link speed to its
paravirtualized NICs.  This will be shown as -1 in server settings, and
when the SMB server (samba) fetches it, it's converted to an unsigned
value (and multiplied by 1000 * 1000), so in client side we end up with:

1)      Speed: 4294967295000000 bps

in DebugData.

This patch check if the speed we got is such value, and print "Unknown"
instead.

The reason to not change the value in iface->speed is because we don't
know the real speed of the HW backing the server NIC, so let's keep
considering these as the fastest NICs available.

Also print "Capabilities: None" when the interface doesn't support any.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_debug.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 90850da390ae..6ec04869008d 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -151,12 +151,23 @@ cifs_dump_iface(struct seq_file *m, struct cifs_server_iface *iface)
 	struct sockaddr_in *ipv4 = (struct sockaddr_in *)&iface->sockaddr;
 	struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&iface->sockaddr;
 
-	seq_printf(m, "\tSpeed: %zu bps\n", iface->speed);
+	/*
+	 * Some servers will return an invalid (-1) link speed, e.g. virtio driver on Linux guests
+	 * When the server parses it, it's cast to an unsigned value, and the field ends with a
+	 * bogus value.
+	 * Let's not print such values to avoid confusion.
+	 */
+	if (iface->speed == ((u64)UINT_MAX * 1000 * 1000))
+		seq_printf(m, "\tSpeed: Unknown\n");
+	else
+		seq_printf(m, "\tSpeed: %zu bps\n", iface->speed);
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
2.35.3

