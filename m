Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26615C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Jan 2022 11:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352775AbiALLJm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Jan 2022 06:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352776AbiALLJk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 12 Jan 2022 06:09:40 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0018BC06173F
        for <linux-cifs@vger.kernel.org>; Wed, 12 Jan 2022 03:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=awvZsCH9vh6r2P0sbzH8u9YY6RFXHlW148Q+lmcG1FE=; b=Szuy6HS8Ul0hLBmQMWDITGului
        E42ize4dMfcbe3InhN8PAKPDVyWDbeBTlJEGOuIc9oyzzuaiNliuQCOXAUZcFmEeXT61RLvfhhqib
        5Ej7Nq3TQpk4lWhl8AXv2eKkU8D/3Mbhzo7IiTlJCreA66OznP9OoyqiPCK/hzqYvdGZx24CQXbll
        ubX6XOzcdXl5rANwBEMJUbvuE5PY/SIuv92fdl7YRGvJ3WFORcsZlELJKv2M0V+yMMIrYQoPBXuZ2
        yj24wmVPVr4+xP6sOUxlyJSV4zJKkwzJovgOkgF/V7CRoMhrM9xY+KD4cZxfxXK71X8ixU3Y/ie9h
        Ts2QFAy88Ocv/rkMXjLGF3NROitZ1Ae0mP67k+nNTBV5w9sXG+GFyFFkCd5uAe/BzgOY63yDJZoO/
        dTsXFegedisV2pr7eDeJbdO4VKwtwKcW+dAI10BLTAl3xdZgCsl6r7PxJzW2Pz6lEbshMz7F7vXoq
        92UvmPIXPGXDjx/IqkCbzbpJ;
Received: from [2a01:4f8:192:486::6:0] (port=46708 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1n7bVY-006uTm-C8
        for cifs-qa@samba.org; Wed, 12 Jan 2022 11:09:36 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1n7bVY-001Q0l-3a
        for cifs-qa@samba.org; Wed, 12 Jan 2022 11:09:36 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 7726] NT_STATUS_ILLEGAL_CHARACTER -- cifs broken
Date:   Wed, 12 Jan 2022 11:09:35 +0000
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
X-Bugzilla-Resolution: WORKSFORME
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: resolution bug_status
Message-ID: <bug-7726-10630-MsiwGa69dK@https.bugzilla.samba.org/>
In-Reply-To: <bug-7726-10630@https.bugzilla.samba.org/>
References: <bug-7726-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D7726

Bj=C3=B6rn Jacke <bjacke@samba.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Resolution|---                         |WORKSFORME
             Status|NEW                         |RESOLVED

--- Comment #4 from Bj=C3=B6rn Jacke <bjacke@samba.org> ---
no response, no similar problems known these days. Closing

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
