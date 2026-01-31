Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D085D320CD3
	for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 10:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769854057; cv=pass; b=cpvpHvO3Lnm+mrPU//impaoT7nTTfmmkiVPkXEpsZcFZPBPXxbpgmn+nTsi7V9FOWixx6NV0IYNKtjLSu41aDUfs19KchZB2LW1R7tZ6eCRAvdNor7ofAT+8PEnWBQWBMWXW4+De9rUWk2A+Y5VV2sgjBdPvSXvlu3fGID/8TuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769854057; c=relaxed/simple;
	bh=I6BM5qKMHQTqFv9AaN/yS5YuzmRJeJu0XeKHoefubnU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kG56fOPKnYei7MI5x2z5SD9tzFBDT8sA0yIOzAEh31FdO8p6DQ2AfACS8V7WncFwnhWh1qsF2mMWHRVL/O3TORte2oA1TbZ2I/ozM4rSwN13K6CkQWCUvyxvqqrR5BQCqWIo1dMSmoL4tB4LQ/kBLNrTWuIl7ESUZLOJjl5esys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CG+hoyTO; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CG+hoyTO"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-653780e9eb3so3992051a12.1
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jan 2026 02:07:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769854054; cv=none;
        d=google.com; s=arc-20240605;
        b=fj8LWV/blkIJ0J8MCZEuurqUVawtB4zqKHDr5nfPZTCevzlA7LHR/Ga1AoA0xjbklp
         MZ3sm+CYHuKUQiTHv+tUZDjKggbvUodYhUOIN/5Ydy8HcSdwe1nwXkTR2c+QMM7NcoKy
         TaMdJDCuW5QEFCZKt++LgWuKFzNxwCd82HJVBAvahYPiKGdyvSIGKFobvNdN1h/JUfuD
         aQJKQ4VVZEoec/TXygr7qOektk5KgN99jAzusLCzHgD1ppfqd46IIIa8zuQeCU/rEs2s
         iPWveYQJCmZ/agNX7lJl70Mq0M0U9OtyS6K+Hzb6opgVNhzGzqOSY3mI412S6vXTNsLW
         v2Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ffws5UrLAUr9v0YnZlGYkxqmp7sDWWp3QAC/eDvakkk=;
        fh=Kj6Xhbozit2MD3l/HPRkSkLzuBLT5FY/ZDfzQZkTkqU=;
        b=IiuM5VW4z+OmWf37b250OQWbOZ+TD/pVigSMyCjFC4YSLd+j5B/CYN8nUozzU45kG4
         Tg5OiVmOuB7Ip+tndPj9boI6A+TN+K5mhYqJOQUXGEJRwCSrO3Ob5G8EOtYXtLNxzZyK
         XakQNb5JtSmRSLyv+DnRe1YRJ61TggLn2ToJM9GEnVVySsglbM+0TfMiTcjbLgjwzq8u
         MOexZ4D7/hLyhShq59noGLfe6S60sVD7n172Y3pKk0pFuSiFKJkDL86O8eRxcb7jZoai
         NhOO9TJURz0/FEEpkE3MuUPsKan3ghVacpUWLpWrrjCQvgSJTm/x2tubLDC24MXOTz31
         5yoQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769854054; x=1770458854; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ffws5UrLAUr9v0YnZlGYkxqmp7sDWWp3QAC/eDvakkk=;
        b=CG+hoyTOG4G0X7q7UXc54V7FsPR4V+wtbGeVQ9EQcIg5VhJCuSgEPm7NHIuaBSSxpz
         Fn+kTV+oYi7tfsy3i6Lzj1IrK9/PUxCfPNr1IK1SI8I/nN37BNZWNvaZAIJA4vPfH+xe
         MD6GM2Ym/vNbl27ehLQwNQVLdtF6B2EKSRkQRxJag3xRyZ7Y3CfOt06kA4Zfi8OKGX2J
         HFzQpH6N7Z5zji1FFBPdRjMUGduX9oIIU8ufWk/jb8tIwO+38E8MxdOuQDtB9haNHoHd
         q19fpzQhV/ddYUOjiHT25rbfJjjr57qjwz7nnCTpfSpQLkfwYWUu3sl+T8o8ayMAXA1/
         IoaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769854054; x=1770458854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ffws5UrLAUr9v0YnZlGYkxqmp7sDWWp3QAC/eDvakkk=;
        b=M+FBNx1r+pbM5RZQJHPpxT7XMp9XsuwKFhElHK5hm1TPDfANR9VC3ld05losJF+ldZ
         aM3sVrIN3g7eDBTie3oJ9pRedSIHF8nhwU0DJ/Lk2QaOipOBa+kw+Ra/4ftolxwBmXAV
         /X1fvnciNSazYewkhm4s0qX5eC6ibGaKoiQVdoPGmX1hUo0CtiTGvm8J0UDqnxu90lH4
         0HyTiKT4ahG6rLT+sMrGy7nkgSTFpqBKOYjhNVySD8s0lVi7K3/MKOCL/kGLaNSvH8dD
         YsEsVUXA5RUfKEuNabm93arMpD1rhQxvIctkawfGjtYX2v8GGArmQlaKWoIoV1oI9qVA
         Es1w==
X-Gm-Message-State: AOJu0YyI8rC3OeVi6QkPrvnmlLN3CfexSrsaBnd0fzCrgMWmqvcxtMHS
	StSknUq/9GSuBWi5OLH/6nDaK5RRc2zuBUjzv6fzAB51aza3ndvUvq79LS9WGWBSLOvC6N02D64
	Ado2QWEvkW/ScnnVpJ4pF/BG1sQeN5iD8vNFQMVk=
X-Gm-Gg: AZuq6aLj2yHska9ruTQuDI4pfszK2qkVm721+mmf2aeqHXgGRyrre3P6I43ILcPBexj
	xwOc5+U+vnEPiS8bM4BSNGoTZxBHghqpmEfcm8X/6/qJdjInd8ZhMceTkl/nCVbMufVr/K5y0EY
	tyGlY1F9xOwixy4tWmffO7xUiTC+U4eG6J33T0msA6vXkTYZkGrb0HjNAa4cXCBFZcdmvRnoGMk
	d2AkfAHXaz3V16wC4xr3G+3EEfRdeYgcfqpzzok0idZ8YiQoVBSOYu/zbavgCCVirjWnQ==
X-Received: by 2002:a17:907:944d:b0:b88:5ef6:17f4 with SMTP id
 a640c23a62f3a-b8dff57e898mr334181366b.17.1769854053665; Sat, 31 Jan 2026
 02:07:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260131080239.943483-1-sprasad@microsoft.com> <20260131080239.943483-2-sprasad@microsoft.com>
In-Reply-To: <20260131080239.943483-2-sprasad@microsoft.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Sat, 31 Jan 2026 15:37:22 +0530
X-Gm-Features: AZwV_Qj-pDqy7QmjR7e3bBFk7_e7OmyTKkXMmfVBRdDgVWHRta6Gvs9LEvuB9EM
Message-ID: <CANT5p=qayd=CGCytZbbqLMgVpuMt0CgZSkdDFonD8mg4gx3eaw@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: Fix locking usage for tcon fields
To: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.org, 
	bharathsm@microsoft.com
Cc: Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 31, 2026 at 1:33=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> We used to use the cifs_tcp_ses_lock to protect a lot of objects
> that are not just the server, ses or tcon lists. We later introduced
> srv_lock, ses_lock and tc_lock to protect fields within the
> corresponding structs. This was done to provide a more granular
> protection and avoid unnecessary serialization.
>
> There were still a couple of uses of cifs_tcp_ses_lock to provide
> tcon fields. In this patch, I've replaced them with tc_lock.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cached_dir.c | 4 ++--
>  fs/smb/client/smb2misc.c   | 6 +++---
>  fs/smb/client/smb2ops.c    | 8 +++-----
>  fs/smb/client/smb2pdu.c    | 2 ++
>  4 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index 1db7ab6c2529c..84c3aea18a1a7 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -788,11 +788,11 @@ static void cfids_laundromat_worker(struct work_str=
uct *work)
>                 cfid->dentry =3D NULL;
>
>                 if (cfid->is_open) {
> -                       spin_lock(&cifs_tcp_ses_lock);
> +                       spin_lock(&tcon->tc_lock);
>                         ++cfid->tcon->tc_count;
>                         trace_smb3_tcon_ref(cfid->tcon->debug_id, cfid->t=
con->tc_count,
>                                             netfs_trace_tcon_ref_get_cach=
ed_laundromat);
> -                       spin_unlock(&cifs_tcp_ses_lock);
> +                       spin_unlock(&tcon->tc_lock);
>                         queue_work(serverclose_wq, &cfid->close_work);
>                 } else
>                         /*
> diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
> index f3cb62d914502..0871b9f1f86a6 100644
> --- a/fs/smb/client/smb2misc.c
> +++ b/fs/smb/client/smb2misc.c
> @@ -820,14 +820,14 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon,=
 __u64 persistent_fid,
>         int rc;
>
>         cifs_dbg(FYI, "%s: tc_count=3D%d\n", __func__, tcon->tc_count);
> -       spin_lock(&cifs_tcp_ses_lock);
> +       spin_lock(&tcon->tc_lock);
>         if (tcon->tc_count <=3D 0) {
>                 struct TCP_Server_Info *server =3D NULL;
>
>                 trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
>                                     netfs_trace_tcon_ref_see_cancelled_cl=
ose);
>                 WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative"=
);
> -               spin_unlock(&cifs_tcp_ses_lock);
> +               spin_unlock(&tcon->tc_lock);
>
>                 if (tcon->ses) {
>                         server =3D tcon->ses->server;
> @@ -841,7 +841,7 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, _=
_u64 persistent_fid,
>         tcon->tc_count++;
>         trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
>                             netfs_trace_tcon_ref_get_cancelled_close);
> -       spin_unlock(&cifs_tcp_ses_lock);
> +       spin_unlock(&tcon->tc_lock);
>
>         rc =3D __smb2_handle_cancelled_cmd(tcon, SMB2_CLOSE_HE, 0,
>                                          persistent_fid, volatile_fid);
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index c1aaf77e187b6..6f930d6c78adb 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -3091,7 +3091,9 @@ smb2_get_dfs_refer(const unsigned int xid, struct c=
ifs_ses *ses,
>                                                 struct cifs_tcon,
>                                                 tcon_list);
>                 if (tcon) {
> +                       spin_lock(&tcon->tc_lock);
>                         tcon->tc_count++;
> +                       spin_unlock(&tcon->tc_lock);
>                         trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_coun=
t,
>                                             netfs_trace_tcon_ref_get_dfs_=
refer);
>                 }
> @@ -3160,13 +3162,9 @@ smb2_get_dfs_refer(const unsigned int xid, struct =
cifs_ses *ses,
>   out:
>         if (tcon && !tcon->ipc) {
>                 /* ipc tcons are not refcounted */
> -               spin_lock(&cifs_tcp_ses_lock);
> -               tcon->tc_count--;
> +               cifs_put_tcon(tcon);
>                 trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
>                                     netfs_trace_tcon_ref_dec_dfs_refer);
> -               /* tc_count can never go negative */
> -               WARN_ON(tcon->tc_count < 0);
> -               spin_unlock(&cifs_tcp_ses_lock);
>         }
>         kfree(utf16_path);
>         kfree(dfs_req);
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 5d57c895ca37a..c7e086dfb1765 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -4239,7 +4239,9 @@ void smb2_reconnect_server(struct work_struct *work=
)
>
>                 list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
>                         if (tcon->need_reconnect || tcon->need_reopen_fil=
es) {
> +                               spin_lock(&tcon->tc_lock);
>                                 tcon->tc_count++;
> +                               spin_unlock(&tcon->tc_lock);
>                                 trace_smb3_tcon_ref(tcon->debug_id, tcon-=
>tc_count,
>                                                     netfs_trace_tcon_ref_=
get_reconnect_server);
>                                 list_add_tail(&tcon->rlist, &tmp_list);
> --
> 2.43.0
>
Please ignore this. I'll send a v2 soon.

--=20
Regards,
Shyam
