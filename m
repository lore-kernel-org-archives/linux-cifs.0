Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B3625F985
	for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 17:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741715118; cv=none; b=i4qRjFzuDsR3t1YYYwG2MhrTXvxEHihbfNeAW79Kl3X0S3SmR7j64sUPOt5XLQPMQC6m1CTPAWL0H/BTwSdqb+nsLVE6czil/NDk6J+kYTJNmzFVtRJVOKHWfjFx0dJbvls1Zjm+ozQir0sPHbUu3d3JvVNLdGeLucL3JkYglgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741715118; c=relaxed/simple;
	bh=4UKC3nKFJ3zGDplvUNaNReuUtf9EZmp1hesuOhP9+OY=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=ffqHwlivOYIDkrBMilNGBRTaVtXED0fjLa6xYgIFaXIg/mw/6LrXQDyvlgj6IChuihnd/9269+0NuuqfwbVvemxMq3sZT6g1iVnGZ0pzKO8D+9V/x5XuQ/wzu2RDsO8ZsvTePiVx4y6YC7NywBTiiJgdCs95/kILu1xojQqtlB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z/dzF+uN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z/dzF+uN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741715113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AnIedSKQB3ps7lKQvcEo0MZHMNc0IxjN8dPmqS0REkw=;
	b=Z/dzF+uNC6c1DQqxXeR8sD8ze6arYsZb/1uoS4oMy5ah3boaFPmvXFI1Jr79o3JYp7M4F3
	9gDfIEPL7BODAT233WlYr8ovw2XKYE1+Wlnc5msk72UTrfzsdU8V2bcyTPIyWw9p4/SrD/
	WbBoiAcPwENBCA2Nh9t/n5bw9qXz8zY=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-TacwvOW8NUia42WJdnpbiQ-1; Tue, 11 Mar 2025 13:45:12 -0400
X-MC-Unique: TacwvOW8NUia42WJdnpbiQ-1
X-Mimecast-MFC-AGG-ID: TacwvOW8NUia42WJdnpbiQ_1741715111
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2ff581215a0so15813550a91.0
        for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 10:45:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741715110; x=1742319910;
        h=mime-version:user-agent:content-transfer-encoding:date:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AnIedSKQB3ps7lKQvcEo0MZHMNc0IxjN8dPmqS0REkw=;
        b=itVG1/sQql42NlR6jZSgpazGderM4XA4ttWkbxpIUUir7M51akM/jJf683gO300VOZ
         qK7NiP2PktDG9qPLPoJfkp4i8yHRt2dx2/5zqF/3kq96aYZKG7embgoVuNK35X2ch2/I
         /c+QwzwnXjlj39zhukFReJgIGCoyJf4LO+cjjTTn1q3H8snMM3SnLoyzdFWrCoIo9dC6
         JXoOSBxRJ6wesoK7qQE80pFaG2Q5emzRUyzU4OdXgMr0cffpN4suqgoBgoI81QLAwfOG
         BWcJvWdChVllziAxkk9y3djajfVqxUh8OkoMOMHH/aBSeA8loofRrnfkuB93McV2ViBu
         BHuw==
X-Gm-Message-State: AOJu0YzdgWtarl5u8VwlLuO5nbPDlxyhuk2HCuHVr30sV0Yox6MA3IEz
	b749tvbZQGQiWat2SiIJrFsmSBQLGegffy4Vhjy8WiRvpxogITwVFma5QrJ22RegJZvqRUxjK5b
	LJIs/v96NebdYZTJO01cm5z70YZ1Dguw77JI+PdSOzs8MdggnitvgHoHRRcxecWELFj2aVmI+Fd
	TFse/8ksLKQKyqbAut+GsXD1jJcqfZoG7drKk1bSAoRqTT
X-Gm-Gg: ASbGncs1SJM6K2QmUgtQMyR7tfCsud5fG0DGypqwcvmLl5a+x6Bto/M/HWS5szwMq1N
	xf+F9r7aMi09R3lwCn+vATFD3IWVoy8upNYO3T/SZnVLgK2cLFgcLoP1vhLA8PUsfDW3tNdra4j
	RNU9gH8Xsf1scOkQ34bc/TcFP2Qn/7tIM8dWwgIyg52RAFXQjaKMv+9oNPs4KZnq1SgCORB/n9Z
	KcEXEaXZdkW77HLF52bwdk6/xQHaU03AUoZIm13410ZaQ3X2rM3NjoGc0E+PpZwSpAvduNYE5+w
	fiXWCLusKC15opcyxH6HoK9Z27TSjHcs+fPX
X-Received: by 2002:a17:90b:3849:b0:2fa:1851:a023 with SMTP id 98e67ed59e1d1-2ff7cefc480mr28598730a91.35.1741715110499;
        Tue, 11 Mar 2025 10:45:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvfeHJ71WfvpkL57OfM5nSs1i/HtePZcU8Sk82z0JpuJC7UCnyPqYGm/pA4ImngLpQVqKwZg==
X-Received: by 2002:a17:90b:3849:b0:2fa:1851:a023 with SMTP id 98e67ed59e1d1-2ff7cefc480mr28598701a91.35.1741715110047;
        Tue, 11 Mar 2025 10:45:10 -0700 (PDT)
Received: from omnibook.happyassassin.net ([2001:569:7cd5:ea00:c6fc:c4e9:3726:7db0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff6936d0f7sm10338122a91.21.2025.03.11.10.45.08
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 10:45:09 -0700 (PDT)
Message-ID: <83c00b5fea81c07f6897a5dd3ef50fd3b290f56c.camel@redhat.com>
Subject: Anonymous mount of CIFS shares fails with cifs-utils 7.2 unless
 'sec=none' is added to mount options
From: Adam Williamson <awilliam@redhat.com>
To: linux-cifs@vger.kernel.org
Date: Tue, 11 Mar 2025 10:45:08 -0700
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41app1) 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

I have this line in my /etc/fstab to mount a local network CIFS share
that requires no authentication:

//192.168.1.9/Media		/mnt/data             cifs    noauto,nosuid,soft,guest=
,uid=3D99,gid=3D99,file_mode=3D0777,dir_mode=3D0777,users,vers=3D3.0	0 0

With cifs-utils 7.2, this suddenly doesn't work. I get an 'invalid
argument' error, and in dmesg:

cifs: Bad value for 'password2'

If I add `sec=3Dnone` to the mount options, it works. But this should not
be necessary.

Others have the same problem - see
https://bbs.archlinux.org/viewtopic.php?id=3D303927 (that's where I found
the `sec=3Dnone` trick).

I'm not subscribed to this list, so won't see replies unless I'm CCed.
--=20
Adam Williamson (he/him/his)
Fedora QA
Fedora Chat: @adamwill:fedora.im | Mastodon: @adamw@fosstodon.org
https://www.happyassassin.net




