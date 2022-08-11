Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE180C19F2A
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 13:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbiHKNeD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 09:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiHKNeC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 09:34:02 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901588A6F4
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 06:34:01 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 0671C8026A;
        Thu, 11 Aug 2022 13:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1660224839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4OSt6IP0TGo7LViMYIYLdAZ6iv0HK4Z1S+wKJTEyZPE=;
        b=JPssDO+G0rYozMF+loOJVyvSkTaEqr6jX7ZGEmw23xhyqSKbkoMLNGpXjNOLYD3MJxVGq6
        tpgp0kBWpx+I8MSkp/BhSVhbFlJP/FkpoEYTik5ontvki028IWVNNL5bf/bu/8RMIzrfBX
        JHGnas8pqRIMW5YX+RyxWuijcVYuxhE0tqcqhlt/It8jvh8PZbz9dYV8sWAtdgZw4PaSBl
        qJJNBmXpw4BGDju9zSWalwPbOrd42zLJL9P7gkBOwCY+Gz1+2JGav9G0IVcl2ZOIypji4e
        CHrSJk0Tri4ESFIt7Lu9T311oyd7nUKwRw7SBFhaSB4bHJWKc0jPt4CtaQjdWg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: [PATCH 6/9] cifs: cifs: handlecache, only track the dentry for
 the root handle
In-Reply-To: <20220809021156.3086869-7-lsahlber@redhat.com>
References: <20220809021156.3086869-1-lsahlber@redhat.com>
 <20220809021156.3086869-7-lsahlber@redhat.com>
Date:   Thu, 11 Aug 2022 10:34:11 -0300
Message-ID: <87h72iucoc.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cached_dir.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
> index 1fb80b23bbeb..9423fee378f4 100644
> --- a/fs/cifs/cached_dir.c
> +++ b/fs/cifs/cached_dir.c
> @@ -47,11 +47,12 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>  	if (cifs_sb->root == NULL)
>  		return -ENOENT;
>  
> +	if (!strlen(path))
> +		dentry = cifs_sb->root;
> +

Why are you calling strlen() twice?  If below check is false, that means
path is empty and then you can set dentry to cifs_sb->root, as the
original code did.

>  	if (strlen(path))
>  		return -ENOENT;
>  
> -	dentry = cifs_sb->root;
> -

>  	cfid = &tcon->cfids->cfid;
>  	mutex_lock(&cfid->fid_mutex);
>  	if (cfid->is_valid) {
> @@ -177,7 +178,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>  	cfid->tcon = tcon;
>  	cfid->is_valid = true;
>  	cfid->dentry = dentry;
> -	dget(dentry);
> +	if (dentry)

No need for NULL check.  dget() already does that.

> +		dget(dentry);
>  	kref_init(&cfid->refcount);
>  
>  	/* BB TBD check to see if oplock level check can be removed below */

Otherwise, look good to me.
