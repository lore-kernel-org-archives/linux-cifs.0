Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A28C54EE9
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Sep 2022 14:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiISOyO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Sep 2022 10:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiISOyN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Sep 2022 10:54:13 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312533342E
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 07:54:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D98E6220EC;
        Mon, 19 Sep 2022 14:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663599250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xwb/tWMc66dCCUa/E/L+M2w3/wUsGgymvowPz0OuwHE=;
        b=Ew2gUbrgS1jUmsvJCV4rb+cfy0SYlS8E6FJ9KMOWD9qusVPyOv87PaU/1zgM9E3dhs3tAh
        pesqxyo1ONWKjSxnWPF+ELnd9jKt5UJmJBLmz6dcK7smvxLXeD9qzbyGsIfVXOyvT7JLsL
        Nd9XDwEnGETSjxIr0PNrtGW+z/hDZyg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663599250;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xwb/tWMc66dCCUa/E/L+M2w3/wUsGgymvowPz0OuwHE=;
        b=oMRHf83wB7k8BCC4gJOSI3gYlPfEA2AMfX+UGMUJH+hallGyI1126Lm8ZNsY2DKVxoZy1e
        E54ZkmNdZ8RqOkBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1E51E13A96;
        Mon, 19 Sep 2022 14:54:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id khYSNJGCKGOGawAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 19 Sep 2022 14:54:09 +0000
Date:   Mon, 19 Sep 2022 11:54:07 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: destage dirty pages before re-reading them for
 cache=none
Message-ID: <20220919145407.wh2lqnk5debd6hv5@suse.de>
References: <20220919053901.465232-1-lsahlber@redhat.com>
 <20220919053901.465232-2-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220919053901.465232-2-lsahlber@redhat.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 09/19, Ronnie Sahlberg wrote:
>This is the opposite case of kernel bugzilla 216301.
>If we mmap a file using cache=none and then proceed to update the mmapped
>area these updates are not reflected in a later pread() of that part of the
>file.
>To fix this we must first destage any dirty pages in the range before
>we allow the pread() to proceed.
>
>Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>

I could verify by using the reproducer from the write case.

>---
> fs/cifs/file.c | 10 ++++++++++
> 1 file changed, 10 insertions(+)
>
>diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>index 6f38b134a346..b38cebefb0db 100644
>--- a/fs/cifs/file.c
>+++ b/fs/cifs/file.c
>@@ -4271,6 +4271,16 @@ static ssize_t __cifs_readv(
> 		len = ctx->len;
> 	}
>
>+	if (direct && file->f_inode->i_mapping &&
>+	    file->f_inode->i_mapping->nrpages != 0) {

Just a minor nitpick, and actually a real question of mine now: can
i_mapping ever be NULL in this case (read)? Furthermore, if so, can
i_mapping->nrpages ever be 0? I looked around briefly, and those
seem to be validated before hitting cifs code.

I'm wondering because if those can ever be NULL/0, wouldn't it be a case
for a BUG/WARN()? And, if so, there are a couple of other places we
should check it as well.

Please someone correct me if I missed something.

>+		rc = filemap_write_and_wait_range(file->f_inode->i_mapping,
>+						  offset, offset + len - 1);
>+		if (rc) {
>+			kref_put(&ctx->refcount, cifs_aio_ctx_release);
>+			return rc;
>+		}
>+	}
>+	
> 	/* grab a lock here due to read response handlers can access ctx */
> 	mutex_lock(&ctx->aio_mutex);
>
>-- 
>2.35.3

Cheers,

Enzo
