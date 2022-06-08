Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19D8C43334
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jun 2022 21:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiFHVzJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Jun 2022 17:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbiFHVzI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 Jun 2022 17:55:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A39938BEE
        for <linux-cifs@vger.kernel.org>; Wed,  8 Jun 2022 14:55:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5713621B3D;
        Wed,  8 Jun 2022 21:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654725304; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=kbtS88fKpaEGwg1zG1ZxtGNm+Z7MhWXfMpTVV3LKQig=;
        b=Tqav6b3PP4MDCoGZJdcskZ0phe8qLunomaAEPGZTrxuO8aBy9U5ig8T/P0j3gj3rJUikH+
        i51ceumxzV6qO0UDnQ7BNwlh08TDl9QcM8YZFpWmvR/IOBlQnOZGiKSQ9K4blsRKQOhjZk
        Sc7GAT/H0J/bax09hlR6ZJ/O3QiuI1M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654725304;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=kbtS88fKpaEGwg1zG1ZxtGNm+Z7MhWXfMpTVV3LKQig=;
        b=9f1rs3pwyUTRQkxeKeca7RJsNhvdWJkZK9arev/otD8gzxeZfK0l8CqSrUwDP6kEvi3Put
        VtBaU1Qa3euzYpCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C8EF613AD9;
        Wed,  8 Jun 2022 21:55:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7FowIrcaoWKbFwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 08 Jun 2022 21:55:03 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 0/2] Introduce dns_interval procfs setting
Date:   Wed,  8 Jun 2022 18:54:42 -0300
Message-Id: <20220608215444.1216-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

These 2 patches are a simple way to fix the DNS issue that
currently exists in cifs, where the upcall to key.dns_resolver will
always return 0 for the record TTL, hence, making the resolve worker
always use the default value SMB_DNS_RESOLVE_INTERVAL_DEFAULT
(currently 600 seconds).

This also makes the new setting `dns_interval' user-configurable via
procfs (/proc/fs/cifs/dns_interval).

One disadvantage here is that the interval is applied to all hosts
resolution. This is still how it works today, because we're always using
the default value anyway, but should someday this be fixed, then we can
go back to rely on the keys infrastructure to cache each hostname with
its own separate TTL.

Please review and test. All feedback is welcome.


Cheers

Enzo

Enzo Matsumiya (2):
  cifs: create procfs for dns_interval setting
  cifs: reschedule DNS resolve worker based on dns_interval

 fs/cifs/cifs_debug.c  | 63 +++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifs_debug.h  |  2 ++
 fs/cifs/cifsfs.c      |  1 +
 fs/cifs/connect.c     |  4 +--
 fs/cifs/dns_resolve.c |  8 ++++++
 5 files changed, 76 insertions(+), 2 deletions(-)

-- 
2.36.1

