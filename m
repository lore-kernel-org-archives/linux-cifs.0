Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE26AC433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 01:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6DD361025
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 01:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhDIBrh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Apr 2021 21:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhDIBrg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Apr 2021 21:47:36 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AE4C061760
        for <linux-cifs@vger.kernel.org>; Thu,  8 Apr 2021 18:47:24 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lUgF1-003sTd-0r
        for linux-cifs@vger.kernel.org; Fri, 09 Apr 2021 01:47:23 +0000
Date:   Fri, 9 Apr 2021 01:47:23 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     CIFS <linux-cifs@vger.kernel.org>
Subject: [CFT] vfs.git #work.cifs
Message-ID: <YG+yK97KkSTkhwx7@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

	Could somebody throw the current variant of that branch
(HEAD at 224a69014604) into CIFS testsuite and/or point to
instructions for setting such up?

	Branch lives at
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.cifs

Al, really wishing he could reproduce the test setup locally ;-/
