Return-Path: <SRS0=r/yF=XE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A982CC4740A
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Sep 2019 12:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78AA4218DE
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Sep 2019 12:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfIIMqx convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Sep 2019 08:46:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:58908 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727138AbfIIMqx (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 9 Sep 2019 08:46:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 645ADAEB3;
        Mon,  9 Sep 2019 12:46:51 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     "Paulo Alcantara \(SUSE\)" <paulo@paulo.ac>, piastryyy@gmail.com,
        samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] mount.cifs: Fix double-free issue when mounting with
 setuid root
In-Reply-To: <20190905184935.30694-1-paulo@paulo.ac>
References: <20190905184935.30694-1-paulo@paulo.ac>
Date:   Mon, 09 Sep 2019 14:46:50 +0200
Message-ID: <87k1ahiqmd.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

" Paulo Alcantara (SUSE) " <paulo@paulo.ac> writes:
> It can be easily reproduced with the following:
>
>   # chmod +s `which mount.cifs`
>   # echo "//localhost/share /mnt cifs \
>     users,username=foo,password=XXXX" >> /etc/fstab
>   # su - foo
>   $ mount /mnt
>   free(): double free detected in tcache 2
>   Child process terminated abnormally.
>
> The problem was that check_fstab() already freed orgoptions pointer
> and then we freed it again in main() function.
>
> Fixes: bf7f48f4c7dc ("mount.cifs.c: fix memory leaks in main func")
> Signed-off-by: Paulo Alcantara (SUSE) <paulo@paulo.ac>

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

I've compiled next branch with ASAN and can confirm the double-free and
the fix works

Compiling with ASAN
-------------------

$ CFLAGS=-fsanitize=address \
  LDFLAGS=-fsanitize=address \
  ac_cv_func_malloc_0_nonnull=yes \
  ./configure
$ make clean && make -j4  

Next branch
-----------

$ mount /mnt; echo $?
=================================================================
==29883==ERROR: AddressSanitizer: attempting double-free on 0x607000000020 in thread T0:
    #0 0x7f69d480a1b8 in __interceptor_free (/usr/lib64/libasan.so.4+0xdc1b8)
    #1 0x559381795f33 in main (/sbin/mount.cifs+0xef33)
    #2 0x7f69d4394f89 in __libc_start_main (/lib64/libc.so.6+0x20f89)
    #3 0x55938178e079 in _start (/sbin/mount.cifs+0x7079)

0x607000000020 is located 0 bytes inside of 68-byte region [0x607000000020,0x607000000064)
freed by thread T0 here:
    #0 0x7f69d480a1b8 in __interceptor_free (/usr/lib64/libasan.so.4+0xdc1b8)
    #1 0x55938178e372 in check_fstab (/sbin/mount.cifs+0x7372)
    #2 0x559381794661 in assemble_mountinfo (/sbin/mount.cifs+0xd661)
    #3 0x559381795eef in main (/sbin/mount.cifs+0xeeef)
    #4 0x7f69d4394f89 in __libc_start_main (/lib64/libc.so.6+0x20f89)

previously allocated by thread T0 here:
    #0 0x7f69d480a510 in malloc (/usr/lib64/libasan.so.4+0xdc510)
    #1 0x7f69d43fc2a9 in __GI___strndup (/lib64/libc.so.6+0x882a9)

SUMMARY: AddressSanitizer: double-free (/usr/lib64/libasan.so.4+0xdc1b8) in __interceptor_free
==29883==ABORTING
1

With fix
--------

$ mount /mnt; echo $?
0

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
