Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B021B425C
	for <linux-cifs@vger.kernel.org>; Wed, 10 Sep 2025 15:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757517624; cv=none; b=RL6XQKcRe7UT35mF5/Iz3EhzfEPGGvvWBEkVU3Lpui0oiXh6WUXhl3X6NCXobWjgBt9p7PCDvCO04cL5D6WaPntK6Rp+d0C9Py90hfDISJeYweD+LsqZO+41Op8CtLgBrDlVNoGZoMFy2gyHDH10FNJtsvrE9juXzmoIfMmLuQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757517624; c=relaxed/simple;
	bh=kv8B0O1HobxaoHy5RFbs2AfcQk0dCx425bnynxZBSGw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=quC6G6FKJd01nF5grcGAgXa0BTrPz0V/bB278qKQ15MAPIKm7xwOfmOc3krYSP03XapDv1Dzdb1WU1Bhc8y7Z1N1pFxacIpVLYY/ubxGfAUNIpF3N/SbyKt9KEYAq4Bi3sBAMCXR8BY8XfXwYYrukmyQU6uc6EtBSuInr107Gp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bCiTStcR; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bCiTStcR"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b045d56e181so1037449066b.2
        for <linux-cifs@vger.kernel.org>; Wed, 10 Sep 2025 08:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757517619; x=1758122419; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YddFOBIDIxcf8W9M4VBDWjnSHo4iGUOtLHzqiAb0UxM=;
        b=bCiTStcRQJ7xrg21i/sgEpm/ygLBpy9zdwRVEzXn8+98ZY1au2au+aPGRrIotyHFCt
         eegZgUNvMge6OUhKtCuUXppF1wMlKtRxvZVdurplQAkq7L0J81TY1CSdyp+AZdwXWqXk
         USczer5pTCIgERYOnlLoxU8OpK3PQ55nf1oe+xsNl0y3cKAQgL3RRnUWcLRDyoRQT1xL
         ydhb+VuIPex9AXWawnmiDT00wV9pfUY/zWm84klmkMTFSepoYUF4bHTMhnjDCZ7Fkpvx
         R22HmAoJ5YTPjYOZ3k6THSrwTdM6bLonAGc5MU+GAVzOZqEDXvUoRo1667m3gfyqIyuH
         Kj/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757517619; x=1758122419;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YddFOBIDIxcf8W9M4VBDWjnSHo4iGUOtLHzqiAb0UxM=;
        b=HrZKVJDrSdDGZhC4KGBziTspOMyOknzBYSvPqCy7UPx6OMsqpoRQv3gcSq5fI0WxL5
         5lXautzb81tTk10VDFaKIaWid2Pp4Oxt4f+SBEUdLg4OZdW9cxHwAqQuZpQPtAPIM5rK
         BBuxnpAzd4sF+p5+oexEFiIDnCBbr68KPkkJlBEMSvyKGKpJ7QJVQxHnh5L0pX/WmnkT
         m0c+7LpPWrnAtdNRhs31o49vHZ4TmSYO/PjuW59ZYHk4rCLS//3zfuFIKo+5bDiiM57k
         VrgL733Ce+8SJmkWyMV4WwriALDUMhTEi5N7ghSsdBX2NtKaPlh/ELW4qqC8TNNWoQ72
         M+GA==
X-Forwarded-Encrypted: i=1; AJvYcCUETRIYwj9yU+ZUQS8PmsNlJai34rxF4dJM8hhT8UjDYJipd92TSmbJLWbIHxeGZ6IASdyQjBG3Zlte@vger.kernel.org
X-Gm-Message-State: AOJu0Ywue0lfnRtJo0dOJx6slHTmUSxPXXRYfxEuy5LE9vHgXm0yG/wT
	UY7gZyqnpCgAa3znienSvWjL7uOodZ9OYgUG7Eg471fq+On2hea9QzfcEMjluUD+uL3BH2IzCd+
	pW3asvghrpNO0o+9saCHQo9QNbSt56B4=
X-Gm-Gg: ASbGncu/MJnAfUCCsuapE5pNBSu5cE4uyMf/EZu/ZRwnAfkIYopdVq7eSJxgr7eiXHV
	2hC1Jyugc0DOeF5eMJN6b8KSd26El8NOhO0a88Wqw/qw7h4JG5WJNwJh9hyBKwvJbZRs2BsLPl8
	fwfYrL8Y9wRBfQn1XwrWTC3/ayROZ6r+DbpO9DRHIKOH8MQhHjOI2zLzvRMyNjhmXMv/9vyIGI3
	DLy+bhT5KJWu65u
X-Google-Smtp-Source: AGHT+IFEDD/EJRTUJeo50foI0Xse2fOk/2Go/a4VgKQGbKl/+u2PY0/xyGLg4lYDrJv0uH4s6HjqIwD3JLfl3LwmbPc=
X-Received: by 2002:a17:907:1c93:b0:b04:3e15:7289 with SMTP id
 a640c23a62f3a-b04b15434ddmr1549316866b.33.1757517619105; Wed, 10 Sep 2025
 08:20:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=ofG-CQF_Rmv15+HAe0Jd1u1r=uqa-nYyDFOBOJ-0-jng@mail.gmail.com>
 <ddd6lpyi36bfbe5qhaqc25m2nfw4rfh7rwjzrsx2chkf3p5zji@4xq5ew2qisha>
In-Reply-To: <ddd6lpyi36bfbe5qhaqc25m2nfw4rfh7rwjzrsx2chkf3p5zji@4xq5ew2qisha>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 10 Sep 2025 20:50:07 +0530
X-Gm-Features: Ac12FXya01MYw6-tkQB8cMPe7kIn-Yz4qPEGmku-lCMTHqCjwucK2NEowV0yuXQ
Message-ID: <CANT5p=r+Ce0FD7yjzJU4kq3v0UyzFNjgTz0eZ_=54fTe_H6_BQ@mail.gmail.com>
Subject: Re: Growing memory usage on 6.6 kernel
To: Enzo Matsumiya <ematsumiya@suse.de>, yangerkun@huawei.com
Cc: David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.com>, 
	Matthew Wilcox <willy@infradead.org>, Steve French <smfrench@gmail.com>, 
	CIFS <linux-cifs@vger.kernel.org>, Bharath SM <bharathsm.hsk@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 5, 2025 at 7:51=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de> =
wrote:
>
> Hi Shyam,
>
> On 09/05, Shyam Prasad N wrote:
> >Hi David / Paulo / Matthew,
> >
> >We have a customer who is reporting a behaviour change in the way that
> >cifs.ko manages pages with Azure Linux running 6.6 kernel. This kernel
> >is generally on par with stable 6.6 tree.
> >They have a test program which simply opens a file, writes to it and
> >closes it (it chooses one of 100 files at random). It spawns multiple
> >threads which do this in parallel.
> >They reported that the memory usage keeps growing and that at some
> >point, the VM becomes unusable.
> >
> >I checked what's going on, I see that there is no memory being leaked.
> >The output of free command reports approximately the same available
> >memory as it runs. However, I see that the "Inactive" section of
> >/proc/meminfo keeps growing:
> >https://man7.org/linux/man-pages/man5/proc_meminfo.5.html
> >
> >              Active %lu
> >                     Memory that has been used more recently and usually
> >                     not reclaimed unless absolutely necessary.
> >
> >              Inactive %lu
> >                     Memory which has been less recently used.  It is
> >                     more eligible to be reclaimed for other purposes.
> >
> >I see that this behaviour is not the same on Ubuntu's 6.8 kernel. The
> >inactive memory does not grow.
> >And on the same 6.6 kernel, a trial on ext4 filesystem also shows
> >similar results. The inactive count does not grow.
> >
> >My understanding is that these are reclaimable pages, which is why
> >free is not showing a growth in memory.
> >But the customer is claiming that they can consistently reproduce this
> >issue and that the VM goes unresponsive as this memory keeps growing.
> >
> >Any idea what may be causing this?
> >Is there a known fix in more recent kernels that you're aware of which
> >needs to be backported?
>
> We had a very similar bug in our v6.4-based SLES, it's a folio leak.
> We fixed it with this downstream patch:
>
> https://lists.linaro.org/archives/list/linux-stable-mirror@lists.linaro.o=
rg/message/FY4GYKLWIMQKGPI4CDDANZH2AFIK6NM4/
>
> Copying a single large (100GB+) file also makes the VM unresponsive.
>
> HTH
>
>
> Cheers,
>
> Enzo

Hi Enzo,

Thanks a lot for this pointer. This helps us with a lot of context.

@Steve French It looks like this patch was submitted to stable. But
because the format was not correct gregkh rejected it and asked it to
be submitted again. That patch was never resubmitted.
I think we need to do this on priority. As customers seem to complain
about data corruption under memory pressure.

--=20
Regards,
Shyam
