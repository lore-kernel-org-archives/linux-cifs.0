Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 642CEC00140
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Aug 2022 03:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbiHEDOv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Aug 2022 23:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236133AbiHEDOi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Aug 2022 23:14:38 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462C22E6B1
        for <linux-cifs@vger.kernel.org>; Thu,  4 Aug 2022 20:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=zxoxH5htGI8P/YmPFQsEdeaJ3vJQjvcCkVGBIhHymAc=; b=eaLYBxJmiEzGlRV3vMLYc43uE6
        gm+imMBcqPjV/JNFd51zEXqU99EYN17Szsww/lQNKQBW4L6wjoWHIazyux9bL5vLC1UpBXD+grfQy
        5WpOTmC9F3YU1gt9iCzP8N5en5z3SaNTRhChCK76EkEE105e3LM86VqR9LxHHxy8Tj82zt4NDuFyx
        cSxkTUJ0GN1UaAZ7UMI9lZnvzHzdc0m6h9BzXF9iWlpd5SI8KdRbXTZQKxBWuFPxpxgeeAvGNV+GD
        ZUImDDkN7dxw7Q1FK4PAIctpQZ9mxEMyeADd3vmsftwC06m571CZbVQVS52Rx4ycQ/VMOQbxC3YXh
        8PN3auhCVSYcmym6wKCHeNsPaLxhBvECwao+1PDWTW1aPKSPKZHa4nmBFHly9Nkw2sFnPPIkL6WH6
        udjsfZUJz53OsFxyKDkL5PZBXWja80ViJAoiS7cSIukZwzgTDBcdMqB9atPqVCe8g8CHxHlrjMYVZ
        EKgBoSVZQ/QCBaN5XXFlFMPA;
Received: from [2a01:4f8:192:486::6:0] (port=57526 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oJnnG-0089Uf-Bc
        for cifs-qa@samba.org; Fri, 05 Aug 2022 03:14:34 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oJnnF-002wb9-DE
        for cifs-qa@samba.org; Fri, 05 Aug 2022 03:14:33 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15136] Access to cifs gets stuck for a while (>20s) after
 disconnecting from network
Date:   Fri, 05 Aug 2022 03:14:33 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 4.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: wangrong@uniontech.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15136-10630-23Xkv9Xp6H@https.bugzilla.samba.org/>
In-Reply-To: <bug-15136-10630@https.bugzilla.samba.org/>
References: <bug-15136-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15136

--- Comment #2 from wangrong <wangrong@uniontech.com> ---
Hi, Thanks for your reply and suggestion

I want to explain the design intent of wait_reconnect_timeout, it is used to
set the strategy for the application to wait for reconnection.
    wait_reconnect_timeout =3D=3D 0, the application does not want to wait,=
 and
returns as soon as it detects that the connection is unavailable.
    0 < wait_reconnect_timeout <=3D sk_rcvtimeo, the application wants to t=
ry to
wait, but is not guaranteed to complete a connection attempt.
    sk_rcvtimeo < wait_reconnect_timeout, the application wants to make sur=
e a
connection attempt completes. This is the behavior of the current code, but
providing the wait_reconnect_timeout mount option gives the application more
choices.

Would it be better to provide both sk_rcvtimeo and wait_reconnect_timeout m=
ount
options? it avoids hardcode.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
