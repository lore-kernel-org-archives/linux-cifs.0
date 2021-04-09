Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1850AC433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 04:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D08EB61106
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 04:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhDIEcP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 00:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhDIEcP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 00:32:15 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B76C061760
        for <linux-cifs@vger.kernel.org>; Thu,  8 Apr 2021 21:32:02 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id n8so7644476lfh.1
        for <linux-cifs@vger.kernel.org>; Thu, 08 Apr 2021 21:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4iPxYGzn3/ixWKeLq+QcxBK38rgATlfT4C6Mkc+6mNY=;
        b=tz/rgOdI9rT9DewQyQHqiunB4Nefy7zUGEKhr8vCBJmXjs8HdMBpPel4uYEtpcjguR
         sj8+tm9dP8zT0+dyhdACBGI7rjL49bH7V21/nQ9MBlyyw4qcd962NhqJq6ibQgiiXGVP
         E7MPEmj187OJ5QWdWZsxnGE088M1YxHb/IhBp9ERW7Nc4uSYXS5gE6DFHP4akptc66Ul
         fltqb6O5zsmOZ1YOivbbCAibDb/wz+5WQSSPnsoqrhCxneY7qBg8S+XZL9cdmDYK3tK+
         K5Zj7OAxsdjLpttbfeqPB7acaXJ/S+Zvruq3G1/bnCtSfm3U5lO/TXgL+14pXNeOc5Ua
         S/0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4iPxYGzn3/ixWKeLq+QcxBK38rgATlfT4C6Mkc+6mNY=;
        b=OHEH37ianq2P+zii6BeVlsjhv2lHILhopCtnlpj9WXEopNUsgARDRfkgmQoch8z3ue
         7hTUMUk5kk/wZyt5qzAdWL+UjvwLMrhIWSdgNR+HVsizmhJ7ASfPILjN1KRUPQlYHE4V
         q6kvdBP/8Cn5sWMgh1vXXhWMGWNtFJpUlw/VfagDng+80cyJza88Uau5G2n9+V8E9GsK
         2XnTlc2y840plxb+Y3WdlnqYDo4/ILQv6Z8SBIKw5XRAotzffmWlZLXYGl3weFKQIA3G
         D7KnSX69HvSXAi/mQLfMdGzJek2hQw9THa4TQuJUqNJCsUT/pkcfrLO3RGJbGXYHtMZ0
         5hqQ==
X-Gm-Message-State: AOAM5319KHT1xNyd2i+pzmAE0jwx5K0PpROY8VfUmuXO8YmaT2yMUp7h
        NKmzHTQQEWcLBMNncrRU2ffDLQTo/A74E5J0vwwhO4Jjatg=
X-Google-Smtp-Source: ABdhPJxZQlimO2hZ8B72vhp0NIkc9wBKvo6ieqTWA+Pj4iBICKdK3RCxh1rlccuIYrHIz6G78Gvjulg9dYQOtj8ZlUI=
X-Received: by 2002:a19:7515:: with SMTP id y21mr9245540lfe.282.1617942721040;
 Thu, 08 Apr 2021 21:32:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210322173437.31220-1-aaptel@suse.com> <87mtuvrnnc.fsf@cjr.nz>
In-Reply-To: <87mtuvrnnc.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 8 Apr 2021 23:31:50 -0500
Message-ID: <CAH2r5mvdztOhoUfXVCqhqiZXNgwU41fSgHaqbS58i-fsn=c+mA@mail.gmail.com>
Subject: Re: [PATCH] Documentation/admin-guide/cifs: document open_files and dfscache
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Mon, Mar 22, 2021 at 2:31 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Aur=C3=A9lien Aptel <aaptel@suse.com> writes:
>
> > From: Aurelien Aptel <aaptel@suse.com>
> >
> > Add missing documentation for open_files and dfscache /proc files.
> >
> > Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> > ---
> >  Documentation/admin-guide/cifs/usage.rst | 3 +++
> >  1 file changed, 3 insertions(+)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



--=20
Thanks,

Steve
