Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB2B145348
	for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 13:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768571325; cv=pass; b=kg23JVTL8LtdUUtSrg+5Yub4p5HfVn0CJ1AYaeJwI09mBpAbyWTydjy2rPUWEqRSjwZL1EwWbWt874DUyE3GxVrO/jhZ+P3WezLhRY+Bb6F84am+jg+pTsY7kJIYD81S4wRhUs36CzbukABN11kLCSAIRSDFTe/9zErU/WArcic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768571325; c=relaxed/simple;
	bh=HX0duE+qGKsVrqZ0C2JNz05cy8+BCoMzHp4oOiMkhC8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ug4QrVDeEooX8SfL+iagKOElnLyVvbp0c3NlyFM+GWujmLAnJX4Ctm5xUtEMovGZcyC9st8GtDVlxMCvwr8eXj4P0KzMkCZFYWVJXemJKODXluHBKsOB8QVkJrFAcbunzO5K6u7/Uz9nUs902V0XXe8IS1AoM+4KCdHsKK8nW0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kJkfm6kV; arc=pass smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kJkfm6kV"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-4040996405eso1301986fac.2
        for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 05:48:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768571323; cv=none;
        d=google.com; s=arc-20240605;
        b=fBrNy/CJRG94dZ+UiV863A4t/gnyB6trHsdAfst98VnYVh93jwzvbTSddDEbJuIAy0
         xS5ll0smJHS0LP2NbdSHjVnW1I4a6+5SGQt6C5bYx325dcGIBUolT66WqJvUciIfMKAF
         lt9tVSMJLXBf2l8ntjqD38GW6c3EX+NaV5ceomBizmbS+Wk22T7CKu0Xbm3nNkWFGGlx
         e9dknhDSdsCxBOU01zwgDNfQA6dMLd7xeOlfGEqPdtLMs1Y5iDDroXtUw39oHp7xUKmu
         KK1K5S4vYzd5Cor1G28JLTz8HiwK6YdvJDf7xx500a6KKL27Axhj+rV5k7jCEuQ6R+Ps
         5U8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jepaoy0VXaYttk/dvdyEucepaOeYwphHZcGqjIuUgJg=;
        fh=usBIOGyQPDc+3gG9E/tIchk6OCHlSR/UQ6TXina2ZQA=;
        b=QJzUiIAQV4jt5aLFBobl5Qm4xDlD8zl+yyc1vFIDbdioqT5SeZKgIMPUyn/GcT15zY
         MqDHWGx/7lECkiqEKUllQJA0xBG2m+EnV4+LxxCqbusYC6NTtELsUgl730DS45+upVmX
         2IvMzfTneGMcuJSxn61fGbpvahP+ze75s76wvLh8whictovQWXTA+kxEL9ZWgW3pllzi
         zzdufrUfsDsTLLpypEcxt/BmTnB6UfSEnLE77jmVyx7C9VTzwmm4hWBTq6rTeTDgpGtI
         qkEyOevGcCUsO5R9Sln6FIXrNuTBs9nmlMiRaY5oZl2RNi0dXQ/TTACaFJLnhdLohoX9
         zzzA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768571323; x=1769176123; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jepaoy0VXaYttk/dvdyEucepaOeYwphHZcGqjIuUgJg=;
        b=kJkfm6kVvXyTJU94MHsNfSlU/vHNORuVRHKJh3BXyOEHSGSBsJ04NpqeP4vJQnLbN3
         7kk7zk6Q73vu1YAcoBJVJ0u/h2EJIaaNKRCLRqgRBfBITcTEQJToub0A6JWuc+bf4Ruc
         ilkeDqGyjsNqzxBPcT68Xq/SnfPDzr+5LijyxpMqMuI0/thZhSIpGt1n7qrTNvoMRFEW
         ykmDB5O/N21Wv8C8PV8DLZh0yf2e8+Lg8t+AufhpaDXahsVWWrkgPDvpCZh0kQV4skoc
         gaR++1xzmqCzEHx09xIYf69JWsptBPtKA62BfcK7wO+Ti7mogLaS679WHZaUQ0ruZi3L
         EszA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768571323; x=1769176123;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jepaoy0VXaYttk/dvdyEucepaOeYwphHZcGqjIuUgJg=;
        b=tT8azbtdIuN7EmUlhFP63JZ4IiLXaHLYh7bGEe2id0smY/rjuULlxdNTcOXxsU98Bd
         UsGSNA717jQaaG2q5Yx1FU/lsi1glQ9PAIBaFexYmndcJBha52U1OvGbAnhobi6iAfrZ
         KBTKq6K0zsmnKfPu3perw+mSoM1DodDz4+tbxiQ1l4Zo/xKWLOGmv1+w4klGUwKe1GWe
         Dhj6iRnSlymPI1Of/ekRPtCFrtD+PaKU20QkF2QhiVdW8SLlUKftkIeZX8jkQ8KDWRL0
         fWzA0Vj7mc9/d3uHCXHPDYZsZ0ONFFxrO/t80G+aQ2O//+KH7yIk9lyi6F13KPYmtc/r
         iCxw==
X-Forwarded-Encrypted: i=1; AJvYcCWQvqFQ1sY0SwYI8KZSvvvFCyGbD0Dpi5BUnnWa1rE2vK4uYNKg4XNH/m4N5lsSqZU6Ky7xJCp5dmSD@vger.kernel.org
X-Gm-Message-State: AOJu0YxwdlAQEEWf2nOcScA0u73CyDz0n6tEWNLR6NjGU7N75t3tPlQv
	/NcYGLJ0SfuXdOFVtURLDF6DV7wamR/vPH2mLJSHQH//G8Kb8w3ic9+tBf2SFm8AoaTV+w/KgVi
	CquV5kWRffuDgTxq6m9noepbIaG5G5ls=
X-Gm-Gg: AY/fxX4pTew59eJcbufUrM45ZwgpackFgq8gq9qiQ/VTvm9NnlA5ugNQeCa7MVcaV+L
	0jbobVD+InIYA2O0Fe9GxO/F4zoKK3PMXokUcDsmMytQzznDIjDT50Sb5j95ara0BKbatf9U7Pc
	f9bBTSDYMtvbTkYwxp4gunKwl7upKGCxm0uSkhLyOSVbbl/uhvA4ZZCZrFwpUUvFkDoGP6boqFx
	GRlESFoE7JTfAYh+0f7z4jFDfSwOiU5j2oyMqU5WynaJ8rcSUY75FNrLZu77pEHaE8zfg==
X-Received: by 2002:a4a:a785:0:b0:661:1ad6:1073 with SMTP id
 006d021491bc7-6611ad6142emr594747eaf.52.1768571322731; Fri, 16 Jan 2026
 05:48:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260106071507.1420900-1-chenxiaosong.chenxiaosong@linux.dev> <20260106071507.1420900-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260106071507.1420900-3-chenxiaosong.chenxiaosong@linux.dev>
From: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>
Date: Fri, 16 Jan 2026 14:48:31 +0100
X-Gm-Features: AZwV_QgCsOn2kGU5CuFyzW-nNL_JZ_DPfUqP4CYecXPaLQPYZoAs2g5KAZSBdIY
Message-ID: <CA+5B0FOT_H1vO+9cfSbpFsUauQ_V1KM0GGKjp=+_K+z-SEWNeA@mail.gmail.com>
Subject: Re: [PATCH v8 2/5] cifs: Autogenerate SMB2 error mapping table
To: chenxiaosong.chenxiaosong@linux.dev
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com, 
	linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

May I suggest using X macros?
you don't need pre-processing and generation of files and you can keep
as much metadata as you want in the macro at zero runtime cost and
build what you need.

You can have one .h file like this:

#define SMB2_ERR_LIST \
 X(STATUS_WAIT_1, 0x00000000, -EIO, <whatever else>) \
 X(STATUS_WAIT_2, 0x00000001, -EIO, <whatever else>) \
...

and then do things like:

enum smb2_error {
#define X(code, val, ...) code = cpu_to_le32(val),
SMB2_ERR_LIST
#undef X
};

Might have to use typed enum to get the le32 through
 https://gcc.gnu.org/onlinedocs/gcc/Enum-Extensions.html

struct smb2_errno_map { le32 code; const char *name; int errno; };
struct smb2_errno_map smb2_to_errno[] = {
#define X(name, val, errno, ...) {cpu_to_le32(val), #name, errno},
SMB2_ERR_LIST
#undef X
};

Also you can use bsearch() to do log(N) lookup. But maybe the compiler
optimizes a larger switch to the same thing already.

static int cmp_smb2_err(const void *key, const void *elt)
{
    return *(const enum smb2_error *)key - ((const struct
smb2_errno_map *)elt)->val;
}

int smb2_err_lookup(enum smb2_error err)
{
    struct smb2_errno_map *res = bsearch(&err, smb2_to_errno,
ARRAY_SIZE(smb2_to_errno), sizeof(smb2_to_errno[0]), cmp_smb2_err);
    ...
}


(code untested)
