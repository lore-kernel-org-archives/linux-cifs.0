Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136F017C
	for <linux-cifs@vger.kernel.org>; Sun,  1 Sep 2024 04:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725165412; cv=none; b=PulqFxVeMss0E1HTT+BP9WlkpnbUsl0xxCk7rDxgqKQc2W550wsm6QC5JD1602QO9Yon6GC+E7dkp/ru2pc4Q7j/tOUxbWvRuGxfRPq+ZEeuo37fM9gAW+l1/YJY+tFW8MZyuR+3WbZ6hyhhyiVX9A4OwpqB5LlO0KsknXkigAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725165412; c=relaxed/simple;
	bh=mqJ3iSmS+UgRn0ciJ3PjKY3eyNLJkYIWT9/oaoRzVaE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fifPMV3W4Qy1/cwe06hg2T7mNozg4Q6vtttMTb061hGkIMMLnpd5uBlWCCqtsiLInjnaiarv5skO9fz0qidD+gpTjkko1Fzur55/WiidPeZF3RInmmlLHhO61D3xUCKbgO0W0f83jXbN+P0foZKSTK5oMDEW3oYcbn0aYF4987Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lUi2Pkij; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lUi2Pkij"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5343d2af735so3002358e87.1
        for <linux-cifs@vger.kernel.org>; Sat, 31 Aug 2024 21:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725165409; x=1725770209; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TtRsBad4EY3ei1wPxo4hj2guOS19V4Wyqtp0q0ikbG8=;
        b=lUi2PkijbuWrsUp8h9AAohWac/a1cg+Bc0iV24H4xkJkMfaw5BzZiLme1N3hxuRw1e
         eJu3XFgBUYJuvEb7jFEjmz0pShHS0IxKelCayqog9+CPVvfAbgVU3i+GoLrpcLWHAgNR
         A651DpF3A8X3hudq3raKC5bVlSg+VeTOXqlq7ZylRLusQmRAX/Fa5oKq3cFt97HF6o4l
         TuDeW/ooBkS58t6KIL8zEGf8LcC8YPCEKvawDm+/LGCYicLXVqNMbmcykLfZqU1kb4cj
         tVRGOnfx48yEMWv9lymFEW5MIXd4x5ye+sg2/+12MX/YU+cl1gSHrU1fj6MKlSdebqUD
         xIUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725165409; x=1725770209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TtRsBad4EY3ei1wPxo4hj2guOS19V4Wyqtp0q0ikbG8=;
        b=GE0DQAs8nsi/qjca+iEdVcAk6CitxMOoMA6hUybR6baqyd4olkFrYc/8YbgaLKwdqe
         IwUFv+YJfAj4ZuQseyFLSHL0ZbWuI5JYw4mD5zwrFpH3Q1JMoggx2LCn/Pefdyn3KlqS
         rqqhP4YWUwRPZ3qGE1EsNztH1EiCiSJ8kE3mm93DPj1haOjs+Locjfs5ndZ6Qgys9kXc
         uopM0XEwy9XQOtnGd5O64vQYO87bqxih0RIQnnePKpcQ36mUabGzCVGeuFannXd5LYju
         7E+Y/UEp25tW+ZfK8SxGhVCrTwxOrXJel1GaSs/bg75ry8Rq4SnAVYshRKlk1pTxMMfH
         B7sA==
X-Gm-Message-State: AOJu0Yzk845xPDBOcM668VgdkFRbVedVcyBAEaS7LGYfbgzKx1Gdr3go
	lMpj+bFgbiE3yqEHk/rF1uXJd20RNq0NjlePJOkQBK0UoU20LQHM/EE3pO0rC3ejRsGj4L9gOwB
	w2O8bHEkAbhpoZIIRXaM22tFxgkY=
X-Google-Smtp-Source: AGHT+IHnjj98MjC4u6USJ+qL4RljfLMgEcsGkzZk/pISmqPd0NYtllOBsEFmtg+Qa93JzQO/iiHWLr2BDideKFFF4/U=
X-Received: by 2002:a05:6512:3f17:b0:52d:b226:9428 with SMTP id
 2adb3069b0e04-53546afd97emr4574848e87.6.1725165408681; Sat, 31 Aug 2024
 21:36:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240831000937.8103-1-ematsumiya@suse.de>
In-Reply-To: <20240831000937.8103-1-ematsumiya@suse.de>
From: Steve French <smfrench@gmail.com>
Date: Sat, 31 Aug 2024 23:36:36 -0500
Message-ID: <CAH2r5msJ4HpuRi5mzOKvL5FhaUnxw2ZtaX331Sm2cZ92vCSgTA@mail.gmail.com>
Subject: Re: [RFC PATCH] smb: client: force dentry revalidation if
 nohandlecache is set
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged to cifs-2.6.git for-next pending testing and
additional review

On Fri, Aug 30, 2024 at 7:10=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> Some operations return -EEXIST for a non-existing dir/file because of
> cached attributes.
>
> Fix this by forcing dentry revalidation when nohandlecache is set.
>
> Bug/reproducer:
> Azure Files share, attribute caching timeout is 30s (as
> suggested by Azure), 2 clients mounting the same share.
>
> tcon->nohandlecache is set by cifs_get_tcon() because no directory
> leasing capability is offered.
>
>     # client 1 and 2
>     $ mount.cifs -o ...,actimeo=3D30 //server/share /mnt
>     $ cd /mnt
>
>     # client 1
>     $ mkdir dir1
>
>     # client 2
>     $ ls
>     dir1
>
>     # client 1
>     $ mv dir1 dir2
>
>     # client 2
>     $ mkdir dir1
>     mkdir: cannot create directory =E2=80=98dir1=E2=80=99: File exists
>     $ ls
>     dir2
>     $ mkdir dir1
>     mkdir: cannot create directory =E2=80=98dir1=E2=80=99: File exists
>
> "mkdir dir1" eventually works after 30s (when attribute cache
> expired).
>
> The same behaviour can be observed with files if using some
> non-overwritting operation (e.g. "rm -i").
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> Tested-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/inode.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index dd0afa23734c..5f9c5525385f 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -2427,6 +2427,9 @@ cifs_dentry_needs_reval(struct dentry *dentry)
>         if (!lookupCacheEnabled)
>                 return true;
>
> +       if (tcon->nohandlecache)
> +               return true;
> +
>         if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) {
>                 spin_lock(&cfid->fid_lock);
>                 if (cfid->time && cifs_i->time > cfid->time) {
> --
> 2.46.0
>


--=20
Thanks,

Steve
