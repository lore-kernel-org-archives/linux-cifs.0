Return-Path: <SRS0=KBsq=VB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E805C0650E
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Jul 2019 22:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9D772189E
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Jul 2019 22:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfGDWDm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Jul 2019 18:03:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:52454 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726038AbfGDWDm (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 4 Jul 2019 18:03:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6E42DAE2F;
        Thu,  4 Jul 2019 22:03:41 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [SMB3][PATCH] add mount option to allow retrieving POSIX mode from special ACE
In-Reply-To: <CAH2r5muoKPQAkSmvjerOb9UCtvBLjdaEjQQ5jfOO=sJnes=C3A@mail.gmail.com>
References: <CAH2r5mvN2LQG_eWhfes3_tpBwhmg-Q=+L7U+=xFHb4W01_wVJg@mail.gmail.com> <CAKywueR8h1ipuWQYZAph729O9f05tUEC2+kzf9RwKTyWgqtV_Q@mail.gmail.com> <CAH2r5muoKPQAkSmvjerOb9UCtvBLjdaEjQQ5jfOO=sJnes=C3A@mail.gmail.com>
Date:   Fri, 05 Jul 2019 00:03:38 +0200
Message-ID: <87tvc1wj7p.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> Where I would like to get to is that we focus strongly on only the
> first two common use cases:
> 1) "client focused perm checks"   -  get/set mode from special SID
> (server permission checks are not important in this case)
> 2) "server focused perm checks" - get/set the three ACEs
> (user-owner/group-owner/EVERYONE) in the ACL

The 2) part is not really documented and is more complex than it
seems. We know how the SID are created but not the actual ACL/ACE for
each SID. I've almost completely reversed engineered it (except for the
one bit).

I've documented all here: https://github.com/aaptel/nfs-acl-test

The is one permission -- the S (SYNCHRONIZE) flag -- which doesn't seem
to be consistent in how it is granted/denied. But its purpose is not
clear on files/dir so it's probably irrelevant: we just need to
reimplement the unix_to_acl() func that I wrote.

I've contacted dochelp regarding this, and here is what they have to
say (note "UUUA" is Unmapped UNIX User Access):

>  I have been combing the source and could not find where a mapping is done yet for the mode
>  you are asking about.
>
> ...
>
>  After conferring with our NFS experts, the key perspective that I’d like to share is that
>  we do document (outside of the protocol documents) that UUUA is intended for an end-to-end
>  NFS-only access.
>  The UUUA mode is intended for use when the Windows NFS Server is the only accessor to the
>  files. We make no statements as to the behavior of any other accessor or how they
>  can/should decode the DACL. 
>  We do not expect a client to ever come across the NFS specific DACL in a well configured
>  system. 
>  With that perspective, we had some archived content which describes some “Mapping of NFS
>  Mode Bits to Windows ACL”. To understand part of what Windows does under the hood, you
>  many find useful to consult the obsoleted [MS-FSSO] which is under Windows Protocols
>  Archive Documents. Keep in mind that archived documents are for “convenience” only. We do
>  not answer questions or service those types of documents. 
>  [MS-FSSO]: File Access Services System Overview
>  https://winprotocoldoc.blob.core.windows.net/productionwindowsarchives/WinArchive/%5bMS-FSSO%5d.pdf

Cheers,

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 21284 (AG Nürnberg)
