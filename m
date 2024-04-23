Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0871482E1
	for <linux-cifs@vger.kernel.org>; Tue, 23 Apr 2024 11:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713872501; cv=none; b=rmpau+cPAy0ul1V4hf3hY/6QCsV3LFDT3+mtm3TQ95GhR4mAC2qJxcjwbATlA0gg9YkBjNKgTKNEL9OdkaZ6g445bbiAAG6Xtys80Yg1087d1y6D1rtYUd2NTdnx1aXBiiRPZW53J07+roVjwFjt0MigmO+Yn1LQtggkHZi18GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713872501; c=relaxed/simple;
	bh=Fca4eWyF/0yuN3WTyFQWpWpOlZrUa1k/Wfc74bzrMFw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mm/gh+gFwVcadPJJgJL/SczJTrtCkiCveFQIAHbeJMo4dw6s4QSoIXrE328WciUChteUVtzkd78+7SqBG8TRuMb0MzjqFDGWGSAVTNdeRiQ1ObQy1gApTdudOTsI3nockIKH+oYsgoGKCOzdIGQM7bKmAmY9PIsvq/oC65d20MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W7MvGRCK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W7MvGRCK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713872498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fca4eWyF/0yuN3WTyFQWpWpOlZrUa1k/Wfc74bzrMFw=;
	b=W7MvGRCK5TNopy5lp0rquKQPa+xgjioIk1pd76eIIld2hduhMIqk88RS6bInS4bSoCgE37
	DGQk9h5Ld+F2p3cDMAWenoIfyUZT0MrJlfM3b/ra6E2jZONIOjMuudZvIX6Po5LhH1s50Q
	bASjsoRsQvCoft8gIcPqWCfNn/IrUIc=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-tBxBtCEvNtypjZ0xfcU9rQ-1; Tue, 23 Apr 2024 07:41:36 -0400
X-MC-Unique: tBxBtCEvNtypjZ0xfcU9rQ-1
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-de468af2b73so11014027276.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Apr 2024 04:41:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713872496; x=1714477296;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fca4eWyF/0yuN3WTyFQWpWpOlZrUa1k/Wfc74bzrMFw=;
        b=C9zzxk8YqFQzmcELNLk9s/kdsdXxF8nzNwf8RemdeVfV/Ks1CAXdnwfMcV9CpSntaz
         6d6PNsYvLpFYBwdZxrYKlQo381QzvoRxLBnSX7ojHvlGXO88CWj6NR7bOJcQHMiBZEaQ
         9fb1JnhO3Y0ZpKg48tG91T8eIcBejzFSArPeSl1r/wsscNHQQi8/tKazTlsoBZAYyEBb
         UfTaQAjNZ+zKBiqRA2axh7KDea8Lry1vjtF5D04FtRxVfWxv5ybi2H75FphmBVv5q4yr
         PF7IL4HNprt5KooeE0xW63lRemzObhYP5nOFD8x0dGyXcvwpnOGXUCck5/NwxQ0hlhlS
         7dlg==
X-Forwarded-Encrypted: i=1; AJvYcCU/5n0HDxFk9xdtsNrt8qMOuCG8yJ4k53NmxeBeHKKgAbEEYzDMuAI7Gg8FRf+MTIbLAEwP0f229pCaTjKq7tm9sOG1DnZsJ45fZQ==
X-Gm-Message-State: AOJu0YxF/MkajNlSsSmkSbARcIItV/V1E3yv3H2IQ9UzBUVmV1kDOw2w
	ZOJP/wpf+emnYlqgsjix+VqLj7uQwEC9z/G1I9odejoWhjPY8d6ezgg1XnUZvoAAU4DokaRAtUX
	ZVQNOTW8C8r+HHagsi0BwHt/jitWJD6keeOj3OhYzBeuYmj2DM16Ux87WRz3HS8HqG26WX2SDi7
	F4QPx1bODlcTJDQ6Ss2MpccPM+GhWlOvv3Zw==
X-Received: by 2002:a25:d851:0:b0:dd1:40dd:6631 with SMTP id p78-20020a25d851000000b00dd140dd6631mr15457167ybg.3.1713872495989;
        Tue, 23 Apr 2024 04:41:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEJp5QOJ47xPS8hTf667HN00Az+mNeJJwOUaw+LronorYXOoDLAmyYv+KrpQZgrAJ0vh2P7pzGPtOdL55AqkQ=
X-Received: by 2002:a25:d851:0:b0:dd1:40dd:6631 with SMTP id
 p78-20020a25d851000000b00dd140dd6631mr15457150ybg.3.1713872495595; Tue, 23
 Apr 2024 04:41:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403052448.4290-1-david.voit@gmail.com> <20240403052448.4290-2-david.voit@gmail.com>
 <80e09054c9490c359e8534e07f924897@manguebit.com> <CAPmGGo7XogXA8RppeqOtidWsgL84u+J4SUB7-st=A9a2ooPriQ@mail.gmail.com>
 <CAKywueRW3PoAJcfwPWANh-oJeop6VP6BXsSMVR1Xq2LcTmXKDg@mail.gmail.com> <6cf617eb193818174f91ccb1a969045f@manguebit.com>
In-Reply-To: <6cf617eb193818174f91ccb1a969045f@manguebit.com>
From: Jacob Shivers <jshivers@redhat.com>
Date: Tue, 23 Apr 2024 07:40:58 -0400
Message-ID: <CALe0_77OG0Qq+SW+mC93-NmWvE11P-nSCMTf1aELfX2caWDHSQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] Implement CLDAP Ping to find the closest site
To: Paulo Alcantara <pc@manguebit.com>
Cc: Pavel Shilovsky <piastryyy@gmail.com>, David Voit <david.voit@gmail.com>, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2024 at 11:10=E2=80=AFAM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>
> Pavel Shilovsky <piastryyy@gmail.com> writes:

> > Jacob, Paulo,
> > Thanks for the testing! Let me know if you want me to add
> > "Reviewed-and-Tested-by: " tags to the commit.
>
> Please feel free to add:
>
> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
>
Please add:

Reviewed-by: Jacob Shivers <jshivers@redhat.com>

Thank you!

