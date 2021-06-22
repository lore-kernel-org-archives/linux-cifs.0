Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3AA0C2B9F4
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 10:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99A5A613B2
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 10:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhFVKjf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 06:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhFVKjb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 06:39:31 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4908AC06175F
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 03:37:15 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id i5so5520019eds.1
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 03:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=bD5QFgRz4TEq1XWgJQNfV8DVq5n6vfi5q3Hywb5/hMo=;
        b=BLrtKrcYKrIZCdy5QtUJhnSnSu7CjBla0bMVDWEnEJt1dpSgHVaL3lOTnJ9qNHsZ9l
         +gktmpzvz5DYjvfooqtueosEGjmP2m+B1ZE10meJHQjLsm5ahnfHhHdIxHckYs5kdTjK
         dmjxILEvQlNKv/vllgFP3YXQXYy+lgOWBfTkjaiDCiJz1I5YKfXM58qj4TDXn2YKjz8Q
         DEpHvHEalVgTlkfKRgVqfOwrVPGQ3e9TdSbZQZKWpdJj2BLPD8hOQd9QPSoCsvMZJPj9
         G7UVrFQ2kMqknvVYMSruZvCKTkWUxZjCAGnIR15yLAhRtLhTGgCLFI+lUwp2bE4pkz20
         6NZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=bD5QFgRz4TEq1XWgJQNfV8DVq5n6vfi5q3Hywb5/hMo=;
        b=mPySHwdM1y4iRlUYi7u2soNdM9eB29JQm+VCgYOgj6x5ip6HlX0tinuCyiMb5+oakP
         v8Bv5s+y2C34pCqQYGkBWrByjAnXPUWGA9/Etohtrj5hW7uMS7wYzdZZAsi9YgbS37VD
         K709K1CSHSBgLxGtBnfQPhqRMpdRkaCg+1tgfYKcN1XTe0RMgjarEr2SIWxFz+FVekqh
         WtF+3SounV1gw1aj3KAD79thlxUSyJkJdPpEAM1ZyssHS5o9PD2Vq49e1QWPBeugbjjE
         WdDq51lYi7rU2rwh86782OR6qWpoORTMupMqaYMEw9PwUC0RssfF0HtBBMqz3aIXf/+s
         V+AA==
X-Gm-Message-State: AOAM532M9vhPgg4C4+nf/wKTrzNRIwVAKxltne/lL+YjY8IPZf0ryYNw
        1SNYrkDBRH6adIwNZMach5o=
X-Google-Smtp-Source: ABdhPJyJtYMXvwckdHIeOC9w5pvmuyMnSJ4lvxdMIA7TkpxyQiYw1tI8f4k+uSccrvS2gcga5R6iSg==
X-Received: by 2002:aa7:de90:: with SMTP id j16mr3973978edv.385.1624358233933;
        Tue, 22 Jun 2021 03:37:13 -0700 (PDT)
Received: from localhost (p200300fa070a9938181fa8b6e56d3837.dip0.t-ipconnect.de. [2003:fa:70a:9938:181f:a8b6:e56d:3837])
        by smtp.gmail.com with ESMTPSA id h16sm11723479edb.23.2021.06.22.03.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:37:13 -0700 (PDT)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aurelien.aptel@gmail.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>,
        'Christoph Hellwig' <hch@infradead.org>
Cc:     linux-cifsd-devel@lists.sourceforge.net,
        linux-cifs@vger.kernel.org, 'Steve French' <smfrench@gmail.com>,
        'ronnie sahlberg' <ronniesahlberg@gmail.com>,
        aurelien.aptel@gmail.com
Subject: RE: ksmbd mailing list
In-Reply-To: <013001d76734$0cf3bee0$26db3ca0$@samsung.com>
References: <CGME20210622061228epcas1p247d557ef24a971eaf395edd6174bed5e@epcas1p2.samsung.com>
 <YNF/OpvdMLbIDZiZ@infradead.org>
 <013001d76734$0cf3bee0$26db3ca0$@samsung.com>
Date:   Tue, 22 Jun 2021 12:37:12 +0200
Message-ID: <87mtriqj6v.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

"Namjae Jeon" <namjae.jeon@samsung.com> writes:
> Add CC: Steve, Ronnie, Aur=C3=A9lien.
> Any opinions?

I think having only one list would be nice too, but we should
ask/document to put a [cifsd] tag somewhere in the subject, which is
hard to enforce.

Case in point, it already gets confusing when people send patches for
cifs-utils: we can't always tell it's not for the kernel from the
subject which can confuse people and scripts.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
