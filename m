Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B10C38BE2
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 19:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A5F62080D
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 19:39:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q9kRuf9J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgBXTjl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 14:39:41 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46978 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgBXTjl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Feb 2020 14:39:41 -0500
Received: by mail-lj1-f193.google.com with SMTP id x14so11410999ljd.13
        for <linux-cifs@vger.kernel.org>; Mon, 24 Feb 2020 11:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kYOMPSsxvVzfVid8qwJEguKtkDtd6InQllJLWbdjL+U=;
        b=Q9kRuf9JuXoqdDeZbWF/TgCeS7sueMbUhtG2aLLPvFJF/2lMNyVtxL6NSsHiRiP0Vy
         /azMWC2woXw4gI2G9XV7NVa7bgErkJLNoyDNc8EHS9Ubux19mioRTktsBdoZg9Bhi94O
         fhpW6aKtmJMQqMa95yTbylUR20WTZ/TG1IW2SIlF4dAw4chpYGtbcdPbb3TtxtqtGfkV
         Br9OznFhcOBrc3IIxd6x+NlOMNVWlFbzIrAmWGRStL3zXWV2je86KrQggt29GHInRgkW
         0o7ZYunao4fnbp/hqJgB1PLYprDhJinYWDs6vPfH1ofjBhRDHFPpND46aI60M74nM0NH
         e7zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kYOMPSsxvVzfVid8qwJEguKtkDtd6InQllJLWbdjL+U=;
        b=bywBzUm2UOxIWvH/9cdq8BBLeZfOu8uaWIxdjSqOFDTu039IduXBLTbUwCyVM/oooS
         6FXx2KhX0sHFhSp1FvRZxvm+YgXxjZ7l0T2ORoYkpJCzx4QHD57LnwSefwCyexaGcMKZ
         Atn+De+VOlrGzZwONy9bPVKffnbm2HBhHrq/vymuOlPCNL+vNNq0F2vhGmajQ7niPqjw
         i6c9JYjNqs6+Eoav1kAe/YBS5Ei+WZHIhqmZTBSsvGydBOrTmbQ9zwqGJmgLdirs2LQk
         uiOb+P3eA9vRxuT9pKFVZOCfaG/onS/1HPwusA945AeuqdmiEr9U1/HtlGXp6VK4pIa6
         4QEw==
X-Gm-Message-State: APjAAAUHqjzl0/W4qkNG/pF1QRD7tslh/xthL+dQiP5AasSgxwq1yV0S
        jbKvYDW64rzkjyJFaBLkslhrmH7VaZF75cLEV7w9Prs=
X-Google-Smtp-Source: APXvYqwyhaQHtw2W385V95AZ4o3p/Niy+hn61o6vCLj65xISTEFhs4SURfYuIVfxD/lfK3bjZtCNtD8f9WIrTTlQhcs=
X-Received: by 2002:a2e:556:: with SMTP id 83mr31209374ljf.127.1582573179487;
 Mon, 24 Feb 2020 11:39:39 -0800 (PST)
MIME-Version: 1.0
References: <20200214043513.uh2jtb62qf54nmud@xzhoux.usersys.redhat.com>
 <370134c148a5f4d12df31a3a9020b66ef316a004.camel@kernel.org>
 <20200214142836.2rhitx3jfa5nxada@xzhoux.usersys.redhat.com>
 <CAKywueRV8+8qVP6e5nsvbpMQtwDU5mQGw5h51w=5rOsCN+Oj0w@mail.gmail.com> <20200219021039.3mpkrmvipd6z3wes@xzhoux.usersys.redhat.com>
In-Reply-To: <20200219021039.3mpkrmvipd6z3wes@xzhoux.usersys.redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 24 Feb 2020 11:39:27 -0800
Message-ID: <CAKywueRvfABoVrdipic6x5_V31K0sOqs8T5y9VzJuyB4Q40bUQ@mail.gmail.com>
Subject: Re: [PATCH] CIFS: unlock file across process
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 18 =D1=84=D0=B5=D0=B2=D1=80. 2020 =D0=B3. =D0=B2 18:10, Murph=
y Zhou <jencce.kernel@gmail.com>:
>
> On Fri, Feb 14, 2020 at 11:03:00AM -0800, Pavel Shilovsky wrote:
> > Also, please make sure that resulting patch works against Windows file
> > share since the locking semantics may be different there.
>
> OK.
>
> >
> > Depending on a kind of lease we have on a file, locks may be cached or
> > not. We probably don't want to have different behavior for cached and
> > non-cached locks. Especially given the fact that a lease may be broken
> > in the middle of app execution and the different behavior will be
> > applied immediately.
>
> Testing new patch with and without cache=3Dnone option, both samba
> and Win2019 server.
>
> Thanks very much for reviewing!
>

cache=3Dnone only affects IO and doesn't change the client behavior
regarding locks. "nolease" mount option can be used to turn off leases
and make all locks go to the server.

--
Best regards,
Pavel Shilovsky
