Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E2A8462
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jan 2024 07:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705994576; cv=none; b=rj1Ou25vfySMDEpcJWu+YwZsbYpdMWlERpNz09K0Kk+ksc+SCnPlEnwFlalvAWwFpauU2dOamwENVmjq3utdkbNBUcnMWIWKwzJKHjThnXBtXnUzllizQFqtU2+R0CEoQ34epY+UNhgmvjqJN0zdQQj6CFOaYhyunTe/cVe/kG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705994576; c=relaxed/simple;
	bh=C4HuiEWgSnF0Nv9Tct+lorXw2VfLgE/QiK3l3SgXoO0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AAmIS8CLG58cyFzR2aqclLE9Qx51N6x1ZdFvSbKpXC5w9rzsHpwYUs4Jv6WtsAxOMZX7bO0p+Y7DEiXafqJR0jQg5E8tNHxpgpccMzFrt323OvgyK3L4DFEWyCgYMza50VogBwEcatD1y/JD0PHEf7UfHH0yutZDZqhvYCmuU5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eDnF/Xb2; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eDnF/Xb2"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-50e7abe4be4so5325668e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 22 Jan 2024 23:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705994573; x=1706599373; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KBcT0dsewyAYpZbz58vnfVDazd23Ph2L9tDu7fBdi4=;
        b=eDnF/Xb2s+5d1qbBXRakdk2U7meX0Dk09lU/GopaI3Ewpw164Vybw1mQkBc/EUWUqK
         dFnfoPFSWahC8I60Qt6eifFP8ebcYLy3FpcvJBLWp+pLbsfj5lyZLROdoCvQEdb0FWKY
         +KjDCqznFdRhJDlLOgRGn2MGK5D81+F0PxnmnRffMrplkHS/wYvUFJuA7J/RWx8yiM7v
         tZQOR3UudTXLy4F2ufyDeG5mhHTFHWaozbzXeHSyBdaoFlnH8AtL4LJBXS7l7FuBBr6l
         gV+gUvWghHG+MXDKZKtaDVNqCFjY/5VjRMORdqE22/OxhCKwiel7639lYWS0DJscfRL+
         q16A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705994573; x=1706599373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7KBcT0dsewyAYpZbz58vnfVDazd23Ph2L9tDu7fBdi4=;
        b=FJZyuyo78zVmpeokdQnW6q0qG7/wK8ejHKfCFvcHKFRBtNhQW2AEH6g1rI8j2MbBLj
         CeFG5RUcxTFBjD6vMFauZYbquKZM/NVLbjjaZWSyNNh6IAh4nPPa/qVrLaz5tF9ECTsy
         /OJHKR5uamS6qj8NPcBC9+RDcnlk0qXH53Hnoczci0Wd1Oe43DWu9dJMyKYO28WZKpS0
         UfyAzjOkyRxFxH/vQpHWHnkodxEEhRrhUYGSsPO0hEpHVw9HVYhnkIAeQadz41fX+828
         K6FXWm9cIM6R+MWmGvC4gdtn9adwjKlXFr07WLN08pxlnXeuZaMCcFwRzEFQBnQF8sMC
         VFHA==
X-Gm-Message-State: AOJu0YwwYovtgyhD3wbT7bSvoBVYN1IrDbTKQsDIvBLI6xfxQ5dz0mxF
	GXKNRxMaQy/gCLezReO3gJ5Blh+/d6ohtkPfTUU8N4SizpzYYVSrZxSBSKwOnpnKIbn9UZvtNB6
	BFcXaq3J7OcN8n49R/ZYPvgpeCnWoauQJ
X-Google-Smtp-Source: AGHT+IGu39wqnkF4weIgjOwLLYQAuAtnzdCgLINIm7u9++ciqAqEAZ7ryzrgg7LloYjT+h9zPdhBaWcNPXcXc8lrAGg=
X-Received: by 2002:ac2:418b:0:b0:50e:7b2c:9013 with SMTP id
 z11-20020ac2418b000000b0050e7b2c9013mr2196469lfh.132.1705994572455; Mon, 22
 Jan 2024 23:22:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121033248.125282-1-sprasad@microsoft.com> <20240121033248.125282-3-sprasad@microsoft.com>
In-Reply-To: <20240121033248.125282-3-sprasad@microsoft.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 23 Jan 2024 12:52:41 +0530
Message-ID: <CANT5p=rn2dd=Wf85Wr9_mikJ5xSrR0O-RwicZbkP5wqwxrrcAQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] cifs: smb2_close_getattr should also update i_size
To: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	bharathsm@microsoft.com, tom@talpey.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 21, 2024 at 9:03=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> SMB2 CLOSE command with SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB
> flag set is already used by the code for SMB3+.
> smb2_close_getattr is the function that uses this to
> update the inode attributes.
>
> However, we were skipping the EndOfFile info that's returned
> by the server. There is a small chance that the file size
> may have been changed in the small window between the client
> sending the close request (thereby giving up lease if it had)
> to the point that the server returns the response.
>
> This change uses the field to update the inode size.
> Also, it is a valid case for a zero AllocationSize to be returned
> by the server for the file. We were discarding such values, thereby
> resulting in stale i_blocks value. Fixed that here too.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/smb2ops.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index d9553c2556a2..e23577584ed6 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -1433,9 +1433,9 @@ smb2_close_getattr(const unsigned int xid, struct c=
ifs_tcon *tcon,
>          * but instead 512 byte (2**9) size is required for
>          * calculating num blocks.
>          */
> -       if (le64_to_cpu(file_inf.AllocationSize) > 4096)
> -               inode->i_blocks =3D
> -                       (512 - 1 + le64_to_cpu(file_inf.AllocationSize)) =
>> 9;
> +       inode->i_blocks =3D (512 - 1 + le64_to_cpu(file_inf.AllocationSiz=
e)) >> 9;
> +
> +       inode->i_size =3D le64_to_cpu(file_inf.EndOfFile);
>
>         /* End of file and Attributes should not have to be updated on cl=
ose */
>         spin_unlock(&inode->i_lock);
> --
> 2.34.1
>
Noticed a couple of things in other places in the code:
1. i_size_write() should be called instead of updating i_size directly.
2. There's a server_eof field that is generally maintained in sync
with i_size. Need to check how that needs to be done here.

I'll submit a v2 of this patch soon.

--=20
Regards,
Shyam
