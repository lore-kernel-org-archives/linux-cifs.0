Return-Path: <SRS0=jY8V=BX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17196C433E1
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 15:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA9F120791
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 15:07:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ZZ4W6mCh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgHMPH4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Aug 2020 11:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgHMPH4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Aug 2020 11:07:56 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3809C061757
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2020 08:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=hmQUgMY5+GEa+dQWeKnMUAGkzkWpDnkwcYhOly+tnA8=; b=ZZ4W6mChoVvw8htdpeIMa7EquC
        XOU16SdGUqCCka5y+MtzeOdg6YVqC4lYJSwxUMAlwjF0gLhSgjx4v4AoPaJf8nJ4+5wxkxMss07TN
        CfmIUoAQOuAsdRnVsG8ZiKY7j5RagBqXJ24HgkUOqGVJZ83wuO7si6eHxV6CSJ3K0vQXmbNn2aZiV
        nq2m+qZ/nYKxfDxd5kxEaMBEwrqG9VbBJ+4foybCJ8rwNKoe4cw5H/MJCzovB0awgkyT3+DlCbD4v
        JQj50jVOQmyfaaU3YwpX7kk74WuRNUkDg6RYOoVZ05isfYWSvHGmR/GpWBMyfKHF9UF5th910CIHr
        +ZWIhAHprsFtzgFeOkOT131+/ZdFU1/P1hZvhjIt9hlb9mgxRSDZFR0xrVjEQvT4dK7gWqmeZcH2g
        pdSKFAF0Be+zZN8BqoEzPHbjElJ8s7St0wHyU0/GFXBP2JRHR3e/jK4UVZVxyv5BWi+J3xEjJLqiR
        CUV1J6/mNbYuB1eh36bBRzf6;
Received: from [2a01:4f8:192:486::6:0] (port=53768 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k6Epd-0001ww-No
        for cifs-qa@samba.org; Thu, 13 Aug 2020 15:07:53 +0000
Received: from [::1] (port=39724 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k6Epd-0092yV-5T
        for cifs-qa@samba.org; Thu, 13 Aug 2020 15:07:53 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 8044] Missing directory entries on CIFS-mounted Windows 7 share
 on Debian Squeeze (and previously on Lenny)
Date:   Thu, 13 Aug 2020 15:07:51 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.6
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DUPLICATE
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: resolution bug_status
Message-ID: <bug-8044-10630-DbCCWCwJgt@https.bugzilla.samba.org/>
In-Reply-To: <bug-8044-10630@https.bugzilla.samba.org/>
References: <bug-8044-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D8044

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Resolution|---                         |DUPLICATE
             Status|NEW                         |RESOLVED

--- Comment #5 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---


*** This bug has been marked as a duplicate of bug 13107 ***

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
