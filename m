Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5687CC433B4
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Apr 2021 00:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06685610EA
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Apr 2021 00:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbhDPA3U (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Apr 2021 20:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbhDPA3U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Apr 2021 20:29:20 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FE5C061574
        for <linux-cifs@vger.kernel.org>; Thu, 15 Apr 2021 17:28:56 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lXCLs-005dSH-EE; Fri, 16 Apr 2021 00:28:52 +0000
Date:   Fri, 16 Apr 2021 00:28:52 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [CFT] vfs.git #work.cifs
Message-ID: <YHjaRN7/F+81PHgJ@zeniv-ca.linux.org.uk>
References: <YG+yK97KkSTkhwx7@zeniv-ca.linux.org.uk>
 <CAH2r5mvEF6RyQ2dCB7y9m_knDxFWw6q2+kBBT_+seA3Tcox4EA@mail.gmail.com>
 <CAH2r5muY4wQjqw9MhP0-NchXMSNQ+JfwNiDtmNcJMC3i0vPGxg@mail.gmail.com>
 <YHilI9yjUb3CtCAo@zeniv-ca.linux.org.uk>
 <CAH2r5mtK20fZrpa4x2C-L7tGmhoq8qsji99_654c72Q2CChZsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mtK20fZrpa4x2C-L7tGmhoq8qsji99_654c72Q2CChZsA@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Apr 15, 2021 at 05:35:27PM -0500, Steve French wrote:
> Your series is currently in cifs-2.6.git for-next, and it is less
> risky if we keep it there, in my tree (assuming your series is up to
> date).

It is up to date, and I'm only happy to have that off my plate ;-)
Should've checked cifs tree before asking, sorry for noise.
