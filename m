Return-Path: <SRS0=jrt1=UG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 368DBC2BCA1
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Jun 2019 21:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E89B5208C3
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Jun 2019 21:24:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EVK8M02Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbfFGVYN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Jun 2019 17:24:13 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:43913 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730204AbfFGVYN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Jun 2019 17:24:13 -0400
Received: by mail-io1-f54.google.com with SMTP id k20so2502736ios.10
        for <linux-cifs@vger.kernel.org>; Fri, 07 Jun 2019 14:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VDnA7G6oEfycCISMp+y58zaY4Y2dGvtqHh5KDSqa5A4=;
        b=EVK8M02ZV1vR7lHfj/Z7ku3d1GD30vGAZeAbk42Hiv7j8RJMlzdV5rj3EFi+OR6uwy
         /o4To+6eTjBqJl9MvcFtkPfzcvUSlM/uCSGeHs4Cstb9PRSK8QNnHbkOjx34smOMfzAW
         EQfRvgnWvf4sMbAz/f7mF5+crhQjiUE3MvD1aP1hy27EQidLbvh+TTSIR2OpqZ0yZpiF
         KAoKykp8TPzMFzo1cFpkJBde0Bpoutpv/6kRx+5NfGEjQ2FGyIxMSvCGvQuePN2ppXEA
         V5gOXiMCJYlrOio8YyENyvW6A1RnT8unOp4p5XCGUHpV+fq5ZbqzBO9ud3/+xGECgOMO
         Zxeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VDnA7G6oEfycCISMp+y58zaY4Y2dGvtqHh5KDSqa5A4=;
        b=XIVpZuWkWEZqF6jj4notmjLLZcF/A16jyey2XEvPPfCIfDKFpnxQ+EenKumOEQdFNS
         JPVYlVxwgJdTgcMTb6Kbn19kJdghuZnkvnX0I3oSHPYAE/RlFajmNgazDJ9YtCwXsKH4
         giapHg06q6n2S5rmn1iLQQvQ9L55Cm4j+pROfn4K8QvWSW34RG7uKpN+QgQ7L8Xy6V/H
         sI5Z+CQ7nBG/9OghV6H+KrkUknGBQ7smUz2+EXQXqyfqVfgHxik2EN+cX02TrKaCoSTl
         qwksX2wyTbFLrEuZCBodtcSpbmSu1U1cHxef89x8mbqVJIk5Yz8xbLwj/9FwW5S7scvx
         4wPw==
X-Gm-Message-State: APjAAAXPGiZzc1/vc3Phbg55aasIporybxLNQkM6FAakyvzWsjttbh/d
        sXn2qZ+k6kKduldmvdhtMKHqE1D8MqJ6mttJZhk=
X-Google-Smtp-Source: APXvYqyh3SBLLyE4XRupeW0yPO1XrHgOpW2cKgu2XEQB9/f5/d1ZIFgt2VXu3N1AiFfwEaCNuy2KrKkTRny2WKyWmbY=
X-Received: by 2002:a6b:4f14:: with SMTP id d20mr19168204iob.219.1559942652611;
 Fri, 07 Jun 2019 14:24:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvA3t2Nm4F=LuBwHkN+E19pHuiLaSv0JV9SMNYvZrxAiQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvA3t2Nm4F=LuBwHkN+E19pHuiLaSv0JV9SMNYvZrxAiQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Sat, 8 Jun 2019 07:24:01 +1000
Message-ID: <CAN05THT93RGGqECaQjpBJzo7cQWyxfsSNh-3nX+WqagjeZN8wQ@mail.gmail.com>
Subject: Re: [SMB3.1.1] Faster crypto (GCM) for Linux kernel SMB3.1.1 mounts
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

First patch, fix the comment :
+ pneg_ctxt->DataLength = cpu_to_le16(6); /* Cipher Count + le16 cipher */
to
+ pneg_ctxt->DataLength = cpu_to_le16(6); /* Cipher Count + 2 * le16 cipher */

You can add a Reviewed-by me.
Very nice!

On Sat, Jun 8, 2019 at 6:24 AM Steve French via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> I am seeing more than double the performance of copy to Samba on
> encrypted mount with this two patch set, and 80%+ faster on copy from
> Samba server (when running Ralph's GCM capable experimental branch of
> Samba)
>
> Patches to update the kernel client (cifs.ko) attached:
>
> --
> Thanks,
>
> Steve
