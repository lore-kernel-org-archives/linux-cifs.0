Return-Path: <SRS0=AHfl=CY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2E8C2BBD1
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Sep 2020 02:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 902F520684
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Sep 2020 02:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgIOCKc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Sep 2020 22:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgIOCKW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Sep 2020 22:10:22 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79463C061788
        for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2020 19:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=OL0v2CNtw7VlckAPc0oBtlco1CQ4eceZm1iDlcvYRXs=; b=l+F+sI83jt0KAZrERznpJeH8u/
        mBFQisDZWGKQaFH2vdVbLfOR4DfSlnZESJ41eR/NQ+pd171OWQibNVthJuxt7OaKt/AQ1jfb52n2R
        tbyATGWW9WM6HZj412o7236DX56sAbMmY+xGG7jX0VoQEeIOG7IvV+zxcq3HWlLaHLVwOoV96DYRD
        aROXce+pgMuxUyz54djxQrN/gv/949vgGt+KtvRRZQu5PR0LNqQpOFQ6qyTITgkMvRitYb/wGcQ49
        rbYzNphgG3Ft+9QnPeiDXIvOdSrurrv3RazxbirZLJt9k7ANRXs12FiXNAUYhuupYiSbH0IEZ0CQl
        256BYHvziTM4E8K6/0YfGS+ehbC4uI+Ns3087vWjD+7FFrz3qQJ/9VPuCfoxVHvzbxgsoFHhJNOcQ
        vTMldrntgVtCsi4fhUelmWC+4hBL7UjazjQdumyP0hhG/eXlK/7LyFxahB6UlyZlzTvrE76AlaE7D
        rHiWcj69NKrfvU5/4PtSSl34;
Received: from [2a01:4f8:192:486::6:0] (port=60794 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kI0QG-0002U0-El
        for cifs-qa@samba.org; Tue, 15 Sep 2020 02:10:20 +0000
Received: from [::1] (port=25938 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kI0QG-002KEc-54
        for cifs-qa@samba.org; Tue, 15 Sep 2020 02:10:20 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14493] New: Conventional tools for managing ACLs can mislead
 the user
Date:   Tue, 15 Sep 2020 02:10:18 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: micah.veilleux@iba-group.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone
Message-ID: <bug-14493-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14493

            Bug ID: 14493
           Summary: Conventional tools for managing ACLs can mislead the
                    user
           Product: CifsVFS
           Version: 3.x
          Hardware: All
                OS: All
            Status: NEW
          Severity: normal
          Priority: P5
         Component: kernel fs
          Assignee: sfrench@samba.org
          Reporter: micah.veilleux@iba-group.com
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

On a client to a Samba share for which Windows ACLs are configured, "ls -l"
reports incorrect information, and no "+" is present to indicate that ACLs =
have
been configured:
------------------------------
mcrs3:/TCS # ls -lh testfile
-rwxr-xr-x 1 root root 0 Sep 14 23:05 testfile   # permissions are incorrec=
t,
"+" is missing, and owner and primary group owner are incorrect
mcrs3:/TCS # smbcacls //mcrs3/TCS /testfile -k yes
REVISION:1
CONTROL:SR|DP
OWNER:VPTC3\cifsuser
GROUP:VPTC3\Domain Users
ACL:VPTC3\Domain Admins:ALLOWED/0x0/RWDPO
ACL:VPTC3\cifsuser:ALLOWED/0x0/RWDPO
mcrs3:/TCS #
------------------------------

Still on the client, "chown" and "chmod" fail without error:
------------------------------
mcrs3:/TCS # chown vptc3\\mveil testfile
mcrs3:/TCS # chmod u+x testfile
mcrs3:/TCS #
mcrs3:/TCS # smbcacls //mcrs3/TCS /testfile -k yes
REVISION:1
CONTROL:SR|DP
OWNER:VPTC3\cifsuser
GROUP:VPTC3\Domain Users
ACL:VPTC3\Domain Admins:ALLOWED/0x0/RWDPO
ACL:VPTC3\cifsuser:ALLOWED/0x0/RWDPO
mcrs3:/TCS #
------------------------------

On the server side, these issues are not present:
------------------------------
mcrs3:/.TCS_local # ls -l testfile
-rw-rwx---+ 1 VPTC3\cifsuser VPTC3\domain users 0 Sep 14 23:05 testfile
mcrs3:/.TCS_local #
mcrs3:/.TCS_local # smbcacls //mcrs3/TCS /testfile -k yes
REVISION:1
CONTROL:SR|DP
OWNER:VPTC3\cifsuser
GROUP:VPTC3\Domain Users
ACL:VPTC3\Domain Admins:ALLOWED/0x0/RWDPO
ACL:VPTC3\cifsuser:ALLOWED/0x0/RWDPO
mcrs3:/.TCS_local #
mcrs3:/.TCS_local # chown vptc3\\mveil testfile
mcrs3:/.TCS_local # chmod u+x testfile
mcrs3:/.TCS_local #
mcrs3:/.TCS_local # smbcacls //mcrs3/TCS /testfile -k yes
REVISION:1
CONTROL:SR|DP
OWNER:VPTC3\mveil
GROUP:VPTC3\Domain Users
ACL:VPTC3\mveil:ALLOWED/0x0/FULL
ACL:VPTC3\Domain Users:ALLOWED/0x0/
ACL:VPTC3\Domain Users:ALLOWED/0x0/
ACL:VPTC3\Domain Admins:ALLOWED/0x0/RWDPO
ACL:VPTC3\cifsuser:ALLOWED/0x0/RWDPO
ACL:Everyone:ALLOWED/0x0/
mcrs3:/.TCS_local #
mcrs3:/.TCS_local # ls -l testfile
-rwxrwx---+ 1 VPTC3\mveil VPTC3\domain users 0 Sep 14 23:05 testfile
mcrs3:/.TCS_local #
------------------------------

My sernet-samba version is 99:4.12.2-11.suse150.

My mount is:
------------------------------
mcrs3:/TCS # grep "TCS " /etc/fstab
//mcrs3/TCS /TCS cifs
user=3Dcifsuser,multiuser,domain=3DVPTC3,sec=3Dkrb5,mfsymlinks,vers=3D3.0 0=
 0
mcrs3:/TCS #
------------------------------

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
