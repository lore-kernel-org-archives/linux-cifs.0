Return-Path: <SRS0=HHpq=RQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4C3C4360F
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 07:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 540A22183F
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 07:33:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MWOnKy5d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfCMHdY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Mar 2019 03:33:24 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:41836 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfCMHdY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Mar 2019 03:33:24 -0400
Received: by mail-qt1-f170.google.com with SMTP id v10so780967qtp.8
        for <linux-cifs@vger.kernel.org>; Wed, 13 Mar 2019 00:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qYiRujI47fm+Pmnr/hIMK3ibi6HAfyp0qdkgfizDSXg=;
        b=MWOnKy5doj9oEXzMskwJ6GSPk57HRqIOcyvCCEy69P/ujhAfOctnw6XyoqkqsTZA/i
         t7CrX0rADHoC1PIe9m6yttpRZdXfSa0AJCTkfNiH5i9DO+2Ql4sNa8KhqLXklyknqQE6
         bZ74usRFbsvaXHtI+kvbloEUq6zdiUOxHd9myYJKaTsW0KDOU/cEFAS8i3AZ5aKgtw3b
         +WKv5jGUbsmo9bCT+T6Y2+PVCUf3LtsHCer0jxWxSnrwqbQ79fwNhKpfrg0UwJnSD59D
         dYuWr6nE+yFNTGs4aIydi3pAU7Pc7EAz0/mHsn3P0ID19GQOV2CtEXYsjqKoEC66rVH3
         sacA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qYiRujI47fm+Pmnr/hIMK3ibi6HAfyp0qdkgfizDSXg=;
        b=DAW9iqeWEYtuTQnE1WN/0KFxXTh9JgVx6w2q54EkKDgce6CS+dGCQgLvo1VxmZDBtF
         1o9XdZM6GYdHIjCMFAsE9B4bxTP6moBE/c2UkHFQU3zFbRwI9830biBrwZzEUpZbsvTr
         VKz+N6vBVnH66Sfl18tD7MKg6aAN+3yLizMDdfHMzYncvKJwxCLyo/FHsbYNcj7puQFI
         t937DYcrSrwcJwArFQjE33e5uHVuZ/Z31B6Ll97O+XncbV2EFo8P6nb9Tammx8T418CY
         ol9zBBfSk65na7OukoaeSafFKKpTS/LduqG7N9rCIVBNajErpob1BrLTwsvD17ip3Dve
         ZERQ==
X-Gm-Message-State: APjAAAXAAVO8mzp/GP70j1hUsqsKbvnoUthtmL+eefiPhlTLMHkutWU2
        DWfmSn1falmds9Xs5h/6W1Ms71dVzGNbF08AcbY=
X-Google-Smtp-Source: APXvYqxsIM6RKDb/Pu9oWJytoyZxr3OpWdUq1roHlNeQSGMhbkfAAyxFHk0ljgaJ1O2zNNO2QPBtg7YVgJQVzq0aRnE=
X-Received: by 2002:aed:3947:: with SMTP id l65mr31414046qte.86.1552462403686;
 Wed, 13 Mar 2019 00:33:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muDfiv2=VpUDTkbW3h+05ubMHsMe53nzjwp9apu=-1-tA@mail.gmail.com>
In-Reply-To: <CAH2r5muDfiv2=VpUDTkbW3h+05ubMHsMe53nzjwp9apu=-1-tA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 13 Mar 2019 17:33:12 +1000
Message-ID: <CAN05THT45xzH3K0YrATJY9UXvoN_qbQ-ZryCaichogaG_+marw@mail.gmail.com>
Subject: Re: [SMB3][PATCH]
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good.

Minor nit is
+ } else if (qi.flags != PASSTHRU_QUERY_INFO) {
+ cifs_dbg(VFS, "invalid passthru query flags: 0x%x\n", qi.flags);
+ rc = -EINVAL;
+ } else {
+ memset(&qi_iov, 0, sizeof(qi_iov));
+ rqst[1].rq_iov = qi_iov;
+ rqst[1].rq_nvec = 1;

I think it is clearer if the "nothing matched, error out" conditional
is the last one in the chain.
I.e. swap them around.

reviewedby me

On Wed, Mar 13, 2019 at 5:29 PM Steve French <smfrench@gmail.com> wrote:
>
> SMB3: passthru query info doesn't check for SMB3 FSCTL passthru
>
> The passthrough queries from user space tools like smbinfo can be either
> SMB3 QUERY_INFO or SMB3 FSCTL, but we are not checking for the latter.
> Temporarily we return EOPNOTSUPP for SMB3 FSCTL passthrough requests
> but once compounding fsctls is fixed we can remove the EOPNOTSUPP.
>
>
> --
> Thanks,
>
> Steve
