Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8F53D300D
	for <linux-cifs@vger.kernel.org>; Wed, 29 Jul 2026 21:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785360181; cv=pass; b=ebQHQ9dPzJyZeFWqgFw6rGbf/RQI2q4C19j/i4pAzzbcN7rGUG/ETJdDHJa6kMMLYYqY0nAiH1aMe2U6Ni/Cvb8nPNUPK+tQvNX3e2b8mT6BRJO3MwGyxZsC7w/pA0wIZcdlJMiPlECaDQoWCtDvFKQf/QnR0TT88iSsQtK1QaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785360181; c=relaxed/simple;
	bh=FKoT5fRMoIzU6f3LxiiYQEFGF9XquK8YtQxDz89bu6I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lk/qnUO4JT1aUdpxUKQRL3d58QlhkX8lFQb4oLTmsSwjf910xgWkLlIJa7NnqwvBXixmWBAiGC9alsGajUXXS0H/koks8YUeW01DmtlW0Rn5UOgOw4uIV/V7uLkUp5QOaBfNSFxrRWaxIK8gaSk2pJRUxE4Y6u/lnvwhc/Y5vAs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MbJcBC3z; arc=pass smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MbJcBC3z"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-930f618435cso96025485a.3
        for <linux-cifs@vger.kernel.org>; Wed, 29 Jul 2026 14:23:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785360179; cv=none;
        d=google.com; s=arc-20260327;
        b=n4GA6PQLw0yuMi5lHws8t634CSaKL7VB8C4yEniDy6YdWWAKyYhVPNVRSuUdpRKLCv
         WQEVrIDgMAtp38K3qCWp1hwoXs0ZTg2aCujezVrLz3FiPlZcHwYqvBM86x8F9db0/wdZ
         fvzOh1v4G9YS3bamosvgbVlpOofsYzn5U706+lXO7j3PwqVWg6gRktecyT0FVnLzQByT
         6QEReLoWELLZKRgsIpZaKbEh13JdG27owgbF/4jiTNf6QKuboQE3X0MPLNMS7/Adn6Zj
         BNxu2UMEf7uBJQxexj1TKCs2ikaMIrAcz9u8qgfHh2eNkoBacwqB/IGmDGYuvVqDFSLw
         j0cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PzclaCE/+wYYqCM6v9vtlttUAcwpu9iPt9kubHlhCrk=;
        fh=37NnBPGSyTvNp8cDOmETmqBa2Prs6F1b5I4bzvv/wHY=;
        b=p7KbstsFycJGdK1dGYRP6Yhq6VoyoQ3bG+Bhzy1UFCGj9sn6f9CwishrTwzOZ2VQg6
         Yi6rGV9RxkvptdnS5dSyazwYEJczl2rTGEK1vn+2zj1epk+9tiwpcSRkoOuvSmPZWWx0
         DpeVk/yYTo8ij/Axq1HFbw8+dLifp8su09TPB1e5dTsZYC1YyM3CWo/S7qYN55uclGhC
         vzKS0aWmQBd/H/n8Zus5eeZDtXzPpsA4+ErypSsC0hyn4E6ZjpaKlYj4NaPLBOOEkxVO
         X5KAQTRTggDqqMYBqLAHb4k1ZM//QIPZRZYrzntyATG0fBArSUvrTE3GZcIFXzNKpoSL
         I5YA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785360179; x=1785964979; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PzclaCE/+wYYqCM6v9vtlttUAcwpu9iPt9kubHlhCrk=;
        b=MbJcBC3zFMp/O6BIaFLMry9IoAD/hEAVQdWb2b/zEGQEVvX6rNyj6AfJQlDIbPQmZ1
         tgvTQT7b7V/F/6spmgLabyPZ7IG0ThcT5hLB7ELcS7L5TnOxFgnmr8lA4Vgxl1FYvwlm
         OlorGLAeKzdMFjKkSXKRH0vK0ZKRmjrraMZQw+VG5pXZNrB6fTMBlmX9vXQDR+3eP4xL
         DO1XAZfmkHYAwL4iisDUFkvnxknJm1L1IwzluULNRL5+vbrBnIzyFfeXyPXze9VQIaDh
         XCV/Ea9Omfzp/W7wdieTYWDNKPKZa7OR9e/rE73Kdwlah6jZE2ja4qH7W3lPAlvYoK9x
         rXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785360179; x=1785964979;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PzclaCE/+wYYqCM6v9vtlttUAcwpu9iPt9kubHlhCrk=;
        b=PBUTlpA7SKgulq76+ibWwCrthDeOBPZhmoCLbRuXluAGiJu4vUcLOXbXgmJGyorlbX
         9SHXnV4lOTq6BF8j2VRwCMHMusB6O5mtiMdIR4V8ViYakqHXhEdIBL7wnDs8t8Od5Jhh
         0TEjG/DnSHs5Kn//Fbv29sx18I12quOQRo96MqtzNbtNAyYkNUkk/E5N4KYgmlqZHpkJ
         mBorQMd7E6LmLnshjvYPaTGkEg8KN4gKa//5oc5n0/OsZzZ7ZSiaxkELG33H+lVleQyS
         /L0ljbhxmZYhciExP3HNmDkAJ0FR0kaWNscpjw9beLZurK8+2SEvmP+MhBRkLYHTTqHt
         Ys9Q==
X-Forwarded-Encrypted: i=1; AHgh+RpW2cnzDv6ASgvIVMEOuqYtRBC9J+3c8mwf20AoilA7AJaDpjdPpHGhvVAt7uULsjtNh5J7pPGOqpNv@vger.kernel.org
X-Gm-Message-State: AOJu0YwyZON+YZMHFAn3rYj3vuISA1JIkVLdNB7ODphxLClHZ2odW2ho
	QC14DwtomeSO6C3I2tBG/vcS1YSLk5spb8NougksbEsTSozQBSredDj7HRM3qquKJuMmM7QaHy4
	5S+tukUNFXZ6WvX6JCLFFsPJ9QFt3HD8=
X-Gm-Gg: AR+sD1001T0qZxozbdxXu0ybTyLzhHYnmZM11Bs7JjA8s8+GkJvkzie8ZtirJN1k6QF
	Xqyn/vJudpjxxL1P+9FhXPnzKKbMMmtHFHtPjTPgrGTOm2UkFQzp+vx87+34Sj8lGzjaewglS9j
	m3n142Zr+Tkgxljmk+ceOuv38OhZ7UVklCqqHSSOjPkpHu1mI2X4f38TA9YQM2uHQBR2PrUgRrA
	sgZLnlmY7FnEhAG+x4/t2quXAI2qel9WVN2Hc0I0TETLVLDKoJHsq7ZpKXQfmx6ZhLvntMjh4KJ
	sPxKh48YnzaASuK2Gaq6HflQcz5RoP49G+wKnMqDuGU3X2yEjQ4+fKYlh+7e+twY20KPtkbqQ+R
	DptQKWxaJ1znqb9TvAi9JtoHHq/AZyqVPI3COeEfRqItqMSDwBE6+YqtLH+oOI0gWdq/nuMboxc
	wuUK4+yxI34SPz54H70PiXfQ0c
X-Received: by 2002:a05:6214:3216:b0:8fd:6de3:bba8 with SMTP id
 6a1803df08f44-908302bf68amr6846076d6.62.1785360179140; Wed, 29 Jul 2026
 14:22:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260728233532.3022799-1-pc@manguebit.org> <SJ4PPFA6E5D1011B2AB6751329AF683DF0BEECA2@SJ4PPFA6E5D1011.namprd22.prod.outlook.com>
In-Reply-To: <SJ4PPFA6E5D1011B2AB6751329AF683DF0BEECA2@SJ4PPFA6E5D1011.namprd22.prod.outlook.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 29 Jul 2026 16:22:48 -0500
X-Gm-Features: AUfX_mwzyxnytP7QfH-q93RjerKR8wxhuRJJlJ7AaZ0gXsig4SsMP1m_d16IGIw
Message-ID: <CAH2r5msJYGuHmROAcGsPH_u_04zKgovBBzWjhMX-s35x-qwF8w@mail.gmail.com>
Subject: Re: [PATCH] mount.cifs: prevent stolen creds through SUDO_UID
To: "Birtwhistle, Daniel" <daniel.birtwhistle@gehealthcare.com>
Cc: Paulo Alcantara <pc@manguebit.org>, Pavel Shilovsky <piastryyy@gmail.com>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-utils and smb3-utils for-next

On Wed, Jul 29, 2026 at 2:32=E2=80=AFPM Birtwhistle, Daniel
<daniel.birtwhistle@gehealthcare.com> wrote:
>
> Hello Steve and Paulo,
>
> Yes. I applied the exact patch to cifs-utils 7.7 at
> 3a7dc396306654aa225c35767e56ac1fb239922e, built it successfully, and test=
ed the ENOKEY retry decision using matched unpatched and patched setuid bin=
aries.
>
> The results were:
>
> - Unpatched direct setuid invocation (ruid=3D1000, euid=3D0, caller-contr=
olled SUDO_UID=3D4242): the ENOKEY retry added cruid=3D4242.
> - Patched with the same identity and environment: no retry occurred and n=
o cruid option was constructed.
> - Patched root/sudo invocation (ruid=3D0, euid=3D0, SUDO_UID=3D4242): the=
 retry retained cruid=3D4242, preserving the intended sudo behavior.
>
> My conclusion is that the patch closes the demonstrated SUDO_UID-to-cruid=
 credential-selection issue. I am also happy to test the final committed ve=
rsion.
>
> For clarity, this validation is specific to the SUDO_UID issue. The separ=
ate credential-file TOCTOU/privilege-drop case and the remaining Low parse_=
unc hardening item are independent and are not addressed by this change.
>
> Thank you for the quick fix and for including the credit.
>
>
>
> Best Regards,
>
> Daniel Birtwhistle
> Senior Director Product Security & Assessment
>
> ________________________________________
> From: Paulo Alcantara <pc@manguebit.org>
> Sent: Tuesday, July 28, 2026 7:35 PM
> To: Pavel Shilovsky
> Cc: Birtwhistle, Daniel; Paulo Alcantara (Red Hat); Steve French; linux-c=
ifs@vger.kernel.org
> Subject: [PATCH] mount.cifs: prevent stolen creds through SUDO_UID
>
> CAUTION: This email originated from outside of GE HealthCare. Only open l=
inks or attachments if you trust the sender. Report suspicious emails using=
 Outlook=E2=80=99s =E2=80=9CReport=E2=80=9D button.
>
> When mount.cifs is invoked with setuid, a non-root user may set
> SUDO_UID to be used on the retry kerberos authentication path,
> therefore allowing it to mount shares by using credential caches from
> different users in the system.
>
> Fix this by trusting the value of SUDO_UID only when mount.cifs is
> being executed by sudo or root.
>
> Fixes: 1a1507654c5f ("mount.cifs: use SUDO_UID env variable for cruid")
> Reported-by: Daniel Birtwhistle <daniel.birtwhistle@gehealthcare.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: linux-cifs@vger.kernel.org
> ---
>  mount.cifs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mount.cifs.c b/mount.cifs.c
> index b57c7d346f42..f0e9bc7beae2 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -2145,7 +2145,7 @@ int main(int argc, char **argv)
>         int rc =3D 0;
>         int already_uppercased =3D 0;
>         int sloppy =3D 0;
> -       int fallback_sudo_uid =3D 0;
> +       int fallback_sudo_uid =3D geteuid() || getuid();
>         size_t options_size =3D MAX_OPTIONS_LEN;
>         struct parsed_mount_info *parsed_info =3D NULL;
>         struct parsed_mount_info *reinit_parsed_info =3D NULL;
> --
> 2.55.0
>


--=20
Thanks,

Steve
