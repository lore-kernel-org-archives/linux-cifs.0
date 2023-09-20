Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E099CE79D1
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Sep 2023 13:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbjITN03 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbjITNJs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Sep 2023 09:09:48 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37352CF
        for <linux-cifs@vger.kernel.org>; Wed, 20 Sep 2023 06:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=ZyinnjiWdvsdV7F1V/XJsua8pC2/jAnMBCTi2Z44jBk=; b=Os3C44Oq575EWMoqQ8IvC2FyWG
        wuj3iShkvQjO6FOjU0w/F7e4UvqhTTAao0nMmGh85c+i6tge5SWjz7MxK43T2Oj71rxojd/kofdEV
        mBzFps6gQ4LqSBI9x37K1k+5XzJwBpwCOzgRrCk4ThQjx7F6afE5zizGTjC4I8oQlR4XsBKhryqRi
        MxuzPz4cooLYfVu+Mxrp/EUQA618Nc68tM+uvEAVQD8IT9W0YIhbYZkiCXYx8iNMaby2FQTc7Xu2M
        wTVjVRtPIeKZJn4c2sgdtv8rJsxegDrFX1Af0HkMZg25dtpBD+NZiFMN4vplgXb9Il7o7qXMEbYaZ
        5Rkr3KYoWFJd+Yp3NnCydH7Rprk4B6XLW7T5UphJeOsRcgdOvhMmFkOyxaoHpIBBZLu3HmFsluDEl
        FKOSYmXjATmxRCxcI5zpugsDjohyJomWsWliqmkSB3OAufk0SVXN9XR5Os0jdRsdJoYEpjC2k3uML
        FO5b+CXTsZOUcS9P0fKE2kIK;
Received: from [2a01:4f8:192:486::6:0] (port=34026 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qiwxT-00EV0l-1e
        for cifs-qa@samba.org;
        Wed, 20 Sep 2023 13:09:35 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qiwxS-001MAl-Q7
        for cifs-qa@samba.org;
        Wed, 20 Sep 2023 13:09:34 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15480] New: Mounting Azure Fles Share using cifs-utils fails
Date:   Wed, 20 Sep 2023 13:09:34 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: sverrir.jonsson@thyssenkrupp-materials.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone
Message-ID: <bug-15480-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15480

            Bug ID: 15480
           Summary: Mounting Azure Fles Share using cifs-utils fails
           Product: CifsVFS
           Version: 5.x
          Hardware: x64
                OS: Linux
            Status: NEW
          Severity: major
          Priority: P5
         Component: user space tools
          Assignee: jlayton@samba.org
          Reporter: sverrir.jonsson@thyssenkrupp-materials.com
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

we are trying to use CIFS-UTILS (Version 6 included with Ubuntu 22.04 as we=
ll
as Version 7 installed from=20
https://www.samba.org/ftp/linux-cifs/cifs-utils/cifs-utils-7.0.tar.bz2 ) to
mount a share from Azure Files.=20

'''
edgedevice@edgedevice-8CG8360GN5:~/cifs/cifs-utils-7.0$ sudo mount -v -t ci=
fs
"//sa32310601.privatelink.file.core.windows.net/prodfileproxy" /mnt/azure_t=
est
-o
"username=3DS1003368,domain=3Dtk-materials.com,password=3D*****************=
****,vers=3D3.11,sec=3Dntlmssp,serverino,nosharesock,actimeo=3D30,mfsymlink=
s"
mount.cifs kernel mount options:
ip=3D10.5.142.10,unc=3D\\sa32310601.privatelink.file.core.windows.net\prodf=
ileproxy,vers=3D3.11,sec=3Dntlmssp,serverino,nosharesock,actimeo=3D30,mfsym=
links,user=3DS1003368,domain=3Dtk-materials.com,pass=3D********
mount error(2): No such file or directory
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and kernel log
messages (dmesg)

DMESG Reports the following:
[83672.820955] CIFS: VFS: cifs_mount failed w/return code =3D -2
[84042.391251] CIFS: Status code returned 0xc0000016
STATUS_MORE_PROCESSING_REQUIRED
[84042.429097] CIFS: Status code returned 0xc0000034
STATUS_OBJECT_NAME_NOT_FOUND
[84042.429126] CIFS: VFS: \\sa32310601.privatelink.file.core.windows.net Se=
nd
error in SessSetup =3D -2
'''

Mounting the same share from a standalone Windows 10 machine Works. As well=
 as
using the Samba smbclient.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
