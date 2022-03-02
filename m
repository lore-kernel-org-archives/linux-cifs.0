Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D37EC433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Mar 2022 15:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243447AbiCBP1N (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Mar 2022 10:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiCBP1N (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Mar 2022 10:27:13 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C29B0EAF
        for <linux-cifs@vger.kernel.org>; Wed,  2 Mar 2022 07:26:30 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id t22so2255837vsa.4
        for <linux-cifs@vger.kernel.org>; Wed, 02 Mar 2022 07:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qSJa3FsiYtYzf+xu8j7W4sU7So0HcUGRJaoCS44Jz8Q=;
        b=H+bZkP5wE2z15u7Y40qfTIdZ7QuoupvJ//aymRTAnl+q89qVolWHCNmt2g2SXZj2Bp
         Pn7q1LXxev5VDyu5xMENSP4E4CuaSlNJTfP52MRGqFieVFNKgMHb2T+DKslhfNRMVW4Q
         00W7REVvbXBT3mvQLGy6secG+gUyMryGVtklhoIZz5OzXBHOqMvn8vIH41jXBntaW7no
         DE6X5plGULLrf1YLvct+cbAJNWuz0DwbGXZg80Vm8lo2eSgq8JMqkjoSllNTwlQreF6b
         3eLJMGuu4/V2uMwYTGFmwJlpkPdQ7D3et6LcZsH/jwgGH0Q6xcwlz2dGSeGGlWIk0kw2
         //RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qSJa3FsiYtYzf+xu8j7W4sU7So0HcUGRJaoCS44Jz8Q=;
        b=CGABimcwAZOjv+pxyllsrVU7uegN2hz270WETsGSr2mxl3XEJ1qoYV1frT6TwMCMTD
         hU7miAKr5dkTfoSf1dQbcMTFZohfPETk6acBQWwY6k+V80VF8m7miFLjqA1/480/rgcA
         5Ar3pN2BYzXaUt9k+NTU3VK4iTADQ+BMXwtOO+7kplhBwqKl3FEUWW6K8dYt10SjtEZ+
         hAisP9ZwvI3FRGA5wGJS9TmCaJbwm+suuoJ723hx3ophDwM83rP3rpOLZvtd52K658zY
         lAoEeXbFx1Mj+pI4FfHOub/PlXpeKfUH6kPci4pzF+wfrV0OKukQ4ypsR5pSfrhbaig+
         9JPA==
X-Gm-Message-State: AOAM530c+tmWMxIUoC3BQdrvlfFkWr36e1hjGgmONA2wKEoMU+RbOXMd
        0Fdz9eE2dhemMlouU5nw3iRQS4CEPgtZNmmQky0=
X-Google-Smtp-Source: ABdhPJytbd5JIIiY9tRxcN5wxY1rAEWkAMOb+gqn71Ys99ZtDxQ4/9n5XXMIFlWM82luCQyq00UPO1Xq3WpN7af7sKI=
X-Received: by 2002:a05:6102:5110:b0:31e:bdd1:d436 with SMTP id
 bm16-20020a056102511000b0031ebdd1d436mr2214591vsb.66.1646234789218; Wed, 02
 Mar 2022 07:26:29 -0800 (PST)
MIME-Version: 1.0
References: <CACdtm0Z4crPr868DRGCYNd=euVXzm+T+rPHT4PdqK66TV7iioQ@mail.gmail.com>
 <914621.1645046759@warthog.procyon.org.uk> <CACdtm0ZteTve1EbSgDX_jochhHT7Ufm3gJg7j28BOjmRSg8dTQ@mail.gmail.com>
 <2500957.1646059150@warthog.procyon.org.uk> <CACdtm0amJS+5O4=Qun-xxSK1JoCoVfEbRrpHCJ0QYVa7Tc8szQ@mail.gmail.com>
 <3570270.1646234203@warthog.procyon.org.uk>
In-Reply-To: <3570270.1646234203@warthog.procyon.org.uk>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Wed, 2 Mar 2022 20:56:18 +0530
Message-ID: <CACdtm0b6q0vgfQ4pRuS0JcH=mB6a865MdBtDsfEK4bcYP1B-uA@mail.gmail.com>
Subject: Re: [PATCH] [CIFS]: Add clamp_length support
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi David,

Patches which you posted today are on top of 7-patch series "[RFC][RFC
PATCH 0/7] cifs: In-progress conversion to use iov_iters and netfslib"
which you published earlier?

or this 7-patch series needs to be reworked ?

Regards,
Rohith

On Wed, Mar 2, 2022 at 8:46 PM David Howells <dhowells@redhat.com> wrote:
>
> Rohith Surabattula <rohiths.msft@gmail.com> wrote:
>
> > >         struct netfs_read_subrequest *netfs_alloc_subrequest(
>
> Btw, note the patches I just posted that rename these structs and some of the
> functions.
>
> David
>
