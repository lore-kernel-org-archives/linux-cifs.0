Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B405A37998C
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 05:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776319184; cv=pass; b=VUllX3Oaz4UAQ73QXoc7CfNJhHoEFHBnq7ne/pcph8D9FsEWRcLIjfUcj1xQWBkEr0iHvfdZkBVek7RSedhpGTaZpRgXar0KGpUo2ntCUTs55gI+qkY/n1O+hfIm2dlR/aAbpTBFh5rqsX+uu7k+MOSyzW9UpJ5nHyPDRUKECNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776319184; c=relaxed/simple;
	bh=JKPf71L+a3LqSTtuaa2E0MYmPTNVdq5Luz6eBlhQBZc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VeyBpEKL3uB0owm19mUwGqGB4qqShWRY8OvIPtVdFsl1imF5Yh66Ni5eTEQANcMh1fs4RSe6sXXwJSS/t1NvqnRerWHH5jpkGN8i6WFhRwElw5dCPH7vGw9tamY0OpNlJs5KY398rMMxf2tmm4g/jllpvs6uzVBZeMwB9UWLM4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yr9r3RDR; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yr9r3RDR"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6714f678bdaso7445246a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 22:59:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776319182; cv=none;
        d=google.com; s=arc-20240605;
        b=b1OIJKdNM3HEYYyi9uA2943+kptilbtRhqaZdQ6wuMFraoGudf7st7CdMT0dZ8BHN5
         GFqAD9g7fhODvRn3Ec33ajXY6RHH7R1b4pjzzqDdGDn9JhbklznmMUKZSPKbJB2W7l+c
         xZ8h9Dj8CKFEl9rA0pdqZGbs9vRE0xDtdq5cV3q7nCWj/4q27ZAcO+fpmKqTq3sNqmSq
         xewC6DCu+XMTvOX3qaBwbJ6ICKzZ3ObNgaSgkteARzauhPf4h6V6B96+hS82THdOYmkW
         svL8AnQEl3E8vaxZgaAUZnE9/f9taoyMlpMtTPNhdgfCrHX7g/FV7F/3J+FOm/sBfLpi
         Wp4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=JKPf71L+a3LqSTtuaa2E0MYmPTNVdq5Luz6eBlhQBZc=;
        fh=RWGhQ7/5N7YpxllXddGLasQMDR7Jj04Z4xwTust7CJQ=;
        b=Gooi7vRY4/d/+BQ7luArxgK5d8CYp9RI7pqj/m0lTC1tp849uNszANR4SK4FSi/obW
         8EQnAqfgNjcu+QfO37TY+otwDRtA7pzoegRzVmaQ/YhfIeq03aB3KfbX9jcGxzHkaBI1
         JMvctdo9qixP+P0VVnqORz/Ui89KoHpmqwl9FvuxiuRZAUwOQthtG6k/9anpXE+aZXwh
         3u+jKmatjN3a/uxPW5BYpe/mn4mKqgVxuxXku95S8mywgxLw7IX+OabthD0YKTD7K2GA
         10qAs8ZFN8jVyF9drTnKmoVfhZvEv76Xug9godW/CyCh5L+rKol6vYdWIWnh41ni19js
         zZ1g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776319182; x=1776923982; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JKPf71L+a3LqSTtuaa2E0MYmPTNVdq5Luz6eBlhQBZc=;
        b=Yr9r3RDRcYIfEB8+f6iJ1Cx8CHIeXhQM8tITHnuIx8r46ia89c0fGpqfvLW6MAb61j
         j0hDLRBGjYma1OjnBy+AekkY+YlJMNN694LhJ7GS4Vyinnp9MI7K23/z3/450GkhDWnC
         yzFp0wez6hnppLDfXUAJzd5DcZGzA4xyd1LNvvAPzUT3jOV1Z1cfuBsPlYx0tMVlVUZi
         5O2Dfs5G7MdB7nGZxBkRCeeBVbf0v+LbaytWFo3Nh6fZq1t9B1WG9E6aGw8agMsyXnGA
         Dw00aKJPaCWEvNr/Nu0fvjNYp1ZbxbZFNrD4Fxkr5NtDm1RRGwFlskVnVjDoeST6vGEY
         U3rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776319182; x=1776923982;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JKPf71L+a3LqSTtuaa2E0MYmPTNVdq5Luz6eBlhQBZc=;
        b=PPgaLFrNTKbdnGSanp0VCyy14w9WRF8V4u3Pw2Z1N4Fph/+yc1Nra6qikR1beQz/ef
         lbpbJxKSnOs0/OlN7NSSzxsnDxskx00E8P8Xa9MxRsOYmR3q+x32MHvwT5l0vTWYmmUq
         LuNJqRSLcUcav6qnBpSg0MwvK70CAlK8tgI/KgiKSBfKm6ljg/FJTfrLzVVjx+Ct0pZC
         cmLbj2A8fYxnj2dNK51OjPkMUH9SJ29a8dIXlJeBs/EjVZFEb32rBcVwzIXE5vpfxXMK
         IKGvFsW95sU2YfK8Bb5xqIDcsCcJPz+jIQyP9/3L4TSRauC5v3AyqA3qKXNfR25+Pt7P
         xEgw==
X-Forwarded-Encrypted: i=1; AFNElJ+Q4UU4WiLl8z3OoUkc4gHQgnMrW7gIYvrJMvUhAfyUUb0vXWjQ1Hfx3p9IXIBjqTjON0AUfwCefqY9@vger.kernel.org
X-Gm-Message-State: AOJu0YxlaGh8jExX0NNnTURplhJG2Bde99tgb//OOvY6S8ITjS51T+Z9
	u4FajlKE/+ezJz15DWiRaC2cz1yk9XOOE6jqkrsnLDsYAb7ovOJ6bqOQNaBAV5f8Co2H3qB3Yt+
	/PG8FZZGxsHqqCF/UDtpMuneE0Gs78rA=
X-Gm-Gg: AeBDiesSRn4KMe8BAg9xTnTOFXjlA7FZv1FVcqeyY4OYETabzfXhry5qnzTlHoFHegQ
	XPXkQ70b2HfukN6kPLbiNoClxrECPng3a2umlqLvZjUy2ztIZFUJY1NLEfZabc6/xFcw4KOVBgU
	nKAqPBx/BnutEjJ7ljYrNdV/gAsljcCrC2HBhFXGT9fh3RJB24FrDTPE5PiFaO4cxz49ZY68Cbt
	7WReGPo/LksL8FXV3JVymqdeagwtY4jGKGWCe75hl8Hj62r2IhTXlYOJgVs3Bt8tQ8fS8W2q3vD
	lYvwigqqcO4Gv4EX
X-Received: by 2002:a05:6402:5213:b0:670:2ca5:bcde with SMTP id
 4fb4d7f45d1cf-6707a47083dmr12515365a12.15.1776319181943; Wed, 15 Apr 2026
 22:59:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260413191110.1508848-1-henrique.carvalho@suse.com> <20260413191110.1508848-2-henrique.carvalho@suse.com>
In-Reply-To: <20260413191110.1508848-2-henrique.carvalho@suse.com>
From: RAJASI MANDAL <rajasimandalos@gmail.com>
Date: Wed, 15 Apr 2026 22:59:30 -0700
X-Gm-Features: AQROBzBvURAag6kkCQysFO300zpgA-jG6N_ldgV9cbORFW2KEzDPMdLmWLWMLMI
Message-ID: <CAEY6_V0yKt1CbbyY44tRqD0VNMpPDA+e+n2C0f-FtOchxx2FYg@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb: client: pass correct from_reconnect to cifs_put_tcp_session()
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Rajasi Mandal <rajasimandal@microsoft.com>
