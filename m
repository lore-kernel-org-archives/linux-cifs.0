Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBCEC43460
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 19:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB41361001
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 19:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbhDITsJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 15:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbhDITsJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 15:48:09 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE28C061762
        for <linux-cifs@vger.kernel.org>; Fri,  9 Apr 2021 12:47:55 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id u4so7806172ljo.6
        for <linux-cifs@vger.kernel.org>; Fri, 09 Apr 2021 12:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EDhF84YRmdbW63bzoYceFfUcXLgMveYoLl3ZFxiLbzk=;
        b=OHwlamEjodaUVNv2M5QqcbV1JXFZuEMbXSRbPcHaEmdF64AxOur1iRGp61AGATkFBp
         oFDzKkxguDQiTcb5y2ZWvAyccxWX4oWwQNjoLM+9aB5QWNmz2WTcYSPL4svFENrT2/EF
         kdDCWwqehSX2b2WLzkh8Xd0ZpeeTIR8V36nRkfP1BkPf8o+GbjBzO5F+DgmiT4ntmmZf
         lTMAWmWF205mRU9qRI+7Mw9kDzdua24h+mrYFV94EmIaqFaaU8RR3AUeEQNuVHBIEpzm
         sBUmLejBNnRGzaARWfjtB+J5HwpLFpvHZVYxquRzjWGlslQ13MUhkXw8Tc8iyglpZVjP
         Xnzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EDhF84YRmdbW63bzoYceFfUcXLgMveYoLl3ZFxiLbzk=;
        b=EJGljYC2Vr0vcbOuPyMlsXxZAfeHnB21u8ol68Ff00XdZnkuFiMj6wfWJvDvvdrLlF
         ll1hdmUtyQ2ESBk/k1+rwt0ZtsxxU1k5/Wlv3J1WCpqzmi1FvryvwmTTy7zn76RWR1Mh
         zhRHfXN2v1eGiV9q9lDqdCl8klYhRIFDrmQ3DMkkCPUVVsJB8QufhiyT6+czOX0+CTjc
         gfT5SwL818Z2nSi5bKMUai/vgi5Ex/Vw9fj9emlvPAw8LfiyJcsNAaNzsWxADHOKyN6O
         f1tUxxvx+p6sPYNmAz3K5hYkg0a6pbVuHzlCM2tf4h6MXaH0NcYVOrVavyId7l33d66H
         +4IA==
X-Gm-Message-State: AOAM532e5HvSaPuS7LLhq/joYCdfxDGEek5gL0Ry9L7qpBmbvhFJAC09
        SPH0WeyXXo3Mm/A9we2937/nJ4ue6ST/qvpYwV0=
X-Google-Smtp-Source: ABdhPJw7I+rfuXtDS+WZ3HqJPtUDaUMTxcqAHCEei2gOwvTMmRzVjv0xrQqBeTyOvjEHDNebXqo6e2CeiHDGg0w3GDQ=
X-Received: by 2002:a2e:a78b:: with SMTP id c11mr10463085ljf.6.1617997674173;
 Fri, 09 Apr 2021 12:47:54 -0700 (PDT)
MIME-Version: 1.0
References: <87tuof3684.fsf@suse.com>
In-Reply-To: <87tuof3684.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 9 Apr 2021 14:47:43 -0500
Message-ID: <CAH2r5msWHV9fXWbHNE37Q5Ok6R6ZemynR_DBS_hU0eJZpTcJvw@mail.gmail.com>
Subject: Re: [PATCH v1] smb2: fix use-after-free in smb2_ioctl_query_info()
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git and added cc:stable

On Fri, Apr 9, 2021 at 9:04 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Hi,
>
> Ronnie, I think there are some memory issues (use-after-free) in the
> smb2_ioctl_query_info() code path.
>
> I have a fix to get rid of the KASAN splat. I've reordered the kfree()
> calls but also replaced the SMB2_xxxx_free() to simply freeing the SMB
> small buf.
>
> It could be leaking the other rqst[i]->rq_iov[] though, I'm not sure if
> there are extra stuff we need to free that is not in the vars buf. Can
> you take a look?
>
> See attached patch.
>
>
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)



--=20
Thanks,

Steve
