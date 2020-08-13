Return-Path: <SRS0=jY8V=BX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA59C433E1
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 16:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC6CE20855
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 16:43:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="v1SKz8Bo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgHMQnV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Aug 2020 12:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgHMQnV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Aug 2020 12:43:21 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58D6C061757
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2020 09:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=p2XW3F7G5G2pNZvATi0+V34vcM9pFws1VSdLNQlmZuw=; b=v1SKz8Bo0WaXaQvTsMP/AW6v4t
        X14VPJfEv7+/dba1WQefhxRFAWMCaV0JNPYzXe5aHoB7RfpAkRrhQBfSD9RQM+gV8tsfdKcWb2dzu
        eajEnUuVLfEqEYIVEFbMYqmsNYn5e2vBw5FqqN9TCyMLvxDiKSD1SABlEYD3/eROW1No2AxTH5BDJ
        SZnVMx9o0hLZDedZ5Bwnc4TRRkFmz3MNV80FkL4goEgi+SJlqdiJ1lsBGcRnw2RqQpbLKcRDv/i6W
        LHlyv5tLIDXWiF9BYsfeHkfXC4Hm3YxN6SMnSBdM8eIrZ9LwJqPYj1KKptmHsDrQXp9bVGx8/gbWY
        r/6PZm8his670U8E82cijsq5Qu07bBPtcPbrBrM3e4OXKV4hfveAHZA2gD2WCNrj09M8UjvRA9wc1
        J/BbdM2KTYfymMSfNtp+IlzsiHsBCr4gLBDpNaVCgcwepaNExX2Hp4OHRod5MJBvL2AqcAP3JOtgW
        i3kBygCgKomIalNtd8d/6o5I;
Received: from [2a01:4f8:192:486::6:0] (port=53890 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k6GJy-0002mL-BZ
        for cifs-qa@samba.org; Thu, 13 Aug 2020 16:43:18 +0000
Received: from [::1] (port=39848 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k6GJy-009350-5j
        for cifs-qa@samba.org; Thu, 13 Aug 2020 16:43:18 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 9484] getcwd does not work with noserverino
Date:   Thu, 13 Aug 2020 16:43:17 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.6
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: FIXED
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-9484-10630-itZxCeWBLq@https.bugzilla.samba.org/>
In-Reply-To: <bug-9484-10630@https.bugzilla.samba.org/>
References: <bug-9484-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D9484

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |FIXED

--- Comment #2 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
this seems to have been fixed since it was reported back in 2012

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
