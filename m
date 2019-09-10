Return-Path: <SRS0=ZOHs=XF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECD3C49ED9
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Sep 2019 16:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 517132082C
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Sep 2019 16:46:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JVy55lB1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436785AbfIJQqQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Sep 2019 12:46:16 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37911 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436798AbfIJQqP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Sep 2019 12:46:15 -0400
Received: by mail-lf1-f68.google.com with SMTP id c12so14039710lfh.5
        for <linux-cifs@vger.kernel.org>; Tue, 10 Sep 2019 09:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DtydDkET6u9RWaQ0b5P2/ejHrO2lFzMPZy/pbS3RlBo=;
        b=JVy55lB1kt+NyiDh0eHg+x4fjQ8a3ifJ4GzxAmqbtOyceVRn9NnRoVS6UXOF1rwVPT
         6yHu/zCx6wtwpDDo4KR1P33GMeFyan5rjre0T+pba6krPk7EMaM2cHe1i9V2eszeBnXE
         gmTSjf9tEp0EllaT+hPW/HbL74qdOUWcUEquspIptVK5oP6XZ4bOenU2tNMvmauCpmA6
         xE4FNKNPwRsNTnsdOhtQU+v3Y2ue7y9GGagCcXqez3FW7YBwB2mFFLRalm/0X/6Mhpi3
         K5c+/gCTrkjm2p8Wf2e8FLa4KsYh0SbbVvAGcqWytpP+CqviAqJpALIiJ6q8EsqxAW9B
         PYKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DtydDkET6u9RWaQ0b5P2/ejHrO2lFzMPZy/pbS3RlBo=;
        b=dCj7o9IE/wbGqg4YvVXJ5poG21W+1lwuI3PqUO4laClz/9Ja3S/vWhCZrG82nJNoph
         xkU9LrFdZfy89xLd1tcycjt0vHQgIkFiEEpiVEiqj/fz9n9CfOy3ouCml/In/5KO90sM
         xdd2YfKK0z3G2tnue6hsBtPGqR7V+G7mUxYVbxQ4HoAMPZN0ilxnNBW8qw7NoFBLg5As
         rGzJmPC+RNPcxTW9VfOEGFLWQn09rpGl34IFdDPLB322PXoR7n3YusxPwKDHMOr++Cpn
         xt0l+qExQp27WMxyFqjzKfoljG0NFAs+fUiEsPscKI5syFrEpmZIPIrUWFxduECHU7XY
         AXMw==
X-Gm-Message-State: APjAAAXEnPKQpVy71x6WeEcPkVmoWC1i2Gw0PvE89SSEabsw8QM9hr7N
        C0+lTM8uJ4U/XwxFseoSZ6phVPrUgdrzD9DDBuBFUmg=
X-Google-Smtp-Source: APXvYqyy5tgZF61zfNth1+LF+y9D8eHMXDQzrtX4rUESVgM605RUusOLeDoIEVwde81cGWRZVXh+jb/zOe31xanijBk=
X-Received: by 2002:ac2:4117:: with SMTP id b23mr21505262lfi.36.1568133973814;
 Tue, 10 Sep 2019 09:46:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtcHR2BpthaubPNgC8fO4uu2d7QkYraMAK3cFOciR9g2Q@mail.gmail.com>
In-Reply-To: <CAH2r5mtcHR2BpthaubPNgC8fO4uu2d7QkYraMAK3cFOciR9g2Q@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 10 Sep 2019 09:46:02 -0700
Message-ID: <CAKywueS3S_DPfFzENhHDQqTQ+aazbAPMdwVQX4nzDG63tuHsdg@mail.gmail.com>
Subject: Re: [PATCH] Display max credits used at any one time for in flight requests
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

server->in-flight is the number of requests in flight, not credits.
Even for multi-credit requests (READ or WRITE) we only
increment/decrement this value, so the following change line should be
updated:

+ seq_printf(m, "\nMax credits in flight: %d", server->max_in_flight);

with 's/Max credits/Max requests/'

The description of the patch and the title need similar changes as well.

--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 10 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 03:42, Steve=
 French <smfrench@gmail.com>:
>
> --
> Thanks,
>
> Steve
