Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A23C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Mar 2022 23:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbiCaX1d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Mar 2022 19:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiCaX1c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Mar 2022 19:27:32 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0338166656
        for <linux-cifs@vger.kernel.org>; Thu, 31 Mar 2022 16:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=osikR6rTJTKFRCibKajJj4uWjRWx4LhBv/Xri3wcykI=; b=YNvbmMGwlQz71rNGnxuxt7HlO9
        1QhZwXGbtVlk960Cf8sxO75i1AKEfUfXT2nKTGqnXQwf+jE0eBNLoVuy9qKhg6lEeQUinDzqgUfoW
        +/WNC7Lu61yfm2g3JO9XcBzD7hjaWGqIlXeE+o3o9KKuizCJeUe181Gr0WKLV+NIIvHGFXIBUFq0n
        iEq4CIB8SxrZ2DFfC9+t5Wo8Z+S4obcSdxJMA1btFf8HiegU/TjSdz61KhSj3aryR0UIKD/6oX8cA
        8kWFxUxwjjmbe5HcxZ42LUEbWEjcmKszCbNcaXyo0z6AbRL0KTsR5yttcn6kjJbdnPh0p0WQS5nLK
        Tx97YRj3jenuNAzgLzpZ5tqI13etiv83+9TLDaxTp0I6tMWU6HeeQe+jMBtMNWVtkWBPJG8fUlTCM
        mO5v7A2O+JGr3vjEVwGIiifSOb2iBbRANgfa73TYdqnEgVSiXUNnvuvdP1YhR9AGKjKsZ+ZNYWAKt
        If2nnrlNK9bsCemxIe3hiN0V;
Received: from [2a01:4f8:192:486::6:0] (port=57748 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1na4Af-004fRe-0h
        for cifs-qa@samba.org; Thu, 31 Mar 2022 23:25:41 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1na4Ae-002ikj-DX
        for cifs-qa@samba.org; Thu, 31 Mar 2022 23:25:40 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15025] CVE-2022-27239: Buffer overflow in mount.cifs options
 parser
Date:   Thu, 31 Mar 2022 23:25:39 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sfrench@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: ddiss@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_group
Message-ID: <bug-15025-10630-lVLlGk6zZR@https.bugzilla.samba.org/>
In-Reply-To: <bug-15025-10630@https.bugzilla.samba.org/>
References: <bug-15025-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15025

Steve French <sfrench@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
              Group|                            |cifsvfs-devel

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
