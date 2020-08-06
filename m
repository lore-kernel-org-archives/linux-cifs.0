Return-Path: <SRS0=f6oI=BQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0662C433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Aug 2020 21:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD7CB2173E
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Aug 2020 21:47:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="avL9hOW0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgHFVre (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Aug 2020 17:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgHFVre (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Aug 2020 17:47:34 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A806FC061574
        for <linux-cifs@vger.kernel.org>; Thu,  6 Aug 2020 14:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=4pyPFJ1msjPajwihKHU+ksoJ3u2KKppvrG/Qqklyqrs=; b=avL9hOW0XTaiOcGqjmC2k45BN2
        9j/rG/PhQR7Is4ASOvvsUi9uOuN868S21mpxxyVzdszghhSyzxvRNShlPS3b6v/TB9qxtphoyCLtK
        49lUu04ALDzP8SWGNRTmX7nqf41KumzZqJTudM0phwKYgOYMhlGA7aRj0juomCixqIjVG8fiqgCtL
        c0I3cTFeCYqRw3EuNEiQa7D8n8Jz+Tu0NR5Ypmjnqh33b2Wh9HXF6IrYQF3e5lfbGsm7t13G1iqp3
        RqNKsst86bQumSWkTdBGjUwU3QEn5MH13FjqTvfy7XcLwv2i9oFe+z15X97jj1F1Kill/oOYZ+BQK
        OQBwnsgZshpAjjsg0ykUpxDs+TXaZnVWV66yPaOTINYtZKyCp79uvQTS33jtJO+8ayWEh7hmNgOaw
        4mDU69G6v+XnPxiy17Zi7b5p2VHikUHai9vg8h5VVA/vfFAZWx3cLMm7B7NOPtbOeGZf837tbfCeS
        ybinufr+DsNpjSnEEmx4BW72;
Received: from [2a01:4f8:192:486::6:0] (port=50946 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k3njX-0004UW-M1
        for cifs-qa@samba.org; Thu, 06 Aug 2020 21:47:31 +0000
Received: from [::1] (port=36904 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k3njX-008TUN-E3
        for cifs-qa@samba.org; Thu, 06 Aug 2020 21:47:31 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13795] Race condition in fs/cifs/connect.c causing "has not
 responded in 120 seconds. Reconnecting..."
Date:   Thu, 06 Aug 2020 21:47:31 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: piastryyy@gmail.com
X-Bugzilla-Status: CLOSED
X-Bugzilla-Resolution: FIXED
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status
Message-ID: <bug-13795-10630-l8YFrS2CJO@https.bugzilla.samba.org/>
In-Reply-To: <bug-13795-10630@https.bugzilla.samba.org/>
References: <bug-13795-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13795

Pavel Shilovsky <piastryyy@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
