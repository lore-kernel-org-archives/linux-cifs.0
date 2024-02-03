Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731A0D2E6
	for <linux-cifs@vger.kernel.org>; Sat,  3 Feb 2024 22:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706999419; cv=none; b=L7UUbItLQ4id8LGsGmTpZHbTdVoD2j+BRJiewVxf3LYtVxP/jsGC/G7KlG+epCmzKYgF/rZrY4Ib5C+h+zAGDkcGcDw0ZYSwaKncNfj7kTEJKMATBh301rCnEA18O+cstbRs7HSIWzrTbcKRbARbynI5zrXtoJsSpT11l1RXt0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706999419; c=relaxed/simple;
	bh=YycHCXX9NeDyAMuaWDawdCPMMnQId5/kveA5XXM0j2U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tMEg0vi/NqD2ymcKJn0TYETpxWG+s2TKoIjN3XSkb9SOZR43AJpZShx4+1+EcKUDE8itylj4EUrSVBVd3JyyA9SA9/KvDJXUOU0ogPTuK3pugMQD4K5DkZhNrOkWci5QELYO08Nm+ttaoBi98qVumDrCpd7uECX/UM7gnR3SwW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cOeZpdxv; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cOeZpdxv"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-51142b5b76dso1435673e87.2
        for <linux-cifs@vger.kernel.org>; Sat, 03 Feb 2024 14:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706999415; x=1707604215; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4YmE9JaCJf6byZTFl2XPaFQv4Fcw6eFSXNOy7B9yD80=;
        b=cOeZpdxvc98EZhZp8k3D6iDSiXWJxnPEPoRTASt/wPcJtBcmSSuWFlSpCnUHZJvJIL
         EkChUA5P/oKzwI8xyV7eEwyfEsx1iy0mGoWO4R1on8KLQTNyEoboYMd+1nqMIXc895FE
         w3KQ8hMV0a49bCWwJls3y6rK90kP+ofYi7kqqEvxqBPZZMwCHIAjy3zE5M599iUmAvAr
         riEb8WD0EyGKHcBEy2DjGJflTYLys7he+MuTfG+J0qCxEODweKMXN172VPEkEc7B3ku4
         AIdE8tfgNZ6LGuLBM0JUj0yzSjKdQrRoEsqXewtPdGuNWgFtW4F6YJMMvcHVXp6p9zCt
         7fjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706999415; x=1707604215;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4YmE9JaCJf6byZTFl2XPaFQv4Fcw6eFSXNOy7B9yD80=;
        b=ocLVCkonhLCDLdKNS7l906HZX4kRC1+fWsqoSRLAU2xziGACTxaPXpdtgszAESefEd
         f9ThPMOw3Ht76Q+WFUK6pVq/yGdFjERbk7O9M/2H//g2QXJXFgYc4OYVmmXnxYOI6m6X
         EU1tciKW8NNXobvaVSKX4owqjN7uU19ZDg4RgF7irlmTDYWkr1rddYaY+qXd1L+bjHeQ
         68JuLz8E7e35hRgRI4xu1pbWwcsLZOOBdp0bL0M5LIDUHH1r4NrFm1yRbv9e2E+tb89z
         ezjNRq1xhJSI0IZ6tOhzo/MB/aE5zfRSop0dnT2IYwGhhsKZLj6oc2pD33IyGSxKpRD3
         R9FA==
X-Gm-Message-State: AOJu0YyCvaLDnEnji7pruOlaWkI0T3UFbIQu9mIQzbFq1eW48bJ9x4MB
	LFb3YUDHf5d53aVz32Y4ueG7s0pOH1tANjDex5/+f+CZ0qVHg7KXAlpJ9IZLYmcdjRkNPJ2bWgR
	J0pnG+nVtEkRPAt4Zw+lShHV5mcz9A5qc
X-Google-Smtp-Source: AGHT+IHm1IiFoMuyMkMdGjHl3Q/EHElVx0w8TbInZFsee6VMJ7ipiKzqYYRD9Xj6KGLCUTM08Os7kx2btRMbmQei9wQ=
X-Received: by 2002:ac2:5930:0:b0:511:4c05:6b3c with SMTP id
 v16-20020ac25930000000b005114c056b3cmr88676lfi.31.1706999415161; Sat, 03 Feb
 2024 14:30:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de>
In-Reply-To: <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de>
From: Steve French <smfrench@gmail.com>
Date: Sat, 3 Feb 2024 16:30:03 -0600
Message-ID: <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com>
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
To: "R. Diez" <rdiez-2006@rd10.de>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Do you know if this is also broken in current mainline e.g. 6.7 or
6.8-rc2 (for Ubuntu and some other distros it is fairly easy to
download from their website current kernel packages to make testing
easy).

David,
any thoughts whether this could be related to folios/netfs changes?

On Sat, Feb 3, 2024 at 4:23=E2=80=AFPM R. Diez <rdiez-2006@rd10.de> wrote:
>
> Hi all:
>
> I just wanted to bring to your attention that SMB 1.0 writes appear to ha=
ve gone broken between Kernel versions 6.2 and 6.5. Writing about 111 kByte=
s of data to a file is not reliable any more, you get 5 holes with binary z=
eros at regular intervals.
>
> Here is the research about this bug I have done so far:
>
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2049634
>
> Regards,
>    rdiez
>
>


--=20
Thanks,

Steve
