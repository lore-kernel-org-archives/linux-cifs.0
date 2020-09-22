Return-Path: <SRS0=eF+0=C7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38D7C2D0E2
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Sep 2020 23:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A66AF221EF
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Sep 2020 23:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgIVXJ5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Sep 2020 19:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgIVXJ4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Sep 2020 19:09:56 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B055FC061755
        for <linux-cifs@vger.kernel.org>; Tue, 22 Sep 2020 16:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=aVkhD3BxAP0wnMGSxvVtQAoKwassx43KAQd2kDMAlzQ=; b=bmZUdbeeYTd+N/vqwAEPmqdGa3
        qS1ZtSZqosMy5uSHGtqgG3MrZzhh2r9t/uuLJcYE734X2iE6qZIAv2VQuNotaRO+hyYUKwlfZoqEu
        9nzW7mz+oXZMdB3oAoqyvcCoCyEsL7VhQMIjxeO3Zq88DXcCONn6tYONf5b1TCXfZwzBiTrDwjex9
        8iIX9snxoa3EMz7YXKbvqjFW8lpO0NRuhWMuupN6l2pkLl50vgtkmlTCYpAN1LcYptGelRnBIiUl9
        2yCY8WmsgG2odOaZbz2pDCYBVurnKo9Ydj+YAkCbNBA3m5VAVdK33AJQFX30eZWlsQ5bi2kESFZTM
        g++xj71sZvakHlq+Bke6yhXZag2X41EnpKGCMK7OXyLUVWDYRKmlvRL2FA71fs5Sa3nLu8eHYI6DI
        JfA/l1GPWyVsY9/vX3sWL13sxPDsC2pb10mAMtwYYDOxPI27DoQ9iU+C8o4b+5bH6oCmWe4TNoYBz
        5ACLBYdc+8JL3L+q+dS+XXGA;
Received: from [2a01:4f8:192:486::6:0] (port=19060 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kKrQ2-0003ph-QB
        for cifs-qa@samba.org; Tue, 22 Sep 2020 23:09:54 +0000
Received: from [::1] (port=31740 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kKrQ2-0032im-DD
        for cifs-qa@samba.org; Tue, 22 Sep 2020 23:09:54 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14509] Interworking Problem OpenVMS Samba Server 4.6.5 with
 Linux Samba Client 4.7.6
Date:   Tue, 22 Sep 2020 23:09:54 +0000
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
Message-ID: <bug-14509-10630-1aJQk1ygaT@https.bugzilla.samba.org/>
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

--- Comment #8 from Steve French <sfrench@samba.org> ---
(In reply to Steve French from comment #7)
typo above:

On create, empty filename (length 0) means the root of the share so this
presumably is a server bug if it is allowing it in query dir response.  The
"MUST" in the spec indicates that server can not return it.  Sounds like Li=
nux
client behavior is reasonable returning an error.  Any idea how anyone could
ever get Samba to return 0 length filename?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
