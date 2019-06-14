Return-Path: <SRS0=yfaw=UN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62DD6C31E4B
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jun 2019 17:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CD8B217F9
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jun 2019 17:36:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ut0ZTwRl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbfFNRgT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jun 2019 13:36:19 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43293 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbfFNRgT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Jun 2019 13:36:19 -0400
Received: by mail-lf1-f68.google.com with SMTP id j29so2263103lfk.10
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jun 2019 10:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rp7xtbZ/gVxDDaE5xSvX//T0llkBLK2m5KBi1kM/cDI=;
        b=Ut0ZTwRlVKMGybFuWtnK1UEhwUQbqehqyv29TW6h+njBbXr6a4AlH8whsxJF7B0t2G
         6fbtmXgWPHYTLBNEnhxiIEy3OXu1SdzcFSVGbckauwkA49zyczFtnjcK8YK75qiyScq2
         FRDseSxKzpqMGShgN1wdaMOPcUwMHiRrHqZb6V09w46R5u4pHsK9YUt4t4pSrb8QVueC
         kP0478ZTPS+fL0oiohTuUlCQnBa85EQ0fp7k2+HALhYaLwaULkC28PhuyiKViBLcMsal
         08jjfv9RYpSweHDJpkbky0sHTjwUmyocU9f96cnQ1F4YV3ESIMqQ2GPATgn0lMX2P/X1
         ciDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rp7xtbZ/gVxDDaE5xSvX//T0llkBLK2m5KBi1kM/cDI=;
        b=QrTHjHFoyiVU3CmuFhFwPCfUnW1BH1JbsAI7iJyokXndRtHUZLUv1Gjc1fT6iwMxrb
         XjJ6X1gMm8gp89K0cZjvK6rhj2UqfVsWsl3azYPdv6FH7/GchosqGsDl8KcJMd8NId1R
         iwlBlUpfZS07GlI6Tw59K55wVSgMVgqICQvaNEvhSjQJgTs+cBQT2nn1K1JsxyPo5Y+v
         pAGYQ7wk7iI83f0SdnrORxFMJM24cV7F1Sey24MX9CoIt4lbHK98eKVQ3Q1YloaTZ6j+
         /ZXLcG7iOpZmS5eKkv3b7Ya/MixcRdnJ8qmor2VvhLazKyVEb8BDvKy9V0j7XNlnpDVD
         D6rw==
X-Gm-Message-State: APjAAAVwu/PMfKBn4j+lCqCxDHSRxZjOTH/oVLFDwLSV7RoA90MlGpgv
        fj0C7m7mhrVfTNDZJ0Is/9IePQH1q7D9Wl/cQ1vbnrs=
X-Google-Smtp-Source: APXvYqy8V9XFETrcMacUop85CM8WaMoShrzpiU7/IZ7SHdfTqGUitF0j5jIlejQTCIUZf1i31BN/9noEJC1Rt7dqQy8=
X-Received: by 2002:ac2:50cd:: with SMTP id h13mr11936976lfm.36.1560533777680;
 Fri, 14 Jun 2019 10:36:17 -0700 (PDT)
MIME-Version: 1.0
References: <MN2PR14MB3150D6916DA2C3E399AD57F2A6EE0@MN2PR14MB3150.namprd14.prod.outlook.com>
 <87zhmk47yq.fsf@suse.com>
In-Reply-To: <87zhmk47yq.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 14 Jun 2019 10:36:06 -0700
Message-ID: <CAKywueRLUcddaYYVAj1WhWXLE1NYQu-5iQn-yZu7kwGVq3g2LQ@mail.gmail.com>
Subject: Re: uninterruptible I/O wait on CIFS mounts on Amazon Linux 2 running
 latest kernel
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Ben Raven <benr@datapad.co>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There are only two changes between v4.14.114 and v4.4.121:

----------------------------------------
$ git diff v4.14.114 v4.14.121 -- fs/cifs
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 6fd4a6a75234..e7192ee7a89c 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1730,6 +1730,10 @@ cifs_do_rename(const unsigned int xid, struct
dentry *from_dentry,
        if (rc =3D=3D 0 || rc !=3D -EBUSY)
                goto do_rename_exit;

+       /* Don't fall back to using SMB on SMB 2+ mount */
+       if (server->vals->protocol_id !=3D 0)
+               goto do_rename_exit;
+
        /* open-file renames don't work across directories */
        if (to_dentry->d_parent !=3D from_dentry->d_parent)
                goto do_rename_exit;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index fd2d199dd413..7936eac5a38a 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2699,6 +2699,7 @@ SMB2_read(const unsigned int xid, struct
cifs_io_parms *io_parms,
                        cifs_dbg(VFS, "Send error in read =3D %d\n", rc);
                }
                free_rsp_buf(resp_buftype, rsp_iov.iov_base);
+               cifs_small_buf_release(req);
                return rc =3D=3D -ENODATA ? 0 : rc;
        }

----------------------------------------

Both fixes seem to be legitimate and shouldn't cause the issue
directly. Please provide the logs (as mentioned by Aurelien above)
together with mount command options. If you have a small simple repro
setup/script/program that would help too.

--
Best regards,
Pavel Shilovsky

=D0=BF=D1=82, 14 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 06:23, Aur=C3=A9li=
en Aptel <aaptel@suse.com>:
>
> Hi Ben,
>
> Any chance we can get a verbose kernel log and network trace?
> See https://wiki.samba.org/index.php/Bug_Reporting#cifs.ko
> for instructions.
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 21284 (AG N=C3=
=BCrnberg)
