Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3CF286B9
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jan 2024 10:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P9ovUy9g"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-50e78f1f41fso1492806e87.2
        for <linux-cifs@vger.kernel.org>; Fri, 05 Jan 2024 02:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704452306; x=1705057106; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gb44fTIgEdi0yLr1EDmBghItXqfgERfBvFUpqork+jM=;
        b=P9ovUy9gI5T/TUtCKyVcPOxbc4GDA9F1CklpH3IRzf2zvQWqI/pHl7JfbqT+4TDgN+
         55vi8KHn/fEGUXJDX89MsFNsZ/yXI4ZI/Gedjo2UR0XjJEBg6O/yEcCde393+E7U3jF8
         RTQPBAPWOaGyknQ05K6Yt0m4ySf72XGvXb7kVPZm/5EOHkYY7JH3z6PdEXf+a53bPwTe
         tEPsoqmfEgrviHiEE92cKV3s/O/G9fPc3GyA0Znxl1ifn9OTMbp5HDff21xT/sEDdaLX
         UlwviNmwilE1WRqcZOKSSlquSBzekvTqukoyJh9C1i7tBprbLWBoe272KbmCVs+aHm4A
         b41Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704452306; x=1705057106;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gb44fTIgEdi0yLr1EDmBghItXqfgERfBvFUpqork+jM=;
        b=vUibnwvxLhvOo4MU8ODjyH4l3in3DFscA1KvMSpeSYePCohYnvFsS6Ow3XhTiTGnNG
         A2qmcgOihb4kAFGCwRLv3w0C1toPQZTvxTcQm86/AybhvYE4TzZ3sSozEuqJk6FKluUc
         vDvybrBxKhQHjXXFie57KjrVo1XOIUb6NM7K8JWhhS9QiGMH+gKT5oC5XwQGsRQCf+i0
         F4TPzH2Qh/+SEkxaVlAJF0GIC2dwZYId7yMYmlm/zcTPv1Eeq2eJswSxQq7pCNvuFnHK
         eqSUQIoB23MTjt0r/vCbJ5MaBMZBaUFFQ+x6q7sAjfswdmcFnTTOpWsuyuKQmlMKzjIp
         ceSQ==
X-Gm-Message-State: AOJu0YwCh3+HPfF+xVuUslAIDfO8tXm0ZIZVLBmBL+PPPIDNbwLtOycy
	kj1Lr6Pg4lscbe89jf97q7Gf1be4usUrFolvdaQ=
X-Google-Smtp-Source: AGHT+IE6ct4zrcBkfNLJVtjXK/Z7EmGqAPGLuSAbL/hbTvhyM16GZBdyioYdCVXUPAAIFpcrSThNCFwJYK//XentTk4=
X-Received: by 2002:a05:6512:685:b0:50e:3904:4f0a with SMTP id
 t5-20020a056512068500b0050e39044f0amr1185633lfe.9.1704452306138; Fri, 05 Jan
 2024 02:58:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229143521.44880-1-meetakshisetiyaoss@gmail.com>
 <20231229143521.44880-2-meetakshisetiyaoss@gmail.com> <7e61ce96ef41bdaf26ac765eda224381@manguebit.com>
 <CAFTVevWC-6S-fbDupfUugEOh_gP-1xrNuZpD15Of9zW5G9BuDQ@mail.gmail.com>
 <c618ab330758fcba46f4a0a6e4158414@manguebit.com> <62eb08fb-b27f-4c95-ab29-ac838f24d70f@talpey.com>
 <CANT5p=qqUbqbedW+ccdSQz2q1N-NNA-kqw4y8xSrfdOdbjAyjg@mail.gmail.com>
 <242e196c-dc38-49d2-a213-e703c3b4e647@samba.org> <CANT5p=oFxQEB5G4CzVuJBkg76Fu-gqxKuFdYJ8NCnGkS-HhFJA@mail.gmail.com>
 <aee2e001-a1a6-4524-a897-de293ef1c034@samba.org>
In-Reply-To: <aee2e001-a1a6-4524-a897-de293ef1c034@samba.org>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 5 Jan 2024 16:28:14 +0530
Message-ID: <CANT5p=rB4dtk7jp3cP9Wda4J2eG0HcEjGDOt9SCOpx=ho8DzRw@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb: client: retry compound request without reusing lease
To: Stefan Metzmacher <metze@samba.org>
Cc: Tom Talpey <tom@talpey.com>, Paulo Alcantara <pc@manguebit.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, sprasad@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	sfrench@samba.org, Meetakshi Setiya <msetiya@microsoft.com>, bharathsm.hsk@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 5, 2024 at 4:08=E2=80=AFPM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Hi Shyam,
>
> >> Maybe choosing und using a new leasekey would be the
> >> way to start with and when a hardlink is detected
> >> the open on the hardlink is closed again and retried
> >> with the former lease key, which would also upgrade it again.
> >
> > That would not work today, as the former lease key would be associated
> > with the other hardlink. And would result in the server returning
> > STATUS_INVALID_PARAMETER.
>
> And that's the original problem you try to solve, correct?
Correct. I thought you were proposing this as a solution.
>
> Then there's nothing we can do expect for using a dentry pased
> lease key and live with the fact that they don't allow write caching
> anymore. The RH state should still be granted to both lease keys...

Yes. It's not ideal. But I guess we need to live with it.
Thanks for the inputs.

Steve/Paulo/Tom: What do you feel about fixing this in two phases?

First, take Meetakshi's earlier patch, which would fix the problem of
unnecessary lease breaks (and possible deadlock situation with the
server) due to unlink/rename/setfilesize for files that do not have
multiple hard links. i
.e. during these operations, check if link count for the file is 1.
Only if that is the case, send the lease key for the file. This would
mean that the problem remains for files that have multiple hard links.
But at least the hard link xfstest would pass.

As a following patch, work on the full fix. i.e. maintain a list of
lease keys for the file, keyed by the dentry.
This patch would replace the cinode->lease_key with a map/list, lookup
the correct lease from the list on usage.
This would obviously remove the check for the link count done by the
above patch.

Reason being that we already have the first patch, and I'm not sure
we'll be able to work on the second one soon enough.

>
> metze
>


--=20
Regards,
Shyam
