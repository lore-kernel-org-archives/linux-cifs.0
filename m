Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4B4C77B72
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Apr 2023 17:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjDTRp1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Apr 2023 13:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDTRp1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Apr 2023 13:45:27 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D424210B
        for <linux-cifs@vger.kernel.org>; Thu, 20 Apr 2023 10:45:25 -0700 (PDT)
Message-ID: <a63523569c379a1ec13a1f352687cdcf.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1682012722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nquglg8RGCodM+d0Nihtqj2ERnY73p2h8HChYrcESeI=;
        b=pAo3eeSVLmMZW6lFjWNRGVAv+QoVGJGcYGJ3N+PQzQOKI8WvH2+NHOgI98GZN9nJ3RwfDB
        GgL96n+3+0D64ePOzQWOW6EvRFMQ8FOkPt1a8pY/4W4lvwv4joHRfL7VXCZB69e+L/I0R4
        nWQEGx9gYU3Uadhsp6rc8wrHmk6YvfWZLgjXMlZYaYAF9oXEj88RcwULi0klJn4Cj6paYk
        ULBGLGHL8xYShV19K0Jkj8PElU4MA/eS5eQT3iVN9e7UoyMUBrs6nlMvqOVyzfK/mvTLCx
        MU6v8Qt5WDLhugZGGPzrs0JXRUiWtCqqx6fbGYcugsIy9TZqo6QHtmzH6l7GGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1682012722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nquglg8RGCodM+d0Nihtqj2ERnY73p2h8HChYrcESeI=;
        b=Hc8waeW3zC6STqbyopMIEP4B67j/BSei3ixy/OdEYIjyyqb4qLqX5sNJcEqrDuc5JWhmX5
        fsc38D6QPXRSNZEzueRqRysymym/Txz1uhDdV1+P2Yuod4BRJwt3zkzOVZzpEl4rJd8F4g
        3iovYA52tMulwJCPA9I5wcGfX1aYA1YqYm+VxGqly/BC5GGDHvuHXgZ427fA0Wo42XHYqv
        +68U+wrNgcnV5JC81Lp7XQdevNMv7BnZfvZ/GFCnG8drFH3xq1KAAblopCnMjSgL6YW61i
        ZsZQrrWQUTiudaprQxhDUIwCb9/oOvzSvQiRladxAqkW5fy1WjQG5oXV0U5FjA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1682012722; a=rsa-sha256;
        cv=none;
        b=Gp7qjgNCgUgTPWEU10YJl11hU/OL8SAfcThSr/ahbQtfR1hMxO6cKGOoy46ps9eucJPE8k
        E4pnIDWe5kKoX9te0IN0pPCoO5dYpOnUeGSmRPGQfbJYQrya82g4xNerLpd+wxlGiMfQfH
        081Lai+wNgTMZSQuxsEckAfllr8KTCaPc7mHZqwN7HVZcMAOW3dU77ohVtkW8GbccovfOL
        Z6pC0GqQmvTgzw1Ik6KuksIFegSGaSDJCVBxCt6AYVtNqXXW9bfXIwkTbvk2cdrjRB240m
        g8nIu9XL1+jL8bYaXz66lgqQVTRmEgZZCIlO4I7foBRolSyMMTtoqC+3U5rpcw==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Bharath SM <bharathsm.hsk@gmail.com>, pc@cjr.nz, sfrench@samba.org,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
        linux-cifs@vger.kernel.org
Cc:     Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH] SMB3: Add missing locks to protect deferred close file
 list
In-Reply-To: <20230420160646.291053-1-bharathsm.hsk@gmail.com>
References: <20230420160646.291053-1-bharathsm.hsk@gmail.com>
Date:   Thu, 20 Apr 2023 14:45:16 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Bharath SM <bharathsm.hsk@gmail.com> writes:

> From: Bharath SM <bharathsm@microsoft.com>
>
> cifs_del_deferred_close function has a critical section which modifies
> the deferred close file list. We must acquire deferred_lock before
> calling cifs_del_deferred_close function.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/cifs/misc.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index a0d286ee723d..89bbc12e2ca7 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -742,7 +742,10 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
>  	list_for_each_entry(cfile, &cifs_inode->openFileList, flist) {
>  		if (delayed_work_pending(&cfile->deferred)) {
>  			if (cancel_delayed_work(&cfile->deferred)) {
> +

No need for this extra blank line.  Please remove the below ones as
well.

With the "Fixes:" tag added as per Ronnie's suggestion,

Acked-by: Paulo Alcantara (SUSE) <pc@manguebit.com>

> +				spin_lock(&cifs_inode->deferred_lock);
>  				cifs_del_deferred_close(cfile);
> +				spin_unlock(&cifs_inode->deferred_lock);
>  
>  				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
>  				if (tmp_list == NULL)
> @@ -773,7 +776,10 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
>  	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
>  		if (delayed_work_pending(&cfile->deferred)) {
>  			if (cancel_delayed_work(&cfile->deferred)) {
> +
> +				spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
>  				cifs_del_deferred_close(cfile);
> +				spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
>  
>  				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
>  				if (tmp_list == NULL)
> @@ -808,7 +814,10 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
>  		if (strstr(full_path, path)) {
>  			if (delayed_work_pending(&cfile->deferred)) {
>  				if (cancel_delayed_work(&cfile->deferred)) {
> +
> +					spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
>  					cifs_del_deferred_close(cfile);
> +					spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
>  
>  					tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
>  					if (tmp_list == NULL)
> -- 
> 2.34.1
