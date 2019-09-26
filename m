Return-Path: <SRS0=5yhP=XV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C2A7C47E48
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Sep 2019 10:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D839E217F4
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Sep 2019 10:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfIZKxV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Sep 2019 06:53:21 -0400
Received: from rigel.uberspace.de ([95.143.172.238]:54948 "EHLO
        rigel.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbfIZKxG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Sep 2019 06:53:06 -0400
Received: (qmail 5116 invoked from network); 26 Sep 2019 10:53:04 -0000
Received: from localhost (HELO webmail.rigel.uberspace.de) (127.0.0.1)
  by ::1 with SMTP; 26 Sep 2019 10:53:04 -0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 26 Sep 2019 12:53:03 +0200
From:   Moritz M <mailinglist@moritzmueller.ee>
To:     linux-cifs@vger.kernel.org
Subject: Re: Possible timeout problem when opening a file twice on a SMB mount
In-Reply-To: <CAKywueQ7g9VYe=d7WU4AzL2Hv+pPznUgQBD7-RVi0ygBkhtGRw@mail.gmail.com>
References: <61d3d6774247fe6159456b249dbc3c63@moritzmueller.ee>
 <CAKywueT=hWCTM=Crsafrj-8P=1mD93DY73oK=Ub8JeWc5X85fQ@mail.gmail.com>
 <4a017b583eb0f5fab477ecbe0e43b3a1@moritzmueller.ee>
 <CAN05THR5FE80VsnbKfpBzvt+g5jPu3rtiOqWkzU5yKoKUkhkiA@mail.gmail.com>
 <CAKywueTOjoP-Jh7WWCi5XJhfzgK+KZs3kvHKuVG_HW0fnYYY7A@mail.gmail.com>
 <CAKywueQUuwRK7hbbJhdquVVPre2+8GBCvnrG76L-KodoMm9m6g@mail.gmail.com>
 <b7b7a790feac88d59fe00c9ca2f5960d@moritzmueller.ee>
 <CAKywueQ7g9VYe=d7WU4AzL2Hv+pPznUgQBD7-RVi0ygBkhtGRw@mail.gmail.com>
Message-ID: <bdf21b8770373c9ea4c37c27a12344d8@moritzmueller.ee>
X-Sender: mailinglist@moritzmueller.ee
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Please update the thread once you verify the patch with the other
> software you mentioned.

It works as expected. Issue is gone. Thanks a lot.

> If it works fine, I will prepare a formal
> patch for the mainline and active stable kernels.

As I'm not familiar with the kernel development cycle: how long will
it usually take for a patch to be included in the kernel?

Which are the active stable kernels?

Best Regards
Moritz

> ср, 25 сент. 2019 г. в 12:23, Moritz M <mailinglist@moritzmueller.ee>:
>> 
>> 
>> Thanks Pavel.
>> After messing around with the Kernel build procedure on my distro and
>> adapting the patch slightly (filenumbers did not match) I got a 
>> working
>> cifs module. And it solved the issue at least for the python test.
>> 
>> I'll check tomorrow the other software where it occured.
>> 
>> >>
>> > Could you try the following patch in your setup to see if it fixes the
>> > problem?
>> >
>> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>> > index 047066493832..00d2ac80cd6e 100644
>> > --- a/fs/cifs/smb2ops.c
>> > +++ b/fs/cifs/smb2ops.c
>> > @@ -3314,6 +3314,11 @@ smb21_set_oplock_level(struct cifsInodeInfo
>> > *cinode, __u32 oplock,
>> >         if (oplock == SMB2_OPLOCK_LEVEL_NOCHANGE)
>> >                 return;
>> >
>> > +       /* Check if the server granted an oplock rather than a lease */
>> > +       if (oplock & SMB2_OPLOCK_LEVEL_EXCLUSIVE)
>> > +               return smb2_set_oplock_level(cinode, oplock, epoch,
>> > +                                            purge_cache);
>> > +
>> >         if (oplock & SMB2_LEASE_READ_CACHING_HE) {
>> >                 new_oplock |= CIFS_CACHE_READ_FLG;
>> >                 strcat(message, "R");
>> >
>> >
>> > --
>> > Best regards,
>> > Pavel Shilovsky
