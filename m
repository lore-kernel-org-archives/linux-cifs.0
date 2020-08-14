Return-Path: <SRS0=wfZ6=BY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD6DC433E1
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Aug 2020 14:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CC7B2074D
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Aug 2020 14:21:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="IQ7LRSpI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbgHNOVw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Aug 2020 10:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728497AbgHNOVv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Aug 2020 10:21:51 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C22C061384
        for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2020 07:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=IkN1EuhVrTj/QmSKE3Ic6P7S+rneJbcbD20zoFYsHWI=; b=IQ7LRSpIoA2e1k9ZuM+aorsWj2
        yp1fcyoZworKlay5NwpDfU4Dnue4PtoyZk+mcgpdfZ2RNhwh1bhzut9KxlVIFaK2dIGMVdUFJv7rD
        QErCsZ/nFoNWADIVg8tpuX25pTM+i1cNvc/utymqEgahKcAIJut1rUrmXicUaDTjsKww2fX4xo9M3
        FoH9AnBNOMXGNKNOX0AOPFvCOoVvw5Lc6pYc1/XkgOeA76J2+x+iago5D3OfnClB9BHWN7wd3cXK0
        ic0SuxbZD3POt082Q6JHH9zICtPddLC/iqFzyyfdUmMFCP4rXrNPOAOojtoP+TtKQlRNPOWtBtxKF
        oZJyDwJmYhRj6Hebxu6bWAfpJXxqr9y0u+DrnsEqa064poYo8RN6VFOJthcQM924tsUOe6B0gcZLx
        d3c4UO7a+NBqmrRdg/Zs+7OOETw/IOjms1vCVBGuJ7yRuDRQuC9nuC/VJFUM959qxX1CYrXXwU4QT
        0TwKFBjjMIudyo7TYFEKS+5z;
Received: from [2a01:4f8:192:486::6:0] (port=54318 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k6aaZ-00037b-Nq
        for cifs-qa@samba.org; Fri, 14 Aug 2020 14:21:47 +0000
Received: from [::1] (port=40274 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k6aaW-0098Lr-LA
        for cifs-qa@samba.org; Fri, 14 Aug 2020 14:21:44 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 8431] Jumbo frames cannot be used by Linux client side
Date:   Fri, 14 Aug 2020 14:21:44 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.6
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: regression
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: resolution bug_status
Message-ID: <bug-8431-10630-0eHDlcMmqD@https.bugzilla.samba.org/>
In-Reply-To: <bug-8431-10630@https.bugzilla.samba.org/>
References: <bug-8431-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D8431

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Resolution|---                         |INVALID
             Status|NEW                         |RESOLVED

--- Comment #3 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
if the number of connections grow, then it looks like you have a network is=
sue
there I guess, maybe not all the network componets support jumbo frames the=
re
correctly? This does not look like a cifs vfs issue to me in any case.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
