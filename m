Return-Path: <SRS0=zmi3=CZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1930DC43461
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Sep 2020 17:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD9AA206B6
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Sep 2020 17:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgIPRpv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Sep 2020 13:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgIPRpi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Sep 2020 13:45:38 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED36C06178B
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2020 10:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=co+aE86MQ1OwE6c4K6MlweQ1WffNPTpkviewRQB67TE=; b=UbfGFvO7C/9ZFHqR/L1/lR4W2a
        LwLPQG6XwvO1IxH8LPjFDCqPv7uDgZVGv/QpWhNR6QPgFXT5G1Uxtos7QXQvkMHcQ+82dkvOEI988
        EX8964/VnX+gQHUwMPD9w7Dxkh7w6f3RGY/DcV4Vi+CCHBAS2pMzS3029XkHlxuuGs8VOAPOoG2y1
        7OZFlPv/CFS9ZefOEhio+KHBq90hW4D6vlvprxDNJ1qzStYp9c2zNHEBzHN1norczZSh+j69ud+gv
        na1VBTAwEcImWdZm1/CM8o5qwjzny9O/L/6wt56EHFGmn49hynzmOYRq8NHkEqsn0WiGhTQw8bI1v
        tKJKBhy2b8SPoE6Ret1+YKadrxL4naxMQdB8tnqfFgAEgl7H09ca3xypQjv4QpwF/CEkhAyUGrKOT
        eWqHjyl5WyeOsYlRsazSZmen4x+j19ZG55XGNp4GL/IEvjvRs+aZnAgfOiEz4JQ1IVo0qYOCZff4P
        Q23lFjdl5vOvrSkyYUjLmUxn;
Received: from [2a01:4f8:192:486::6:0] (port=61614 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kIbUb-0007RM-Af
        for cifs-qa@samba.org; Wed, 16 Sep 2020 17:45:17 +0000
Received: from [::1] (port=26756 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kIbUa-002T1c-K6
        for cifs-qa@samba.org; Wed, 16 Sep 2020 17:45:16 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14498] New: Why is mount -a is not detecting an already mounted
 DFS share endpoint
Date:   Wed, 16 Sep 2020 17:45:15 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: Chris@craftypenguins.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone
Message-ID: <bug-14498-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14498

            Bug ID: 14498
           Summary: Why is mount -a is not detecting an already mounted
                    DFS share endpoint
           Product: CifsVFS
           Version: 3.x
          Hardware: x64
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P5
         Component: user space tools
          Assignee: jlayton@samba.org
          Reporter: Chris@craftypenguins.net
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

I am trying to figure out why mount -a is not detecting an already mounted =
DFS
share endpoint. It works as expected on mount.cifs version 5.5 but not 6.7

Distributor ID: Debian
Description:    Debian GNU/Linux 9.13 (stretch)
Release:        9.13
Codename:       stretch

Mount.cifs version 6.7.=20

/etc/fstab=20
//ctserver6/ops_apps    /mnt/ops_apps cifs=20=20
defaults,credentials=3D/root/.smbcredentials,rw,users,_netdev,soft   0 0=20
//ctserverbc/Public     /mnt/ctserverbc cifs=20=20=20
defaults,credentials=3D/root/.smbcredentials,rw,users,_netdev,soft 0 0=20
#//ctserver3/ops         /mnt/ops cifs=20=20=20=20=20=20=20=20=20=20=20=20=
=20
defaults,credentials=3D/root/.smbcredentials,rw,users,_netdev,soft   0 0=20
#//ctserver3/public      /mnt/public cifs=20=20=20=20=20=20=20=20
defaults,credentials=3D/root/.smbcredentials,rw,users,_netdev,soft 0 0=20
//ctdomain.local/DFS_OPS/OPS       /mnt/ops cifs=20=20=20=20=20=20=20
vers=3D2.1,credentials=3D/root/.smbcredentials,rw,users,_netdev,soft   0 0=
=20
//ctdomain.local/DFS_OPS/Public    /mnt/public cifs=20=20=20
vers=3D2.1,credentials=3D/root/.smbcredentials,rw,users,_netdev,soft   0 0=
=20

If I leave off the vers=3D2.1 option it will create a new mount process and
duplicate in /proc/mounts :
/mnt/ops_apps            : already mounted
/mnt/ctserverbc          : already mounted
mount.cifs kernel mount options:
ip=3D192.168.111.10,unc=3D\\ctdomain.local\DFS_OPS,soft,user=3Dctlinux,pref=
ixpath=3DOPS,pass=3D********
/mnt/ops                 : successfully mounted
mount.cifs kernel mount options:
ip=3D192.168.111.20,unc=3D\\ctdomain.local\DFS_OPS,soft,user=3Dctlinux,pref=
ixpath=3DPublic,pass=3D********
/mnt/public              : successfully mounted

With vers=3D2.1 I get:

/mnt/ops_apps            : already mounted=20
/mnt/ctserverbc          : already mounted=20
mount.cifs kernel mount options:
ip=3D192.168.111.20,unc=3D\\ctdomain.local\DFS_OPS,vers=3D2.1,soft,user=3Dc=
tlinux,prefixpath=3DOPS,pass=3D********=20
mount error(16): Device or resource busy Refer to the mount.cifs(8) manual =
page
(e.g. man mount.cifs)=20
mount.cifs kernel mount options:
ip=3D192.168.111.20,unc=3D\\ctdomain.local\DFS_OPS,vers=3D2.1,soft,user=3Dc=
tlinux,prefixpath=3DPublic,pass=3D********=20
mount error(16): Device or resource busy Refer to the mount.cifs(8) manual =
page
(e.g. man mount.cifs)=20

On 5.5 it will detect the DFS share is mounted already

--=20


Chris Pickett |
Linux Systems Engineer

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
