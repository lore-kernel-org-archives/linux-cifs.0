Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B9C208D0
	for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 17:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758389634; cv=none; b=bCQGMiZQOsQoCWtHQUinT9R/Ma89mFDHjzk4Ypw6yB9ZCyY0Kgs+tRwwM4MNfNLECwjYXYubU58PoASAG7Zr26frSl5hIpFb1h4dFdojg3c0+vI3B8Y8JqTkHqbin++hMzq9WKFF1GV+6aKm4ak/CI6ToUFdvuZWoczJugiDcDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758389634; c=relaxed/simple;
	bh=axUg6ozbUEIEMe72bEm/AXSWRoT52B1CCWou4q0Sn+Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qtv5NE3Z0lBT59Cn86MfXJ0Bo1a/X6Q1r3Q53DL363EcJWxMIX0fWzA0w/dOtIk/sHvZXnlDMdYilXrrsyS4iEZKE8JVUYODB4LQVGegS2u8nue2lN+lupWW3u7I1FILkuZHPResybPk479V/RUbEWXRW41vLSiZuyyiYdNzZxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GIbXuR9J; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GIbXuR9J"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-78ea15d3489so30425696d6.3
        for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 10:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758389631; x=1758994431; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vTxrZ6RUVsJ9ZObmKgt0fNbpsdhV3OAVQk54/OZ4DRg=;
        b=GIbXuR9JO7zNRNttqqigPsOmLzXryMOlUhMw4ZPn/R9nPa/pF1JV9SGymgl2U2X5If
         LzUa6ij3gtJtYhG1DW75/bB/6yYjF3/FXvUbcHRkUvvZC8n+q0tD9qcvhiM6mxLNVzKs
         SlqRej34bYU2ih/Kbg1fqiRdeth+UF8E3uzjFqgS4OMjFoKetsTV3UPhJtVMaAa2w360
         wncTXyzj8U0aZ3Wn9GspCG/HQIDUwZzrxBb+8awLOLgEFu3Oxu66QVp5HWEcRF+M5AhR
         8AA+uMrJpV8ZLjU9PUbjbnYIyjJn0mDkq5rph/T/T8PxGUdAqDj/mAe0wXJRphE+HtlT
         +I0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758389631; x=1758994431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vTxrZ6RUVsJ9ZObmKgt0fNbpsdhV3OAVQk54/OZ4DRg=;
        b=K+t0Y1jf9ZMXEDRSx1c3fcHPhYdWJ1GQ/5Qz9Jz4ruJ+0KmvxHHir6vbzjLIM7VdW9
         uTf4wFWU7bZJlF+38T46r+F7C1hsgYzGqhW3AEzwo3qckYS4lI+IoYRwmhv+vPVRBD32
         whs2QQEiykVJjtmksIbSh1x0yvEXSMmOpbAh16t+Vempaf0LM+HCUZhhIFL/7qhAuFuh
         2O0zWCXyd8Y0IjUowPaE6+KurZpyLVOy+wa2use+KARF0Wry+cF07irMsygmCHSaOQRs
         s0hRHXj5Nw5z07hwr56zDDoP8Vo1FHYAQUnBA4BpEy9cKmvcCejuZ2uJXgOPt+l19r9E
         rIsA==
X-Forwarded-Encrypted: i=1; AJvYcCWjvAv5tyW1kvR1PocM9uyQyqfDWIeEIeuBitYYPSTfvBea91xN5XAfjyHHnXt9hCNDrM3m5YXMfZ9q@vger.kernel.org
X-Gm-Message-State: AOJu0YxV8wh8p8CQbnggG9pdNb+17Ws3IfBytmWbCtUHJj7hPxsbvoUw
	/73jYETXfm8IOHr9R2d5Pp1bo4TlgzHYR86/nHcCg92PT2QqwUf4PjBv33pioael5W09goGDpsR
	1j6FTCWDvuQrfELoRuCflhXP92HhQDow=
X-Gm-Gg: ASbGncu7UxL0T8R9o6oZFhFqnDl9kmTPtVxvGeITaqQ4+W+Txnznf0+c/rRBR6aMmZL
	1n8irpF2fXhSsNbkkH/zGsW8LTkLKh69ePok6pLEuW/8Od4Gz8LJkw1eNWqBX/zLmMP+c1dPsYP
	7wJRzjRVM+uQKYzBJqFpt9Cbp3cvuFmjNu5CC2yIuDdwjb6bfE99URkfb57u8pysl+DSEH9on8c
	/N2LhYQW6W0g7uVuBMSnZiZXsOwW44ImfmKsFxNlUjno9Bau4LD3K0SvAoBrzODPZQfrHyJ8UmL
	5wzcfIkvy6jPtJPulkIwhdbA7kFSPK0s+B7gVDDlVKXqCBJ4ubk9V5/lMrjvL01icsHa+UHsa46
	ZxFzcrrZt5ahfi21oHIF3
X-Google-Smtp-Source: AGHT+IGw0LN8Ye25fHIKSO16jQgLUq+l9DfzB0UQcy3MWlSIptMJfl7DU8+o/Q07Xmrj3YBqBcF25mpIDZ+3LpHIkfw=
X-Received: by 2002:a05:6214:c68:b0:781:d761:5468 with SMTP id
 6a1803df08f44-7991a7430bdmr96518186d6.39.1758389631456; Sat, 20 Sep 2025
 10:33:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250831123602.14037-1-pali@kernel.org> <20250831123602.14037-28-pali@kernel.org>
In-Reply-To: <20250831123602.14037-28-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 20 Sep 2025 12:33:39 -0500
X-Gm-Features: AS18NWBiX16bf_9o6AX1NyV10rRA9QvcHW1qyR6ISSA8C6LIPXhf4HwqmXS4XCQ
Message-ID: <CAH2r5mtvP34-Da12BNjgjpQ9pNjrEfXc3HPGgrsZBowPwdW0zw@mail.gmail.com>
Subject: Re: [PATCH 27/35] cifs: Move SMB1 usage of CIFSPOSIXDelFile() from
 inode.c to cifssmb.c
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	ronnie sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This did not apply to current mainline

On Sun, Aug 31, 2025 at 7:37=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> Special case of unlinking file via SMB1 UNIX extension is currently in th=
e
> dialect agnostic function cifs_unlink() and hidden under the #ifdef
> CONFIG_CIFS_ALLOW_INSECURE_LEGACY.
>
> Cleanup the code and move this functionality into the SMB1 ->unlink()
> callback, which removes one #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
> code block from inode.c
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/cifssmb.c | 12 ++++++++++++
>  fs/smb/client/inode.c   | 20 +++-----------------
>  2 files changed, 15 insertions(+), 17 deletions(-)
>
> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> index c09713ebdc7c..3a0452479a69 100644
> --- a/fs/smb/client/cifssmb.c
> +++ b/fs/smb/client/cifssmb.c
> @@ -768,6 +768,18 @@ CIFSSMBDelFile(const unsigned int xid, struct cifs_t=
con *tcon, const char *name,
>         int name_len;
>         int remap =3D cifs_remap(cifs_sb);
>
> +       /* If UNIX extensions are available then use UNIX UNLINK call. */
> +       if (cap_unix(tcon->ses) &&
> +           (le64_to_cpu(tcon->fsUnixInfo.Capability) & CIFS_UNIX_POSIX_P=
ATH_OPS_CAP)) {
> +               rc =3D CIFSPOSIXDelFile(xid, tcon, name,
> +                                     SMB_POSIX_UNLINK_FILE_TARGET,
> +                                     cifs_sb->local_nls,
> +                                     cifs_remap(cifs_sb));
> +               cifs_dbg(FYI, "posix del rc %d\n", rc);
> +               if (rc =3D=3D 0 || rc =3D=3D -ENOENT)
> +                       return rc;
> +       }
> +
>  DelFileRetry:
>         rc =3D smb_init(SMB_COM_DELETE, 1, tcon, (void **) &pSMB,
>                       (void **) &pSMBr);
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index c3f101d10488..545964cac9cd 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -1947,27 +1947,13 @@ int cifs_unlink(struct inode *dir, struct dentry =
*dentry)
>
>         netfs_wait_for_outstanding_io(inode);
>         cifs_close_deferred_file_under_dentry(tcon, full_path);
> -#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
> -       if (cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
> -                               le64_to_cpu(tcon->fsUnixInfo.Capability))=
) {
> -               rc =3D CIFSPOSIXDelFile(xid, tcon, full_path,
> -                       SMB_POSIX_UNLINK_FILE_TARGET, cifs_sb->local_nls,
> -                       cifs_remap(cifs_sb));
> -               cifs_dbg(FYI, "posix del rc %d\n", rc);
> -               if ((rc =3D=3D 0) || (rc =3D=3D -ENOENT))
> -                       goto psx_del_no_retry;
> -       }
> -#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
>
>  retry_std_delete:
> -       if (!server->ops->unlink) {
> +       if (!server->ops->unlink)
>                 rc =3D -ENOSYS;
> -               goto psx_del_no_retry;
> -       }
> -
> -       rc =3D server->ops->unlink(xid, tcon, full_path, cifs_sb, dentry)=
;
> +       else
> +               rc =3D server->ops->unlink(xid, tcon, full_path, cifs_sb,=
 dentry);
>
> -psx_del_no_retry:
>         if (!rc) {
>                 if (inode) {
>                         cifs_mark_open_handles_for_deleted_file(inode, fu=
ll_path);
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
