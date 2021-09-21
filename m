Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8709C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 03:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDF66611C5
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 03:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhIUDvc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 23:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbhIUDvb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 23:51:31 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084D1C061574
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 20:50:04 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id v22so64389031edd.11
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 20:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=iwATZxMGgzU4GhXhfVcpz7I3yLZTSa6h2lOtUl9sgU0=;
        b=FYv+T+P3CW5sDJDAz/tiQqO4HplkfXDseo5ZP82Z1ihB1CTsTu5qzDVgoJT7UglWdq
         9HTSMLOGPWRQsVHiuHdBeIe725FtvH7eVTZnri34q9RvGNG+eeBORLqUcE4NmIasQkXJ
         UCDtw7ebQArP4NNb7zBTUl34dqDRYQj5CwK0Tpc6udEhaDvDdv1JQOA0ALmkuv3p5GVQ
         FJROtWktv3VqtzA4ABTwDpw4Ox7UUyrOGro8RYT09hbiUttR2WDyEDpoHofTZji1Qdya
         Q/CAa5yaEbqo6O5ypvpWQ4ugY2YxHQhgnCmWEHPhZEgaXGleQYzzmJJZ2HSXMnpDxv06
         Eu2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=iwATZxMGgzU4GhXhfVcpz7I3yLZTSa6h2lOtUl9sgU0=;
        b=Apx3WqZ4X21aBdGaCKSvZPUT7voC3sZy9KL/okjQTO2yfKdDqGOoVmOT6IPtmwEAMJ
         MDdPdEp4jyweZ6rrfQy77hNXQIvtWub55s0F+3vK+n4mC4NXKtTgs2k61IIVzccZci5E
         ODTGEwkmylZKoSt6KONOIbVqe9wjSgmGhNwZDOcXdz2yU3ZqE3c/wD4sHLjT7+3oJn7p
         pW81p64DT9zBIpSJ7HCSn71vkHAL2KWAm2/ZsUih1DA+0eSjlVcZwAXKXCp4LIXE0WOs
         MWHHBbZLMfSkKWq/7u7aXGGsqVRILG5ZfTZZuHX6erEHA6uj6/3wybM6/mhMzsTu5Bin
         ukRw==
X-Gm-Message-State: AOAM530sIgWHHU/a+qrSWbfsQhy4F3jNxlEXwAUdmoPCf1qrsblZD4T1
        WhN/CtryQ1ppkHRSjb1/y1IPgTdpfuUTTLKWidfriq9JsCE=
X-Google-Smtp-Source: ABdhPJxAh/FZioxWX07vWsNqqorqJS41QJaK7u4xOwMwdvorlE1F4wp6S3UcD8dE1cNAkrx8rIRj3A67l77Q3Go8eEQ=
X-Received: by 2002:a17:906:680c:: with SMTP id k12mr33021436ejr.85.1632196201981;
 Mon, 20 Sep 2021 20:50:01 -0700 (PDT)
MIME-Version: 1.0
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 21 Sep 2021 13:49:50 +1000
Message-ID: <CAN05THTGgqcDQJAqf_PVNz=Wj_fH297ATEfmx3bzN3oyTLJqkw@mail.gmail.com>
Subject: ksmbd_smb_request can be removed
To:     linux-cifs <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In smb_common.c you have this function :   ksmbd_smb_request() which
is called from connection.c once you have read the initial 4 bytes for
the next length+smb2 blob.

It checks the first byte of this 4 byte preamble for valid values,
i.e. a NETBIOSoverTCP SESSION_MESSAGE or a SESSION_KEEP_ALIVE.

We don't need to check this for ksmbd since it only implements SMB2
over TCP port 445.
The netbios stuff was only used in very old servers when SMB ran over
TCP port 139.
Now that we run over TCP port 445, this is actually not a NB header anymore
and you can just treat it as a 4 byte length field that must be less
than 16Mbyte.

I.e. you can change it to just be :
bool ksmbd_smb_request(struct ksmbd_conn *conn)
{
    return conn->request_buf[0] == 0;
}

and remove the references to the RFC1002 constants that no longer applies.

(See MS-SMB2 2.1)
