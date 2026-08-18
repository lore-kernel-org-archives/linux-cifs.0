Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C29846A
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 06:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787035814; cv=none; b=lCGfjyOr81vFyBKlWF1i6gYP2eyRIGtFE6myWxdsFPbwtwKVMtVDaFFnZB+Qp46xq7MB+hw3NfGAN314ZbcSPiHe2TvDA/v/NFIkVGwiPLmjPVGrU0I4psXL4pNp4BP4vAHHIYi/cq5CLIxZ3IdeH29c0/aPvEmQo8K9bZw8lmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787035814; c=relaxed/simple;
	bh=BAPjnKIqwagZ5XNksWCi3LVneQVmWra/mPpJisbwGOg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NkwOSDvlMhdKvRi0MXnMNm8GTtyDAK35OkB+GV33OToFe/SxWlQmPO1N5XSXaWPc5dsMXez72s2q2HWApnNIiRq1kJnyIBVnOTYpG+KmRAU5sJvk7y7x6zNbkT8A8dmR3CUV2EwrRLQWovk6TJ3TIzovebrhvGjeLEM3pCyi4sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QUpotFLx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QUpotFLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63F31F000E9
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 06:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787035812;
	bh=WqimeFQ06fu9NB/p5fjjnuAqHv2hTtrz9rJ0LHhyqX4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QUpotFLxr3UdBYcFtBkehGkdw4YB/Hl1vDvVFyVCMSA6lpX3+pmGYBfPKZEXJNM+o
	 L912LMlNgMGEcAqtvynLxtMRyVgMPIcH1Wt4NK6QxKK7XYMfF7SH/0sOZZXvdHczPP
	 058FYfCede/Ofx7HN15kQckGnYVflOB9SmR/kG27NHXJDFb4G45a1lwawIioImxTnq
	 nxRoMqipzRVcyj6tQgjAQv3AxoDM8ISjth9Jv6wPn4VXs7fgpZ4Fxo18JRsIeW4rQl
	 K08tM7iorBwOZM5Cf0KmZprtSlHOBuYhN4viZaoXYS4IR/uTbQOgL6Z0EmPjnWFeCY
	 +/ERSzMoeKFHA==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c15cb6f5c12so780256266b.0
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 23:50:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqm4W7rYunHyJyu/trUpF4QGr3AWbYmasnwhcgM6AgI5tyFcxgbnPpDYa4Q4Pz57GEc5gyifzC+XqGe@vger.kernel.org
X-Gm-Message-State: AOJu0YzGbfTjx4jREiKKqb29SHaL/hKgBG+rfJeQ9vQBuWZhvYMxek/W
	XY8IWGU/cQJOijRavJl9UG15XhxUIrGVZ5HS/HarmYSz6qHeooyFefYhT8okcwR6VcA3hCVcbiQ
	FdpUhoAMwqTrBWBWe28xX/pqfmeFDpBw=
X-Received: by 2002:a17:907:6093:b0:bec:64d4:3872 with SMTP id
 a640c23a62f3a-c212a341e30mr1526150066b.24.1787035811300; Mon, 17 Aug 2026
 23:50:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
 <20260813094251.666373-1-rajasimandalos@gmail.com> <20260813094251.666373-2-rajasimandalos@gmail.com>
In-Reply-To: <20260813094251.666373-2-rajasimandalos@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 15:49:58 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9o7wAr8anZ7G=R92CPymkn9VOqHK1_GvgbJYtNQCr4Gg@mail.gmail.com>
X-Gm-Features: AcwNN1Vs7G4rWap3QB9-eHROraPUrxLwOEEHdpz8WEuaDbwN-hRCKDPKmxWQ4vc
Message-ID: <CAKYAXd9o7wAr8anZ7G=R92CPymkn9VOqHK1_GvgbJYtNQCr4Gg@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] smb: client: sync runtime state into ctx on reconfigure
To: rajasimandalos@gmail.com
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
	Bharath SM <bharathsm@microsoft.com>, Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

> @@ -1961,6 +2112,48 @@ int smb3_init_fs_context(struct fs_context *fc)
>         char *nodename = utsname()->nodename;
>         int i;
>
> +       /*
> +        * For reconfigure (remount), duplicate the existing mount context
> +        * instead of building one from scratch with init defaults.
> +        *
> +        * VFS sets fc->root before calling init_fs_context for reconfigure,
> +        * so we can access the existing superblock's context.  We dup the
> +        * live cifs_sb->ctx into a private new_ctx, then sync new_ctx with
> +        * runtime state (tcon/server/ses) so it matches what
> +        * cifs_show_options() displays.  Syncing into the private copy (not
> +        * the shared cifs_sb->ctx) avoids racing with concurrent
> +        * fspick/remount and /proc/mounts readers.  The parser will overwrite
> +        * only the options explicitly passed on remount, so any difference
> +        * between new_ctx and old_ctx in smb3_verify_reconfigure_ctx()
> +        * represents a real, intentional change by the user.
> +        */
> +       if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
> +               struct cifs_sb_info *cifs_sb = CIFS_SB(fc->root->d_sb);
> +               int rc;
> +
> +               ctx = kzalloc_obj(struct smb3_fs_context);
> +               if (!ctx)
> +                       return -ENOMEM;
> +
> +               rc = smb3_fs_context_dup(ctx, cifs_sb->ctx);
Doesn't this add another potential UAF path? smb3_init_fs_context()
may run before  s_umount is acquired, so this duplication could race
with another remount freeing or replacing strings in cifs_sb->ctx.
