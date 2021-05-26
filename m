Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C133C47082
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 15:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31A3661002
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 15:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbhEZPiZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 May 2021 11:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbhEZPiY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 May 2021 11:38:24 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E79AC061574
        for <linux-cifs@vger.kernel.org>; Wed, 26 May 2021 08:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=lFfV8xKr8jOSkJ0+YNmDkVWLS5D/EeYxhR+kZVi9Mso=; b=BZ5ekaCubJZToLq1jGO1czVfUX
        WcWbVypmX4ixN07rD8rHtXZE8tzPqRKWqJjSkgI8FYrHmYOE2bx/giUawioTOK8/9fBOFL6TVlLkI
        /QiFxVmv2IsZ0uHUKkNG6xKRBWz1+UzG4FAmN6WgwpA94hzzByut0dNCfYhBusWMaeImwkWW7WNCP
        oTfBbAFnqj+HfBNkKhUeHXuKzjp6SnTUeq4iZaPtShPnUpJP5hWMhkOcCUbHEggv6hwEg2nqd4gd2
        4ro0LI5FTmmYDUFnYPg8WuIDG16xnOeoU9rlYjjMUtD/ObmTg7pkGR0Zqi53QsuTLl6QgAqAAWmI2
        7tuytFflg4+CY6hyVDawH1m3qibOJnXR8SyzH++4/AnfSNpcakuj2R4hhYp2ybp2rAuK32LGdaw0P
        tgeYIcvczyuNd1f/PL4IkFT8B2ZbXtG54U0dQMmOXI2501EwRon3sWSu6XBManpKHhZLXRUZZDlXQ
        +htuF24LeKkH9Hd78YpsJwVr;
Received: from [2a01:4f8:192:486::6:0] (port=56320 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llvaU-0000tq-Jo
        for cifs-qa@samba.org; Wed, 26 May 2021 15:36:50 +0000
Received: from [::1] (port=34206 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1llvaU-008p2e-2D
        for cifs-qa@samba.org; Wed, 26 May 2021 15:36:50 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14713] SMBv3 negotiation fails with a Solaris server
Date:   Wed, 26 May 2021 15:36:49 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sfrench@samba.org
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14713-10630-nI3N3HVy4p@https.bugzilla.samba.org/>
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

--- Comment #28 from Steve French <sfrench@samba.org> ---
> fear is that some flag is set wrong, maybe during negotiation

There isn't an obvious reason why any of the flag differences would matter
(unless server bug), but it should be possible to test mount with smb3.1.1
(without encryption) by changing the server config line
      server_encrypt_data=3Dtrue
and make sure server doesn't hang up on tree connect (as it does with
encryption)

If we verify that wireshark can decrypt it, then the only strange guesses I=
 can
think of that would cause the server to give up on the tree connect are:
1) difference in tree connect flags with smb3.1.1
2) differences in padding of the tree connect request that confuse the serv=
er

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
