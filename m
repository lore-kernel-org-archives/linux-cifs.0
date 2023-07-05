Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AAF5EB64DD
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Jul 2023 13:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjGEN2L (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Jul 2023 09:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjGEN2K (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Jul 2023 09:28:10 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541371719
        for <linux-cifs@vger.kernel.org>; Wed,  5 Jul 2023 06:28:08 -0700 (PDT)
Message-ID: <ac5fa242eb1cb2bac8fc12f90102a574.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1688563686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yJHKjLWEk3cBrHyVAteEjSwJgKski+pOj3uXy1xxuIQ=;
        b=d/jDCGtyPwAhp75xeOHn27IkqJoJWoXZYPigyij5RAiiyNYb93icn1otnYD94Ku/wo4KUK
        TY33F+40MbQ+87YokrRUpFy1vFbK17ZTZ5k+2QqEDEk4uzT1BIV9OkSopJVmNkUmcn4zKz
        gVAa15JLFngJyKIJdTtleRYPJ0CwrxNmw9kjs8KP8BZnZejs2rrNa/OeYgk4/3/6iMul67
        7YSTI4fwCbcJesfnKXvRxJDRi2yaE1wXenL2WufJyhGEfbCoadQzMUljdnjBpt3xnAm5sJ
        0COWotpfcTbj3D348quAZcLGIOaQTtfeACWCuegeVniFeVtawxBlC6SEa+aRWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1688563686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yJHKjLWEk3cBrHyVAteEjSwJgKski+pOj3uXy1xxuIQ=;
        b=guQa1UHcvufR48r8ZbNBIRyrkv9ZeFbIRdN2p2iRf+6vaqVqg4zAj6FzgPiM2/4hNxd1L2
        VrUz3y/YN7new1RKgRuX00BI+zKA1F96eCE/offbvgOWAq4lx2H1iKS5d15nNrrcBzuy42
        g2hfsxRU/Snj/oM+Nisb/Y0giC3adwMEtHJYE/ZkCX/u06cYjjC5yYC85IfYnuHVI8b/TH
        Q3njjhKfjI8rLfVZ54x4lDyW6ZamdmEELkOeAYGrb7b7+4Xof/6Hk7sTnIRiDaOm7X1VQq
        XW4ahYoXKw+Su7UtENwpFmsgoXFAgeM/x/OwaYG9gnFXZ5rdxpTpuGdiQpbBYA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1688563686; a=rsa-sha256;
        cv=none;
        b=pvcf0krPkz90ztDAbZk0CWwxg12SM9uB75uEU4EQ/HzyDsgsSNfEmnQTPmpFBetG9UVM6R
        ZUd6rmZ51agbDirx5gq2TyE4FL2t8wfEO6DQGYoawF6sw6noa9SBGVsTa0ifWWCqFKKY5s
        ZZOzCTJrI5Y97Q9qDOA3TjzxJEw9Uga5Vc2dN6e+nGCJDZX/IRKtweJX8p3V66YuRy6234
        vntk/Pef2YrOKuuZ2du9c9NOzl8xY0uNK5WV02IG930I4u2BAszQ5rGVhOLliXZbi29cnm
        vO0SJ8o/RmgHmnE/wRzDE4kel+8vkZlJI0DB0z185KRXTttDzu5UEIT8v3o7mQ==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Bharath SM <bharathsm.hsk@gmail.com>
Cc:     sfrench@samba.org, lsahlber@redhat.com, sprasad@microsoft.com,
        tom@talpey.com, linux-cifs@vger.kernel.org,
        bharathsm@microsoft.com, nspmangalore@gmail.com
Subject: Re: [PATCH] smb: add missing create options for O_DIRECT and O_SYNC
 flags
In-Reply-To: <CAGypqWzoo83xy0wbGUO6NX_24pFEM=tpS=e2_iuxvCdRk4e9mA@mail.gmail.com>
References: <20230703120709.3610-1-bharathsm@microsoft.com>
 <223dd925bd50acd04bfb25fa18cf276e.pc@manguebit.com>
 <CAGypqWzoo83xy0wbGUO6NX_24pFEM=tpS=e2_iuxvCdRk4e9mA@mail.gmail.com>
Date:   Wed, 05 Jul 2023 10:28:00 -0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Bharath SM <bharathsm.hsk@gmail.com> writes:

> On Mon, Jul 3, 2023 at 9:33=E2=80=AFPM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>>
>> Bharath SM <bharathsm.hsk@gmail.com> writes:
>>
>> > The CREATE_NO_BUFFER and CREATE_WRITE_THROUGH file create options
>> > are correctly set in cifs_nt_open and cifs_reopen functions based
>> > on O_DIRECT and O_SYNC flags. However flags are missing during the
>> > file creation process in cifs_atomic_open, this was leading to
>> > successful write operations with O_DIRECT even in case on un-aligned
>> > size. Fixed by setting create options based on open file flags.
>> >
>> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
>> > ---
>> >  fs/smb/client/dir.c | 6 ++++++
>> >  1 file changed, 6 insertions(+)
>> >
>> > diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
>> > index 30b1e1bfd204..4178a7fb2ac2 100644
>> > --- a/fs/smb/client/dir.c
>> > +++ b/fs/smb/client/dir.c
>> > @@ -292,6 +292,12 @@ static int cifs_do_create(struct inode *inode, st=
ruct dentry *direntry, unsigned
>> >        * ACLs
>> >        */
>> >
>> > +     if (oflags & O_SYNC)
>> > +             create_options |=3D CREATE_WRITE_THROUGH;
>> > +
>> > +     if (oflags & O_DIRECT)
>> > +             create_options |=3D CREATE_NO_BUFFER;
>> > +
>>
>> Looks good, thanks.
>>
>> I see that cifs_nt_open(), cifs_reopen_file() and cifs_do_create() use
>> cifs_create_options().
>>
>> I'd rather have those flags set in cifs_create_options() by passing a
>> new @flags to it, so if we need to make any changes later, only
>> cifs_create_options() will require it.  What do you think?
>
> I see there are around 34 places where we call cifs_create_options()
> and currently it's taking cifs_sb,create options as arguments. Should
> we make another helper function with name
> "create_options=3Dcifs_parse_flags(flags)" then pass create_options into
> cifs_create_options() ?
> I think we can do this cleanup as the next patch. What do you think.?

Sounds good.  Thanks.
