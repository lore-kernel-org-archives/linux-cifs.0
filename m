Return-Path: <SRS0=/4jl=C2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB13C43461
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 09:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EC6020770
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 09:35:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=suse.com header.i=@suse.com header.b="PbZRxGYV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgIQJfP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Sep 2020 05:35:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:46204 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgIQJfP (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 17 Sep 2020 05:35:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=cantorsusede;
        t=1600335312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JW7Xg8kojk+EGh0LWBVlLzB7J5lWhbcSh0UysnREDqw=;
        b=PbZRxGYVyJyag/nFn54CNzsvrg6qpS8ezmbNdnRg1wKHJD2WRnpo9VY+vZop5FWVsaszVD
        ff5hYZff+aKZRSHmHGzxH21OvqOIu9izp0H8pvLE/izlqosSp7t4Y0BW/mjgZgZnzqIfFf
        Ax6QiGvDh6avjKAbaGkQJ2Nkc+C8Jwa2ZxeMKa58AiNyDkCbjPmBY3fu4ZV74jkOcHcAM/
        45/jEbbU9sfIDO86hf9CmMD4lVMUDLmpS35QiRV6QAHsB89NpTE06o2JnsAFrck9NYSxNB
        eiAzCpVd4MU2MLma6Kx1gCEmSW0DHHIvOntd05xJzQPWqVnaLCA2uAe2WU7MaA==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CEB87AC61;
        Thu, 17 Sep 2020 09:35:45 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: mutiuser request_key in both ntlmssp and krb5
In-Reply-To: <87tuvwlpto.fsf@suse.com>
References: <CANT5p=qTXPkjqBuR9cvwQoRZFb72gY4M22tMG5Q_1XC9vvKZcg@mail.gmail.com>
 <87tuvwlpto.fsf@suse.com>
Date:   Thu, 17 Sep 2020 11:35:11 +0200
Message-ID: <87r1r0lp9s.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aur=C3=A9lien Aptel <aaptel@suse.com> writes:
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>> 1. For ntlmssp, I see that the credentials are stored in the keyring
>> with IPv4 or IPv6 address as the key. Suppose the mount was initially
>> done using hostname, and IP address changes (more likely in Azure
>> scenario), we may end up looking for credentials with the wrong key.
>
> Yes I thought the same thing.. I'm not sure why the decision to use IP
> was made.

I suspect this code predates the existence of the in-kernel DNS
resolver. Just a guess.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
