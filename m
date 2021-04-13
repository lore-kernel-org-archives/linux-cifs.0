Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D8EBC433B4
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Apr 2021 00:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DFD3613AF
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Apr 2021 00:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344296AbhDMAK4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Apr 2021 20:10:56 -0400
Received: from mail-ej1-f46.google.com ([209.85.218.46]:33711 "EHLO
        mail-ej1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344287AbhDMAKz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 12 Apr 2021 20:10:55 -0400
Received: by mail-ej1-f46.google.com with SMTP id g5so16395457ejx.0
        for <linux-cifs@vger.kernel.org>; Mon, 12 Apr 2021 17:10:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=q8zLFPx1aQMVOfdtZ5kgBVw6QCXBH3THleOQVoOLnp8=;
        b=LDdqYBzf/xf8gHk4MG/g6IEbzMrKSZaeOmpBoX6wJ1sjht/RLHpfdw4xzZYgvRwOmT
         EPtKLrifenSLrAoOlSKjD5AKKBLw0argyvCv0uikhtIhqhfpp2tlYBIHpZejGnsZUkOX
         cAcDWPxlbtnWT5Gke9/3PySD2pOCtzZzIprnIRprSaUHwoKjF70gx1/6Wmoxpfky3lX7
         lzEs7443+BpyxeV+sJN2WX541HpRHON2jOM/Abe9ToPYW2jPhMTG39+LwKFALjMtHou/
         i5tVMGX3LObPLxXKA/+HLgeBy3dQHuvJteWFtN0cOSysf4lMAXvVNXZsFP6dtloolHF0
         fi3A==
X-Gm-Message-State: AOAM531fsQbPnms+dapS2Y1Odj5q1PaXtyb/rERle3dQj05uDJq9hBBQ
        DCvDzUkc7w1a0BlrhCP14HQkSZNaTutpMmDLJCjfdDdRmg==
X-Google-Smtp-Source: ABdhPJxHftmE0W4PX+n0s+uwb2KoVlSYE1nmlFWCS+s31Yf+arlwLnhWoTJWD7di4CrOOLmhOL/A3U79XPIWGw1BHss=
X-Received: by 2002:a17:906:cc46:: with SMTP id mm6mr3729341ejb.138.1618272634015;
 Mon, 12 Apr 2021 17:10:34 -0700 (PDT)
MIME-Version: 1.0
From:   Pavel Shilovsky <pshilovsky@samba.org>
Date:   Mon, 12 Apr 2021 17:10:22 -0700
Message-ID: <CAKywueSqRGSFmeDHQacyu831BNUeGFxGg3vgBmozzhkGBCjyXQ@mail.gmail.com>
Subject: [ANNOUNCE] cifs-utils release 6.13 ready for download
To:     linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        samba@lists.samba.org,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Boris Protopopov <pboris@amazon.com>,
        Steve French <stfrench@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Pavel Shilovskiy <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

New version 6.13 of cifs-utils has been released today. This is a
security release to address the following bug:

CVE-2021-20208 cifs.upcall kerberos auth leak in container

For more details, refer to the description below.

===========================================================
== Subject:     Container calls to cifs.upcall access host environment
==
== CVE ID#:     CVE-2021-20208
==
== Versions:    cifs-utils 4.0 and above
==
==
== Summary:     When a container process causes an operation that trigger
==              the kernel to ask a userspace for user credentials for
==              an SMB filesystem, cifs.upcall utility may indirectly
==              leak an information about Kerberos credentials available
==              in the host environment and cause non-sanctioned SMB
==              filesystem access in the container.
===========================================================

===========
Description
===========

A bug has been reported recently for the cifs.upcall utility which is
part of the cifs-utils package.

In scenarios where a program running inside a container issues a
syscall that triggers the kernel to upcall cifs.upcall, such as when
users access a multiuser cifs mount or when users access a DFS link,
cifs.upcall is executed in the host environment where its execution
may indirectly leak an information about resources available only to
host applications, such as Kerberos credential caches, to a
containerized application. As a result, a containerized application may
trigger access to files on an SMB share under an identity otherwise not
intended to be accessed by this container's environment.

The bug is a consequence of the kernel calling the host cifs.upcall
binary and can traced back to the introduction of the cifs.upcall
mechanism in cifs-utils and the introduction of containers in the
kernel.

With this release, cifs.upcall joins a caller's process namespaces
before accessing any resources to perform Kerberos authentication.
As a result, access to SMB shares is limited to credentials already
available inside the containerized environment.

==================
Patch Availability
==================

A patch is available as an attachment on the bug report.

https://bugzilla.samba.org/show_bug.cgi?id=14651

==================
CVSSv3 calculation
==================

AV:L/AC:H/PR:L/UI:R/S:C/C:L/I:H/A:N/E:F/RL:O/RC:C/MAV:L/MAC:H/MPR:L/MUI:N/MS:C/MC:L/MI:H/MA:N

Base score of 6.1 - medium.

=========================
Workaround and mitigation
=========================

For host systems that cannot be updated, DFS and multiuser mounts can
be disabled in the container SMB mounts options i.e. adding 'nodfs'
and removing 'multiuser' (if present).

=======
Credits
=======

Originally reported by Alastair Houghton.

Patch and workaround provided by Alastair Houghton and Aurelien Aptel.

==========================================================
== Our Code, Our Bugs, Our Responsibility.
== The Samba Team
==========================================================
