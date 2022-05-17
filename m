Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC4B8C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 17 May 2022 21:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347405AbiEQU77 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 May 2022 16:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345869AbiEQU74 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 May 2022 16:59:56 -0400
X-Greylist: delayed 654 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 17 May 2022 13:59:53 PDT
Received: from c.mail.sonic.net (c.mail.sonic.net [64.142.111.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E62532D3
        for <linux-cifs@vger.kernel.org>; Tue, 17 May 2022 13:59:53 -0700 (PDT)
Received: from ocelot (157-131-248-104.fiber.dynamic.sonic.net [157.131.248.104])
        (authenticated bits=0)
        by c.mail.sonic.net (8.16.1/8.16.1) with ESMTPA id 24HKmwGo024219
        for <linux-cifs@vger.kernel.org>; Tue, 17 May 2022 13:48:58 -0700
From:   Forest <forestix@sonic.net>
To:     linux-cifs@vger.kernel.org
Subject: getxattr() on cifs sometimes hangs since kernel 5.14
Date:   Tue, 17 May 2022 13:48:58 -0700
Message-ID: <91188ht5vqi7kq3ml5d3a48sjo9ltqjko3@4ax.com>
X-Mailer: Forte Agent 3.3/32.846
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Sonic-CAuth: UmFuZG9tSVYIVm069RcB9oNRyMnL6OZ4Bp/ULBCpoSTIGePkOVnuJwB8DQNY5rUFjRG8OlsGhNLSzB1LdOzN1lUuqMY7qtpW
X-Sonic-ID: C;yLIdxiLW7BGLKoghXFXpmA== M;UB8kxiLW7BGLKoghXFXpmA==
X-Sonic-Spam-Details: -0.0/5.0 by cerberusd
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When running on recent kernel versions, this system call on a cifs-mounted
file sometimes takes an unusually long time:

getxattr("/cifsmount/dir/image.jpg", "user.baloo.rating", NULL, 0)

The call normally returns in under 10 milliseconds, but on kernel 5.14+, it
sometimes takes over 30 seconds with no significant client or server load.

Discovered while using gwenview to browse 100+ 1.5 MiB images on a samba share
mounted via /etc/fstab. While quickly flipping through the images, the problem
often occurs within 20 seconds. Gwenview freezes until the call completes.

Client:
  kernel versions 5.14 and later
  mount.cifs 6.11
  Gwenview 20.12.3
  Debian Bullseye
  4-core amd64
Server:
  Samba 4.13.13-Debian
  Debian Bullseye
  6-core arm64 

A git bisect identified kernel commit 9e992755be8f as the problematic change.
The problem does not occur when any of the following are true:
- Client is running a kernel from before that commit.
- The nouser_xattr mount option is used on the cifs share.
- Gwenview accesses the files via smb:// URL instead of a cifs mount.

I don't know Gwenview's internals, but using its strace output as a guide, I
have written a potential reproducer. It succeeds at triggering slow getxattr()
calls, though not nearly as slow as those triggered by Gwenview. I can post it
if that would be helpful.
