Return-Path: <SRS0=eF+0=C7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB15C2D0E2
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Sep 2020 23:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15E22221EF
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Sep 2020 23:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgIVXHZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Sep 2020 19:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIVXHZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Sep 2020 19:07:25 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E32C061755
        for <linux-cifs@vger.kernel.org>; Tue, 22 Sep 2020 16:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=Lh9iKiJeWkZn3yzdTz1CEoOG/66nBdhqoUbgRIKOHdI=; b=xYr15E87u/nf1uJb2qmJd+eHS8
        Z+9kOyiEc1/DQnpidjQfsYvBacTiqfWj+jFsmGTnDpDwy0oENF+bzOMRZt9saBldKoCYN30U+3mLd
        OERn68SDM1mvxm7rbTAA/rJueA0PxjZ3ORoDQg3s9DtoD5UN5kFjupBoqCWZgwE2mwUhmcXZuwqAl
        R5eNHKlEgcvcYHNCFbj5qUcu+bynKZ40QsYAdc9S5fU3iihO8GHsvp6+DR1317SGamJJYkDfhkrs0
        AjE9zWWRSLmkmha7yRjD/BhBHGvRIxprb5pvKn3WzO5+MdmMq/jKIMFLWrQtdhaxb9alk6DvMK3Rx
        kb9LKr3aOAAhmVkALX2Wwq69ZY/xWe5+dG+8BNe8ietDgYz1UwjCtzw95vHUKcXvxC/rX2JFmbSVO
        P2BbTYNZ4VAmoTGqmAQk/0NLPIJhwmlYQBwl9V3Aab3rueNz2+ESbTQr0jwbkIPLlTO7uTbzNsB2A
        wtWhAJhe33Hg9VRKJIW0TMLh;
Received: from [2a01:4f8:192:486::6:0] (port=19056 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kKrNb-0003og-Jo
        for cifs-qa@samba.org; Tue, 22 Sep 2020 23:07:23 +0000
Received: from [::1] (port=31734 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kKrNa-0032ie-RN
        for cifs-qa@samba.org; Tue, 22 Sep 2020 23:07:22 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14509] Interworking Problem OpenVMS Samba Server 4.6.5 with
 Linux Samba Client 4.7.6
Date:   Tue, 22 Sep 2020 23:07:22 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: minor
X-Bugzilla-Who: sfrench@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14509-10630-klCLSOcbga@https.bugzilla.samba.org/>
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

--- Comment #7 from Steve French <sfrench@samba.org> ---
On create, presumably open means the root of the share so this presumably i=
s a
server bug.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
