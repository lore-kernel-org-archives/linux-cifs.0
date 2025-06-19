Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60CB20CCE4
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 10:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750328164; cv=none; b=MRPSXXtP/FlevjU9fg8evjAtkUWIi3kHcaiQm8QS2+PGk+FMwSDAZtVvUyJsRasV6XrQUa3fr2hJzUHfHxI+1UZrAjq8ujJmK1nS/41LjxApCC3r2WDXRAtSkAe0xzXgdsvqhixQd84Olsb6btel4poj4mblFa3H5pe48vbYe3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750328164; c=relaxed/simple;
	bh=zFBdkt82K3NVqJKk8CRCaeTxkr/gxoCZrdBwjZ8GUl8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lYek4Cn9Ghhlsag97pMhplXusYQEJQkTAQvWMgmCea0AMgoBp8L0mHwiBzpjBkVXZXw8aukrSqLdd5Y3sbqDya/J70Y0ZqX8XCQ3oAb3tYbdoq11PmwVaTA/RJ2RCMJJg3EM40G8j04obaRfCSEpxkBtXEgaCbgAGXQJEEgMxVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IIgHD05V; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IIgHD05V"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-607ea238c37so1111965a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 03:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750328161; x=1750932961; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UGmSlnLKeDf0hTJD74HrkrFzAqI7023yPHmAzwohSkE=;
        b=IIgHD05Vb26ujD20I6uO18RoYFMGkc+F57WbjtQdYysnX7CXBmPbVwdNiqLuztuKYr
         VITECsK5kx1KB2z0xpOMaXup8q55HvsVehsZmv6hqXxq1j4hg6zihuMNacPUwtpb/jDA
         7t08hR+TPOJWGYk3KMcOYNoCm4wuZy5QFcTQfPAp4jiYza/dOAWAJzwxr03s8VzjuHXl
         PJx/+P7EPLeLBX9/JNLcxqFuGP2pxMKJmT+oHEm4VMgJ8oy6T8q3sRcLY/LZWfFXTd0F
         f7v3HS92oYllDC0r/WlLBilK/TH9iKvcIFWzgyKAmN0LO+sNp8Z23c3W48phjNKYyJYC
         Dl/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750328161; x=1750932961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UGmSlnLKeDf0hTJD74HrkrFzAqI7023yPHmAzwohSkE=;
        b=iSoDJbRoIr4BVozQuOCMUqTgW4wtF9F2mnlO1Ew/Ip9xMoX/LbnvtIx6Z4lgRn5tTY
         E+ieg6djagrsxL5djjwThaBZB1RnzKOBw/7CgGpaRAPkTW9buMjFArzi8JBOMBa8Ql5a
         4CckmjjsxerMNA5qPftwRnQvD//q+wes4iE1Ybr5OUt1egPjtLy6eTFyKjDIFUKALwB9
         CbHIisB6+yXgls7lE+Vf0tXRWW+sKIVtvellqW+Ykq5DBJ8lHnnd946Ertl1WbHAcVdZ
         qwH3K+WwiYanM3+qSIwCSqNLKPYWb8a08JbSXEHiOhOUhXE/agKCLmjC/ngPZxOuT9d8
         JzAw==
X-Gm-Message-State: AOJu0YyPJkgAk3BUiH/LvyXiv0Zh4nzFh3a+EVuw4Upp2IdotrFPdsVx
	HOzl24USZhIvhjhEcUOiE/0YLSyNZvcpc+FhRkFZl0wenEGraKe6AbuK/WE/OuPdLouIvhAoZI+
	nzE2WIk9YGevssSmalGnLhwePwbCEOdgDVXUirvw=
X-Gm-Gg: ASbGnct1WzWxcc0kfO92sQdo0NdkREzTHwoAmOqu4n7wJ43Viicr6ioodrMCCY4t3d8
	9qqay/qscKg9+IZHVL7IcwhYjXsRTFY8K2QVoaQnXMWBNKwFS4winqLknX2QtCuMp96uHE3x5Y1
	5hWL7+fC7Ml2kQToWYf692SwzqYv/mBwa39GqbLGoW2A==
X-Google-Smtp-Source: AGHT+IGtkLiyFleG7OWC0iwosNYn+rYwYsCmlUoxCGw9pVhoqgyZRgyYVu+B9AxsIfUg4HyUMdSTNXSMRytGqV0uMNs=
X-Received: by 2002:a05:6402:2812:b0:607:f082:5fbf with SMTP id
 4fb4d7f45d1cf-608d0861c42mr18304949a12.12.1750328160452; Thu, 19 Jun 2025
 03:16:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619101314.750228-1-sprasad@microsoft.com>
In-Reply-To: <20250619101314.750228-1-sprasad@microsoft.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 19 Jun 2025 15:45:49 +0530
X-Gm-Features: AX0GCFvUgC1WXh4Dyrv5V3Kbb8b2BekPi3ye1n4p5hOOVa5Hp6r0n9K5qGtNVbc
Message-ID: <CANT5p=rNM_GmvytQVe5FoeT4BFx5p2TY_7x1yTvXEMMhJNxiVA@mail.gmail.com>
Subject: Re: [PATCH 4/6] cifs: serialize initialization and cleanup of cfid
To: linux-cifs@vger.kernel.org, smfrench@gmail.com, bharathsm.hsk@gmail.com, 
	meetakshisetiyaoss@gmail.com, pc@manguebit.com, henrique.carvalho@suse.com, 
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2025 at 3:43=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Today we can have multiple processes calling open_cached_dir
> and other workers freeing the cached dir all in parallel.
> Although small sections of this code is locked to protect
> individual fields, there can be races between these threads
> which can be hard to debug.
>
> This patch serializes all initialization and cleanup of
> the cfid struct and the associated resources: dentry and
> the server handle.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cached_dir.c | 16 ++++++++++++++++
>  fs/smb/client/cached_dir.h |  1 +
>  2 files changed, 17 insertions(+)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index 9b5bbb7b6e4b..9c9a348062d3 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -199,6 +199,12 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
>                 return -ENOENT;
>         }
>
> +       /*
> +        * the following is a critical section. We need to make sure that=
 the
> +        * callers are serialized per-cfid
> +        */
> +       mutex_lock(&cfid->cfid_mutex);
> +
>         /*
>          * check again that the cfid is valid (with mutex held this time)=
.
>          * Return cached fid if it is valid (has a lease and has a time).
> @@ -209,11 +215,13 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
>         spin_lock(&cfid->fid_lock);
>         if (cfid->has_lease && cfid->time) {
>                 spin_unlock(&cfid->fid_lock);
> +               mutex_unlock(&cfid->cfid_mutex);
>                 *ret_cfid =3D cfid;
>                 kfree(utf16_path);
>                 return 0;
>         } else if (!cfid->has_lease) {
>                 spin_unlock(&cfid->fid_lock);
> +               mutex_unlock(&cfid->cfid_mutex);
>                 /* drop the ref that we have */
>                 kref_put(&cfid->refcount, smb2_close_cached_fid);
>                 kfree(utf16_path);
> @@ -413,12 +421,15 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
>                 }
>                 spin_unlock(&cfid->fid_lock);
>                 spin_unlock(&cfids->cfid_list_lock);
> +               mutex_unlock(&cfid->cfid_mutex);
>
>                 kref_put(&cfid->refcount, smb2_close_cached_fid);
>         } else {
> +               mutex_unlock(&cfid->cfid_mutex);
>                 *ret_cfid =3D cfid;
>                 atomic_inc(&tcon->num_remote_opens);
>         }
> +
>         kfree(utf16_path);
>
>         if (is_replayable_error(rc) &&
> @@ -462,6 +473,9 @@ smb2_close_cached_fid(struct kref *ref)
>                                                refcount);
>         int rc;
>
> +       /* make sure not to race with server open */
> +       mutex_lock(&cfid->cfid_mutex);
> +
>         spin_lock(&cfid->cfids->cfid_list_lock);
>         if (cfid->on_list) {
>                 list_del(&cfid->entry);
> @@ -482,6 +496,7 @@ smb2_close_cached_fid(struct kref *ref)
>                 if (rc) /* should we retry on -EBUSY or -EAGAIN? */
>                         cifs_dbg(VFS, "close cached dir rc %d\n", rc);
>         }
> +       mutex_unlock(&cfid->cfid_mutex);
>
>         free_cached_dir(cfid);
>  }
> @@ -696,6 +711,7 @@ static struct cached_fid *init_cached_dir(const char =
*path)
>         INIT_LIST_HEAD(&cfid->entry);
>         INIT_LIST_HEAD(&cfid->dirents.entries);
>         mutex_init(&cfid->dirents.de_mutex);
> +       mutex_init(&cfid->cfid_mutex);
>         spin_lock_init(&cfid->fid_lock);
>         kref_init(&cfid->refcount);
>         return cfid;
> diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> index bc8a812ff95f..b6642b65c752 100644
> --- a/fs/smb/client/cached_dir.h
> +++ b/fs/smb/client/cached_dir.h
> @@ -42,6 +42,7 @@ struct cached_fid {
>         struct kref refcount;
>         struct cifs_fid fid;
>         spinlock_t fid_lock;
> +       struct mutex cfid_mutex;
>         struct cifs_tcon *tcon;
>         struct dentry *dentry;
>         struct work_struct put_work;
> --
> 2.43.0
>

Hi Steve,

This is an updated version of the patch with an additional fix of an
issue that I found during testing. cfid_mutex was held while rolling
back the cache in failure of open_cached_dir.
Please add a CC stable on this one as well.

--=20
Regards,
Shyam
