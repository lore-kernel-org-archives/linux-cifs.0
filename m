Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64FCDC43334
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jul 2022 19:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236487AbiGGTPR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Jul 2022 15:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236603AbiGGTPQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Jul 2022 15:15:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1151C5723F
        for <linux-cifs@vger.kernel.org>; Thu,  7 Jul 2022 12:15:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B476F1F98A;
        Thu,  7 Jul 2022 19:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657221314; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=mnA3bCHmHtC+Nmfj1hUBI48/vTGcf9Vklj1tj2ce7lQ=;
        b=Ijd2uE5sfB0WC0u+lFUGVUFVU4BPVrlzL2IYlUfAUrJTACXpD+aksM4IelbGEp95sB8w6V
        B1BjnEPTrlqG/ArYj851r0OFY8ho2L1qkTw8Pw2/xQ6N4RW+/ruoe0mgK2kGzcsUKSgATv
        4eh82HlelZmVU2o7WIihcDwhd4CN0O4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657221314;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=mnA3bCHmHtC+Nmfj1hUBI48/vTGcf9Vklj1tj2ce7lQ=;
        b=Pgr3UWhabVAviqNuScUFZg76sPe9t9Xf/2A8+ZkKXorNAW3xK9T0yOmRAJYV71OVtQIsTo
        GHrV67KS5JVEXtAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 375DA13461;
        Thu,  7 Jul 2022 19:15:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IssEO8Ewx2LqIgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 07 Jul 2022 19:15:13 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     dhowells@redhat.com
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 0/3] keyutils: create a common DNS interface
Date:   Thu,  7 Jul 2022 16:15:04 -0300
Message-Id: <20220707191507.2013-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi David, list,

In the following patches, I moved all the common DNS functionality in
keyutils into key.dns.{h,c} with the aim to:

- Improve code readability
- ... by restructuring the DNS functions
- Use libresolv for any query, and not only AFSDB/SRV types. This allows
  A/AAAA queries to also have extra data fetched (such as TTL, for example)
- Add flexibility to add/remove/update any DNS query type

Patch 1/3: moves the common DNS parts into key.dns.{h.c}, rework on the
	   query part to have it as generic as possible, adapt callers
	   to the new structure.
Patch 2/3: refactor read_config() to make it more structured, hence more
	   flexible (idea is to have it ready for new config options).
Patch 3/3: adds a "ns=ADDR" callout option to allow callers to specify
	   custom nameservers for their queries. Custom as in, different
	   from the system's default (usually resolv.conf).

I've been using most of this code on my day-to-day to aid my
CIFS debugging activities and I thought it'd be good to have it
upstream.

Reviews, feedback, testing are all welcome.


Cheers,

Enzo Matsumiya (3):
  key.dns: create a common DNS interface
  key.dns_resolver: refactor read_config()
  key.dns: allow to use custom nameservers

 Makefile           |   6 +-
 dns.afsdb.c        | 358 +++++-------------
 key.dns.c          | 891 +++++++++++++++++++++++++++++++++++++++++++++
 key.dns.h          | 260 +++++++++++--
 key.dns_resolver.c | 683 +++++++++++++---------------------
 5 files changed, 1457 insertions(+), 741 deletions(-)
 create mode 100644 key.dns.c

-- 
2.35.3

