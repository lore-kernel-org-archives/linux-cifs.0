Return-Path: <SRS0=TF3n=VP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03EF2C7618F
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Jul 2019 23:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE3A620665
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Jul 2019 23:38:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rOrnZpHj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbfGRXiW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Jul 2019 19:38:22 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33612 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfGRXiW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Jul 2019 19:38:22 -0400
Received: by mail-pl1-f195.google.com with SMTP id c14so14619975plo.0;
        Thu, 18 Jul 2019 16:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ejf8jP9JEl34EyOvMAAN/iD2j/3iRy7pQtt2oG66RW0=;
        b=rOrnZpHj1qqG9j+9o6/0ztcUQejjl7AMDuch8v+94QMbEm3AYftqj4GL885p7s49vB
         fWIqc4MbOhbI91EdEgJ4PqgMXIL0/WJVF7TwdVsuo/njssM5npu25bUx4nd+NaR2jdjF
         s/MMg2THZYquEoCYdfmuYMNvINiVDIgQLdNt6N2iFiiQ/gQrZexn8cFPoD3YqUJjpRVj
         LKSWqy7XWCsR4AGdx4WiCGPzVAhInCcY8TJZBCLv7r8I8L2ASuEwrVaLuihKQGaWxi7i
         owG9UvS8Wh4f4Y5W04SdIwEz4NTiq8J6wzekBf0XfD4cetEGSZcSQcE58oXWMACqWRUS
         wgbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ejf8jP9JEl34EyOvMAAN/iD2j/3iRy7pQtt2oG66RW0=;
        b=lCBPCY1c+ILdo9YDZQA5jncbYg0W423hp71gpqpCGZlsz+4jq9xQTczRG1GYTp45cU
         WqYAFwXt65EJPgUuRgRRlkncW+XeGemOmCgILRjwYr4Fyzj6SzfMSzu1gcF+0km3oVHg
         NI3gdyUIiYe/KYjnrf9eaeUnIk/MaPy5u7EsYsznxOEnyGydMbPMjbjMywUskGW2DLsr
         NkBbltBiIysZBalsK5Eai3q0eo67wtnrq62FoyCkirbtSrQ3VlWSAhTGKNilwP+w5upu
         YU6ZQT+ba1fSXLDS/U0FsqOFq+RDE0c6f5lvGkEH4u8SGjTQJqS8IsT37x0a0YzVfK36
         6OQw==
X-Gm-Message-State: APjAAAVA3ALYA36ZMd3zqaTx3NKXku3bAKAHKHKpn5uapzQzPOy2UulW
        oMlknmo06dxE6cZzQouvdOHl0c0mTE65MITxfEBowajs
X-Google-Smtp-Source: APXvYqxKIH9OpSasSZPrCm42K+XRfVXN+lt3saSnx1BM1/u4unr5Z4mMdnazLEfiKN3QVy68CyjOTk+pIRLAnADgPQs=
X-Received: by 2002:a17:902:2a68:: with SMTP id i95mr54016177plb.167.1563493101326;
 Thu, 18 Jul 2019 16:38:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190719091635.4949cc70@canb.auug.org.au>
In-Reply-To: <20190719091635.4949cc70@canb.auug.org.au>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 18 Jul 2019 18:38:10 -0500
Message-ID: <CAH2r5mvBMMa+tp2W16qSNF-gChZ65ZUqe22VMBFicPaFkUmHuw@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the cifs tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This typo has been fixed (earlier this afternoon) in cifs-2.6.git for-next

On Thu, Jul 18, 2019 at 6:16 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the cifs tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
>
> fs/cifs/smb2ops.c: In function 'open_shroot':
> fs/cifs/smb2ops.c:762:28: warning: passing argument 5 of 'smb2_parse_contexts' makes pointer from integer without a cast [-Wint-conversion]
>      oparms.fid->lease_key, oplock, NULL);
>                             ^~~~~~
> In file included from fs/cifs/smb2ops.c:16:
> fs/cifs/smb2proto.h:234:11: note: expected '__u8 *' {aka 'unsigned char *'} but argument is of type 'u8' {aka 'unsigned char'}
>      __u8 *oplock, struct smb2_file_all_info *buf);
>      ~~~~~~^~~~~~
>
> Introduced by commit
>
>   bf63aef07199 ("smb3: optimize open to not send query file internal info")
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
