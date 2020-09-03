Return-Path: <SRS0=e7mR=CM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0477C433E2
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Sep 2020 17:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8D6E20716
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Sep 2020 17:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgICR3q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Sep 2020 13:29:46 -0400
Received: from mail-ej1-f47.google.com ([209.85.218.47]:39046 "EHLO
        mail-ej1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgICR3o (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Sep 2020 13:29:44 -0400
Received: by mail-ej1-f47.google.com with SMTP id p9so4964470ejf.6
        for <linux-cifs@vger.kernel.org>; Thu, 03 Sep 2020 10:29:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=v1XhI1LSAM2uv1/MyByn6atDg2jfT9gssL5nzm1/cs0=;
        b=q+qwQZmp1BAC9V58Qt+c7E5+9lPgH08gkrVA8DdT6gvgbmYdwLrVWrWENyWG5rtB8R
         clXChZqJm2SQglYy9rePWFIGoJhQ20G7alnM+W0+3JK6bSXA2VT5PsSZBI8pGfKiW1Pl
         5GuXSzxkAwAZPPEz3fpQEkdLowy15t3MGQ656TH3RQk62hIiU7c5WkP0w1meweo2NOrj
         WfjWnVPWa246hKEXpUI/JMouxAl/Ji43XQ05v9YCGSgwU8RWwWlHcnd8gMjXjsg0xJ1B
         mcQpVVPKqyx/CsRI55h1eAp7niodCOaTdBFyixbBY/4OIdFdsW5K0xJIJb10XgSttiPp
         J9JQ==
X-Gm-Message-State: AOAM533VxUAsFm1izGgyABPZgydUMQLXNH9HkJSqbV/W7tHTAg+qxUht
        Bnw6G+e/bKJQALqgZKPaCT/CtupD5hhkdL29+nODAPyp2A==
X-Google-Smtp-Source: ABdhPJxrDf+8JSyUd0UYfIVPxrqVSLtHov2JPOMZW+TJF/DE9Lc7FmjJfrcVRW/wbELJpI5i00PAVVdWt+5JLZhdX4E=
X-Received: by 2002:a17:906:4a8c:: with SMTP id x12mr3324165eju.271.1599154180681;
 Thu, 03 Sep 2020 10:29:40 -0700 (PDT)
MIME-Version: 1.0
From:   Pavel Shilovsky <pshilovsky@samba.org>
Date:   Thu, 3 Sep 2020 10:29:29 -0700
Message-ID: <CAKywueR5QBgAYWHpn-AJMO8jmVpBqPLfgY5BOhB7-_8sRxLdVw@mail.gmail.com>
Subject: cifs-utils release 6.11 ready for download
To:     linux-cifs <linux-cifs@vger.kernel.org>, samba@lists.samba.org,
        samba-technical <samba-technical@lists.samba.org>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

New version 6.11 of cifs-utils has been released today. This is a
security release to address the following bug:

CVE-2020-14342: mount.cifs: fix shell command injection

For more details, refer to the description below.

===========================================================
== Subject:     Shell command injection in mount.cifs
==
== CVE ID#:     CVE-2020-14342
==
== Versions:    cifs-utils 5.6 and later
==
== Summary:     A user controlling the username mount option can embed
==              shell commands that will be run in the context of
==              the calling user.
===========================================================

===========
Description
===========

A bug has been reported recently for the mount.cifs utility which is
part of the cifs-utils package. The tool has a shell injection issue
where one can embed shell commands via the username mount option. Those
commands will be run via popen() in the context of the user calling
mount.

The bug requires cifs-utils to be built with --with-systemd (enabled
by default if supported).

A quick test to check if the mount.cifs binary is vulnerable is to look
for popen() calls like so:

    $ nm mount.cifs | grep popen
    U popen@@GLIBC_2.2.5

If the user is allowed to run mount.cifs via sudo, he can obtain a root
shell.

    sudo mount.cifs -o username='`sh`' //1 /mnt

If mount.cifs has the setuid bit, the command will still be run as the
calling user (no privilege escalation).

The bug was introduced in June 2012 with commit 4e264031d0da7d3f2
("mount.cifs: Use systemd's mechanism for getting password, if
present.").

Affected versions:
  cifs-utils-5.6
  cifs-utils-5.7
  cifs-utils-5.8
  cifs-utils-5.9
  cifs-utils-6.0
  cifs-utils-6.1
  cifs-utils-6.2
  cifs-utils-6.3
  cifs-utils-6.4
  cifs-utils-6.5
  cifs-utils-6.6
  cifs-utils-6.7
  cifs-utils-6.8
  cifs-utils-6.9
  cifs-utils-6.10

==================
Patch Availability
==================

A patch is available as an attachment on the bug report. It can be
applied from v6.10 down to v6.2 included.
A backported patch is also available for v6.1 and under.

https://bugzilla.samba.org/show_bug.cgi?id=14442

==================
CVSSv3 calculation
==================

CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:L/I:L/A:N (4.4)

=========================
Workaround and mitigation
=========================

For systems that cannot be updated a wrapper executable around
mount.cifs can be installed. This wrapper simply calls the original
mount.cifs on correct input and exits on injection attempts.

Once the wrapper is installed and owned by root it can have the
setuid bit if necessary and the original mount.cifs binary can
have the setuid and execution bits for group and other cleared.

You can find more information along with a Golang implementation
of this wrapper on the bug report attachments.

https://bugzilla.samba.org/show_bug.cgi?id=14442

=======
Credits
=======

Originally reported by Vadim Lebedev.

Patch and workaround provided by Paulo Alcantara and Aurelien Aptel.

==========================================================
== Our Code, Our Bugs, Our Responsibility.
== The Samba Team
==========================================================
