Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF01CC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 08:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1DC86103E
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 08:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241784AbhIGIkD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 04:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236858AbhIGIkC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Sep 2021 04:40:02 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41FAC061575
        for <linux-cifs@vger.kernel.org>; Tue,  7 Sep 2021 01:38:55 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id s29so7590974pfw.5
        for <linux-cifs@vger.kernel.org>; Tue, 07 Sep 2021 01:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+nCpdOgVIRQsk4LFVtzynowlodPdmMjIIH75EckValY=;
        b=MfpSlX3gRuHZ8yjP0duQ15kI4yLC7y6QT0dwVq2SxKYOFGGF+s95tnQ2dCu2NH/HlA
         oY+qFZJscen0tcK9IsOWIDF69VXOks7Srje88EkkAg0ghamgKuWqYVOnAK5zdWbG32as
         3jBUokG4zS1rW7KeVRApLVsSCn5uYpcVvswnY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+nCpdOgVIRQsk4LFVtzynowlodPdmMjIIH75EckValY=;
        b=Y+Lghja3opQEVopHPX23vBxNsPltz2zPkQA/bqRl4CY6hYv3BeRb+Y7jmcjM5eqCq8
         Vlzt1zSSQsHr0xdc5qPG72vGdo4tBQ33azP9ASb39ED1W9CWwTO1O2CkvSseK0MM1h/7
         pORaShMjzsukzosFap6//dohaUCgyzyQlr4P0U3KaNBBdpLbymBU3seoyvElJJEPDvqQ
         sT064OSs2ulINNBNUsLQnQQFnVioRXGdcaYtRP1231Rp2hqieyHOLoogcITn3vbQy8VE
         P4I/G242HSXzmbF8m3mnGjC0EJe4TVtFofWPPRJR2YbQx5i6m/uLv8+z9xcKbDcdoVSM
         PCKQ==
X-Gm-Message-State: AOAM530VWU8LFMBhPOp26L3Psz6Yv1V4hEeEZuObDzOHC3S2QsKV+i/2
        zzFKeV/4da4NtgBNRRrpaln9zw==
X-Google-Smtp-Source: ABdhPJxzmVq5GML8j7GNYiV8Z9skyx6xWjZ0mMbX9eRbN9rjmFoHUuv70pgiwqDJNSGhgd8T61klfA==
X-Received: by 2002:a63:5947:: with SMTP id j7mr15914828pgm.193.1631003935552;
        Tue, 07 Sep 2021 01:38:55 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:4040:44a5:1453:e72c])
        by smtp.gmail.com with ESMTPSA id p30sm9925472pfh.116.2021.09.07.01.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 01:38:54 -0700 (PDT)
Date:   Tue, 7 Sep 2021 17:38:50 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ksmbd: potential uninitialized error code in
 set_file_basic_info()
Message-ID: <YTclGhwxhjHxODQz@google.com>
References: <20210907073340.GC18254@kili>
 <YTccRzi/j+7t2eB9@google.com>
 <CAKYAXd9rQU-u6q2ptqfGjFAND_VCRY4GqyF6th_b0u8Q__ckJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd9rQU-u6q2ptqfGjFAND_VCRY4GqyF6th_b0u8Q__ckJQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (21/09/07 17:09), Namjae Jeon wrote:
> 2021-09-07 17:01 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> > On (21/09/07 10:33), Dan Carpenter wrote:
> >>
> >> Smatch complains that there are some paths where "rc" is not set.
> >>
> >> Fixes: eb5784f0c6ef ("ksmbd: ensure error is surfaced in
> >> set_file_basic_info()")
> >> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >> ---
> >>  fs/ksmbd/smb2pdu.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> >> index a350e1cef7f4..c86164dc70bb 100644
> >> --- a/fs/ksmbd/smb2pdu.c
> >> +++ b/fs/ksmbd/smb2pdu.c
> >> @@ -5444,7 +5444,7 @@ static int set_file_basic_info(struct ksmbd_file
> >> *fp, char *buf,
> >>  	struct file *filp;
> >>  	struct inode *inode;
> >>  	struct user_namespace *user_ns;
> >> -	int rc;
> >> +	int rc = 0;
> >>
> >>  	if (!(fp->daccess & FILE_WRITE_ATTRIBUTES_LE))
> >>  		return -EACCES;
> >
> > It sort of feels like that `rc' is not needed there at all. It's being used
> > in
> >
> >                rc = ksmbd_vfs_set_dos_attrib_xattr(user_ns,
> >                                                    filp->f_path.dentry,
> > &da);
> >                if (rc)
> >                       ksmbd_debug(SMB,
> >                                  "failed to restore file attribute in
> > EA\n");
> >
> > and in
> >
> >                rc = setattr_prepare(user_ns, dentry, &attrs);
> >                if (rc)
> >                         return -EINVAL;
> >
> > Either it should be used more, and probably be a return value, or we can
> > just remove it.
> This patch is correct. But I have already fixed it.
> You can understand it if you check #ksmbd-for-next branch, not master.
> 
> https://git.samba.org/?p=ksmbd.git;a=shortlog;h=refs/heads/ksmbd-for-next



I assume it's "ksmbd: ensure error is surfaced in set_file_basic_info()"


If none of the branches that set `rc' is taken then function returns
random stack value:

---

	int rc;

	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_STORE_DOS_ATTRS) ... {
		rc = ...
	}

	if (attrs.ia_valid) .... {
		rc = ...
	}

	return rc;
---
