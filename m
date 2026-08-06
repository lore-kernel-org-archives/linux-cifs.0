Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D73499F07
	for <linux-cifs@vger.kernel.org>; Thu,  6 Aug 2026 22:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786054346; cv=pass; b=Dgi3ZyRwcs0s1CaMg0gc2f3SeBcaQ7rY9EbkuPM5r8CQGgkP8eqQJs2FkOgCxZpxyy9UcT7QWuRsr9M/smfdg0iyfEHRg06nIWDVQpZhGG8loIREJS6gM8KkKnX+sZc084eIx5B9upIU5qWAwiJK3nwu5TaNoVuQ5YNLEAwLiYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786054346; c=relaxed/simple;
	bh=2HtdCOmQNsNYSMKEc34KMZ6eRd+QklfVcwZ2NEaB8+4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L8j2VwTH9PQ9N/iLLMcpphMmIMjsnOUH70a7HiKRzBG8epW3RYhXSOePhse+GyvQBZ6Z1YaW+Jk5LHeiYj1kUiv3wF+9A2v9ScViRYokUyyJ4omgxJVxN3icmt02ltMB+DQRPx1C8JbZj5YTy6qBwC/wJ174xcYpMgeQSK4Azz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bJBl4HDN; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bJBl4HDN"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8f29ec73064so18076846d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 06 Aug 2026 15:12:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786054344; cv=none;
        d=google.com; s=arc-20260327;
        b=H9Z1DnVLHhjaxHoUksdNdQOM5KDXXgDFrypMSaOGhCh8qjGVpIXwSq/2w1dIZ2TeYQ
         gNRPXKgukmwH74Xlc3QF76uzt7GXsL4N0MMn23Hn12eU248/onxrkGkw2juaCD7Xfj9i
         xo0pSNQ1Y5khr9m/o0IzP0s3LNrFRr6Ch4xNAbxfcYK1xAvfHEF7S5ILuMwZ3z4mZctB
         tnJSq+XtlnJbjGHVtb5JA7VlWaaxr8Ij48RFeiY4lw3RtC/+wxwfJkBQQORjBPeIZJ+n
         n1YYGsmZXPHazpcL8KCu+cbYWN48HphBKxAsLwwEs+DCuTpUoubfywuNqr73FWA+C6gx
         HZ0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Sllrkhd2/fp33jA3hDdBWqmnbOpjD3ms7CijBHO80hg=;
        fh=SQxvXb4VDO4074iFIfLmZ5j3JkCVG9yrhjhWFYULVN8=;
        b=LtmZj24G9tYPL/BLSdxiAlW4HbUKHM2nlbT5F2Q2zokHt6MDPY0qcmSV6bfJ44RHnt
         g10HGrqnm5B9GIVZ2wasr+M9hJKDdRbsU8RgZAIhFKmyOl2KZ717e3VC9/8lKwR0xGki
         WglcAv/2EnSaG4tx3n7dy8Krp77rGuVXFRGXuEjJV1aGdgTqw0xS2EhclmBLuO97Gk/a
         dKOtuU2u/9oGZppUrVUM2VVFNf6kBGQCQQsGLizIQP/tP9WvOk49QFfgrcgEnQEimRPj
         woxNu9jDv/v3T/Uak4vP70kv0rPAMhcB0KG2OxwS1TMKK6k0nwxQKQ/PuELDQKPdZPfg
         B4Ew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786054344; x=1786659144; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Sllrkhd2/fp33jA3hDdBWqmnbOpjD3ms7CijBHO80hg=;
        b=bJBl4HDNIJ6z1ScZ+yJHEb9p6AOnBpedMh/v1UJJ/9ec5RJYIZ0PfnzhPSsmnQbRZD
         wNd1Una8qpx7nq89DU8mf8f8H6Vo0EZnpOI/5EcScGD5aNkdaDFR/dfMEZngjE3jk5U7
         P7d4q6yoUb1FIvu2fVVJ50vEvV4Edg8D0qPyoNqOKM5+rBD2ypO/qsHkqXbuvxlBBJNc
         /zL5atCg9XV7/z33OSBn9whkwbYbiIBOCiFOm2leGCRCFTbDVozEKu9y1IW2zrqJFtGR
         GcSxZxepX6ZeJY5jg5yiwdypqI2uDjLBXzyW4ZpAjiiVutylK0Ob4TRX3zjlUWOs1WBq
         wSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786054344; x=1786659144;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sllrkhd2/fp33jA3hDdBWqmnbOpjD3ms7CijBHO80hg=;
        b=KNnnICYCMCyRRuVXh+RJE4NR/4CjR0yr4MHHLfPcxE4WtLsvpy4jspyROM5GHUcXEZ
         QgBxXnRSHDai1Ms7bU844PEpoFzOH3d1nQGnRXzCzLH2lJ982eGNrouzmMxzaQjml7Ck
         cQ66vlj8Ze3p+Mh0caFcv7mU5k8GR1tktt/i+zZ+G+LoHV2J3ltxblBIjjh4pdiB9eJS
         ZEWB4QQSNjRm8Iexh0SzhD3CPrE5WU+DLoruxfXyW49p5LHKqup4HYSyAJacVPYYNYcC
         onrIpqjQw4MecLmNFlQ18GSbLJKeMnMBLUP3fALyuqA1i+H2fuQaoHSgMo9w3wtowGlp
         uiMQ==
X-Gm-Message-State: AOJu0Yw++ZGFECO9sms7aCMkCqf31CK5k9PsroqCyaNb8OsIk/W6zsS4
	Q1CndyWqhsx4HmzXo53PoW+bW1AdLkfzv//ZIrZjFI8TJmuk/O3kgFguseXWUWHRiiTtg53KNRs
	WoPUj2yh4IJZVvmXneDDWww41EINJAoJtOg==
X-Gm-Gg: AR+sD12joSjznOwb81z+hd/8GgAYeTabVlZ7xkZA9rPqzi5v3kbRK2iGpbtlelxeoYm
	c12UMYLAtaIJS1cJtOIaEddVuIu09Ssf/9aVBCDklff0N7QylXyZ++zfookM1w5WInry75qUnGS
	nrfC8KRxxZtPUPThwqhX5Ci8WTsjxaVGgWs+OI66iufPXYLVzL75UpDEM3ZCjAagsnNg9qyRjCc
	rOcQBzmK9nQ8dk5TCUvZ44SO8R/9lThDvlKFrLsZz9GysnJTOiVMlki/SCt7rAHJXI3AM0D2jTh
	VefuBYLIeOvKlTROmPJMhiBjznyVEbCOJvdRnXFkJnqBbbWcjG23NUjI39Nq49PcE987ngyw8X6
	ytTLTa+J9oo8KyKE/96cQFdKiOK3S4HLWquz5ctPgO9rnnsaKcjohMpxnIg8gMiiG15publCUCw
	z03NGJRb0SUkN3NwzePm3WhwAS/yIqrc6ca2r2H2zenXgPTCRaNfDsgQrEourmiQhAsrxpeA==
X-Received: by 2002:a05:6214:2b93:b0:8ee:f0ac:b9f with SMTP id
 6a1803df08f44-9088125b14emr224141716d6.21.1786054343831; Thu, 06 Aug 2026
 15:12:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260806190540.332207-1-ematsumiya@suse.de>
In-Reply-To: <20260806190540.332207-1-ematsumiya@suse.de>
From: Steve French <smfrench@gmail.com>
Date: Thu, 6 Aug 2026 17:12:12 -0500
X-Gm-Features: AUfX_myv-4Ql_gLXvMAUoGxRdIpc7U3zUkE7kz79fy4TXZ3qDrpwEonnuHUyoV0
Message-ID: <CAH2r5muNkfU9LyfvKhQjHUqTF-y=GX1BSXMgyVSR9tHoJYHQvQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: require CONFIG_CIFS_DEBUG2=y for accounting
 tcon bytes stats
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

the problem I see with this is that for customer perf issues, it is
often asked to look at the bytes read and bytes written stats to
narrow down what is causing the perf issue, which tcon (and thus which
server share)?

On Thu, Aug 6, 2026 at 2:06=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de> =
wrote:
>
> cifs_stats_bytes_{read,written} uses tcon->stat_lock to account for
> R/W bytes.  This is done unconditionally on every read/write since
> commit fcabb89299d7 ("cifs: simple stats should always be enabled").
>
> On a highly concurrent workload, a spinlock in the middle of the R/W
> codepaths can become heavily contended, which is absurd given its
> purpose (protect non-actionable debug/stat data).
>
> Make tcon->{bytes_read,bytes_written,stat_lock} usage depend on
> CONFIG_CIFS_DEBUG2=3Dy.
>
> Fixes: fcabb89299d7 ("cifs: simple stats should always be enabled")
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/smb/client/cifs_debug.c |  4 +++-
>  fs/smb/client/cifsglob.h   | 24 ++++++++++++++++++++----
>  fs/smb/client/misc.c       |  2 ++
>  fs/smb/client/smb1ops.c    | 19 +++++++++++++++----
>  fs/smb/client/smb2ops.c    |  7 +++++--
>  5 files changed, 45 insertions(+), 11 deletions(-)
>
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index 4ed4f55a0bb7..3118174745e0 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -762,11 +762,13 @@ static ssize_t cifs_stats_proc_write(struct file *f=
ile,
>                                         continue;
>                                 list_for_each_entry(tcon, &ses->tcon_list=
, tcon_list) {
>                                         atomic_set(&tcon->num_smbs_sent, =
0);
> +#ifdef CONFIG_CIFS_DEBUG2
>                                         spin_lock(&tcon->stat_lock);
>                                         tcon->bytes_read =3D 0;
>                                         tcon->bytes_written =3D 0;
> -                                       tcon->stats_from_time =3D ktime_g=
et_real_seconds();
>                                         spin_unlock(&tcon->stat_lock);
> +#endif /* CONFIG_CIFS_DEBUG2 */
> +                                       tcon->stats_from_time =3D ktime_g=
et_real_seconds();
>                                         if (server->ops->clear_stats)
>                                                 server->ops->clear_stats(=
tcon);
>                                 }
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 79e4e84f8985..e0e945c1de0f 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1240,9 +1240,11 @@ struct cifs_tcon {
>                         atomic_t smb2_com_failed[NUMBER_OF_SMB2_COMMANDS]=
;
>                 } smb2_stats;
>         } stats;
> +#ifdef CONFIG_CIFS_DEBUG2
>         __u64    bytes_read;
>         __u64    bytes_written;
>         spinlock_t stat_lock;  /* protects the two fields above */
> +#endif /* CONFIG_CIFS_DEBUG2 */
>         time64_t stats_from_time;
>         FILE_SYSTEM_DEVICE_INFO fsDevInfo;
>         FILE_SYSTEM_ATTRIBUTE_INFO fsAttrInfo; /* ok if fs name truncated=
 */
> @@ -1655,10 +1657,11 @@ convert_delimiter(char *path, char delim)
>
>  #define cifs_stats_inc atomic_inc
>
> +#ifdef CONFIG_CIFS_DEBUG2
>  static inline void cifs_stats_bytes_written(struct cifs_tcon *tcon,
>                                             unsigned int bytes)
>  {
> -       if (bytes) {
> +       if (likely(bytes)) {
>                 spin_lock(&tcon->stat_lock);
>                 tcon->bytes_written +=3D bytes;
>                 spin_unlock(&tcon->stat_lock);
> @@ -1668,10 +1671,23 @@ static inline void cifs_stats_bytes_written(struc=
t cifs_tcon *tcon,
>  static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
>                                          unsigned int bytes)
>  {
> -       spin_lock(&tcon->stat_lock);
> -       tcon->bytes_read +=3D bytes;
> -       spin_unlock(&tcon->stat_lock);
> +       if (likely(bytes)) {
> +               spin_lock(&tcon->stat_lock);
> +               tcon->bytes_read +=3D bytes;
> +               spin_unlock(&tcon->stat_lock);
> +       }
> +}
> +#else /* CONFIG_CIFS_DEBUG2 */
> +static inline void cifs_stats_bytes_written(struct cifs_tcon *tcon,
> +                                           unsigned int bytes)
> +{
> +}
> +
> +static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
> +                                        unsigned int bytes)
> +{
>  }
> +#endif /* !CONFIG_CIFS_DEBUG2 */
>
>
>  /*
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index 46e1382e8e04..597dc3c68cd2 100644
> --- a/fs/smb/client/misc.c
> +++ b/fs/smb/client/misc.c
> @@ -145,7 +145,9 @@ tcon_info_alloc(bool dir_leases_enabled, enum smb3_tc=
on_ref_trace trace)
>         INIT_LIST_HEAD(&ret_buf->tcon_list);
>         INIT_LIST_HEAD(&ret_buf->cifs_sb_list);
>         spin_lock_init(&ret_buf->open_file_lock);
> +#ifdef CONFIG_CIFS_DEBUG2
>         spin_lock_init(&ret_buf->stat_lock);
> +#endif /* CONFIG_CIFS_DEBUG2 */
>         spin_lock_init(&ret_buf->sb_list_lock);
>         atomic_set(&ret_buf->num_local_opens, 0);
>         atomic_set(&ret_buf->num_remote_opens, 0);
> diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> index dc5a8c1da623..484e12cb9181 100644
> --- a/fs/smb/client/smb1ops.c
> +++ b/fs/smb/client/smb1ops.c
> @@ -817,14 +817,25 @@ cifs_clear_stats(struct cifs_tcon *tcon)
>  static void
>  cifs_print_stats(struct seq_file *m, struct cifs_tcon *tcon)
>  {
> +       u64 bytes_read =3D 0, bytes_written =3D 0;
> +
> +#ifdef CONFIG_CIFS_DEBUG2
> +       bytes_read =3D tcon->bytes_read;
> +       bytes_written =3D tcon->bytes_written;
> +#endif /* CONFIG_CIFS_DEBUG2 */
> +
>         seq_printf(m, " Oplocks breaks: %d",
>                    atomic_read(&tcon->stats.cifs_stats.num_oplock_brks));
>         seq_printf(m, "\nReads:  %d Bytes: %llu",
> -                  atomic_read(&tcon->stats.cifs_stats.num_reads),
> -                  (long long)(tcon->bytes_read));
> +                  atomic_read(&tcon->stats.cifs_stats.num_reads), bytes_=
read);
> +#ifndef CONFIG_CIFS_DEBUG2
> +       seq_puts(m, " (CONFIG_CIFS_DEBUG2 is disabled)");
> +#endif /* !CONFIG_CIFS_DEBUG2 */
>         seq_printf(m, "\nWrites: %d Bytes: %llu",
> -                  atomic_read(&tcon->stats.cifs_stats.num_writes),
> -                  (long long)(tcon->bytes_written));
> +                  atomic_read(&tcon->stats.cifs_stats.num_writes), bytes=
_written);
> +#ifndef CONFIG_CIFS_DEBUG2
> +       seq_puts(m, " (CONFIG_CIFS_DEBUG2 is disabled)");
> +#endif /* !CONFIG_CIFS_DEBUG2 */
>         seq_printf(m, "\nFlushes: %d",
>                    atomic_read(&tcon->stats.cifs_stats.num_flushes));
>         seq_printf(m, "\nLocks: %d HardLinks: %d Symlinks: %d",
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 192649fec25d..e1e28f202d0c 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -1425,9 +1425,12 @@ smb2_print_stats(struct seq_file *m, struct cifs_t=
con *tcon)
>          *  Can't display SMB2_NEGOTIATE, SESSION_SETUP, LOGOFF, CANCEL a=
nd ECHO
>          *  totals (requests sent) since those SMBs are per-session not p=
er tcon
>          */
> +#ifdef CONFIG_CIFS_DEBUG2
>         seq_printf(m, "\nBytes read: %llu  Bytes written: %llu",
> -                  (long long)(tcon->bytes_read),
> -                  (long long)(tcon->bytes_written));
> +                  tcon->bytes_read, tcon->bytes_written);
> +#else /* CONFIG_CIFS_DEBUG2 */
> +       seq_puts(m, "\nBytes read: 0 Bytes written: 0 (CONFIG_CIFS_DEBUG2=
 is disabled)");
> +#endif /* !CONFIG_CIFS_DEBUG2 */
>         seq_printf(m, "\nOpen files: %d total (local), %d open on server"=
,
>                    atomic_read(&tcon->num_local_opens),
>                    atomic_read(&tcon->num_remote_opens));
> --
> 2.55.0
>


--=20
Thanks,

Steve
