Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F76141C73
	for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2024 14:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710168083; cv=none; b=NmRkZMf/2Uf4Dda2wQ9tvkE9Y8KECcd5h2Otr9yX4dDtdq2potBvVoCxM6r6T+PJ0CDGrmttKUMMaP7595wGhL3Aq77icqKM+KGFIrwR/gYhXEKob6Y2SADWhZ+xAqIrYAcgM70lfLDuRqatWR54naS0IzqGxj/n2Lvy/2bst7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710168083; c=relaxed/simple;
	bh=AlDpESnQaNIzuyoroKG1q/FIh2SzXRFlalya3MGyRkg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uMbDh3PVQ4qMpDvJjEOZ4zyn+7flnlXdFr/jT/OmwresCvh+59lqu9z2GGTwOnBQTJx3Go6fpnbCtMPUvX9xgw0oZ0cK9FeHHcVzWlWP0Lua/JVU+L8FdzE6cDLMRCFqKKAJUK6CzY6O2hGrHckHaNXcDuP4pJviixuHmuM92Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TJ23HzjZ; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TJ23HzjZ"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-512b3b04995so3384136e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2024 07:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710168079; x=1710772879; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o5LJULp3e+2YyfqdX7uqzm6q6ZbQzniTBnAS+7yhBVo=;
        b=TJ23HzjZx2Z2sV1UFtPjQ2J5k0LtmqfomsC9e6pYEg7EEsh1xv25Y6b9i2sXEpq3Q7
         BZtsE6Ll6yUPq8A6WdX/wci/xdrAdbL3zrXVN9uHnusWyj3IMC2oGHalQ2ztaJroyD1E
         47nyxVlxSWx6qr/4VKsS04k94VA0OjR/U596mUGtVbBx6ncyy6BgqVC1WozzzU/cfLsB
         QZ1QJCAPZLxPyiYbPZfOwzpqcau0jwwMmLnVMnnzBsrOt5X/oWNFO2CT69G2qeUoDwCi
         4Dg/HAu9LFn9lFBh0LyAY3jOY1JC24OxBE3P7J93hNWHmRalCVPXsGt6gZY5y+2rw8pN
         VH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710168079; x=1710772879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o5LJULp3e+2YyfqdX7uqzm6q6ZbQzniTBnAS+7yhBVo=;
        b=LeLnW2zFFHu2WAm+DxlDO2C7+JMreNKg+C+M9TWs3/kztWyODIvm6EF2nv60DarbhN
         VevVexLZMJLJLF5k5f+OmFfaqz/SWWHb0i9TfqZzSsD1952tiAc8vddGFE79OcJF3b0Y
         s0YMIB0ia3VBKWxyWVsAWGOQrl4Hn1kDs6c2Kt597/ys3r3wYBvOZ614ZUTHswJm+XT3
         TF0sU9PcHXKgNK9rMuZjX89w/N3TsTdTaj2zskifS56i2gSJnuuP4E11txitOnpMXesJ
         Nms4AnWVtdsbNc7Y23WM6BzqoLclhRwNtjkh1Ch99Ms4lWGs6RO1Y944Uy8+BBt2OkVE
         2rtw==
X-Forwarded-Encrypted: i=1; AJvYcCVoNTDdYxHpCisYzfjutEO8p9uw9lKxja7lMb+b7VvMlPswf+7d+q3F4sTXFjtyT82SDA7ZXJ+XGRftkg1/pCAR9dQQ2nwgHm3xxw==
X-Gm-Message-State: AOJu0YzLVzVmWhriM53QsRjNAQ9+KdJBFNSwV5Y5WRqMtSKBEsnNb1QS
	9M/+13Ec1VXdvML9ZZsovZci+K2bZZq9cip+bN9EYBR12tqe6Qy6kNJsZr7R5vUM69+GvzSWyoT
	m/gRdAglIthH8f8JGbjGL1Z9da4GRzMBraBbgJQ==
X-Google-Smtp-Source: AGHT+IGmeFaIQEhevRIP8Ge4iVIMr1UWatvKUtCmBHpZpRvLMA1HmH1iiyEXxzKFaJzvk79qALgsWF8Ox3T3AObDTX0=
X-Received: by 2002:ac2:593a:0:b0:513:524f:9690 with SMTP id
 v26-20020ac2593a000000b00513524f9690mr3846187lfi.38.1710168079103; Mon, 11
 Mar 2024 07:41:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240311012425.156879-1-pc@manguebit.com>
In-Reply-To: <20240311012425.156879-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 11 Mar 2024 09:41:07 -0500
Message-ID: <CAH2r5mt+kcWu4jFwKfn4izwhFxCbGNDaAbR7ReKfX3cxdQoidg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mount.cifs.rst: add missing reference for sssd
To: Paulo Alcantara <pc@manguebit.com>
Cc: piastryyy@gmail.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

You can add
Reviewed-by: Steve French <stfrench@microsoft.com>

On Sun, Mar 10, 2024 at 8:24=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Reference sssd in mount.cifs(8) as it can be used instead of winbind
> via cifs.idmap utility.  It's also enabled by default in most systems.
>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  mount.cifs.rst | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/mount.cifs.rst b/mount.cifs.rst
> index 9d4446f035b6..f0ddef97a0e8 100644
> --- a/mount.cifs.rst
> +++ b/mount.cifs.rst
> @@ -761,10 +761,10 @@ specified in the following Microsoft TechNet docume=
nt:
>  In order to map SIDs to/from UIDs and GIDs, the following is required:
>
>  - a kernel upcall to the ``cifs.idmap`` utility set up via request-key.c=
onf(5)
> -- winbind support configured via nsswitch.conf(5) and smb.conf(5)
> +- winbind or sssd support configured via nsswitch.conf(5)
>
> -Please refer to the respective manpages of cifs.idmap(8) and
> -winbindd(8) for more information.
> +Please refer to the respective manpages of cifs.idmap(8), winbindd(8)
> +and sssd(8) for more information.
>
>  Security descriptors for a file object can be retrieved and set
>  directly using extended attribute named ``system.cifs_acl``. The
> @@ -780,10 +780,10 @@ Some of the things to consider while using this mou=
nt option:
>  - The mapping between a CIFS/NTFS ACL and POSIX file permission bits
>    is imperfect and some ACL information may be lost in the
>    translation.
> -- If either upcall to cifs.idmap is not setup correctly or winbind is
> -  not configured and running, ID mapping will fail. In that case uid
> -  and gid will default to either to those values of the share or to
> -  the values of uid and/or gid mount options if specified.
> +- If either upcall to cifs.idmap is not setup correctly or winbind or
> +  sssd is not configured and running, ID mapping will fail. In that
> +  case uid and gid will default to either to those values of the share
> +  or to the values of uid and/or gid mount options if specified.
>
>  **********************************
>  ACCESSING FILES WITH BACKUP INTENT
> --
> 2.44.0
>
>


--=20
Thanks,

Steve
