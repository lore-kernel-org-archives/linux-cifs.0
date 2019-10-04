Return-Path: <SRS0=e7DE=X5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA495C10F14
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Oct 2019 00:21:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEE5520862
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Oct 2019 00:21:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="imlmDu4R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbfJDAV6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Oct 2019 20:21:58 -0400
Received: from mail-lf1-f45.google.com ([209.85.167.45]:44587 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730098AbfJDAV6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Oct 2019 20:21:58 -0400
Received: by mail-lf1-f45.google.com with SMTP id q11so3154965lfc.11
        for <linux-cifs@vger.kernel.org>; Thu, 03 Oct 2019 17:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DvWimnm16b3bqPmod3i89DpArW16zTxOuKvtcXsDPr4=;
        b=imlmDu4RCjXhYCo04eJjsfiClmtoSkI0RACqdj6gw8ejAfpXeXioost/UKgVM3bgUD
         ZW0LOD4MWUN6s2UMW+Z0WjbS7QrqVT2IzYXrr2WG3HfL1fhQE5TppToGD/1mc6Zz5aUS
         4ct+E2s/HNwk+ha/mERN3xZf18Q/VIjJI5sTZDLMJ7IaPx1ivim3VByeJyxDQ0sM5bF7
         S2v/pM+wfg5ZOidArIyWPCGoerRPVKm1jUHmnrJKcPIa8+JwNBnbsz4U6hpbc6tayfwq
         MEESi8JLfktMb7rCha3rJP8/HLbv8Xk0UjOd5RsY6dvx6NKXJEozQh4UXiQ8UmOXalmu
         RKow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DvWimnm16b3bqPmod3i89DpArW16zTxOuKvtcXsDPr4=;
        b=lPLrsIPls4nBaI+DW0+q9oRQT2+1dQHX5bBfVTV9BGSgs0sNY2Wr+C1OOg3zTfZQYj
         j4VJ8MFf3KJl8LbZaUgW9WtLOjI8hwXkjHLsWm3iLrt9WEZ48f/9pDJgw2IsMF3KdTkb
         Pv887A1imHluLdTQaK7KLd3FvpuejxSlSPVNSWHmK7DsS/Owyo+/IMJNllYA3+e591hy
         ULIrIsnUfI45BBEoRdcLYhnJHZ0o7vjMWCbYlWRlLmHmZr23ZM+E4QeZrbjl3SsvtwBG
         BUuzxU/YBJ4W5g/HHkvgE6iOkl7yO4buwR5O/UCx8bPjEJzVpR/QLaLtrVoPYx0oNZGT
         ZqUA==
X-Gm-Message-State: APjAAAUt8B+Dk9B+9pRP/zveXyiXNJwz99V0vLMI0lKvMM3pMD5mLHpA
        ZOtNcmxSCrN4xkykF0/9IBGrXTFK11zacqp56w==
X-Google-Smtp-Source: APXvYqxgNqrER0ObirqCA2yomjsELvfP0xpCwrHkURjot6U6htqjamv4DkU1bzYWd3u20NRMOV2yeMZ6wWDnwgiY5ZU=
X-Received: by 2002:a19:ae0d:: with SMTP id f13mr5630546lfc.36.1570148515981;
 Thu, 03 Oct 2019 17:21:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvfb3nkdz8r8sAUXGJkx678XZkt4dn=4xiuq0UD2vxFrw@mail.gmail.com>
In-Reply-To: <CAH2r5mvfb3nkdz8r8sAUXGJkx678XZkt4dn=4xiuq0UD2vxFrw@mail.gmail.com>
From:   Pavel Shilovsky <pavel.shilovsky@gmail.com>
Date:   Thu, 3 Oct 2019 17:21:44 -0700
Message-ID: <CAKywueQ2rGannA7Mi-7j02E0aDN5KYGCLz5faHUDKhC+zp2ODA@mail.gmail.com>
Subject: Re: [PATCH] smbinfo dump encryption keys for using wireshark
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged, thanks.
Best regards,
Pavel Shilovskiy

=D0=BF=D0=BD, 23 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 21:51, Steve=
 French via samba-technical
<samba-technical@lists.samba.org>:
>
> Updated with feedback from Aurelien and Pavel
>
>
>
> --
> Thanks,
>
> Steve
