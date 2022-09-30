Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F2FC433FE
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Sep 2022 03:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiI3DpU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 23:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiI3DpS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 23:45:18 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C981128A31
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 20:45:17 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id dv25so6484128ejb.12
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 20:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=jJyD5Wkuii9vVebwcAbHf0PRQZ1yVzaMcDij7twYn7U=;
        b=Ljwk4wsj8JsXEMPboz/CZ7Xfmy1CxYsboNRR8SiX/Dm638CDZ2V3n3zHXFjt8X1v2Y
         uUiv7foYTMeyimJU0RCZE3kYaTYwQKxI141hMUQdv7SKJ29QMiKNHxoDbsXHoLEi/eDd
         MOFrHUMopSyisfUZOZLlUTnf/WWPvHDuCkyNvcE1vCFS3m1ffNQgB7x/GuXs6DCtE8QU
         TnaBUL+GyaTPOb6FejlTdArD6rBJ0X3bN88rpfnLCzLse2gsInQShyipa7GWpeZQKZ4I
         QxQ7LKrGsfrIIsfcekpA/qvWoxUDKgJ5RvF4z0Zjxp93z4akb8JqZU1QOKtUpptJXDLY
         5QfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=jJyD5Wkuii9vVebwcAbHf0PRQZ1yVzaMcDij7twYn7U=;
        b=xf3QeeWeVPpnspAn+iSQdLTz2sow1cOrdaAg5J2vQ4e+k8CyBlNl0jkAsfmkVsgO3D
         EqcCn9KQc8Z4dhCPSbHUcuISoYt1aGEPFpmgeuBzmDSAHdY+Am/Nd2LzXdU9Jv7UkxFr
         qh80ScNCkeNR+XmIwsfLujpF5iHeCU09VzFhABef66gSEX8q/uipuLh22VkRQ94zKQkD
         AkjsF+b3QAlvpWi/yJDk45gYMdMQXZBqQlWe6J6AjqgHHHVaGyNjpJglfO+Bndvzy/vb
         vGhUpfpIw8H3uGH7z9Ul76fev4AT/1+smfycF9K3POM9jgfcU7tYM4UkkE8AjiXE8+Qb
         KuKg==
X-Gm-Message-State: ACrzQf3/zth8uGcK965RGd0W5Et+rXGkoo0dvmQ9rp4mXKRkPxP0Z/DA
        NxGFryOP4ru0/dA9woFhDPFBVezrFSc7QdRpsejFMEGO
X-Google-Smtp-Source: AMsMyM7eD6Xb2Oqt4eCURuusw5SeMaK6kqCl66pc7+7Ubigymkelvg1bXfs2cqbhwhHF9ViD5KXwCYmL8yBG1TEISTs=
X-Received: by 2002:a17:906:a0d3:b0:73d:be5b:2b52 with SMTP id
 bh19-20020a170906a0d300b0073dbe5b2b52mr5271539ejb.727.1664509515634; Thu, 29
 Sep 2022 20:45:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvXmjiY25wcUYM=8-MbJjaO3=_dziNwc6i1n4qW00N0kw@mail.gmail.com>
In-Reply-To: <CAH2r5mvXmjiY25wcUYM=8-MbJjaO3=_dziNwc6i1n4qW00N0kw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 30 Sep 2022 13:45:03 +1000
Message-ID: <CAN05THR61htia-nCQasJLUvgMBAsU==QU4_9iU2dFgg_-VVCLw@mail.gmail.com>
Subject: Re: Kerberos mount testing and buildbot
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 30 Sept 2022 at 13:15, Steve French <smfrench@gmail.com> wrote:
>
> I noticed  we should be running more tests to kerberos mounts e.g.
> cifs-utils/102.
>
> Did I miss any?  Any thoughts about running this as part of the main
> cifs-testing group as well?  Adding more kerberos tests?

That sounds good. In libsmb2 I had issues in the past with kerberos
and gss-api wrapping ntlmssp and in this combination neither sign or
seal would work
because the combination of kerberos implementation (mit) and ntlmssp I
used could not provide the session key to the application.

I think at the very least we should have one test to verify kerberos
with krb5,  kerberos with ntlmssp and also in combination with both
sign and seal.
Not all tests, it should be enough with one test of each case and that
could just be to test we can mount and access the share, so the
tests should run very quickly.

Possibly we should have this small block of tests against all servers
where it is possible, Windows/Samba/ksmbd/azure

>
> We also need to create a test group for very current Samba (and also
> ksmbd) running with posix mount option to make sure we don't have any
> bugs show up as they continue to finish up the server side of this
> support.
>
> --
> Thanks,
>
> Steve
