Return-Path: <SRS0=kqF3=C3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A8EC43463
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Sep 2020 08:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF681206FC
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Sep 2020 08:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgIRIkp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Sep 2020 04:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgIRIkp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Sep 2020 04:40:45 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFC0C06174A
        for <linux-cifs@vger.kernel.org>; Fri, 18 Sep 2020 01:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=Fi+XjWa4Hv7FDzAUXQBkH7efRJKAZpcrreZbMM79ysk=; b=e9Mc7Oj7Bvi4ge66EpMJzwSrvw
        vlynT+sFz/4nQA+ZOXFs9Wc0QHKRqefkVs/6xu3brX000zRanj7yEwKlokU8lYRJ9Otqj3A/Yu0Jg
        ZE0qFd1VngJiM60XhANGu9NfBRNeMO+JKgiRdMNS+MPo3MIRFeXREG5CjhRCVbmLnuiImPVH41ffW
        ZVMokKTDIAEkvb5SSYYv+lCvb96CVQKc/heGLWXecX5mCAvLjA6jv7RyIDE3BvBZzeTAS7uZaXZB7
        A3TD675HuwxRXN+4o3nglKD0oyoPD6RRFAP6B6R1KzNltypJ5TDEODeEH2jKRr61WCYAGOkaoSAcZ
        LedlWA5+VPra9g6zFWcgqW3jUitffYHzYI8+uq522K3ROvcILrVg/KRgu5lEIkgc5gdD6XdysKuNM
        Q4J3Gpx23QnsrHerDl3pi+jG3iQPuvTSkJP8QASooydqfYW68NpY0J2Ten+yc4FkU4zfMUDOjlN6G
        9JKiCm82JL6DNHuaOJRkA4vH;
Received: from [2a01:4f8:192:486::6:0] (port=63960 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kJBwh-000781-AF
        for cifs-qa@samba.org; Fri, 18 Sep 2020 08:40:43 +0000
Received: from [::1] (port=29102 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kJBwc-002e82-8f
        for cifs-qa@samba.org; Fri, 18 Sep 2020 08:40:38 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14499] New: expose NT ACLs via system.nfs4_acl EA
Date:   Fri, 18 Sep 2020 08:40:37 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: enhancement
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone
Message-ID: <bug-14499-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14499

            Bug ID: 14499
           Summary: expose NT ACLs via system.nfs4_acl EA
           Product: CifsVFS
           Version: 5.x
          Hardware: All
                OS: All
            Status: NEW
          Severity: enhancement
          Priority: P5
         Component: kernel fs
          Assignee: sfrench@samba.org
          Reporter: bjacke@samba.org
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

At SambaXP 2020 the idea came up to expose the NT ACLs via the more commonly
used extended attribute system.nfs4_acl - which is the default attribute al=
so
for NFS4. Those ACLs can be managed with the well known toolset of
nfs4-acl-tools and those ACLs could even be managed by Samba through the
nfs4acl_xattr module. This would improve overall cifs ACL management a lot.

This bug is to folow the status of this idea, is there some rough eta for t=
his,
Steve?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
