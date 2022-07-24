Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D681C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Jul 2022 15:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiGXPLv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 11:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiGXPLu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 11:11:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DE710FC4
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 08:11:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D12B35C7CD;
        Sun, 24 Jul 2022 15:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658675507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=p1VjeFb7caf5Yhypb0jze89MEj+AHeLJVRlNziDj8io=;
        b=Y5ZzE18eWPjy3W1HCpn23jTbhtKVYgCXsSdCkzKey+I+FLPWzfbuiLo0NMpZYoUq//3C3/
        g71QB84XqqJJjEY+t8tmet94aH4KwhW/x1mzU4nIaQNj8wimDrEC3feW4aqs9QInjdppVr
        WSBOzWbuW3S23gZ7cGIVtK13Kn3YwAQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658675507;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=p1VjeFb7caf5Yhypb0jze89MEj+AHeLJVRlNziDj8io=;
        b=dpwJvYcVIRDD49qEfUYBs+a3N6dRG/Zmm1y4iOEEzuy07iEJRoDzm4ljjWWKM/3M5ApJwV
        NbIbAH4+UFQf/cDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4E20B13A8D;
        Sun, 24 Jul 2022 15:11:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0vLOBDNh3WLtMAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sun, 24 Jul 2022 15:11:47 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [RFC PATCH 00/14] cifs: rename of several structs and variables
Date:   Sun, 24 Jul 2022 12:11:23 -0300
Message-Id: <20220724151137.7538-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi all,

This patch set renames several cifs.ko data structures, variables, and
functions with the goal to improve readability of the code.

In summary, what's been done:
- change from CamelCase to snake_case
- try to give more meaning to globals and struct members
- typedef of status information for each cifs struct
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

Enzo Matsumiya (14):
  cifs: rename servers list, lock, functions, and vars
  cifs: rename xid/mid globals
  cifs: rename global counters
  cifs: rename "TCP_Server_Info" struct to "cifs_server_info"
  cifs: rename cifs{File,Lock,Inode}Info structs and more
  cifs: convert server info vars to snake_case
  cifs: typedef server status enum
  cifs: typedef ses status enum
  cifs: typedef tcon status enum
  cifs: typedef securityEnum
  cifs: rename cifsFYI to debug_level
  cifs: rename list_head fields
  cifs: rename more CamelCase to snake_case
  cifs: rename more list_heads, remove redundant prefixes

 fs/cifs/Kconfig         |   2 +-
 fs/cifs/asn1.c          |   4 +-
 fs/cifs/cifs_debug.c    | 176 +++----
 fs/cifs/cifs_debug.h    |  31 +-
 fs/cifs/cifs_spnego.c   |   4 +-
 fs/cifs/cifs_spnego.h   |   2 +-
 fs/cifs/cifs_swn.c      |  24 +-
 fs/cifs/cifs_swn.h      |   8 +-
 fs/cifs/cifs_unicode.c  |   4 +-
 fs/cifs/cifs_unicode.h  |   2 +-
 fs/cifs/cifsacl.c       |  22 +-
 fs/cifs/cifsencrypt.c   |  84 ++--
 fs/cifs/cifsfs.c        | 138 +++---
 fs/cifs/cifsglob.h      | 712 +++++++++++++++--------------
 fs/cifs/cifsproto.h     | 180 ++++----
 fs/cifs/cifssmb.c       | 391 ++++++++--------
 fs/cifs/connect.c       | 985 ++++++++++++++++++++--------------------
 fs/cifs/dfs_cache.c     | 182 ++++----
 fs/cifs/dfs_cache.h     |  40 +-
 fs/cifs/dir.c           |  16 +-
 fs/cifs/file.c          | 636 +++++++++++++-------------
 fs/cifs/fs_context.c    |   8 +-
 fs/cifs/fs_context.h    |   2 +-
 fs/cifs/fscache.c       |  18 +-
 fs/cifs/fscache.h       |  10 +-
 fs/cifs/inode.c         | 530 ++++++++++-----------
 fs/cifs/ioctl.c         |  22 +-
 fs/cifs/link.c          |  26 +-
 fs/cifs/misc.c          | 199 ++++----
 fs/cifs/netmisc.c       |   4 +-
 fs/cifs/ntlmssp.h       |   6 +-
 fs/cifs/readdir.c       | 344 +++++++-------
 fs/cifs/sess.c          | 148 +++---
 fs/cifs/smb1ops.c       | 182 ++++----
 fs/cifs/smb2file.c      |  36 +-
 fs/cifs/smb2inode.c     | 136 +++---
 fs/cifs/smb2maperror.c  |   2 +-
 fs/cifs/smb2misc.c      |  98 ++--
 fs/cifs/smb2ops.c       | 593 ++++++++++++------------
 fs/cifs/smb2pdu.c       | 626 ++++++++++++-------------
 fs/cifs/smb2proto.h     |  68 +--
 fs/cifs/smb2transport.c | 154 +++----
 fs/cifs/smbdirect.c     |  28 +-
 fs/cifs/smbdirect.h     |  16 +-
 fs/cifs/transport.c     | 292 ++++++------
 fs/cifs/xattr.c         |  12 +-
 46 files changed, 3609 insertions(+), 3594 deletions(-)

-- 
2.35.3

