Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A62E4BA1D1
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 16:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789490517; cv=none; b=RLGJEv0T5Mx2ZL9upmR95dii5q/i4clz8cpB4jAmTQiu5yEGsEaB2AKljIV8WVgVKqTWl3YpJxdx4c+xGgEBzPTlVyr0ODMXOJ1kKobEKMJkTyRF3Z9RptXRL5g9UvxAQPC/YCyDaZvYCDnID3YnAqrvCJSjYr9kHimx7YtHYBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789490517; c=relaxed/simple;
	bh=akXLJ+AUYTa/EEtNE17XjRC0pcoMa5G77vtM+q5il1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LiH3tomv3HPekswzkk7vIEtnQ0sj4ewD3djSx0eQ/sh2KChqcMJF8UPHWcu+Q9dlQ6zMAD7wEw9SJ6VtDs5CwDVkK1nBkQys1eX6vAum99Z5WTmIHQ3qdfRgYyK1tLPDjzuq+/lFnGsNDbjPMKw8MiTsfxDYDQPAfQi5uwCHLpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L7wKAX/n; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bq3z1kGK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L7wKAX/n";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bq3z1kGK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789490514;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kRd3EqI3rJAYAi0qSc65P4cbxsdPp70e4PeE97s7MBA=;
	b=L7wKAX/nhNaB7XEV0LwwhA4jmtdbge9/JzaV285DgDG3sARBSAK0J/n682gPWvVztjaSw+
	gsWUVuPPxDbVhk99DKzE16f+WqmKB30+TFPFPBCk9EOkhPZhCVVCZwS8oJU9t3DdhLFJMr
	th/vvRGAzuXo+GZRPC8bYkQa6hkkEvo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-wRtjTmuAOVC1lJZryXgEsA-1; Tue, 15 Sep 2026 12:41:53 -0400
X-MC-Unique: wRtjTmuAOVC1lJZryXgEsA-1
X-Mimecast-MFC-AGG-ID: wRtjTmuAOVC1lJZryXgEsA_1789490513
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91213a1aa68so67072856d6.0
        for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 09:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789490513; x=1790095313; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kRd3EqI3rJAYAi0qSc65P4cbxsdPp70e4PeE97s7MBA=;
        b=bq3z1kGKWeMv4+Ce085GmVZn816slzeomKX9WQFIgM7AHOCMMrx0mAQyH8u/wA4JC2
         5+ZUHSjDL65AN2k+ANMnZYWtMPTrySbsuPFzAOrRFw9yXhgRkZbZmHC6xhYIIGrqEleB
         COe/dJK4VDrjtcUUjYkIv41v5I2QRSiA45DIHBz3UHcqttv437A5ypBHNqLbz1MZ3q7w
         fnv7lFhHDY9YOkIwE+Ofz+ZG/FgPXQ1KSpWs5e4cBA7FdfA/EOH3gdMoHTZa3hjsN90y
         jiNvYx/06kJSAB8piOuPv7JaqWQWeswm3nj+r8tlsWidF5o7xVDz2K/gf0N1axtiNxh2
         3YaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789490513; x=1790095313;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kRd3EqI3rJAYAi0qSc65P4cbxsdPp70e4PeE97s7MBA=;
        b=BGNceyAzUNaLFTjMEwP2ofGQDwcJ0ewe1TLL3LgJhqGA9faYfDPuLlx0HCGexREiT6
         6f3+1RpsLKL9J7FWvOYUMCiGDuesDwHRTJigWfs4/vFpo5qLyUzK+j+v+9Ag7rchayVK
         xgbaUUTDxZu5TZu8/F1HhhXJiJHDtSgsHUbZqlCXNr2A/Qth9+/0b0OjYqpBw/rI2lL1
         5c8saZraq2h03nmUan9Ezbo+DdGOXAkDwulhHVJwCf7pJCq6mtMvGx3ReDoA/9BCciWy
         y4Id1B5JPpwUf/pkeYzDQsVNdh6M4rw7l5id4dUZIN0uWJit513desAfwe5Rj0VMGC6+
         bskw==
X-Forwarded-Encrypted: i=1; AKwUvByLciKjGt7VoyNNsr0XHPESoCnm6DWx4yMfAWSoiDzfYHYtedXQYLxxVUfvmA7EDXz+QGfMoXc25jRJ@vger.kernel.org
X-Gm-Message-State: AFuF++kfmVG2sYwENN8XDfvVs0lahu0Dbs074/eC5j9qCocBPHh2Tp/k
	NKb+LV5SGZOtVv95UrgPKC4YzNbdPIqaujFzwIr2q6UsTx1ZtW5IytBQdbYx0OJN8psrevhYXes
	XbFMJBOgppMHt1Bs3518XoDH5ye3Lz9LbKrkLpa20Bpzn3ZxGefV41tegU30xyNA=
X-Gm-Gg: AYBFou2VNuQlsAO1kAi8qEXecgTxRoy9sAKcY5prYb1AAPcGj1GdjRDuMqeTEHDKQur
	XBf7rvCVVOFK1+uoXxUuMRado9aDKYwiyejPew2SIcocMRmt0khlf67blWdJCGUWIQbTy5XN47m
	d40cO7i0pbGM24Rk9pj1072ljyF/khgo1KmXnBZ/SdOZPjnyOFPDVY1KyC/WVLKrJYSvQbvGsy4
	YPlYNA6qGiyEA8aNVyJbqyXSLJ3k7q354Hb3yfr3zn7LAKUNrN+RmEQiFICYYVGxZDMmf4HbHv7
	4BnP4getZELXn1qA8koFSd2195D5goVEEYYaNbUnxWb7bzVzQvC5Sa0AvDImtqBcHONk0ME8TJJ
	D3pS3lpuv94bWtkiKvojZSVctZgdn0ubngpEuVZQg
X-Received: by 2002:ac8:5a09:0:b0:530:e0b2:4aaf with SMTP id d75a77b69052e-5310cf0cc6dmr133291301cf.11.1789490512986;
        Tue, 15 Sep 2026 09:41:52 -0700 (PDT)
X-Received: by 2002:ac8:5a09:0:b0:530:e0b2:4aaf with SMTP id d75a77b69052e-5310cf0cc6dmr133290911cf.11.1789490512528;
        Tue, 15 Sep 2026 09:41:52 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530ca309989sm132834191cf.4.2026.09.15.09.41.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2026 09:41:52 -0700 (PDT)
Message-ID: <6a11c41e-d636-4051-9b89-95186eb8e280@redhat.com>
Date: Tue, 15 Sep 2026 11:41:50 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH v4 02/10] smb: client: validate minimum PDU size before
 smb2_get_data_area_len()
To: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com
References: <20260913214510.3071370-1-sorenson@redhat.com>
 <20260913214510.3071370-3-sorenson@redhat.com>
 <0b3d295a3f9ada22c99ac4e49b935106@manguebit.org>
Content-Language: en-US
From: Frank Sorenson <sorenson@redhat.com>
In-Reply-To: <0b3d295a3f9ada22c99ac4e49b935106@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 9/15/26 10:04 AM, Paulo Alcantara wrote:
> I don't understand why you're creating a new array.
>
> What about to replace @has_smb2_data_area with the above array, then
> have something like
>
>          #define smb2_has_data_area(cmd) (smb2_min_pdu_len[cmd] != 0)
>
> and in __smb2_calc_size()
>
>          if (!smb2_has_data_area(le16_to_cpu(shdr->Command)))
>                  ....
>
> Then we don't need to worry about keeping both arrays in sync.

*facepalm*  yes, of course.  I will fix.


Frank

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

