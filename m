Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FDB56442
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jan 2024 21:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P17I2cxE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704750620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h3L9Ms3RJbkhDRpENMDIIkYxze9oX7IYZ5aUjYfsps8=;
	b=P17I2cxE8Ijp+ve3OqPoIjQq4xz2PheqvzOTVja1FR6BgR+E/Q0+OP9vIFmHxemuhAfXZE
	yAOl/pP6oAqxWNJHONBgr7NoH8kOH8BMnx06GlSilH962NpL90ArPT5uvQ2kZ0EOA2FLyH
	fFyAW6p0pbDxoK36i43MQh37yZNs7WI=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-1RGEkE0AOtqTrlrTZuVunQ-1; Mon, 08 Jan 2024 16:50:18 -0500
X-MC-Unique: 1RGEkE0AOtqTrlrTZuVunQ-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-5f240ace2efso29370757b3.1
        for <linux-cifs@vger.kernel.org>; Mon, 08 Jan 2024 13:50:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704750618; x=1705355418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h3L9Ms3RJbkhDRpENMDIIkYxze9oX7IYZ5aUjYfsps8=;
        b=V2GNPRHnxsEUSw12/sPhGu3Hg0xksT7ehni6aIOAtOzk3O/lY0zICOlzVQQsXSHXEP
         juwWeCYgIhuGMnngOKzyIGKUhpjMrJMdzm6O9195RnOlfcDulsQiOvl5G8z8UXphx9ny
         tD3JBkkfHIp9vA71s5E/rEXpt4T9g4NTWMDHssH/9s3fgmmG/50P8phLNRq6VAmB8id/
         dcMq7C616RS26ZybvHHkfGTnjY+r2p8BEJrW+QIoi8p2dNPzeavJ2yz5OauwFT2XfAgK
         op2EQAH50S/HkVrNF2l+710jk5k/iVX9V2U1Zr5zZ13R/yQprMPy22ByzF6sDYzwN+c6
         IHrQ==
X-Gm-Message-State: AOJu0YxeNB7KvSrUR64Hrk4vm+OIzerXvt9wNYNOaHYcSVx3mNfMHYoN
	QMMlkgcTeX3469AX1+AXdKw/InL93JkrjfK6I3t8y+Rvc3Y0FOuDiXnnQgZKGG1NLvAYqFrBFjg
	I9PabUlCbQURv3xaW6V61jUmuRq/ndjEhZzWkZuDNpyFkktdEehQrp1vP
X-Received: by 2002:a81:4742:0:b0:5eb:29e:45a3 with SMTP id u63-20020a814742000000b005eb029e45a3mr2758877ywa.32.1704750618189;
        Mon, 08 Jan 2024 13:50:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0mjHn+eWP2TDMMlnHgtyr6G7HK36SREVu7O3klmm/rR5VIOWgvJQG4p4WgEySWe6CPqFJQ0L1ReKsmKeeIbI=
X-Received: by 2002:a81:4742:0:b0:5eb:29e:45a3 with SMTP id
 u63-20020a814742000000b005eb029e45a3mr2758873ywa.32.1704750617915; Mon, 08
 Jan 2024 13:50:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALe0_77CgEXNiXrM4oQ47sfHnDoML18oz5rmEu-_57Av0KRTkg@mail.gmail.com>
 <20240108181751.natpy6fac7fzdjqd@suse.de>
In-Reply-To: <20240108181751.natpy6fac7fzdjqd@suse.de>
From: Jacob Shivers <jshivers@redhat.com>
Date: Mon, 8 Jan 2024 16:49:41 -0500
Message-ID: <CALe0_777GL=XQYSochOoph73madKm8DsRn+xQOcTmz9xh+wcHQ@mail.gmail.com>
Subject: Re: Linux client SMB and DFS site awareness
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Enzo,

Thank you for the response!

I failed to mention the initial aspect that is specific to mounting a
domain based DFS share. This would contact a random domain controller
instead of a DC local to the calling client's site, should it exist. A
CLAP ping like that used by SSSD[0] could be used to identify the
nearest domain controller prior to initiating a subsequent mount
request. This is where the DNS discovery for a ldap entry would be
applicable.

Hope that helps to clarify the use case.

Thanks again for the response.


[0] https://docs.pagure.org/sssd.sssd/design_pages/active_directory_dns_sit=
es.html

On Mon, Jan 8, 2024 at 1:22=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de> =
wrote:
>
> On 01/08, Jacob Shivers wrote:
> >Hello,
> >
> >I have a use-case for a Linux SMB client to mount DFS replicated
> >shares, with a preference for sites that are closer geographically.
> >DNS site discovery/awareness exists within DFS[0], but I have not read
> >of any work currently under investigation.
>
> DFS supports referral responses based both on site location and site cost=
ing,
> which are done on the _server_ (MS-DFSC 3.2.1.1 and 3.2.1.2).
>
> For site location, the targets are sorted with targets on the same site a=
s
> the client first, in random order, and then targets outside of client's s=
ite
> are appended, also in random order.
>
> If supported and enabled, referral responses based on site cost will, pra=
ctically,
> sort the targets from lowest to highest cost (relative to the client,
> and in random order if same cost).
>
> On either case, the client will try to connect to the targets in order
> it was received.
>
> >[0] https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adt=
s/7fcdce70-5205-44d6-9c3a-260e616a2f04?redirectedfrom=3DMSDN
>
> I don't see how the info on that link would apply to this particular
> scenario, as doing such discovery on the client would be redundant since
> the server, if properly implemented, already did it.
>
> Please clarify if you think I misunderstood your case.
>
>
> Cheers,
>
> Enzo
>

