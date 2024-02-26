Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C721CD2F;
	Mon, 26 Feb 2024 10:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708944988; cv=none; b=EfjvphxCRxFjKe5BRbjYNv2swNnoimwSKkILXfyW0lAujtp4m8eqUajlRr/nE9BxJLjjStBx1jApT6crc5a0NW1yODXoZEcqnktCcO4xtU2DvrIU6he+ZVAfniw1nb9Bnm7Cu/FHZvtV+yfa0oGVakqH5pIXoyeLY8aY1J4aOM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708944988; c=relaxed/simple;
	bh=SI0ijatx+CA+XCLUPsJKOZ7njhSleBQdAsZ2YXXWjaI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HphfS9mvyBuz/x9+QJoUmvJETfJGYnKqgDoFQlHp74upKKx7SI50rvTc4bM6Yui+sPcky/aomcZ9FHKf8XXlllYoSNxofUXrmwjS5+1Ct3xFbwqw/ylKBQhE2tthlY9bdJ7+u1H4vLZcISF8LF+jr2l/zfkWNwXNzo4/Tfxdfu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KRlAPXWv; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KRlAPXWv"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-512d6bcd696so2619449e87.1;
        Mon, 26 Feb 2024 02:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708944985; x=1709549785; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7fB0a/5ZcbNw+Zj1uUC8jy+nhy/LiwshbicAgHsNIg=;
        b=KRlAPXWvGbaMl/3MX0FlcROnRKyBF47oaYLT3OxITWFoyakiwox38OW9DgoN+czz/g
         vHO6lv5w25Yrg3uDHuqgsO0GygDWO/iu2lHlYFe2fVAUcv9MgCgKs/c+WnBFJlF4ofAX
         NqIe0QzsdZxQtsDaHZMBQDIzFp2RCQrmqglma0kZV9zA5jW/IKEib5U8wHwleDWapDcK
         Cv2q5h9AqvzAq26MwpgiOAqkVHclpLrOcTVoChtJT945h21dmAdX9/Sf4Z2aW1iCDIqh
         7mZ2rmCdCn537U8YhT48C6BeIoC7/fmJe/HuYe2KW7WW1lHawREF4uWLxRk5o0GtKOni
         B4Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708944985; x=1709549785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h7fB0a/5ZcbNw+Zj1uUC8jy+nhy/LiwshbicAgHsNIg=;
        b=nH3cbMz1PPh2SUPmXyhrkyiYLV4/AlXTRXtz2hu+2QJqVh/k3FClTeVMaK2zIKAGpA
         n5tIcB3NJb+C0t4+I0JtIrGMkskBVcci0k/vLZwd6EmWtvaDJoVpEIaLeTGGuc9hk3eB
         euhFWlfI7i3M5Ycix2K7A8JiwZF1vXIpK7SU+cVqNDoUtFFH5pSlj10c4nPhsGTLhRrt
         p+Xu9tz4uAqfFtOxlOxP3B6zxnx7odYP0goq6bm7fNqmdd3Q//RIw+X3uZkAujatXHLZ
         +EWTIuQ1t27cujD/DvjqAHPdgUdG00qg8evM4XFkHTPvdHwGP+DlR0EYxUqXgZXEUJsu
         a7DQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIqgtzk2H/5otm5UYvYA+YNSVxl+X2YLN6AvWk9owHncLyyMy5Ly72tX7/FTfu7v5mevJqldWVCSGrW/L1LEAXsJ5IjPJJL4ipGQ==
X-Gm-Message-State: AOJu0YzT3x5ToUHmoi7+3YrIo+APVLVxZ/nzo/8fjtKVHV1r04lGXcKo
	VNSXLlnqGvJ+PZpFgyejOs2qu6JpATr1wj64J4TV2xICStIf1UICywY9sMG/S3UYkZ2OBn0kWWL
	xk9GC6vXVL2h1xj6hUznePo8fSCOToPAgbrI=
X-Google-Smtp-Source: AGHT+IGWZejTrnXyiwIqx/+lXlbxX3JTiyKintL4lQKrwfz6ujFLgEmkjGHcl/yKez/mE0xqMEn1SjcuGnXks0B3hiE=
X-Received: by 2002:a05:6512:1093:b0:513:d1:770e with SMTP id
 j19-20020a056512109300b0051300d1770emr435234lfg.21.1708944984590; Mon, 26 Feb
 2024 02:56:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=rYFOkpnB_SMGd0dAV5orX--Z53O-gjVg4qRkgrH6HiqA@mail.gmail.com>
 <2024022347-blinking-dingo-1411@gregkh>
In-Reply-To: <2024022347-blinking-dingo-1411@gregkh>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 26 Feb 2024 16:26:13 +0530
Message-ID: <CANT5p=qsAtUCp0W=gZ=-8sjoUtg8uUKda04=ou+ABx-mjVUeUA@mail.gmail.com>
Subject: Re: Request to include a couple of fixes to stable branches
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Stable <stable@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 23, 2024 at 8:41=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Fri, Feb 23, 2024 at 07:11:48PM +0530, Shyam Prasad N wrote:
> > Hi stable maintainers,
> >
> > We seem to have missed adding the stable tag to a couple of important
> > patches that went upstream for fs/smb/client. Can you please include
> > them in all the stable trees?
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D4f1fffa2376922f3d1d506e49c0fd445b023a28e
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D79520587fe42cd4988aff8695d60621e689109cb
>
> These do not apply properly at all to any stable kernel trees, did you
> get them to work?  How did you test this?
>
> Please send a set of working backports and we will be glad to apply
> them.
>
> thanks,
>
> greg k-h

Hi Greg,

I have not applied these to stable kernel versions yet.
So no testing has been run on stable trees yet.
Let me work on patches to the stable trees and share them with you soon.

All the tests so far have been with the mainline kernel.
The testing involved simulated network disconnects when the Linux
kernel source code was being copied into the SMB share.
Our team has been running stress tests on the mainline kernel, and
there's nothing alarming seen so far.
Also, these changes have not regressed any of the xfstests.

--=20
Regards,
Shyam
