Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC3D1C77B7A
	for <linux-cifs@archiver.kernel.org>; Thu, 25 May 2023 20:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbjEYULl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 May 2023 16:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233917AbjEYULk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 May 2023 16:11:40 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E1CBB
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 13:11:27 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2af2f4e719eso10987601fa.2
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 13:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685045485; x=1687637485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SEtHntZHg7Ms5YQP5nZwmkuEWeGUPfuHk0wUhDFOsZA=;
        b=P79uMI7NatuSIhbDUKW8SoaoXvzyBjSyek6HYp9dwC2rgSr0JHCFk44khyWJQC8bdb
         +fJDNez2/7psPSWmI1n+kIhNEMbyOk7rtCzERguacg4YY2sHrYYKx/+9RoT0EqValDUZ
         hXKCja810FTmbUiYkDqT4Jk+ptjp6/npNCSsmPIirxli1ojYV2Sz15B7H1EfvBGL/ZXG
         TvN4X9/finzn+tEO35cO9awzgIAg688W74Nq+dPIfrc3p6EBGEVPzD9DAnptf3K8v4k8
         37kY1Bb1HZdjRl7+qVjjlGQuLVB3UGPZ8pD9g6ykipjQq4fKVmvXhNrOfsS/QDTK035s
         rlTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685045485; x=1687637485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SEtHntZHg7Ms5YQP5nZwmkuEWeGUPfuHk0wUhDFOsZA=;
        b=YkiCZ7TxWbKN3w5uYdKtizz/Wz5T5gsv4PO0IPmRTMpCPwkS0AifJFm08KEai02R9u
         4h+Bz09sJFzrRAEtARfpWUstcs8zFZI0srsUZhgD25g9nXcw+WLrHQ1GsyLAhNustMgW
         ArRVSqjyQEEtd5v+YnnEY/Cw74yN5BBZDWuXMaKQlp+G29nPC3buwzxKW+NOEuOrPJ7v
         CFGRLhm+rEbzYuMzqoLvYhzgNUiVTaacX5RbqfmLaOnVx2UHD4KEpkktgO4ycM1YmoeT
         dvajFieGduCcgrOrvXp1KRbwsFCxCKBnNblDk2nMv2uyswgkS17gtRoq1kKF/gdfip98
         LzxQ==
X-Gm-Message-State: AC+VfDzFfURDVoapAFAW18bmfQpMc5Pq0FyPrAfyGLppnfExNrKgSlR9
        f6QZPGkjnwrhTRwKVWtebkSBXdyUmLKFHDieTq0=
X-Google-Smtp-Source: ACHHUZ7LOK+udplatlLHG+AhXhOY6hgiMjN2Rzuh5x5ArUDuYTDx8mw1Q0DUKybRkMPN4w9l1wxnGqsbI3OTBgLEPME=
X-Received: by 2002:a05:651c:20b:b0:2ad:cb20:695a with SMTP id
 y11-20020a05651c020b00b002adcb20695amr1202545ljn.51.1685045485047; Thu, 25
 May 2023 13:11:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
 <ZGuWhzP98U9Niog+@jeremy-rocky-laptop> <20230525093900.GA261009@sernet.de>
 <CAN05THTi0BC_iwjXMiWn61fg3hRemi5Momwp3O0WGygyWLGomQ@mail.gmail.com> <ZG+LOKTr8B+zjQsC@jeremy-rocky-laptop>
In-Reply-To: <ZG+LOKTr8B+zjQsC@jeremy-rocky-laptop>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 25 May 2023 15:11:13 -0500
Message-ID: <CAH2r5mv7aZ8nm30oKyYpa-bd8-MqA13EcEmQWV4mOyrV-rj8Ug@mail.gmail.com>
Subject: Re: Displaying streams as xattrs
To:     Jeremy Allison <jra@samba.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        =?UTF-8?B?QmrDtnJuIEpBQ0tF?= <bj@sernet.de>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, May 25, 2023 at 11:22=E2=80=AFAM Jeremy Allison <jra@samba.org> wro=
te:
>
> On Thu, May 25, 2023 at 08:49:47PM +1000, ronnie sahlberg wrote:
> >>
> >> just took a look at how the ntfs-3g module is handling this. It was an=
 option
> >> streams_interface=3Dvalue, which allows "windows", which means that th=
e
> >> alternative data streams are accessable as-is like in Windows, with ":=
" being
> >> the separator. This might be a nice option for cifsfs also. That optio=
n would
> >> just be usable if no posix extensions are enabled of course.

You can already open alternate data streams remotely (from cifs.ko on Linux
as you can from Windows and Macs etc. just open "file:streamname"), but on
Linux you have to disable the reserved character mapping ("nomapposix")
otherwise ":" would get remapped on open in the Unicode conversion.

There may be a better way to list streams in the future (e.g. to help
backup applications
that need to be able to save files created by Macs or Windows that need the=
se
e.g. Virus checkers etc. use ADS, and looking at my Windows machines, PDFs
can have small "Zone Identifiers" saved in streams), but you can
already list them
with "smbinfo filestreaminfo <filename>"

I was thinking mainly about backup scenarios whether this came up as
listing them
also via a pseudo-xattr (IIRC Macs do something similar).



--=20
Thanks,

Steve
