Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C690CC433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 06:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D5D761A7D
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 06:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhJBGCC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 02:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhJBGCC (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Oct 2021 02:02:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DDCE61AAD
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 06:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633154417;
        bh=RkuoWf168ho+1/uh2STF/gUbhy4pQDTFjH5ykC2sdO4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=FL5bCoBaHi/DOMfhkhjdo8+hNYE1eGFfu3AGMO5crqv7wxP13LhkJ2qPh27RF7gAW
         wxtr9hor6yHswn59GtibTfm1sfHVTa5H9zlPDVkyoZ5sB2s/tlVLLwhlu6Su4xoau8
         jprGxDaVD1TUJ9GZwO76Br+XGkwWelSgHSmg1vQ5BwaBdflvOcGfL5TjydwkNJEt77
         sw+bOYtILIjVHVnhv7LP7TBsuuJrurQ2P4/WWCM30lOpdof2MvBPmTBhnwSuKvcDaV
         kymB4A+eb3AnU0xp8o7ZxriQsp8Jr0gxqiQaHVSRdto6xyMz5AZupsJA36PHhk7LIL
         vCJqdAU05Uc2Q==
Received: by mail-oi1-f178.google.com with SMTP id s69so14191187oie.13
        for <linux-cifs@vger.kernel.org>; Fri, 01 Oct 2021 23:00:17 -0700 (PDT)
X-Gm-Message-State: AOAM530x+UrL4n1kFi2aHcPblaL2bRtLAPNKuC2OXMd6okChWZZqKi/r
        Ec2/DhIWtgI2UHs/vEF+YkO6up0qoCQ5l8yneyA=
X-Google-Smtp-Source: ABdhPJzNzieT00bdpvXWjay75gqY6kUG7SogNSE1ktUuL1DB+GZ8rPPNpiDq9jt5lALRia8QjJMLpxd8mDXyxcUAG70=
X-Received: by 2002:aca:3704:: with SMTP id e4mr6883796oia.32.1633154416602;
 Fri, 01 Oct 2021 23:00:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Fri, 1 Oct 2021 23:00:16 -0700 (PDT)
In-Reply-To: <20211001120421.327245-19-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org> <20211001120421.327245-19-slow@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 2 Oct 2021 15:00:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_rfAXxhzPmr6rkZB2m5uJKSyD7qQqHempE7cCYdr1WQQ@mail.gmail.com>
Message-ID: <CAKYAXd_rfAXxhzPmr6rkZB2m5uJKSyD7qQqHempE7cCYdr1WQQ@mail.gmail.com>
Subject: Re: [PATCH v5 18/20] ksmdb: make smb2_get_ksmbd_tcon() callable with
 chained PDUs
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-01 21:04 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Also track the tcon id of compound requests.
>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Ralph Boehme <slow@samba.org>
> ---
>  fs/ksmbd/ksmbd_work.h | 1 +
>  fs/ksmbd/smb2pdu.c    | 9 ++++++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ksmbd/ksmbd_work.h b/fs/ksmbd/ksmbd_work.h
> index f7156bc50049..91363d508909 100644
> --- a/fs/ksmbd/ksmbd_work.h
> +++ b/fs/ksmbd/ksmbd_work.h
> @@ -46,6 +46,7 @@ struct ksmbd_work {
>  	u64				compound_fid;
>  	u64				compound_pfid;
>  	u64				compound_sid;
> +	u32				compound_tid;
>
>  	const struct cred		*saved_cred;
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 7d3344b5519c..5b1fead05c49 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -98,6 +98,8 @@ int smb2_get_ksmbd_tcon(struct ksmbd_work *work)
>  	int tree_id;
>
>  	work->tcon = NULL;
> +	work->compound_tid = 0;
> +
>  	if (cmd == SMB2_TREE_CONNECT_HE ||
>  	    cmd ==  SMB2_CANCEL_HE ||
>  	    cmd ==  SMB2_LOGOFF_HE) {
> @@ -110,13 +112,18 @@ int smb2_get_ksmbd_tcon(struct ksmbd_work *work)
>  		return -ENOENT;
>  	}
>
> -	tree_id = le32_to_cpu(req_hdr->Id.SyncId.TreeId);
> +	if (req_hdr->Flags & SMB2_FLAGS_RELATED_OPERATIONS)
> +		tree_id = work->compound_tid;
Well, Isn't that a performance degradation due to unneeded lookups?
> +	else
> +		tree_id = le32_to_cpu(req_hdr->Id.SyncId.TreeId);
> +
>  	work->tcon = ksmbd_tree_conn_lookup(work->sess, tree_id);
>  	if (!work->tcon) {
>  		pr_err("Invalid tid %d\n", tree_id);
>  		return -EINVAL;
>  	}
>
> +	work->compound_tid = tree_id;
>  	return 1;
>  }
>
> --
> 2.31.1
>
>
