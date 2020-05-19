Return-Path: <SRS0=BTJv=7B=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C7FC433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 18:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A6E4207D3
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 18:40:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dge1+eZA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgESSkE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 May 2020 14:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgESSkE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 May 2020 14:40:04 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B037AC08C5C0
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2020 11:40:03 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id be9so416239edb.2
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2020 11:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UknPpKlku5M8rptkQykK9c0xQGKmsEJq3TUl7S8JB7k=;
        b=Dge1+eZAGBtGHPOojxuUpFZ3bDu43oqttCndQISndAil//PmRfQXBphrNTKB0BkprE
         GTs/cD5/lR3y+VXUrj9C1xai4MYecGNWopyA5mGPwK5mM27mKvoj6CX3dt8g7/t9h1n5
         Mo0yRNaB4PqIZMK8G9MzXw8N3f+MOsvPD8mEBG2qBoYFEHQTyRvUBeOMNgkHPEOc/O+i
         6po1FWa50YOs+I3MgvJnGu30l0w39+K9YilLlo+46uUxjXDqzLY0Idxg3GSEFe/8YJa7
         Q550vkIpwyg4TQJ90CXLKYW4nlTZjBD6dDAFldT3uZkc45qSGqltNBYvZfpBFFTtjrtp
         Lq7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UknPpKlku5M8rptkQykK9c0xQGKmsEJq3TUl7S8JB7k=;
        b=s+O8r3m04eEW8ubJBLLW8Ux59rJ/CPYzY6sG4rzWW0RbNJucPYHjOueJwb5SxB+zKj
         y4AGOeYgEG6n9S7aspc7DMpYHtL6XfGWHfIj9PJc1qaggMoP4OmR9SS68or9mwRKeMuy
         kHxbmwsCjXKkNE9KTj8k2EXVSvQHQswt8cCR1NcE+vbaXWRm8uiF48Agq2l7WxCHT+bO
         X/uZcEIBMcKC/O65JxYayxUamkVSw0zlGHEyEoVj5sxs/WwCmB8yStQoLOFkEkBXXyvo
         Vm3FYk192fFmrokncKhM6k31ZptNQk7eUID0yawFsri/BwUhf8S1EcqWecOo8UGdVe3z
         HFeg==
X-Gm-Message-State: AOAM530xaq/i0bUGTJ+Tev6CS/1DCNWu/qT9C4v4kx6tyPXA+0UOvB6E
        o2xpwRdnH3ywWV8hxLuDemHZ7dje2raRT9TqDg==
X-Google-Smtp-Source: ABdhPJygDmPwKVZSDJFJdeEC8GxLYPZgTFW+wZKtX4fMnx96e447etdja78HtI+uzJqdpYg8BxYLAlEQ5g6cMpkXyf8=
X-Received: by 2002:a05:6402:1a21:: with SMTP id be1mr225993edb.211.1589913601213;
 Tue, 19 May 2020 11:40:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muydPce3j9R_he3DE0uMhPF-A40J0aPVEOXH-LKdjr3nA@mail.gmail.com>
In-Reply-To: <CAH2r5muydPce3j9R_he3DE0uMhPF-A40J0aPVEOXH-LKdjr3nA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 19 May 2020 11:39:50 -0700
Message-ID: <CAKywueRAJTSSkomV-S7LGtrsBVPjCU_D4D-nC58Z6wZOfoAgmA@mail.gmail.com>
Subject: Re: [PATCH][CIFS] Add 'nodelete' mount parm
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 19 =D0=BC=D0=B0=D1=8F 2020 =D0=B3. =D0=B2 01:14, Steve French=
 <smfrench@gmail.com>:
>
>     In order to handle workloads where it is important to make sure that
>     a buggy app did not delete content on the drive, the new mount option
>     "nodelete" allows standard permission checks on the server to work,
>     but prevents on the client any attempts to unlink a file or delete
>     a directory on that mount point.  This can be helpful when running
>     a little understood app on a network mount that contains important
>     content that should not be deleted.
>
>
> --
> Thanks,
>
> Steve
