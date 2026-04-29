Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0261A3009C7
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 20:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777495573; cv=none; b=Rs/0MJdakxysOuGN1unLRzQrewfUcTKiIaJ64xC7v9IQQCDngVnh/7tg+Y80CUaufb3Ln7hvLXQKdRrbCQuOfElklAKd8lmsq+j3u3NkIbK7unkqMjvaQY4PHvTfUW+6IfSsFzM0Utc5852D5xzd2kEFMK3KOOm0zC3aiNdscSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777495573; c=relaxed/simple;
	bh=zl1e9ZzqOUMtp/cDxIw1N0nsCcf87S2hObyRsrFDNj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZcTW5B7sFmMC7ZuKCpR4t7udgoPnZBTEwmZz/0Nq80b7V4DS9zLg/5KjL8Q3fRmfXPvJhrPoqVXQ4r/ElvccSU8BiAy0NupDdDXx0Phqg6+k9ye2lw+cs1ybx4bTMJwY8ml/4SlaKDLBX4Th0DUTYhH8XBwZjF4HrXMzWDauUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VLSmlpvv; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VLSmlpvv"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488b8bc6bc9so1113315e9.3
        for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 13:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777495570; x=1778100370; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zl1e9ZzqOUMtp/cDxIw1N0nsCcf87S2hObyRsrFDNj4=;
        b=VLSmlpvvS0A6Bx4DeqiGmyHdg7hhUg5o4kg3xBtKJSHfezNcJGLK6Wq0QTHBElQsYR
         16hQfNwxvfEPDGzMgDV5fSolNlGXtyxx0N2JezmwSLWaJ2fVgH/ojy1oEsZUgl+xsmtV
         7/6gtq5+wFoiMQAMiCwHkuczboldi6YC9QbhKaAWxOe2CERD7yZ4x5uqoCYJVXOo3B5o
         H8HfakrYZRR8KLRBz6Az57T+rM9oXuTybuxzhcfKb1jUWGx4MOB5edeiJcZ9Okb6DNtw
         +2NamIW1TmWzL15ylnokOvEWZDXKx6VUGac3CajDtodt/ZT8PQHfpMIDfcpEfFD0rQXh
         QVVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777495570; x=1778100370;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zl1e9ZzqOUMtp/cDxIw1N0nsCcf87S2hObyRsrFDNj4=;
        b=fdzF8mARoKrITpRPMuFmjyFWSYl/rBaWIJGemJJQxV8doi/WkL93eFxQ5CdPDpNvO5
         lE1jGw9jRwJepck4XKgNMWyN2qqSxeJX7tP0/WZNaXq120TvMuSN/C7pV6PBws5MU4oU
         kB2ZT/Djnp6trAiDkkceEAPMhIltqXZ5sJ89zLqbB0aYO+9nvD278QdFaFeZTChYnAT4
         W7X+T95NRHHcrqo6rqpUo/boUWKHJdd4n0DkPnJJ3WjS8TjVqgDJisiO6+V6+ZsBDf6P
         w+gqS61Px0VowToj2PITQC4bWPg5QGWYtjfxiVGS8qvcs5dcDTAZfxMyXtUKRC0VjgGK
         HrUw==
X-Forwarded-Encrypted: i=1; AFNElJ+QS5IyLIIENQX/okyIhVfcd7z6npDhCFdbtwBerBfEpca8Ao+MWCBoONgoOTAxARs4PanbkfPjtyb6@vger.kernel.org
X-Gm-Message-State: AOJu0YwiV2rq0bOmQF/oNQkccWHZpqKu50Jfiayj/L9rYhmB52umf7Y5
	xTdFZ2Jamki+aqHmQknFVZirkVMdQc7lu0eg0jbYNm0khSpe6z8ozlVSrzXXc9Y8IBs=
X-Gm-Gg: AeBDiesAzz+3vB3/xIB6p6QVVedjFY7WxDbCuGB22sqkJAVbnNZquK38oyKYeSHRwUa
	Qnfo9/yJ6YKzgg2nljJUDYwXIC7soa+4hEr8JqtKUnK7lqaXnDUqvwNP/G9oEOQYCtCK+gv/zkh
	NWvM/q9JzxFUT7FPX6ZpmSEKowKRwotuJoZqBy92uyCvN94WhegsV/JdnNwecTfzboxbvhZ0wVF
	eP+k/C4G+jFdy0JM0av2ClDJTyA8PJvq20tOSaeqapjt5lHB7p70eCy1X7iLGDce0Sysy2KIZxm
	5e/OrOUiYxXj5MHr2n8hk5qXI9RPfuDe0mDPbK6LeoveOcQMyfDvdUgw+Z56MMbEtqIH17Ygf0k
	aiZIwCxNB35mAL6h48WDwddI2A6/srx1F225BTXCe8NVeEcQQ3nFxqtGsl9/i3TL2S/Pu6qXpSW
	L8Fh1Gmwn1LaqTC7IK6pi9kBYkr7qLut+KSuex3jMn01wq
X-Received: by 2002:a05:600c:1f8e:b0:488:a824:fe04 with SMTP id 5b1f17b1804b1-48a8447f466mr1852815e9.26.1777495570184;
        Wed, 29 Apr 2026 13:46:10 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-573b6b7d4eesm1871652e0c.2.2026.04.29.13.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 13:46:09 -0700 (PDT)
Date: Wed, 29 Apr 2026 17:45:59 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: DaeMyung Kang <charsyam@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Rajasi Mandal <rajasimandal@microsoft.com>, Rajasi Mandal <rajasimandalos@gmail.com>, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] smb: client: fix state-consistency bugs in
 smb3_reconfigure() multichannel path
Message-ID: <mhc4fpsjriwsrrtsms3uhqueihguf7vztnwxbnj7tud52e6rq3@dkfi5w6zmdkh>
References: <20260416151839.3315696-1-charsyam@gmail.com>
 <20260429121013.1696901-1-charsyam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429121013.1696901-1-charsyam@gmail.com>

Hi DaeMyung,

Thank you for the update.

This version is better than the previous one, but I think it still needs
some work.

First, `mchan_rc` appears to be vestigial in its current form, so I do
not think it should stay.

Second, I think remount/reconfigure should be all-or-nothing. If any
part of the reconfigure attempt fails, we should not commit the rest of
the changes, otherwise userspace gets an error without a clear view of
what actually took effect. As written, I do not understand why
`scale_busy` is handled specially while other failure paths are not.

Lastly, please shorten the commit message. It would be better to follow
the style of nearby CIFS commit logs.

Thanks,

Henrique
