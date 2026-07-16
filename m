Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2419234994
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 02:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784168043; cv=none; b=iPWheyrbJiZvQebK7BBih5vtNyDOOUSHs7phLp/b7ErU3TomWdsCanirzIVBFgGTv9FIyp5T221E08a27OCD2abqvCCRhb/EPjOt63PYNXl08+HSZMmS5+rNQmjDJCIHwmw6ElPs1+AreaXv9oAWiG2wEnyv6Xe1X0lS6ErBo48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784168043; c=relaxed/simple;
	bh=fQnLcJS76HM/B/27Dnf1wZdbiclEZsd3SvV+AU/RBTg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SuH/sIQ3+Z3np9Q2+0fzD04Bhwha+vdgjc2hn4TvaRvHv2684aWMLZYfZMYXnQ6RJvc2O7hi1NiblS/pl/KSQoyr86H6JqxQeR1g1MymYMaukA2brMcL4kejxqjCeZ/srkjvPzzTeg8U7YlRO6a9N7R0XUD8eLRuG83RLN3bl0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LT8tXUtl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LT8tXUtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9961F1F00A3F
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 02:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784168042;
	bh=Ki6Xh+fCoh9cOV7Du0kTNbWy6ly9BKcuw7PRYzUCJwA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LT8tXUtlK3+VBgfLpsKCPC4KCBPSHwJkevQEqAUT415MiVd+Uapgd2ivbMPbEdsPx
	 LCWavmI0phQ3enx6ZP79ry9kuqLohTYqHfTmloyn1rCddyLuVeekhWoanYEQRNA4dV
	 A9Sybl7iHe6JeQUyVltFqOWr36794/fzfaLKNVOUcSh1xJ0/U2OCbuYTVEUCVV0FxI
	 APvt+grSUE4fsnd7uorh/FEi71ifZvv+3GiaE6xKgwVyrw8cfs9h70Gw/7map+9EKa
	 5ZXyiNBSRJ5gfUiAjdHznN/4Ll6/Nnlp9dPWZgsD/11gJtT/5bfiYZTFiMwC2lmzc6
	 bQKQm86XPMAmw==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c1671ec8692so233842366b.0
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 19:14:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoC06BGX6rMDiY/k3gPFOfklLXMx6ZCkC2wtkDM5D+xQavSZisR+IdQlumFt3IRbcyJMDLVum8NgHGb@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3VCXlCsM66xQKyJ/FYBod7s6kjcYhYn7gD4gYYnAfrYXqxkbI
	SFujr0EPLEasPv2lKV5oc98/rIHQOCJsrmVvpBh+1HAG8Uzgw4ndXj9pHL4jtiW2R1zVmFGM7SJ
	A3vfowXRhMa19zUXYDqyrZiVraL4EuJs=
X-Received: by 2002:a17:907:9613:b0:c16:1a3:9025 with SMTP id
 a640c23a62f3a-c1679368f06mr391930766b.57.1784168041178; Wed, 15 Jul 2026
 19:14:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260716001156.671587-1-chenxiaosong@chenxiaosong.com> <20260716001156.671587-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260716001156.671587-3-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 16 Jul 2026 11:13:49 +0900
X-Gmail-Original-Message-ID: <CAKYAXd80TEVZB2GYeYCfhhyN99HyD89ZP_9NjON6caoXuMWTDg@mail.gmail.com>
X-Gm-Features: AUfX_mwGMsaJCSbZDL_c5fm07agP8Z4zTAI995_WLRsy4BJYEHDAhMGC2eCNIFU
Message-ID: <CAKYAXd80TEVZB2GYeYCfhhyN99HyD89ZP_9NjON6caoXuMWTDg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] smb/server: cancel async requests when closing connection
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	gael.blivet@gmail.com, andriy.shevchenko@linux.intel.com, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> +static void ksmbd_conn_cancel_async_requests(struct ksmbd_conn *conn)
> +{
> +       struct ksmbd_work *work;
> +
> +       ksmbd_debug(CONN, "Cancel pending async requests on releasing connection\n");
> +       spin_lock(&conn->request_lock);
> +       list_for_each_entry(work, &conn->async_requests, async_request_entry) {
smb2_notify_cancel_fn() calls list_del_init() on async_request_entry.
With list_for_each_entry(), the loop increment then follows the
self-linked entry again, causing an infinite loop while holding
request_lock ? So, should we use list_for_each_entry_safe() ?

> +               if (work->state != KSMBD_WORK_ACTIVE)
> +                       continue;
> +
> +               ksmbd_debug(CONN, "Cancel async request id %d\n",
> +                           work->async_id);
> +               work->state = KSMBD_WORK_CANCELLED;
> +               if (work->cancel_fn)
> +                       work->cancel_fn(work->cancel_argv);
> +       }
> +       spin_unlock(&conn->request_lock);
> +}
> +
>  void ksmbd_conn_lock(struct ksmbd_conn *conn)
>  {
>         mutex_lock(&conn->srv_mutex);
