Return-Path: <SRS0=XnNO=4O=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B44C4BA0B
	for <linux-cifs@archiver.kernel.org>; Wed, 26 Feb 2020 09:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 680F021556
	for <linux-cifs@archiver.kernel.org>; Wed, 26 Feb 2020 09:22:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ICPhGHr7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbgBZJWi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 Feb 2020 04:22:38 -0500
Received: from mail-io1-f48.google.com ([209.85.166.48]:40518 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgBZJWi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 Feb 2020 04:22:38 -0500
Received: by mail-io1-f48.google.com with SMTP id x1so2553720iop.7;
        Wed, 26 Feb 2020 01:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EV7FGZpFqM3MXMRpDIfQuZeYXOQ0Cm1sB7r0IOS6lMw=;
        b=ICPhGHr7tJmDzDBkCqyFZ5ucRR+vGT8BRVZ+bPsX2Fnd4trg/jrsJ/9iRN6BHvgE9F
         VaIB9RZTo0yZf95ykQ+Eyk8//usLHs4Lwagd7GFHXW+9TM46lmVoMdAXVpST4Nzn34GX
         ykO8dwGAj/62eS77sZaK4Srdorlzg+yCQjE9Zrg2HsnkGnULOAFCSS2NwGd/9dfANpu9
         24EjtOzkX9lNGe8cBFum3AJ0dWXgZAYfTYXYyhb3EDaLZkZHamaXTDGfIJHL3nF6E/4S
         2ePKrfEZRvZZLqA/l3ZmCH29TJDmV2aofXuhhTot/s4oJvV2TOeqFqx/VZ9yGmrCrPb5
         KTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EV7FGZpFqM3MXMRpDIfQuZeYXOQ0Cm1sB7r0IOS6lMw=;
        b=TG1AoIFmyPdwDi8Wsh69YxgtwxAS5um2EpfX5gDo968IiuoGKRhy+QsHgijYFARZrt
         VsOh1MHM9ShyNYTFwBhlgeV8n2LG/XsPu+WrsULB9t1p9s3kYTkR4J4B9JH6OJFog4lW
         GiKUx9xLyy1rGemdXeMZXNRz5VHjNn8buDuVmQrOyF7OCL1jTiCyvBz/W5456QBz8olK
         T8U66PoT7CVuYMmWK6s+gJizxOHnzD4F2chY9H2Mn+LjGjCP2PcAh45D9pTJ2fNc6Zdb
         yqKmZVANWoiDegdASwCEiZPlIQ4ANWtZw4xHJnBZJcsLiJBEyNDzU92H6izcrdPt3l90
         J+WQ==
X-Gm-Message-State: APjAAAXKfKnnZUAMoPH5NAuGoxp063gdfxZJLtibAREK8KupV0yfWbl+
        wrN50ma56q9n31RHQ5LjlcD3wBDDMreLPOki2eM2/lV2
X-Google-Smtp-Source: APXvYqw0sD4ErZ4gv5YKtxhRLMl66m8Y/T3l3446JfpEtvmwI6jm6LXWXnEG8XHui07nTxCndkxDZUEQU7H5+6BOPXM=
X-Received: by 2002:a5d:9c88:: with SMTP id p8mr3424343iop.9.1582708957178;
 Wed, 26 Feb 2020 01:22:37 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mt0=WRC2SgG6UZmZ32PbjZrcK4N_sZ9=WcSEar1utTmCw@mail.gmail.com>
In-Reply-To: <CAH2r5mt0=WRC2SgG6UZmZ32PbjZrcK4N_sZ9=WcSEar1utTmCw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 26 Feb 2020 11:22:26 +0200
Message-ID: <CAOQ4uxgUuR__Epnt4tfDuZ4-qiRQxt9mVY5ukBCC2z59YNdDHw@mail.gmail.com>
Subject: Re: [PATCH][CIFS] Use FS_RENAME_DOES_D_MOVE to minimize races in rename
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Feb 26, 2020 at 8:37 AM Steve French <smfrench@gmail.com> wrote:
>

What sort of rename races? Is that a real/reproducible problem?

> Should be safer to do the dentry move immediately after the rename
> rather than later.
>

Looking at what "later" means, you moved d_move() before
cifs_put_tlink(tlink);
and
shrink_dcache_parent(new_dentry);
detach_mounts(new_dentry);

I suppose cifs_put_tlink() is not the issue.

It makes me wonder about shrink_dcache_parent()/detach_mounts() -
they happen for some fs before d_move() and for some fs after d_move()

I think it kind of makes sense to have them moved after dentry is
unhashed anyway? (that is after d_move()).

Thanks,
Amir.
