Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C912152163
	for <linux-cifs@vger.kernel.org>; Wed,  3 Apr 2024 16:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712163597; cv=none; b=gjQAnwFPwNPT8o5e6Uzjmu1Q+Thp1OjXSp4ykMh7X0iUbYBgmBHl0iOrwKN/yMOFqZvKgD7ej+IGTHdd7aEfwcJjBgjaAHWfn4lUV2mx1TaBIB+k9f1gzPkFD/MvuanC7lsduXfjmGlv/UF3ycI5IG/YR+fU955UYNBydmR+IKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712163597; c=relaxed/simple;
	bh=1QHEDPpqFRVTaMitRFRECKns1ULA3ceFkMwOdLkg8FU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MbVLwFrAVaYzGDJB23Wx3+2QfOtHp23hfkD1M8m8GeUePtCGTeK3nxyE5CPGRViLx0Eqsd8QwCQjTfVx5Brxti2OHfM1glnz6DIFnobTMWhbZ2IIc72J247ImiU1R1Ijofk5gAfZv0F4OAo1DxrNlLXWe8IXaSldLJ6voT7aqLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TCCp6BSw; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TCCp6BSw"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a47385a4379so231983466b.0
        for <linux-cifs@vger.kernel.org>; Wed, 03 Apr 2024 09:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1712163593; x=1712768393; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9zZqVSe49xG+Cuf6x2/pIzSVIeoqPFNTQJEfQlqHLac=;
        b=TCCp6BSwTIKImCa6ejUZOPRl8RsaJEURQMAwwU7IHez/VMYlGRhnn9pSN9ctNafl5+
         6iHtQuJA4ZXkg4Ce42HjQ660rSmAhMRbGLX1VBWYeMrG/P9SYdN7TXCF970dSrzMsUPd
         a2WRC79HWKBeNYRUnQL8ddgSmlswDktck7p7k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712163593; x=1712768393;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9zZqVSe49xG+Cuf6x2/pIzSVIeoqPFNTQJEfQlqHLac=;
        b=dZU02sQaMXyNhkGWGY81vk6G9rN19SpF4I/MOlsvXwKqgMR8OC+vBV1qHbKyGbzhb/
         m9zJT0mu7epk0A4LeMPsmrrvCLtOUSSIbIZmQvKQqb9F6FAjPuXd2VdjQK5u3l9MH1GN
         87TNsKstOOaYGgvdDuaVqt3XCz0zKGI1+89NHE8SVBVqb+xh4ln+ivqT7PNX50i/7Jc0
         jlUpK0er2rTdVT/AA0mXcqKzCkxHDSCKKIU4wK+q6K/evRrnudbRV47ZtrP4CYeEH+3d
         T0lcPfm+Dad0/LdqhGpe7gaZAINmHqXTw3nTeB3DWIMGgWETzu5yhX6fIpA0NBg172eN
         emjA==
X-Forwarded-Encrypted: i=1; AJvYcCVEuXFs2V3MJpnpmoL5cSQxexVfZsCwRMT+lFkBc5qwLFMQw7Zzg71dZ28EpyKwu4+SayKlXbv5fnAb2XNkw7fIjWl84DQqmqMqGg==
X-Gm-Message-State: AOJu0YyNyNpYhXIsl3H004sRaiAhn9JH1OdqSBzCG0Jidwnjz4/9uN9J
	cO3aaa3xXszDUVVFDhT3A4VADpQlTTVeLch7MK2Eq2B4zl4xJGJwQxv2X+O+8Jipd8R3Z4U64sE
	8r9tJgQ==
X-Google-Smtp-Source: AGHT+IE+FMmDS+WDbp3gzB0lUo3YqY2qd7bk8ojA2DqGNjuY8zSQX9cmodyvUwPbrWti9WgEhEHD1g==
X-Received: by 2002:a17:906:230d:b0:a4e:9e7d:6588 with SMTP id l13-20020a170906230d00b00a4e9e7d6588mr2416728eja.27.1712163593537;
        Wed, 03 Apr 2024 09:59:53 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id n3-20020a50cc43000000b0056bb1b017besm8160762edi.23.2024.04.03.09.59.52
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Apr 2024 09:59:52 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-56e05fc2421so1622766a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 03 Apr 2024 09:59:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV+1M2VTlwTb9P6tHlTk/+B3K8s64Z1ufYNeoKdGJBcyRGZ9CFFrSgYmguGhRe2Scbe0p6BPE0BgL+ucVK3nhJgOfR2NwTg348UCA==
X-Received: by 2002:a17:906:4f0f:b0:a47:3afd:4739 with SMTP id
 t15-20020a1709064f0f00b00a473afd4739mr2945922eju.6.1712163592316; Wed, 03 Apr
 2024 09:59:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403090749.2929667-1-roberto.sassu@huaweicloud.com>
In-Reply-To: <20240403090749.2929667-1-roberto.sassu@huaweicloud.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Apr 2024 09:59:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjG-V-9USyDTWqUhY7YxEwSfwC9yA7LJkT7uGbHHFZeYQ@mail.gmail.com>
Message-ID: <CAHk-=wjG-V-9USyDTWqUhY7YxEwSfwC9yA7LJkT7uGbHHFZeYQ@mail.gmail.com>
Subject: Re: [RESEND][PATCH v3] security: Place security_path_post_mknod()
 where the original IMA call was
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-integrity@vger.kernel.org, pc@manguebit.com, 
	Roberto Sassu <roberto.sassu@huawei.com>, Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Apr 2024 at 02:10, Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> Move security_path_post_mknod() where the ima_post_path_mknod() call was,
> which is obviously correct from IMA/EVM perspective. IMA/EVM are the only
> in-kernel users, and only need to inspect regular files.

Thanks, applied,

              Linus
