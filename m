Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08E9C38BE0
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 20:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 676702176D
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 20:39:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KOX5/iuP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgBXUjX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 15:39:23 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:46938 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgBXUjX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Feb 2020 15:39:23 -0500
Received: by mail-il1-f196.google.com with SMTP id t17so8849145ilm.13
        for <linux-cifs@vger.kernel.org>; Mon, 24 Feb 2020 12:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yB653smAVEFNv3GwaaJZRcvE6Bb1cJ4KZuAcX5SURtY=;
        b=KOX5/iuPGI3DiXZwDdmDN/sh8eVgYsjOYY90y9iMHcs7sSVNnr2o3M3lTpEYCrMp15
         pZ+OQJoINLa8BuzZp2KNtlDunj00QvTM9VmplFynCzaqd7rJO9Hts+naG2syfQ4WNdHr
         fCkeTcRzI5BqStzXXL5SNrsto2O/VRwOrrvpFDuNjQF3M8MjKVzHeDUrISTP8OAoBQpt
         zW/lbnBoy5w3nFt7NkDeuaWb4QOnRe+IndeJ4ptT1B1FFcKAEC1ITz5U2d33NE9FBs++
         5yTV4zKbm+4xiCQVDOcdjyXEqGbpbzwJqt01y6Hqr6hRWMa9cGZAIZSCZBP/0mcUgr6b
         y/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yB653smAVEFNv3GwaaJZRcvE6Bb1cJ4KZuAcX5SURtY=;
        b=XoICEx2SZIqXbv3wwx7wCGtN3SClGjTuMtz9daX9Uum1M9kDA9v0xPNvqPYGhm3GAc
         s8+sSj6/IZQEt6gchzMffMliatjsGgbqdSfklRpNa57bS7XUAPbSnikB76f6nSR2YL83
         SQsIxFJ/0V5ce3kEy0dib4dGM7eX+v1vhHJEgKuiKmTlHkjyBEXWPgQnaqQ3HkoiVhcA
         PhUCz5kJ+lOIvg6GfcsDo2p8nI3aHMQBtN2MlP/eGjOgQ16rBEH03cta/69gQ4vB665+
         9EzcQbqSawJKtP+srL4rXglQHzDkmgJvUIrz9QIOv6cIZWtajP523PgjglpWNojcl2SJ
         NIvw==
X-Gm-Message-State: APjAAAVnH43OuqDcWZrTCPE9rOLP/JKZdDHmJWwg0JBRrjqIRiBUhQuf
        ndWR8D1sd4V3v6auu3MqdVL8xWcLccsMVxBsFf7upw==
X-Google-Smtp-Source: APXvYqxqeE9Pt5GrJeuTvCPh47fcUOFAK8/zG130kGV1FzFBYWjb/JiIBq2MM2mBQBTCVFq7gBZl4khG5F4PJR7r2Og=
X-Received: by 2002:a92:cb8c:: with SMTP id z12mr61503551ilo.5.1582576762246;
 Mon, 24 Feb 2020 12:39:22 -0800 (PST)
MIME-Version: 1.0
References: <20200224131510.20608-1-metze@samba.org> <20200224131510.20608-4-metze@samba.org>
 <87pne34zye.fsf@suse.com>
In-Reply-To: <87pne34zye.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 24 Feb 2020 14:39:11 -0600
Message-ID: <CAH2r5msm43TLWYUx++9+tND2rOBDUFuZJ4+vtiTPQwQiqPbSyQ@mail.gmail.com>
Subject: Re: [PATCH v1 03/13] cifs: make use of cap_unix(ses) in cifs_reconnect_tcon()
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@samba.org>
Cc:     Stefan Metzmacher <metze@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

First three patches in this series merged into cifs-2.6.git for-next
(and the buildbot's github tree) pending more testing and review

On Mon, Feb 24, 2020 at 12:12 PM Aur=C3=A9lien Aptel <aaptel@samba.org> wro=
te:
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)



--=20
Thanks,

Steve
