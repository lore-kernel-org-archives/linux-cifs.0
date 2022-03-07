Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D99C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Mar 2022 01:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbiCGBe5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 6 Mar 2022 20:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233960AbiCGBe5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 6 Mar 2022 20:34:57 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CF013EAB
        for <linux-cifs@vger.kernel.org>; Sun,  6 Mar 2022 17:33:58 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6F356210FF;
        Mon,  7 Mar 2022 01:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646616837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=lgYb+ENhs24TdAT2IUenIcZL53vK2G11yeghmPvCUDU=;
        b=xowYVk9z3QnQISftu0flvhD4OrmubnhrJOR2ZR3J4hgF+Vc4DpQ6/Ir1vBxvC+49PYoy5Q
        zrAHFbdN7/35BbAVrorHXwdZVxu/K4E3g3XV2iUc+fwqgZIg9JYzmz1TZyOjhNAxtZuD2D
        5OeXljbu1eebqIGx3azY87Jc8z1NauA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646616837;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=lgYb+ENhs24TdAT2IUenIcZL53vK2G11yeghmPvCUDU=;
        b=7uRNhQATogKs3/Z2+iwCHMblUtU6XM0hlZUS6r2vyprs0o7R6oxL5gPRxdwjCv8RE8mJ5I
        GIxJ97HoigWIVhCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DED211340A;
        Mon,  7 Mar 2022 01:33:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GjxCKARhJWIFdAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 07 Mar 2022 01:33:56 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org, linkinjeon@kernel.org
Cc:     senozhatsky@chromium.org, sergey.senozhatsky@gmail.com,
        hyc.lee@gmail.com, smfrench@gmail.com,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 0/9] Unify all programs into a single binary "ksmbdctl"
Date:   Sun,  6 Mar 2022 22:33:35 -0300
Message-Id: <20220307013344.29064-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello,

This commit unifies all existing programs
(ksmbd.{adduser,addshare,control,mountd}) into a single ksmbdctl binary.

The intention is to make it more like other modern tools (e.g. git,
nvme, virsh, etc) which have more clear user interface, readable
commands, and also makes it easier to script.

Example commands:
  # ksmbdctl share add myshare -o "guest ok=yes, writable=yes, path=/mnt/data"
  # ksmbdctl user add myuser
  # ksmbdctl user add -i $HOME/mysmb.conf anotheruser
  # ksmbdctl daemon start

Besides adding a new "share list" command, any previously working
functionality shouldn't be affected.

Basic testing was done manually.

TODO:
- run more complex tests in more complex environments
- implement unit tests (for each command and subcommand)
- create an abstract command interface, to make it easier to add/modify
  commands

Enzo Matsumiya (9):
  ksmbd-tools: rename dirs to reflect new commands
  ksmbd-tools: move control functions to daemon
  ksmbd-tools: use quotes for local includes
  share: introduce share_cmd
  user: introduce user_cmd
  daemon: introduce daemon_cmd
  daemon/rpc_samr: drop unused function rpc_samr_remove_domain_entry()
  Unify all programs into a single binary "ksmbdctl"
  README: change to markdown, updates for ksmbdctl

 Makefile.am                        |  14 +-
 README                             | 100 -------
 README.md                          |  57 ++--
 addshare/addshare.c                | 172 -------------
 addshare/share_admin.h             |  15 --
 adduser/adduser.c                  | 180 -------------
 adduser/user_admin.h               |  15 --
 configure.ac                       |   7 +-
 control/Makefile.am                |   7 -
 control/control.c                  | 128 ---------
 {mountd => daemon}/Makefile.am     |   2 +-
 mountd/mountd.c => daemon/daemon.c | 401 +++++++++++++++++++++--------
 daemon/daemon.h                    |  55 ++++
 {mountd => daemon}/ipc.c           |  27 +-
 {mountd => daemon}/rpc.c           |  21 +-
 {mountd => daemon}/rpc_lsarpc.c    |  13 +-
 {mountd => daemon}/rpc_samr.c      |  22 +-
 {mountd => daemon}/rpc_srvsvc.c    |  11 +-
 {mountd => daemon}/rpc_wkssvc.c    |  10 +-
 {mountd => daemon}/smbacl.c        |   4 +-
 {mountd => daemon}/worker.c        |  32 +--
 include/config_parser.h            |   2 +-
 include/ksmbdtools.h               |  24 +-
 ksmbdctl.c                         | 182 +++++++++++++
 lib/config_parser.c                |  15 +-
 lib/ksmbdtools.c                   |  26 +-
 lib/management/spnego.c            |   6 +-
 lib/management/spnego_krb5.c       |   4 +-
 {addshare => share}/Makefile.am    |   2 +-
 share/share.c                      | 227 ++++++++++++++++
 {addshare => share}/share_admin.c  |  97 +++++--
 share/share_admin.h                |  44 ++++
 {adduser => user}/Makefile.am      |   2 +-
 {adduser => user}/md4_hash.c       |   2 +-
 {adduser => user}/md4_hash.h       |   0
 user/user.c                        | 238 +++++++++++++++++
 {adduser => user}/user_admin.c     | 263 ++++++++++---------
 user/user_admin.h                  |  44 ++++
 38 files changed, 1458 insertions(+), 1013 deletions(-)
 delete mode 100644 README
 delete mode 100644 addshare/addshare.c
 delete mode 100644 addshare/share_admin.h
 delete mode 100644 adduser/adduser.c
 delete mode 100644 adduser/user_admin.h
 delete mode 100644 control/Makefile.am
 delete mode 100644 control/control.c
 rename {mountd => daemon}/Makefile.am (95%)
 rename mountd/mountd.c => daemon/daemon.c (55%)
 create mode 100644 daemon/daemon.h
 rename {mountd => daemon}/ipc.c (95%)
 rename {mountd => daemon}/rpc.c (98%)
 rename {mountd => daemon}/rpc_lsarpc.c (98%)
 rename {mountd => daemon}/rpc_samr.c (98%)
 rename {mountd => daemon}/rpc_srvsvc.c (98%)
 rename {mountd => daemon}/rpc_wkssvc.c (97%)
 rename {mountd => daemon}/smbacl.c (99%)
 rename {mountd => daemon}/worker.c (95%)
 create mode 100644 ksmbdctl.c
 rename {addshare => share}/Makefile.am (74%)
 create mode 100644 share/share.c
 rename {addshare => share}/share_admin.c (68%)
 create mode 100644 share/share_admin.h
 rename {adduser => user}/Makefile.am (69%)
 rename {adduser => user}/md4_hash.c (99%)
 rename {adduser => user}/md4_hash.h (100%)
 create mode 100644 user/user.c
 rename {adduser => user}/user_admin.c (52%)
 create mode 100644 user/user_admin.h

-- 
2.34.1

