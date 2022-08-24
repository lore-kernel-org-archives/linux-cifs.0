Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA326C00140
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Aug 2022 05:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233556AbiHXF5j (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Aug 2022 01:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiHXF5h (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Aug 2022 01:57:37 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003EB910B4
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 22:57:32 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id x12so6361102uaf.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 22:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ldKctSS7Wy8fg0uiQ/uFDo7AqMsJ3DMP3naKyTd31xk=;
        b=nPMLEOB+wEg6OgfDcIG+mlo8en1LSiyf4ZgZsXzfEwoYEwUiYYA0tivrnEVFKdnzpD
         xcF9bQOzHbhodZ7tPFwSuzKSD+Q9Shq6bDO2dZPN1/T2IsOFMk1ahVCY96gQ49L15GOZ
         zWnk/2sPVrXsqBJoVZ1GqC91dIZ4eIMeRrkPp9Jgl2o7s0O428CsNejFuOlhBpJevlLm
         8E0OWMbCRaz58gcgc+88O20ztH8+Z5Z8nUHPlX3nq0c2A0xncrA1uiqbeUVHQ7as1RYb
         IsGMqBllqkuTf0l9dT6qr2MHlxhdQbXREIC1h0QKd7ybt8vvhdneP4RkLbc9AqB9wSWT
         +swA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ldKctSS7Wy8fg0uiQ/uFDo7AqMsJ3DMP3naKyTd31xk=;
        b=Si5WellwbBYz2A6Mv+W+c0p0LlosuFr6TPOSpm5WbF6aecTuKEGuIiz4wPz1bBnn+W
         qYlNjojVEX3thWEHGIwPt2PoZHu+/I7aePLKbhrehIshQpb9iNRa1VJqLdh7stOvc3sI
         ds1dNBJ4sSqtP4yDyobPJfsX2ITpl7Qg/3LZNu6IKEEKkGhl21oQodbATiOlZP8XyYMc
         k4cVYJkTGuMQs3LO2LtYE854wto1+6Gft1xZjJ2lW6FeRLYJciCYcCWUHimtRsEbboog
         nsri84+Xi8oCxKV6jwfX04Sbg2f5lQzJh4K5uGRVGcX69wg+jGTwsUseIGFt4NCWKoNM
         goiQ==
X-Gm-Message-State: ACgBeo3XBGJ0dlUg+uMOrhKSG2ne8SEHGb8prhs17HeuASZVVY0eJ1hb
        CKMzW+kt30ciBqUFRij+E0+uU+Ca/fUUPuYGee0=
X-Google-Smtp-Source: AA6agR5YkXzIxIc53P5Gsoa25+nrc/IGu0oFRnXlcrfrQ9bq9nUA4/eKvcgLcHUr6mmuh9Jfhos04M6WnFvxqESFi14=
X-Received: by 2002:a05:6130:10b:b0:37f:a52:99fd with SMTP id
 h11-20020a056130010b00b0037f0a5299fdmr10474115uag.96.1661320651971; Tue, 23
 Aug 2022 22:57:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220823125202.1156172-1-zhangxiaoxu5@huawei.com> <877d2yj2m2.fsf@cjr.nz>
In-Reply-To: <877d2yj2m2.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 24 Aug 2022 00:57:21 -0500
Message-ID: <CAH2r5muSyGmWOWD3oMwhyFBQo4b-hyWCWeUJ=qcPDohqi-Hx6A@mail.gmail.com>
Subject: Re: [PATCH -next 0/3] cifs: Use some helper function for preamble size
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>, rohiths@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing

On Tue, Aug 23, 2022 at 12:23 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com> writes:
>
> >
> > *** BLURB HERE ***
> > The unfolded expression of header_preamble_size is too long, in addition,
> > some expressions have specific semantics, e.g.:
> >   calculate the position of the mid,
> >   confirm it's smb2+ server or not.
> >
> > Zhang Xiaoxu (3):
> >   cifs: Use help macro to get the header preamble size
> >   cifs: Use help macro to get the mid header size
> >   cifs: Add helper function to check smb2+ server
> >
> >  fs/cifs/cifsencrypt.c |  3 +--
> >  fs/cifs/cifsglob.h    |  7 +++++++
> >  fs/cifs/connect.c     | 28 +++++++++++-----------------
> >  fs/cifs/transport.c   | 21 ++++++++++-----------
> >  4 files changed, 29 insertions(+), 30 deletions(-)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Thanks,

Steve
