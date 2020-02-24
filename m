Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A5EC11D2F
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 17:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B126F20836
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 17:25:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ttw3oaCn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgBXRZN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 12:25:13 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:33759 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgBXRZN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Feb 2020 12:25:13 -0500
Received: by mail-io1-f66.google.com with SMTP id z8so11111600ioh.0
        for <linux-cifs@vger.kernel.org>; Mon, 24 Feb 2020 09:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nnFHuoWxVOdzogmqXQd8HCNcdJ2Ad7azOTtYBd1W6wI=;
        b=ttw3oaCnMQXNRase2m5Vx7tygBzwz15FY0Ble40CSN5EWARmMTnV9BIG/Zh4m04eJE
         goj/EqChLWzxYFo32aKiYxxWvl7Tkqwi32jwaBBi5bgBY8wjSMuPec1T7zAjim+6suJw
         csyZqp1S6ekMO2v1X3AujgsO0XVx47/Yr3fTMycX+a+DGNOw65LQVjWRUTVtiT8nVGbh
         XkUDkcBcJ3cyJ2eOiLM4mxxRL/O59pQyPZCSd1Fwu6PtDvcgfSiW2zz4ZcU+9xQQWHfO
         peaPlB31y5bFzFig5/qhU6HlGokOxc2gYGtvL1LjtJQCHcjYkZoT1DNJ2CUVOQjINWi+
         9SLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nnFHuoWxVOdzogmqXQd8HCNcdJ2Ad7azOTtYBd1W6wI=;
        b=TbyzO83obAyq+wEZnGuHmxlimePHOEzV5z2m6YTETU9ntzTfz9ACIGpN1BsugFkIid
         JnMEVLonqecxk659rj5cBFm+E5W4Vg0LF7o4vRQmGJDlkJJ3NXfUewnuUa0V4u7CYn9q
         OlR8XHgml0g9XdaoUjBdJ9fJ3E0aYMAtBcA4+bgTWYDO2ZSjCkmHKtY0qBVf9G7wYANg
         6PR41kscluRPm/UEagS1P95ouiEmr5pqeXVxs6L5ff4nItD4Y/eqNXFsBWI3uH437Bgi
         CZmqutgS3Wf/OpiZK410Hvx/6klTOI5pqBbntcFysOnBSrANBFVO9rpxLqONDfPL53Ag
         sLAg==
X-Gm-Message-State: APjAAAWhjj/NgMXk+rB0qjXlgrHrKt7SWEOuNPwDVlOLFBFPJE5s2HMM
        opwqy++iSFDevwqCV6m+8k2zbLla9Nlliz0bWdk=
X-Google-Smtp-Source: APXvYqwZWGVxUelplHusrPpjUeoOa+r8u1mzOOfQ22q3I60SQZK3hzHvs3FrQgDUHQ6S+nBI6V7ifV72RoOR/2cdUW8=
X-Received: by 2002:a5d:9419:: with SMTP id v25mr49657396ion.3.1582565112315;
 Mon, 24 Feb 2020 09:25:12 -0800 (PST)
MIME-Version: 1.0
References: <20200221101906.24023-1-aaptel@suse.com> <878sks5fv7.fsf@suse.com>
In-Reply-To: <878sks5fv7.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 24 Feb 2020 11:25:01 -0600
Message-ID: <CAH2r5muBesAGGsraDLsnt9Kq1pqLqRg_kbRMEQCPj3HcsiT79A@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix rename() by ensuring source handle opened with
 DELETE bit
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

added cc:stable and fixed the commit id for the "Fixes"

On Mon, Feb 24, 2020 at 6:28 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Steve,
>
> Can you add this fixes tag if/when you merge this:
>
> Fixes: 8de9e86c67ba ("cifs: create a helper to find a writeable handle by=
 path name")
>
> Thanks
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
