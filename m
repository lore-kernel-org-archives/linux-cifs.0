Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479D3C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  3 May 2022 23:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiECX7Z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 May 2022 19:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiECX7V (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 May 2022 19:59:21 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F312A1AA
        for <linux-cifs@vger.kernel.org>; Tue,  3 May 2022 16:55:46 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 27F487FC20;
        Tue,  3 May 2022 23:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1651622145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OB17PS86umE8Lzurri+ELnsu000t2609mjV1pbwg12M=;
        b=0d2cxk1GeJaT18TeZM0/MamcLdvTLLzyEVPacNQB5e2V0OtdIdr3WaDwqas4w05UqUts6t
        HQVSv9IsqqoLyq9rEpoeRcW+c6gCowtTmpixZyqwqNwC3cmybVnkh14D8/ZduAiqVfF3re
        cvhSeuFXaZU3pRItCxByHqLzJyQcifTP+QcSA26zNOLQ5rXqXPS1Z0IlW2Su7l8Ooe0YkV
        5FbfawERb2jbIw6Ag5VPg99731t54Wlvv4XpbfrHDg9AjFnh8piQ7OwmwCGr4/xcuvfDgE
        R7FS+ldQYBqMie3FYWfLmGHQXL23M8qcVjoCIUj9z2TFL3V58K9se4PmEoAi0g==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: cache dirent names for cached directories
In-Reply-To: <20220503070959.2276616-2-lsahlber@redhat.com>
References: <20220503070959.2276616-1-lsahlber@redhat.com>
 <20220503070959.2276616-2-lsahlber@redhat.com>
Date:   Tue, 03 May 2022 20:55:40 -0300
Message-ID: <87bkwe2mtf.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Ronnie,

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 1929e80c09ee..8b3fbe6b3580 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -840,9 +840,112 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
>  	return rc;
>  }
>  
> +static bool emit_cached_dirents(struct cached_dirents *cde,
> +				struct dir_context *ctx)
> +{
> +	struct list_head *tmp;
> +	struct cached_dirent *dirent;
> +	int rc;
> +
> +	list_for_each(tmp, &cde->entries) {
> +		dirent = list_entry(tmp, struct cached_dirent, entry);

What about list_for_each_entry()?

> +static void add_cached_dirent(struct cached_dirents *cde,
> +			      struct dir_context *ctx,
> +			      const char *name, int namelen,
> +			      struct cifs_fattr *fattr)
> +{
> +	struct cached_dirent *de;
> +
> +	if (cde->ctx != ctx)
> +		return;
> +	if (cde->is_valid || cde->is_failed)
> +		return;
> +	if (ctx->pos != cde->pos) {
> +		cde->is_failed = 1;
> +		return;
> +	}
> +	de = kzalloc(sizeof(*de), GFP_ATOMIC);
> +	if (de == NULL) {
> +		cde->is_failed = 1;
> +		return;
> +	}
> +	de->name = kzalloc(namelen + 1, GFP_ATOMIC);
> +	if (de->name == NULL) {
> +		kfree(de);
> +		cde->is_failed = 1;
> +		return;
> +	}
> +	memcpy(de->name, name, namelen);

Replace the above kzalloc() & memcpy() with kstrndup()?

> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index d6aaeff4a30a..10170266f44b 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -699,6 +699,8 @@ smb2_close_cached_fid(struct kref *ref)
>  {
>  	struct cached_fid *cfid = container_of(ref, struct cached_fid,
>  					       refcount);
> +	struct list_head *pos, *q;
> +	struct cached_dirent *dirent;
>  
>  	if (cfid->is_valid) {
>  		cifs_dbg(FYI, "clear cached root file handle\n");
> @@ -718,6 +720,21 @@ smb2_close_cached_fid(struct kref *ref)
>  		dput(cfid->dentry);
>  		cfid->dentry = NULL;
>  	}
> +	/*
> +	 * Delete all cached dirent names
> +	 */
> +	mutex_lock(&cfid->dirents.de_mutex);
> +	list_for_each_safe(pos, q, &cfid->dirents.entries) {
> +		dirent = list_entry(pos, struct cached_dirent, entry);

list_for_each_entry_safe()?

Nice job!  Looks good to me,

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
