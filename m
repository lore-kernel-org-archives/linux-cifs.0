Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB04C6FA8E
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 14:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiITOnj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 10:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiITOn3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 10:43:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6289353D1D
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 07:43:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 44C7821AFA;
        Tue, 20 Sep 2022 14:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663685005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bh5JhODSYX5KQDRBD9gBYyoTJZvU7Fw2I7XOBdRGgBc=;
        b=pb0CKmYhXfDIZlHh+GCD4WBcI1ygj1WbIttk+OuT+ALOIMcFyS48FY9hwZu/zk5C5UMqZI
        /bHX1pGaUkTftQVyyDwVs+oPUTZpRvIG8Dzf9+7vwvrY/Vj4g1ofnKwBR3Cfi32sxbFFD5
        8erv518dvsDd0TtE2aZg8VDYrkE1oCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663685005;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bh5JhODSYX5KQDRBD9gBYyoTJZvU7Fw2I7XOBdRGgBc=;
        b=nitLZjRqen8ug3dfExc4IABFQBZZFUwd6c40nhXZNfTIzN1gekg82V/fcJ2cziiO00gYPG
        6BSreDuCReRQCbDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AAFF413ABB;
        Tue, 20 Sep 2022 14:43:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gLDBGozRKWONHQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 20 Sep 2022 14:43:24 +0000
Date:   Tue, 20 Sep 2022 11:43:22 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     lkp@lists.01.org, lkp@intel.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [cifs]  c9ba95b978:
 BUG:KASAN:use-after-free_in_SMB2_sess_free_buffer[cifs]
Message-ID: <20220920144322.tkd6eeezfeesva3r@suse.de>
References: <20220918033619.16522-1-ematsumiya@suse.de>
 <202209201529.ec633796-oliver.sang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <202209201529.ec633796-oliver.sang@intel.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 09/20, kernel test robot wrote:
>
>Greeting,
>
>FYI, we noticed the following commit (built with gcc-11):
>
>commit: c9ba95b978808970633b0221b70c5255ebc8630e ("[PATCH v2] cifs: replace kfree() with kfree_sensitive() for sensitive data")
>url: https://github.com/intel-lab-lkp/linux/commits/Enzo-Matsumiya/cifs-replace-kfree-with-kfree_sensitive-for-sensitive-data/20220918-113758
>base: git://git.samba.org/sfrench/cifs-2.6.git for-next
>patch link: https://lore.kernel.org/linux-cifs/20220918033619.16522-1-ematsumiya@suse.de
>

snip

>If you fix the issue, kindly add following tag
>| Reported-by: kernel test robot <oliver.sang@intel.com>
>| Link: https://lore.kernel.org/r/202209201529.ec633796-oliver.sang@intel.com

snip

>kern  :info  : [   81.927031] CIFS: Attempting to mount \\localhost\fs
>kern  :err   : [   81.949059] ==================================================================
>kern  :err   : [   81.956956] BUG: KASAN: use-after-free in SMB2_sess_free_buffer+0xba/0x1c0 [cifs]
>kern  :err   : [   81.965177] Write of size 44 at addr ffff8881219a3c00 by task mount.cifs/1530

Will send v2.


Enzo
