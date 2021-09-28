Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3CCC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 22:56:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7B2860EFF
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 22:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243098AbhI1W6U (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Sep 2021 18:58:20 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:38306 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243149AbhI1W6U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Sep 2021 18:58:20 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AAB8E22450;
        Tue, 28 Sep 2021 22:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1632869798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=9R+KsHbbAYnX/32wv1dZmBtnC2nyh4sHQiosg2j6XFU=;
        b=AprJi52ioM/EN/+Jr1B8p87FZdql4SyMhPpV+hWDt8q2hbz9tH5uQUbajvlcpfk5Ty05p8
        K7divg0D3yQPfStDD5QA9/IQlxjKO1sq8P7RcieC2HFDUXfda/HYrTrivpxyv3r9V0i3Wk
        detTHH2bJH+3z93WfDxnJW9z4tEaWeI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1632869798;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=9R+KsHbbAYnX/32wv1dZmBtnC2nyh4sHQiosg2j6XFU=;
        b=hya3tVO07iT/0DAkeHX/TPO14lNXoP0kaVTbTYUc4xbFQWuTnksysyuostZ+2cPIhWDn3W
        Ji7RxvfoZ1+9ZPAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3707913EB3;
        Tue, 28 Sep 2021 22:56:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7ZX5AKadU2F0LAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 28 Sep 2021 22:56:38 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     pc@cjr.nz, Enzo Matsumiya <ematsumiya@suse.de>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ksmbd: fix documentation for 2 functions
Date:   Tue, 28 Sep 2021 19:56:34 -0300
Message-Id: <20210928225634.28432-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd_kthread_fn() and create_socket() returns 0 or error code, and not
task_struct/ERR_PTR.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/ksmbd/transport_tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index dc15a5ecd2e0..c14320e03b69 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -215,7 +215,7 @@ static int ksmbd_tcp_new_connection(struct socket *client_sk)
  * ksmbd_kthread_fn() - listen to new SMB connections and callback server
  * @p:		arguments to forker thread
  *
- * Return:	Returns a task_struct or ERR_PTR
+ * Return:	0 on success, error number otherwise
  */
 static int ksmbd_kthread_fn(void *p)
 {
@@ -387,7 +387,7 @@ static void tcp_destroy_socket(struct socket *ksmbd_socket)
 /**
  * create_socket - create socket for ksmbd/0
  *
- * Return:	Returns a task_struct or ERR_PTR
+ * Return:	0 on success, error number otherwise
  */
 static int create_socket(struct interface *iface)
 {
-- 
2.33.0

