Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA743C433DB
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Jan 2021 17:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CFBC2333E
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Jan 2021 17:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbhAHRaM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Jan 2021 12:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbhAHRaL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Jan 2021 12:30:11 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5E5C061381
        for <linux-cifs@vger.kernel.org>; Fri,  8 Jan 2021 09:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=ZSEwacM+L/3JG4u2GMRvkVq8TblubURl7F5+479jvb8=; b=rnp1RGdrw0AS967DzvxGXsTStm
        oRhl3fN5tJXgbLpuNxcAlHpNGPi2l2riaTpEV66uu3owQEdYtWEEoW2EtiA1aDFFBcQ5njG5pUBjF
        egFR2OONM7QFXSpqdtPxIXjlXWxBh8Q7cFm53D38bYqQodHVtHcHLYwAb1SOA6eSdTX/8iMv0ytB+
        EMG/gdnz7hL4gFazj1wOy7ZytXhBkajZVZqkRLz1ElaMgargniWoxEW+BXp7vBsq7N3DjDocOp555
        2Jw3bfd0HSm/6DoSgUKvQX3mjq4N7joXqoOiA/mUytBT9PDTjRdE3QveLUtEDUuHwdOTEskOj9caK
        97X5SNx1KFbrtsPcf3jfmppI5yZCC+pphWDIzjsr8Gyn+aDbvVURCxXxoaV1vZntZz1/SO1BTzfvN
        t7rczuZSn9GEdYNzKw7qEcrxOSDleedbARhGddPqklHUFuq0yyILk7l/dTvtGcrDwV1FuSzMXDKbr
        KW2mjBZbssO9tSHTPG+aIqby;
Received: from [2a01:4f8:192:486::6:0] (port=59040 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kxvZo-0003Fm-7M
        for cifs-qa@samba.org; Fri, 08 Jan 2021 17:29:28 +0000
Received: from [::1] (port=28480 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kxvZn-00339X-RR
        for cifs-qa@samba.org; Fri, 08 Jan 2021 17:29:27 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14610] New: Lockup in kernel 5.10 when copying large folder
Date:   Fri, 08 Jan 2021 17:29:26 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: wheybags@wheybags.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone attachments.created
Message-ID: <bug-14610-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14610

            Bug ID: 14610
           Summary: Lockup in kernel 5.10 when copying large folder
           Product: CifsVFS
           Version: 5.x
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P5
         Component: kernel fs
          Assignee: sfrench@samba.org
          Reporter: wheybags@wheybags.com
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

Created attachment 16384
  --> https://bugzilla.samba.org/attachment.cgi?id=3D16384&action=3Dedit
server side config file

I have been having an issue with CIFS mounts when running kernel 5.10 on the
client (using the 5.10 build from
https://wiki.ubuntu.com/Kernel/MainlineBuilds).

When doing a lot of IO in a file copy tool I'm writing, the mount would lock
up, and calls to open() would hang, sometimes form multiple seconds, and in=
 a
few cases indefinitely (I left it for multiple minutes). Accessing the share
from a separate process (eg, running ls in a separate shell) would normally
work fine, but on a few occasions the share locked up completely and wouldn=
't
re-mount until I rebooted. When the lockups happen I get the following in
dmesg, sometimes just once, and sometimes repeating thousands of times:

Jan  2 00:13:50 pooka kernel: [ 9548.025373] CIFS: VFS: \\192.168.1.1 No ta=
sk
to wake, unknown frame received! NumMids 1
   29 Jan  2 00:13:50 pooka kernel: [ 9548.025380] 00000000: 424d53fe 00000=
040
00000000 00000012  .SMB@...........
   30 Jan  2 00:13:50 pooka kernel: [ 9548.025382] 00000010: 00000001 00000=
000
ffffffff ffffffff  ................
   31 Jan  2 00:13:50 pooka kernel: [ 9548.025383] 00000020: 00000000 00000=
000
00000000 00000000  ................
   32 Jan  2 00:13:50 pooka kernel: [ 9548.025384] 00000030: 00000000 00000=
000
00000000 00000000  ................

The kernel messages will show up for me by running a copy of a large direct=
ory
using standard cp, as well. The problem is not present when running kernel =
5.8
(stock for my distro).

The machines are connected directly via ethernet, I am pretty certain that
connection loss is not part of the problem. The client is running Ubuntu 20=
.10,
with kernel 5.10, and the client is stock Ubuntu 20.04 LTS.

Here's the mount line from /etc/fstab on the client:
//192.168.1.1/allfiles                       /files_zfs cifs
rw,relatime,cache=3Dstrict,user=3Dguest,pass=3D,uid=3D0,file_mode=3D0755,di=
r_mode=3D0755,uid=3D1000,gid=3D1000
0 0

I have attached the server side config file.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
