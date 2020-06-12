Return-Path: <SRS0=RdgD=7Z=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739C1C433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Jun 2020 23:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 448C22078A
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Jun 2020 23:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592005081;
	bh=07QDCF421g/CuXLPx32EKB9Xu/PvgNQ6R+YnFVHUbuw=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:List-ID:From;
	b=BnwAFgv1aCZAhq0owlfs+ELu+I4L28AnwvUMihikHa6yZXzajkQsnriPKzNBjhZPZ
	 J39rYbKPLiHy4NInaKJphEahcuRYSBCQerCv5+4XPFHRt0Dc+4zEnAsN2W6+/4l7WL
	 NA6c/VkbM2SdRId86Tcp3iEhMCWv/TP72HyKfsu8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgFLXiA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Jun 2020 19:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgFLXh5 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 12 Jun 2020 19:37:57 -0400
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4663420791;
        Fri, 12 Jun 2020 23:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592005077;
        bh=07QDCF421g/CuXLPx32EKB9Xu/PvgNQ6R+YnFVHUbuw=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=hyr+caZu2NRBmgLwdXXu40vb4iTHoYV+HC/tPpLLyKoU1vq6Vj5mupX/DyQQgAWH1
         GC667Hkv16bCjScoofE/VXIGPoCnLbKtxI9crxSO16y/JYOnUWfE5crlsoYYo5XECi
         7GLKq3FjNoJTCy8rwN7rPVQSmF/XrmgzlwT6YhGI=
Received: by mail-ot1-f53.google.com with SMTP id m2so8674340otr.12;
        Fri, 12 Jun 2020 16:37:57 -0700 (PDT)
X-Gm-Message-State: AOAM530SdvRgHVbaJc/wecZi5jFTV3HJOTyF7FWBEBXTPUwzynAbQFGs
        dgBOYw+TLPuregbWni8oiMvdGlrm4cqu4kaSLJA=
X-Google-Smtp-Source: ABdhPJyTRtcPMPqKh5Nfj4+4NWaSGz97CSu/hxlH0RFH6zRAvJcXWfjI0ZvuL8tlEYmqUJnZV3f78BRyXwepAizGOL4=
X-Received: by 2002:a9d:6c4c:: with SMTP id g12mr12585266otq.114.1592005076625;
 Fri, 12 Jun 2020 16:37:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:1d8:0:0:0:0:0 with HTTP; Fri, 12 Jun 2020 16:37:55 -0700 (PDT)
In-Reply-To: <87ftb0im64.fsf@suse.com>
References: <CGME20200611022619epcas1p46fd9d1d54396f0a4206b550949377d99@epcas1p4.samsung.com>
 <20200611022119.31506-1-namjae.jeon@samsung.com> <87ftb0im64.fsf@suse.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 13 Jun 2020 08:37:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd86YGh9d5=zYs_+_NKNXLnFK5jb9EBMm5AGeNuRtnWzeQ@mail.gmail.com>
Message-ID: <CAKYAXd86YGh9d5=zYs_+_NKNXLnFK5jb9EBMm5AGeNuRtnWzeQ@mail.gmail.com>
Subject: Re: [PATCH] smb3: add indatalen that can be a non-zero value to
 calculation of credit charge in smb2 ioctl
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>, linux-cifs@vger.kernel.org,
        Stable <stable@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2020-06-12 20:00 GMT+09:00, Aur=C3=A9lien Aptel <aaptel@suse.com>:
> Hi Namjae,
Hi Aur=C3=A9lien,
>
> Nice to see a patch :)
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Thanks for your review!!
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>
