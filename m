Return-Path: <SRS0=9U06=D6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8D7C388F9
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Oct 2020 18:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1092820882
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Oct 2020 18:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603478822;
	bh=fPFyqBC272tQlyZSSjpaakyW/41BEBUvZYxLrHwvbBY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=pEuU/qgFRGKR7o85A65swjzpVrUtRv2s5nOrr85oX2mLfmVGOc7/iiOw0HBLgGweT
	 3SqNgbFfqAC9b2X75sxdNgi7AagwYm4Lqy5o0sa69e1GPyhbxWPu4e1vc+b2W4jKzP
	 PiofFfohkWjhXBusV60Q7gcFJh9oPY0YFyauZuOo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750880AbgJWSrB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Oct 2020 14:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S465814AbgJWSrB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Oct 2020 14:47:01 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4867C0613CE
        for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2020 11:47:00 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id 134so1602664ljj.3
        for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2020 11:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3z4cRBzKdq1xnxZ+nJkFCRoD3Wm2zd2U58jOHQMA/HI=;
        b=gTlGDRQCZ8TLSW1Sh7jsWk8XOTVQBpGyZ2B9HuEj9gnfvwvCoUhy8wTOn1eqO74Vl0
         XNMawyetiZ0ZrCy1uv4a5He5UgHHNyHh3KCU6uFHUrBGDLpuCOQd1iLlEXsFc8fws+GX
         u/oSCPBEE5MTd4jAub0dWjWjuzQR/B0ynrv4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3z4cRBzKdq1xnxZ+nJkFCRoD3Wm2zd2U58jOHQMA/HI=;
        b=Fj58SgU10yZh4/voUJt7K1BJ/fieWQsxSNkqQuPE7LZu2L4D/LPtpMAxDtfqcMs5cR
         QnbMwofXHHT3wGKjYVHeX6wWFV7EHd0R9T+8BYtsR8HKIRJMvvvom2azV2Pudovuav+i
         y41uYiVIJMuBfDxQJZQnGZr5oZM0/X1EHBGAVggvao74nYChGlC8IGwSWfbBNpArYayM
         0VoV0dg1hK+hFdPWFrHsVySe2u2AtcGJWufODZ90lvHTxYDy1RkTqfU1AQDQKxzy40qi
         tEo4t5M7Jrz3r0xrxS4sM5oxrhZU7Kil8VsSEJDzcGraZUGDzG4Mbu8FtP9jt6NwWsil
         XJBw==
X-Gm-Message-State: AOAM531+/GItdAAdZNG83Hxmj3ydoI9/9xsrpfZR4YaJDism1xpiH0Re
        dQvc3AVAQqTJ2OGCiA6fhCxpi+8SPG83ew==
X-Google-Smtp-Source: ABdhPJwuvwMvCgxvMg1D27Oe4Jh96TPWvW6egi07qxPe9ntO8oToE+9ilYGUBq0Q7lx8lBbClduEbA==
X-Received: by 2002:a05:651c:1307:: with SMTP id u7mr1380462lja.39.1603478819032;
        Fri, 23 Oct 2020 11:46:59 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id n20sm210724lfl.249.2020.10.23.11.46.57
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 11:46:58 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id h6so3281050lfj.3
        for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2020 11:46:57 -0700 (PDT)
X-Received: by 2002:a19:c703:: with SMTP id x3mr1115755lff.105.1603478817658;
 Fri, 23 Oct 2020 11:46:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvcYcC19PN4aNXjkDyPsAQ8wgnK-p2ikvhm_zVfTHsF+A@mail.gmail.com>
 <CAH2r5mtpCkH7zb8Q=is3a_fwqkswkcnJJ5XJVss10t_sa7KA9g@mail.gmail.com>
In-Reply-To: <CAH2r5mtpCkH7zb8Q=is3a_fwqkswkcnJJ5XJVss10t_sa7KA9g@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 23 Oct 2020 11:46:41 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgW=io6sfH1yzAakP+NnR3WQ-6kYtxoGfWra-=Fq2yzew@mail.gmail.com>
Message-ID: <CAHk-=wgW=io6sfH1yzAakP+NnR3WQ-6kYtxoGfWra-=Fq2yzew@mail.gmail.com>
Subject: Re: [GIT PULL] cifs/smb3 fixes
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Oct 22, 2020 at 11:12 PM Steve French <smfrench@gmail.com> wrote:
>
> Looks like a cut-n-paste error (double paste).  Will resend the pull request

Well, the re-sent one was truncated and missed the final part of the diffstat..

If you're mousing these things, and that's the problem, may I
introduce you to the 'xsel' program?

                Linus
