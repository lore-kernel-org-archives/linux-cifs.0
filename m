Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792544771;
	b=UtN0SK1QkRcFNInDzBFlF6Wub4eMzGDs7jaEH6sDa5QOubX0pBQ4rL13qg4Z9v1qMUg8
	 gTNqaxp+g/i0qoIeniWw6Q30FG4/ZfSxBd8QOWEOL7KXFIYoZ70XWVKwVde/0Z7sHKGjU
	 HRibmeIomIxj7WD+zcph/CNAZeHpJFAupW/EK5WhPsi0oN/BrESqWXeAEGfAJxABMR9EK
	 QxtHAA1y31TCUhZgKS61bQ3XW9U9TQqCpEUyh05As2TboGeLVgJVaNp8ztKo0i/0jaw0i
	 x+KwnGWC8cZttNwm7m2TnW7haM9/ClSyvNFdrB1XnLSEl1vSP62zqbRCuWUfscZ2hNw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792544771;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=7BuIBRaFV355G0S8fL9PjcEbMxttXic2m2/XMDLcEKc=;
	b=O5iCQGRMXwcPAiqmIJU0WKEbHDLGhb+Y1KzzBxKe4lCegDStm8SCgeQjAgJrb6te7Sm8
	 nVtihEWqw7+IqpqIelBwn0Ay5o8XMQubvV7cXrquY6Xq8Cf9QI7qsTubguSXrVg5MIf2w
	 BySbq8FQobb3fYFm+5mxN5WiA5CjARr49eYpXoO1vba9PR3XpZ98KnwAJ2SQtIb7BIYFB
	 OdW9eS+ZM49ETTI9z3khkghQBFXxsjaJrHskDdqgPpfwnWCRcBCEsXQRMgZikq4zbpRc5
	 +8hUpnMnyMzj3FQ/xIZnMUcxl1FXXjpO47a7RBOeGa56YUeDlzLP+/P2IeARM+XMK9A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KvugKlDN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.48
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD61D606A31A
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 01:06:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD61D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KvugKlDN
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-7c03744ef27so78080137.1
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 18:06:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792544770; cv=none;
        d=google.com; s=arc-20260327;
        b=quLxkBkCbXdKE7fosLGdBgN9IyRdYC9izH8jyXfUg+CgjljIC4FGJP+ofS5tSEKnGu
         82GeR4xznqnKdroXX37jrqxx/7/b6uVdzth0API26BTLD6EFYB9lhPS5E+a4otkewxAb
         lFmSS+O+sxKqk3jcH5dbB0IOV3FZGNgR0hFkKI4DhlfRTGbSmfxCWfFXsXHeViYcpLRE
         jcjtIr52hGyhaJaOH+mXYhFvoQlAfpcPJbKzNZSwCGJTZBinXjxDNZcQ2P+heA0TYCtN
         InuHSTdJcwtWPgSvluBpGV5NbOwSTcQD39MjA67qdQ6bM8QA+1KZoy1JIJYsRXgL2FFh
         7v+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7BuIBRaFV355G0S8fL9PjcEbMxttXic2m2/XMDLcEKc=;
        fh=BeDyZzmfJH/08kwnYpjYRPPSj2AqmVUYNRCu5IBQv6M=;
        b=Mb6+cYGxtFdJH+OIxZf2k6Dv272dLVzrjmYMBbXngyrSVGxeGwrmKuW/i9EskcGIaT
         ZMMZqMLIdrjxUWw0PjTe7eV4Owgh3tengRhXbPyFnerXhbHbbwIBaHZzZ76KhCC1LZO3
         c2eD0gX2uF0T62cdXaPtVOYklP7Ma7WMTi9ZeM0afpSpFdlEvtQs4lvHXF8AGPXqCG7R
         m7/AmWnTVYcbakUIcMhT67JHBHKuATtmjDozIjwNlUIQqmveAOza2GDaUiUhDPJGMErQ
         tWBBv6BjR6SeHmmqHXlBSL07wqOcAO7aXbKGV6LcyND/zpPUa93pPipc2zKHjjhDV2fw
         2VtQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792544770; x=1793149570; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7BuIBRaFV355G0S8fL9PjcEbMxttXic2m2/XMDLcEKc=;
        b=KvugKlDNmXk/cCY+MwnEEpJnqJooxAALm3jLB7pNUBegi86nxEs4DXjdt1wXoN25f3
         nW+WbiecPk6mPX5dCfVXiW2Ft/msqW+qelQrNITR2VGLtWI4vTr3fmG2v/TKKpTcL2Hy
         2jnFnqb76ltqM94Tiyi/nPjARPwAQfiUJF3bgh0DxBKB9G5gSX1Hpl9JmgyU4pMSfNRR
         aQ6wPigwBEAdptUBZs+bnwr5cGpolM9rDzh1k7TdlniajQ5HJRvMOl5jDNg5sTqE0+KK
         3j91fvCfNdwDpi2EprK8RdZG6tNaJTplpSgYMPEZJ0NhM7Jw86pl+OSVhedqvuqh/yVZ
         aO5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792544770; x=1793149570;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7BuIBRaFV355G0S8fL9PjcEbMxttXic2m2/XMDLcEKc=;
        b=1aTsLaNCxkCDrIOpxw/t+KQM65oZtRyfv2AghaQZDv2Q9SxbHhoFRSodOZH9Vs7tUD
         iprgd+XbU3+EOKmNKqZWdFp9Ut5UL+DxBk8RfWcs6A2rkmvJ703IV31Ajc+Weewi18+z
         33FT1ogEGpH1gF9UtZiCP59GUps8/QwR/pJZm91JmL+JYS4yZTzPqoLHhv645Fof6vvk
         RViE8Bgm3AoRW430bgN9dT500eH0YqLCmOmJFmx359MpG5X1/nQqC8N0WfDAU0EkaUJL
         8KzKuZWnpQcfDtwH5IW0TGX/K7SseSHxWsRvPSMLvUSivhkxHTC4WSYM1fv3gaL4v1XP
         IGqQ==
X-Gm-Message-State: AFq9FYKguxZThdMZpmAj8EJqp7PSBVEFHPRODArP4hvNbcqT2wRh2/uP
	8ktxSMYLYPpEr7yp4d3EJ+hE3zkZ0jpcMMOY6boqa67E2yB/v0UlGgL+GOI/yEWELPfMFzTtV2F
	/W52FhcjWSmH+mwemsLrL58Y5UZPSx6bp5XBzara18w==
X-Gm-Gg: AYBFou0MfALScim7BCane0ynHasN5cHuwRkL2tP1+l5e6PIFs1LDVaKpN7PK54c0hkk
	OVU/bIaF78zJXkeFQRzYsg4RE6H4v/XFBrk7uoVj2PrpiOUu0SKgxOItkw22hbVkjpIzbUFbeuI
	8ZsV7Ax9WNUYOFUuw8blwnKtRSFJo7T0zJ8zYuef2C4NrOMEluHfawTD2laVxUOqj2Lun/T04Bf
	24kcWgDmBlLWtlcmMxji2z3CMWgF79uHuN2W6g9JtfFZMaxevf/SQoTnlWMjWp3hlxFMD7kZGln
	HrUJmHe6Nc5V9r34hoTM29IJ/wYk+ShcrdF4jchKCQfcxVo8kb46Lm+zRoQy28l5CXabTYQRF51
	SS+0pZ5ymkdoRhBUQwB26xHmF6ymrA3J9fyVAZPmSRDILKJcqfDjr9kybWDK3odmjUos=
X-Received: by 2002:a05:6102:424d:b0:7c3:72b7:7fc0 with SMTP id
 ada2fe7eead31-7cc9265d04cmr248159137.13.1792544769708; Tue, 20 Oct 2026
 18:06:09 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAO+rqLhpPvY0NLrAnZjFXz0gOXnA6zsXxK8xCgtA42XUkSsAeg@mail.gmail.com>
In-Reply-To: <CAO+rqLhpPvY0NLrAnZjFXz0gOXnA6zsXxK8xCgtA42XUkSsAeg@mail.gmail.com>
From: mixalhs <mike.michalo@gmail.com>
Date: Wed, 21 Oct 2026 03:05:56 +0200
X-Gm-Features: AclHuK96Iv7sIfj-K6HeA-KwHJZMws-qCNnMG4ml62R5k6M1hxvGPFUJiD8ad3M
Message-ID: <CAO+rqLi_Bh1AFTJqp-Ddvs1Y+sxzq8ULgb_fYWmDmCM3weE_2w@mail.gmail.com>
Subject: Re: ksmbd: Kerberos login fails on 7.3 with released ksmbd-tools
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Also reproduced on the v7.3 release (c03c1a1450): ksmbd-tools 3.5.7
fails with NT_STATUS_LOGON_FAILURE, ksmbd-tools master logs in.

#regzbot introduced: a47634cd729b ^

Michalis

On Wed, Oct 21, 2026 at 2:39=E2=80=AFAM mixalhs <mike.michalo@gmail.com> wr=
ote:
>
> Hi Namjae,
>
> Kerberos session setup fails on 7.3 with the latest released
> ksmbd-tools (3.5.7), and ksmbd-tools master fails the same way on 7.2.
>
> struct ksmbd_spnego_authen_response gained a __u64 session_expiry field
> before payload[] in 7.3 (commit a47634cd729b, not in 7.2), making it
> 168 bytes; in ksmbd-tools 3.5.7 it is still 156 bytes.  ksmbd-tools
> only gained the field on master on Oct 18 (4c0ca83), after 3.5.7, and
> always sends the new layout.  ipc_validate_msg() requires
> msg_sz =3D=3D sizeof(*resp) + session_key_len + spnego_blob_len, so any
> mismatch is dropped.
>
> Tested with a local MIT KDC and smbclient --use-kerberos=3Drequired, same
> realm and user throughout:
>
>                     ksmbd-tools 3.5.7    ksmbd-tools master
>   7.2 (mainline)    login OK             NT_STATUS_INVALID_PARAMETER
>   7.3 (ksmbd-next)  NT_STATUS_LOGON_FAILURE   login OK
>
> In both failing cases ksmbd.mountd logs "Authenticated user `testuser'"
> and the kernel logs "SPNEGO_AUTHEN_REQUEST failure".  NTLM logins are
> not affected.
>
> From the code, 6.6.y, 6.12.y and 6.18.y also require the old 156-byte
> size, so a ksmbd-tools release built from master would break Kerberos
> there as well (only 7.2 tested).
>
> Would you like the kernel to accept the old response size again, with
> ksmbd-tools sending the new layout only to kernels that support it?
> I'd be more tan happy to write and test the kernel side. :)
>
> Thanks,
> Michalis
