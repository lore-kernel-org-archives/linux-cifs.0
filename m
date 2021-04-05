Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9580CC433B4
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Apr 2021 21:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52FBE61353
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Apr 2021 21:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241253AbhDEVlF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Apr 2021 17:41:05 -0400
Received: from mail.xes-mad.com ([162.248.234.2]:27171 "EHLO mail.xes-mad.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhDEVlE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 5 Apr 2021 17:41:04 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Apr 2021 17:41:04 EDT
Received: from zimbra.xes-mad.com (zimbra.xes-mad.com [10.52.0.127])
        by mail.xes-mad.com (Postfix) with ESMTP id 7A0E220248
        for <linux-cifs@vger.kernel.org>; Mon,  5 Apr 2021 16:34:40 -0500 (CDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xes-inc.com; s=mail;
        t=1617658480; bh=rvADVjeHmEJKgRTVFcNmcC/cC/E8dYdNr2Madl5e5TI=;
        h=Date:From:To:Subject:From;
        b=I31ouF+yoRYp7YdAXDIRpHT9UGLgjCetcYkfa9mzt/OYJrHWSsZnfASzteGpm2wm0
         taLPyp1Vj20qdE2RuM4DQms7tV6cqFc6EDRdVV165ZNgxIoby4uLqB81UVzeNNjBMu
         l8r3PVSbD1giX2LHtKB7qzYJK8TZti77j7S9P+Ik=
Date:   Mon, 5 Apr 2021 16:34:40 -0500 (CDT)
From:   Nate Collins <ncollins@xes-inc.com>
To:     linux-cifs@vger.kernel.org
Message-ID: <3798863.814011.1617658480343.JavaMail.zimbra@xes-inc.com>
Subject: multiuser/cifscreds not functioning on newer Ubuntu releases
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.17.93]
X-Mailer: Zimbra 8.8.15_GA_3996 (ZimbraWebClient - GC89 (Win)/8.8.15_GA_3996)
Thread-Index: zfsCWz3oq5gRsOXrvAegmI+oaDcGLw==
Thread-Topic: multiuser/cifscreds not functioning on newer Ubuntu releases
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I initially posted this to the Samba mailing list, where it didn't 
receive much attention, but it might be more appropriate for a
CIFS-specific mailing list. Per the subject, this may be an
Ubuntu-specific bug, but I don't have the familiarity with CIFS to
claim this is so and that nothing is wrong with my setup.

---

This is a problem that's plagued us for a while that we haven't been
able to resolve due to the lack of familiarity with cifscreds and keyring
debugging, so I thought I'd ask here to see if there's anything obviously
wrong with our setup, or if there's any cifscreds/keyring debugging
advice that could help us.

We currently use multiuser CIFS mounts on a handful of domain-joined
Ubuntu 16.04 servers to permit users to access CIFS shares with their AD
credentials. The CIFS shares in question are mounted by a separate service
account. Everything has been working as expected on the 16.04 servers:

$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=16.04
DISTRIB_CODENAME=xenial
DISTRIB_DESCRIPTION="Ubuntu 16.04 LTS"

$ uname -a
Linux host1 4.4.0-206-generic #238-Ubuntu SMP Tue Mar 16 07:52:37 UTC
2021 x86_64 x86_64 x86_64 GNU/Linux

$ dpkg --list | grep cifs
ii  cifs-utils                            2:6.4-1ubuntu1.1
amd64        Common Internet File System utilities

$ keyctl show
Session Keyring
 [key] --alswrv      0     0  keyring: _ses
 [key] ---lswrv      0 65534   \_ keyring: _uid.0

$ cifscreds add share
Password:

$ ls /mnt/share/
Content
...

$ keyctl show
Session Keyring
 [key] --alswrv      0     0  keyring: _ses
 [key] ---lswrv      0 65534   \_ keyring: _uid.0
 [key] ----sw-v  [uid] [gid]   \_ logon: cifs:a:[share IP]

$ mount | grep multiuser
//share/share on /mnt/share type cifs
(rw,relatime,vers=3.0,sec=ntlmsspi,cache=strict,multiuser,domain=[domain],
uid=0,noforceuid,gid=0,noforcegid,addr=[share IP],file_mode=0755,
dir_mode=0755,nounix,serverino,mapposix,noperm,rsize=1048576,
wsize=1048576,echo_interval=60,actimeo=1)

$ grep cifs /etc/pam.d/*
/etc/pam.d/common-auth:auth    optional            pam_cifscreds.so
/etc/pam.d/common-session:session optional    pam_cifscreds.so
host=[domain controller]

$

However, with the exact same setup on an 18.04 and 20.04 server, I am
unable to access the CIFS mount after running cifscreds add share:

$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=18.04
DISTRIB_CODENAME=bionic
DISTRIB_DESCRIPTION="Ubuntu 18.04.1 LTS"

$ uname -a
Linux host2 4.15.0-42-generic #45-Ubuntu SMP Thu Nov 15 19:32:57 UTC
2018 x86_64 x86_64 x86_64 GNU/Linux

$ dpkg --list | grep cifs
ii  cifs-utils                            2:6.8-1ubuntu1.1
amd64        Common Internet File System utilities

$ keyctl show
Session Keyring
 [key] --alswrv      0     0  keyring: _ses
 [key] ---lswrv      0 65534   \_ keyring: _uid.0

$ cifscreds add share
Password:

$ ls /mnt/share
ls: cannot access '/mnt/share': Permission denied

$ keyctl show
Session Keyring
 [key] --alswrv      0     0  keyring: _ses
 [key] ---lswrv      0 65534   \_ keyring: _uid.0
 [key] ----sw-v  [uid] [gid]   \_ logon: cifs:a:[share IP]

$ mount | grep multiuser
//share/share on /mnt/share type cifs
(rw,relatime,vers=3.0,sec=ntlmsspi,cache=strict,multiuser,domain=[domain],
uid=0,noforceuid,gid=0,noforcegid,addr=[share IP],file_mode=0755,
dir_mode=0755,soft,nounix,serverino,mapposix,noperm,rsize=1048576,
wsize=1048576,echo_interval=60,actimeo=1)

$

The following error appears in dmesg whenever I try to interact with
/mnt/share:

[   44.660510] CIFS VFS: signing requested but authenticated as guest
[   44.663053] CIFS VFS: SMB signature verification returned error = -13
[   44.663172] CIFS VFS: failed to connect to IPC (rc=-13)
[   44.664501] CIFS VFS: SMB signature verification returned error = -13
[   44.665361] CIFS VFS: SMB signature verification returned error = -13
[   44.665442] CIFS VFS: cifs_put_smb_ses: Session Logoff failure rc=-13

I can't tell if these mssages are significant or not -- I recall reading
that this was just a change in logging between releases. I tried using
ntlm through ntlmssp for the mount, but none of those protocols resulted
in the mountpoint being accessible by my user (they did however get rid of
the dmesg message). I've tried adjusting other mount options to no avail.
I can recreate this issue on multiple shares across multiple servers.

I found this bug report:

https://bugs.launchpad.net/ubuntu/+source/cifs-utils/+bug/1900856

along with this one:

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=986168

which seem to be similar issues, except with Kerberos authentication. From
the first report, I enabled some more verbose debugging:

$ echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
$ echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
$ echo 7 > /proc/fs/cifs/cifsFYI
$ echo 1 > /sys/module/dns_resolver/parameters/debug

Then, when attempting to ls /mnt/share:

/build/linux-Y38gIP/linux-4.15.0/fs/cifs/smb2maperror.c: Mapping SMB2
status code 0xc0000022 to POSIX err -13
/build/linux-Y38gIP/linux-4.15.0/fs/cifs/misc.c: Null buffer passed
to cifs_small_buf_release
/build/linux-Y38gIP/linux-4.15.0/fs/cifs/connect.c: CIFS VFS: leaving
cifs_setup_ipc (xid = 109) rc = -13
CIFS VFS: failed to connect to IPC (rc=-13)
/build/linux-Y38gIP/linux-4.15.0/fs/cifs/connect.c: CIFS VFS: in
cifs_get_tcon as Xid: 110 with uid: 1001
/build/linux-Y38gIP/linux-4.15.0/fs/cifs/smb2pdu.c: TCON
/build/linux-Y38gIP/linux-4.15.0/fs/cifs/transport.c: Sending smb:
smb_len=100
/build/linux-Y38gIP/linux-4.15.0/fs/cifs/connect.c: RFC1002 header 0x49
/build/linux-Y38gIP/linux-4.15.0/fs/cifs/smb2misc.c: smb2_check_message
length: 0x4d, smb_buf_length: 0x49
/build/linux-Y38gIP/linux-4.15.0/fs/cifs/smb2misc.c: SMB2 len 77
/build/linux-Y38gIP/linux-4.15.0/fs/cifs/transport.c:
cifs_sync_mid_result: cmd=3 mid=41 state=4
CIFS VFS: SMB signature verification returned error = -13
Status code returned 0xc0000022 STATUS_ACCESS_DENIED
/build/linux-Y38gIP/linux-4.15.0/fs/cifs/smb2maperror.c: Mapping SMB2
status code 0xc0000022 to POSIX err -13

Not sure if these messages are meaningful, but I thought I'd include them.

There's been other cifscreds strangeness that we've noticed, like access
to mounts not being immediately revoked when `cifscreds clear[all]`
is ran, but this is the main, easily reproducible issue we've been seeing
that's preventing us from using multiuser on CIFS mounts.

We use Samba DCs on version 4.12.3-8, and the CIFS share hosts are
up-to-date TrueNAS servers.
