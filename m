Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11205ECAAA1
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 10:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiJ1KtY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 06:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbiJ1KtV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 06:49:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF401CB517
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 03:49:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD4946279E
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 10:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C93BC433D6;
        Fri, 28 Oct 2022 10:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666954160;
        bh=vC2RetaYwcQdXODq6Fy2Us2LkDfhT/Qr/UP8bwHn3xc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PLK6GNekvtxUCyIexugxAaNGYbKXVeMq1vfM0vKX7hDT0ogZ83KAmEN9E+iZDyccK
         oCnxA+SdeC5mwr4FeqNz5sNm2kmH25ra3QLjwLUL99DHxQPfI6BkWfq4DINRt9Tf/F
         Q4qhakDYn29mliVr9TIIbTkJT6C/sohw1s1kQmeeVyiz5/18+Ali7304oCTi6TD4xO
         OCflB/kTfGzDmLCKh2ggIW4eGb2aJi8aGNj0EpmYiV4tfOXuVV7/q/pTpvsI4v5PWS
         XwXK8Ah3ZqvFfVB50YJyaxmXy1mfFC5gLh0swNoXGQ4YDs3OtmegSpeZgrbPfWGEkm
         eE+E61sWoBTDQ==
Date:   Fri, 28 Oct 2022 12:49:16 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [bug report] cifs: implement set acl method
Message-ID: <20221028104916.cwrghgnjy7ocjeju@wittgenstein>
References: <Y1uxJVwln0+gTaFz@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y1uxJVwln0+gTaFz@kili>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Oct 28, 2022 at 01:38:29PM +0300, Dan Carpenter wrote:
> Hello Christian Brauner,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch dc1af4c4b472: "cifs: implement set acl method" from Sep 22,
> 2022, leads to the following Smatch complaint:
> 
>     fs/cifs/cifsacl.c:1781 cifs_set_acl()
>     warn: variable dereferenced before check 'acl' (see line 1773)
> 
> fs/cifs/cifsacl.c
>   1772			returns as xattrs */
>   1773		if (posix_acl_xattr_size(acl->a_count) > CIFSMaxBufSize) {
>                                          ^^^
> I looked at the callers and "acl" can definitely be NULL at this point.
> I feel like it would be nice to check it earlier and goto out directly,
> but I don't know what a NULL acl is for...
> 
>   1774			cifs_dbg(FYI, "size of EA value too large\n");
>   1775			rc = -EOPNOTSUPP;
>   1776			goto out;
>   1777		}
>   1778	
>   1779		switch (type) {
>   1780		case ACL_TYPE_ACCESS:
>   1781			if (!acl)
>                             ^^^^
> Too late.  And later on there is another check as well.
> 
>   1782				goto out;
>   1783			if (sb->s_flags & SB_POSIXACL)
> 
> regards,
> dan carpenter

Thanks for the report, Dank. I added the following fix on top. If that
work out I'll likely fold it into the original commit though given that
we're very still pre -rc4:

commit cb2144d66b0b24fd1b880fc72678ba21ca414dab (HEAD -> fs.acl.rework)
Author:     Christian Brauner <brauner@kernel.org>
AuthorDate: Fri Oct 28 12:45:10 2022 +0200
Commit:     Christian Brauner (Microsoft) <brauner@kernel.org>
CommitDate: Fri Oct 28 12:45:10 2022 +0200

    cifs: check whether acl is valid early

    Dan reported that acl is dereferenced before being checked and this is a
    valid problem. Fix it be erroring out early instead of doing it later after
    we've already relied on acl to be a valid pointer.

    Fixes: dc1af4c4b472 ("cifs: implement set acl method")
    Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 6a9f03c882dc..c647f0d56518 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1764,6 +1764,10 @@ int cifs_set_acl(struct user_namespace *mnt_userns, struct dentry *dentry,
                rc = PTR_ERR(full_path);
                goto out;
        }
+
+       if (!acl)
+               goto out;
+
        /* return dos attributes as pseudo xattr */
        /* return alt name if available as pseudo attr */

@@ -1778,8 +1782,6 @@ int cifs_set_acl(struct user_namespace *mnt_userns, struct dentry *dentry,

        switch (type) {
        case ACL_TYPE_ACCESS:
-               if (!acl)
-                       goto out;
                if (sb->s_flags & SB_POSIXACL)
                        rc = cifs_do_set_acl(xid, pTcon, full_path, acl,
                                             ACL_TYPE_ACCESS,
@@ -1788,8 +1790,6 @@ int cifs_set_acl(struct user_namespace *mnt_userns, struct dentry *dentry,
                break;

        case ACL_TYPE_DEFAULT:
-               if (!acl)
-                       goto out;
                if (sb->s_flags & SB_POSIXACL)
                        rc = cifs_do_set_acl(xid, pTcon, full_path, acl,
                                             ACL_TYPE_DEFAULT,

