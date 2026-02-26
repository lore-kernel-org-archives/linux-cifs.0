Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEDE1F4CBB
	for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 01:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772069445; cv=pass; b=NjHiIAGIYgmLDIlbddrxq+CdBf84016RbNMzRes8sONRyUTysmIXPMi41NojualSnbNl25pr9A99cdchn9RgU5BsNaVI7Rz2HIXV05tQ5p/D6oisETl8PRQ2mwEHeYGnZ0Ka5D188f/R+nG9Z1N4c9Boivhb91d7MUxatl3qVxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772069445; c=relaxed/simple;
	bh=qfV8OlMgbGJTMyQkiQstUWAPf4YR/uplqAyH4yK9XGA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sDhw/ru5L/3zaFn9ithpkk7XEn7eiMnvoPKD0UEZX860cBOEhrJjp0AILvYfak3qplx7RTTexCyj+bnrluiQBopf9eUNMcu+1Z6u26IaDuYD0Ivawame8Ine9jm7z8ODnZn3MwjbYiKt1IvHXcb8iRYwEam4lfYcV3Gvtq7UVRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y5nIgGZi; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y5nIgGZi"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5069b3e0c66so20678421cf.1
        for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 17:30:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772069443; cv=none;
        d=google.com; s=arc-20240605;
        b=PDgRat0pgNWnrdPFg6oz4Zi74E2+zLBxVE+052SyJfhXHazjWoR3JEaSoHYVPx/I0O
         kOKvppNf0028Gf+KTYTHLmyGYo4Q6Wk+skiOoFsb2WT4WZOfPGSigAT6Bu6DHO57TPAr
         iRz/4yZXaeplK78iBC900mO5KCqTzM/d2ZwKuhd0aGKOTlEswekxa7Wlc0PRkBX34Fyg
         iePotWHJGHZl2ozEYg++VUBqWNMo4DYJwI6JSM1CRe8Z4uD3SWeEFy6z5fPXhVKBR8+7
         w0t1FKOmJ2l7EdB4hActrV57tnn+Pys1suePXY9qDXV8EcJfTpBslMnq52miTAf4SY66
         NaQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7KOA3S5YvTDdYb8629dKTpj+veWzL4ZgCTD7xkgPdd0=;
        fh=faPcN8ImboiUvdZJhpdPa3LiAbxah8nfqBlIKJWug8s=;
        b=eoZ+lAz2I3lHeXE3hhYri/qzX8Ejx0DElSrBwb3ReDmkvFVdRmtZyQ+XcPY1tWOllp
         Eym6Ix36k0FwPre4Njf62ewHElAPWXsZcUfzDdpdcL3s1MYT433PIRSWu35HwMungk17
         RPXVdQfTS+7Meg5MNVpoM/UX1toKxZzw4/EgKTiliQwnETKwZmqGnN3gBRt4LieuLIPs
         twkrsWKLJ3Tm0fVt/5w4TAJOnZyiB9Ry5nfooECN/eDc5M7jJXJs8WZUtKlXFQ+DNQIV
         97Uy4rdLAtB68YF2CT/Y4/uor8mSwIlQHIDP+0bncyuMKT71RInG47Jjs4pAZqy0yMZu
         +ZbA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772069443; x=1772674243; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KOA3S5YvTDdYb8629dKTpj+veWzL4ZgCTD7xkgPdd0=;
        b=Y5nIgGZiGsPm99//xVQ+yR8Al52vsBdL2YLsq4cIwFnoqC8G1igcsYL1yMGbC6QX9u
         U4Y+IUZMmTvpcBZciiCBEC9CzW5yAyuuY5kB4LoTchsXXPr3TqpTX3qaFJRnmbn8KyVY
         19XTE3rd1kde1K8YJs7E8DjMz3YcF/GiFRPbILre0ezeyRdt6F5crwiVIHjxeqYH59Ci
         khGchKVRW2b0ec9+7VnrCM13Pkj/bImt2XJNV/Pxf5gRO+/6GhGbKoTX6OWqTf+R/MMb
         pRwIoGpgV9USnSoA3VLdCbBzO72PKgsQHBIwrHhctviopbtrIVnErKCRuMCTp0Dx+0jU
         FO3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772069443; x=1772674243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7KOA3S5YvTDdYb8629dKTpj+veWzL4ZgCTD7xkgPdd0=;
        b=IT8kx3gfHQoAhm6Z9X/ywMPq1gzc2GiuT9/s4MNrVR7etnpDSM6dHnlB/QH680ZAZh
         efXSQGWEWjrNZHdPlzJJ4jxcnkvjJGmU4tVreO+vZrRXOMA6n8QLJhunMI+JSEmYZRHl
         f0ZFaKYQNk+AAUU3Mf4TjoO4YKzBUBx2OW1emH733CZUw29lfaYuCVmUO8i1mfqG7+c+
         rfXkY4QFtbdGV8/nmoULNP/1jcy+Zsth5XJ6+2g4RFIYxjt4qTyGfPx17Nl7vu+a4Le1
         U6TlYGx/ZI8JIJH7E0N69U8PamSHv8RJYHbz63tZu71+kwn223Hf1THH+7TclFoqwbqg
         ZTIw==
X-Forwarded-Encrypted: i=1; AJvYcCUBSOorFlTHyw/7kXWK8oK9uCZMhHAkoxIdO6EC74RscPehWt8V/UAT4pBdtFPjkY2yuvlKSWJ/7baf@vger.kernel.org
X-Gm-Message-State: AOJu0YzaSLOTp5gsfmdsPFiUuhfLJvvBKoWnur7UmShCGQpNCuPCRkNl
	j/F6wnrseDzJxTaM4kObHIkU0vDx9C1j+rlvZkV6I9+kO0V9sL3AlPRFrWz7ueu6eCV4Q2bzVw3
	4FK0UBLTAAEX4lUv2Fzm3NWj2fgrVA9Q=
X-Gm-Gg: ATEYQzyERfAofNXQotOgxyxjju7nDzhJer6V0y4q8bEjBwu/PHfD8myOt1Oq+pWgZ0H
	3xOmUiY0DXKsnqlMKmyXBW2uDwELoO71UvlcYdGq4/4q560/cmfXQ4ao1ms3mFVGJvhz4l5pzh7
	Kb2jlGJ7TCq2w4EdruFzaeM68s4BGUDtlSyPPxd4QZdAyfhVxhPxf9UfHbhbdRtHyZQf6rE+nop
	bIW8U2tbcqs4QLnhyxn9hL2eZqkQVVXovmyE7w943ERgUR5UK9jNpqH8fXwLtuzdXFin9grEjYQ
	h8C5ZB8VRL1WLTGu/DWvDSHPAFozpGanxC/fa0fSyHnle/zpGanyQQ3oSr3u3fwlghbYSMgJkt9
	axNflZ6uEcaMtdNTtWqneMTl8LaiBss9Crcq6n2W6G6s8ZKHqeDk6VVjL3nBzGdrmVysexY5ZOg
	==
X-Received: by 2002:a05:6214:27c3:b0:894:6f33:1700 with SMTP id
 6a1803df08f44-899c67a685bmr17599956d6.14.1772069443353; Wed, 25 Feb 2026
 17:30:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226003455.1699030-1-pc@manguebit.org>
In-Reply-To: <20260226003455.1699030-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 25 Feb 2026 19:30:30 -0600
X-Gm-Features: AaiRm536E8MS4ED3Ywayxs4ZxH5pA3lHNVuFCTuxsRqgxtY4RXjserFyXCZlLpY
Message-ID: <CAH2r5mv6FcBCpy4Lu0JMmdKzMCYEH+aCdPdc5p+_n9xbbDRfSQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix broken multichannel with krb5+signing
To: Paulo Alcantara <pc@manguebit.org>
Cc: Xiaoli Feng <xifeng@redhat.com>, David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added Cc:stable and tentatively merged into cifs-2.6.git pending more
review and testing

On Wed, Feb 25, 2026 at 6:34=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> When mounting a share with 'multichannel,max_channels=3Dn,sec=3Dkrb5i',
> the client was duplicating signing key for all secondary channels,
> thus making the server fail all commands sent from secondary channels
> due to bad signatures.
>
> Every channel has its own signing key, so when establishing a new
> channel with krb5 auth, make sure to use the new session key as the
> derived key to generate channel's signing key in SMB2_auth_kerberos().
>
> Repro:
>
> $ mount.cifs //srv/share /mnt -o multichannel,max_channels=3D4,sec=3Dkrb5=
i
> $ sleep 5
> $ umount /mnt
> $ dmesg
>   ...
>   CIFS: VFS: sign fail cmd 0x5 message id 0x2
>   CIFS: VFS: \\srv SMB signature verification returned error =3D -13
>   CIFS: VFS: sign fail cmd 0x5 message id 0x2
>   CIFS: VFS: \\srv SMB signature verification returned error =3D -13
>   CIFS: VFS: sign fail cmd 0x4 message id 0x2
>   CIFS: VFS: \\srv SMB signature verification returned error =3D -13
>
> Reported-by: Xiaoli Feng <xifeng@redhat.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: linux-cifs@vger.kernel.org
> ---
>  fs/smb/client/smb2pdu.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index a2a96d817717..04e361ed2356 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -1714,19 +1714,17 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_da=
ta)
>         is_binding =3D (ses->ses_status =3D=3D SES_GOOD);
>         spin_unlock(&ses->ses_lock);
>
> -       /* keep session key if binding */
> -       if (!is_binding) {
> -               kfree_sensitive(ses->auth_key.response);
> -               ses->auth_key.response =3D kmemdup(msg->data, msg->sesske=
y_len,
> -                                                GFP_KERNEL);
> -               if (!ses->auth_key.response) {
> -                       cifs_dbg(VFS, "Kerberos can't allocate (%u bytes)=
 memory\n",
> -                                msg->sesskey_len);
> -                       rc =3D -ENOMEM;
> -                       goto out_put_spnego_key;
> -               }
> -               ses->auth_key.len =3D msg->sesskey_len;
> +       kfree_sensitive(ses->auth_key.response);
> +       ses->auth_key.response =3D kmemdup(msg->data,
> +                                        msg->sesskey_len,
> +                                        GFP_KERNEL);
> +       if (!ses->auth_key.response) {
> +               cifs_dbg(VFS, "%s: can't allocate (%u bytes) memory\n",
> +                        __func__, msg->sesskey_len);
> +               rc =3D -ENOMEM;
> +               goto out_put_spnego_key;
>         }
> +       ses->auth_key.len =3D msg->sesskey_len;
>
>         sess_data->iov[1].iov_base =3D msg->data + msg->sesskey_len;
>         sess_data->iov[1].iov_len =3D msg->secblob_len;
> --
> 2.53.0
>


--=20
Thanks,

Steve
