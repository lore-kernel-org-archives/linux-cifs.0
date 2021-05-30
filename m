Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD67C47092
	for <linux-cifs@archiver.kernel.org>; Sun, 30 May 2021 13:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68E196108D
	for <linux-cifs@archiver.kernel.org>; Sun, 30 May 2021 13:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhE3Nw7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 30 May 2021 09:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhE3Nw6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 30 May 2021 09:52:58 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B9FC061574
        for <linux-cifs@vger.kernel.org>; Sun, 30 May 2021 06:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=X+tvL+rOaY/tHgEDwksGrbRsvHd1Gz7PyibXoulrvSM=; b=uplo1LrJhXtmvQqnJbUUV92iKz
        Tq1gW7o5cnvPHmSnfhT81TL5jALtz/r0vodZ/SGIEsJ4jE/t7DPrsvDW/WfZLVz8jAyjHQtTx0duG
        vUkZd7ejBd1RNRI2ou9xNfrZzKpqGhyCZbDc2z5LVzEWDz7oxtS6OLz/KiBN9pxJFrd6IZK6Ihq5r
        zCmHwXdPhi6sRNzzcAQUnjc5jmOvmWtH67AZS+fGxbYgLx0cCIn79RWchcajsLhi3730hvOmfc+EV
        1y3oaNhwY2Gxpz00tgg2JQhTdkzpDrMP82iLZ2pGiqKGi3IbdvLKFMMjIgsgx5veMcB6EpBU8QtBU
        mmflR+lujC9Dt+SwwEQj1qt3dsc2VKyBq6lf4/mModDNyoUGmHTt8unCzjQ57KEH0zdt9/HrdPaiL
        ZcXqFRSRoYIU0O43pPiC2AeseH9Djj7J9vEixkERAkmBDdd4HPSz568RQWOF2qd8WfvAM8WPviFN+
        Ddf3dPND4pxZuaS+YpXJU4n/;
Received: from [2a01:4f8:192:486::6:0] (port=57216 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lnLqW-0004gp-W1
        for cifs-qa@samba.org; Sun, 30 May 2021 13:51:17 +0000
Received: from [::1] (port=35102 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1lnLqW-0099h3-2Z
        for cifs-qa@samba.org; Sun, 30 May 2021 13:51:16 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Sun, 30 May 2021 13:51:15 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: richard.flint@gmail.com
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14713-10630-YfXLMo3WiI@https.bugzilla.samba.org/>
In-Reply-To: <bug-14713-10630@https.bugzilla.samba.org/>
References: <bug-14713-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14713

--- Comment #36 from Richard Flint <richard.flint@gmail.com> ---
As requested I am emailing you details of the successful SMB2.1 negotiation
using both smbclient:

smbclient //nonsuch/myshare -m SMB2 --user=3Dmyuser

and the CIFS mount command (with vers=3D2.1 and without seal).

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
