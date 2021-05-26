Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 685BBC47088
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 22:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49BBC613CA
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 22:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhEZWLM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 May 2021 18:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhEZWLL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 May 2021 18:11:11 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A70EC061574
        for <linux-cifs@vger.kernel.org>; Wed, 26 May 2021 15:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=yNf5E1277npxllTNiWEbUW6URf34xtYmXLVXu13GvN8=; b=UiJU9RX+3+wG36Pg44Zb0k73S4
        gbpdYah1XjFPhNDSLm/9ECkKVZT2bElLnUT//W1MzlH4xbZbmJ9SZHu0sY5solmX+9mgamlfgi7/8
        ZFNQZ8nufhOImSCl2bwvdLFvgv9WfY7aDOwNlrzB2QMB1YT+npwj1PmZUfoiZmu0lJkkZbVAPcIYK
        ilVPSEF04/8yDJPuTumae4Wrc2ESF0cwE/j1FA/FWT82R06bi7mncPPtWmP/VGVvt2V9aoQN7lJh4
        jY3mOZqxJXOzFdTdOlTyeYoypAjHcHXN+L184a2RHyD3Rh9kcEpBkcQbqkaVWRRZhmTidpiYMX/+C
        DrDj/IeRUoqVuz+ZroaEdoAgKDdD7rRVl9cE/MJQeqbeBS7qwtxydvMpyBXoYeSyrpsqTk6icXhe4
        ZjI+7Dw1fJZAO+cIMmtbBOlBjko04RMZF7WD+jTxDzZGG61/+Zp0QnW+NkZCIOSJsNqw+Js7TdBis
        /1lu5daCdcWsvlQnCgphwgTp;
Received: from [2a01:4f8:192:486::6:0] (port=56390 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lm1ia-0004Lz-56
        for cifs-qa@samba.org; Wed, 26 May 2021 22:09:36 +0000
Received: from [::1] (port=34274 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1lm1iZ-008pIc-P1
        for cifs-qa@samba.org; Wed, 26 May 2021 22:09:35 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Wed, 26 May 2021 22:09:35 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ronniesahlberg@gmail.com
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14713-10630-SIu63zut5Q@https.bugzilla.samba.org/>
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

--- Comment #32 from Ronnie Sahlberg <ronniesahlberg@gmail.com> ---
Note that in vers=3D3.1.1  the TreeConnect calls are always signed
which means that client and server must agree on what the session key is.
Just like when encryption is used.

Try to see what happens if you use vers=3D3.0 in this scenario as the TreeC=
onnect
will not be signed.


It does sound like there is something wrong with the session key and client=
 and
server disagree on it.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
