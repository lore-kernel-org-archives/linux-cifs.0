Return-Path: <SRS0=eF+0=C7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A772EC4363D
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Sep 2020 15:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 402062395C
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Sep 2020 15:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgIVPCI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Sep 2020 11:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgIVPCI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Sep 2020 11:02:08 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BDCC061755
        for <linux-cifs@vger.kernel.org>; Tue, 22 Sep 2020 08:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=o39ki/g35mrfOENgzZm/5Bl8EL+6jA+x/EO/8/xZ0Rg=; b=yumCR3p228QVctbt2vQ6ndrvdM
        ewto4F7MHhLnaXx4M2csQzP0hJi/mR7JRqRfmqbN5tM6iOxUsFMVyEaihXhPFUvK99H6Q55rp8ImN
        PLAK+CFXgIPhSsURnRy8NUgLLAHbfSqQ+EDFEatz9zq2OulnNh4ooVVbKY4i4MnALX3TYmbVCYYeh
        Zawut8UOMvDIv4xlPAGBkz6nfqXNoDeZjwyqyCAWYZKJHwlwhieoqY0iVFB4xpDe0Fc/aiMUOP3lD
        AnzpbwFzrA4bISF6mBU9bOxCcAh1pFWH+F+eBaZGlYF3lJRKyXlWFsdh/N++6kBIQfPn6eRxFWdiU
        QqFcx68wf87oH05KI5IJONKxnpN3SW9ucVOh5C1aA/W4XP58PRhFQdDxwQmS8SrZdO+pQIrkxu4vm
        RUC0QNbouSoEeAyCZn8Zec4GBMgTxUeWvtDP/ahY0pZcW1hxaZR7F5bv8NY294mNvFBYpfWJ9kF7z
        5qjW/uu+SiDoRct9FO7ioG+6;
Received: from [2a01:4f8:192:486::6:0] (port=18906 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kKjny-0000Tq-Df
        for cifs-qa@samba.org; Tue, 22 Sep 2020 15:02:06 +0000
Received: from [::1] (port=31584 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kKjny-0032BX-11
        for cifs-qa@samba.org; Tue, 22 Sep 2020 15:02:06 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14509] Interworking Problem OpenVMS Samba Server 4.6.5 with
 Linux Samba Client 4.7.6
Date:   Tue, 22 Sep 2020 15:02:05 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: minor
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14509-10630-MXnQiWF2tm@https.bugzilla.samba.org/>
In-Reply-To: <bug-14509-10630@https.bugzilla.samba.org/>
References: <bug-14509-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14509

--- Comment #3 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
file name length of 0 looks very weird. I think you forgot to mention the
important point that you are using a OpenVMS port of Samba, don't you? Is t=
here
any point in listing a file that has 0 file name lenght? It would be
interesting if the the protocol specs say anything about such a weird case
also.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
