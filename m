Return-Path: <SRS0=XnNO=4O=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D937CC4BA13
	for <linux-cifs@archiver.kernel.org>; Wed, 26 Feb 2020 15:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD60C24684
	for <linux-cifs@archiver.kernel.org>; Wed, 26 Feb 2020 15:39:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dIGRq1An"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgBZPju (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 Feb 2020 10:39:50 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43249 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbgBZPju (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 Feb 2020 10:39:50 -0500
Received: by mail-pf1-f193.google.com with SMTP id s1so1629948pfh.10
        for <linux-cifs@vger.kernel.org>; Wed, 26 Feb 2020 07:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D8kpTrC+jNk7ps+d2vySu+gO16qFSpiseAZm/mvF674=;
        b=dIGRq1An5CJUJbTNn9qbvu2RPLygM1jN03igPNxHAt5d/Idm8JPlyuZMD4fF9jzhMd
         tZDMSKTY3Lq2aN51MGiTLE0nMq7k/uO/8MFtjWuY8Nri2vn9GDofc26LrvmiXgse+UBF
         p0Pky5tNWYZ/jJ/kwPpqwn7dfxKoGCygk3IQHcsuzKvnJK9OYZeUjHcT91jM2sgQc6bg
         Kgd6HkYBeHSLithrf/zLQlb/NnYvAmETTiMamNpj4qane+0tbM/OML8HZlx4UKH6H0T2
         q33oLxRJrpMEMjXq0AYyCqiymcsGRcJc0Eb3aN3IZjN54roPB9oWnLuWMfEAEc/FTbi1
         sYoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D8kpTrC+jNk7ps+d2vySu+gO16qFSpiseAZm/mvF674=;
        b=CWWluVbupletSbR8UgoXA9WkkjipgJ4fC+KbzNCmbqZjhvmHad4VN+IY5J3wZZA/Om
         OR/rnIrfpdcoUl0gPJ7PAaoyQvDIPltTUKvf/IOMwtg3GcegxUH9ifWo78NMmD0Svxby
         Ra2uxs1MkaAu6WngGCtqAY4ix61Gv5XzvNU5CQfij7seBQaX5CrIj3ANM0YYHxAC1gMQ
         Po6u8gfVMUH1ErFy7tgjilyIhhC1MaSw/JnTiq+wVoemJhtwCwR25r/a/GnfUVovn0qg
         6kWcDZ9IbtfViO1FFSLFN96BqFwoDP2YvDE25n3ZqkMi9H8JCrEMxionWcSmnVQWBRYc
         hq5Q==
X-Gm-Message-State: APjAAAWF+7IFYCtl8PIIZeXsJwy8CzYTWxg5RYoaAVKA1Ek6qNlCPdCp
        o9FlVzLxgxnpS3zwv8WfZCX4Exsb
X-Google-Smtp-Source: APXvYqyXQhODes9SRofLQDu9Mh3iiOXLqaArs4fLWWkXK+eQ3lDaNvAmqkpHMxbmSbtm0kBLWqCRCw==
X-Received: by 2002:a62:2ad1:: with SMTP id q200mr5113001pfq.123.1582731588841;
        Wed, 26 Feb 2020 07:39:48 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a2sm3594076pfi.30.2020.02.26.07.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 07:39:48 -0800 (PST)
Date:   Wed, 26 Feb 2020 23:39:41 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Murphy Zhou <jencce.kernel@gmail.com>
Subject: Re: [PATCH v2] cifs: allow unlock flock and OFD lock across fork
Message-ID: <20200226153941.xv7xsrh623zp3s7w@xzhoux.usersys.redhat.com>
References: <20200221023001.vcoc5f43rdqqeifn@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221023001.vcoc5f43rdqqeifn@xzhoux.usersys.redhat.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Feb 21, 2020 at 10:30:01AM +0800, Murphy Zhou wrote:
> Since commit d0677992d2af ("cifs: add support for flock") added
> support for flock, LTP/flock03[1] testcase started to fail.
> 
> This testcase is testing flock lock and unlock across fork.
> The parent locks file and starts the child process, in which
> it unlock the same fd and lock the same file with another fd
> again. All the lock and unlock operation should succeed.
> 
> Now the child process does not actually unlock the file, so
> the following lock fails. Fix this by allowing flock and OFD
> lock go through the unlock routine, not skipping if the unlock
> request comes from another process.
> 
> Patch has been tested by LTP/xfstests on samba and Windows
> server, v3.11, with or without cache=none mount option.

Also tested with or without "nolease" mount option. No new
issue shows.

Thanks!
> 
> [1] https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/flock/flock03.c
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
>  fs/cifs/smb2file.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
> index afe1f03aabe3..eebfbf3a8c80 100644
> --- a/fs/cifs/smb2file.c
> +++ b/fs/cifs/smb2file.c
> @@ -152,7 +152,12 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
>  		    (li->offset + li->length))
>  			continue;
>  		if (current->tgid != li->pid)
> -			continue;
> +			/*
> +			 * flock and OFD lock are associated with an open
> +			 * file description, not the process.
> +			 */
> +			if (!(flock->fl_flags & (FL_FLOCK | FL_OFDLCK)))
> +				continue;
>  		if (cinode->can_cache_brlcks) {
>  			/*
>  			 * We can cache brlock requests - simply remove a lock
> -- 
> 2.20.1
> 
> 

-- 
Murphy
