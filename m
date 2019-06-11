Return-Path: <SRS0=/HTR=UK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53C6C43218
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Jun 2019 00:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0BFD206BA
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Jun 2019 00:41:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dqql54mL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbfFKAlU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Jun 2019 20:41:20 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:33300 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728645AbfFKAlT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Jun 2019 20:41:19 -0400
Received: by mail-lf1-f44.google.com with SMTP id y17so7952777lfe.0
        for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2019 17:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LTh7h4fwgu/IdLNqhRirFuzkrJkPBdU70QJ+oK60Rks=;
        b=dqql54mLFx32R5XqDQvMgr1zgOL1adNKtsldm+Xn8K8GouJsDRX4S73PXI/+STxyDX
         hBgjfzpoxjwIMcXlOo9cBhUm8jKkW9C9F9sQFHmQsZHiH+PQXtT0g0u5qFGBy9O3BS90
         3YxLTQSULLMQW8dOFzd6eyIDOsD8Uv/cCX9qGjPPticpg0FIvqxINFV5aOdrKezs/Y27
         Jp/BqevykAP6yt9BGqJh2WCk3H8JN42JiykLvykGnumfQAw9a83o+rg6h6H318pde0kp
         5llUGdc3eU6inqwuXrk6OoMNWHcBqbvCWKW+J7xxcHijORey5RxFFB1HP+TUccIFlPcV
         yHdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LTh7h4fwgu/IdLNqhRirFuzkrJkPBdU70QJ+oK60Rks=;
        b=JRio7MeL9oV6MZrrxg1o6Q/P/vwfkY0tZRIrzWWW6SasjgK36Cjwu6yk3mp9oFlbMK
         5F+8ZegKahgklPf9vvi3Ajg52wRgXI2iEP6e0brFtZu8arz2DNJxAJM+Rrz7CZqn02pA
         /HzyBwFGMxqrB5QhIwJ74+v+h/D/53OmWGJRZs2EeqtVbqlKp6YivMj+jFn6RTnB3kb/
         2+5sBrTtLbI6shTYGEksp5vSAI6VOxJ6Bc7FVR7T9Vv1xYTdJjjWXTKrg6Ui8HZN7wxm
         Gg502U8p0aIvjxFeZ9eCceQ7fARf2U13F4cYhgXwFRU7lYxTb7TDk8nlThp3XH3TfGvk
         qEag==
X-Gm-Message-State: APjAAAV5MUlmLGMWQNclc+hQKlfVwf80EAw9nFuEulYY03+s7mddbIaj
        4REFajDUJzpx3LZOL2t1IBGdiEX9PtyBGjo1ig==
X-Google-Smtp-Source: APXvYqx4Wsa/kcO/OivCXZfzgGN/lguwrntS2svHyv0Cu7GknbQV9ZTBr2qZpd2QQAlDN4YqQ8WhLgeFFtvar2lueHQ=
X-Received: by 2002:a19:700b:: with SMTP id h11mr35137919lfc.25.1560213678086;
 Mon, 10 Jun 2019 17:41:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvA3t2Nm4F=LuBwHkN+E19pHuiLaSv0JV9SMNYvZrxAiQ@mail.gmail.com>
 <CAKywueTTp_jQqhND0gpLhffNeXudPUjkWHGEze33+=6oVWhLpw@mail.gmail.com> <CAH2r5mvo5YbDd5Pqu6XcMBAW+4rPX0ZZU9RBj=NWLEFTp4L+-w@mail.gmail.com>
In-Reply-To: <CAH2r5mvo5YbDd5Pqu6XcMBAW+4rPX0ZZU9RBj=NWLEFTp4L+-w@mail.gmail.com>
From:   Pavel Shilovsky <pavel.shilovsky@gmail.com>
Date:   Mon, 10 Jun 2019 17:41:06 -0700
Message-ID: <CAKywueRauK_Lf_NMKJgKr46tLMOgJyk6iWcsMuPx74EJ3cGz=g@mail.gmail.com>
Subject: Re: [SMB3.1.1] Faster crypto (GCM) for Linux kernel SMB3.1.1 mounts
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 10 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 15:34, Steve Frenc=
h <smfrench@gmail.com>:
>
> Updated the patch with Pavel's suggestion and added reviewed by and
> repushed to cifs-2.6.git for-next.
>

Looks good. Thanks!

Best regards,
Pavel Shilovskiy
