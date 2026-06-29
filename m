Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128A337D11C
	for <linux-cifs@vger.kernel.org>; Mon, 29 Jun 2026 15:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782747276; cv=pass; b=fKUfiSA4E5gi73INqwPksyNJ/FF1dtsCROgJ52HJrw/Tn+cbUva/iwzLl9zl+uBS6Jf9dFc3K0AtTapqQu+40YbDeZtNFXP5+yDa/zKA0EI2SsphDoW44HwnICRFlsbSit9QKcZb0WFC8ktNKzfnR4U5onE3FvWgy/BytSSAwi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782747276; c=relaxed/simple;
	bh=+u9AZQEV3S11NPulmXX9xQXClkKpEpy9KA8iix24zVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qXTvEoqGpVPrIYihL3yigaHr6e9LUJGbvq07T2jGpSz5fVVqGYfob4l3geHXMybN3Jf03QYEEYP/4N76eN9azMWOZyarrhRa1jkAxCzuFPVjNbq56v4pb5LYC3mZpqHu+w0yq/V6FUgXodNnddK72S5W7QXikwvB2jFDjLhFPwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ce2588Tq; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ce2588Tq"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51a0188b92fso36996501cf.3
        for <linux-cifs@vger.kernel.org>; Mon, 29 Jun 2026 08:34:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782747274; cv=none;
        d=google.com; s=arc-20260327;
        b=bd2CUw1Soa9kUejsQo6wyDYNxSMkeAscI8VeDR9R5071Isa5Q2dYvcnT7fLJnZeXoD
         rEnpMdgj72eAfK/E91NqNLZjQlhrtmSvXpsrlKM3+6n2FcfkHysC19PSgdNAehU6waLJ
         y5lYPfyzADfiJrefOYFPmRmIQOxmMeVDnHRcoZ37E8BuA0to/fFIweds7qY1m9LfWubg
         xKmFwmiYD10cio/Bo1wubF+Evlg3m/r6o+EN9Ybyz2eYiz4q5qE9cwKIlNgx+LaDOuL9
         G36mYIg9oUevtT7iUXEMjVr4eGRjKlYer4DFih5NJRtuW7a1DYkLT3GQ7un4KhdbzMjx
         Cepg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pc5WVUUaZOpIJN+f0RYzSe+QvXVQediPgMWEYHcf25Y=;
        fh=a57l5Kqoa8gzzf4aI6BlOM1u1F1CxVB9VhovUUkJ9YQ=;
        b=c7YxhpgWZqkLIzJU/aGI/dFQrChYu09I/U7OXm1i7CsL7DF+wWvI5MHLrcV/U8oOzg
         +JLn+rbqbB9+31MUxo6ay/lzfsac3Pkv3c26J2ihUC220W0RIkzkKxz4PBhvy0GWq7LP
         GxLQQzpcCgaPFWJ3icWXdMcLN9YLKyvjUbs1NssHHTJU0gF4GS/hpTrChn+UC4jvm5GH
         loJB/wmZMJ9eJJVf/LNVvMi81ZbiyXGJu54K0Z5rptUtjfzbtE4PNzWNHt5ZNGetMPD5
         rINlyOtTN/6+v0u5/mW41t+HHkDDpXJdIeUi7NmpTbsBbc/t0C4m+W5k7QTsIns0bdSV
         x1lg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782747274; x=1783352074; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pc5WVUUaZOpIJN+f0RYzSe+QvXVQediPgMWEYHcf25Y=;
        b=ce2588Tqx75hBR1Af9aRvq+CiN8PsYzWeWm/TENQ3ndVziHe9s4QHQXz+DuoQOd4S/
         0XKSUkYQC/mZYf8nx8KoETHb0icD7JekxgMCQgKgmbJoWO6mjCE1bwr6VHzKiZoo6hhQ
         OvglaDNneNcWNpeCP58jNk+pDknHRThOkRUS/nyz5ELNNEIMlD6LsTBYu5b0d2GUtLTd
         weHel2HfJEI63f0ZRutXTM+lFtIEAO9qKmbrsN2jWvoYVczGkManmTT3P2cKLETsaR63
         yyDC27FSVXQsReAXw/JspjMDDfEm/bveIlETY7L350/HYs0KyEmSYRhgyJQZPvZ6N7/v
         adKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782747274; x=1783352074;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pc5WVUUaZOpIJN+f0RYzSe+QvXVQediPgMWEYHcf25Y=;
        b=eJ9Cgel4+ebtrGCAYPCgDPzYgUwrQ26Nnlekdy1LHfjrXG3nLoICtUJHXchoifbB5Z
         FugQ4u/FhJ85Aud1ste7NNd4EK61a2a5bvGeY9ecMq/NfAfcEV+1aT6AjFDy2I7EmYuc
         nxDxx0IeCAtjc6PD7UP5KqdiNTnJrEmTsVpnRkfqoSMq5oolgKYfsxQOEG1Kjw0eA9xT
         WhxTG6Rb7mFHjBRGMRgTFPdM8xFwch/p1OTW5C9eHJT/ouveFOiHPJaBeKLqheerCXV4
         O5RhvWpufpfFErZXNcjPVwLw2aZbVwYKWL7szHOsR3WudBtdd3Hilokpaap4uEPKh6QK
         EN7Q==
X-Forwarded-Encrypted: i=1; AFNElJ+1VidxtQYNIqgFax36t9bZ2RSDT0+bThFK74MPMOs1mTsdL6Hv5TUDHUXKbSm3oSCcUixvR8A74pq1@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr8NunQNrKQ+0rzVE5XCsBt8HSHR5m5aCcn2BhCbtFCXexA6cP
	4HdzW4WOGhHjqe1nDFAn7oDXlCEbpH8xsfmBNeTCSou49Qp2Ixa6Qc6ixo7CAChPoYvbWbQre3O
	OVYjq9wfhwHblySnM0l+Bq80tUu5IgrY=
X-Gm-Gg: AfdE7ckE1KHMb9US4+jI3Y28b5DFEwShJDTaoRsqVhWUmdLFqHEBcxPnoGzCMYvR6gy
	ESq4ATZvo/CQnNEn8onAnlZScESkCSWKqe8RPfmy7krbDmtaz8J6aPCf38Bc9FhFNiqgNOJIwQR
	heS5Z/cVGW2evnlR86gY1H7UnFuCUEPRUYZBhuKvtCgGU6KXzHbmQA7ExRKyIKhg0jazLealWJU
	o5fvHDvzNrx4ANHN7GhHSe3ZPObBY1y95AGWOCACGu/6gX5itEJNY+w5SeT0b4USuqeIl4016B5
	kNWo7Qt/0hpU9BmRZV1QAi6QrkFh6voAv7Hk0GmH9I7QzNbSkdsMf1eLwr+YbA1OdpeKtXpCC/O
	N9d9wvAC/uo373gxW1mDCGRPbQfZkaLxPIyaPCDW8PF0WQ/rSUAFanf8LMmwmiFUpJcrBEEPazr
	Q5tQ8jDOL77lc=
X-Received: by 2002:ac8:5a87:0:b0:516:ed02:c85d with SMTP id
 d75a77b69052e-51a7276b211mr234178771cf.3.1782747273730; Mon, 29 Jun 2026
 08:34:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260629152659.703943-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260629152659.703943-1-chenxiaosong@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 29 Jun 2026 10:34:22 -0500
X-Gm-Features: AVVi8Ce1kL3jY_lSyqmfxE2dLOwmXFs8WCGoYWO1fB-RTytcPACTfBoq87lYt4k
Message-ID: <CAH2r5mt2Jonpx-YZ9ea0icKtGTCHFcEF77F0nJdFXRn97eUC=w@mail.gmail.com>
Subject: Re: [PATCH] smb/client: fix incorrect nlink returned by fstat()
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

wouldn't this be a big performance penalty, adding an extra roundtrip,
adding query_info call to open?

On Mon, Jun 29, 2026 at 10:27=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Reproducer:
>
>   1. mount -t cifs //${server_ip}/export /mnt
>   2. touch /mnt/file1; ln /mnt/file1 /mnt/file2; ln /mnt/file1 /mnt/file3
>   3. C program: int fd =3D open("/mnt/file1", O_RDONLY);
>   4. C program: struct stat stbuf; fstat(fd, &stbuf);
>                 stbuf.st_nlink is always 1, should be 3
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2pdu.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index d058584b8f05..70b3beb96aff 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -3371,15 +3371,19 @@ SMB2_open(const unsigned int xid, struct cifs_ope=
n_parms *oparms, __le16 *path,
>  #endif /* CIFS_DEBUG2 */
>
>         if (buf) {
> -               buf->CreationTime =3D rsp->CreationTime;
> -               buf->LastAccessTime =3D rsp->LastAccessTime;
> -               buf->LastWriteTime =3D rsp->LastWriteTime;
> -               buf->ChangeTime =3D rsp->ChangeTime;
> -               buf->AllocationSize =3D rsp->AllocationSize;
> -               buf->EndOfFile =3D rsp->EndofFile;
> -               buf->Attributes =3D rsp->FileAttributes;
> -               buf->NumberOfLinks =3D cpu_to_le32(1);
> -               buf->DeletePending =3D 0; /* successful open =3D not dele=
te pending */
> +               int qrc =3D SMB2_query_info(xid, tcon, oparms->fid->persi=
stent_fid,
> +                                         oparms->fid->volatile_fid, buf)=
;
> +               if (qrc) {
> +                       buf->CreationTime =3D rsp->CreationTime;
> +                       buf->LastAccessTime =3D rsp->LastAccessTime;
> +                       buf->LastWriteTime =3D rsp->LastWriteTime;
> +                       buf->ChangeTime =3D rsp->ChangeTime;
> +                       buf->AllocationSize =3D rsp->AllocationSize;
> +                       buf->EndOfFile =3D rsp->EndofFile;
> +                       buf->Attributes =3D rsp->FileAttributes;
> +                       buf->NumberOfLinks =3D cpu_to_le32(1);
> +                       buf->DeletePending =3D 0; /* successful open =3D =
not delete pending */
> +               }
>         }
>
>
> --
> 2.54.0
>


--=20
Thanks,

Steve
