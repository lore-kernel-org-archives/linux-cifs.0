Return-Path: <SRS0=/4jl=C2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11313C433E2
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 09:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9E85206E6
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 09:23:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=suse.com header.i=@suse.com header.b="Krr0wTtP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgIQJXV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Sep 2020 05:23:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:39548 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgIQJXV (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 17 Sep 2020 05:23:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=cantorsusede;
        t=1600334596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Aaq8YljVjV4BZmLtaxaIvIKTPTsjMpl7AYQOiu4G8mM=;
        b=Krr0wTtPyVAlTI5H6QnSGnRR5tw0rd0iHSJbBi7ZSZsTlmVBK6H7q2t12s7PkYCIVrcLsc
        440P71P6PISYD2i2bHp2uw7zLNo55c6d8p+v9OZziY2H2qpSgANseMK6gQHi8fwP+nfC19
        iPJNTFED6cX+JBpfcYDgaB504pP2eDHlZgnC85WevlLo65OV5zeXuiJN56XMXwUdyrjOnM
        IDLe75n5ijLrt+O7SmaNNvNppqHRClCg+43+n3ieujvZ/kkO9Cwxrg08agjABCIGGgfig4
        3f5ZEF0UUAfmWgVCesh9RKjGdpqEgw2ecDRVDT5jRosiZeHEF4/xv7jkMaWmZQ==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1ECFCAFB2;
        Thu, 17 Sep 2020 09:23:50 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: mutiuser request_key in both ntlmssp and krb5
In-Reply-To: <CANT5p=qTXPkjqBuR9cvwQoRZFb72gY4M22tMG5Q_1XC9vvKZcg@mail.gmail.com>
References: <CANT5p=qTXPkjqBuR9cvwQoRZFb72gY4M22tMG5Q_1XC9vvKZcg@mail.gmail.com>
Date:   Thu, 17 Sep 2020 11:23:15 +0200
Message-ID: <87tuvwlpto.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:
> 1. For ntlmssp, I see that the credentials are stored in the keyring
> with IPv4 or IPv6 address as the key. Suppose the mount was initially
> done using hostname, and IP address changes (more likely in Azure
> scenario), we may end up looking for credentials with the wrong key.

Yes I thought the same thing.. I'm not sure why the decision to use IP
was made.

> 2. For ntlmssp, if I add another user credentials to the keyring using
> cifscreds, doesn=E2=80=99t that overwrite the prev user=E2=80=99s credent=
ials? Or is
> there a way to store multiple credentials for the same server?

IIRC the keyring used is the session one, so each user gets a different key=
ring.

> 3. For krb5, and multiuser mount, how should cifs.ko get the username
> for a user? Currently, I don=E2=80=99t think we read the username from
> anywhere.

Remember that all code running in cifs.ko is always in the context of a
process (or a kthread which is also using struct task). It's the process
who does some syscall that calls cifs.ko. So within the kernel code you
can always access the calling process task via the 'current' pointer.

We use current_fsuid() to get the current uid.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
