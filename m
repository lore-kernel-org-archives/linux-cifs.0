Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D47EC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jan 2022 19:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiANTw1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jan 2022 14:52:27 -0500
Received: from mail.astralinux.ru ([217.74.38.119]:45326 "EHLO
        mail.astralinux.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiANTw1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Jan 2022 14:52:27 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id B0EA730637F6;
        Fri, 14 Jan 2022 22:52:25 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 5mjIfvMInK5a; Fri, 14 Jan 2022 22:52:25 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id E7A9130637F7;
        Fri, 14 Jan 2022 22:52:24 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TUHAunpIzWSi; Fri, 14 Jan 2022 22:52:24 +0300 (MSK)
Received: from himera.home (37-145-209-165.broadband.corbina.ru [37.145.209.165])
        by mail.astralinux.ru (Postfix) with ESMTPSA id 03F5330637F5;
        Fri, 14 Jan 2022 22:52:23 +0300 (MSK)
Date:   Fri, 14 Jan 2022 22:52:22 +0300
From:   Eugene Korenevsky <ekorenevsky@astralinux.ru>
To:     linux-cifs@vger.kernel.org
Cc:     Steve French <sfrench@samba.org>
Subject: fix for "CIFS: DFS namespaces with non-ASCII symbols cannot be
 mounted" #215440 bug
Message-ID: <YeHUds+PLW0eBfHG@himera.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The following patchset fixes the bug.

The test case (verified by me):

1. At Windows, create DFS namespace with name containing non-ASCII
symbols (for example дфс)

2. At Linux SMB client (kernel must be built with
CONFIG_CIFS_DFS_UPCALL) execute command

/sbin/mount.cifs //<smb_server>/дфс  /tmp/dfs -o domain=...,user=...,password=...

3. ls /tmp/dfs/<existing_dfs_ref>
-> (before the patchset applied) error "No such file or directory"
-> (after the patchset applied) result of successful ls

4. ls /tmp/dfs/<non_existing_dfs_ref>
-> (before the patchset applied) error "No such file or directory"
-> (after the patchset applied) error "No such file or directory"

--
Eugene
