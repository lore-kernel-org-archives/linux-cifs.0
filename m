Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC91AC4332F
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Nov 2022 13:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiKGNbh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Nov 2022 08:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbiKGNbg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Nov 2022 08:31:36 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43CA1CFC6
        for <linux-cifs@vger.kernel.org>; Mon,  7 Nov 2022 05:31:34 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id sc25so30018365ejc.12
        for <linux-cifs@vger.kernel.org>; Mon, 07 Nov 2022 05:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=D8SWZqFCOUKzLi8+ZQ0qCoIDCiuOKVlNWqM0PpWG3h8=;
        b=ovVLPCEOCglehUmGcJrr8NbCmHuLM2HwzEN2pXAWbQOrIMtgNl5gNgAjLp1Cb/EgmG
         3DBhwsqKi2BCxuCazSEhqXxNG2XUAuaLslq9cnwHcE8oyaekN5dllfx5w+MshJyx0pr4
         c/1Z/uPQ7/krEoM7C/JvKKvs2x5j7DCMUAnwUEnQ3H7fyhNfJ6LIaROriISQk8ieRZBZ
         DSzQURGrk2MknD906PkmUwIL/ngtkvTs7fCj6mqOSeJ+LqyUvrxxc6iXrXkct3yAIZua
         aSNlVtYIrxmpqCLWfZKHvKjE3JYN6kSJeqjk1Bvlm72WLakxP5IAOmD2f60Z8ee6hDvJ
         TVjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D8SWZqFCOUKzLi8+ZQ0qCoIDCiuOKVlNWqM0PpWG3h8=;
        b=3rfPYDenDYNFcO1OEXS0Lt0mu7BY/2ikFeNcsugF5xipe1jcpqQWZ6Swka17f/h1nw
         wK1AXONZGcOxQDOrgJmFbKmsoLFWLsFeJGv8Y3VaUeQFVmb8H5WpSkJgjA+Lmj2sIORK
         eoixwZ6NQAeq9uo4KNP3qt57Nbi9gi63DZUoOSmwNULXS/hpFwV5ddteWftps9pyQlt5
         XaW4ruSxsXbv4HigsVNJEcYMDI2IPUxuweOY8y34bwhSEtL0OWWTeyuwt6GTn1nF6/k4
         FxSGOFz7MuROt8TZkNEN6UYvd/8GV8P9hAXXuav219TGsamNaUnlR0K75O6mdGIPj+9D
         x5qg==
X-Gm-Message-State: ACrzQf3Ny+aTzrMU9cQCc1Iz1QtvA+0ZphQ/IIuTm0Ulf673qXS5PViA
        YpaB49o2nITdleLPjlG9ysWlxMwKpz9iahELUjY=
X-Google-Smtp-Source: AMsMyM7x6ErSvqffOR2ykcl9p3xOmTx5xPtBcCEP+qjONtLTT/RqTJFKC7VYg0Xi5Lbfg/OHglL+Nccr5tTNQfuCsmA=
X-Received: by 2002:a17:907:1de6:b0:7a5:ea4b:ddbb with SMTP id
 og38-20020a1709071de600b007a5ea4bddbbmr48232784ejc.757.1667827893206; Mon, 07
 Nov 2022 05:31:33 -0800 (PST)
MIME-Version: 1.0
References: <20221011231207.1458541-1-lsahlber@redhat.com> <0fb9b48e-3bcc-5a5e-15fb-1d3e2752d80b@leemhuis.info>
 <b5badfe1-ccb8-f8b3-90b7-c05689e22776@leemhuis.info>
In-Reply-To: <b5badfe1-ccb8-f8b3-90b7-c05689e22776@leemhuis.info>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Mon, 7 Nov 2022 23:31:21 +1000
Message-ID: <CAN05THSLqgRS9LwQMdSBY22YRYRoD6FDJUS1HZ+Ujzk=gZ+jHw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix regression in very old smb1 mounts
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <smfrench@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, 7 Nov 2022 at 23:20, Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> On 01.11.22 18:53, Thorsten Leemhuis wrote:
> > On 12.10.22 01:12, Ronnie Sahlberg wrote:
> >> BZ: 215375
> >>
> >> Fixes: 76a3c92ec9e0668e4cd0e9ff1782eb68f61a179c ("cifs: remove support for NTLM and weaker authentication algorithms")
> >> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> >
> > Ronnie, Steve, did this change create any trouble in 6.1 pre-releases so
> > far? If not: could you please consider submitting this change for
> > inclusion in 6.0 and 5.15, as this is a regression from the 5.15 days
> > that according to the bugzilla ticket seem to annoy some people a lot.
>
> Ronnie, Steve, if you have a minute, I would really appreciate your help
> in this matter, you are the best people to judge here.

Thanks for the reminder.  I don't think there were any issues in the
pre-release so we should try to get it into the stable kernels.
I am not sure how that process works since the patch is already in upstream.
(I have only seen the process where you flag the patch with cc-stable.)
Can you explain the process on how to flag this existing patch for backporting?


>
> Ciao, Thorsten
>
> >> ---
> >>  fs/cifs/connect.c | 11 +++++------
> >>  1 file changed, 5 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index 93e59b3b36c7..c77232096c12 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -3922,12 +3922,11 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
> >>      pSMB->AndXCommand = 0xFF;
> >>      pSMB->Flags = cpu_to_le16(TCON_EXTENDED_SECINFO);
> >>      bcc_ptr = &pSMB->Password[0];
> >> -    if (tcon->pipe || (ses->server->sec_mode & SECMODE_USER)) {
> >> -            pSMB->PasswordLength = cpu_to_le16(1);  /* minimum */
> >> -            *bcc_ptr = 0; /* password is null byte */
> >> -            bcc_ptr++;              /* skip password */
> >> -            /* already aligned so no need to do it below */
> >> -    }
> >> +
> >> +    pSMB->PasswordLength = cpu_to_le16(1);  /* minimum */
> >> +    *bcc_ptr = 0; /* password is null byte */
> >> +    bcc_ptr++;              /* skip password */
> >> +    /* already aligned so no need to do it below */
> >>
> >>      if (ses->server->sign)
> >>              smb_buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
