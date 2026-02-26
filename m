Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A185327C0C
	for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 23:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772148380; cv=pass; b=ZsGfzRmUdv7cKXaIfG8OViNabcPgJfirFccoMxGaa8RJaKPD8gImDCWlyfem9b6tyZiEKrp2haQwrVCYXu1o3ciYpzi2pWIRAuSopmVtXaMte4oD9/Y0RlNH80hod9UpSRaASOoI+V4Lp/V8zdXyorPHjg+gy3jzjOb0abTTLAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772148380; c=relaxed/simple;
	bh=JDu/Kyb4YxGW5BExfZZ8xeYP3Lz5ZV7jwP8nEaxcC08=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q6C6sNNeL1WsEAWmxs+nPIYHAw35g/Rl9Gbp2l6/3bDe/0KbucTP1bhd7l0TcPaCd767K2ORXQ+fe1wvvkFujFxkmmh0hlwMMgxD12x25XVbUVzma8QYuvXPHxVvRmWPmmNVEzg1AEURzMpGHNrNERRdkm9/jvWu0MV4VIfd3Sk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XSSp6kJg; arc=pass smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XSSp6kJg"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8cb40277a8bso153573385a.1
        for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 15:26:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772148378; cv=none;
        d=google.com; s=arc-20240605;
        b=YzbJ3rktRXwyNd1H4+a+Qn0u356y10/1I66CS1GyqjCRMUp9jplUlXtDtsIIw4cObY
         UJ7ERBTYXUom4f9DTu7MtKTLE8AdPLePdDM7zBoOVvIz+rm9mPUO564nPlRiQtOqRnaF
         1SlFliE5g6a1pAOor1eVdCNtuJT5xp9dnbZUKDbeO7JpMgfHppNIcmwdzYNg7hXCnCq6
         XykMweMGbGeLVyc1lKk8AXrHy6Khon6VWXh1GHG7046J+Bhu/t7yO7Nliu4ZxGI+NVr1
         mpxI86g9mZ3mbrC4g8GtEYbk8U8GcY+ubr8Er2qShBshnXNYmXlQ+4+7nGOWcTW6lsiA
         j5bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7PtuFHCg2l2I+oo2Ai+DrkNScQvQ59foDxESr26IWTU=;
        fh=DqyrI1ZX7hoYba2odGhYXTPV6kAwFAN38uv0sgu/7WY=;
        b=UtoZna7lGb33eB1PHFGj0bdEa1sM+wGwtFisirGIIr2JkF7MBVIgLXSokw1ov3x2L1
         d6LGSyFkdnilK7/ThjstQmShmMfxF/aoKW5R56GvYSiII6J6rAEdeULDbQRLoLESCgW3
         KTn7ZN2PttJca1dvpNrbSjSfAXV5yeXvQIcaAQd/rqkPWP6ojn4q+zyn5NDUT1YCS2c7
         kHBkWlQW/4VGDxTGdc/ke+pC9hdKSM8XFe5H24K4eR5Yb9pN27WrP7nXDL635M4w1LAn
         ZtrcK6vL69iFUDUEsZ4jH7IoRI2jkYDUTKF4iLHAsueKGgiUfp1L+lzhth0BSidXYp32
         cElA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772148378; x=1772753178; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7PtuFHCg2l2I+oo2Ai+DrkNScQvQ59foDxESr26IWTU=;
        b=XSSp6kJgpNmT135GyrBuTAiP6q0OaMkeVp9MrnCyCTot4uAsgxoWo4kCH6RKvq0IMQ
         PNTzOadXxZzNcy2UWu+RjBmqWzrCQQluQQ3ttB0Rf1jF/pj89RCsAngQ2GNqAE29RUny
         MtK7jp6S2ET1ZztPBuTtgmyyMId1LbKiUsZiiBe4md0AhaYQYNn8GmxlwduYpJNm7kXh
         NvIzmL6+hnVyR6W4yy5IJ1Q9uOsRU2Q7j/5WDPDUkz9K5w+Xd/IedAAD8QssiAUlp0Mk
         WnBLBt5N3dDEXLfPu2ilEAA9l3TZQQhCYHQh+MnNwA7gjVoXbs1a5WRWt6DpleJB0ChS
         NiTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772148378; x=1772753178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7PtuFHCg2l2I+oo2Ai+DrkNScQvQ59foDxESr26IWTU=;
        b=V/Dxyvzzxyn8gpmYMKF3X6JzbhnlFJ1O4rhyuL5VOu4DBJBwBa4LfIpfI1wkgq1C/N
         lid8LKE4dj3zWe8f/W8JTcpqsnGYl42KixWJvZ1A22vFHDjrKGD6FSBd5bKLoGPdvkNl
         37oMtYYaoiBo45GgtTTFO69GJsuodVfddpH8Wknpd12hmSym9oYHEfsyZrchBw01Bvpc
         2nj2dw5f4X6cJinUPRjLUDMh6iK0Vj9/hN3ZVJuEfZkSW9I9jUaBa+7Pz9vYiHN1DkJc
         IoZz98o0wiFMOlDNErSGmGO4+Zm5C4CnoncuCUxmUVcpaECPxuxVnXRBkIjnRuB277qD
         VakQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSDKK6VyTf6odMrSYlSsD6vFqbfcZPjtOB/NtcvExoq3iXXZSAs9jFVXxfVH0c2gkJc/FqusM4tIEN@vger.kernel.org
X-Gm-Message-State: AOJu0YzZrj7gDVtqBy1Eyx4S0GweQz7830sIY0bfc1Crbo+B1LFF1MLV
	YPfOCV0dMC2ORZWCjLqAJUPnKkYkkazWmX5yPC4GSMbHjMtUoRgCW4CNwoHApmTp/AvLGtWEvQb
	q4gqXHUNE4S+/kPJqou6GRFHLtHr2/1YpiA==
X-Gm-Gg: ATEYQzwMLTATW6DHdYofckCZsdlSIXPwenUb6RXmsbRO8BDd0TAU5EDez8vm1mvHXUD
	dsoNkezM0++7avjI+6SxSjKrQHN6ph/DdsJkor+uyPUsj0Lv2AfGNO35X++haYfHLZvpscT5stu
	4HUFnqlS/MJEnfBkEcW9byPI2qM5UcxDOzwXMn5eqWHGyhU6alYJ7+opyh4RfpV28BeKrnfmtat
	wVwtNZjr6LQ2GwYdamiPg0upMrdWKN5kp0ZFj5Vj2UI4qYLXdlz2G8SNsRGtgBu78h5w3T7+mPP
	R+Si1NCNvFqDbgUQbeGefegpS3nm3IgOfzxOWdAbarBXRirThrBqWfCgRdyEoc3tyNVEAxjyOUs
	nPglGfJCvX+wY0Q0Xkw+Z+mkE4wFwv+O0jx2H36EcJodToWR00nM7lYxj5yY=
X-Received: by 2002:a05:620a:4453:b0:8c6:d2ca:1d0e with SMTP id
 af79cd13be357-8cbc8dc2700mr108970585a.11.1772148378019; Thu, 26 Feb 2026
 15:26:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226221522.796394-2-thorsten.blum@linux.dev>
In-Reply-To: <20260226221522.796394-2-thorsten.blum@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Thu, 26 Feb 2026 17:26:04 -0600
X-Gm-Features: AaiRm51MAa8Zd1sxya9KBTtt_XAEO_wNhoDMOSAwJGwzn146wZuT4_Tm3LMNloE
Message-ID: <CAH2r5mu+Wb6UJrZ8g3iyDkSTZFVjWRbwpwYaAoMaHvoQKjiHVw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Use snprintf in cifs_set_cifscreds
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional review and testing

On Thu, Feb 26, 2026 at 4:16=E2=80=AFPM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> Replace unbounded sprintf() calls with the safer snprintf(). Avoid using
> magic numbers and use strlen() to calculate the key descriptor buffer
> size. Save the size in a local variable and reuse it for the bounded
> snprintf() calls. Remove CIFSCREDS_DESC_SIZE.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  fs/smb/client/connect.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 33dfe116ca52..a055496c4835 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -2167,9 +2167,6 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
>
>  #ifdef CONFIG_KEYS
>
> -/* strlen("cifs:a:") + CIFS_MAX_DOMAINNAME_LEN + 1 */
> -#define CIFSCREDS_DESC_SIZE (7 + CIFS_MAX_DOMAINNAME_LEN + 1)
> -
>  /* Populate username and pw fields from keyring if possible */
>  static int
>  cifs_set_cifscreds(struct smb3_fs_context *ctx, struct cifs_ses *ses)
> @@ -2177,6 +2174,7 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, str=
uct cifs_ses *ses)
>         int rc =3D 0;
>         int is_domain =3D 0;
>         const char *delim, *payload;
> +       size_t desc_sz;
>         char *desc;
>         ssize_t len;
>         struct key *key;
> @@ -2185,7 +2183,9 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, str=
uct cifs_ses *ses)
>         struct sockaddr_in6 *sa6;
>         const struct user_key_payload *upayload;
>
> -       desc =3D kmalloc(CIFSCREDS_DESC_SIZE, GFP_KERNEL);
> +       /* "cifs:a:" and "cifs:d:" are the same length; +1 for NUL termin=
ator */
> +       desc_sz =3D strlen("cifs:a:") + CIFS_MAX_DOMAINNAME_LEN + 1;
> +       desc =3D kmalloc(desc_sz, GFP_KERNEL);
>         if (!desc)
>                 return -ENOMEM;
>
> @@ -2193,11 +2193,11 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, s=
truct cifs_ses *ses)
>         switch (server->dstaddr.ss_family) {
>         case AF_INET:
>                 sa =3D (struct sockaddr_in *)&server->dstaddr;
> -               sprintf(desc, "cifs:a:%pI4", &sa->sin_addr.s_addr);
> +               snprintf(desc, desc_sz, "cifs:a:%pI4", &sa->sin_addr.s_ad=
dr);
>                 break;
>         case AF_INET6:
>                 sa6 =3D (struct sockaddr_in6 *)&server->dstaddr;
> -               sprintf(desc, "cifs:a:%pI6c", &sa6->sin6_addr.s6_addr);
> +               snprintf(desc, desc_sz, "cifs:a:%pI6c", &sa6->sin6_addr.s=
6_addr);
>                 break;
>         default:
>                 cifs_dbg(FYI, "Bad ss_family (%hu)\n",
> @@ -2216,7 +2216,7 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, str=
uct cifs_ses *ses)
>                 }
>
>                 /* didn't work, try to find a domain key */
> -               sprintf(desc, "cifs:d:%s", ses->domainName);
> +               snprintf(desc, desc_sz, "cifs:d:%s", ses->domainName);
>                 cifs_dbg(FYI, "%s: desc=3D%s\n", __func__, desc);
>                 key =3D request_key(&key_type_logon, desc, "");
>                 if (IS_ERR(key)) {
> --
> Thorsten Blum <thorsten.blum@linux.dev>
> GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4
>
>


--=20
Thanks,

Steve
