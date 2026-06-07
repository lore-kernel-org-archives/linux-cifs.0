Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C82A17D6
	for <linux-cifs@vger.kernel.org>; Sun,  7 Jun 2026 15:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780846566; cv=pass; b=eXxpu8WPRRBHkekQW9zb08RbWB8r93kG7a6mJw1o3eVEvvlXGLed716Z9hQxKG3oFEiPrK5FeU20Rt+RHDPIUxw9e+5pwM4ICZgHQkRw55GIb+e3yG/4Gxqd6llnOWDVQOMrTgtHm2KSjCvaeKTo8i+ZFM5v4Tdg8mMIG3Fo7lQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780846566; c=relaxed/simple;
	bh=PcFrDrm4nX7OxWFulTG7I+ZRFcXhn9HCQr+MH9bEwPw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RVtE/jIgAr4dLzf9rBrcl1C6l1KtNMTi+NXcnE1Jxjof58+I2ccPD+tVgt2ah+KrmbyA9OYb0AsNtkwFaT4q25yWJxJEwS2kJecdSATQa6q1yhU7E/dWUacncmK5M8CL3YpQU8upWuiC+6PNzZnc7zVrMNWnNw9omnnAZGan9cs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K6STQLAg; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K6STQLAg"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8ce9df31840so25897376d6.1
        for <linux-cifs@vger.kernel.org>; Sun, 07 Jun 2026 08:36:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780846564; cv=none;
        d=google.com; s=arc-20240605;
        b=J+cyp0xBhNE574nSU9C7s+punyFMm5z1iXpf/q7LYbb+zzMXZpWewtSKe8o3TS8jC9
         OIcqa4WjJkH1LGspL8wlGlNfHTmbVpGRIeBkBdpw45lJs0dwzSNm1bzr6mkzjKzwMyLl
         n3I5B7EI3MDyqe5DE/VjXAU6lvbSPyNjkAgqGYPPLnqMzxsOXZuM8oragd1TLe/PTAxt
         7zUV/rjd99qIH2C/Qtib5n5h9qB6pVOpOeVTAW6dwln9Y7BVTSVw8LHm6o+ZwPVNv561
         S2kbv0M0pg11RQaxtZbGngVI0FzmayCPOewpNkO2tifMPw+AoUEOAp4kkNFSqKklrQVt
         Xdkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pKBey19T5rzRF+YoKzIviBsKJnnJEf4gY0FQdWzaXU4=;
        fh=WDEtHRrpHL0eBFDiu/9YlEvg14RBFyCL+LxP20Zh1zk=;
        b=ag/EWS/fPgGqANXG/Sjm9i2yHBg63GhDt0xl+H2QcLPVp+GUSwj7dh13txdO/lK/UL
         Jj0zLRHseGUz+dDrrZ5yegFfe8aBDWzSMMeHYdqNKUILBy3N+ynF6X1RN/6B+NX9n0rF
         3CHANnLdh4w8klXpPbYj/pvjFFccQ31k1msA1eTKRaMghsa/H18ImE5Jqf8PGI/ed0ON
         cRBdN9pgMtjlbmDyw+5AwVsPw4tlQKY+s9ec02N4ccoUnRIvlPiV+hoiVKB5hTKdRgKE
         +/L23o1k9i/VE6R6VmlH5CTd+BU07YZnMfcA6h+GHSaMnd76RWLe0FbYbJQAH12APzuh
         9YZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780846564; x=1781451364; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pKBey19T5rzRF+YoKzIviBsKJnnJEf4gY0FQdWzaXU4=;
        b=K6STQLAgezf4bqJYTo3WhaGN8TBZjz1YTqPvUAv/gS20clxDeg8B0kMWRuUtgfNASv
         3sEJG2+H6en4hPVFTP1nS5xUKmooM2/GyfNb0ptGkHlSbZbNu9odDhPWNWixdEHiWbaR
         XBVgirlhMtS+wd4CjiM27XrJIxVryqsHns9nXUqD00TNj1wbq2PdUYGu5qGdQV4absJc
         qRpbgcmciLOl16VUOXpI6tN9ceKQG0pJ/63hHud8RrPqN39CWC05JXzboQ5vkDvXrVsf
         OQkOeutbrsdU2FPTUChVV6lIdlt+9vyC+6EgBq2cZXHCHHtXVphGNV+5b3ZT8PryVGHs
         wBtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780846564; x=1781451364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pKBey19T5rzRF+YoKzIviBsKJnnJEf4gY0FQdWzaXU4=;
        b=cDBlXoiMM1wTEwFfi+O72s6m5HbqzUIBeKFP/nlwAbOqL0es8wl1jzX4gKyYo1Kwzv
         UsnQ+izDgSr5WCyUpQ9u1enmRHHzqImWrDVysX4n9ESjYQQwHnZafvYMmYv2LeyI/OmH
         ZqM2K/EengUlCAJCS89KgHFzkq34FOX+WVEWT6gytRCnROJyW+Qfz7CdjtohGT6ErYpX
         fhiaL+GjWzxsuk7D5i/Jgr1KLjdX5MNa0il/vtYjxGIzjVPynfmwXsaLiFbxX8DMGvPG
         6hiAOBwZu3V3wjCUBtYwDD7GJW2qWRNHEHhVIo43iwFLf7E+TGbQGVDHSrrzm3QprOx2
         axXQ==
X-Forwarded-Encrypted: i=1; AFNElJ9rXLyl/iZ+JPxtTSvq6+qzawAQU/dwV59pw5O19PVIhy9Md7GUHeFVRvsRxtMoieqwKk8KVK3a4xA5@vger.kernel.org
X-Gm-Message-State: AOJu0YxgjaykLtMwiOp4PFM506PVlhI/UmiqbobJVVLO6KEF38uuVm0T
	dfzTOGoitNCpkyk4Swq0FaFt9jZmgYD2+4z/2fUblHiqXSkP5+Y2qnsviJLZfl6KRXcMUuc8zgp
	VFrnrgYo/acnwXMdladgYVR70pL2+4P0=
X-Gm-Gg: Acq92OHwyBkzTCwUiVByb/VeMtuxPL/iJxoDYA/1Qp1ANgiEdO+xrWlCuAhjtw60QZW
	cKJdBhh1+PnBnYWNeqrDOFDDm3UEoXas5x8aboq5goUeb++vQyqnHhy1KHb2XgDOvf4toc3H5OX
	fvYRJ9AZc0+AuKHhBN54IsANmgYI2TMu58b83XmYyR7cnTuh7zvHI2+p4x7e8abTCc/mjn1nDRu
	RtnE/V5I/tmuA/hC12h8vB8zAZHVyQF7ZMQF55PQA5NB6vf8r7tzuIiYgS/0Hc+XKBDDMELW3tY
	NbmUFULuHQmgvXXRrlHHMPCcvwcRpQGg2L2A5weYwC7b4LmSUudKSjVN9ss7hb04NWUTVg77y+a
	4rRuNtSAT4LmJhHpBZ5I0Wh9g75NcxezI6LcbvUCTfqdsICKwNcMfNRlLITofQKuMlrbaRIqq+4
	g9p5Jex/VVldHUiDGAcYxZ8GDUtDICS7R5/7TEQwFn
X-Received: by 2002:a05:622a:4d98:b0:517:5e32:af1e with SMTP id
 d75a77b69052e-51795a87723mr178114501cf.8.1780846564489; Sun, 07 Jun 2026
 08:36:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260605163519.169916-1-huiwen.he@linux.dev> <20260605163519.169916-4-huiwen.he@linux.dev>
In-Reply-To: <20260605163519.169916-4-huiwen.he@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Sun, 7 Jun 2026 10:35:52 -0500
X-Gm-Features: AVVi8CfCV815gb7eKrK5D0hBMzoxz1wHfhRfzMl1-qYYtjzwDgDgwgtro9Fxn4I
Message-ID: <CAH2r5ms=53YHR41Y9qWozAtSO5UP4yqDN4myp-pju7WpP2WLjg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] smb/client: refresh allocation size after fallocate
To: Huiwen He <huiwen.he@linux.dev>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This regresses xfstests generic/568.

generic/568  1s ... - output mismatch (see
/home/smfrench/xfstests-dev/results//sambamfs/generic/568.out.bad)
    --- tests/generic/568.out 2025-08-22 09:54:32.333796989 -0500
    +++ /home/smfrench/xfstests-dev/results//sambamfs/generic/568.out.bad
2026-06-07 10:32:28.896135808 -0500
    @@ -1,4 +1,4 @@
     QA output created by 568
     wrote 2/2 bytes at offset block_size - 1
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    -OK: File did not grow.
    +ERROR: File grew from 512 B to 1536 B when writing to the fallocated r=
ange.
    ...
    (Run 'diff -u /home/smfrench/xfstests-dev/tests/generic/568.out
/home/smfrench/xfstests-dev/results//sambamfs/generic/568.out.bad'  to
see the entire diff)

On Fri, Jun 5, 2026 at 11:36=E2=80=AFAM Huiwen He <huiwen.he@linux.dev> wro=
te:
>
> From: Huiwen He <hehuiwen@kylinos.cn>
>
> SMB3 fallocate extends EOF using FILE_END_OF_FILE_INFORMATION, but the
> server may also update the file's AllocationSize.  If the client keeps
> the old cached i_blocks value after fallocate, the swapfile hole check
> can still see:
>
>         i_blocks * 512 < i_size
>
> and reject the file as sparse.
>
> This shows up in xfstests generic/496 as:
>
>         generic/496         [not run] fallocated swap not supported here
>
> After a successful EOF-extending fallocate, query FILE_ALL_INFORMATION on
> the open handle and update i_blocks from the returned AllocationSize. If
> the query fails, leave the fallocate result unchanged and force a later
> attribute revalidation by setting cifsi->time to zero.
>
> With this client-side refresh, and with a server that really allocates th=
e
> fallocated range, for example Samba configured with:
>
>         [scratch_share]
>         strict allocate =3D yes
>
> generic/496 can pass the swapfile hole check.
>
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2ops.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index d4875f9532b4..89230141b5dd 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -3698,8 +3698,23 @@ static long smb3_simple_falloc(struct file *file, =
struct cifs_tcon *tcon,
>                 rc =3D SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
>                                   cfile->fid.volatile_fid, cfile->pid, ne=
w_eof);
>                 if (rc =3D=3D 0) {
> +                       struct smb2_file_all_info file_inf;
> +                       u64 asize;
> +                       int qrc;
> +
>                         netfs_resize_file(&cifsi->netfs, new_eof, true);
>                         cifs_setsize(inode, new_eof);
> +
> +                       qrc =3D SMB2_query_info(xid, tcon, cfile->fid.per=
sistent_fid,
> +                                             cfile->fid.volatile_fid, &f=
ile_inf);
> +                       spin_lock(&inode->i_lock);
> +                       if (qrc =3D=3D 0) {
> +                               asize =3D le64_to_cpu(file_inf.Allocation=
Size);
> +                               inode->i_blocks =3D CIFS_INO_BLOCKS(asize=
);
> +                       } else {
> +                               cifsi->time =3D 0;
> +                       }
> +                       spin_unlock(&inode->i_lock);
>                 }
>                 goto out;
>         }
> --
> 2.43.0
>


--=20
Thanks,

Steve
