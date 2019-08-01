Return-Path: <SRS0=8TPy=V5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706BAC433FF
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 09:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E47D2087E
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 09:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbfHAJP5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Aug 2019 05:15:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:38084 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729924AbfHAJP4 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 1 Aug 2019 05:15:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9F285ACFE;
        Thu,  1 Aug 2019 09:15:55 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Zhiqiang Liu <liuzhiqiang26@huawei.com>, smfrench@gmail.com,
        liujiawen10@huawei.com, pshilov@microsoft.com, kdsouza@redhat.com,
        lsahlber@redhat.com, ab@samba.org, palcantara@suse.de,
        linux-cifs@vger.kernel.org
Cc:     dujin1@huawei.com, Mingfangsen <mingfangsen@huawei.com>,
        zhangsaisai <zhangsaisai@huawei.com>
Subject: Re: [PATCH cifs-utils] mount.cifs.c: fix memory leaks in main func
In-Reply-To: <d4bf65ab-42e1-606c-be35-a5cb3b7b77b0@huawei.com>
References: <d4bf65ab-42e1-606c-be35-a5cb3b7b77b0@huawei.com>
Date:   Thu, 01 Aug 2019 11:15:53 +0200
Message-ID: <87h871s0ty.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Zhiqiang,

You are on the right list :)

Unfortunately it seems you have sent the exact same patch as before so
I'll post my comments again:

Zhiqiang Liu <liuzhiqiang26@huawei.com> writes:
> index ae7a899..029f01a 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1830,6 +1830,7 @@ assemble_mountinfo(struct parsed_mount_info *parsed_info,
>  	}
>
>  assemble_exit:
> +	free(orgoptions);
>  	return rc;
>  }

Since orgoptions is allocated in main() you should also free it
there. In fact it is already freed there so the return have to be
changed to goto.

>
> @@ -1994,8 +1995,11 @@ int main(int argc, char **argv)
>
>  	/* chdir into mountpoint as soon as possible */
>  	rc = acquire_mountpoint(&mountpoint);
> -	if (rc)
> +	if (rc) {
> +		free(mountpoint);
> +		free(orgoptions);
>  		return rc;
> +	}

Since mountpoint is allocated in acquire_mountpoint() you should free it
there if there's an error.

>  	/*
>  	 * mount.cifs does privilege separation. Most of the code to handle
> @@ -2014,6 +2018,7 @@ int main(int argc, char **argv)
>  		/* child */
>  		rc = assemble_mountinfo(parsed_info, thisprogram, mountpoint,
>  					orig_dev, orgoptions);
> +		free(mountpoint);

Since this code block is only run by the child I think it's ok to not
use goto. Don't forget to free(orgoptions) if you remove it from
assemble_mountinfo()

>  		return rc;
>  	} else {
>  		/* parent */
> @@ -2149,5 +2154,6 @@ mount_exit:
>  	}
>  	free(options);
>  	free(orgoptions);
> +	free(mountpoint);

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 21284 (AG Nürnberg)
