Return-Path: <SRS0=5TF8=26=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00711C282DD
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jan 2020 18:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C07DE2072E
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jan 2020 18:30:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UaoVqme8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730890AbgAISaD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jan 2020 13:30:03 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43644 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729648AbgAISaD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jan 2020 13:30:03 -0500
Received: by mail-lf1-f66.google.com with SMTP id 9so5919626lfq.10
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jan 2020 10:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MCSrDHZHZx6RhMZE2+Je1a/5ofwAYFbx6RT8eoh/lxI=;
        b=UaoVqme8Xcy9V3p6VsXYDT2UaTYoyEsEACUJSYwTGp7xMfuayJmnTtkwEDlTJl3maT
         D9lP7JdZjurYxB1GmaJSiav3tw/0l/m+XO0nUwCINSFqA+iAwEBynR1nKxiy/L2LwqFp
         4E4IIeH8WbZTjslvDWSSv0lLHIyprLUzaSvfg2OJAFPBo+3XEzIpZkP9x3L4eV2E6SPD
         O4lltRwR7g7qQ18d57lj7gyYqgNR7K96pcsW4mnj4cCvRmrduGUn5GG0OWJq1qpRhThJ
         pcCHIQBPhLOA6O1TakSwGqaF+ceyqL3mII+erdmJg+oO1dBemekvMYBhh+yfdK9XI+bP
         skhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MCSrDHZHZx6RhMZE2+Je1a/5ofwAYFbx6RT8eoh/lxI=;
        b=Ix5ErDGAGavSk3baQo2JSk2Tb+4DPUQSQPQovmEx3xK7pRp3V5H4lE4QJqi4cx9AkN
         70IHF7CVAkub/88WF30q1MjBejdoRTdI704QKwNSZ/2PzMgNYHFzB5Lmiqn8KoChTUYM
         q8wW0ZnDUJlH07Oee5MOQ59jtAEzrQWftVCWrp6R3xjsgU7DMOR/SggWnmLZVu8ctsf8
         QrGkwXwNTDGbWsR4IE7OJcL7fVR4Y/OjfV6UJ1H5G1Jz8bEchvFg7UqDwGA1d0DzXJGF
         Rw4LeMJUnqE8oYQ9urLw5gW099HLK7jrnwd3pKOGJ5a9CF1wfXWNoew2755wQceA0xyX
         0z9g==
X-Gm-Message-State: APjAAAUzN1GcRD7GgihOT3XdRK40DatEyl+DnGKNbjmNG3mzA4Tr7gk6
        W/8lRkRiVytZ8jA8wvbqSgYAgmuR24HgPL7l/Q==
X-Google-Smtp-Source: APXvYqzI+v3lmB4Xu+Swv/657Qmi/qR+yawJXSfba9wxut1/eoXKumroTaEgLxpbOX+bRcS1iJ9VI59eREOshwDcXTY=
X-Received: by 2002:a19:c148:: with SMTP id r69mr7389791lff.142.1578594601248;
 Thu, 09 Jan 2020 10:30:01 -0800 (PST)
MIME-Version: 1.0
References: <20200106163119.9083-1-boris.v.protopopov@gmail.com>
 <20200106163119.9083-2-boris.v.protopopov@gmail.com> <CAKywueSK-_zzF-K3_ehmLT3yje_hGaQU-1z-G3hYugMv3ZV-eA@mail.gmail.com>
 <CAHhKpQ7PCQXgvXkjTUuPtX2OHVxee9seGyRT=omJXvZLt3=ygg@mail.gmail.com>
In-Reply-To: <CAHhKpQ7PCQXgvXkjTUuPtX2OHVxee9seGyRT=omJXvZLt3=ygg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 9 Jan 2020 10:29:50 -0800
Message-ID: <CAKywueSXxYxZLDAXPwsHTyUSHyWV5WmssOwvo7xF-Wgf57XEsg@mail.gmail.com>
Subject: Re: [PATCH] Add support for setting owner and group in ntsd
To:     Boris Protopopov <boris.v.protopopov@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        samba-technical <samba-technical@lists.samba.org>,
        sblbir@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 9 =D1=8F=D0=BD=D0=B2. 2020 =D0=B3. =D0=B2 08:07, Boris Protop=
opov <boris.v.protopopov@gmail.com>:
>
> Yes, there is a patch that I have recently posted to linux-cifs and
> linux-kernel list (subject line "Add support for setting owner info,
> dos attributes, and create time") that enable setting owner/group in
> ntsd, file native attributes, and file create time.

Thanks for clarifying!

We need to make sure that the appropriate error is returned for old
version of the kernel that don't have the patch.

--
Best regards,
Pavel Shilovsky
