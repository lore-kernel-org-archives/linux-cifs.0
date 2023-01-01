Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3945C4332F
	for <linux-cifs@archiver.kernel.org>; Sun,  1 Jan 2023 00:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjAAAzX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 31 Dec 2022 19:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjAAAzW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 31 Dec 2022 19:55:22 -0500
X-Greylist: delayed 1504 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 31 Dec 2022 16:55:20 PST
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EC66580
        for <linux-cifs@vger.kernel.org>; Sat, 31 Dec 2022 16:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=R1ldD4SfBd9cFIsYXMWscQEpVThY+Ms7xDPGNAjJsC4=; b=aifEfVHO+hVIr8zq8ac31QJt3s
        sgsyBwuOp2nOIXpMLeSg7c5FHncFPprTcpacr1+M4LKZKuh0wJg9FDlyGE2C+9qaWOtx6L6b0zDNi
        J2VG2yX+vjNoGn7dFEHfhFqyFmR6oJggb02pAzYbhAniMJOYHt6MFUuOW2kxlZ5yL9DBMo+pr2XWC
        FOu60bb0t1CAaJrz9FCzmCYSPFf5KLrPQg6THvi0psVRfzVuvWXqZEuqMXyndzvkJtOcbqrdMSshr
        FTvVuljyZ1Ztd+As1lzed6/fupw63uzKGrNLQ9ZqrGpeMLJ3hIRqzLPYPN8kNgPtcTQ8DSBizbOf9
        Ggxbqe9Gzq6uiV/1SU+3uhnQLyUNrA3vP5zhZ+fnhmjf0z9L84wusmYvJl8i7mYdryfODd78LXrUo
        F0DGG8wyX7pbytTKyMDF+Hsl/8jrfGtqsjdXH40Jf42WRuQTLtlVyfhvrGEykGtdXzCyeLNVuSRbi
        DREHH96CQRjuBDybWGFiBqfa;
Received: from [2a01:4f8:192:486::6:0] (port=44740 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pBmEv-006FcC-23
        for cifs-qa@samba.org; Sun, 01 Jan 2023 00:30:13 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1pBmEu-002Z2T-FS
        for cifs-qa@samba.org;
        Sun, 01 Jan 2023 00:30:12 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15274] New: detection for systemd in mount.cifs.c fails when
 running in 'unified' systemd breaking ask password functionatlity which leads
 to permission denied
Date:   Sun, 01 Jan 2023 00:30:08 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: regression
X-Bugzilla-Who: eric.vannier@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone
Message-ID: <bug-15274-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15274

            Bug ID: 15274
           Summary: detection for systemd in mount.cifs.c fails when
                    running in 'unified' systemd breaking ask password
                    functionatlity which leads to permission denied
           Product: CifsVFS
           Version: 5.x
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: regression
          Priority: P5
         Component: user space tools
          Assignee: jlayton@samba.org
          Reporter: eric.vannier@gmail.com
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

The current code to detect whether to invoke systemd-ask-password does the
following logic:


        is_systemd_running =3D (lstat("/sys/fs/cgroup", &a) =3D=3D 0)
                && (lstat("/sys/fs/cgroup/systemd", &b) =3D=3D 0)
                && (a.st_dev !=3D b.st_dev);


Though as explained in https://systemd.io/CGROUP_DELEGATION/ the presence of
/sys/fs/cgroup/systemd is not guaranteed on systems running systemd: indeed=
, it
is only present in 'legacy' mode.

As such, this means that any system that would be running in 'hybrid' or
'unified', the code fails to detect that systemd is running and defaults to=
 the
'getpass' method.

This obviously breaks the usage of mount.cifs inside systemd units.

Ubuntu 20.04 seems to ship in legacy mode, and it is working correctly, whi=
le
Ubuntu 22.04 is shipping in unified mode, and it breaks. Further given the
above documentation, it seems likely that more distributions are likely to =
be
configured in unified mode, and it seems reasonable to think this might be
affecting a great deal of users that rely on the systemd-ask-password solut=
ion
(as is necessary when mounting from a systemd unit).

I am not sure what the portable and reliable way to detect systemd, but a f=
ew
options that come to mind:
- /proc/1/comm =3D=3D 'systemd' might provide that information (but I would=
 agree
this might not be super maintainable and might be a too linuxy ?).
- doing the statfs code mentioned inside https://systemd.io/CGROUP_DELEGATI=
ON/,
though this seems kind of fragile in my humble opinion: in the end, the
mount.cifs should not really care which mode it is running on (what the
documentation tries to explain), and should only want to find out if it is
running within systemd at all.
- then maybe, the lazy/simple approach is to simply rely on the success/fai=
lure
of launching systemd-ask-password ... After all, if it exists, and returned
successfully one can probably assume that this is all we want in the first
place ?

Additional repro steps:
- configure a unit for example as <mount_point>.mount
"""
[Unit]
Requires=3Dnetwork-online.target
After=3Dnetwork-online.service

[Mount]
What=3D<samba_share>
Where=3D<mount_point>
Type=3Dcifs
Options=3Dnosuid,nodev,iocharset=3Dutf8,username=3D<user>,uid=3D<user>,gid=
=3D<user>,mfsymlinks,file_mode=3D0740,dir_mode=3D0750,noauto

[Install]
"""
(Note that I am pretty sure the options do not matter for the repro case, b=
ut
are reproduced here since this is how I reproduced).

- run: systemctl start <mount_point>.mount
observe that systemd-ask-password is not invoked and instead getpass is
invoked, but since  the stdin is not connected to the tty, you can only see=
 the
information in the logs (journalctl -u <mount_point>.mount:
mount[31947]: Password for <user>@<samba_share>:
mount[31946]: mount error(13): Permission denied

(permission denied since I must assume it passed the empty password).

Thanks a lot for your consideration. I could propose a patch and test on Ub=
untu
20.04 and Ubuntu 22.04, but per above, I am not quite sure which implementa=
tion
you would prefer.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
