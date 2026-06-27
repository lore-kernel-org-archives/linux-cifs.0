Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11144224D6
	for <linux-cifs@vger.kernel.org>; Sat, 27 Jun 2026 18:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782583483; cv=pass; b=rMwfq4Y8kYRi/+f7tuIM/i+1ByxlQXRnYzQBF/wH4dr18lVtrmNpjyZfTGyIBeS6xgGIRF3cPcgaSe10pN5lPppU0D9mbSL2O1kBME2LMTKSYUzLWXxOTnTMuVfQndIzR8iRqeHWsAGFNbY52ofXGUedfdeauCdjUs1KdGWv1kk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782583483; c=relaxed/simple;
	bh=00cjUUyZW9IepMQqd5lzGefz52EH8BD8Uq3oD/2NHkk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ugjZUNU6SGdkZ/GZBVI9Yp9nqt2Nnvcz04aw4DTS9orqn8SQOZabbPLSZoyY8hoay6ycH+gsaadnA/aBzqTCrCYAoOb5LV9d2MOMWLzqVtJmztWyGpzeTlukjgDzAqfenEBx74wFyWr6PMLCVp3JRLFk6ULFlDg5oDT/5IrCztI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LQmgKxxf; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LQmgKxxf"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8dd6e530061so33026086d6.2
        for <linux-cifs@vger.kernel.org>; Sat, 27 Jun 2026 11:04:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782583481; cv=none;
        d=google.com; s=arc-20260327;
        b=UEExoqPTAQdaXYevAOhlbQsMEavMYC7+uOvQY9x8SI7ry6VBFKARnCq1q14GP5YUOd
         gDjCVCiC/EmGehO9rvG6Kep05kfe50Kl4m0NpqsUzJrDtcFeGtb3rO9qpsn1WjmW2gvm
         gSxsSo4bCt11c8/dYwjR2K1k5aCFHLVj17Jd7IKXSHK6Z3UuhwXr2gmZT7h12BGSukxY
         +kyr3rUX2c2w4kWwluy9c5pxmz49XOJL2aYXHLS4KIISfh8oVXeDBUuAtszxdF0EAE7j
         zzfTYA6sMjOajAVOHNVOZml67Sabp3LsL8ucsWwuc6Ph2Cd8G+pK05i3fHDjdoosmyHI
         qDYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h+8t13E4Nr3S1jPpui9oOc3txeOZjy0vLV1Nv9RtrvE=;
        fh=2LhtuHb+/q4JkSN8O0lBpTwIzRmIb17ngiwzZvhlzcw=;
        b=PproisNLFMTf7IpQ3MTxtMSor6cYYnrNQ0wBvdzI12ZrZojo4+Vr3u8avi3fptZgu8
         0oaF0hPotDk1sPSFaGLM6+5dj6bjKZDkIva8Gv68SisVCu11tsG4I3QKj9IJv6IVykKT
         SlkBXibS+P9dHrTvZl/Qk0wlaF0nLLh3RQCZkmygjRwLleaV4k0b+j/KIXCEuCaKBEcO
         iXGKR7nXhSWZClYdvylvfHEdkC10Wr/nm0jJGjd0P0j7jB5FabB2PA2BTP4V9moW8dk+
         8n+RzQb5tFgOdIBtNSVr+Mb2eBqH8BL3FJ0dUuBDc/9hyJFK/mZEKqpwBtZBTEeIZHdW
         2gzQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782583481; x=1783188281; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h+8t13E4Nr3S1jPpui9oOc3txeOZjy0vLV1Nv9RtrvE=;
        b=LQmgKxxfto/Fs8cTugVOOMutD34D9JKyLivmtvUaLV/+kD3M/bzblxKvvO2KCDO2Mq
         EuWdLaausFW1kMaOutci+yHEzlJxiv5g7baLem2pP5FMq4LKM1ADkwQNQL5YdmEr1F2W
         ypOj3gsaTzytXPS4rIgxkdIc2ioD/wthwJvXeGb6pkuplnwuSxi98XTOIXvKONNGOEBb
         GsKFKJAItTYdkrp1tQUyHHVpr/kLysaHJ8Z6ta+KqB7CQsqhoeCDrP745Ko3oevxqaqc
         OpotLvXOUaIWQHiGrgrGrY6SD/kosrwBgkM0hwfNeaoG1Gug+YnDL4qZDBpovbz1mBua
         INOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782583481; x=1783188281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h+8t13E4Nr3S1jPpui9oOc3txeOZjy0vLV1Nv9RtrvE=;
        b=dkPEsPE7KaSYgST3dPnKfaBG4f/5t8Nd8ODE5GwcpTcT/x102yJ5mJaM/mVKGYIg4M
         udoUXOM6Pd6STa1FPhjKlfnvxEK/fkD9/OEzILcTgffms0bkvjJzaztWrQjIJtUOgZui
         yKfqI1HtsUu78fBCxaUh93EaQLr5rXDd3/PcBc5eP7WuN9M/WXCFijaWSdXryUse0Wny
         HY17GLBlyRO2digWa5cJHk5KfUfDIS+dksbMLeY5OQ99K8t6VQojhqbn4EZewKzzwjkE
         1srHAWeLm3nP63EjcTaUiMLEQig/S0XfLGK8ey0ghoPEIMb3Jcp0WUieDnyYI4vWYZkG
         FC1w==
X-Forwarded-Encrypted: i=1; AHgh+RpK4q7j+a+j+t9lGjLZD+G5Pf+4qndwcCQChWdSAODpFs1ief1MQzx2dJKwgFYTJCb4hJ71EJTeVO4b@vger.kernel.org
X-Gm-Message-State: AOJu0Yyke34vmXkJ2som4g92KR9ncZl1DcvwZtnaDY925PzIL2M+B5YG
	FZzQDdnH/mSY9cD00PqQ1SM5AWCJ0KO1a5MrIxHmCSrioSqsgZW5ElzIo371TGdX+uAqy3UyaV0
	OBsbgNfNSqpr3YaN3PpNpSrzD8L1CRMk=
X-Gm-Gg: AfdE7cmCL8hfQV5VpKx0lX72dMTpCHjrl0Nw8e2jPS8IXzUaMLJCd6C9gunclR7PCJ9
	3uPHaGQ/g3lWMe0hD0IqmID6rdUc1wajmYP3BwjzbUJUaCW9LgMZEkIApYAo3mE/8Xrxpn1uAb9
	jvpmgkhALvCpMOybKuMooWpeYlaEaiJOLXEwFmgAH+4LOcR5yUYbq0iQogmG+8Wm6V1QW/4N3f+
	Li/YuHibf+0cCwQCrWpHr5iVRTU+Unb9Md/uDmIdkTxNXdPTJmyDttoWdP3B5cDUJv9/VU9FKMD
	iXxXH7CyPGmNnp6OlBDdYHPgTEKYj+7d7Rl0qP3oPh8bsgDQ7WqZ4HTm2njZesG9Q96GCKIUJnA
	xHQoZCP+tZHdKWkz4rJkdG9hDQnVEhihTrDLCG41BSaG3vfNRGnO8Q/arTayw3yD543ElOMMRqP
	5gFjLriTkuXxA1z89e8mo73Q==
X-Received: by 2002:a05:6214:54c4:b0:8e0:6afc:38c2 with SMTP id
 6a1803df08f44-8e6d67832fbmr194800976d6.34.1782583481039; Sat, 27 Jun 2026
 11:04:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260626134719.158270-1-huiwen.he@linux.dev> <20260626134719.158270-7-huiwen.he@linux.dev>
In-Reply-To: <20260626134719.158270-7-huiwen.he@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Sat, 27 Jun 2026 13:04:29 -0500
X-Gm-Features: AVVi8CdU5iYzsnpKJM1mAXrsgtABaFidGryYVAXA21mZpdgsVfDFcwvmSZPf5-I
Message-ID: <CAH2r5msQgF_ktpuAbebZzhd+=u7yu9GO1+9ePpRmwB4cLO6FTQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/7] smb/client: emulate small mode 0 fallocate ranges
 at or past EOF
To: Huiwen He <huiwen.he@linux.dev>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Running to Samba I have always been getting a failure with generic/213
(with or without this patch). Any ideas?

generic/213        - output mismatch (see
/home/smfrench/xfstests-dev/results//sambamfs/generic/213.out.bad)
    --- tests/generic/213.out 2026-06-16 19:54:18.366737595 -0500
    +++ /home/smfrench/xfstests-dev/results//sambamfs/generic/213.out.bad
2026-06-27 12:37:15.973294906 -0500
    @@ -1,4 +1,3 @@
     QA output created by 213
     We should get: fallocate: No space left on device
     Strangely, xfs_io sometimes says "Success" when something went wrong, =
FYI
    -fallocate: No space left on device


On Fri, Jun 26, 2026 at 8:48=E2=80=AFAM Huiwen He <huiwen.he@linux.dev> wro=
te:
>
> From: Huiwen He <hehuiwen@kylinos.cn>
>
> The xfstest generic/213 has a mode 0 fallocate case like:
>
>         falloc 0 1G
>         falloc 2G 1M
>         truncate 3G
>
> The expected layout is:
>
>         allocated [0, 1G)
>         hole      [1G, 2G)
>         allocated [2G, 2G + 1M)
>
> Current CIFS can pass this test while allocating the intervening hole.
> Before this change, the server-side layout was effectively:
>
>         allocated [0, 1G)
>         allocated [1G, 2G + 1M)
>
> so [1G, 2G) was allocated as part of the second extent.
>
> Emulate small mode 0 fallocate ranges that start at or past EOF by writin=
g
> zeroes only to the requested range.  For off > old_eof, this preserves th=
e
> hole between old_eof and off. Keep this emulation limited to 1 MiB so the
> client-side I/O cost remains bounded; larger unsupported ranges remain
> rejected.
>
> After this change, the same pattern gives the intended layout:
>
>         allocated [0, 1G)
>         hole      [1G, 2G)
>         allocated [2G, 2G + 1M)
>
> This changes generic/213 from a false pass into a range-correct pass.
>
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2ops.c | 50 ++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 47 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 311709d73798..02ecba985daa 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -3693,18 +3693,22 @@ static long smb3_simple_falloc(struct file *file,=
 struct cifs_tcon *tcon,
>         struct cifsFileInfo *cfile =3D file->private_data;
>         long rc =3D -EOPNOTSUPP;
>         unsigned int xid;
> -       loff_t new_eof;
> +       loff_t old_eof, new_eof;
> +       struct smb2_file_all_info file_inf;
> +       u64 asize;
> +       int qrc;
>
>         xid =3D get_xid();
>
>         inode =3D d_inode(cfile->dentry);
>         cifsi =3D CIFS_I(inode);
> +       old_eof =3D i_size_read(inode);
>
>         trace_smb3_falloc_enter(xid, cfile->fid.persistent_fid, tcon->tid=
,
>                                 tcon->ses->Suid, off, len);
>         /* if file not oplocked can't be sure whether asking to extend si=
ze */
>         if (!CIFS_CACHE_READ(cifsi))
> -               if (keep_size =3D=3D false) {
> +               if (!keep_size) {
>                         trace_smb3_falloc_err(xid, cfile->fid.persistent_=
fid,
>                                 tcon->tid, tcon->ses->Suid, off, len, rc)=
;
>                         free_xid(xid);
> @@ -3714,11 +3718,51 @@ static long smb3_simple_falloc(struct file *file,=
 struct cifs_tcon *tcon,
>         /*
>          * Extending the file
>          */
> -       if ((keep_size =3D=3D false) && i_size_read(inode) < off + len) {
> +       if (!keep_size && old_eof < off + len) {
>                 rc =3D inode_newsize_ok(inode, off + len);
>                 if (rc)
>                         goto out;
>
> +               /*
> +                * A small range at or beyond EOF can be allocated by wri=
ting
> +                * zeroes.  For off > old_eof, this preserves the interve=
ning
> +                * hole instead of allocating from offset 0.
> +                */
> +               if (off > old_eof ||
> +                   (off =3D=3D old_eof && old_eof !=3D 0 &&
> +                    (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE))) {
> +                       if (len > 1024 * 1024) {
> +                               rc =3D -EOPNOTSUPP;
> +                               goto out;
> +                       }
> +
> +                       rc =3D smb3_simple_fallocate_range(xid, tcon, cfi=
le,
> +                                                        off, len);
> +                       if (rc) {
> +                               spin_lock(&inode->i_lock);
> +                               cifsi->time =3D 0;
> +                               spin_unlock(&inode->i_lock);
> +                               goto out;
> +                       }
> +
> +                       new_eof =3D off + len;
> +                       netfs_resize_file(&cifsi->netfs, new_eof, true);
> +                       cifs_setsize(inode, new_eof);
> +
> +                       qrc =3D SMB2_query_info(xid, tcon,
> +                                             cfile->fid.persistent_fid,
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
> +                       goto out;
> +               }
> +
>                 if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) {
>                         rc =3D smb2_set_sparse(xid, tcon, cfile, inode, f=
alse);
>                         if (rc)
> --
> 2.43.0
>


--
Thanks,

Steve
