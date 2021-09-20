Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC89CC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 15:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5D9260F58
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 15:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhITPOJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 11:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbhITPOI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 11:14:08 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F3EC061574
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 08:12:41 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id i25so69791822lfg.6
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 08:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ELxXjTAQXfYlHX0GNqtvor8+zHOUpc0Ttq6m0tY1aC0=;
        b=L9mJANIJTaDDP/p+7q+KsxlNbMY0ADqHQph6YDdgfpDJLs8uex5jZdzMJJ8OHmWxV8
         UyQBA9FhmKE+7RnH5J7ejv0z4FLVLL7nNdkD4rBGApQO47WeW7i2IvmKQ0MsuJv+dI1Y
         trPAynR/F4wSSEIOfyPZySSNSEohaAijCjR10RDY9HmH8KA6IZ+DdiXQaygs263jBooM
         KznKZ96oag0LjcVuQkb2w6PbVnmFAgI3+vW9xFDrxJrkrTQzp28jP5NX5+PbZdu+kfM9
         ohLh0zciEX58PH8LpfIrNskoehM3zJzvQO3mypzkXHmOQrBh0FZw56Urom75R3O62AfE
         NWww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ELxXjTAQXfYlHX0GNqtvor8+zHOUpc0Ttq6m0tY1aC0=;
        b=IfuRJ4RMW58Dty/Xq9wsQLUdxPR3xYMTDjlqs4vrhc3jT1qeCVAKZkubsqFK/e56Sk
         Wj9Tso386IBHvnjU4WD+zMTqVHblnK3o3uGlJPqSOCP+eK8G0g5dM9U3Z11nA2en/V2R
         V4JbdNg0oviRAHZusaDsVphxY1KiTalyiW9ohcGI6LLXTFgQIzH1eZ2s0//UHJVoxWLl
         12C5XRwSUungT3U4SSygm9feM1aa+C0M796Uokv4AAKhnWq/aYS62zGrcgfR2zaab1UR
         3PSzps1cAClC0YHqdhIgMQSyOsctlOVFxl01Znk/d8fbrhJMhbpSwpUJGrmRABw7dxu2
         GauA==
X-Gm-Message-State: AOAM531mwVhui9gNDJSthVlQ/P3pcUo0auP+U3KjX9Pv4CgBoICuXaV9
        FwNAkz+NxNvGaqrqiNSmxwGGu8dL93ii5G19z82fNdPAe1c=
X-Google-Smtp-Source: ABdhPJzoPSrXgnvgYVikp3EU0sQKWqk6gKvtPbRAzCGFgWcEK4iTlILwhgbFo5icPjS9Pcp4xqetxmpM7q1thwFnKOs=
X-Received: by 2002:a2e:4619:: with SMTP id t25mr16477837lja.398.1632150661294;
 Mon, 20 Sep 2021 08:11:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <85871805-c9fb-6df9-be6d-ff57074426a3@samba.org> <27cdc659-cf4d-cc9e-e5c5-6a3d23987e72@samba.org>
In-Reply-To: <27cdc659-cf4d-cc9e-e5c5-6a3d23987e72@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 20 Sep 2021 10:10:50 -0500
Message-ID: <CAH2r5mt8gxSS56kDvmtRTOi7Dm0fXwD6zL45WAP2hw2_TxDPow@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] ksmbd: add request buffer validation in smb2_set_info
To:     Ralph Boehme <slow@samba.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Sep 20, 2021 at 10:03 AM Ralph Boehme <slow@samba.org> wrote:
>
> Am 20.09.21 um 16:45 schrieb Ralph Boehme:
> > Am 19.09.21 um 04:13 schrieb Namjae Jeon:
> >> Use  LOOKUP_NO_SYMLINKS flags for default lookup to prohibit the
> >> middle of symlink component lookup.
> >
> > maybe this patch should be squashed with the "ksmbd: remove follow
> > symlinks support" patch?
>
> also, I noticed that the patches are already included in ksmbd-for-next.
> Did I miss Steve's ack on the ML?
>
> I wonder why the patches are already included in ksmbd-for-next without
> a proper review, I just started to look at the patches and wanted to
> raise several issues.

I included them at Namjae's request in for-next to allow the automated
tests to run on them (e.g. the Intel test robot etc.) - those
automated bots can be useful ... but I had done some review of all of
them, and detailed review of most, and had run the automated tests
(buildbot) on them (which passed, even after adding more subtests),
and the smbtorture tests were also automatically run (it is triggered
in Namjae's github setup).

Of the 8 patches in for-next, these 3 are the remaining ones that I am
looking at in more detail now:

24f0f4fc5f76 ksmbd: use LOOKUP_NO_SYMLINKS flags for default lookup
1ec1e6928354 ksmbd: add buffer validation for SMB2_CREATE_CONTEXT
e2cd5c814442 ksmbd: add validation in smb2_ioctl





-- 
Thanks,

Steve
