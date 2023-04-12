Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B825C77B6E
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Apr 2023 16:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjDLQ1z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Apr 2023 12:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDLQ1z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 12 Apr 2023 12:27:55 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A62410CC
        for <linux-cifs@vger.kernel.org>; Wed, 12 Apr 2023 09:27:53 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id sg7so41711147ejc.9
        for <linux-cifs@vger.kernel.org>; Wed, 12 Apr 2023 09:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1681316871; x=1683908871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LlbBUU3Heh2HbQgGaI5PMM5WO9GB4tDWoyyHCpBYNx4=;
        b=efCuKwNHI+e5ttjxepW1uvimCACd89PmCHF1VAnRqej2/xLnn9b8tpJu36F2CiP0yr
         Mep67bOSUqLiuHmV6LGR3innHFLBaL5lRzkYPl4+RyyWC7AGHf6ZvvLwLkZlMxLZ967B
         rsBZ88WVUh/FexU/p8WdLfDSH8dpH1Gbxfd/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681316871; x=1683908871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LlbBUU3Heh2HbQgGaI5PMM5WO9GB4tDWoyyHCpBYNx4=;
        b=QuNFU3fQMqXYu4D3ihHEp6gQSk5TMPcbx41Wqg2bF+mrMkucsa1iSqI2DdgCNYRZ9U
         /JeDEaYOZrxHR4bAFOiozgAGKQHtuD2gq4UcHRh5SoKKAqMN4B3m7snwL18UajH4OBf6
         +PHxpZ79XF5rK4PQPvnubQ9e6SMQD2o0iduPRleZsjSknT+qnBiObieqjJa9yzre2mm2
         hmFTF/q0bJR2iaD+j83Il8mZsODQK7mCKzMTyWMPRLpR5tFnrTV9ewtKUItwtKKlVaL3
         TAUNv2XZiRb2dRXjC9MNIfAQ9P1OzZC8WRg+GBgE+QHEpIbA8cKeZ23VWy8NGJGSrM+6
         r4Dw==
X-Gm-Message-State: AAQBX9dLFhG52vtwnypHwBPht10t/BI1XrAIb7DflpBJ0pwfBmwQvvw2
        QQUMtL7pPXuu7yhMF23SpKASCCbpKaq4EOo0uKNcXw==
X-Google-Smtp-Source: AKy350bJqqdjefv8q1cxn4AIh2NsDELLHFv50m9W/TGgK5NLJCKnW6hseZirEa+8/nI6jjvhXocvpw==
X-Received: by 2002:a17:906:2a48:b0:93b:1c78:5796 with SMTP id k8-20020a1709062a4800b0093b1c785796mr13441278eje.43.1681316871401;
        Wed, 12 Apr 2023 09:27:51 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id m15-20020a50930f000000b0050477decdfasm6153080eda.3.2023.04.12.09.27.50
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 09:27:50 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-504718a2282so3681661a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 12 Apr 2023 09:27:50 -0700 (PDT)
X-Received: by 2002:a50:9fa2:0:b0:504:81d3:48f with SMTP id
 c31-20020a509fa2000000b0050481d3048fmr3195779edf.2.1681316870239; Wed, 12 Apr
 2023 09:27:50 -0700 (PDT)
MIME-Version: 1.0
References: <110100.1681301937@warthog.procyon.org.uk>
In-Reply-To: <110100.1681301937@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 12 Apr 2023 09:27:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjJt-6_PJ=hm2_TzwVHcWSatMCiByrFiUizpteogGNibA@mail.gmail.com>
Message-ID: <CAHk-=wjJt-6_PJ=hm2_TzwVHcWSatMCiByrFiUizpteogGNibA@mail.gmail.com>
Subject: Re: [PATCH] netfs: Fix netfs_extract_iter_to_sg() for ITER_UBUF/IOVEC
To:     David Howells <dhowells@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Apr 12, 2023 at 5:19=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> Could you apply this, please?  It doesn't affect anything yet, but I have
> patches in the works that will use it.

Applied,

             Linus
