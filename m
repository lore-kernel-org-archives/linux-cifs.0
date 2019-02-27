Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB25C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 19:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EAD42133D
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 19:30:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sy+x/4Tr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbfB0Tac (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Feb 2019 14:30:32 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37234 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfB0Tac (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Feb 2019 14:30:32 -0500
Received: by mail-lj1-f195.google.com with SMTP id a17so14906832ljd.4
        for <linux-cifs@vger.kernel.org>; Wed, 27 Feb 2019 11:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KGTPQ31YHzlLwRzpWCXcTwqcb35KpjKVp/7MCWGe7Jc=;
        b=Sy+x/4Tr661zHKIaixc/KrShGZaMLLeCoFw7xiKsrmxn4Sp4rE1H+XZ3Oc3r77RBVI
         gsPq4IIz4Kql0VUMS1IOe0bcYXVe1Utao4h026UY/6Mscikzqayg75Pkjl9ll+9gNKDa
         3GtnYOtU6VzXF0gXliHPvm3YhfEfneXfV0RFDtt033QL+sCRaie4pbbgKjwiqSs4jMIT
         8knxx/Wm2Zn3rWwL4/3Xpi08CZm3BB23TKvwf42LS+b6UQG2YFtWCcvmeAgaBr2z32Bq
         rHYnOAfwqPDqeD3bNN0U1LdvN9nfUz0z2Z3lS/gWgLVBfTjuBPh5+uSD6Fgcph5NyTVJ
         46vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KGTPQ31YHzlLwRzpWCXcTwqcb35KpjKVp/7MCWGe7Jc=;
        b=D7Cy7cziCWPd3BZiUHfumBEoZQQYmM6JjkgoK5dqGsPogErn+JfEJfx1n+lYAnHYCe
         UkmerFnmxdSlWFuoBQAemmvdcJagq0k0L2ouTT9jvXqwX1P7oX1LV46hw6Iiv1THMTWG
         wkbAHZCXrkQdgTVcmeKBO5ZPHh5a7IsIQKD4dCZarA7I3Zw96+NG9xSHwJQxgRoV24DU
         HQ0HL4kgNG4vdn56zpUPGdaKwqhkR62BjYvr98gWAL09dNg9/vTbHTtb5yahJ+9g2Hk6
         iVxxTkt8y3DCcJesJBE9nfCW2PGMBnHLlWIdNWOjspEFCIbJ6WfGqRIM7Yj9+BRXV2A7
         bqYQ==
X-Gm-Message-State: AHQUAuaqh98AZmVWfHSwxPVRzCCwJqmxM8B7+FiJhVUovpGYcaid++Bk
        4cijcI4F2B+RilHhMb3mWGl0nvbbrZDFQyCtQsHks0E=
X-Google-Smtp-Source: APXvYqyCoPBp4/7F42DCyZpPGnOIO5vKv6CWDurFgtiobOltmevpyd1fyIhrZPwsd8x2so2Da+FXS0Bx+Q9W5nEHVnY=
X-Received: by 2002:a2e:251:: with SMTP id 78mr2405711ljc.90.1551295829713;
 Wed, 27 Feb 2019 11:30:29 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mt_bKGxNVCchmwCo-J7T_WqZRW+HXsn=V7c57_s6cBgxA@mail.gmail.com>
In-Reply-To: <CAH2r5mt_bKGxNVCchmwCo-J7T_WqZRW+HXsn=V7c57_s6cBgxA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 27 Feb 2019 11:30:18 -0800
Message-ID: <CAKywueRw7aBj3AhSADbU1pSWuTNa=7LKaXWNPrhB6isf2x-DWw@mail.gmail.com>
Subject: Re: [PATCH] Add a dynamic tracepoint for smb3_cmd_enter
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 26 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 19:28, Steve=
 French <smfrench@gmail.com>:
>
> Allow tracing before sending a command (add an smb3_cmd_enter)
> on the wire - this allows us to look in much more detail at response
> times (between request and response).
>
> See below sample output from doing
>
>     trace-cmd record -e smb3*cmd*
>
> in one window and then "trace-cmd show" in another
>
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>            mkdir-22002 [001] .... 25557.965367: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D5 mid=3D28
>            mkdir-22002 [001] .... 25557.965370: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D16 mid=3D29
>            mkdir-22002 [001] .... 25557.965371: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D6 mid=3D30
>            mkdir-22002 [002] .... 25557.972623: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D5 mid=3D28
>            mkdir-22002 [002] .... 25557.972625: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D16 mid=3D29
>            mkdir-22002 [002] .... 25557.972626: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D6 mid=3D30
>               rm-22003 [001] .... 25563.125131: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D5 mid=3D31
>               rm-22003 [001] .... 25563.125134: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D16 mid=3D32
>               rm-22003 [001] .... 25563.125135: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D6 mid=3D33
>               rm-22003 [001] .... 25563.134590: smb3_cmd_err:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D5 mid=3D31 status=3D0xc0000034 rc=
=3D-2
>               rm-22003 [001] .... 25563.134643: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D5 mid=3D34

smb3_cmd_enter trace point is called 3 times for mids 31, 32 and 33
and only mid 31 is logged with smb3_cmd_err. This is happening because
we skip processing mids in compound_send_recv() once the hit a
failure. We need to fix compound_send_recv() to be able to log all the
mids in the compounded chain in a case of error but this is out of
scope of this patch.

>               rm-22003 [001] .... 25563.134645: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D16 mid=3D35
>               rm-22003 [001] .... 25563.134646: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D6 mid=3D36
>               rm-22003 [001] .... 25563.138544: smb3_cmd_err:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D5 mid=3D34 status=3D0xc0000034 rc=
=3D-2
>               dd-22004 [005] .... 25567.863084: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D5 mid=3D37
>               dd-22004 [005] .... 25567.869415: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D5 mid=3D37
>               dd-22004 [005] .... 25567.869424: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D16 mid=3D38
>               dd-22004 [005] .... 25567.870319: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D16 mid=3D38
>               dd-22004 [005] .... 25567.870369: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D17 mid=3D39
>               dd-22004 [005] .... 25567.871073: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D17 mid=3D39
>               dd-22004 [005] .... 25567.871094: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D5 mid=3D40
>               dd-22004 [005] .... 25567.871095: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D17 mid=3D41
>               dd-22004 [005] .... 25567.871096: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D6 mid=3D42
>               dd-22004 [006] .... 25567.882760: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D5 mid=3D40
>               dd-22004 [006] .... 25567.882763: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D17 mid=3D41
>               dd-22004 [006] .... 25567.882764: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D6 mid=3D42
>               dd-22004 [006] .... 25567.882876: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D9 mid=3D43
>            cifsd-21979 [007] .... 25567.884150: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D9 mid=3D43
>               dd-22004 [006] .... 25567.884278: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D9 mid=3D44
>            cifsd-21979 [007] .... 25567.885189: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D9 mid=3D44
>               dd-22004 [006] .... 25567.885299: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D9 mid=3D45
>            cifsd-21979 [007] .... 25567.886174: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D9 mid=3D45
>               dd-22004 [006] .... 25567.886283: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D9 mid=3D46
>            cifsd-21979 [007] .... 25567.887145: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D9 mid=3D46
>               dd-22004 [006] .... 25567.887269: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D6 mid=3D47
>               dd-22004 [006] .... 25567.889631: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D6 mid=3D47
>               ls-22009 [005] .... 25613.476023: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D16 mid=3D48
>               ls-22009 [005] .... 25613.477997: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D16 mid=3D48
>               ls-22009 [005] .... 25613.478067: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D5 mid=3D49
>               ls-22009 [006] .... 25613.485037: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D5 mid=3D49
>               ls-22009 [006] .... 25613.485048: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D14 mid=3D50
>               ls-22009 [006] .... 25613.490983: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D14 mid=3D50
>               ls-22009 [006] .... 25613.491151: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D14 mid=3D51
>               ls-22009 [006] .... 25613.491898: smb3_cmd_err:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D14 mid=3D51 status=3D0x80000006 r=
c=3D-61
>               ls-22009 [006] .... 25613.491947: smb3_cmd_enter:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D6 mid=3D52
>               ls-22009 [006] .... 25613.494271: smb3_cmd_done:
> sid=3D0xf3f1eab7 tid=3D0xe3c55496 cmd=3D6 mid=3D52
>

Thanks, now we have a great tool to start analyzing client latency.
The more advanced step would be to start aggregate latency numbers and
count percentiles (especially for specific commands).

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
