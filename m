Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57CC32CF6C
	for <linux-cifs@vger.kernel.org>; Fri, 12 Sep 2025 19:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757705847; cv=none; b=Yque06XhMimdSW5chNY3EO1ASxtUn0yX5AqiG9Gy3sFgk0zBuo9yu59z3Y7yDxVYRlzp78gh4cekhMV7QyD+D9fx3F4hcQqkswX2j/jl1RpyAm6QaLPHi8npK7AA1n0oNrljMIO7MYSuUya+68A0NLIsw0YXtLGPqqHXzT6xpEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757705847; c=relaxed/simple;
	bh=jbFnjxJWjhtNxHXt4FoejfNpMrAWEd/FHa9/FglzMpI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tWV+OJGMuGG7Bd9/PVsHiFWiL9fc0+PxFK4Bg7q1W5U4xAxnivtQnIsKiZB0LAvT3HL8qqwcQYkoOv6EJE/w50gR0woskeF1xv3ZXl+miz8bUuK6Re+7Ae1Ec6rNFnZOSfkTpBIMufhCg+RZcCUdCoU2po+IcXLUOVu0YzuzFWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m+EK+X4k; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m+EK+X4k"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-812bc4ff723so211781885a.0
        for <linux-cifs@vger.kernel.org>; Fri, 12 Sep 2025 12:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757705844; x=1758310644; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nJrqVtBzism8LvHn0AfEJzuFpjJwQoU8jgIsGBAq2KI=;
        b=m+EK+X4kUXcWmjFcq+aAaJonrwg9wGmeBuMBVVygt8z7ukDkFCqwgH4+pO+r+sBjsv
         mWsjyAb4kn8eXWcf779Iu3kPiSWb2SpO2d81Oh8BBbGQFu7XLf/wiaYF2H8QzzvuO+9o
         WxiLjSA5rTDuryd/LFiJHEhy4gZZSENCIlKMTWbO3Pe7qt1823Ma+o9XNINt2mmX2ZVK
         58KXCxZ07v3YfynHOKnNZO9aN6puf3tXf0TlHc/qNRir1ynVijjyMfKKvNJKgjz6oROc
         EFCOrthF72Clpwc2gM8j/fs9DeAR5BOjZenhbUK8N/nbnVDStHVskNtsN+lLHTCg+rSl
         118w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757705844; x=1758310644;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nJrqVtBzism8LvHn0AfEJzuFpjJwQoU8jgIsGBAq2KI=;
        b=n/h7JKAPcw8bKjxKKNIP5zHnJsCJ/aFabjH53JQur2Ka34z9Z7dsdFe+QJaGb0o780
         JbEcmF/1mRq9QRA2zsH0y7zv2IuNlclzSjiCFb7SxhI6Rax0oONA6MRozCY6e1xl9s6E
         3XTk2iWlDXH1sbvedRQiLNXZxpcF7fUTm230bLww0XnL59qkv4Gi7PlEu9UQrFTyaWYm
         rNdT1Tt6byQsVQZ98FDAVgZK0kpfg0bcrRkHEX5e1FZf0lfKLv4ywhwkBINSy5jgcEPD
         +x/ztvoTjTFwt9j7UIfBjyXi84D3csmZddH/+ZlI3E1YqE9QBOrf8nzrxU/nZF2DclH7
         QVnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVm2PfvKBuf9gnPD6oSIhrTU16r7XWPnqgLcC8wev4JI+RRHP7kwf0NZgZWD0v9ujCa3kUN8j3jDgmu@vger.kernel.org
X-Gm-Message-State: AOJu0YztIX9C0HRWXvbsBwTgcCDw7XVO6DAWLa7B9/B6vnLq2pmZkjnA
	wYRXPe2N9pVlMwnlqwFxrcD1CU1dQbpknGKHBEi/mo9OirjC5cIOJ12434ZwdKaiM3L6tX6tKB8
	WE5lfOvhS9NnOicbmlpvu0eO4+ag7kvk=
X-Gm-Gg: ASbGncu3mQuoD1bXL2nunWjGf1KKdxGLgBEYXuZfJ/9UBc5JS7Qs3IugcDsdLKBj1b1
	qsGTDMnd6/t1WTC1Iii7L4ORix2fbC/tyG3B3jM1cqFGsCU1UWJGoivzl2n/GorpYXpQftH9Ghp
	3Ku3dA2dcyOnL0cEK0fqLs+nBIh/pqiEptEcfUjEW7zwmFg12o7VPT0S8R/9KFSjB29DW6uheLL
	LJfRvnBu4B7FA0uqG0jgMLFVfinqw6oDWTvDsrxRM/TLsjyyhVCraKLtuFhLlp5A7dBJJ3Qf9ci
	34Zsy/oAgLvtsF15lbPiWYZNoAhfefc7OecmU3repM7AgCQW4DqO6pu9tNI/GoKkBA==
X-Google-Smtp-Source: AGHT+IH+NUqwMf9aGrD+QjrYEqf1NZMtTWzeVVVkc/ZhzAZfomGOrdOKLEEfE6qM/2qdseyhmKI0oLCibGu1OpVQNk4=
X-Received: by 2002:a05:620a:700c:b0:7f6:d085:c4a with SMTP id
 af79cd13be357-823ff6d68dcmr602487385a.49.1757705844309; Fri, 12 Sep 2025
 12:37:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250912014150.3057545-1-yangerkun@huawei.com>
In-Reply-To: <20250912014150.3057545-1-yangerkun@huawei.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 12 Sep 2025 14:37:12 -0500
X-Gm-Features: AS18NWDBUxneUPVwsxvhIbUR9KMdR-j0v_6ZZGDbEJ5L2XnYP7FXx2wSHxEZUyQ
Message-ID: <CAH2r5mvR=H=neH_vM8UkuXELVpTBeVfQWK5eRPoxUvgokROdNg@mail.gmail.com>
Subject: Re: [PATCH v4] cifs: fix pagecache leak when do writepages
To: Yang Erkun <yangerkun@huawei.com>
Cc: gregkh@linuxfoundation.org, willy@infradead.org, pc@manguebit.com, 
	sprasad@microsoft.com, tom@talpey.com, dhowells@redhat.com, 
	linux-cifs@vger.kernel.org, stable@kernel.org, nspmangalore@gmail.com, 
	ematsumiya@suse.de, yangerkun@huaweicloud.com, 
	Bharath SM <bharathsm.hsk@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Acked-by:  Steve French <stfrench@microsoft.com>

On Thu, Sep 11, 2025 at 9:11=E2=80=AFPM Yang Erkun <yangerkun@huawei.com> w=
rote:
>
> After commit f3dc1bdb6b0b("cifs: Fix writeback data corruption"), the
> writepages for cifs will find all folio needed writepage with two phase.
> The first folio will be found in cifs_writepages_begin, and the latter
> various folios will be found in cifs_extend_writeback.
>
> All those will first get folio, and for normal case, once we set page
> writeback and after do really write, we should put the reference, folio
> found in cifs_extend_writeback do this with folio_batch_release. But the
> folio found in cifs_writepages_begin never get the chance do it. And
> every writepages call, we will leak a folio(found this problem while do
> xfstests over cifs, the latter show that we will leak about 600M+ every
> we run generic/074).
>
> echo 3 > /proc/sys/vm/drop_caches ; cat /proc/meminfo | grep file
> Active(file):      34092 kB
> Inactive(file):   176192 kB
> ./check generic/074 (smb v1)
> ...
> generic/074 50s ...  53s
> Ran: generic/074
> Passed all 1 tests
>
> echo 3 > /proc/sys/vm/drop_caches ; cat /proc/meminfo | grep file
> Active(file):      35036 kB
> Inactive(file):   854708 kB
>
> Besides, the exist path seem never handle this folio correctly, fix it to=
o
> with this patch. All issue does not occur in the mainline because the
> writepages path for CIFS was changed to netfs (commit 3ee1a1fc3981,
> titled "cifs: Cut over to using netfslib") as part of a major refactor.
> After discussing with the CIFS maintainer, we believe that this single
> patch is safer for the stable branch [1].
>
> Steve said:
> """
> David and I discussed this today and this patch is MUCH safer than
> backporting the later (6.10) netfs changes which would be much larger
> and riskier to include (and presumably could affect code outside
> cifs.ko as well where this patch is narrowly targeted).
>
> I am fine with this patch.from Yang for 6.6 stable
> """
>
> David said:
> """
> Backporting the massive amount of changes to netfslib, fscache, cifs,
> afs, 9p, ceph and nfs would kind of diminish the notion that this is a
> stable kernel;-).
> """
>
> Fixes: f3dc1bdb6b0b ("cifs: Fix writeback data corruption")
> Cc: stable@kernel.org # v6.6~v6.9
> Link: https://lore.kernel.org/all/20250911030120.1076413-1-yangerkun@huaw=
ei.com/ [1]
> Signed-off-by: Yang Erkun <yangerkun@huawei.com>
> ---
>  fs/smb/client/file.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
>
> v3->v4:
> 1. delay folio_put after folio_unlock
> 2. document the reason why we choose this single patch instead of
> backport
>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 7a2b81fbd9cf..1058066913dd 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -2884,17 +2884,21 @@ static ssize_t cifs_write_back_from_locked_folio(=
struct address_space *mapping,
>         rc =3D cifs_get_writable_file(CIFS_I(inode), FIND_WR_ANY, &cfile)=
;
>         if (rc) {
>                 cifs_dbg(VFS, "No writable handle in writepages rc=3D%d\n=
", rc);
> +               folio_unlock(folio);
>                 goto err_xid;
>         }
>
>         rc =3D server->ops->wait_mtu_credits(server, cifs_sb->ctx->wsize,
>                                            &wsize, credits);
> -       if (rc !=3D 0)
> +       if (rc !=3D 0) {
> +               folio_unlock(folio);
>                 goto err_close;
> +       }
>
>         wdata =3D cifs_writedata_alloc(cifs_writev_complete);
>         if (!wdata) {
>                 rc =3D -ENOMEM;
> +               folio_unlock(folio);
>                 goto err_uncredit;
>         }
>
> @@ -3041,17 +3045,22 @@ static ssize_t cifs_writepages_begin(struct addre=
ss_space *mapping,
>  lock_again:
>         if (wbc->sync_mode !=3D WB_SYNC_NONE) {
>                 ret =3D folio_lock_killable(folio);
> -               if (ret < 0)
> +               if (ret < 0) {
> +                       folio_put(folio);
>                         return ret;
> +               }
>         } else {
> -               if (!folio_trylock(folio))
> +               if (!folio_trylock(folio)) {
> +                       folio_put(folio);
>                         goto search_again;
> +               }
>         }
>
>         if (folio->mapping !=3D mapping ||
>             !folio_test_dirty(folio)) {
>                 start +=3D folio_size(folio);
>                 folio_unlock(folio);
> +               folio_put(folio);
>                 goto search_again;
>         }
>
> @@ -3081,6 +3090,7 @@ static ssize_t cifs_writepages_begin(struct address=
_space *mapping,
>  out:
>         if (ret > 0)
>                 *_start =3D start + ret;
> +       folio_put(folio);
>         return ret;
>  }
>
> --
> 2.39.2
>
>


--=20
Thanks,

Steve
