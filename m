Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61D2C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jan 2022 17:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238633AbiAJRzR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Jan 2022 12:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238641AbiAJRzP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Jan 2022 12:55:15 -0500
X-Greylist: delayed 1032 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 10 Jan 2022 09:55:14 PST
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B738FC061748
        for <linux-cifs@vger.kernel.org>; Mon, 10 Jan 2022 09:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=SdadVNEtyTr8O8LtDiAu1NAIiIgQhXP4iu0VvV5W2ZQ=; b=tQP8sKw2F6SO5YU5n6YN+j7fjt
        lDptxJBIFFoeSbx0VF2zRGdm9tZ8IrLOCISeYdO8JgT47+QV5O3SrvBFsTcXOCJN9nysquDTgrD2i
        mRyW8DfNpK8Fh9ByAsDdNQJH54yVYZpuwlvb68yPPQKuzQvbzsnK6QrrCvIwX1s7YzwcOVZRyjUV6
        qfh52FWUBY0I8UykrPIT6jOvER3ER/WycrBATshDuxXNAAoXBOzWCOpj3i5s7JMECP9fThIpWh6oD
        ZabAAuNsv4CoD6v7hU2K7JQYP4mc+jkyJL5HsHUK4EhyG9HRrM3A9et24p7XSVELmvvArA5p8ZJtl
        dSX1+1DFOCOJ3MyhQ0t0IQMFy15o1zVKolYrFn3vUH+kQXiuo02UdXBGdBg9Q6M4xcwChz3SKHPXT
        Jk8yBFTbSme24OCcs1o5pIn3h8nmGnCemLFoRhJpXoma/HK4HahkTqVmwTOUlHfIvT+GU1kQxhQWU
        osPQbJWtE7bdooYdOyjJFczK;
Received: from [2a01:4f8:192:486::6:0] (port=45330 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1n6ycI-006cln-Bs
        for cifs-qa@samba.org; Mon, 10 Jan 2022 17:37:58 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1n6ycH-0003wH-QO
        for cifs-qa@samba.org; Mon, 10 Jan 2022 17:37:57 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 7179] mount.cifs mtab locking Denial of Service
Date:   Mon, 10 Jan 2022 17:37:57 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jlayton@samba.org
X-Bugzilla-Status: ASSIGNED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: product qa_contact component version
Message-ID: <bug-7179-10630-wzKgJbCv3w@https.bugzilla.samba.org/>
In-Reply-To: <bug-7179-10630@https.bugzilla.samba.org/>
References: <bug-7179-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D7179

Jeff Layton <jlayton@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Product|Samba 3.6                   |CifsVFS
         QA Contact|samba-qa@samba.org          |cifs-qa@samba.org
          Component|libsmbclient                |user space tools
            Version|unspecified                 |5.x

--- Comment #6 from Jeff Layton <jlayton@samba.org> ---
Nope. I'm not sure this bug is really so much an issue these days since mod=
ern
distros have turned /etc/mtab into a symlink to /proc/self/mounts.

In any case, this should probably be in Pavel's queue...

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
