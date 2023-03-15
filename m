Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29629C6FD1D
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Mar 2023 13:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbjCONFw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Mar 2023 09:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbjCONFu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Mar 2023 09:05:50 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5909C570A5
        for <linux-cifs@vger.kernel.org>; Wed, 15 Mar 2023 06:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=Ys6A7bfxxNHXTGQkBX942BhDXQ4SWnlZeBGgpTGwwBw=; b=JW2WFhobzF2WtK1EWgdDsrn332
        BVUDSM9LhKli1Tv+8Ij2cvMUo0XJOa6GmJqLKmwDiGKyTmPAWRQ3tqIMMXFZjxgrlUps05dF8KGP6
        s6MWHoJ6/J3yont8DszW6m4YvUy0hzH8/3Xrl+g17IDpzS/2mNrSm4ZR7vZtHUBihZir55dm8lvqX
        GxpsLHOiU4ZgWMNaQLPixMExyOvoSgdUAa6xN5y4Cnc9xXHGQSJAgBKH1Jn8XXqqUpLoxNBeceGpc
        G4ErhnjuJhFF8CEVIgW+cflRn63hh/JACcx8ATBaGKMb9mhYmdNEfmZ/ilvzMqxU4qW/hXl21l5Z/
        BkZkOaRLonDMSD6v4lDt3FNXKG837VYBfASftM2XUt/Ub4gR9pKAzgvp55C5QtyYx8xiv0tdK7yOm
        FMMCgCH7RTqIak0k6hTHRbavZG1dY53H3J3gcxjCVBA0tRXJK2UDk8Nfjm3UYmRnElyQsg1MzY3Bk
        aFtr5VLqV4IygG4pyXgZ6+bT;
Received: from [2a01:4f8:252:410e::177:224] (port=40716 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pcQp6-003KNd-4t; Wed, 15 Mar 2023 13:05:44 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 00/10] Some cleanups for fs/cifs
Date:   Wed, 15 Mar 2023 13:05:21 +0000
Message-Id: <cover.1678885349.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

These are some cleanups and simplifications to fs/cifs which helped me
understand the code a bit better.

Volker Lendecke (10):
  cifs: Simplify some callers of compound_send_recv()
  cifs: Make "resp_buf_type" initialization consistent
  cifs: Slightly simplify cifs_readdir()
  cifs: Slightly simplify cifs_readdir()
  cifs: Simplify SMB2_OP_RMDIR with CREATE_DELETE_ON_CLOSE
  cifs: Slightly refactor smb2_compound_op()
  cifs: Reduce copy&paste in smb2_compound_op()
  cifs: Avoid two "else" branches
  cifs: Store smb3_create_tag_posix just once
  cifs: Use switch/case to dissect negprot reply ctxts

 fs/cifs/cached_dir.c |   1 -
 fs/cifs/cifssmb.c    |   6 +-
 fs/cifs/readdir.c    |   6 +-
 fs/cifs/smb2inode.c  | 163 +++++++++++++------------------------------
 fs/cifs/smb2ops.c    |   7 --
 fs/cifs/smb2pdu.c    |  92 ++++++++++--------------
 6 files changed, 91 insertions(+), 184 deletions(-)

-- 
2.30.2

