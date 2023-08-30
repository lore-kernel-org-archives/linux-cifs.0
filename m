Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CD4C83F22
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Aug 2023 18:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245557AbjH3SxZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244794AbjH3ODH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Aug 2023 10:03:07 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C07BFC
        for <linux-cifs@vger.kernel.org>; Wed, 30 Aug 2023 07:03:04 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2bcd7a207f7so82610201fa.3
        for <linux-cifs@vger.kernel.org>; Wed, 30 Aug 2023 07:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693404182; x=1694008982; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K4CQfD2NKsjx/zuuqsVdU+P5dOQxhmaSFHz0dKpYm9c=;
        b=TgZe5SbQPRwsldyDBh195N5yEGNzdxHAoXfsI/NiRPoilH1JXiyKWMXuiFay+5qxeG
         O6uoh1kuGa+eOwouckM+6ih6T8qjxRNEXZZroGVnHb9suFWx0ZLVdWqiwFW+3/BKy4ha
         Q47Ftm0ppYldBN02jzfWOtHOuD+Ukj2dwW2184lomHkpRhwIFDmRHXUT6kN5GVLcE5LC
         Tv/ZoRfJ4LsNh6V0EmSckx/jDQtHBZLTYkSiFJEX6DtPfSZVgo9CKIf3bARhqlrZc/lZ
         l3pKxq5oXTzkmFT0d36RqLhB137j+Vip2puD0q+1q8hqkWsfOZJ/3qHbLIgaYGVJjjy6
         sdCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693404182; x=1694008982;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K4CQfD2NKsjx/zuuqsVdU+P5dOQxhmaSFHz0dKpYm9c=;
        b=Ml0FuHmSg0QdlBRzlC0ZTJjOHztyBYycQcp7Q4UvY0t3BfnsAs4ygtWShr3ZmRSu7e
         qFTDQlr68yipSzSgp/s418yOP9aCOpN5tj7yiSy+fTMqc3FRwMvYquOBLjuDSqUXFQW7
         98H4k27qjeiCsewJ8GhQU7KUkhjwBCCRP97OCuJL4641+xrXdNmPaMfTYTvu1Iwld1Rd
         7jPLhlncaM59pAJVkzv02wr00MndPsgNKnTJq9JvKIdF7WUduw6EnpdqWfTsOso3Am+W
         ECVxe4gEMGvJ1IBHUnQU9h1W7dJSo7K2QPU28oqFQju9/ay9BQ2By4f0VvvkFKlcdG2r
         8Pgg==
X-Gm-Message-State: AOJu0Yx3L0eHlPe5Rpb9UgDUF9Zu5Ws7O7klkDKNeE7GfUWMNFoqICaQ
        V+HEQRx3ERyS9tGhxcjvC/mpI8OYfRgXqrCj81c/xTfXM4D8zA==
X-Google-Smtp-Source: AGHT+IE+TJfAn/Cz0mFsz78QzP97elLPlGtNRZP6Myx93oqK+/NuYU6w6q49oN5f3l+F2Etn63eO88drfericH5CBBk=
X-Received: by 2002:a2e:9d8d:0:b0:2bc:f41a:d9c6 with SMTP id
 c13-20020a2e9d8d000000b002bcf41ad9c6mr1911768ljj.0.1693404181933; Wed, 30 Aug
 2023 07:03:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mucC=YxgaQV5nAPCfduAmjyEyxYw+XdToOwELezqe=e0g@mail.gmail.com>
 <CANT5p=rHdWmD_wtQtKU615LAWmXx4UQxHORf0HDqgYNksddvEA@mail.gmail.com> <CAH2r5mtRJtNiN128kJTSknv_F4Q6uPDsETcKH7Pjkfk0Fco6zg@mail.gmail.com>
In-Reply-To: <CAH2r5mtRJtNiN128kJTSknv_F4Q6uPDsETcKH7Pjkfk0Fco6zg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 30 Aug 2023 09:02:50 -0500
Message-ID: <CAH2r5mtHwKv1QAWqawr8jRcjNaz=pb4H9tk1wngxqBdm2Wj4uQ@mail.gmail.com>
Subject: Fwd: [PATCH][SMB client] send ChannelSequence number after reconnect
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

---------- Forwarded message ---------
From: Steve French <smfrench@gmail.com>
Date: Wed, Aug 30, 2023 at 9:02=E2=80=AFAM
Subject: Re: [PATCH][SMB client] send ChannelSequence number after reconnec=
t
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Tom Talpey <tom@talpey.com>,
Bharath S M <bharathsm@microsoft.com>, Aur=C3=A9lien Aptel
<aaptel@samba.org>


we could do a follow on with your suggestion, but seems like without
the replay flag would just look like a new write to the same offset
(which should take precedence over an older queued write to the same
offset that has a lower sequence number)

I will code up a follow on patch to do replay operation patch

On Wed, Aug 30, 2023 at 8:56=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Fri, Aug 25, 2023 at 10:09=E2=80=AFAM Steve French <smfrench@gmail.com=
> wrote:
> >
> > The ChannelSequence field in the SMB3 header is supposed to be
> > increased after reconnect to allow the server to distinguish
> > requests from before and after the reconnect.  We had always
> > been setting it to zero.  There are cases where incrementing
> > ChannelSequence on requests after network reconnects can reduce
> > the chance of data corruptions.
> >
> > See MS-SMB2 3.2.4.1 and 3.2.7.1
> >
> > Note that (as Tom Talpey pointed out) a macro  "CIFS_SERVER_IS_CHAN" us=
ed by this patch is confusing (has a confusing name) since multichannel is =
not supported for older dialects like CIFS.  I will fix that macro name in =
a followon patch.
> >
> > --
> > Thanks,
> >
> > Steve
>
> Theoretically seems okay. Although MS-SMB2 says that replay requests
> need to be indicated as replay in the header, which we are not doing
> currently.
> I don't know what maybe a side effect of not sending that could be.
> Will this patch without that make things worse?
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve


--=20
Thanks,

Steve
