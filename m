Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F313C433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jan 2021 14:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0286224D3
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jan 2021 14:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbhAGO6e (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Jan 2021 09:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbhAGO6e (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Jan 2021 09:58:34 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1D8C0612F8
        for <linux-cifs@vger.kernel.org>; Thu,  7 Jan 2021 06:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=B/2yrD8QTiCZz/hbiQh+/CqTcCCy5i/vb62+LjiPxtY=; b=wZHIU6qBdz9+zFh4XsaFDulyFN
        5yQAFZsdlAUjB/YQUlkH+ccs/dYs8VCK43HpQ+LRSxZbU+C+5q0kOUYgzwCFNRL3ubm6/ZaRSaTHb
        72fuXoQUpTrrVaE4XeVLLd9aRF8z/21jql4+UgIV44RFJWqQ1qrlkL48SCEphKITGiy5sAjCzquKW
        GvFmVVEx6WLyLyQNVM7FnHChadaNxr2UsrsiKCAxP/0rdkmabncEUo6tj4Da+5G0t1ip99xB+Ce6H
        GN0wE+XEqDWyeHTO5Z/10JZadKMvTXkRnKoxekWAkPgdKZlyNLMvp/LWYYRpmXNwOsdJ/bAqpDkxi
        fVQlEwSBaLs/cWYeWa0MZJgrc08yHXGS2TNUUGXdr1tkrKEIdhwlMBhaW2rvNH0MArx3H+1uFurvM
        fz20jgFQIzzkqSUnZuJPikZsuVXsJZtJ44GmSnjmPATkihMG5P4AH9af/KUNmE1/a2r+53hJgce4n
        MEHwHV6++4WvVK8V1TisBIMq;
Received: from [2a01:4f8:192:486::6:0] (port=58036 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kxWjT-0000Kw-Kp
        for cifs-qa@samba.org; Thu, 07 Jan 2021 14:57:47 +0000
Received: from [::1] (port=27472 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kxWjT-002xna-8f
        for cifs-qa@samba.org; Thu, 07 Jan 2021 14:57:47 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13712] Unable to access files below folder name with trailing
 dot or space
Date:   Thu, 07 Jan 2021 14:57:46 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: resolution bug_status
Message-ID: <bug-13712-10630-5EftObgMkt@https.bugzilla.samba.org/>
In-Reply-To: <bug-13712-10630@https.bugzilla.samba.org/>
References: <bug-13712-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13712

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Resolution|DUPLICATE                   |---
             Status|RESOLVED                    |REOPENED

--- Comment #3 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
sory, I need to correct myself, the testcase you mention is really broken!

Steve or someone else who feels responsible for cifs vfs bug repost, can you
have a look at this, please?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
