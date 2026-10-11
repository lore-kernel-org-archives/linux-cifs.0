Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4615E377AAC
	for <linux-cifs@vger.kernel.org>; Sun, 11 Oct 2026 06:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791698810; cv=pass; b=idWpaflHc5kiZtusTAhKWbrEQyYzkPb1tb2xmlC2exhd4WnasxC9KlkfB6DAUL9xCg9PaBVAReoplz+8aLT+JbtpIwMRxne2JS0NjeBX94kbtCEGpDNnImZFfRFMWMvEQmHRtTj8tzkHuZ7tN267Aw2hozXuN704EhgL3ZD4Hpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791698810; c=relaxed/simple;
	bh=L0xjsPO0dageaCm5EnmOV3npT9NMmldJ1OdH583Oiwc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fUFVOVLNcR44N5RqEqNlng2MQUn7A2wZZwL+LBYrEdWR1dE5+ggJ6VgPX5bb8yh/ni8ZDLmFbgp4smtVmqq4MUeL+zBBQDNC7VTW6i7GJX8KACDMXpsd2aK+JzDgZ/ECa4ECQd6Cb9nBVq+iy+2eexAeMDRNPkmt4khtYLDw6R0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UEznfOEw; arc=pass smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UEznfOEw"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8aea903b7b3so406877b3.3
        for <linux-cifs@vger.kernel.org>; Sat, 10 Oct 2026 23:06:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791698805; cv=none;
        d=google.com; s=arc-20260327;
        b=OxEoiWP8E8A7h4OT6Pnxay0n/65UB0sWnpdIw3dtDMizLwY1c9N59WWGlLfDZ98Lc/
         m0e/pMUHEsOWLR+b9sqfw0h4pHZquANAfvZcInmL1FQvfLL8L3eoQ0ZQ7jir/KhLGiUJ
         hsiT+YQ9YMi01+uMgacsQNeJU6sIzg44pFcPYLYCx2d+PJjck5WebiS8roEzA0nNSxNh
         P+nrWWVVaLqkXwppfzn7QClqCUfvtxI7soA8EPS/QDJfEQy5TbLHr6YdlboydidUqn9K
         gvhf13FM3BZr5MagF5qU5z9XGIjUNUme0GYUODwIrj4zLfGPN35nX9yayjjxkoyd0tAF
         GmJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q9QEKW7arrkNR3tpw3Z2BxesbCJ4by5YCPWmZN+zoiQ=;
        fh=GPY6deqgrKgVTkXMz52CUQbmPjDI6A8iiS4Xg47Vv+8=;
        b=aKXuJ00fU4/7FaUP4HK19QPbQJZWIojp3sV63ZrE9pJGT82dXNaUvffgKdffyDuLXP
         JxiyCFFzp3h5Jd0JZZRdhDrmzjdUuIAcRvW98CFfeLbJZ83/h+XWR+8Ss5cFsd/7Ji7T
         emeR5BYZpguFvrdZ6AKT1WtUMFNP8GImA+bIJHBdu5P4OdsT+IJ55LO/g9mOH0RJPS9v
         qLtNCbLuhyUCuvFTsPqVOSPa5vjM0ipKorunUGdmReMDTwMwdKqflA4KfllbrDTa021h
         PHH2JrpAJ4dM1XxoMeiUsRZ74GT9T8tzAnxE/Q7yjKgEitqn1Dj9nmtzH8m6u4Z0rn5k
         oGLA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791698805; x=1792303605; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q9QEKW7arrkNR3tpw3Z2BxesbCJ4by5YCPWmZN+zoiQ=;
        b=UEznfOEwbJiCvdZDg0O9q+z6qNTOJFH4EdMnu+j7Peqrzk1B+2MN4ofnYDgcLjv1FV
         b6cViZccom06sMsmJicubIugGsjqDsdzTFBGCz0nTI7Hioq6BeuLiS+j8UIVXeA5zZDR
         uDf9wGjLWqktnkZApdID0gukVetL6mJbVwtBBLV7k1+Lx+XLasFtmH0Kv73lRkO1SZlQ
         mcxIskdoCF0nORjNETt8AKmcl10Buiw7MFMGgmVcYQtizoFC3MqEbaYfQqjL2a+6iPUA
         qVx3zI/x1AuMcYpWCJf4QfWdcwHG/i005MawWyUntJeXFZt1A7TIRjyhyyfGku6xaklc
         7ZfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791698805; x=1792303605;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q9QEKW7arrkNR3tpw3Z2BxesbCJ4by5YCPWmZN+zoiQ=;
        b=GSzmX6xj2rnyldidIQZcFznHhFfpx0ehv1avUR1hsY14rq/sVcBoAacjPCCOI4y61h
         rgxkvwS44lZE6H8EcdpL1ZDMMC3Ewpb0YEytRObnewfJv9907UY09AIzii7ylNC/BhKo
         UtoQ4+zu6JO4BqBSrP2TnWPXYwcCGNsHDXoLDphXaVKEHumTfFn66iIujSgn9YTa91LA
         j4IxO9t55q1Shx2wuW9mI1rE4Wo8xvQmukjj8LSFOPe9pc++oj/YxaR9ftsAtHaJMAkT
         2zYYPz7WXVELC1BK8/RFufWlm8wAFdcIOxPqBGyyVaH+aTHNzeWca8fQ7Td7LLyFST3B
         FWrw==
X-Forwarded-Encrypted: i=1; AKwUvByKqrx8PSyqn9CJfflAOmuDAtNcCmO0XTMT1/dSpdgBSmld1mFQ07KmLWN+CoYXTKHbaJyi9djfWuqh@vger.kernel.org
X-Gm-Message-State: AFq9FYKFV+bCRw9gvsLb9dAT0z3LCR3hHiyR9jFzQjk/v4D7uL/6l1+B
	3fYkdTwSvEMlpVvRzZaY8ZdBCPgvfdc9aT3LRutjfiiuKHECATbAhBVaOWCyYLC7O76lM+tvpcu
	O2d+0gizp+jKyNMHO8THAF+JUe1UWMrc=
X-Gm-Gg: AYBFou0LMBMCPNPLXIAuMu+tFfj0xovfARahLuyA++ZoqeGxUmm4iAVeYhDZ/8sAUZX
	++8d5sLyAtZomjggBacHcLp5Hjh6KcKTNIGQZqT1VYOknm6jM3yqsw3HhVtu92Av+fDq/ycFORy
	2xAwgH2siHkUEiu+3fAQ+o04tiEYODoq3ESfNRWgZ2FG/ifxaBsFujPWzgbUgecV89PKQY16hcz
	fgUN0sPn4mV8EF05zakkFdpfw23cC+kbuJBmg4IYJPsUKsNBWfnWO3tvvqb40aOIB7dkklW6C34
	/CzyxvYl8AUU55FT/OtHIUujldpxJmftBs69f/1C6l3h0jqyQTn8OzejAw==
X-Received: by 2002:a05:690c:3346:b0:863:29e8:a9bc with SMTP id
 00721157ae682-8b07ed65de6mr41630957b3.2.1791698804847; Sat, 10 Oct 2026
 23:06:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261011055955.1487087-1-charsyam@gmail.com>
In-Reply-To: <20261011055955.1487087-1-charsyam@gmail.com>
From: CharSyam <charsyam@gmail.com>
Date: Sun, 11 Oct 2026 15:06:33 +0900
X-Gm-Features: AclHuK_Q2ERhKi5UKeLKEtH53kUObVOxPUwVMIZwD4utFinQ8ZLZT4N8mhh3IyI
Message-ID: <CAMrLSE6bvD9dH_KGU6bgkKPSE4xnrJatj_to7NcJyxp6+NNBHQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: match the full EA name in single-entry queries
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please disregard this patch. I found that the same EA name length
check was already proposed by Ze Tan in [RFC PATCH v2 6/9] ksmbd:
support
security.capability EAs: https://lists.openwall.net/linux-kernel/2026/07/17=
/194

Sorry for the duplicate.

2026=EB=85=84 10=EC=9B=94 11=EC=9D=BC (=EC=9D=BC) =EC=98=A4=ED=9B=84 3:00, =
DaeMyung Kang <charsyam@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> An SMB2 QUERY_INFO request can name a specific extended attribute with
> FILE_GET_EA_INFORMATION. smb2_get_ea() compares only EaNameLength bytes
> of each xattr name, so a request for "Foo" also matches "Foobar". If
> both EAs exist and listxattr() returns "Foobar" first, ksmbd returns
> "Foobar" and its value instead of "Foo". It also returns "Foobar" when
> "Foo" does not exist.
>
> Check the xattr name length after removing the user. prefix before
> comparing the name bytes. This keeps enumeration without a requested
> name unchanged.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
> ---
>  fs/smb/server/smb2pdu.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 12a43efdb53f..a49cc3a0c9de 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -6738,8 +6738,9 @@ static int smb2_get_ea(struct ksmbd_work *work, str=
uct ksmbd_file *fp,
>                         continue;
>
>                 if (req->InputBufferLength &&
> -                   strncmp(&name[XATTR_USER_PREFIX_LEN], ea_req->name,
> -                           ea_req->EaNameLength))
> +                   (name_len - XATTR_USER_PREFIX_LEN !=3D ea_req->EaName=
Length ||
> +                    strncmp(&name[XATTR_USER_PREFIX_LEN], ea_req->name,
> +                            ea_req->EaNameLength)))
>                         continue;
>
>                 if (smb2_is_private_ea(&name[XATTR_USER_PREFIX_LEN],
> --
> 2.43.0
>
