Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6DEBC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Dec 2021 21:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhL2Vkf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Dec 2021 16:40:35 -0500
Received: from mail.astralinux.ru ([217.74.38.119]:43858 "EHLO
        mail.astralinux.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbhL2Vkf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Dec 2021 16:40:35 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 0615B2FA7FBB
        for <linux-cifs@vger.kernel.org>; Thu, 30 Dec 2021 00:40:34 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id USmlMObV-Zk2 for <linux-cifs@vger.kernel.org>;
        Thu, 30 Dec 2021 00:40:33 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 938BC2FA8001
        for <linux-cifs@vger.kernel.org>; Thu, 30 Dec 2021 00:40:33 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Pqz5-iGTeQJB for <linux-cifs@vger.kernel.org>;
        Thu, 30 Dec 2021 00:40:33 +0300 (MSK)
Received: from himera.home (37-145-209-165.broadband.corbina.ru [37.145.209.165])
        by mail.astralinux.ru (Postfix) with ESMTPSA id 584A82FA7FBB
        for <linux-cifs@vger.kernel.org>; Thu, 30 Dec 2021 00:40:33 +0300 (MSK)
Date:   Thu, 30 Dec 2021 00:40:31 +0300
From:   Eugene Korenevsky <ekorenevsky@astralinux.ru>
To:     linux-cifs@vger.kernel.org
Subject: bug: DFS namespaces with non-ASCII symbols cannot be mounted
Message-ID: <YczVz6tiutXEGmLk@himera.home>
References: <YczT8K47eA6JqEIB@himera.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YczT8K47eA6JqEIB@himera.home>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pay attention to the bug:
https://bugzilla.kernel.org/show_bug.cgi?id=215440

The patch in previous message is a solution.

But the problem is more
global: after tis patch, Windows SMB server returns undocumented response
STATUS_OBJECT_NAME_INVALID to SMB2 CREATE request for DFS referrals at
non-ASCII DFS namespace. And 'ls' for mounted  non-ASCII DFS namespace
fails.
