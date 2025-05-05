Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DDD1DED5E
	for <linux-cifs@vger.kernel.org>; Mon,  5 May 2025 19:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746474103; cv=none; b=JnTG7Bhdj3J63VyEP4SHOvy3QZdGof+WzR9NcaQtc3pmMgZebuT64iTDAvkm2Tq/IWiK/YJj6BLaURCdYsChmvbAAWaqErxFa1aobJGOwRJTYoTyz0jqPM9p7lHV7jZzoRbdwx+1tIFL35hG98TJLqnx6E/rm2uoVcKW7Ls3kCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746474103; c=relaxed/simple;
	bh=LmUWWvJSO6ryW6mtEqcetdi7xMhLwbMxHE+hE4edkwU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NEjdxMP+yE6aOurMYuLl3CWKkFSln1bgrRtpKCdyROoNHGql536w9XyMqiXTmNHjAffmC1lIWK10SzAEHuf91fTVXq/V5q5p/1NpLvbOGaAs8vLXzQj1uapK2LD/jH0CfmtxQ2jE4vdKxlP/MCHxSc7o05wZpMcSNKihCLo9ma0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iikLEdLI; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iikLEdLI"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-54993c68ba0so6111285e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 05 May 2025 12:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746474099; x=1747078899; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tCU5rIWWyjYZ+AUdxvLsf7Qsf04E6z0JedrkfyOu/VE=;
        b=iikLEdLIsPeAM+RDVrVXdGWSt/AjhC+vKBCoG7WdtXeiLZUOSSZPiCmCPijNPAakCl
         TS9CwcOnK0MIlawe+DHjydjG/nQ/UUeio7zkFiKxmQosvRSI4ajXisvznaA+MDpiw904
         Q9QFQjCBwPijsUmfc/QwYy84OODMmLVTsGscLeHh92Kh4T/5zW+ByMyPk2HzH5g4csVI
         GnJxpidvlFgu1B96696u508NhvyCeOG+GdzediDCxcvT4DK4nFprU4RAKMHQxlsitYJo
         GMtc1lPKKkeLfGszO1F4OCyIjhxx0mCLwqqmipnz2ob+ZNreKnS4HWX5Nx6K8gumIMGi
         NaXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746474099; x=1747078899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tCU5rIWWyjYZ+AUdxvLsf7Qsf04E6z0JedrkfyOu/VE=;
        b=rr3j6hvrzaMY2RjkuscmRsd5woaqK5zJZRg5dt88whES7saA7JocOfaLpdw+vJFk8F
         OOkSB19e9fZzrfvnkjCywNx7nd1EfUBYEOIsemw3eYTkgDo7LHn3bMi1Hno4ecPa4lT/
         Bpx5RcnYK58dr55X+TddwTxEfF5hJqssCDSlkHwFeAyzNhpk4fHkT67GgyOowfzkgwnF
         VH6uUIna3o8C6gm+yyE1W1fhNwVubGEHmGf80RcYGIvDdqBOMvQ8347yLaHBZ/Eamjo/
         QjxB+QF6poYMGhucJJ4a7+cnrYfCoxwJY9HpYmw84VUsoPsYq+fORvcKiax922mMjN7h
         D6pA==
X-Forwarded-Encrypted: i=1; AJvYcCV1sOeg9EEk0bsrQ0WXVsOfdQ5iQpeiApIIqFD1PVQmshY3DnxbQWJE+6U/QcHHWrnUbodekEY/qVhv@vger.kernel.org
X-Gm-Message-State: AOJu0YyXPyvJ1VpOKuBQMgFREas1YcY1gIbLxFDGc+NsGJn1bWqhsEvr
	ronziUjmImuwx+L5sSQ1y2SglTxY3WDvYMESbRFgmRoHlZQkN+FnEatG6IWaPEmTm+wPjLJFiwo
	JpiG1vOImgnv7pDtWjJfz/pAREfE=
X-Gm-Gg: ASbGnctjrzAPWmTyx1QTpqB47aAPvMzsTPC5rZz/jrIX6gH0qoTFPzPxTqz77alfPjQ
	wdE4whpibNAYnueCWD8j9q4HKHHL9mFHgAoLONzLNnseAB01I6y5kYp3Ul2uuiW2mosgQQLYDaM
	gNQQLh51wcn2BvfyTTlmSoZc8=
X-Google-Smtp-Source: AGHT+IEpqQpwdwh+bHDU28xEaOH5vWxTUlnoAFZmkxkvp+ml2sSzkabJjAzLMDSyzZKPIrpFoUsokQozKuNJ/hP1mkw=
X-Received: by 2002:a05:6512:689:b0:545:2e85:c152 with SMTP id
 2adb3069b0e04-54eac211f17mr4041557e87.34.1746474098727; Mon, 05 May 2025
 12:41:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250502225213.330418-1-henrique.carvalho@suse.com>
In-Reply-To: <20250502225213.330418-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 5 May 2025 14:41:25 -0500
X-Gm-Features: ATxdqUFktT74_fcKAkzde83dPdAKGpWbV1Qbb41enYXC3ppzVmOHNKp9vYqA8Fs
Message-ID: <CAH2r5mtyZV=VJTbV_FeETT=CEZeJp2zUFvSL738RWwBtAJ4EHA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] smb: cached_dir.c: fix race in cfid release
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: ematsumiya@suse.de, sfrench@samba.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, paul@darkrain42.org, 
	bharathsm@microsoft.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The first few times I tried his patch it seemed to help avoid the
generic/241 dentry crash, but the last four times I have run it, it
still fails the same way so may have been a coincidence that the patch
avoided the problem a couple of times.

Suggestions welcome ... also looking at Shyam's and Enzo's patches
which address similar locking issues

On Fri, May 2, 2025 at 5:53=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> find_or_create_cached_dir() could grab a new reference after kref_put()
> had seen the refcount drop to zero but before cfid_list_lock is acquired
> in smb2_close_cached_fid(), leading to use-after-free.
>
> Switch to kref_put_lock() so cfid_release() runs with cfid_list_lock
> held, closing that gap.
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
> V1 -> V2: kept the original function names and added __releases annotatio=
n
> to silence sparse warning
>
>  fs/smb/client/cached_dir.c | 32 ++++++++++++++++++++++++--------
>  1 file changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index fe738623cf1b..fc19c26bb014 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -370,11 +370,18 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
>                          * lease. Release one here, and the second below.
>                          */
>                         cfid->has_lease =3D false;
> -                       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +
> +                       /*
> +                        * Safe to call while cfid_list_lock is held.
> +                        * If close_cached_dir() ever ends up invoking sm=
b2_close_cached_fid()
> +                        * (our kref release callback) recursively, the r=
eference=E2=80=91counting logic
> +                        * is already broken, so that would be a bug.
> +                        */
> +                       close_cached_dir(cfid);
>                 }
>                 spin_unlock(&cfids->cfid_list_lock);
>
> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
> +               close_cached_dir(cfid);
>         } else {
>                 *ret_cfid =3D cfid;
>                 atomic_inc(&tcon->num_remote_opens);
> @@ -414,12 +421,12 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tco=
n,
>
>  static void
>  smb2_close_cached_fid(struct kref *ref)
> +__releases(&cfid->cfids->cfid_list_lock)
>  {
>         struct cached_fid *cfid =3D container_of(ref, struct cached_fid,
>                                                refcount);
>         int rc;
>
> -       spin_lock(&cfid->cfids->cfid_list_lock);
>         if (cfid->on_list) {
>                 list_del(&cfid->entry);
>                 cfid->on_list =3D false;
> @@ -454,7 +461,14 @@ void drop_cached_dir_by_name(const unsigned int xid,=
 struct cifs_tcon *tcon,
>         spin_lock(&cfid->cfids->cfid_list_lock);
>         if (cfid->has_lease) {
>                 cfid->has_lease =3D false;
> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
> +
> +               /*
> +                * Safe to call while cfid_list_lock is held.
> +                * If close_cached_dir() ever ends up invoking smb2_close=
_cached_fid()
> +                * (the release callback) here, the reference=E2=80=91cou=
nting logic
> +                * is already broken, so that would be a bug.
> +                */
> +               close_cached_dir(cfid);
>         }
>         spin_unlock(&cfid->cfids->cfid_list_lock);
>         close_cached_dir(cfid);
> @@ -463,7 +477,9 @@ void drop_cached_dir_by_name(const unsigned int xid, =
struct cifs_tcon *tcon,
>
>  void close_cached_dir(struct cached_fid *cfid)
>  {
> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +       kref_put_lock(&cfid->refcount,
> +                     smb2_close_cached_fid,
> +                     &cfid->cfids->cfid_list_lock);
>  }
>
>  /*
> @@ -564,7 +580,7 @@ cached_dir_offload_close(struct work_struct *work)
>
>         WARN_ON(cfid->on_list);
>
> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +       close_cached_dir(cfid);
>         cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
>  }
>
> @@ -688,7 +704,7 @@ static void cfids_invalidation_worker(struct work_str=
uct *work)
>         list_for_each_entry_safe(cfid, q, &entry, entry) {
>                 list_del(&cfid->entry);
>                 /* Drop the ref-count acquired in invalidate_all_cached_d=
irs */
> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
> +               close_cached_dir(cfid);
>         }
>  }
>
> @@ -741,7 +757,7 @@ static void cfids_laundromat_worker(struct work_struc=
t *work)
>                          * Drop the ref-count from above, either the leas=
e-ref (if there
>                          * was one) or the extra one acquired.
>                          */
> -                       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +                       close_cached_dir(cfid);
>         }
>         queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
>                            dir_cache_timeout * HZ);
> --
> 2.47.0
>


--=20
Thanks,

Steve
