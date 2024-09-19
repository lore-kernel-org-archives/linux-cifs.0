Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAB819D08F
	for <linux-cifs@vger.kernel.org>; Thu, 19 Sep 2024 11:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726743979; cv=none; b=rJ5AQfz356QeRNpn+R63pKFjNSF96vB+Gogu21pRZv8P4bWQi0vjQklRgxul7kzKNEXg31Bm04o/t5zqG2yTO2r3NJ8l3L1Z5GQzlYkGxxsQs8SKGzsB9NVOIbMl2U1hw8Veil67TxEqupc28iy2G2gQ9vPmUubEyMDpK765F0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726743979; c=relaxed/simple;
	bh=XSP8xJ00zRFpFaJFDidFJU15hZIGJRobVxO6j5KPho0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oozSXSvXL5NxrRdg2h6PcuRyZrDINQ/53H7UrxdjmTfbxPKe5led1qJJDMdTgHl9cEH99VZgRu6bjatJHYRbNcRiJx/e6ajOFPR84/WFqSSALT7JMHt3RGNaIbuV2+vT640KKo+eJwT3VwL3zDsJNwJHpnLUwy5mf/XKnZiEO24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CtKLPYUl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CtKLPYUl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726743976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XSP8xJ00zRFpFaJFDidFJU15hZIGJRobVxO6j5KPho0=;
	b=CtKLPYUl4j3+fFaUuDGFfWGA02YXOMIECaFCLiM/ucyEq9+YxxQzXJsbdlxqYwwkzNbsbz
	3t36G7obuI6nEIKZ7Gej27ZJ+WAfR/n8pTiWEQdQALEcKkMbDRvTwiL78rV99vmp55zC9/
	H5yH5oY4I6L5bBsABvUpNLhquhb1zQY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-FPWA4X7GN2mv4keFvV3Z9w-1; Thu, 19 Sep 2024 07:06:15 -0400
X-MC-Unique: FPWA4X7GN2mv4keFvV3Z9w-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a8ff95023b6so50845966b.3
        for <linux-cifs@vger.kernel.org>; Thu, 19 Sep 2024 04:06:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726743973; x=1727348773;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XSP8xJ00zRFpFaJFDidFJU15hZIGJRobVxO6j5KPho0=;
        b=MJggUfVoQtK5jSDGNcDommd8QpJr2QPHV8Jr2SHjlgZQNHN7mAxH47F640fQTHETKh
         wFmVySp3lSHkuy+AIdybFN5FHrT3ZF4hXViEfmD5S1KDdeBmHbg+aezxOAZEl7G4e0tV
         2/iKnAe9mGv1VoZwSc91Y1BnnbDezmGFkuhuJhKaErsEGxuuM0jj17FJ+VCafpBJRdPs
         DjFumrJtZTeiU3RkwMbGbQeSSQ9QAY/EQmswFIejcuAv7DRjdkxMUCSRdUiJGxqPVBL7
         0vJdwG4q8QN4V4uPC1U3DGyNNlUmRmA5lVbZJ+uzO+AtQfEwLBIR56JehdCVvJphN2Am
         jS2g==
X-Gm-Message-State: AOJu0YzD2m5VRWozDU2dYQZoXzObmK7Vx4x1ECuVoRCfb33sXG3AcJdF
	ef/M+RDfQ1HkFq4QFRo7sY2EoIAkG7BmkBRqtqH3uLY04bqTRbtmVDysp7TY2b5wvXh/ZDEU4xX
	j9PeVqQYOuKyk+22vrR/GQeGyVktd8QuOgUqSc/90hn6+GIeqYVAJak7TS3sHMxPThjZNu7d9WK
	Bdj850cDSBBdV+DFNQk5PeJqxutt1OPY6vTMzXojwKWmgEVtE=
X-Received: by 2002:a17:907:e29f:b0:a86:7b01:7dcc with SMTP id a640c23a62f3a-a9029435ad1mr2390208366b.18.1726743973419;
        Thu, 19 Sep 2024 04:06:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHIxW9SoaheOZUqE8BDnp74IwserWBz8HuAhBQp0VmLWPEvYkVV5NoKyl32j0XbSla3+kINvRaQ+v5hJao7II=
X-Received: by 2002:a17:907:e29f:b0:a86:7b01:7dcc with SMTP id
 a640c23a62f3a-a9029435ad1mr2390206866b.18.1726743973021; Thu, 19 Sep 2024
 04:06:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKRryJZs-gXnWCYUXhbjV__OM7T85xpKp9nvPOprJzcOJGX9=A@mail.gmail.com>
 <CAH2r5muNdy1QM5qjfA_G4DamuwqhYi2gGiaBqOhWm7ow7dyvDA@mail.gmail.com>
In-Reply-To: <CAH2r5muNdy1QM5qjfA_G4DamuwqhYi2gGiaBqOhWm7ow7dyvDA@mail.gmail.com>
From: Maxim Patlasov <mpatlaso@redhat.com>
Date: Thu, 19 Sep 2024 13:06:01 +0200
Message-ID: <CAKRryJZmi9mg5J_Cv76v2D6pCt=MSFvaHpYV_LXVdXXXVb93Fw@mail.gmail.com>
Subject: Re: rmdir() fails for a dir w/o write perm
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Steve,

> It worked fine with me (same local fs or mount) when I just tried. Which server did you use?

I used smbd coming with Fedora 40:

# rpm -qf /usr/sbin/smbd
samba-4.20.4-1.fc40.x86_64

Regards,
Maxim

