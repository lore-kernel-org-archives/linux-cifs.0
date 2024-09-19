Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E5417D344
	for <linux-cifs@vger.kernel.org>; Thu, 19 Sep 2024 11:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726743820; cv=none; b=Rq74gw7G1S6lBoxbQJJ1gvtoeOtqK2jaj2jDODRWGNpVhK+Ufx7JfnQTE8W44fyZnWdqA9FZ+APGJUAVSPGOMLpGfH+msNBekOspqRj4mny0llD/s1+Vo4++6CXJTfC5ViX7CtPPotkyAZfSoxy1dUFNoI6622UzjYNzaQkzcvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726743820; c=relaxed/simple;
	bh=rp5sHeAzHV/aqxiv+Xcm9qKo2e0bTvo/ukMc3Eb/CnU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I8+5QgdSOFD2s39YPpK/9nmGDPlApwYifych5Aqg1UDQTyM24vbREhb67lSLr+5CPnsEXc3u0bLzT01U8BBzjCivEezQemRGeUL5qNsqJuE6FMqAFjTLbLjfzU4S/cmTXNklzm2nw5+ibUKyZNr10cU7tcZcNsi5T/VU4bD0Gi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SXNz4qLl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SXNz4qLl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726743817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rp5sHeAzHV/aqxiv+Xcm9qKo2e0bTvo/ukMc3Eb/CnU=;
	b=SXNz4qLluccSmhLnWgnhBx74kTmJ1UIK559b46Cm86ze/rByzP1euN5EPY8hjSPtyr4EFj
	TCG63ezgiqy2hFfVqUhRnM/pKt74tWzh5QSpQvOcKifH8sAYWKU39HHTrp47XGZCd+BLRo
	70N8Al26bfNiwQXXoBd5+tMCvCWcKzE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-E7N2nNB1PPu264Uwa-8PtQ-1; Thu, 19 Sep 2024 07:03:36 -0400
X-MC-Unique: E7N2nNB1PPu264Uwa-8PtQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a8b6ed71659so47007766b.0
        for <linux-cifs@vger.kernel.org>; Thu, 19 Sep 2024 04:03:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726743815; x=1727348615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rp5sHeAzHV/aqxiv+Xcm9qKo2e0bTvo/ukMc3Eb/CnU=;
        b=Qe/1JiRoV1lc6uaUZ0hRXeYhpj3pv+LPRvoe6dJvxmNdW4vE+uevgO0yiUDdn10lWC
         jrDxe863LjYlbksSa/ult5lwA60flAZhBrVYa7zsMZc9umS9+1muQs3/oiNA2p7Jyol6
         zeelLhChCY7u8xV+fkwKaX6vzeKKuUzaW+P/Rdfj93JiakjuoAHW8M/9fqkw4WSTZSUe
         o1sdfPlNxhtyeQ7LmEY0sSGk9OAS3cpfWpV1jcVqQX4tj5ZiLWsrPx4layZFHjoCjlgf
         o2YLvXMiD/O+9HaCvf2caFjEuKvt2z90XsrorndHXWO02WVWAu2k5Hk419NFgjcVPXyO
         AgIA==
X-Gm-Message-State: AOJu0Yy6Yr4fGbisGYYjGobMHDFMV3MdL/sGaD+T13p7SkLwX8+3Xjsj
	8rYL/hU1EOoAc327d5y2PJxa+S/Yf00Vlbfi5X0k5NXY2/0Y0CUzaftb3x9V3EZ2CVABVlaS5Ue
	0BR/0m5kCW5g1PFY93uJkgtHTxqpwhSmScY2Gj4YebVyegPwEvJI9Q6f7kzSpOem2A7s63B8PvT
	gwgCKhQ1/VTsCL6DbxD7bQpmME41MzzESLKQ==
X-Received: by 2002:a17:907:26c3:b0:a72:50f7:3c6f with SMTP id a640c23a62f3a-a9029432757mr2583660766b.14.1726743815430;
        Thu, 19 Sep 2024 04:03:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWebgv8sCUVvu7Pb1u9FayCyIspEqmA7sUPNWGbnO4Ve/UFa/BlzzP+7/RNDiEFMXekQIBpYyiV3BkP9BQ3Mw=
X-Received: by 2002:a17:907:26c3:b0:a72:50f7:3c6f with SMTP id
 a640c23a62f3a-a9029432757mr2583658266b.14.1726743814930; Thu, 19 Sep 2024
 04:03:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKRryJZs-gXnWCYUXhbjV__OM7T85xpKp9nvPOprJzcOJGX9=A@mail.gmail.com>
 <nfqi2vtpgpvmmix4h2fesil2smneezbhciqhz5rj6dxilh5h3l@eoa6hlabnjml>
In-Reply-To: <nfqi2vtpgpvmmix4h2fesil2smneezbhciqhz5rj6dxilh5h3l@eoa6hlabnjml>
From: Maxim Patlasov <mpatlaso@redhat.com>
Date: Thu, 19 Sep 2024 13:03:24 +0200
Message-ID: <CAKRryJb0nwOZgq_hy3R4+OOnfJkJTua8QTnAEuJud_3jjwwGAA@mail.gmail.com>
Subject: Re: rmdir() fails for a dir w/o write perm
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you, Henrique, I understand it now. As a side note, this is very
unexpected for a unix user who got accustomed to POSIX semantics.

On Wed, Sep 18, 2024 at 7:53=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Hi,
>
> On Mon, Sep 16, 2024 at 03:43:22PM GMT, Maxim Patlasov wrote:
> > Hi,
> >
> > Is this a bug or well-known issue?
>
> I think this is the expected behavior.
>
> When I try to reproduce this I get a STATUS_CANNOT_DELETE from the
> server.
>
> This is from a MS-SMB2 Normative Reference:
>
> If File.FileAttributes.FILE_ATTRIBUTE_READONLY is TRUE, the
> operation MUST be failed with STATUS_CANNOT_DELETE.
>
> ref.: https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fs=
a/386d9ec5-e0f6-4853-b175-c05be01419e0
>
> --
> Henrique
>

