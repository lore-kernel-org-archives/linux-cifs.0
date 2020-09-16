Return-Path: <SRS0=zmi3=CZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490E1C43461
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Sep 2020 19:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A01D9205F4
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Sep 2020 19:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgIPTBi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Sep 2020 15:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbgIPRsy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Sep 2020 13:48:54 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EDDC06178B
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2020 10:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=77NnYH5ZvfIFIyHiyKvHOrWUv8EGAZcGimAFJnZWzB8=; b=hNPjPb2owcJgsLEBfDu9+Y8hlr
        UhcCxqMgtUSrntJm9IJC6sPAP13i5IjbF+rD4Q+tSFNTqDVgUiPaD1Pth5TbZV9llWoTzBjsgubF4
        GYLEZp9iLJlY0wrjNzUu+E3oWR3pxcgeqZQg6v3OPDKuZA9BePYdbQN4uJzEhK5tdoD60mloUb+np
        UDgwXwYUhuH3tZ+rjYp6vNmQk2fSA3Y6vlEb44erDJ7/6XA4oSnK14dapH69TXF/xMWO43XyuTxEl
        A70gKSdg2FofjVAduByLDNP0vykK18feTniyoAMvKlo1Kw9j4DL51Nj5JxzcLc1y1Pth32Zo6BvzR
        dAnN+5JC8EturkMWrX/xJ2C/FQAn0NXn1Sa0HA9hKYCClcw6pnk+pXF887j5wl/2/s78h6R/f9ZK5
        BlGaZ/TN0EFUXIvsNlggBHqmy5uJOkEhUtBV08dnnlfaHhIzBfnr3aQGY2egNYbK82L0ZlmJUCb+S
        We8TkwzyldWQF10mGiusAXzv;
Received: from [2a01:4f8:192:486::6:0] (port=61620 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kIbXi-0007W8-Mp
        for cifs-qa@samba.org; Wed, 16 Sep 2020 17:48:30 +0000
Received: from [::1] (port=26762 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kIbXi-002T1l-I0
        for cifs-qa@samba.org; Wed, 16 Sep 2020 17:48:30 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14498] Why is mount -a is not detecting an already mounted DFS
 share endpoint
Date:   Wed, 16 Sep 2020 17:48:30 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: Chris@craftypenguins.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14498-10630-yVEtJfx7Uv@https.bugzilla.samba.org/>
In-Reply-To: <bug-14498-10630@https.bugzilla.samba.org/>
References: <bug-14498-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14498

--- Comment #1 from Chris Pickett <Chris@craftypenguins.net> ---
The result is duplicate mount processes created for every mount -a attempte=
d.
We had a cron that was calling mount -a every 5 min so we were building up
quite a few entries in /proc/mounts.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
