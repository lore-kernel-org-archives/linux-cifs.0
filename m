Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F48C83F21
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Aug 2023 18:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244229AbjH3SxW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244765AbjH3N4Z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Aug 2023 09:56:25 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4057107
        for <linux-cifs@vger.kernel.org>; Wed, 30 Aug 2023 06:56:22 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-500aed06ffcso7222130e87.0
        for <linux-cifs@vger.kernel.org>; Wed, 30 Aug 2023 06:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693403781; x=1694008581; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Upx92DUimAI2lQQO9dRBMYAViDwz8BMobbcvkYqgSYY=;
        b=b82tL4rWFsPcef70Q4Y3ixPiGImytUHuV01UstHWQ8omN8aK3GhvVFRcLe3S/Sr7Gu
         7UFNZB3fETZdEniFdlJXOxQ1Uj/g3mbdRE1SzY4pYvWLpYxJi10U8NMxs022viODa443
         qLeG9Czk30N2jYBDdgUFBIDeObQ7j1EBnnCz0icGZI+zaHs30oOpb+xCSjUvFZR9Mzrq
         RuX00awxl587CwlA1AvCRuWvafzrqLVcoGTkp5Pvu+kpjUHkwbYMcfHRKR6N/IB3pmmK
         VOEccn0GBAlDGLvfhuzVcZhPKKf65oMnlQZA6vwH3Ws0qH1j2t0De7po33wFlQE1xY44
         a7qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693403781; x=1694008581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Upx92DUimAI2lQQO9dRBMYAViDwz8BMobbcvkYqgSYY=;
        b=DknuWmlH4Dle2WIoFGax3Lk9z8lJFqQRdJgLHjELX7pvUl/vUzwrLO1YX60IQZuBIf
         elo7WPlt8ABqrR9YirZI4TZ/2DmGYk30jPlMf9AqUgxmQoq6BFsAJGdQhCZH5otSGWhq
         OHjjB8UwSkgK02CSSSvZftpYIYkodIz8gMu5s9/Ep0ePQ6EjxLbUl6wfVRxMhYHTK212
         oOOb5VyMskpqO5RuC21c2EDu04ocgR7Ppj/sy2/rSlwkUTIsooHNtfyrKeTmW2Xv6Mot
         t7xx3kWrq8iBuWEtxWdK3+XdjBacEkQgFUeNF4Jwn5vDHDhBrBLAGUCt18QIfg2O5XOF
         4bWg==
X-Gm-Message-State: AOJu0YzRvRLREA7+c+HXxi3fJnlvXZGmcFrE+SwVEeXEDcGa9mb1wxK8
        znRyIEOp8xv/tn3cmCDI3k4W61E133mLsEgvRc0=
X-Google-Smtp-Source: AGHT+IFGaf7XWc1e0jQtr9zOyNolePqdVl5g1vmPvIQsoC8BnVrI7D89WFW5UpPxL0TCDFmHQ2BX5ktFYfCGn2/GxAw=
X-Received: by 2002:a19:4303:0:b0:4fe:62f:35eb with SMTP id
 q3-20020a194303000000b004fe062f35ebmr1310449lfa.20.1693403780944; Wed, 30 Aug
 2023 06:56:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mucC=YxgaQV5nAPCfduAmjyEyxYw+XdToOwELezqe=e0g@mail.gmail.com>
In-Reply-To: <CAH2r5mucC=YxgaQV5nAPCfduAmjyEyxYw+XdToOwELezqe=e0g@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 30 Aug 2023 19:26:09 +0530
Message-ID: <CANT5p=rHdWmD_wtQtKU615LAWmXx4UQxHORf0HDqgYNksddvEA@mail.gmail.com>
Subject: Re: [PATCH][SMB client] send ChannelSequence number after reconnect
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Tom Talpey <tom@talpey.com>,
        Bharath S M <bharathsm@microsoft.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Aug 25, 2023 at 10:09=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> The ChannelSequence field in the SMB3 header is supposed to be
> increased after reconnect to allow the server to distinguish
> requests from before and after the reconnect.  We had always
> been setting it to zero.  There are cases where incrementing
> ChannelSequence on requests after network reconnects can reduce
> the chance of data corruptions.
>
> See MS-SMB2 3.2.4.1 and 3.2.7.1
>
> Note that (as Tom Talpey pointed out) a macro  "CIFS_SERVER_IS_CHAN" used=
 by this patch is confusing (has a confusing name) since multichannel is no=
t supported for older dialects like CIFS.  I will fix that macro name in a =
followon patch.
>
> --
> Thanks,
>
> Steve

Theoretically seems okay. Although MS-SMB2 says that replay requests
need to be indicated as replay in the header, which we are not doing
currently.
I don't know what maybe a side effect of not sending that could be.
Will this patch without that make things worse?

--=20
Regards,
Shyam
