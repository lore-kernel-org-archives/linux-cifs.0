Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25AFC433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 04:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiJCEiS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 00:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJCEiR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 00:38:17 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0F233860
        for <linux-cifs@vger.kernel.org>; Sun,  2 Oct 2022 21:38:16 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id bj3so1746043vkb.5
        for <linux-cifs@vger.kernel.org>; Sun, 02 Oct 2022 21:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=p1IQ4xWavzrSN1ZEsVWfDaCrop+YUwxoPLR9GRlbgO0=;
        b=ZY/3NS5ODi8PsSDeSh9/s5BqdrerdaxpUb+77pxN/PTg9gEZuvKgIbGMIEK34S6vOl
         BSqtok+Lq+JJCMhsYY95+N1Lv1C62kz32pb4BDicpcys15XqinXjGBhxo9kF+ouOuxzD
         VcFNLpNxMqFV5ZJhRblFuiR6nd+2MhSFydkqVUyYKJCTHeD/nYGzwpTlTC2+As1J6ZAa
         /IGFXoC+X3xFFg4H9h9tbe/iIEftmT//7js68XK5ayzCv7YOi6kiUbPpU+zOepAK33Dq
         qM7BszVIF5ewp3aah/Xlk/ro00Snp3LeYJMaL8v70jLKxUUXf10rBIMAuLK88Wle6ga4
         UUmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=p1IQ4xWavzrSN1ZEsVWfDaCrop+YUwxoPLR9GRlbgO0=;
        b=CaOgfUE4AJVkGJd9PQxiF0h0zZmL+doHh6uJS8FTbRh8heKi5XBTYGPcWi8kudNQwO
         p/DHIJnsCgCmiBgYiD9OKckYz/UgBoXTAHADWDR90A4Do8utyiwF5IyGnmUxAf9M2JJG
         DssazElk7X7SbLOE/vyP0gLtpDUozXTHHBsQzwTiiNiMidSWd81qZ7DZNZX0ixMeGFkz
         z3UBDW3FLI0tlMuIg9+lbZqzFoemQm8qM7vk+Po50OWIGGa+Judztvizu5ttcRgJoZwu
         psYAkN4riW27UiAxNpXsmDNC7oAqifCCIGYYUScUeGbhmmPrty5KlKKHj24jk/CZR/v6
         78vg==
X-Gm-Message-State: ACrzQf1m3yj1UoGTcms301G1fgKoRRsJ38Ej292EhXVnSR7c/iWo5sbh
        jftfHBtQfzGuhOTgtDkE/Ov1/jBxP7BX+QVGDRAgYZ8+
X-Google-Smtp-Source: AMsMyM7nOMCkcJDlpOo6TnFiqBkt42JbSMsGNA98Eo5/M7WiXRRn9inNgwpdp9oSKyeXkwKqjeSSIkk5MZ7Ok4K2VeQ=
X-Received: by 2002:a05:6122:1043:b0:3a9:9506:c34e with SMTP id
 z3-20020a056122104300b003a99506c34emr3875908vkn.38.1664771895120; Sun, 02 Oct
 2022 21:38:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvS6_AXjbK8sY_dEWUbmtRjodSYEtxeNz_NST9+EyC96A@mail.gmail.com>
 <df473fde-e79d-ae90-37bb-3a3869d3aa9a@talpey.com>
In-Reply-To: <df473fde-e79d-ae90-37bb-3a3869d3aa9a@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 2 Oct 2022 23:38:04 -0500
Message-ID: <CAH2r5msDX4eaGuyine__ePtOTRoSBDjiUN_dthaHpiA9UKm0yg@mail.gmail.com>
Subject: Re: [PATCH][smb3 client] log less confusing message on multichannel
 mounts to Samba when no interfaces returned
To:     Tom Talpey <tom@talpey.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Oct 1, 2022 at 6:22 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 10/1/2022 12:54 PM, Steve French wrote:
> > Some servers can return an empty network interface list so, unless
> > multichannel is requested, no need to log an error for this, and
> > when multichannel is requested on mount but no interfaces, log
> > something less confusing.  For this case change
> >     parse_server_interfaces: malformed interface info
> > to
> >     empty network interface list returned by server
>
> Will this spam the log if it happens on every MC refresh (10 mins)?
> It might be helpful to identify the servername, too.

Yes - I just noticed that in this case (multichannel mount to Samba
where no valid interfaces) we log it every ten minutes.
Maybe best way to fix this is to change it to a log once error (with
server name is fine with me) since it is probably legal to return an
empty list (so not serious enough to be worth logging every ten
minutes) and in theory server could fix its interfaces later.



> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> >
> > See attached patch
> >



-- 
Thanks,

Steve
