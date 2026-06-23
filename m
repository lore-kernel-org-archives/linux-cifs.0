Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB1A38A706
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 22:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782252332; cv=pass; b=u+p9cFCm+IPpVnVsfCOkbOdIuvebv9d2JQuBPEfkSD4xYXgltJDsL5r6psMvKD1I+712ylvHOk1ZA0+Tqu4QWMpPSD3HaFKKu1Th+6r74x0NsRUce/uP2Vy/id0iCnNQyXIn+xYq23+cmgGj73e/qi1o9UtN9N/Vg259WLhJqc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782252332; c=relaxed/simple;
	bh=IXx1fu5GBgKGIpMJu/3rp88LFVfF5jO0VEc/3kOyFY4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sXHSdR6g6uxd3n8YDfsXg/nyRJVowjBCYjRmIdIYethDjX+YV74Nc9FzLX9+8GJ0Lv9cVHP4MObydSZSdCABWgUTn7pDHOurna+55BTaBijfiCSFx16Eds04nlsCEPGg5uuznY7PjvBxqftPwUWJSVQ+p9mwJTiFYXVfkPEt1/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SYFSZexs; arc=pass smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SYFSZexs"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-727fad2be54so141282137.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 15:05:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782252330; cv=none;
        d=google.com; s=arc-20240605;
        b=NmGnQLxFger4D314zVoH2IOKj4AjH2bbcECtWdupkgdb9jnHLqRdPxDaxl36Vyy8ZF
         PNuBRWGCDb+hpWeCjQb2aBX8njSNylgu/+e/Gzlq36PHdQee6gZQSvhczXr4AQYa+Kwn
         XLR3f2FszkXtOP/Ic3CerquLhs7Xu9mL7zHNryOg64zVWVcLzx4IbDWf7mgEX13LBGGJ
         9CjEnbtp93fd+gHnGgBB7A74Df0MuraAZ+jOfNCdRYHSO96g4HGEJXXb++Irkr83ODdV
         Nn+nMch7EJ+lNrELHcCAzLinJA9ZnRTRSwYcwNFmXeM1PCo+4aOd9LwO8zjhIoaY1rx1
         1pSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=22GH4Y1N75vl5DFCcBY4iJaoKZ/t6keFSyFkFll6qIQ=;
        fh=Xam56eq/xWWpEliQgJWk5Yu4gyQjm4I5OMVwKartUPY=;
        b=Vi/mqYw4E5U0H+TzejvMqL4l9dVaqdsFvbu71LLnywPUrGwLogY5hyIrdySrF3pfLL
         0pq/fS121hPyI92d9sJJLEbztTigHHs9PRekq+249+dIGOwkLIgHp/Cwf3Fe1cXNBtxD
         t1RJ3WXpNjtAm3xpp1UoSen8A38fKg56Gz8zO6eYYJXUIxXfO8T5J3I7U3TFBBSzrg2y
         JFgXUb14Rr7yAzi1NoImMcJQEvCIcIhbs25JD558Q1pf5CK/0dPS6nERqKwYzEva4C35
         ld5auabt1yeJcQfrW051mCOj1uRhPycA2ETCjsvyxlZa0dfebXi2sqLwoCjq9gObVeRv
         xQsA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782252330; x=1782857130; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=22GH4Y1N75vl5DFCcBY4iJaoKZ/t6keFSyFkFll6qIQ=;
        b=SYFSZexsw5qznzLbyH9jiv2tH1c5YOxfN9QsimFQ0yfICypQjilDyQRabb3VHc5Kaq
         A2qHc3w3XMBFG2gIVMXLHGJeJUFDwQe/cXJYXscXrciQ0nzsUxwhKN2h5Kpq7MuZ2CZS
         HrJt3QsIxBWiKHAu7weBEfCtJjFG1sLH28RHYlgmn0fleIaOdAjMCfau4BGAp6iUCpZh
         /Vdw5dC9FecrG4hHVNNevEOYhz0f4rOOfkLt30RPTY6bRGT4/MmiPNp5Aik2tBO5qbKH
         G/50/D2EWqh1xwFJsbS/icAah/EoljzdvyC4H78/JRBrYGpMh2ESRjd0aXNOWGjTxuXZ
         NVFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782252330; x=1782857130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=22GH4Y1N75vl5DFCcBY4iJaoKZ/t6keFSyFkFll6qIQ=;
        b=D7dGdIVCm/0Mk9izd8qHkyYOEewY4oo1seMXp6bRqFuRNydAFvZBuyD99BJWWpZGwr
         qJshLBIiaSyqnmsCLpXa8We9RI66/12aF7sQWRj+zkmen4dElQLNJ0uotTeQ9kpBz3JD
         8z5iOf0cqaW3jxguR2xUkCvxtevZ50O3qTZOmWPtrwfUgzuqSthGgb7wOMH7SgEsA12l
         G8PqT+C6UamOLgdLUbaT1DQjZu9DJUodvpM10loNj66Lq2QR1eN8bsEZs/CaNhUL6bDk
         oKfYilHlP9qj1wsIvN5Q2KIturCOHRn115GN9ltNEwpmDDbGGoYuv/U+x+bIdFQ1bweG
         9xzw==
X-Forwarded-Encrypted: i=1; AFNElJ+h68w+Rn9e0NT7Y8zosbn+ICo44bil2OLxeV0hZDMs5A8O++OYnDxcYQsmZjQWWFQOp7JEENMEJA31@vger.kernel.org
X-Gm-Message-State: AOJu0YyLahpgdq1PRJf+UVG+Grc4MSq12TDnq3FcTn6VFMiYwjzzR/jE
	WuE6JdijyR0HcR0oFAIQ2vNWSlcQmfM/EujEbAA9XO+jB1Z8kZvC2fDgbP7eIGCCXjzY/01Akvq
	OjhyHt4PV0vHW8E+JxlAbvujEzDYJaEE=
X-Gm-Gg: AfdE7cml4+Un4x2sfFG6o7MCKsb+HEnDg29DIMJjzXwUld7y/ei7GwknU3mFcQV9A6g
	xlFD9PnyHm9Ht27XOG6CpC/vvN5zsWKRg37vRhJAJpoyezuyuTNpayafLtD2YtKQsGGD/UDsqsO
	fJOABFCkB8QoVHt1kUwqRLuX0cZnvcAyMUPoYciza5jMcFvt8TAs3nw6/TygsFb5CQRdLvYg7Mi
	zt8s1Tsp9IR3W+jkm69tGFTq7TopXJs8H52CMaWU9TopU9hat1a06ALRRgBmqC0wShXbkDZiixN
	QDLwsEjLipGSI0m/OKm44Tz92nnx3wjwgsTby/GSK4E+2BIXgL+OSQ9no/2D1mAk3nBU90zbn9d
	B/nIuIcSw4wbFuOpfldGSw3mHljVRQ/Vf4j6nPI7P+b5Q8fXF5iBnyyzwfxpxpVjxiy7oR0kY3s
	lwmZL2YykS8Po=
X-Received: by 2002:a05:6102:32d4:b0:650:aa33:5dd7 with SMTP id
 ada2fe7eead31-73112fb950fmr333903137.2.1782252330279; Tue, 23 Jun 2026
 15:05:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ajEi4CyvM6bcl3bp@a2f8b33cc4be>
In-Reply-To: <ajEi4CyvM6bcl3bp@a2f8b33cc4be>
From: Steve French <smfrench@gmail.com>
Date: Tue, 23 Jun 2026 17:05:18 -0500
X-Gm-Features: AVVi8Ceh-Qi6Y1VwbFhZNH8zBuMz67irJA5R1rCM9_76BRUN_aotwOCfgmdsfbE
Message-ID: <CAH2r5mt_7kwggEaE-WZyNwbFfBxGNtWopeWb6mJirSKjCwWQoQ@mail.gmail.com>
Subject: Re: [PATCH cifs-utils] mount.cifs: fix const correctness in parse_options
To: Rudi Heitbaum <rudi@heitbaum.com>
Cc: samba-technical@lists.samba.org, linux-cifs@vger.kernel.org, 
	pshilovsky@samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-utils and smb3-utils for-next

On Tue, Jun 16, 2026 at 5:33=E2=80=AFAM Rudi Heitbaum <rudi@heitbaum.com> w=
rote:
>
> parse_options() modifies the string it receives in-place, temporarily
> null-terminating keyword and value boundaries. The const qualifier on
> the data parameter was wrong; remove it so the compiler can verify
> the pointer assignments are valid.
>
> Signed-off-by: Rudi Heitbaum <rudi@heitbaum.com>
> ---
>  mount.cifs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 836a060..b57c7d3 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -834,7 +834,7 @@ static int parse_opt_token(const char *token)
>  }
>
>  static int
> -parse_options(const char *data, struct parsed_mount_info *parsed_info)
> +parse_options(char *data, struct parsed_mount_info *parsed_info)
>  {
>         char *value =3D NULL;
>         char *equals =3D NULL;
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
