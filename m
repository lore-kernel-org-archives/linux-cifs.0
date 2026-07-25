Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427BD1FBC8E
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 13:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784987071; cv=none; b=F7W8I3KmB6+TziDnYIMmU+vYQYsYEo5gR8xusnyquLI0TPKTwpEY/O/w0db6f5tRulFl0hHd0aG4njuS0SCNYl86NNYM+ThUd6jlX12ER2JHSRW1LPbsPwt7aI8zkWEV5gMcXCNnwStiLjvwkCRu+b9M+xzFfQc/ygug3U5Pl8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784987071; c=relaxed/simple;
	bh=1oNcqIVe7yN6EPLewVOGo7I+cUgYVb8ISg+R7AqpSDk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z5akVSyIHvnskU5DyK7ZDpLQU6o8JbVr5Dny6FBbN3qMWLWxuu3FB4XW7acBUQhFVU8Mw5sP28yiyFDxOX14vt6h+y+y2Et2ZwE4UenPqn3h8U2B0KGS9HpoC1sw7jkF02+jhhJBgMQjdHch66FtUEMPnUtP9tMNAoMZOCDYgus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Unvfq00o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Unvfq00o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378571F00ACA
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 13:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784987069;
	bh=yFRuy9VQDhzn4Brojh+rbgIu+yw0UyjOqRYpnvLACqY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Unvfq00omOCl7BeZ6AguZI4AC4do3DGolEKSHfrQPwb1UT3mx4fVTggOYzGobdkcO
	 RP1Z4eWX14PQ6/pnY2MH00ea1WuEhtLqT86rs+fczXfmAyY4IGHKwz6VhtihFSK/u3
	 IWbsKFuDV81jIuBtpWNae64U8rt20+OSE4eSdtqkXlcvqrMYE9yboYb4jUbh2HpaSl
	 P/jn+iWMVaqpXEhAqHxva3dFLCErHJhHqa0P+2Np4IydtgQUe9SJwCZbxj0/iMSFnV
	 q7ubcRTQyhyogvb2IqYpTYGK46ZzXFA7KqnMcsUO6m/OHc/+XXZ147Opt0NjsLxdtw
	 +LZVwsMsrsguA==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15b33f7b23so207368566b.3
        for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 06:44:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrqxKRb37gKy1HUpHrAAP9oH2+31TF/vyGhbOfqxhxzBi1iKbfjSXjdhEzk52roUmrHCeZ2tQPbFZc1@vger.kernel.org
X-Gm-Message-State: AOJu0YzGozZ/8NzOXqlDIGZ6lqG3m5xU1BRxSAPWgm/T7zvQf/xvdrD4
	iOq92aBi8QNDOcEtSSqrwDp6rcoLCH70r5WjzryrpwdkWyC7F440ggjUA6irpFh6aP4+nl4pVHt
	cXfDQkb+TOhJ626OoGKGH1b2fSELmmJg=
X-Received: by 2002:a17:907:d08d:b0:c12:36ff:6ebb with SMTP id
 a640c23a62f3a-c1f1f0d5e3bmr95653766b.44.1784987067821; Sat, 25 Jul 2026
 06:44:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com> <20260723031644.312866-5-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260723031644.312866-5-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 25 Jul 2026 22:44:13 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Oc3YbYaHDjs5_r9Uz=dcWy=JR49wYVhOhnA2MP3UC=A@mail.gmail.com>
X-Gm-Features: AUfX_mwD53kEEhKnbn_0p8CXVPH0QybHUaPCuOplQWTZpGSLpVfK6sebhRVD1tk
Message-ID: <CAKYAXd9Oc3YbYaHDjs5_r9Uz=dcWy=JR49wYVhOhnA2MP3UC=A@mail.gmail.com>
Subject: Re: [RFC PATCH 04/11] smb/server: watch directories for changes
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	gael.blivet@gmail.com, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> +static struct fsnotify_mark *
> +ksmbd_notify_add_mark(struct ksmbd_notify *notify, u32 mask,
> +                     struct fsnotify_group **group)
> +{
> +       struct ksmbd_notify_mark *notify_mark;
> +       int err;
> +
> +       *group = fsnotify_alloc_group(&ksmbd_notify_fsnotify_ops, 0);
> +       if (IS_ERR(*group)) {
> +               pr_err("Failed to allocate fsnotify group: %ld\n",
> +                      PTR_ERR(*group));
> +               return ERR_CAST(*group);
> +       }
> +
> +       notify_mark = kzalloc_obj(*notify_mark, KSMBD_DEFAULT_GFP);
> +       if (!notify_mark) {
> +               pr_err("Failed to allocate fsnotify mark\n");
> +               err = -ENOMEM;
> +               goto err_put_group;
> +       }
> +
> +       notify_mark->notify = notify;
> +       fsnotify_init_mark(&notify_mark->mark, *group);
> +       notify_mark->mark.mask = mask | FS_EVENT_ON_CHILD;
Where is SMB2_WATCH_TREE handled?
FS_EVENT_ON_CHILD only reports events for immediate children of this
inode. it does not recursively monitor descendants.

>  static struct ksmbd_file *
>  ksmbd_notify_validate_req(struct ksmbd_work *work,
>                           struct smb2_change_notify_req *req,
> @@ -88,10 +270,40 @@ ksmbd_notify_validate_req(struct ksmbd_work *work,
>         return ERR_PTR(err);
>  }
>
> +static struct ksmbd_notify *
> +ksmbd_notify_setup_watch(struct ksmbd_file *fp,
> +                        struct smb2_change_notify_req *req,
> +                        struct smb2_change_notify_rsp *rsp)
> +{
> +       struct ksmbd_notify *notify;
> +       u32 filter, mask;
> +       int err;
> +
> +       filter = le32_to_cpu(req->CompletionFilter);
> +       mask = ksmbd_notify_map(filter);
> +       if (!mask) {
Please do not reject a CompletionFilter merely because no currently
mapped bit remains.
If no valid bits remain, the request must stay pending until it is
cancelled or the directory handle is closed.
Also, the mapping currently omits valid filter bits such as
FILE_NOTIFY_CHANGE_SIZE, FILE_NOTIFY_CHANGE_CREATION, and the
stream-related filters. Those need either implementation or explicitly
correct handling according to the protocol requirements.
