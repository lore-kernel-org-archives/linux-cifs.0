Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB21123EAB7
	for <linux-cifs@vger.kernel.org>; Tue, 17 Feb 2026 04:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771301674; cv=pass; b=ZEGW+m6e/lOk9PHnIVgDc7lMjd2q4naMKAJT6iDa4UXjUnG/bw7x7BhVfIjFRbI3za0tKyghvW6UMDf/dkHeHn6QhyatiYBP4pWrOBt9Q801MDv0bve9EHkdHRfk2MeNuM51EdXXin9X8nvdTOOVlns+VZQsTo8yVya8acQIq2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771301674; c=relaxed/simple;
	bh=vl73Wg7pS+Ahm5P0YPj+Pe00Z8nc8FXlY1ga54JpjGA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RloOgjXu5n9xMYsalaM0y4q8ap373OgXz69BD1T8y+2IFoQoV+XA9TMAjm0Cf/6/iVYpcfYjSLJ2GI8YRAPgDFyuQHDkbVieMn7ivgkQ2zSnYKk+AzIIHV4imXK9+Cnf5iFMa0KVX3eblYbzeOWMeLN1lA06/5pxC97hAoxaTtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=frU9r1aQ; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="frU9r1aQ"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-65807298140so5735946a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 16 Feb 2026 20:14:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771301671; cv=none;
        d=google.com; s=arc-20240605;
        b=J3926cMNVDdZg3Sg9Sga9TKanzgd0OYrH1gIHiBkLcvHCM+yjVk/hSk93LzGA+57UO
         i28L+kBcIWM3iD2LwyM8RjNNPxAWQBFAD8tHXA88tuQ6+HHZhu2zMfytTuJxl3N162Cp
         MlD0XsblEwAlX9ORKO0AAuTfWzvZzjf8Z6Fan9MBa2Tjm+M0skHH26HjNBur2uttpN8S
         0tkyzMGyp2STOWjCwSbRKRGZUCstszL+MXcjR3Ll5wAXKU+dNceq2a141IZONWgLZr9E
         FAyPwC1ir91snJw4LXvvCaqUJjkfS9rsdr8lVKwQgfygVGUaBtPgMUy2/yFmKqkf+u71
         aSAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vl73Wg7pS+Ahm5P0YPj+Pe00Z8nc8FXlY1ga54JpjGA=;
        fh=LCvw48C4oY3eJKEWCrsE/pg/00TzVvAEvW+2/2FYoGk=;
        b=HTYzsPa8F2ABQ24vjB5iMosNS3ESfMXFsxer3v1tczKg5xFkcrT1jqFZOhUsj9F/9e
         pUWYAhz80zSVPrhpjlAvrrT0BT2VmFUAotcBcokpuohHMBjfLpRI3UdJrZnVAu5P8N21
         M9DxW72NZMnCix/4W9QUR+snOmXKJ1f3JVnEfLBaWZrvtVjcBl2lLj3feQzyBrwGQLEN
         gW9SsyBmZR5ut8TY/pJCThMCFhcVdJyzytcumE9xewP086QAmh3YtyXJxhzF8l/qEXRH
         D+SwjqNGA3nVEJ4CKIhGn/kAjbB/2ojGt2rNATd4LXHi/68FBLBoSx6k9noKyju/r5fL
         gm9A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771301671; x=1771906471; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vl73Wg7pS+Ahm5P0YPj+Pe00Z8nc8FXlY1ga54JpjGA=;
        b=frU9r1aQzw4+qVjkdlz0wFF4WcsZnuG+7GoE6RmXGgXbKH5XyIT7YRYi9o9kywK680
         MpfuggRA0eNfMF06O8JKzkVMLPJOTPX6TOrjP7n2dos/DC3PfBCyWuuy+Wz+3nSf/KSC
         SXY17n5EqmA1q77NyOBul2ZYU3Sl3jz0wmtro3G+8KT0cXL/bWB1pdvfahwXdLmil/F8
         TsrENVvZnaQdWGghHJebwx1gx1uaRS/fNqOycVBM7LuMPAKcyj66FZHuHiebHgmLkojB
         6KO/FCE/O/yFVjILTpjMcHbEHNVPPgTJLXEtNn9k/KAy9y1mAOwQDjCkmTv7kx4vLLZt
         qBJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771301671; x=1771906471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vl73Wg7pS+Ahm5P0YPj+Pe00Z8nc8FXlY1ga54JpjGA=;
        b=PUXFIasGmjprWiy7B+43WyGScoZBpLFh/z0MGBjXM75iJRXYI6sgSRH5gyakz/Gt6H
         cA4zPCBuvKYc2QpvE1tltpw0TBSfPOh8WPSHtJY5JebkAgEdN5L8XwLCNMFPHGa7ZUeP
         F+4iYt8ShCSny6QVG3Q4cBNty2zMw+l9EzbllhZ0qGmYP9em+GzCZe3jFlfEvEeMlV7/
         /j3HahhyKTzL9wQnjVNvc0W/15SDMRMldgLpdF8qF4wLcfn4k96LO5TFboCifLgzLYos
         UdTqN4+xyocQ7OV5SbZqDSgHYmqlcDhMHh7sxqZzC+0coZCBd0Ie+EYcniXup8Xq0sEy
         E/Eg==
X-Forwarded-Encrypted: i=1; AJvYcCWvSQ+XdXjPbLG0oNYcX4md2ne1uxjpdafdhQxFlSlTR1L8qQntxD3BuUN1hFpEQaoQ9l0NCUrvtFgO@vger.kernel.org
X-Gm-Message-State: AOJu0YzIBhvqwuWQELH94NebEL4JF1zPGOThpNccWcYVOYZwMt6ToStV
	NWpX+9SCDHUinhWnLSuBg6lWI2WS8VIUAIc27+KDlK5TRWZ/B6YmFHDfO9a+KM8wlNM2grQQvV3
	Tpoun3Hjzi4DHCBf4mve7EkHNKiY2bak=
X-Gm-Gg: AZuq6aIe8PAseOAzmjH8jLPxn6uraElVC1aOs8blnG/QPh45sh366Opm17CWgaNaxMU
	eq+JQk1yH3VumeWXPC6oDxe5GlBNfA2KT08n95yPr+/X0Df7Im5cTX9AMS6r+P4hDRPtMuoqffg
	I0QahfLb4tOhirXHOddRR0MrhtsA9ERjJx8aXSVvP7bdOqOJBLZI3/ccBFeptM711i2E52+uBkj
	Jpl+EZJ3n3fbvCwboO/E/UupZ2hIRMG/vq7AOowpLJyEjQKzT2LSYOoOY34k0pgCdd9rvoDWInz
	apSxJQ==
X-Received: by 2002:a05:6402:278b:b0:65a:409c:6fe6 with SMTP id
 4fb4d7f45d1cf-65bb1161199mr6549992a12.15.1771301671063; Mon, 16 Feb 2026
 20:14:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=rDxeYKXoCJoWRwGGXv4tPCM2OuX+US_G3hm_tL3UyqtA@mail.gmail.com>
 <7570f43c-8f6c-4419-a8b8-141efdb1363a@app.fastmail.com>
In-Reply-To: <7570f43c-8f6c-4419-a8b8-141efdb1363a@app.fastmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 17 Feb 2026 09:44:19 +0530
X-Gm-Features: AaiRm52qcDduH0WOoiy86XQ-uP4UAzjzDBGWAMpuxDVbnPDCNM8VzO-fhxMilbY
Message-ID: <CANT5p=rpJDx0xXfeS3G01VEWGS4SzTeFqm2vO6tEnq9kS=+iOw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Namespace-aware upcalls from kernel filesystems
To: Chuck Lever <cel@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, keyrings@vger.kernel.org, 
	CIFS <linux-cifs@vger.kernel.org>, linux-nfs@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 14, 2026 at 9:10=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
>
>
> On Sat, Feb 14, 2026, at 5:06 AM, Shyam Prasad N wrote:
> > Kernel filesystems sometimes need to upcall to userspace to get some
> > work done, which cannot be achieved in kernel code (or rather it is
> > better to be done in userspace). Some examples are DNS resolutions,
> > user authentication, ID mapping etc.
> >
> > Filesystems like SMB and NFS clients use the kernel keys subsystem for
> > some of these, which has an upcall facility that can exec a binary in
> > userspace. However, this upcall mechanism is not namespace aware and
> > upcalls to the host namespaces (namespaces of the init process).
>
> Hello Shyam, we've been introducing netlink control interfaces, which
> are namespace-aware. The kernel TLS handshake mechanism now uses
> this approach, as does the new NFSD netlink protocol.
>
>
> --
> Chuck Lever

Hi Chuck,

Interesting. Let me explore this a bit more.
I'm assuming that this is the file that I should be looking into:
fs/nfsd/nfsctl.c
And that there would be a corresponding handler in nfs-utils?

--=20
Regards,
Shyam
