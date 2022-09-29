Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B14EBC6FA82
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 00:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiI2AHh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 20:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiI2AHf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 20:07:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00F91166EF
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 17:07:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B199B8222D
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 00:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0CAC433D7
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 00:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664410051;
        bh=CrCkF0WgXvXdALBalem2h67pPCTeKHRIVx7Ya6w6psU=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Mxb3AdqiffYKaEBbsHGzBjIXJmZO+OMKwfF2mGP9gX5pHiDg7svXEWdqlMyrkcVHj
         lXIIJP3p+FMY4oYoRXVY+7sWrZvQMoRIraDpltaUF4f6viMqV5PqmSBeEZPS2eJ25N
         PrkA2tYyL0rPPzLvy9jpR2hHN5JELySjbg/lRoVuu9GRy7LMze3UDYCMTa7xO/qm0M
         YIxNKQK3+LljWbYTQwtq6DpFyXQQ7HmeB/ZMVpre7sVRExIPN+IDvgVs71zBD0hLn+
         K3d88ost0NSTpzV3ziMbq2TKTFLiE+xLu+gP1X6y3EL8eBuOKnIMCNXB/3ut87VyTQ
         emVXadjSaCXJA==
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-13175b79807so9269603fac.9
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 17:07:31 -0700 (PDT)
X-Gm-Message-State: ACrzQf2YnhUHaLArDz2JA8OfY58k+bIFLWjKLKwXSW9X1gWTEAj+X/aM
        BUhSfjTE7JMd9+1/mOon6qRDYaTuII6L8dl+o4U=
X-Google-Smtp-Source: AMsMyM7DvX8Ygniep+txUwafdqg/LlbYoQxOLOK5wFjNKx5wbXwv7FCN7ROpuBym63EBYoz7+IeXSXdYPHe2VeXLyAg=
X-Received: by 2002:a05:6870:b290:b0:127:4089:227a with SMTP id
 c16-20020a056870b29000b001274089227amr7175416oao.8.1664410051042; Wed, 28 Sep
 2022 17:07:31 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Wed, 28 Sep 2022 17:07:30
 -0700 (PDT)
In-Reply-To: <20220928184259.75500-2-atteh.mailbox@gmail.com>
References: <20220928184259.75500-1-atteh.mailbox@gmail.com> <20220928184259.75500-2-atteh.mailbox@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 29 Sep 2022 09:07:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_F=tWHBq8By+n9kUTA0ngsCrwN8=Hg=B3nPhPYpFi2MA@mail.gmail.com>
Message-ID: <CAKYAXd_F=tWHBq8By+n9kUTA0ngsCrwN8=Hg=B3nPhPYpFi2MA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ksmbd-tools: preserve share name case by
 casefolding at lookup-time
To:     =?UTF-8?Q?Atte_Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-29 3:42 GMT+09:00, Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>:
> Preserve the case of share names by doing casefolding at hash table
> lookup-time. This is preferrable for a few reasons.
>
> First, ksmbd can be built such that it is not capable of casefolding
> UTF-8 share names. Such share names are then case-sensitive if they
> have non-ASCII characters, and connections to them should succeed only
> when matching the name in ksmbd.conf, ignoring ASCII case. As such, the
> case-preserved share name will be sent to ksmbd in the share config
> response so that ksmbd can casefold it and validate against the share
> name it knows. This is necessitated by the way share config caching is
> done.
>
> Second, addshare should ideally preserve formatting when modifying
> ksmbd.conf. Then, preserving the case for user readability reasons is
> desirable. Also, since ksmbd.conf is just as often edited with a text
> editor, it is important that share names can be searched using it,
> which is often not possible when they are written casefolded.
>
> Third, case-preserved share names are now used in SRVSVC GET_SHARE_INFO
> response, with __share_entry_data_ctr0() and __share_entry_data_ctr1(),
> and so they are seen as written in ksmbd.conf.
>
> Also, in shm_casefold_share_name(), note that g_utf8_casefold() aborts
> on fail, and if g_utf8_normalize() fails, g_ascii_strdown() aborts on
> fail. `share_name' was leaked in srvsvc_share_get_info_invoke() as the
> string returned by shm_casefold_share_name() should be freed. Before
> that, `share_name' was the string returned by g_ascii_strdown() and
> leaked then as well.
>
> Signed-off-by: Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>
Applied, Thanks for your work!
