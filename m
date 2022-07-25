Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA05C43334
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 22:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbiGYWib (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Jul 2022 18:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237405AbiGYWiJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Jul 2022 18:38:09 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510E826549
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jul 2022 15:37:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CC1973371E;
        Mon, 25 Jul 2022 22:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658788633; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=sfw6+EZfHhYO8xPSnXRNtFNQi4BqQcLqh5gJAR+esss=;
        b=JlQcTZBOo/KWQwFPmY3cW2xu/DaKovVKULFrNYmAUpH9vSgmC/mIGZKY7zph3SQoKQ8lnU
        hzd42kXrrX6O8yhBFt6UiB9J5tWFNftlvEkgD8lcubHHfpjXTGSEZupNb366h7oucMAp0d
        4noEI/KiTc2wueMNYtWShX9QTxP0raw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658788633;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=sfw6+EZfHhYO8xPSnXRNtFNQi4BqQcLqh5gJAR+esss=;
        b=W9gsI2JJjZ8hBm1Rin2ER2oVBzW6iAX9QOoXEh0UfnJnanG6tEHblRl4OUZ629DSbaGC7h
        9B6MddDjgKuds1CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 47C7313ABB;
        Mon, 25 Jul 2022 22:37:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kxWDAhkb32LoRgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 25 Jul 2022 22:37:13 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [RFC PATCH v2 00/10] cifs: rename of several structs and variables
Date:   Mon, 25 Jul 2022 19:36:57 -0300
Message-Id: <20220725223707.14477-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi all,

This patch set (v2) renames several cifs.ko data structures, variables, and
functions with the goal to improve readability of the code.

In summary, what's been done:
- change from CamelCase to snake_case
- try to give more meaning to globals and struct members
- rename status fields (server, ses, tcon), define constants for the
  various statuses (4/11 can be shared between those structs, others are
  specific to each)
- rename of list_head variables to better represent whether they'are
  used as a list element ("head") or a list per se. Also tried to give
  more meaning to these, as "rlist", "tlist", "llist" looked confusing
  and, sometimes, ambiguous.
- remove redundant prefixes from struct members name, e.g.
  tcon_tlink's tl_*, smb_rqst's rq_*, cifs_fattr's cf_*, etc

No functional changes has been made.

I know these touch some very old code that older devs are highly used
to, but I see this as an improvement to reading the code for everyone.

I'll be waiting for your reviews and feedback.


Cheers,

Enzo

v2:
  - remove status typedefs (suggested by Christoph Hellwig)
  - define status constants instead, reuse some between different
    structs so we don't have to create a different set of statuses
    for each cifs struct

Enzo Matsumiya (10):
  cifs: rename xid/mid globals
  cifs: rename global counters
  cifs: rename "TCP_Server_Info" struct to "cifs_server_info"
  cifs: rename cifs{File,Lock,Inode}Info structs and more
  cifs: convert server info vars to snake_case
  cifs: change status and security types enums to constants
  cifs: rename cifsFYI to debug_level
  cifs: rename list_head fields
  cifs: rename more CamelCase to snake_case
  cifs: rename more list_heads, remove redundant prefixes

 fs/cifs/Kconfig         |   2 +-
 fs/cifs/asn1.c          |   4 +-
 fs/cifs/cifs_debug.c    | 158 ++++-----
 fs/cifs/cifs_debug.h    |  29 +-
 fs/cifs/cifs_spnego.c   |   4 +-
 fs/cifs/cifs_spnego.h   |   2 +-
 fs/cifs/cifs_swn.c      |  24 +-
 fs/cifs/cifs_swn.h      |   8 +-
 fs/cifs/cifs_unicode.c  |   4 +-
 fs/cifs/cifs_unicode.h  |   2 +-
 fs/cifs/cifsacl.c       |  22 +-
 fs/cifs/cifsencrypt.c   |  78 ++---
 fs/cifs/cifsfs.c        | 124 +++----
 fs/cifs/cifsglob.h      | 694 ++++++++++++++++++++--------------------
 fs/cifs/cifsproto.h     | 172 +++++-----
 fs/cifs/cifssmb.c       | 356 ++++++++++-----------
 fs/cifs/connect.c       | 574 ++++++++++++++++-----------------
 fs/cifs/dfs_cache.c     | 178 +++++------
 fs/cifs/dfs_cache.h     |  40 +--
 fs/cifs/dir.c           |  16 +-
 fs/cifs/file.c          | 636 ++++++++++++++++++------------------
 fs/cifs/fs_context.c    |   8 +-
 fs/cifs/fs_context.h    |   2 +-
 fs/cifs/fscache.c       |  18 +-
 fs/cifs/fscache.h       |  10 +-
 fs/cifs/inode.c         | 530 +++++++++++++++---------------
 fs/cifs/ioctl.c         |  18 +-
 fs/cifs/link.c          |  26 +-
 fs/cifs/misc.c          | 185 ++++++-----
 fs/cifs/netmisc.c       |   4 +-
 fs/cifs/ntlmssp.h       |   6 +-
 fs/cifs/readdir.c       | 344 ++++++++++----------
 fs/cifs/sess.c          | 142 ++++----
 fs/cifs/smb1ops.c       | 182 +++++------
 fs/cifs/smb2file.c      |  36 +--
 fs/cifs/smb2inode.c     | 136 ++++----
 fs/cifs/smb2maperror.c  |   2 +-
 fs/cifs/smb2misc.c      |  72 ++---
 fs/cifs/smb2ops.c       | 555 ++++++++++++++++----------------
 fs/cifs/smb2pdu.c       | 596 +++++++++++++++++-----------------
 fs/cifs/smb2proto.h     |  68 ++--
 fs/cifs/smb2transport.c | 112 +++----
 fs/cifs/smbdirect.c     |  28 +-
 fs/cifs/smbdirect.h     |  16 +-
 fs/cifs/transport.c     | 236 +++++++-------
 fs/cifs/xattr.c         |  12 +-
 46 files changed, 3230 insertions(+), 3241 deletions(-)

-- 
2.35.3

