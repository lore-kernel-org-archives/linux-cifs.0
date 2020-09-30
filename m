Return-Path: <SRS0=H1OG=DH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF4DC4727E
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Sep 2020 15:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FC2C206F7
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Sep 2020 15:58:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O8mgV3OJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbgI3P6E (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Sep 2020 11:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730858AbgI3P54 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Sep 2020 11:57:56 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5469AC061755
        for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2020 08:57:55 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 67so1656331ybt.6
        for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2020 08:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QRYbhq4WJ1cXhPiCR9E4mjM6g3lUrGRalJgt95r3sIQ=;
        b=O8mgV3OJm9P35A7L4rojU/NzAlIgqKBVWo0y0jYO/eAKp2L+G9GKQ7SrDepWIN95Ck
         IuX7mpTqVwnAULCom4FgI+4v0QRDHsMN7iJp3Exm5IdDarLxa1WNmOpsVTpyc7ATcr2G
         WQ6zwGSGJo94yLCfMXyIlm0PxlnZWtMRVCAj7uWEJDiZclbVl3KH/CZqqEXbqH72f0pB
         KHeHhDhEgBxYKUfbIsXzF4/OC0OStQaPkcf6PMpxlxO0TXK6I9s49jPaPk3Mk8UDXRWt
         kY/dA0w/vUh9bP2sTLaJp2pWS0aMnEoLPP5khc7bTL7TzSeq32MyhrfLzjiET+0p+Tig
         9ZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QRYbhq4WJ1cXhPiCR9E4mjM6g3lUrGRalJgt95r3sIQ=;
        b=QQ3cZLPWIVBOWE6ILXozIqv0OoMIPvcIrxiZJnSokwG+GszwNLIjJ4LF7CgK/IkOIL
         tHftDYcvqGq238AWVY4oFOozGNMisrRkPi+hX2tRyMf826XQAYKZ5ophzVg8K/8iPT8+
         jBOMBPPOILYzQHeahr6GAPMKzCAU2RYE4Yu6abgmkQ+gdVSIK57Pq3UIPv/fB8e8qVtQ
         ZUrYoTiU0fxvLdIrwax+70KZparKexbIPEtpsvSkwcCsFFV4dGHU5XzOqHgmAMFnqdu9
         e5sVeiZP9PvRoxc2Aa/Vw4TYP9IIa5TJeFw2LUOTYXFKUrM7dgqg7Lr3UkCdc93NlY7u
         gCYw==
X-Gm-Message-State: AOAM533Wu41SFETk5pkTOcS8fV9f6SAVDANr9RsqqSYBB3ouayJ++EGY
        8F9ry6TLI7HJwpsUmXqenK5fgCgGJFsilaJnoX/7aTXwjFuPoVPm
X-Google-Smtp-Source: ABdhPJxCy4bT4VupmikucrEWIs12HrHCBipsdKrTk2yeGQep4Wq14JGfu/r9+SsFrbSx9W691lfQ6ftrLCAg/pXLnzc=
X-Received: by 2002:a25:6193:: with SMTP id v141mr4300843ybb.34.1601481474534;
 Wed, 30 Sep 2020 08:57:54 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=ojR_Aac4bWSBqb3_FmzzjA6sHQBdN5z4o6c4nFDKmNDQ@mail.gmail.com>
 <87blhok9jd.fsf@suse.com> <CAH2r5murtQh0Mvp53bc_DRh7AwuMNPq=dqPq=gh3ESsQ0Lkwsg@mail.gmail.com>
 <CANT5p=q=8MLgWogmUiGUCRX53qNOsg_tRyXP_YMDjfrfai7awQ@mail.gmail.com>
In-Reply-To: <CANT5p=q=8MLgWogmUiGUCRX53qNOsg_tRyXP_YMDjfrfai7awQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 30 Sep 2020 21:27:44 +0530
Message-ID: <CANT5p=rWSgB77Q-L_8YMUqzaVWsCLbguq7z4moN63cNKqgdHiA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Return the appropriate error in cifs_sb_tlink
 instead of a generic error.
To:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ok. Checked the test. It does a multiuser mount of a file share. (I'm
assuming this is using sec=3Dntlmssp)
Then does an "ls" on the mount point as another user. Expects EACCES
as the output.
With this change, the command returns an ENOKEY.
With the credentials added to keyring using cifscreds, the ls command works=
.

Now the question is: Is the right error to return here EACCES or
ENOKEY? Even if the expected error here should be EACCES, I'd say that
the error returned by cifs_set_cifscreds should return that error.

Regards,
Shyam

On Wed, Sep 30, 2020 at 8:48 PM Shyam Prasad N <nspmangalore@gmail.com> wro=
te:
>
> It looks like xfstests smb3 multiuser cifsutils-101 and cifs-101 are fail=
ing.
> Maybe they were written keeping in mind the current error code
> returned by cifs.ko in this situation? Let me take a look.
> I guess @ronnie sahlberg will be able to debug the failing tests
> faster. The failing test has his name in the code. :)
>
> On Tue, Sep 29, 2020 at 11:16 PM Steve French <smfrench@gmail.com> wrote:
> >
> > tentatively merged ... running the usual functional tests
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2=
/builds/399
> >
> > On Tue, Sep 29, 2020 at 8:16 AM Aur=C3=A9lien Aptel <aaptel@suse.com> w=
rote:
> > >
> > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > > One of the cases where this behaviour is confusing is where a
> > > > new tcon needs to be constructed, but it fails due to
> > > > expired keys. cifs_construct_tcon then returns ENOKEY,
> > > > but we end up returning a EACCES to the user.
> > > >
> > > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > >
> > > LGTM
> > >
> > > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> > >
> > > Cheers,
> > > --
> > > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnb=
erg, DE
> > > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> -Shyam



--=20
-Shyam
