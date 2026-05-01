Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB52B189F43
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 00:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777596476; cv=pass; b=PaSvpO1dUgOR5/np2m1gyY+D5sfd64Ps0/enJ7ejmO+QSh63xWGf9WY0Ju2cFx/Zobn9yMU26EXCtW4PNHDqI4COHXi5aUFVJNOu3xZGRWrkEm6foE6N0efc5DpfKd5FvBkb6xMvo5xeR/VDgr0ufeueQNNnHZR+pX3EsWPvGFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777596476; c=relaxed/simple;
	bh=1dWIZJHlZdtZyn8FhsP1PzWEjeD9W5TWYymkhsSY1H4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=apE72pcbUnGfLxjYr3dBvDa2pOuPbgiLlGVZJidzecXhlcMU8sw6dh3CtOn3KHm4sQlEwCeCZ2ZxeJZiIUyuBiAgsECF5qS1YdJHmCtrepa20CHU4HGVal/PuS1SlAdO7iN7xS8s3SnE4H3M/hJj1CvKPiCZ5ifCzJZd9lByCVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IynExUOV; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IynExUOV"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ba67b332bbaso227945666b.0
        for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 17:47:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777596473; cv=none;
        d=google.com; s=arc-20240605;
        b=ZFj+R439zoIiJmQAmoKhBOIMbY1VouiRXW+F7xpu0FtD92UDCNvtoTNgR4OoDFgjiM
         paZ1F3zOschG7MGEDCXA3a12BoLgSZusf9k0CW2EQdfbUoEh83sHfzEpfXXy4ezCW5mp
         Bvi/NH+Nxra9iZ7PJysrnRfyUSXIbGdpeO/ikdqCgbERhbHyP5akzJmN0+cqlTezX97o
         /H4xfAeEU9k3MKCidgE5cDTz/SEmPb8NufPdDVenaXvkb4n/24i6mR6seUgOpN6bhsqx
         UBq3lDp3TcsweAzp+QSmaZ73MyrHgWQYbwhiHy0tQivUgl+W8XIolfVAIPTyi+JyxH6F
         2Zuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gA5MU8H/VP+EpMiZU/F1urYiAlH9oeYefDlgYKqvLm0=;
        fh=v1++Ia+fP5Cgt4iH6/T3wvsl5IZTsVbAm6oNSl5bGX0=;
        b=H1oZ9cYw1Qkm77clk2c/mUEEcxkPIzkmcM5LHVvzPAB2YEfAmwRtazea2RUCS8DyId
         /WKqsV6wK00lgLB5dVj4azLFMUtaCekFJGU25owtnpgmoiq78eOUlTeck7fM3tdb27bg
         RCj48Y7+REIdtEpdTn9AVEJvDKGSX73rkvKIkAO2bcjbEEUIBDjSOIldIXOrBGWv4Q8Q
         yio2Dq9o+5XdBnqJY67X7aD6Ks7geFZ/V+oi2gUjIld4gr+WX+hqIrG68P8bPX6GvtWm
         ci2J3OPDCKpGTgYmFx0UC+M/wTdJ92S+avD4h53hb6dI2LIKh8g2s+onVyduUXdDBXV4
         IjsA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777596473; x=1778201273; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gA5MU8H/VP+EpMiZU/F1urYiAlH9oeYefDlgYKqvLm0=;
        b=IynExUOVHgJrvzfElvJ42+PfA1Mq74d8cC1wQwaFVnkR8WohSq4O6m2wGBncr55hap
         OxFeK1YaRiE12TfB34Q7O43yTNnK0rTMlfOsYWEteuYWvJFYho+uI50/eIkBFjAxPtAd
         po0h2+JCj+yZTZsDQisLhNg4/nKsHD4Pb2ZAWhKd9wJ4Q9wIiJpUmpVL8R1yhx6Ks9/+
         5Jp7mohtJIRIpntbuN2L1fqpO9qTwfnyvz4cjSxm4xOY0+mawhLoAbuYeifyjO/ke/08
         Xobb+OGzyelOtfeQ5/SQquMhNsEH2IYVHK9heJqBAJqcMt4n/flmkXBTxD5cdSnhiHtD
         67ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777596473; x=1778201273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gA5MU8H/VP+EpMiZU/F1urYiAlH9oeYefDlgYKqvLm0=;
        b=OTRl6gW92z8Ffg1Ijlc0j5umluisZjq7ridjibwrkt7svopXsDcvvRLNYYjiCofDs0
         0rVXIK0JptwnkgnTJlWXDqFpcYH0BCGQJbvgdMkKCq6quloydBYYHbDsTrribjrO22o7
         yEwj7QgZLKmrrgEAwgLNXo8/9PFHnf8fJXI16Re0JSTpIa69tch+s95JWE4unGeyrU9f
         2E6gUsyVK863RzIB0U+aATzjOIgC74L7fANE7dnp37d/WOr60v92HSfBjEDxGvGjoHFx
         80UNoujQtooQDMDI26ZB0IoEsLBiRkAQgXG7EHHxYVVtu5RwXyQBdOHY2rucfsbBQ3Bt
         7EDw==
X-Gm-Message-State: AOJu0Yyt1SEQCHlMyCIUW/qxkB//47ALGFhsrVcjq9y9cOhiZG0/mqGB
	wBuXC7RwaLcx4aF+WUWOC2razP1wItg38zqcs/j5mFL6U24TbRrTmdxjBMwae9T2jgK/1dkCO8V
	28HVriJwy9GxKK4eN2cI6q4As90Idl++TAvXwGa0=
X-Gm-Gg: AeBDieuqNpOVFMThVzTuc12YB2AJDBHJzpE7YFKAFpMPURUsbq+FZ/YMCNBsCbPImio
	zdYul5j+5J3f289gRSIbEoi3d1Pk5BBP4TdCJBqUUbSRdmtX1iWvwx5d5Ah1HSlzZPkawP4T+AE
	w+g1M90Q9FnSefGjo1LmPHCibkt3qDPnWXg/QCiYBkZ5ndC0te9TyCet8e5kcV+kt/C53SxQeH6
	yvvITlAqlD3M7g0INfmTOQ+b28U5xTf5CmkJsKdIz6tcZ1H6YRh2QhptGS1z7n3SeLKytwgcjga
	8BV+Z8zLNzG6SeWmgBE7FqEDUoWNE+G784m8rfYukrRKIDAgFL3QYJk0J0em1dhB8Lht82ZQOFW
	25VKAw81f8bd3Wsh8LdywWJHJj4Z/mEQfiqmqbgZPUToGh3xnd2oNZQpfNC2Eu0jtgDyT
X-Received: by 2002:a17:907:6d11:b0:b9d:4301:be37 with SMTP id
 a640c23a62f3a-bbac5abfa9emr340991966b.5.1777596472435; Thu, 30 Apr 2026
 17:47:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260430220601.76266-1-rosenp@gmail.com>
In-Reply-To: <20260430220601.76266-1-rosenp@gmail.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Thu, 30 Apr 2026 17:47:41 -0700
X-Gm-Features: AVHnY4I2reyX5j1UdJFbNiB8-56Esqx6Xgl89-hTzZbod2ktSGTZB1nv_bGU_Ow
Message-ID: <CAKxU2N91aPUvWp20RUdad0P3VTLnX_Sby2RvHJ4Fq1y_4P77YQ@mail.gmail.com>
Subject: Re: [PATCH] cifssmb: use struct_offset in memcpy calculations
To: linux-cifs@vger.kernel.org
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	"moderated list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)" <samba-technical@lists.samba.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 30, 2026 at 3:06=E2=80=AFPM Rosen Penev <rosenp@gmail.com> wrot=
e:
>
> It seems W=3D1/FORTIFY_SOURCE is getting confused about the math here.
>
> Use struct_offset to point FORTIFY_SOURCE to the correct place.
>
> Remove response_data variables and directly apply to memcpy. Simpler
> and avoids excess casting.
>
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  fs/smb/client/cifssmb.c | 40 +++++++++++++---------------------------
>  1 file changed, 13 insertions(+), 27 deletions(-)
>
> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> index 3990a9012264..8598cec5ebbd 100644
> --- a/fs/smb/client/cifssmb.c
> +++ b/fs/smb/client/cifssmb.c
> @@ -4090,9 +4090,9 @@ CIFSSMBQFileInfo(const unsigned int xid, struct cif=
s_tcon *tcon,
>                                       get_bcc(&pSMBr->hdr), 40);
>                 else if (pFindData) {
>                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataO=
ffset);
> -                       memcpy((char *) pFindData,
> -                              (char *) &pSMBr->hdr.Protocol +
> -                              data_offset, sizeof(FILE_ALL_INFO));
> +                       memcpy(pFindData,
> +                              (char *)pSMBr + struct_offset(pSMBr, hdr.P=
rotocol) + data_offset,
> +                              sizeof(FILE_ALL_INFO));
>                 } else
>                     rc =3D -ENOMEM;
>         }
> @@ -4264,9 +4264,8 @@ CIFSSMBUnixQFileInfo(const unsigned int xid, struct=
 cifs_tcon *tcon,
>                                       get_bcc(&pSMBr->hdr), sizeof(FILE_U=
NIX_BASIC_INFO));
>                 } else {
>                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataO=
ffset);
> -                       memcpy((char *) pFindData,
> -                              (char *) &pSMBr->hdr.Protocol +
> -                              data_offset,
> +                       memcpy(pFindData,
> +                              (char *)pSMBr + struct_offset(pSMBr, hdr.P=
rotocol) + data_offset,
On further review, struct_offset might not be needed.

I believe

struct_offset(pSMBr, hdr.Protocol) =3D=3D 0

since Protocol is the first member of hdr and hdr is the first member of pS=
MBr.

Not sure if removal is desired.
>                                sizeof(FILE_UNIX_BASIC_INFO));
>                 }
>         }
> @@ -4349,9 +4348,8 @@ CIFSSMBUnixQPathInfo(const unsigned int xid, struct=
 cifs_tcon *tcon,
>                                       get_bcc(&pSMBr->hdr), sizeof(FILE_U=
NIX_BASIC_INFO));
>                 } else {
>                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataO=
ffset);
> -                       memcpy((char *) pFindData,
> -                              (char *) &pSMBr->hdr.Protocol +
> -                              data_offset,
> +                       memcpy(pFindData,
> +                              (char *)pSMBr + struct_offset(pSMBr, hdr.P=
rotocol) + data_offset,
>                                sizeof(FILE_UNIX_BASIC_INFO));
>                 }
>         }
> @@ -5079,7 +5077,6 @@ CIFSSMBQFSAttributeInfo(const unsigned int xid, str=
uct cifs_tcon *tcon)
>  /* level 0x105  SMB_QUERY_FILE_SYSTEM_INFO */
>         TRANSACTION2_QFSI_REQ *pSMB =3D NULL;
>         TRANSACTION2_QFSI_RSP *pSMBr =3D NULL;
> -       FILE_SYSTEM_ATTRIBUTE_INFO *response_data;
>         unsigned int in_len;
>         int rc =3D 0;
>         int bytes_returned =3D 0;
> @@ -5130,11 +5127,8 @@ CIFSSMBQFSAttributeInfo(const unsigned int xid, st=
ruct cifs_tcon *tcon)
>                                       get_bcc(&pSMBr->hdr), 13);
>                 } else {
>                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataO=
ffset);
> -                       response_data =3D
> -                           (FILE_SYSTEM_ATTRIBUTE_INFO
> -                            *) (((char *) &pSMBr->hdr.Protocol) +
> -                                data_offset);
> -                       memcpy(&tcon->fsAttrInfo, response_data,
> +                       memcpy(&tcon->fsAttrInfo,
> +                              (char *)pSMBr + struct_offset(pSMBr, hdr.P=
rotocol) + data_offset,
>                                sizeof(FILE_SYSTEM_ATTRIBUTE_INFO));
>                 }
>         }
> @@ -5152,7 +5146,6 @@ CIFSSMBQFSDeviceInfo(const unsigned int xid, struct=
 cifs_tcon *tcon)
>  /* level 0x104 SMB_QUERY_FILE_SYSTEM_INFO */
>         TRANSACTION2_QFSI_REQ *pSMB =3D NULL;
>         TRANSACTION2_QFSI_RSP *pSMBr =3D NULL;
> -       FILE_SYSTEM_DEVICE_INFO *response_data;
>         unsigned int in_len;
>         int rc =3D 0;
>         int bytes_returned =3D 0;
> @@ -5205,11 +5198,8 @@ CIFSSMBQFSDeviceInfo(const unsigned int xid, struc=
t cifs_tcon *tcon)
>                                       sizeof(FILE_SYSTEM_DEVICE_INFO));
>                 else {
>                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataO=
ffset);
> -                       response_data =3D
> -                           (FILE_SYSTEM_DEVICE_INFO *)
> -                               (((char *) &pSMBr->hdr.Protocol) +
> -                                data_offset);
> -                       memcpy(&tcon->fsDevInfo, response_data,
> +                       memcpy(&tcon->fsDevInfo,
> +                              (char *)pSMBr + struct_offset(pSMBr, hdr.P=
rotocol) + data_offset,
>                                sizeof(FILE_SYSTEM_DEVICE_INFO));
>                 }
>         }
> @@ -5227,7 +5217,6 @@ CIFSSMBQFSUnixInfo(const unsigned int xid, struct c=
ifs_tcon *tcon)
>  /* level 0x200  SMB_QUERY_CIFS_UNIX_INFO */
>         TRANSACTION2_QFSI_REQ *pSMB =3D NULL;
>         TRANSACTION2_QFSI_RSP *pSMBr =3D NULL;
> -       FILE_SYSTEM_UNIX_INFO *response_data;
>         unsigned int in_len;
>         int rc =3D 0;
>         int bytes_returned =3D 0;
> @@ -5277,11 +5266,8 @@ CIFSSMBQFSUnixInfo(const unsigned int xid, struct =
cifs_tcon *tcon)
>                                       get_bcc(&pSMBr->hdr), 13);
>                 } else {
>                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataO=
ffset);
> -                       response_data =3D
> -                           (FILE_SYSTEM_UNIX_INFO
> -                            *) (((char *) &pSMBr->hdr.Protocol) +
> -                                data_offset);
> -                       memcpy(&tcon->fsUnixInfo, response_data,
> +                       memcpy(&tcon->fsUnixInfo,
> +                              (char *)pSMBr + struct_offset(pSMBr, hdr.P=
rotocol) + data_offset,
>                                sizeof(FILE_SYSTEM_UNIX_INFO));
>                 }
>         }
> --
> 2.54.0
>
