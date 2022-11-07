Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2531CC433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Nov 2022 21:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbiKGVkR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Nov 2022 16:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbiKGVkQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Nov 2022 16:40:16 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FD527DE1
        for <linux-cifs@vger.kernel.org>; Mon,  7 Nov 2022 13:40:14 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id k2so33758178ejr.2
        for <linux-cifs@vger.kernel.org>; Mon, 07 Nov 2022 13:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a7Pu312VBrRa3fZpA2kIIB54gqaUtTzt/kFTpVj9Gyg=;
        b=n5wjSnKDahfy6jokw7XFLSSk66A4Ob296f44tyNXmPenGjHHPloCpXMD1Ez/AkqESK
         SLHykNycUc06VqR7N9BrpxYUZtNhvxyYPu5z0aNrhswA+iK7SMIJestecpQ/XTqyH6g0
         zejJLg0rvbsQoFhSb8h5lbkKbsowOJbX/A0gPHQfRCEGjn8cowuBP3NdX6YGRFOQuF33
         iS6lEvYdkVYPYHVB1ezKwL9pCCSoypVt6jZN0WlFa1XrjlSeg3nSBWW0Z/HD2nj9mBPQ
         6IlnUzFioaelYmGCEpvGVCJxJ/Q+T+dHKlmZbGNk/qO/sSylhdfKk8n3naHnRxXN/0yo
         d76A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a7Pu312VBrRa3fZpA2kIIB54gqaUtTzt/kFTpVj9Gyg=;
        b=OZHfaIuirG4V54Z+8oujXJWrW3Hrqr7mRw4KglP2KDGUmJx2iWi6dSiA4AqWIKC6k4
         T68Q6WVYPNIL7LBIvF2OV95NX7XgTZD3WZFqFEDPm3w7wBn6IIx0hp22/zBbDe5LIlXx
         FxUPwg8RmueHcNrFOTWdGsTtY7O9yjQ3HKB5QUEZIY9QIKaQQ0xiWgt2uRPT7s0wUbsc
         lplihGkQz9gKrdn+lLz6whkybAnzPzn+aXhOnfvSZqtzBbmlDsD8F3311P+XqTpWUL4O
         ojZ/ZyRtz0rynjhHRBPo2CMLb37/iLB0FaDuwZJqbSsKpbV7Cg+/o6YoGHdA7F93B2D6
         /1yQ==
X-Gm-Message-State: ACrzQf3pbiTd3QByzG/gzWonv0p8wsGO+SsleMVsloJyKledp1lnuDhI
        prCZkLQ/GKj97A3TR3xptpT2jUAzS3jYWLnZAHU=
X-Google-Smtp-Source: AMsMyM675OVDVgKSw3ua7nw/asBTMb/aRORa1xk0sqS6j8Ja93NCFLWkXxRtCKVOaR7mYmsIB9DwvFVv+7bFcPtOBTE=
X-Received: by 2002:a17:907:1de6:b0:7a5:ea4b:ddbb with SMTP id
 og38-20020a1709071de600b007a5ea4bddbbmr50075967ejc.757.1667857213303; Mon, 07
 Nov 2022 13:40:13 -0800 (PST)
MIME-Version: 1.0
References: <20221011231207.1458541-1-lsahlber@redhat.com> <0fb9b48e-3bcc-5a5e-15fb-1d3e2752d80b@leemhuis.info>
 <b5badfe1-ccb8-f8b3-90b7-c05689e22776@leemhuis.info> <CAN05THSLqgRS9LwQMdSBY22YRYRoD6FDJUS1HZ+Ujzk=gZ+jHw@mail.gmail.com>
 <7a348025-8db3-449b-e92d-7033104d60d3@leemhuis.info>
In-Reply-To: <7a348025-8db3-449b-e92d-7033104d60d3@leemhuis.info>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 8 Nov 2022 07:40:00 +1000
Message-ID: <CAN05THSP0N0QMTv5-csBjvHuO0PVgDBkC7xNMNfHUZmuMXLRnQ@mail.gmail.com>
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

On Mon, 7 Nov 2022 at 23:40, Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> On 07.11.22 14:31, ronnie sahlberg wrote:
> > On Mon, 7 Nov 2022 at 23:20, Thorsten Leemhuis
> > <regressions@leemhuis.info> wrote:
> >>
> >> On 01.11.22 18:53, Thorsten Leemhuis wrote:
> >>> On 12.10.22 01:12, Ronnie Sahlberg wrote:
> >>>> BZ: 215375
> >>>>
> >>>> Fixes: 76a3c92ec9e0668e4cd0e9ff1782eb68f61a179c ("cifs: remove support for NTLM and weaker authentication algorithms")
> >>>> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> >>>
> >>> Ronnie, Steve, did this change create any trouble in 6.1 pre-releases so
> >>> far? If not: could you please consider submitting this change for
> >>> inclusion in 6.0 and 5.15, as this is a regression from the 5.15 days
> >>> that according to the bugzilla ticket seem to annoy some people a lot.
> >>
> >> Ronnie, Steve, if you have a minute, I would really appreciate your help
> >> in this matter, you are the best people to judge here.
> >
> > Thanks for the reminder.  I don't think there were any issues in the
> > pre-release so we should try to get it into the stable kernels.
>
> Great.
>
> > I am not sure how that process works since the patch is already in upstream.
> > (I have only seen the process where you flag the patch with cc-stable.)
> > Can you explain the process on how to flag this existing patch for backporting?
>
> Documentation/process/stable-kernel-rules.rst (or
> https://docs.kernel.org/process/stable-kernel-rules.html ) explains this
> (see option 3 there) better than I can. The patch afaics needs to got to
> 6.0 and 5.15.

Thanks. What we need here is option 2.
Steve, can you send an email for option 2 so we get it in the older kernels?


>
> Many thx for taking care of this!
>
> Ciao, Thorsten
>
>
> >>>> ---
> >>>>  fs/cifs/connect.c | 11 +++++------
> >>>>  1 file changed, 5 insertions(+), 6 deletions(-)
> >>>>
> >>>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >>>> index 93e59b3b36c7..c77232096c12 100644
> >>>> --- a/fs/cifs/connect.c
> >>>> +++ b/fs/cifs/connect.c
> >>>> @@ -3922,12 +3922,11 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
> >>>>      pSMB->AndXCommand = 0xFF;
> >>>>      pSMB->Flags = cpu_to_le16(TCON_EXTENDED_SECINFO);
> >>>>      bcc_ptr = &pSMB->Password[0];
> >>>> -    if (tcon->pipe || (ses->server->sec_mode & SECMODE_USER)) {
> >>>> -            pSMB->PasswordLength = cpu_to_le16(1);  /* minimum */
> >>>> -            *bcc_ptr = 0; /* password is null byte */
> >>>> -            bcc_ptr++;              /* skip password */
> >>>> -            /* already aligned so no need to do it below */
> >>>> -    }
> >>>> +
> >>>> +    pSMB->PasswordLength = cpu_to_le16(1);  /* minimum */
> >>>> +    *bcc_ptr = 0; /* password is null byte */
> >>>> +    bcc_ptr++;              /* skip password */
> >>>> +    /* already aligned so no need to do it below */
> >>>>
> >>>>      if (ses->server->sign)
> >>>>              smb_buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
> >
