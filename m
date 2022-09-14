Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D51E1ECAAD3
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 14:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiINOjB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Sep 2022 10:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiINOjA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Sep 2022 10:39:00 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D9C26AF7
        for <linux-cifs@vger.kernel.org>; Wed, 14 Sep 2022 07:39:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CFC2D338DF;
        Wed, 14 Sep 2022 14:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663166338; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aqlupjzwktQWLu6LA65zag0iQEb/xanUADUPFM5dQCU=;
        b=iK42rkK0m9iKGsA0Pjupb2vEt2frOBVRhA6Tk4plpHp5mTOzJpF/ChAKfm1AYIOrkWFwrg
        aQynoH+p+ZIzVlbhCvboJ/gXLVfTKX5KFyvNoK54NTUp+1SJD6Smu2cO3lYMd0NdJ2ryi7
        IuEd3Ny8lRpK7dpPnfk9ix/MAEo6LAc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663166338;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aqlupjzwktQWLu6LA65zag0iQEb/xanUADUPFM5dQCU=;
        b=6xe5He1M+Z9Xyz2loALK5H/5CpMy2ayEeG3MO/iPWNX+vyHK9lqm5EpnSYiKQEJ8QoI/19
        Q1VnjAU0T1yT0xAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4AF02134B3;
        Wed, 14 Sep 2022 14:38:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LSgbB4LnIWP9OQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 14 Sep 2022 14:38:58 +0000
Date:   Wed, 14 Sep 2022 11:38:55 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     =?utf-8?B?QXVyw6lsaWVu?= Aptel <aurelien.aptel@gmail.com>,
        linux-cifs@vger.kernel.org, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: perf improvement - use faster macros ALIGN() and
 round_up()
Message-ID: <20220914143855.7qatfr2peege5zc6@suse.de>
References: <20220906013040.2467-1-ematsumiya@suse.de>
 <CA+5B0FNBJVFC6-SfVodctu0DkyyZ9DzJM8OJsDBbVb453Mvfsw@mail.gmail.com>
 <20220907204140.77ssfeib3zmwvqy2@cyberdelia>
 <CAH2r5msyrbfM71WDpUggD7V_YTZhE50w7y4Umt=QjAG=Yfhz7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5msyrbfM71WDpUggD7V_YTZhE50w7y4Umt=QjAG=Yfhz7g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 09/13, Steve French wrote:
>Most of the changes look ok to me, although not much point in changing
>the lines like:
>
>     x = 2 /* sizeof(__u16) */ ....
>to
>     x = sizeof(__u16) ...
>
>not sure that those  particular kinds of changes help enough with
>readability (but they make backports harder) - and they have 0 impact
>on performance.   So even if that type of change helps readability a
>small amount, it could be split out from the things which could help
>performance (and/or clearly improve readability).

Those kind of changes were not aimed at performance at all. IMHO it
improves readability becase a) remove a hardcoded constant, and b)
remove the (necessity of) inline comments.

I can drop those changes if you'd like.

>The one area that looked confusing is this part.  Can you explain why
>this part of the change?
>
>@@ -2687,20 +2683,17 @@ int smb311_posix_mkdir(const unsigned int xid,
>struct inode *inode,
>                uni_path_len = (2 * UniStrnlen((wchar_t *)utf16_path,
>PATH_MAX)) + 2;
>                /* MUST set path len (NameLength) to 0 opening root of share */
>                req->NameLength = cpu_to_le16(uni_path_len - 2);
>-               if (uni_path_len % 8 != 0) {
>-                       copy_size = roundup(uni_path_len, 8);
>-                       copy_path = kzalloc(copy_size, GFP_KERNEL);
>-                       if (!copy_path) {
>-                               rc = -ENOMEM;
>-                               goto err_free_req;
>-                       }
>-                       memcpy((char *)copy_path, (const char *)utf16_path,
>-                              uni_path_len);
>-                       uni_path_len = copy_size;
>-                       /* free before overwriting resource */
>-                       kfree(utf16_path);
>-                       utf16_path = copy_path;
>+               copy_size = round_up(uni_path_len, 8);
>+               copy_path = kzalloc(copy_size, GFP_KERNEL);
>+               if (!copy_path) {
>+                       rc = -ENOMEM;
>+                       goto err_free_req;
>                }
>+               memcpy((char *)copy_path, (const char *)utf16_path,
>uni_path_len);
>+               uni_path_len = copy_size;
>+               /* free before overwriting resource */
>+               kfree(utf16_path);
>+               utf16_path = copy_path;
>        }

This change only removes the check "if (uni_path_len  %8 != 0)" because
uni_path_len will be aligned by round_up() (if unaliged), or a no-op if
already aligned; hence no need to check it. Unless I missed something?


Cheers,

Enzo
