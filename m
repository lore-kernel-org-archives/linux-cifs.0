Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C4CC43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 04:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F749206DD
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 04:10:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y/cTVNHI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfCEEKH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Mar 2019 23:10:07 -0500
Received: from mail-qt1-f173.google.com ([209.85.160.173]:33404 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfCEEKH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 4 Mar 2019 23:10:07 -0500
Received: by mail-qt1-f173.google.com with SMTP id z39so7683123qtz.0
        for <linux-cifs@vger.kernel.org>; Mon, 04 Mar 2019 20:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CLb4LswRAModR6Vrc0A34i26eWlBzSp3U+KdkHaX30c=;
        b=Y/cTVNHIKNQEKMHUAlgoHLo0EzMDrN8bCwX0IqoSKONiEch+bW+HOEqu6GDyN6fqWa
         vwlr4yjT12k2cndujwIsVMS8mhldwa2gMCpKngrEetZ2o+BLHzWFUpSlzTxVUzNHzTId
         qqR8bVOc8Mo+eF3iYHpvP7FHQygQB/U3ZqAUg21yHijzBLtmH+Zi8tZAS08nSBUd0f4M
         ngWXKkdpJiKwWikmxtbBZigG4B9Quf4vFdHoOrujVSGLKD+TG1CBuZS5V/aSAGsrXaaW
         kwOk73og6MH24qVtl5gBT/g8kqmYn6XPEu1khTeR859Lgacj8K5HaUwQpFlHRxZNed+I
         6Cjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CLb4LswRAModR6Vrc0A34i26eWlBzSp3U+KdkHaX30c=;
        b=gdFPiQ8O0qbKS9CN9I8VF0lwqdZzITbmHDR/DSiTnYhDT5IBFIAQQ+RIhkKlac6RT1
         FlXPLbz44tN02L7CxUUDkIMbPiczh7qEC96XUBIFkikZsUEy/phqgfQcBZozN+mGajqj
         AFdQN+W0FI/mDJ7Vx14Cny4ongyiNiW5ojUG+Ww9QX0m4qhVmaCWeULvJ8gnyg+M6ubn
         TSmeUS/Rv0k3yXbxv0wr4pydnhOxveYXcX7khRjhSuwIHPXkSXWS2pIaM72XExDrazKc
         MiLhrYR6xYIpNucEySzHrk5cXrdCvRx6mf4+mNAQcNGzeqWQmRSuQoONWe3FKWG8kv4J
         D+Bg==
X-Gm-Message-State: APjAAAVbL7GnA2MwYL+AQzTOkHkNJyTfX4RJFv4lhLcv8UA/0kPnofKj
        kkeJZcnBWYdA5q/jkpEy8+cUg0k4MfEzcPU14OU=
X-Google-Smtp-Source: APXvYqyDkjWaFUL9eEUBy48hNzixTdg3ywfNyiCxDyrm65/wB52IhKNgPaXnzrQdAiMAafdehAyAJQa6p+sv3AaKp00=
X-Received: by 2002:a0c:91a9:: with SMTP id n38mr568371qvn.171.1551759005863;
 Mon, 04 Mar 2019 20:10:05 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muJYvzg7-HEa1_+Zww3QFBgiL-L6oGBDMiP4TPC5GX2BQ@mail.gmail.com>
In-Reply-To: <CAH2r5muJYvzg7-HEa1_+Zww3QFBgiL-L6oGBDMiP4TPC5GX2BQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 5 Mar 2019 14:09:54 +1000
Message-ID: <CAN05THTyukBUmbLu-pB+xjLQDq_LByxz=twkUEP1hktGdjdbBg@mail.gmail.com>
Subject: Re: More tests added to buildbot
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

generic/469   does it work for you?
It fails in the tests.

I have tried it locally and it always fails here. With current
for-next as well as for-next as of a month ago.
Same for xfs-tests, with current as well as months old master.

Lets remove it.

On Sun, Mar 3, 2019 at 3:05 PM Steve French <smfrench@gmail.com> wrote:
>
> Added four xfs subtests to the cifs-testing buildbot (and 3 of these
> were also missing from the Azure buildbot so added them to Azure as
> well)
> +        [ "generic/464", "smb3"],
> +        [ "generic/469", "smb3"],
> +        [ "generic/524", "smb3"],
> +        [ "generic/528", "smb3samba],
>
> Testing the three new tests for Azure in
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/105
>
>
> --
> Thanks,
>
> Steve
