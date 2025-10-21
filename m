Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FA21A2392
	for <linux-cifs@vger.kernel.org>; Tue, 21 Oct 2025 18:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761073178; cv=none; b=F0mM2fhhsmURuJQ0a3S6+Q4ucSE0Pf+0nCSOe1+SbzjGJPSlNuJhKbgomcIUeMChY1WZUTkS1UDPUUwbzKGTqfwZYpX9ZltzeyH7UPxA88LahUa1bFTmCn4ANzWD+N5f2y5ImQreuA3T3yjlYn3KndqNOsTZRNXUq4sGrRqgdaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761073178; c=relaxed/simple;
	bh=4DcqkwAMlIEplRfS31thjKYMFSVdsmO5K7qZUn0mtCI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EhqCRHQCp1Z+o4yN7pnM6bfL8Gu6krl1vDmXvbPx4r6UjohE43eyi9NHJX9mhwX4w3KCM8n+uAz1NZAMPYuoX6m3mKf+83QNUblOFS9prUQLtKINBEm/m4A/5HzG3JWkee+H+OBXyXqeSM9pT1ZF8iORnx4PQAtaJrzFT6YUmxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TQsZwX/y; arc=none smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TQsZwX/y"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-6360397e8c7so6104798d50.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Oct 2025 11:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761073176; x=1761677976; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aPG9zln5XU2mnMTQ/EplaImp3uu28G7WxD8f3ae2VUY=;
        b=TQsZwX/yf09XNWWNf1aeiMVWO0kIK7zZdVQDD2whxe7Ox81gxAL3Vsk+blW15Jy4Is
         vkFe5A83CJj9FEVTCNgkxPDcpL1lBdMKEMUCYaPlp3G0ucN+Gvmynq0aEgHZZYQ7CuOo
         IjtzHnfaovsQtsITL7b/TbK8BOAQUg64RgoeF5lN2Yx4xqD6srFWx5YDIM28J3SNJlkL
         ONHtgc2xPmE51L+Awg3YI9LIbz0fxPE5MQSo4JHGz9FalpmxQf6uX6E6OizVMZldjob2
         1o7XUv5Y3/bbRQsXfmIGeJW0VKl5G+J3gVFLXE/aA8w8kT83dek//MZN1BFr0giXTu3z
         pT5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761073176; x=1761677976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aPG9zln5XU2mnMTQ/EplaImp3uu28G7WxD8f3ae2VUY=;
        b=xDSBxuhmStn3JzFLXzD3NR6PnRS5Aegi32ZMeN9GYtyXEbiFajcxJqq2L0Lot5c8OU
         lfdIMqCMADJfdGSw8QetVWux0vQ9nkZhBYFTp3isyd7neG9QpR+5uRhpfbsZMICU+Xvw
         bdVdxXscNm8/xGiaHAzcOW08YI/rbB0KA2Fq+bGoCNnNOcjPIHxV0UVd0uT4ZQER8MQp
         tstr2ahXVHyqY0O3xvbIxhGBJSRudzNjQmpbh+T0fhMn4GVfAV483iKSWfWvK8WQWaqg
         qGmT0dulfn9o/Nka4E8ZkvBLlkyv29lEI7hOqTk+T+epSvkV/fCuGX+C5Tt2+nf51dZN
         s0/w==
X-Forwarded-Encrypted: i=1; AJvYcCUJUSA1YNtkzI5Rq7rNZYcKxXKV6h/ma58NzRVKnd5x+EwZpfhMXreYRRdHMW6/zMt9PPC0nM3O5aUZ@vger.kernel.org
X-Gm-Message-State: AOJu0YyjK+WlC2YI1+Y71mZhbxongeJJseKEzZlrSfMacMjbWgAJyUJP
	xl6Vv+FjuVulxdH8a1IMoxKPqt1TlDF3GEchElEzBtD4F1gixOZGQU8O298nUmS2ud/wB+CKjkl
	hHDmXNk0tWCXedaO2gEfEauDKylhBSSY=
X-Gm-Gg: ASbGncvDQRr2EqG5Xb75EEH8/eRqe1z8xdgcJtVDzu/gZc0kissv+OpP2Ck8Im2GAUe
	vVb1CV/bjLWeAePA7wQQLk0+wSBqMc0FMZjIvwdBMyc+iXBY3ZPAyuBftp3na9uCmOPj3e4UJaD
	0kumoWBMbUs7jKX+qzvv/FP1htXZ3NyMey5ySK25hbSZbFKaMf1f5wDUECD0S9E/mIl60/5FSnL
	cpwpphxBOl8dLvxANR/Tc9RC26JglnXJkTdRpkGQvUb3uRAGKe3cus/Bz8FdyWxYuelcdX++RN3
	DIlQbrJwqvrTWkmAmATf9eTnFBJaXhFjY3lvPjuXlhNN1TQ8lKimOUJlWuAbV/zv6UO3PGPRfxB
	uJA==
X-Google-Smtp-Source: AGHT+IGfA88lshRrHeuhWYx8VLmZmv7TZuHtokbNApYFPae32yqmw79Gqy195FvBvbYPjD1HelbR8qmV4l9q09qdisA=
X-Received: by 2002:a05:690e:1553:10b0:63e:14b1:4811 with SMTP id
 956f58d0204a3-63e1617644fmr12941546d50.11.1761073175581; Tue, 21 Oct 2025
 11:59:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEAsNvQmV=xFsU-4jn9zC2DYoAUjXTS3qcsGNe7XUZEEXg1cLg@mail.gmail.com>
 <CAH2r5mtCjCvYphEAWir9PtxWQUy51jiir2Lk8erubUetX8TAbQ@mail.gmail.com> <eksh6mo4hhijkea2o3lalpbsoju7sp4nwwvo62l2fhs7hkvaid@6aisea5jt3f2>
In-Reply-To: <eksh6mo4hhijkea2o3lalpbsoju7sp4nwwvo62l2fhs7hkvaid@6aisea5jt3f2>
From: Thomas Spear <speeddymon@gmail.com>
Date: Tue, 21 Oct 2025 13:58:59 -0500
X-Gm-Features: AS18NWC6vOYvgtQfK_Cai8yF0jpDOQNH7d442IT4uFnCEhWPRYNka0isd_ApPME
Message-ID: <CAEAsNvTNf14E8iVrtptzSqQ4Gq8QsM4sHpJ0tfTyt4mkFWCk7w@mail.gmail.com>
Subject: Re: mount.cifs fails to negotiate AES-256-GCM but works when enforced
 via sysfs or modprobe options
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Steve French <smfrench@gmail.com>, samba-technical <samba-technical@lists.samba.org>, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This sort-of makes sense as to why it's happening. I can understand
some code so what I see here is:

>  else if (enable_gcm_256) {
>                   pneg_ctxt->DataLength =3D cpu_to_le16(8); /* Cipher Cou=
nt + 3 ciphers */
>                   pneg_ctxt->CipherCount =3D cpu_to_le16(3);
>                   pneg_ctxt->Ciphers[0] =3D SMB2_ENCRYPTION_AES128_GCM;
>                   pneg_ctxt->Ciphers[1] =3D SMB2_ENCRYPTION_AES256_GCM;
>                   pneg_ctxt->Ciphers[2] =3D SMB2_ENCRYPTION_AES128_CCM;

Here, AES-256-GCM is second to AES-128-GCM when enable_gcm_256 is
true, but if AES-256-GCM is still present as one of the ciphers as per
this snipped, and the server doesn't support AES-128-GCM, shouldn't it
fall-forward to AES-256-GCM instead of causing an error? IOW, I'm
wondering if there's an issue elsewhere that's preventing the
AES-256-GCM cipher from being used and reordering would simply
band-aid the issue.

> so if the server supports AES-256-GCM, the only way to make cifs use it
> is with 'require_gcm_256', unless you disable AES-128-GCM on the server
> (as you have observed).

Actually, the issue I'm observing is that _when_ we disable
AES-128-GCM on the server (Azure Files), mount.cifs on the client is
failing to mount the share completely _until_ I set require_gcm_256.
I'm happy to do some debugging and provide outputs if needed. We're
testing this setup in a lab environment for a wider rollout to
non-prod and production for an app team who needs to mount Azure Files
in Kubernetes, so we're using the Azure Files CSI driver for
Kubernetes and I have full access to the underlying nodes since it's a
lab cluster.

Side note, I also found this unix stackexchange question that seems to
be related but is for a non-Kubernetes Linux client and a FreeNAS
device as the Samba server:
https://unix.stackexchange.com/questions/766995/linux-smb-client-failed-to-=
connect-to-smb-server-forcing-aes-256/800613#800613

Thank you,

Thomas

On Tue, Oct 21, 2025, 1:31=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de> w=
rote:
>
> @Thomas:
> Yes, that happens because cifs sends AES-128-GCM as the preferred
> algorithm:
>
> (you said you're not a developer, but this illustrates what happens)
>
>    static void
>    build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_ctxt)
>    {
>            pneg_ctxt->ContextType =3D SMB2_ENCRYPTION_CAPABILITIES;
>            if (require_gcm_256) {
>                    pneg_ctxt->DataLength =3D cpu_to_le16(4); /* Cipher Co=
unt + 1 cipher */
>                    pneg_ctxt->CipherCount =3D cpu_to_le16(1);
>                    pneg_ctxt->Ciphers[0] =3D SMB2_ENCRYPTION_AES256_GCM;
>            } else if (enable_gcm_256) {
>                    pneg_ctxt->DataLength =3D cpu_to_le16(8); /* Cipher Co=
unt + 3 ciphers */
>                    pneg_ctxt->CipherCount =3D cpu_to_le16(3);
>                    pneg_ctxt->Ciphers[0] =3D SMB2_ENCRYPTION_AES128_GCM;
>                    pneg_ctxt->Ciphers[1] =3D SMB2_ENCRYPTION_AES256_GCM;
>                    pneg_ctxt->Ciphers[2] =3D SMB2_ENCRYPTION_AES128_CCM;
>            } else {
>                    pneg_ctxt->DataLength =3D cpu_to_le16(6); /* Cipher Co=
unt + 2 ciphers */
>                    pneg_ctxt->CipherCount =3D cpu_to_le16(2);
>                    pneg_ctxt->Ciphers[0] =3D SMB2_ENCRYPTION_AES128_GCM;
>                    pneg_ctxt->Ciphers[1] =3D SMB2_ENCRYPTION_AES128_CCM;
>            }
>    }
>
> so if the server supports AES-256-GCM, the only way to make cifs use it
> is with 'require_gcm_256', unless you disable AES-128-GCM on the server
> (as you have observed).
>
> I don't really know/understand the reasoning for this, but it's probably
> because Windows follows that order.  AFAIK the performance difference
> between AES-GCM 128 and 256 should be negligible (to the user) nowadays.
>
> IMO we should reorder this to prefer AES-256-GCM by default, hence drop
> the {require,enable}_gcm_256 parameters, and make it an opt-out thing
> instead (Steve?).
>
>
> * Also @Steve, I just noticed we handle AES-256-CCM everywhere else, but
>    never actually negotiate it.  Apparently nobody ever complained about
>    it not existing/working, so maybe just drop it?
>
>
> Cheers,
>
> Enzo
