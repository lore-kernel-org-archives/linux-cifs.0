Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D064CDB474
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Oct 2023 03:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjJMDee (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Oct 2023 23:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjJMDed (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Oct 2023 23:34:33 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B5FE1
        for <linux-cifs@vger.kernel.org>; Thu, 12 Oct 2023 20:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=0X72Nsr+HeZOpYmjZqtdVCl2HIOVNPosk/Tyl8HM1Pw=; b=2FkUUVkv65HKvJfop2G+SB6vht
        sbUQ7VlK8jk2wmerhnSsxy9CHveggF1gx2jUvJyJXcEHswzJATbcAKI1jMyUDk548K+tZaJbE6jAP
        4o3yDOp4BjeZC+thuNn6UPrjSAVIMnCHbsYXqQtEX5djXzpytWXSVGHqttE/Le0uOot6SQ8L25i94
        iIxamICGQp4U41dijYGDxRuthuKaV3A6Vk7eYQYTZx2H7JfOBrf1ZlrXXqtkozZTBUjPszORkb/X4
        By/TXy9S+kTTWQDM0aND/w2lhpHxub5VukQs33brtcm879XYDrQ/NDWBAnobyxVK3/I+U1toGANmh
        BeqdMuxv4s008IVHaQI+U7ZJqlJ+ENgR3FO3rK4+KzzYe0iA6uRqLAkVD9RvDJLSTwzHwqXGzkfZD
        Olb1c2ujQJQiSOuaW4dvBMksAfPPVTSrFnUkDMbBd1IeZ18irukbmMLSh7jk6m9n5HUOOnwa7nnuN
        ycj5wADaVFFQl7oc9bq1piRu;
Received: from [2a01:4f8:192:486::6:0] (port=39780 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qr8wV-000Mbx-2V
        for cifs-qa@samba.org;
        Fri, 13 Oct 2023 03:34:28 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qr8wW-000BJC-FM
        for cifs-qa@samba.org;
        Fri, 13 Oct 2023 03:34:28 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14492] Minshall-French symlinks cannot be searched for with
 "find . -type l"
Date:   Fri, 13 Oct 2023 03:34:27 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
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
Message-ID: <bug-14492-10630-BzYNXTwtMk@https.bugzilla.samba.org/>
In-Reply-To: <bug-14492-10630@https.bugzilla.samba.org/>
References: <bug-14492-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14492

--- Comment #5 from Steve French <sfrench@samba.org> ---
good catch - this one may have slipped through (we also ought to add a small
xfstest or equivalent for this so it doesn't cause problems in the future or
show up with Samba reparse points in the future etc.).

Will take a look

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
