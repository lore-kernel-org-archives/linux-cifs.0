Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6425A33D6F9
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787036602; cv=none; b=Bm6NXm7zY66FG4uGOywHPq3hpfbVTLo50dlbnJtiniB020HEt2JGn+f9a/ZiRXA3uRWKs8EuwNFYvoJmwcmf7mpmyV6prE4Fe1r/UVU2a4uZXdmnogfHqpBavM85lqgUnaxa5xng3UOhWUGBy+qQEDvsqfcqOmpEyi0630XkwP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787036602; c=relaxed/simple;
	bh=FpCmCOHshs5IJZHDHYqBkMei21zP2Sk/lMvSM9DxYBA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SUhA0rzStDskTZmgLNyN3CqX+JH9y9+mSf+98JHU9fn/pXnCkEH74DGFIH9xA44y543rm/qQQdd0iD3JS0H6s9mvH25fe4YmU4o/qBUa6kfM0bPd7hUUnyUOVnZVJfhDug73IH9WEpsoZ5C5n68d1sUDLWeh8CctosMgRJYdf0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TfsJ2T+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TfsJ2T+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA9D1F000E9
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787036601;
	bh=El0iyo9X3wCnDyVvw7IxL2bZvVuo1Xce73p6V4jqSlA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TfsJ2T+GhfoJIRwO4/XcMYD0Xcw7m+egimJtI9/nfUtdh9tVeOttMblewtU02/sFl
	 2I+H6clG5cU96zs/OQ6yRWZ4tsGfyKQKY5jFfpO3dTYhRGF+e0zXxbGZIDyrB3q1jm
	 6AEl0NlPOzj2D42E7Utru5KX5WNoGELefNSfHdWQDWJ8gOVk4XDG6G4MdrEQrYpZbi
	 5w/aCpwj2GYaJ+CS2bwOo16OgWkmt3K3KFhGPuh3uvQiaknw1EJ0RbN4dp/qeCmpSO
	 nAJ6Q9Jf1gOFmH5fNLC2h+hG8uc6BTC6/iyAjWGW7bmmmiROuOpviO0hRVKomw/ZrC
	 0AKH1VR9Oo3Wg==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a0a4a28cbdso7246567a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 00:03:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqtTXckXpzMM5a2V2zfDhicBof1TgjcJxofgRXbyIZ99fzez/Q57ehtQBTu4ai6IcQG1U0Vi4LtmgIm@vger.kernel.org
X-Gm-Message-State: AOJu0YynnlqqaiGs5199S//9dfv3+7C8i9OMy1Lga+b4enKVH3/a7YTB
	wEQm2HqvF/5HCHvzYoKQgANV/36ltynkiyo8A1/EIT/t/vRyWODazgekt83uwWfNoIbfoszhCd9
	bxdLwib7dEZq/FpSryYBXlbHOUaWj1bY=
X-Received: by 2002:a05:6402:2381:b0:6a1:854:e75e with SMTP id
 4fb4d7f45d1cf-6a38a97fd22mr13040721a12.15.1787036599635; Tue, 18 Aug 2026
 00:03:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
 <20260813094251.666373-1-rajasimandalos@gmail.com> <20260813094251.666373-8-rajasimandalos@gmail.com>
In-Reply-To: <20260813094251.666373-8-rajasimandalos@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 16:03:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-qNcPcg=NUEUz_DUfL4QCv14PHgG-=aCXsBWYg3vOp3Q@mail.gmail.com>
X-Gm-Features: AcwNN1WutptrLcFDIG7M0QYG4z25h1ifna85PXz-nrGDiyzuqm5LS3CvtMyqai4
Message-ID: <CAKYAXd-qNcPcg=NUEUz_DUfL4QCv14PHgG-=aCXsBWYg3vOp3Q@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] smb: client: allow nolease option to be
 reconfigured on remount
To: rajasimandalos@gmail.com
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
	Bharath SM <bharathsm@microsoft.com>, Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

> +/*
> + * Invalidate cached directory entries across all tcons under a
> + * superblock.  Count the tcons first so the pointer array can be
> + * allocated with GFP_KERNEL outside tlink_tree_lock: allocating
> + * per-tcon under the spinlock would force GFP_ATOMIC and, on failure,
> + * silently leave some tcons with stale leases after a nolease remount.
> + * References are then taken under tlink_tree_lock and the cached dirs
> + * closed outside the spinlock since that can sleep.  Holding a tc_count
> + * reference prevents the tcon from being freed by tlink_expire_delayed()
> + * between dropping the spinlock and the call.
> + *
> + * Called on remount while the connection is live (e.g. switching to
> + * nolease), so pass close_handles=true to actually release the
> + * server-side directory handles and their leases.
> + */
> +void invalidate_all_cached_dirs_sb(struct cifs_sb_info *cifs_sb)
> +{
> +       struct rb_root *root = &cifs_sb->tlink_tree;
> +       struct rb_node *node;
> +       struct cifs_tcon *tcon;
> +       struct tcon_link *tlink;
> +       struct cifs_tcon **tcons;
> +       unsigned int i, n = 0, count = 0;
> +
> +       spin_lock(&cifs_sb->tlink_tree_lock);
> +       for (node = rb_first(root); node; node = rb_next(node)) {
> +               tlink = rb_entry(node, struct tcon_link, tl_rbnode);
> +               if (!IS_ERR(tlink_tcon(tlink)))
> +                       count++;
> +       }
> +       spin_unlock(&cifs_sb->tlink_tree_lock);
> +
> +       if (!count)
> +               return;
> +
> +       /*
> +        * Best effort: if the snapshot array can't be allocated, skip the
> +        * eviction.  New opens still honor the updated nolease via the
> +        * tcon->no_lease propagation done by the caller.
> +        */
> +       tcons = kcalloc(count, sizeof(*tcons), GFP_KERNEL);
> +       if (!tcons)
> +               return;
If this allocation fails, the function silently skips evicting cached
directory FIDs while the remount still succeeds. Such a FID may then
be reused after nolease is enabled. So please do not silently return
here.
