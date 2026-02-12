Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2638F10785
	for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 17:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770917370; cv=pass; b=U8u9zN3In0rXF+VY9Jvcc9kT3YMkZmBsGJ3ixKSPUCSKGrZkt4V38V2K9TlfI1BS/ETtIrhRC3IiUJQ3CCIzKTtjiQyRGhIJYHqf6aW4VwaKo+kFyLy1nE/H138ml36j2fqbvgNzQ8k653pOKPmE8BgZJecYCDMVJeiHezj6PZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770917370; c=relaxed/simple;
	bh=/dWXKXhnyWanRAbfr+5nah47DKaieQ8LXs5yYT1FgPw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ediWQ1KHyaKv69AapSHeFKCNK6TDSetdnEwFPvt2zeSwzjT5R46ZSCJiQmAMaThGJYD/Q/1jam+W+aZdBn2uKP9IokI8HTlrKGRjp04sQmkxaeh4g/9BMab4OBrKyo5uMycFk4F+FHKHT9rorwJcU/mcludcXZaCoUxBtnsXrJQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EbRU0NHI; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EbRU0NHI"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-896fb37d1f0so1714046d6.2
        for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 09:29:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770917368; cv=none;
        d=google.com; s=arc-20240605;
        b=Dche3BVr8Gsg/iNITTNTK4t7hVSUCQrpor1joUU/aKZ5Qe66wfPEy9AEdmSX12S9bS
         8PvRKYC93rrmrOCM3A6juqchDj3Dte7msBWOKhTdofV9btaAkJ7h9EpwH7qQo/da26K/
         Cal3TTtzFQAddgJpWO3n9odtXLuN0oW4y+4Nx4HErmGgH4VeLZb8GPq4Kg9yvP3YLV8v
         MZoZPMLoQcYUHOhn39/jwtEu9vv0XEnz+3AfUnh5Y4BJs6kjJ5HqisAf4PUSx5qCK0Lk
         Mr0UcZ1XA98Hl/45IIkkmAH+hW8aakXlb2t177smRjRpX/svyRPIIa0dipgqaYfE5TJr
         aqVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=DjmislnmlmhlAcWen12nQLQCKg3UumK3+1xJMdDdLW4=;
        fh=KbQe4kdT3AB3u3IHWfByShcL3XEKekfkdoK/wL2tp1k=;
        b=K2B8xObLGOKL8dYSadB63X9q9PVVQb6OsmPvK8TVCg7x0AMUruGXId8rtnIi7UC5NU
         L/wRojGSCkK7BWfC6/MuuTpEkGn8gyAnlmTSEsBowQ7gPf6+LkzO1PqbO0Tlgm4+eLYE
         YSdCeeojZu9yIjBFN3GCn2LdS9KHppYLJ6h6rzConE/491GQHWmv++aAyNpQ3EWXXtya
         eoLD+IqUnENZeQPav/G0FkHFg3hqLdp+eScTFGuXAE0G/JHY9ji5zfP7rXLcxkl8CetK
         fTjxo/cptcMplDmPnH6e3a5jnTOr4xWeGGQgvvwP4dIwDA0XNd6LddPWsvJyZ6u2p/C3
         rZSA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770917368; x=1771522168; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DjmislnmlmhlAcWen12nQLQCKg3UumK3+1xJMdDdLW4=;
        b=EbRU0NHIq96UFkYvteXuafKUeIJOs2yM+WF4V6h6lT/iGIMTiqfk1V6NJUN/BkAYsV
         zkYP173Ja8WgwpV5dOjf+9kaE3imW8Gj4zfDNRQiKcHoD8Efy4vzo9fvrogskBiEl8K8
         qir/6g8iv4hO9e1Phm9U8QXnPXNk3SsqwkHj+B++NVVF5sfcnDo4boe6Pyrc8hgvjSTR
         CXQwd1hrDDpXx5rUCAXRr6FYByL56vYV1GZNPKd+FL1vBHvAyeqQo8nO+oFZS94a2Y5T
         Pvgh41q4jr6tXkLbZa1CgBTPnIHO3YsgDAtQNrBldqPPJY62WjpxuO/omneb6xkSXsol
         sFlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770917368; x=1771522168;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DjmislnmlmhlAcWen12nQLQCKg3UumK3+1xJMdDdLW4=;
        b=M5q3iRzhrwcsms1Dx6mOt7ooav7LZWg9wW8Z/tpPqjbox3Y32VaLFQsLrJ/wP5TG2m
         xwuSynlUVUKamlvfi5iuoLYVfF0LRE9nV/23KBPPpCW9IUPyEx9IJdynbb99Iy0rBfzw
         nddwMKziVgWDfMH48jnN7vjJyvuNGmJgWWDKpYbJ25DmocDUh84AwyDyenyIhGREUlCv
         lzTOhEETmFh6OYTy5r3APklrFF/Ybp16zOUyECgLRcHFVyvFBzkvnE8fdkuGu/jzKxZR
         GTZe+rloc99iW9ERvcupYueMChpFTJUQcuXpVTKl9i01dSEyiKpMqyT0lGdXRFsdgD2V
         TUow==
X-Gm-Message-State: AOJu0YxGjmqGXXzt2LWz90Xlzl0Hnv0GVmdcYVkGs9ntD3MrvOq5CNr4
	eSGHhyiHF35yf5qsqTUOQw3HLSi+gOOEm9G/Cx/C8F/KjNJyfH0UiXcUC7mb5yyy2C9B8BUZP0h
	ItBMbO8MeIWWW8SnXQ8ALVuDlKLpflnN8NmAX
X-Gm-Gg: AZuq6aKC7Eg6v7hnGYrQPXJBdox7MKbbTyXuKOT11BzRe8kpVAly+RocKdGFOZN4KvB
	ipvwO8v2ZwNo8hv2un7cgxGVHOWTP316+CG/UYY+C/MhwMVO4oxkUcDcWhiURGwe/B9tNQUfj8E
	49JtqwDDXm0dixJ6KYD0Yc1ngufk92T6RQUR2P7zN5cE/9+WTq/NFpX9u/wxQXTnIy2VgOyNaVW
	K45n6sDmnNgUdcry0BTaTGOn+0v3LFy5iG8K6cLy88B4fmCs696ucYuHE0DVpK7qCruK2VnUWcp
	QMFFx92uHow2jozQujtCaSFM9viqt87E4zu+Ogwv8wC5OoFH0aQMkSxwOTuFhUji/UwwRBZte+E
	j+tLOUEkKenYsoEmj+XPIECmapMW9CUrt6e5SbGSM7g6CDh3ruvRtU9s8q6qZU7LF0B7iXpn6HY
	XzgQYZxoLtcjC4MRg0vw==
X-Received: by 2002:a05:6214:2684:b0:895:4741:9f06 with SMTP id
 6a1803df08f44-8972795fcffmr59616796d6.41.1770917368096; Thu, 12 Feb 2026
 09:29:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 12 Feb 2026 11:29:16 -0600
X-Gm-Features: AZwV_Qi6edTxmVpyNNZ6Z3J4ZnDaRTb2mV9n3GEjdtyDk9NNHQfVUKjRrmEOD6k
Message-ID: <CAH2r5msswV+zSytTtFhK8s8wVTwt-5bPQX+KWWNEV6Qvq2YxjA@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] smb: move smb3_fs_vol_info into common/fscc.h
To: ZhangGuoDong <zhangguodong@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

The patch needs to fix an endian error

VolumeSerialNumber should be either le32 or u32 consistently - server
and client treat it differently so your patch leads to build warning

+struct smb3_fs_vol_info {
+ __le64 VolumeCreationTime;
+ __u32 VolumeSerialNumber;


-- 
Thanks,

Steve
