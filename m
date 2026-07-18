Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB7F3DFC68
	for <linux-cifs@vger.kernel.org>; Sat, 18 Jul 2026 16:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784391878; cv=pass; b=O7uOT88psFuUvKIdicQUBq8SoWDhR1h0qluD9+3ivk1nrymk6m/f1dHHwumy3x8izDWh7fiT0dMBrGmseOMm/+HRMPkYpvWjqMewgbCkY9oMBt/fo1onHzysFWV+lq0ouZo/Ssb9fNXZosAwHzrb/2wzMay89hV5Lqr5yYxpLnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784391878; c=relaxed/simple;
	bh=58fneeiGK04WArEx0exX6TNfP/GW26/oX6pF6onULC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GZOzdd0U2GPUXfQXcJGBkK0ZKQaxroJD676sJtiwIrfaMMsIF9OT7w6i1VGzhzvZxIOLA7iz4EvjmJqLqVx67+BCp30dPb/YiuVLj+aX5Tzb5drYLc6Uzbl+uHSbvyP88FQoYf4CAedFKB4Hn+e3drXOxLwRsStieIMhS6uA5Ow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j9RAI0fL; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j9RAI0fL"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c2a449c57so86105201cf.1
        for <linux-cifs@vger.kernel.org>; Sat, 18 Jul 2026 09:24:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784391873; cv=none;
        d=google.com; s=arc-20260327;
        b=bgsnw3ttTLuB2FdEsdv14l2QPSJr+pDKG74NoRNhhD20E74v4inEwZP80tXQCR7sfq
         +lRRL845Va1ZAmFik+7kzK1EfglWFp+jcoxoiR3S483YLjdBVG3oKwo71TMwWnGhZ3TD
         95+7ZSc8HEYCR65CyRhsyGmjLPdHZiGBvbDkZtn+a0q5BCov1uL673YdzkFjNoVDIPqT
         a0piKtoVfO6xe4vqbBEmcj4Dye/27WSwl5TEZhuKkXtiDf3ZInMVe2E1uQV7UGN90DWR
         Dck8oAy04JdeM/Q8MAuC+ZxE3K8bvmN/UbCQh0dTdixDBOiBWlhrQgNfMrHWqMGezHv8
         Xa0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lzGcIxw7xxVJXpsuNMch9ZaBNgK4DDNlFvbVNb0seuA=;
        fh=6/4skhh4uQJ89FQcY0lD06bp+uBzvMkKycGEQGw4o+g=;
        b=mQVwIyGUb086yTHxanGpm6Jx5sgk+ZpMGKdxdk5klrHLwPzp+J9x026f62UQR/Pnhz
         aVbeQGNw7Rlx9FAGiidt2dXizRByVbpmRE9JEy+wTcwkFsIMji8bqH52UBt92yrhesIP
         OvVr1F8MlZocR68Bs2iPBfmKKvq3ZE2MNCNCl0zCRvS2NRxoT+HvciVCZL2BHDQW1BSI
         OoIMIfK72w8QpDTMbmDPzM5blBavTyDhvmSmTGPPcSSjs2EHQMzirsJUn38Gm6iBra4u
         BJDsWLMXQ+ZOthMHULCRYrdm6Fxx/GrYKM2MUY05xCvRfGEiFEQPRL0Z5Jw6yuuiNt/n
         H4jw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784391873; x=1784996673; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lzGcIxw7xxVJXpsuNMch9ZaBNgK4DDNlFvbVNb0seuA=;
        b=j9RAI0fLt1D2mum69JRoeqAWHwUjZJYvV2HDrHUWN8ATBvrFAqmagc2psD7eso0k/D
         7UIG0+RliNKo0XsWbtJI+vo2pxUCIQPqz212bs/UCFS9hlQN1ig6f7PE0Q6yfjKnNARL
         Y57Jx5D22D+lEHSGi87ozq7erPev/2kn41GoLzUrFuUMGVZazXHXXiNlJeVhJqeITZSn
         E6bHfCHf/FUcILvPF3SPfNLhGN1Z1P0wnY1mBB4Vc1e8bz8NSqa1tCDo5oPfLrpbQqt/
         KsahWvxJBdAE9eZFStnnIvRw5w7JhzZha61ySD08pgBmEFO3q9ycWjdBx5TPhrrAcBae
         p+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784391873; x=1784996673;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lzGcIxw7xxVJXpsuNMch9ZaBNgK4DDNlFvbVNb0seuA=;
        b=SAJglauP9RxGcthak6y+KD7QMw7ng+92x4G0nz4/O4kRNQb377IWFUMP99S3P2ZMNw
         +ectK+NdywS0nKtja95vipm2jgXVKAO7x4B3Sy1QPBW+/HT/saLKyvPNGmVXlMDe19pH
         CafVqLpsZAuaQfZ2UC0fAr686oDglXUVodGDXk2tC32EvNMjGuIjc1S7WKW1GMAXUQ8r
         LRmZ+W1f/gqnltp09rgnUJiW8714io5vLDn3u/fj/EmWEqfsUNajWOEGbiBqzC4fKY4Y
         vwiJOawMROUmwcmHl/8gmbUP6CLu7TzsxNUWz0pnJKpIMAk+cMKRfihyD3bXLoOW2LKi
         69Hg==
X-Forwarded-Encrypted: i=1; AHgh+RqD0ymyS4St3R1yBgH/tvur5YwnzmfVdpD10Rg3PTW7hnHT0uzRCy4kgKLEn1qmp8krzP/Hp/nakhUQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy0vs70iIWMPGaPmc5RU6HG0I3Pq/Mkcd25fBtBo2L/dU1ubx/
	GmPQ50qJPH3FQ1/jN6o4twVovkx4g6aRYTdKjabpaeUnOupvPNBXMf0TGmu6Cvpgqm5mB+PLUaA
	rU+PuSaxVDZMFu+jqt8XYbDQ73so4X4U=
X-Gm-Gg: AfdE7ckT0haWcOgZ3Or7LsGbWLe5vXrjgbIQta1/Du4nxeL5PPQpntNZwhJcSyl1S7f
	RuYDaQAI8vBedNejIkYHo0uGMgTG7NoKT/wTl6CaU0IiSEQKGJkxUTZlDnJSRuXZELLg5mvitPz
	x4LAac7Lucj2bcm5Z7FtDKkswrTzL+MGMMqmLTfNMq4AwbiDSPv+YYlKZCXHXpNvOfoGZoqfMSV
	RW0YzePdbN6UlHNPVVpV92q41OPNV9qpYoYNzTKKZ31a8tqGZkpCPDhJWr30MtkFMEwIstyGFRG
	zSVtHbG4Qy9BvhylTyCHQwt+2hTuynuEv5JnrC0BfEswaOpScvoMjlOGrksYex2URYQY9dYG0+J
	Xzrr1ZcIR2uw1q9jqjAUIrkRl9ik77IsPy+1+vFJD7aejnBzYQ1Hrwy89ILAjIFR5sf/EYmHGsx
	qy
X-Received: by 2002:a05:622a:178c:b0:51b:fcbc:84c6 with SMTP id
 d75a77b69052e-5213e584c20mr70797241cf.71.1784391873019; Sat, 18 Jul 2026
 09:24:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260718002124.90753-1-jay@artiphishell.com>
In-Reply-To: <20260718002124.90753-1-jay@artiphishell.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 18 Jul 2026 11:24:21 -0500
X-Gm-Features: AUfX_mw2wSzfLiMWSVFhaDIwxFbR0OMnoyG24YFALTcmXsskRk9olP6yG4QQB84
Message-ID: <CAH2r5mtywQgQXZvpDFcZNWDJJoh-Kw8t7x+h2d2wT3=bDkG-Sw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: bound dirent name against end of SMB
 response in cifs_filldir
To: Jay Vadayath <jay@artiphishell.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional review and testing

On Fri, Jul 17, 2026 at 7:21=E2=80=AFPM Jay Vadayath <jay@artiphishell.com>=
 wrote:
>
> cifs_filldir() copies the entry name out of an SMB1 TRANS2_FIND_FIRST /
> FIND_NEXT response using a length (de.namelen) supplied by the server.
> The kmalloc'd SMB response buffer is bounded, but nothing checks that
> de.name + de.namelen still lies inside that buffer before the eventual
> filldir64() -> verify_dirent_name() -> memchr() reads namelen bytes.
>
> A hostile SMB1 server that returns an oversized FileNameLength in a
> directory entry therefore causes memchr() to read past the end of the
> response slab buffer. Reachable from any user who can list a directory
> on a CIFS mount served by an attacker-controlled server (getdents64()
> on the mounted directory):
>
>   BUG: KASAN: slab-out-of-bounds in memchr+0x71/0x80
>   Read of size 1 at addr ffff88800e0640cc by task poc/115
>   Call Trace:
>    dump_stack_lvl+0x64/0x80
>    print_report+0xce/0x620
>    kasan_report+0xec/0x120
>    memchr+0x71/0x80
>    filldir64+0x4c/0x6a0
>    cifs_filldir.constprop.0+0x9bb/0x1e00
>    cifs_readdir+0x2101/0x3380
>    iterate_dir+0x19c/0x520
>    __x64_sys_getdents64+0x126/0x210
>    do_syscall_64+0x107/0x5a0
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Pass the end-of-response pointer down to cifs_filldir() and reject
> entries whose name would extend past that boundary.
>
> This bug was discovered by Artiphishell's vTriage pipeline, which
> generated a userspace reproducer (an emulated hostile SMB1 server plus
> a getdents64() client) that reliably triggers the KASAN report on an
> unpatched kernel. The fix below was drafted with the Claude coding
> assistant; a userspace reproducer is available on request.
>
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Jay Vadayath <jay@artiphishell.com>
>
> ---
>  fs/smb/client/readdir.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> --- a/fs/smb/client/readdir.c
> +++ b/fs/smb/client/readdir.c
> @@ -952,7 +952,7 @@
>  static int cifs_filldir(char *find_entry, struct file *file,
>                         struct dir_context *ctx,
>                         char *scratch_buf, unsigned int max_len,
> -                       struct cached_fid *cfid)
> +                       char *end_of_smb, struct cached_fid *cfid)
>  {
>         struct cifsFileInfo *file_info =3D file->private_data;
>         struct super_block *sb =3D file_inode(file)->i_sb;
> @@ -973,6 +973,11 @@
>                          de.namelen);
>                 return -EINVAL;
>         }
> +
> +       if (de.name + de.namelen > end_of_smb) {
> +               cifs_dbg(VFS, "search entry name extends past end of SMB\=
n");
> +               return -EINVAL;
> +       }
>
>         /* skip . and .. since we added them first */
>         if (cifs_entry_is_dot(&de, file_info->srch_inf.unicode))
> @@ -1194,7 +1194,7 @@
>                  */
>                 *tmp_buf =3D 0;
>                 rc =3D cifs_filldir(current_entry, file, ctx,
> -                                 tmp_buf, max_len, cfid);
> +                                 tmp_buf, max_len, end_of_smb, cfid);
>                 if (rc) {
>                         if (rc > 0)
>                                 rc =3D 0;
>


--=20
Thanks,

Steve
