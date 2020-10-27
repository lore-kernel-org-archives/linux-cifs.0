Return-Path: <SRS0=BDHi=EC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6A5C4363A
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Oct 2020 10:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CB9221D24
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Oct 2020 10:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897387AbgJ0KI3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Oct 2020 06:08:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:59494 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897380AbgJ0KI3 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 27 Oct 2020 06:08:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 102A2AEE6
        for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2020 10:08:28 +0000 (UTC)
From:   Samuel Cabrero <scabrero@suse.de>
To:     linux-cifs@vger.kernel.org
Subject: [PATCH v2 00/11] Witness protocol support for transparent failover
Date:   Tue, 27 Oct 2020 11:07:56 +0100
Message-Id: <20201027100807.21510-1-scabrero@suse.de>
X-Mailer: git-send-email 2.29.0
Reply-To: scabrero@suse.de
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Changes from v1:
  * Update SPDX header in user space API files to LGPL-2.1+ with
    Linux-syscall-note

[PATCH v2 01/11] cifs: Make extract_hostname function public
[PATCH v2 02/11] cifs: Make extract_sharename function public
[PATCH v2 03/11] cifs: Register generic netlink family
[PATCH v2 04/11] cifs: add witness mount option and data structs
[PATCH v2 05/11] cifs: Send witness register and unregister commands
[PATCH v2 06/11] cifs: Set witness notification handler for messages
[PATCH v2 07/11] cifs: Add witness information to debug data dump
[PATCH v2 08/11] cifs: Send witness register messages to userspace
[PATCH v2 09/11] cifs: Simplify reconnect code when dfs upcall is
[PATCH v2 10/11] cifs: Handle witness client move notification
[PATCH v2 11/11] cifs: Handle witness share moved notification

 fs/cifs/Kconfig                        |  11 +
 fs/cifs/Makefile                       |   2 +
 fs/cifs/cache.c                        |  24 -
 fs/cifs/cifs_debug.c                   |  13 +
 fs/cifs/cifs_swn.c                     | 723 ++++++++++++++++++++++++
 fs/cifs/cifs_swn.h                     |  25 +
 fs/cifs/cifsfs.c                       |  22 +-
 fs/cifs/cifsglob.h                     |   8 +
 fs/cifs/cifsproto.h                    |   2 +
 fs/cifs/connect.c                      | 141 +++--
 fs/cifs/fscache.c                      |   1 +
 fs/cifs/fscache.h                      |   1 -
 fs/cifs/misc.c                         |  56 ++
 fs/cifs/netlink.c                      |  88 +++
 fs/cifs/netlink.h                      |  16 +
 include/uapi/linux/cifs/cifs_netlink.h |  63 +++
 16 files changed, 1117 insertions(+), 79 deletions(-)

