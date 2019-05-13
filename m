Return-Path: <SRS0=ZeIh=TN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA423C04AA7
	for <linux-cifs@archiver.kernel.org>; Mon, 13 May 2019 14:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7E31208C3
	for <linux-cifs@archiver.kernel.org>; Mon, 13 May 2019 14:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbfEMOeQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 May 2019 10:34:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:34478 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729561AbfEMOeQ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 13 May 2019 10:34:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1A58CABE9;
        Mon, 13 May 2019 14:34:15 +0000 (UTC)
Date:   Mon, 13 May 2019 16:34:13 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Murphy Zhou <xzhou@redhat.com>
Cc:     ltp@lists.linux.it, linux-cifs@vger.kernel.org
Subject: Re: [LTP] [PATCH] safe_setuid: skip if testing on CIFS
Message-ID: <20190513143413.GA4568@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20190510043845.4977-1-xzhou@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510043845.4977-1-xzhou@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Murphy,

> As CIFS is not supporting setuid operations.
Any reference to this?
fs/cifs/cifsfs.c and other parts of kernel cifs works with CIFS_MOUNT_SET_UID.
Also samba_setreuid() from lib/util/setid.c from samba git (I guess used in
samba libraries works with SYS_setreuid syscall or setreuid() libc wrapper.
What am I missing?

> diff --git a/lib/tst_safe_macros.c b/lib/tst_safe_macros.c
> index 0e59a3f98..36941ec0b 100644
> --- a/lib/tst_safe_macros.c
> +++ b/lib/tst_safe_macros.c
> @@ -111,6 +111,7 @@ int safe_setreuid(const char *file, const int lineno,
>  		  uid_t ruid, uid_t euid)
>  {
>  	int rval;
> +	long fs_type;

>  	rval = setreuid(ruid, euid);
>  	if (rval == -1) {
> @@ -119,6 +120,13 @@ int safe_setreuid(const char *file, const int lineno,
>  			 (long)ruid, (long)euid);
>  	}

> +	fs_type = tst_fs_type(".");
> +	if (fs_type == TST_CIFS_MAGIC) {
> +		tst_brk_(file, lineno, TCONF,
> +			 "setreuid is not supported on %s filesystem",
> +			 tst_fs_type_name(fs_type));
> +	}
I guess this check should be before setreuid() As it's in safe_seteuid() and
safe_setuid()
> +
>  	return rval;
>  }

Kind regards,
Petr
