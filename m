Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B535A2F8E9E
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 14:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790520879; cv=none; b=M5qi9QFDkrize8ysv46/F6GKywJmtN/pH+d80VZsbAi8hnGqVfedr7UnK7QwFV8Jnht9dG9QjXzEaPbbMdqvZQc1u42i1mIMLhfyOLLaByO0eeVRWyDVyKQp5Bq5XTY3Nbgc/3yq/jclekLy0L73k1zWCYXOYZpdfdJHsC/1/4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790520879; c=relaxed/simple;
	bh=yKI5V/O0xPS9DO8JxOaTTj+A0oMs8grfiPaICIe2IbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=musTQru+3Acn0+bRVvKYIWn8H1poAoMrZ8BVSgSxK8/i/ffP9s5jx9Nf0b7BNzaGJWXBra3k5UX/GoKhWXwE9lAWxLL3JIuENQXR08tyTCsUysiUgaY9iy0iXG2d1GZ/cGE8LnwOnyW86Zd7lBa5U2eTUcOZwevwi4IkvHHVQ7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nNpfihw9; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNpfihw9"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e6b885ef8so12280745e9.1
        for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 07:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790520876; x=1791125676; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ktsh/JgcSNmnNKAcVLzISoygMwOgNOsVbgbRCXSNX9I=;
        b=nNpfihw9oeOfJKV/D+DG9dcYWpMKwPIJ4sA4ZQPPjJA3fcxX/9V2R8orn6HAwf/UkY
         2zCPnMNHez4OlcDGBjNhWD/sbRGjkPOUjttoS61evAoZn8mUKm+TajSo/LmprAL/bUEf
         JeFospjGCDqN9InDGBO+geUQwHpO4qmRu9E8v4+9Gw+mt461bLCPCaf2zmx3cou+g+8f
         w/uEN7G53HL5f1Kh+oDvd0d/Mu0coFLjSG/BieZHwx6mDdkVZW+RhQMPUgkFe0GONF7s
         hwGiyRVWrywJ98xS1+6M1VoFZaNjeSUzu3iMtKZZYqn7OoqrN183+wqjVvt5Q+u/Uvx+
         0KjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790520876; x=1791125676;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ktsh/JgcSNmnNKAcVLzISoygMwOgNOsVbgbRCXSNX9I=;
        b=ybwzCOfGKfQiBX9g/RGJSUNftLPfxIm9JTheoAOYESQOBzSwu77GSnyM2+tLWwmYIs
         ycoA9BEogz7DUcT7PbDxkRI8klZfc0aKbQHAQ2QFwwifuiDjfxrqfwaQGNekQaKcOqW9
         5RJaqdi73JGX94RNMkejJJzrK+9ugsZoRWoJe1m0YpOidLND7cynDxNC/uLwiq0NRyhh
         W9/PyB1xhSptGp4ylYYQpJces4Rd3F0O+8Oiwll0L0CabZ9S19dZxJuAvyli8YUWD4hp
         hggbs5HCJnbBAmuGm3SSLzgQePHPKSV3tigWWkswrC4WgCYBFJc7p08g5+x9mzz92hfM
         EESg==
X-Forwarded-Encrypted: i=1; AKwUvBwhke5rpb0N3VxnDamJNxswpt6Zg0CYH6qW/nEUla/4GFPKNUEdKDQpHV8wmA0vCOjpGbKwgr7mHXD0@vger.kernel.org
X-Gm-Message-State: AFuF++n1xyVcqtQ3foXeVRcAnBrAtVCVZ6/XGUSZU5e12inUnyJvrxlI
	ix5BSwZh+mMqb6/mh+cwqA0Ng4IPJRi3E1d/0D16WkPShFqMq2SM5zLCxw69CcWE4IeZIg==
X-Gm-Gg: AYBFou1VGZiqQ74/AyagJHpWkd/mbHV3nqbLR5TaTdoKBJUYpeO8zfdWuy0GrcF8P7W
	Naa+f5PwLu0g2LZgxwUeo6by5CrDLIetNGyyfid0rCYqa3lbaCcn1C0PlKPCVxKOnTg9INUsJax
	uKpJdv9Rn5EkUA10IShiA2604uLKh64GIguyjuQmNXX/av06Ry1IlOsnOisLy7jOIdQJaFVJq9E
	XvyroSjjEcVdt1K6FUBnM/zLnQ9c+g0iAotrpG6N8K7d52m/bv+eyKnDKKy3P7cG61Ss3uqg7Cs
	C+DcdtqchvUuEpKsohEfOuCeU+gt2HkNfi/bPhP8O6TsigsyQN2gRYhHeBOuXk4gu5ru3Q8rCpd
	Vv7Ja/Bpi5qQteS0bAQKvmCh2mNslqBK0AecnQ5xsBLKrTJH17AkmSqajWxWdu1FNaPkwSOeJy7
	e2eb4D5lBDvm5kJFmgZ7iPxwpQq2LWbBzEVN0u3CpT3r0JIicUn4sPSv81fEuNIf2eg8aOl4K2K
	Gsxz3E=
X-Received: by 2002:a05:600d:486:20b0:49f:e8bf:221a with SMTP id 5b1f17b1804b1-49fe8bf24fbmr135716955e9.22.1790520875905;
        Sun, 27 Sep 2026 07:54:35 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0018dd0ffsm69292305e9.2.2026.09.27.07.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 07:54:35 -0700 (PDT)
Date: Sun, 27 Sep 2026 17:54:30 +0300
From: Dan Carpenter <error27@gmail.com>
To: Zihan Xi <zihanx@nebusec.ai>
Cc: pc@manguebit.org, linkinjeon@kernel.org, ronniesahlberg@gmail.com,
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
	dhowells@redhat.com, stfrench@microsoft.com,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	kernel test robot <lkp@intel.com>, Luxing Yin <root@tr0jan.top>
Subject: Re: [PATCH] smb: client: avoid NULL resp_iov dereference
Message-ID: <arkuJtmhKDAFnzTl@stanley.mountain>
References: <20260926132208.23360-1-zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926132208.23360-1-zihanx@nebusec.ai>

On Sat, Sep 26, 2026 at 01:22:08PM +0000, Zihan Xi wrote:
> compound_send_recv() only populates response vectors when resp_iov is
> non-NULL. The final pre-authentication hash update nevertheless
> dereferences resp_iov[0] whenever all compound requests complete.
> 
> Guard the update with resp_iov to match the response-buffer handling and
> avoid a NULL pointer dereference on callers that do not request response
> vectors.
> 
> Fixes: 62432a3f5145 ("cifs: Clean up some places where an extra kvec[] was required for rfc1002")
> Cc: stable@vger.kernel.org
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Closes: https://lore.kernel.org/all/202609241449.HlHmnZFZ-lkp@intel.com/

Originally the idea was that I would review these and filter out
the false positives, but these days people use lei to read email so
they recieve the unfiltered warnings.  The zero day bot should
probably put a "Unfiltered warning" note at the top to let people
know the warning hasn't been reviewed.

regards,
dan carpenter


