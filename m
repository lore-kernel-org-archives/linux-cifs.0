Return-Path: <SRS0=I8uG=XP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69151C49ED7
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Sep 2019 05:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 390B02086A
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Sep 2019 05:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbfITFB1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Sep 2019 01:01:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:48798 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbfITFB1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 20 Sep 2019 01:01:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 15A66AF84;
        Fri, 20 Sep 2019 05:01:26 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v4 0/6] multichannel
Date:   Fri, 20 Sep 2019 07:01:13 +0200
Message-Id: <20190920050119.27017-1-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patchset adds multichannel support. It is a cleaned up version of
v3. I've removed debug messages and split the patch in multiple commits.

It still needs more reconnection testing and some tweaks (use 3.0
instead of 3.1.1 as minimum requirement).

Long Li sucessfully tried the patchset with RDMA (opening RDMA
channels).

Aurelien Aptel (6):
  cifs: add multichannel mount options and data structs
  cifs: add server param
  cifs: switch servers depending on binding state
  cifs: sort interface list by speed
  cifs: try opening channels after mounting
  cifs: mention if an interface has a channel connected to it

 fs/cifs/cifs_debug.c    |   6 +-
 fs/cifs/cifs_spnego.c   |   2 +-
 fs/cifs/cifsfs.c        |   3 +
 fs/cifs/cifsglob.h      |  29 ++++++-
 fs/cifs/cifsproto.h     |   8 ++
 fs/cifs/connect.c       |  83 +++++++++++++++----
 fs/cifs/sess.c          | 216 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2misc.c      |  37 ++++++---
 fs/cifs/smb2ops.c       |  13 ++-
 fs/cifs/smb2pdu.c       | 106 ++++++++++++++----------
 fs/cifs/smb2proto.h     |   3 +-
 fs/cifs/smb2transport.c | 150 ++++++++++++++++++++++++---------
 fs/cifs/transport.c     |  14 +++-
 13 files changed, 551 insertions(+), 119 deletions(-)

-- 
2.16.4

