Return-Path: <SRS0=eF+0=C7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 633D4C4363D
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Sep 2020 14:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE2962395C
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Sep 2020 14:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgIVOpG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Sep 2020 10:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgIVOpF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Sep 2020 10:45:05 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92ACEC061755
        for <linux-cifs@vger.kernel.org>; Tue, 22 Sep 2020 07:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=6BclYkMsq/qUQWwD9DZEviJpjQXhjyK36P9D3dFRGFo=; b=eUGwGd4jml21q2NPAq8W5rcb6I
        gHnhzWCWmVBKMOgPDreiE2pHiUUgF8c36/olRFY3ymwQYromFZg6JO3DIXRiCvcRIN99r/hJ10Oy9
        GVrVUyTY/vA7ViSrWnIBDixQpE5255Dj7VvoRm5A3kLg+EYpdwlm6vE1lZpoxwVY9/1KiFjmeeIoa
        1R3c8gXTMlibNFJwvP5FzjkfzNgC6oOQU1Dx1Ef6LN2Y0zkma6pxZggSAYiJZnk8c8oXoiNyteH58
        7/Mq6M4JELO6Qarik1akkXwqTJug+gw4LjHWESeAlN7IHX9SKqNBTQcarWh7xn46bXth5N59r9kbx
        AoJX4l+v3JotrXqUkDN40cKLn81eFse0jo/wNDXpPvP+umTQBOd8bfdLT7Y4+PAzXLH8PmAG4KeiP
        Jt9nRyt/BITYJC5+ef0oa+VMzr88hM4uRddsyyl7aQxaGFLBsS7j9c4EEWfiU8lHczzBiS2ZmP4aD
        5PVkXndH9VlQBTTzXqFeyg3q;
Received: from [2a01:4f8:192:486::6:0] (port=18898 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kKjXS-0000Lu-9j
        for cifs-qa@samba.org; Tue, 22 Sep 2020 14:45:02 +0000
Received: from [::1] (port=31574 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kKjXR-0032AM-RR
        for cifs-qa@samba.org; Tue, 22 Sep 2020 14:45:01 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14509] Interworking Problem OpenVMS Samba Server 4.6.5 with
 Linux Samba Client 4.7.6
Date:   Tue, 22 Sep 2020 14:45:01 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: minor
X-Bugzilla-Who: slow@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: version assigned_to qa_contact product component
Message-ID: <bug-14509-10630-QJ7ApQSjOz@https.bugzilla.samba.org/>
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

Ralph B=C3=B6hme <slow@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Version|4.7.6                       |5.x
           Assignee|samba-qa@samba.org          |sfrench@samba.org
         QA Contact|samba-qa@samba.org          |cifs-qa@samba.org
            Product|Samba 4.1 and newer         |CifsVFS
          Component|libsmbclient                |kernel fs

--- Comment #2 from Ralph B=C3=B6hme <slow@samba.org> ---
Chaning to product to cifs vfs as this seems to be a bug with the Linux ker=
nel
SMB client.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
