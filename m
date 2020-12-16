Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13522C2BBCA
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 10:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDFF82313C
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 10:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgLPKI7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Dec 2020 05:08:59 -0500
Received: from smtppost.atos.net ([193.56.114.176]:19505 "EHLO
        smarthost1.atos.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726235AbgLPKI7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Dec 2020 05:08:59 -0500
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Dec 2020 05:08:57 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=atos.net; i=@atos.net; q=dns/txt; s=mail;
  t=1608113338; x=1639649338;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=asXNBOibR7wMbBcy3fG4A2AtkRemXxNb/fkCI9Q+U0c=;
  b=dv6Qe9yiKAe/FxosKLX5Hqb0yUMk/DrNdDXCh9jT4K7WPfjmthkUaEDy
   vpjNWxIh4B/LGlQaPvV8AMaFAwU+uLhVNxmOXYRXtycKGEFuI1WBII8pA
   OlUd7O5S0Zhxw7bPHaKKZzmJbCVyOP4Yijoau+VmJtvhSSN33k92W4Y6S
   M=;
IronPort-SDR: iiP4Ohx3fsFpWp/7hB0IDrV1sl5bqoDOWDYn+YoFSt6PHLXNd4/SAgXx+HqmJnfrubp8K1TSSv
 WTaPjHr8YFETpAWyjXOWjqhPY4daW+0XA35LXmltvXOrru7viqHKAZD/7XnBq4neNp7UEwP/yi
 IW+wPxADkTAflHv1wjFRiFc0kZYCkgwYDSWfblkRVEKmXTovD95XHpQU7RYjHpT7ikSpak+XzM
 Omtkeawwuc2fZBzETLVlM/uYYScvWfLy6btEwTjSfm6F3YbQEgRsQN9j5QKzhnnG2ZD1Z0Uv8M
 vLoZGlEyMmh+baItpLYVAemo
X-IronPort-AV: E=Sophos;i="5.78,424,1599516000"; 
   d="scan'208";a="182210739"
X-MGA-submission: =?us-ascii?q?MDElAbH8poHKPY0mhKeYHyM4yklhUJLqB9ELqf?=
 =?us-ascii?q?RqjS1UXk0XfHxQ3rGfvk7+tF90ln5icDNizqXGIUhqg98ja0wN18wXpI?=
 =?us-ascii?q?S3IRP3UXthulApQ9FPZG9eEpsY8b/sQlk2rJ8MPwLu8IRjhyJ9E8Quhv?=
 =?us-ascii?q?12?=
Received: from unknown (HELO GITEXCPRDMB11.ww931.my-it-solutions.net) ([10.89.28.141])
  by smarthost1.atos.net with ESMTP/TLS/AES256-GCM-SHA384; 16 Dec 2020 11:01:44 +0100
Received: from GITEXCPRDMB14.ww931.my-it-solutions.net (10.89.28.144) by
 GITEXCPRDMB11.ww931.my-it-solutions.net (10.89.28.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Wed, 16 Dec 2020 11:01:43 +0100
Received: from GITEXCPRDMB14.ww931.my-it-solutions.net ([10.89.28.144]) by
 GITEXCPRDMB14.ww931.my-it-solutions.net ([10.89.28.144]) with mapi id
 15.01.2044.004; Wed, 16 Dec 2020 11:01:43 +0100
From:   "Weiser, Michael" <michael.weiser@atos.net>
To:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
CC:     "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "gss-proxy@lists.fedorahosted.org" <gss-proxy@lists.fedorahosted.org>
Subject: cifs-utils, Linux cifs kernel client and gssproxy
Thread-Topic: cifs-utils, Linux cifs kernel client and gssproxy
Thread-Index: AQHW0tgPe397r8v2v0y1SGaypM9pOQ==
Date:   Wed, 16 Dec 2020 10:01:43 +0000
Message-ID: <2e241ceaece6485289b1cddb84ec77ca@atos.net>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [160.92.209.239]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello,

I have a use-case for authentication of Linux cifs client mounts without th=
e user being present (e.g. from batch jobs) using gssproxy's impersonation =
feature with Kerberos Constrained Delegation similar to how it can be done =
for NFS[1].

My understanding is that currently neither the Linux cifs kernel client nor=
 cifs-utils userland tools support acquiring credentials using gssproxy. Th=
e former uses a custom upcall interface to talk to cifs.spnego from cifs-ut=
ils. The latter then goes looking for Kerberos ticket caches using libkrb5 =
functions, not GSSAPI, which prevents gssproxy from interacting with it.[2]

From what I understand, the preferred method would be to switch the Linux k=
ernel client upcall to the RPC protocol defined by gssproxy[3] (as has been=
 done for the Linux kernel NFS server already replacing rpc.svcgssd[4]). Th=
e kernel could then, at least optionally, talk to gssproxy directly to try =
and obtain credentials.

Failing that, cifs-utils' cifs.spnego could be switched to GSSAPI so that g=
ssproxy's interposer plugin could intercept GSSAPI calls and provide them w=
ith the required credentials (similar to the NFS client rpc.gssd[5]).

Assuming my understanding is correct so far:

Is anyone doing any work on this and could use some help (testing, coding)?
What would be expected complexity and possible roadblocks when trying to ma=
ke a start at implementing this?
Or is the idea moot due to some constraint or recent development I'm not aw=
are of?

I have found a recent discussion of the topic on linux-cifs[6] which provid=
ed no definite answer though.

As a crude attempt at an explicit userspace workaround I tried but failed t=
o trick smbclient into initialising a ticket cache using gssproxy for cifs.=
spnego to find later on.
Is this something that could be implemented without too much redundant effo=
rt (or should already work, perhaps using a different tool)?

[1] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#user-impersona=
tion-via-constrained-delegation
[2] https://pagure.io/gssproxy/issue/56
[3] https://github.com/gssapi/gssproxy/blob/main/docs/ProtocolDocumentation=
.md
[4] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#nfs-server
[5] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#nfs-client
[6] https://www.spinics.net/lists/linux-cifs/msg20182.html
--=20
Thanks,
Michael
