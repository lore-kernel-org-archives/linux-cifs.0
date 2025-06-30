Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA39D25BEF2
	for <linux-cifs@vger.kernel.org>; Mon, 30 Jun 2025 19:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751312862; cv=none; b=l9meF3ZBycVWGHa4zKERPZjhynn2dNPlEZb4X32RQ5p025YeIii2pMAg/n8RWmdpMnq63InMp9ioq7DJShRg2/tfBfckjbKcyND6krZYNtIG6p9M+SVnsy6guoSi9CmrjE5pjHrOSjALuWWxJE6xCzktdkqA2dbU7KD0OgKBwlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751312862; c=relaxed/simple;
	bh=fwt66L5AQ198ZqKm6UDIsBFFQ2JRrmWT49boEjzGfOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qfNsZUd0oibMiZK+PiE8Qc5HILccMKEfooLTXYBpudufbYc/Vz29x/pZORuLq1KSPqjKnOimiGZ+uT1bacq3vHy0QddUFgnEwI6eobQ81WmWzRtHsdyqsUnNLVXGgQ7PPuSMHJvf2JffdR4QBFTj6yEU4PHq9Dxb4wV/zjT3bWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jEJsFW6B; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jEJsFW6B"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6fad4a1dc33so24312566d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 30 Jun 2025 12:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751312859; x=1751917659; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/0zmhuNpp9Q5hcZIO7ycQKexlbQb3pwtdjZUPWyyFss=;
        b=jEJsFW6BRInrs4XCNv54x3VFJBi+6Ti+YoQZzQareHcJItSkA3GnF+mlx4jLEpN/Pn
         L7B1aWITHUMJ+AbhOL8Tcp2JhVBcEm/YwfUM6g+U/O8d2Vu7JGP/rNNiP1D1nXwr050v
         yL57jJFc9F6beX7WDHloAHDSoYCFbJ3PzcrUuoPmv/9BLxwjv+heIjKMsyzIy5HO1/w4
         ZqpHEni+J9SbV1ZkSyJCR6Vd+MZ8GcDMOGAJtCSQtsyZj+rAnmF5ZrT1Mdke6yTb9QCV
         PAf5OIk4JVF2nnEuOUoPAVPn0Dld/bf8NRehnLXOzuxtSNTJ85zerCCELmVywHMIN76a
         Ctyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751312859; x=1751917659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/0zmhuNpp9Q5hcZIO7ycQKexlbQb3pwtdjZUPWyyFss=;
        b=JrFuwnKBLrpuOwWsM+2JC+PL+RTW6C35xp8mDJW5QgNTze7lciLVvncj8M177o/L10
         zKXOkqQqmeihrYJsvNyTtjklqIGhzakE3+h6k94tZld92tHmrixjQXvpuVmcvEPTnCSx
         /uPI25IMlELsRKAnDoHlCuothlgn/1dQqUOFIlgXR6p62Q35RNn+3QhGg69BcV+1szUj
         ng5O3tlI7oFJHOA/xuM7k9cDeErxnU8Y/bZr3u8DloK4Q5WOeJjYgR95D6mkD3wo2G+a
         vgjOHDlnNaLZLjxZwlmqdXBdQdyd7HLB7XUy9YtjLb9pBg/VfQZNtbED0N8W3cRe/U3s
         O2KQ==
X-Gm-Message-State: AOJu0YzWU8c1EEq+f2CP6EeLppH7WryIaEKZUOYkd/9HSqch6m2Q50fU
	ETVVDAsQhuItCPvew4VYFCOz5kHsvyiqrnTMFHEvLHdumvgZ5ewrDHYYU+nj60uM2A+gQUekGOc
	C7vFx01tUz7truhLSQf2i5AvU+JkRr7TF7g==
X-Gm-Gg: ASbGnctD0REmVlJpGLuGC6nktTvYmv6keBMd9RXA+GkxHjPEt4/oSJwbhMdoNXwUjnp
	semzhlRRNi6vhd75nne8h2l449yrYutjDfjZyjIj/8ngLtwotjUpQd6FPRn1XLRppVS4CQipBoz
	4eIFjIffLGU6oaExVbzIujJT2aNH80DHuX2fTKO1uHvt75CTQiQ443w/YgV9NiCi2oktsr3MzUZ
	/aE6Q==
X-Google-Smtp-Source: AGHT+IHoR+8sId6obm4qA636A156wWrTcwB9LHXA/1YyXptCxbhVWZd8qitYXYi9o3ZchPxHDyZV/rJ8DPhcx2acwOQ=
X-Received: by 2002:a05:6214:da3:b0:6fd:8fc:e2fa with SMTP id
 6a1803df08f44-70003c9331emr230423226d6.32.1751312859376; Mon, 30 Jun 2025
 12:47:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250630184932.12067-1-bharathsm@microsoft.com>
In-Reply-To: <20250630184932.12067-1-bharathsm@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 30 Jun 2025 14:47:27 -0500
X-Gm-Features: Ac12FXyCLF3OfP1lVAABpdMSOvsuCuSFvk13R25gadsa9-Bu50xvRwOp3GaBaPU
Message-ID: <CAH2r5mtmFFTrsSv3RQ4tfzNn9mD+P_X096iEsEuYj_4Je-kN0A@mail.gmail.com>
Subject: Re: [PATCH 1/2] smb: change return type of cached_dir_lease_break()
 to bool
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Mon, Jun 30, 2025 at 1:50=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> cached_dir_lease_break() has return type as int but only
> returning true or false. change return type of this function
> to bool for clarity.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/cached_dir.c | 2 +-
>  fs/smb/client/cached_dir.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index 373e6b688fe3..211a6f35541b 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -613,7 +613,7 @@ static void cached_dir_put_work(struct work_struct *w=
ork)
>         queue_work(serverclose_wq, &cfid->close_work);
>  }
>
> -int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
> +bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
>  {
>         struct cached_fids *cfids =3D tcon->cfids;
>         struct cached_fid *cfid;
> diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> index bc8a812ff95f..650d727bcea8 100644
> --- a/fs/smb/client/cached_dir.h
> +++ b/fs/smb/client/cached_dir.h
> @@ -80,6 +80,6 @@ extern void drop_cached_dir_by_name(const unsigned int =
xid,
>                                     struct cifs_sb_info *cifs_sb);
>  extern void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
>  extern void invalidate_all_cached_dirs(struct cifs_tcon *tcon);
> -extern int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key=
[16]);
> +extern bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_ke=
y[16]);
>
>  #endif                 /* _CACHED_DIR_H */
> --
> 2.43.0
>


--=20
Thanks,

Steve
