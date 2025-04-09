Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE46278141
	for <linux-cifs@vger.kernel.org>; Wed,  9 Apr 2025 18:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744224217; cv=none; b=MPQdIsVpJqyoHqPBxjC/JcrFS+Ut9o+NsQ+0ZxhatSm7ORIWqh90vKro0p3Py1fCLM5vPBOph2u84wGJb/pnvmdKrfB/7ruH/k13SvK60SJcBZD9VKkCuu5bZSkshVTz8vI+G+/ZhFOfTy5II7M0BtVfvZUFcHUuOwCo7VgrArk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744224217; c=relaxed/simple;
	bh=KI+q2kvMmfaLgOCyijeyDo0KbIaH3kgvfEiUwxaYxrA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZxKayauUrzepo5b7GfP9Xi6rnVDCOO7f743ABaCfssMGLH4Dv80M83IUufgVuxc9Y9M1Jl08wYBNwB0jmiViTdm4W3aYuxZ3e9NTw64Zi9TVE88FO6lgbmmnV8chgLDOt3P8ZuAGxe+KCUe6ieGcDMleFQIKHFO30qYvecci2r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nkq1pWNy; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nkq1pWNy"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-54b1095625dso20427e87.0
        for <linux-cifs@vger.kernel.org>; Wed, 09 Apr 2025 11:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744224214; x=1744829014; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KI+q2kvMmfaLgOCyijeyDo0KbIaH3kgvfEiUwxaYxrA=;
        b=nkq1pWNy/yByglg9i82e9MhVYsoD/0kaT1gluxeguiVe1kZi9MEbyW71tJdWn+R40+
         aoMPbNNsGHZ63JFub4pxbqRJkmWz/6n/51hVfgx1CwFj5tCthynREFfQsSYSfgMyXqYA
         WSIeUVla8WMbHMjdoErZSLUY/rBNas1PDsMtb01LYPrS2WwYR4CxELW2/HPknFY1S/hJ
         gGAbNwmxiasIXVohUxeHT4k3YmpWl3ZW/c37FOWYVIQGydz99hcnfLVH42frcRqsjG2n
         Vlw3awWBBO6Rl6/qjajJwgiRpwcrxo9CrjZzO9rGEcoicjPtBr5VaXrzRQd7BSN6g7S4
         DaFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744224214; x=1744829014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KI+q2kvMmfaLgOCyijeyDo0KbIaH3kgvfEiUwxaYxrA=;
        b=pnKuz+bgYj+7GmqDTJqWA0+eIt5LgDTUb/9QdrfaHEwcrULHhMXEEoQpiFyQpWLQIy
         gpGUw/8yK70VglxYJVhEQoGv5gUg3UH7YLmOnUjK2st57YzefoEUibTdYrieggZRRXoJ
         /XEzPCCD/NvA7GEY2y8WiaKVrh6UpJUX/vuWQc5KN4+F5sf8nECdwAkhhMO0hw+jGuvS
         VaF63S+9/zKYVWXsERZ+Ufip8mbmcpAKHt0VQE9Nno5uoxMZNb+D6RFi/8rjOpUjSUni
         rhM/UHfdIQEKUcg28vZ4Es98Qz050A5azZRy6vPUKFO4ittqTznTaWFw1DVzp3ysuikl
         BK+w==
X-Gm-Message-State: AOJu0YzKEzN8iS9RYd8UgJtIX6TSA9FTKetLHOH+JljMxzR9ATBlkHW1
	A/wkqUj0/nrK9ALoK/5t0a0FU6IYETrYILjzjLIpQg6c3Y6gNuNDNOSiD1s2L5qV5DEIKMC+0yv
	eCbxwKdpa1Cor5Wqv+s78kWwOLX77Ug==
X-Gm-Gg: ASbGncuTq81FjCy6q1Y9vd940Ms/wkU7OU+0yDODGqPpDKgsb0/owJaVCGVp5b8tIcZ
	KKUHcNk/whdQdHXWawqmjXIc+xlKO+Qlx0LGmVAZrnfzDTrxmKo0YqfbxYmWXusrXR3S2AiCi7O
	7mvmpU2cgXvFrVZhdhKUm4w7KdW/z/3ozZ2LLt5xRVZpswRKJT9l0E2A/sVLIYV4W+9Q==
X-Google-Smtp-Source: AGHT+IGqEJc93XgSpk++HFKE3x1gUUjAWlTToA2x2cjL5syEO8ILQlQlP2og+SZ5/qTrupg/ejPZ+tkj93vq8CHqHlA=
X-Received: by 2002:a05:6512:1152:b0:545:225d:6463 with SMTP id
 2adb3069b0e04-54cb6880beamr5549e87.42.1744224213432; Wed, 09 Apr 2025
 11:43:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
In-Reply-To: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 9 Apr 2025 13:43:21 -0500
X-Gm-Features: ATxdqUHQJ71Tiq8r-QtDsPvmolxGJ91VK8m1pKT8yIzFPiSR8xgdg4iI8eYHj0A
Message-ID: <CAH2r5mt2032HC_yLrqGoAY-J6JZfP_2zjOjoKiY92YUrxBiqnA@mail.gmail.com>
Subject: Re: SMB3 POSIX and deleting files with FILE_ATTRIBUTE_READONLY
To: Ralph Boehme <slow@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, Tom Talpey <tom@talpey.com>, 
	Steven French <Steven.French@microsoft.com>, Jeremy Allison <jra@samba.org>, 
	"vl@samba.org" <vl@samba.org>, Stefan Metzmacher <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 9, 2025 at 1:18=E2=80=AFPM Ralph Boehme <slow@samba.org> wrote:
>
> Hi folks,
>
> what should be the behavior with SMB3 POSIX when a POSIX client tries to
> delete a file that has FILE_ATTRIBUTE_READONLY set?
>
> The major question that we must answer is, if this we would want to
> allow for POSIX clients to ignore this in some way: either completely
> ignore it on POSIX handles or first check if the handle has requested
> and been granted WRITE_ATTRIBUTES access.

I agree that to delete a file with READ_ONLY set should by default require
WRITE_ATTRIBUTES (and delete) permission (better to be safe
in restricting a potential dangerous operation).

But this is a good question ...

> Checking WRITE_ATTRIBUTES first means we would correctly honor
> permissions and the client could have removed FILE_ATTRIBUTE_READONLY
> anyway to then remove the file.
>
> Windows has some new bits FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE to
> handle this locally (!) and it seems to be doing it without checking
> WRITE_ATTRIBUTES on the server.
>
> <https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/2e=
860264-018a-47b3-8555-565a13b35a45>
>
> Thoughts?




--=20
Thanks,

Steve
