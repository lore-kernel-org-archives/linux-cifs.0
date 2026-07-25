Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A85230D40A
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 14:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784988150; cv=none; b=nErvlDOHsosB7PefEf5erdLs8KhzHwWuxPgcfnLaRfto0wsdKU7L59ACsgE5074ptdcOAm1ALDs0ySVh9cEKrghJr0EGCWKNF/EUTfcQ0RbKnueirUmNN4rklGZLvToATbswOAXbwf7sZMvtE6c6iKGzrYUiRYw2T70HGC+2MRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784988150; c=relaxed/simple;
	bh=PEM8f6hyXHaz7m8gl86tF3wjiK6WXKsyDI9OMcG0//g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f5MclWTYoG8T/KlU93Bhq/cS9knrI4hBVcEnc7Kf/mKpGKSgOLJQGir+W5B3yJuUZsY5+b2nAofsE5pDj89BZ1Cl3nToQ/XSe9nxgCEAHeq0UUaP/GNAFMetOPMFSXHS9VZQJ806uEHXavjUjcZ8nzNZNNCY1ztmt/0/uxn1Sj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TNAHHSj5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TNAHHSj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008AA1F00A3D
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 14:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784988149;
	bh=5X+imHMCF1EIXfVbhE+jukAfFYTQ5F5samMr17QyonI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TNAHHSj5TpoIoQtzvEOeYJzopLscXaOGffUw6HAX6q9fnXzGCLyJrxj7E5CKXjUJy
	 N103WXFde7fhlWgjzrDDlFKPpd/9DLfYo2+D4aDXT0k0D5YMpvT7mgjM4dodHzCYop
	 +O6mdK2ST6AjLw1/L8SpgWVSetPsS5je8bvkfSylBPFaWC2ZYsY3kW35xPxs2NJMMQ
	 zE9SGqD111VNlIIp40vecqeooom0oYhq6Mgq0cz0Aq4L1DgxgI76cqufMUOBQ+C/z6
	 BerA8nYam5UFShRBu1vvec5V8lXNeGvrKERV22z6KchJVGrOdhYPENbx6g0Md//NbT
	 8SWZ664cVmW1w==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-698bf053053so1846889a12.3
        for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 07:02:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrlKPEEWJzvVuAD0SdKFptyoytOigMCjCIGxbzIdGCIfu3IQwYIMQ+bN4Y1L78NtCMO6rPPhWofUlEu@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/pn5t5+NmZrfKNZvLqzFc1DsWt0RsH0l++3lI8LdlwqxzO0KQ
	SmMv5C5o+km4+6fsJ7h9NmK2zax9kOPVqb8BY7JGxygtqIbJYRLLU1lNOaxr6DUFzBD1CVOMrzD
	5zGQlc/yIFF5ZdScYVsbD5h4ivRZGysc=
X-Received: by 2002:a17:907:3f91:b0:c12:67d2:3d67 with SMTP id
 a640c23a62f3a-c1f1f04317emr93080866b.45.1784988147635; Sat, 25 Jul 2026
 07:02:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com> <20260723031644.312866-11-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260723031644.312866-11-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 25 Jul 2026 23:02:13 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-CNK07Z84fQD-mtdS=JAvKpyoWAJrrYNYPKWWSpcnHJA@mail.gmail.com>
X-Gm-Features: AUfX_mwPhTTB-G_qNmG0FSc4BKdPbLYLK_JgXNrtZr9c_uSOh9HbotdIheLOq40
Message-ID: <CAKYAXd-CNK07Z84fQD-mtdS=JAvKpyoWAJrrYNYPKWWSpcnHJA@mail.gmail.com>
Subject: Re: [RFC PATCH 10/11] smb/server: send notify events to the client
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	gael.blivet@gmail.com, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> +static int ksmbd_notify_reply(struct ksmbd_work *work,
> +                             struct ksmbd_notify *notify,
> +                             struct smb2_change_notify_req *req,
> +                             struct smb2_change_notify_rsp *rsp,
> +                             struct list_head *events)
> +{
> +       u32 max_len = min(le32_to_cpu(req->OutputBufferLength),
> +                         notify->max_buffer_size);
Why is the response limited by notify->max_buffer_size, which is
captured when the watch is first created?
The maximum amount returned for this completion should be governed by
the current request's OutputBufferLength. Limiting it to the first
request's buffer size can unnecessarily return STATUS_NOTIFY_ENUM_DIR
even when a later request supplied a sufficiently large output buffer.

Thanks for the patch!
