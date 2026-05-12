Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F22B349CF7
	for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 13:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778591285; cv=pass; b=ckkcnXnaml6vj3pDkQIYnDk5rhPCSrktf8oW5MV7uz5Bh4t7UgfO1VXJSS4M16ioD05KIl5Evuxh0YiFqJiGfgn3wSaI6hfMYkpCqzkiG2Fd/LKGvJhj7R0KDzmp2PQK7Jp6G9lMcLV33qGZdPTPUa930j5a0xi1A/VofaFj38o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778591285; c=relaxed/simple;
	bh=+vcfNdRtvwQHAPFi9qeID7iVjTEIACNb7t52akS/Gx4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eXYN4jj49DBqzzA6dNMEryHbe3LgZLu7994Qybc5ny5pCBGjfolekmpDLkqx0JlzOnTlLuX61VTjoPLw04wNnzaGgHzeOOEji3nDU/3qAqcptbbCXziN+RDPuUeaXD6HEff/S5qKcINHyiR/SxogvzvqK9D1NlcR1Xiss4xl5Hk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fEGrDJvt; arc=pass smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fEGrDJvt"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-651ce87d785so569963d50.2
        for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 06:08:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778591283; cv=none;
        d=google.com; s=arc-20240605;
        b=agoNk4hKe6JsZwACYBfT5aTSFW+ER9esfyAOVg+oY8i7Ckd3TTxD0d6fZv/YyyUFKS
         PdbR2I7QBBc5lIJH8ydUlaTkmOnYU/w1dBsRUhiJjyL+QQrWGSbd74kQmxw49uf5NbW0
         OZzJ3DfE44Yk26M5LRsiR/mi4JH1xyoSNiXXn9bxbFJx6lHcTZ0VfUyohFmCAmlEcBA1
         QOzXwHCGmIqEgYF6Q4uZq2qGDv+lA1JGQvvRXlhKSxwq8SoEiAu8yNNnNlitx4QbLfMB
         upOeiXI+ovgoG4VRrnUb18yebXn6g7KU8iHrW9Xbwi4dHRRWuq+U9w0cPdJBkIBMtzAi
         2bng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vnBWAAshyrw9uW2waQU9UJFxrzx86ul1N0tkpGj9Dmo=;
        fh=EcY0HLj75Z7t9i0Fuve6XUB/bBG/8+E2F/+HaFOoLKQ=;
        b=ED7Q3KgYfhRZ65oiYPPctGCMhNS8Zv7qx0tk6xYObSyqC4hI1MROsEaZrpCHUyH6ql
         LaieIK/r7fKVA3QDcf6th2nE6UDhaii+ScHGU/IJfmaUxVeyVzy5PfoepmR7NdiP8WhW
         icuZZGT+9ZuGDuEror7lMe2S1MTFFRM/1G/lj6CwvgfFBswwdA20Kkz8fD2Nwh8zKWG9
         N4OP3QyV7AQjZp/3W1/iMYQAdxKvLCQqsbCjgrMDqdzjkLbVxJUbWDeNoU4DOIQ2sm26
         cILJAThpZjQtOiOOf8eEugf4x292LL7vsye0/gPmPgPedxtJQOCD30Ex6XR/DLjZXvXW
         NCng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778591283; x=1779196083; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vnBWAAshyrw9uW2waQU9UJFxrzx86ul1N0tkpGj9Dmo=;
        b=fEGrDJvtHpIFtrTWjkSoGKqDTEQcVkexN4jqkdq4Th8fzXv9UTKn/H7MMd8olzktqd
         2qVppYWSG4KHLvBTv3QKS2rbh4j+YD674sTm1qS7+gFGDg8nnkzV4OCMKG6vQlPS0l6n
         HnJVvajdgkMF0uoiN4iFMck+1LrImvydCGoJw1xynC6YuSBYBAmXt4DIYqK+QFs7lygI
         QuUY46kyQz1i6/B/pxWxeyVQXb1vbPYoK4OE+1wGDUyqs1nE+rZ84qnl+5DiWlRGICmQ
         WNsPCeAKQZt4Bmwhi1eEo+WluE64FdBACfg+ocN/mJpHj/KLZ2ptvXO6LUs4IvPmpwUR
         0/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778591283; x=1779196083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vnBWAAshyrw9uW2waQU9UJFxrzx86ul1N0tkpGj9Dmo=;
        b=IK47Wp6Tt7NcF8mnAy1xaCuMwK+TMu0BFEV8ANNCEcY0nlv2z93YPDXMP6WTixb3EK
         bqoZeCSoEkT72cIq7jmvQhRN7XHQ7vxiDiU5oFgZs2NzckT+1l9b1uE673kuQZHV2gOz
         P++shUpWb29r3ukwCnSXrRXeiq2uypCXXitebs9p13ZoXbR5cS92SlCTejD4cSTDNWAI
         dJyMxXXHC9F9UjSGEk9QzVSSMWIUAii918/cqIxeN8Jp7Xq6xz1DWf+zx79afykIlDlq
         iF68+zBT1SsqwLvseHgE7MoTk0DjkJBzG7KNjc5nLlQausqCQQAjnxgWYbn9KJA+e4hB
         BGLg==
X-Forwarded-Encrypted: i=1; AFNElJ+/sKx38vurco/xwcs272no9DU2wfdT3pyKMfoYQbc1O/jsL+2VVTXoMbopk4tgedoL2Nz0X+MXNFli@vger.kernel.org
X-Gm-Message-State: AOJu0YyTWqV+Ndz5wUW1vDX6N8Ka5T1xnZir9qnaTrQDleOElw16pZK0
	hp4n4N3pBV/3hDK3ywD1xK8r4GpYkd8k48Oml2BPZYdRn2zLrUnkHf6xslmSqIpz3cY7gth+l44
	Pk1bIf3GN64ty2QSMl8WV5tUMgtNztFo=
X-Gm-Gg: Acq92OEpW2YKAiDufhaMOWN1rfa/ukg3qMH0bH+m+YYLMGh31UKdMUidVPCwG/gaNJw
	FyzZRAhM67c3SrutSU+Z82QNA8CpTaeaiaAwhI06V3AS7UMb7NVQK8A1eTgxSIMcAdop+VT7i1J
	ykcCVRwoK+TiP0r54XODP5ww0cL+hlp/4/iYLMBU63/EQ7bQmh7eRYffXb78uyHuw8Stt0iuP2H
	lTDrSVqds+xSfyBaDmCQFMUDe9yn6tHf2Rxm4i3+jiQC0BkFvUcSf9WjKL/xwT/GGzP8iiz+S59
	57wUeZox
X-Received: by 2002:a05:690e:13ce:b0:65c:322a:7ac3 with SMTP id
 956f58d0204a3-65c7b70bfbbmr17655158d50.2.1778591283371; Tue, 12 May 2026
 06:08:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512123404.719402-1-dhowells@redhat.com> <20260512123404.719402-9-dhowells@redhat.com>
In-Reply-To: <20260512123404.719402-9-dhowells@redhat.com>
From: CharSyam <charsyam@gmail.com>
Date: Tue, 12 May 2026 22:07:51 +0900
X-Gm-Features: AVHnY4I7C6CzYKo5rOIaKeFxn1UK1vSWmDrEYuJGWgiJZva0dOf3Ebu3U-sXK3A
Message-ID: <CAMrLSE5jFZwmUrx5GWhz4AD9QpLsF9VsdaMJxiDa6ukXqH8RPg@mail.gmail.com>
Subject: Re: [PATCH v6 08/24] netfs: Fix potential uninitialised var in netfs_extract_user_iter()
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, Paulo Alcantara <pc@manguebit.org>, netfs@lists.linux.dev, 
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, David.

It looks like ret does not need to be initialized to 0, because it is
only used after being assigned the
return value of iov_iter_extract_pages(). In the zero-length case, the
loop is skipped and ret is not used at all.
What do you think?

Thanks
DaeMyung

2026=EB=85=84 5=EC=9B=94 12=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 9:43, D=
avid Howells <dhowells@redhat.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> In netfs_extract_user_iter(), if it's given a zero-length iterator, it wi=
ll
> fall through the loop without setting ret, and so the error handling
> behaviour will be undefined, depending on whether ret happens to be
> negative.  The value of ret then propagates back up the callstack.
>
> Fix this by presetting ret to 0.
>
> Fixes: 85dd2c8ff368 ("netfs: Add a function to extract a UBUF or IOVEC in=
to a BVEC iterator")
> Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%=
40redhat.com
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netfs@lists.linux.dev
> cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/netfs/iterator.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/netfs/iterator.c b/fs/netfs/iterator.c
> index 154a14bb2d7f..6903028b7162 100644
> --- a/fs/netfs/iterator.c
> +++ b/fs/netfs/iterator.c
> @@ -43,7 +43,7 @@ ssize_t netfs_extract_user_iter(struct iov_iter *orig, =
size_t orig_len,
>         unsigned int max_pages;
>         unsigned int npages =3D 0;
>         unsigned int i;
> -       ssize_t ret;
> +       ssize_t ret =3D 0;
>         size_t count =3D orig_len, offset, len;
>         size_t bv_size, pg_size;
>
>
>
