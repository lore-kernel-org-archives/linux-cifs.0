Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F5634A3D2
	for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 18:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761330811; cv=none; b=WWTW0nOZlZsaMgRYsq5VRmOlyQp999AFCh2fdbGXXWcC8s1WYLQu1NrMLYoDpb8c4fA2njpJJ1WXsFcHn/zX6cn7uNxmtdXQgPPxeTSrwfMPha0HoAcQ4Xm7LfVjONA8TZKXL3ReiHufPfNlcZ3cZpX9bFQgUm2gRNcis+be+9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761330811; c=relaxed/simple;
	bh=Nd5f5mvR8j7Rl5+8OhTw3H5NlwT9LRbX/j7EzXiov8s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Ari+xFkwnLp/YHPQ475tbkSLw/rI8kJ5S+9RgP2ldbN2/8RZLw07X+NFC4U+AS2dPE2XjGWHBZFFkXcEVQqiic05/c3c7jImWMbxDQiIW5Bz4kDhhUeDmKuXENIcvH8r7julw3exfVnuo0XO3N91JWcI3FTwv1WRcw3VYEBkTtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ed/K7uk8; arc=none smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ed/K7uk8"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-63bcfcb800aso2710328d50.0
        for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 11:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761330808; x=1761935608; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nd5f5mvR8j7Rl5+8OhTw3H5NlwT9LRbX/j7EzXiov8s=;
        b=ed/K7uk8kvhIczIYMmGthGVCTDmEDXqQA8qDcgOo/TrFJ1qVL1G0lm2HYBJmc5J1uk
         Gi3kzINJWqonri14bsfA5J6ZPCYcuM8TmPS+A7qRLF8c+ep4vzNzJtbOPrfxoZlpajMd
         M+9qntEbh7PJvqHmXLhXfHmLhqMUeLYHBhhWcAtj8SzLGs1qis06gpo4jc7NCjyXnHFy
         W9tX9EjMhFNMQyIaNOpSD+rqSJvDf0i9g9ajlzpbhHgn+IrYqAPxjE6nKZccyhJPCFvP
         vKHQ//lXgUGf56jjBFx9mRTEP/fEz7dp8YlCgTaud7lcfJAtpbhQUqmBxd7pIJemkIF3
         yXsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761330808; x=1761935608;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nd5f5mvR8j7Rl5+8OhTw3H5NlwT9LRbX/j7EzXiov8s=;
        b=bu++q6Y6s3QvFsMemqULCGW56iQKvGKHbAx6yVUzcWJ+488dgldSVF6uws3GPjd8fd
         hizMv57X4IjjNEb0b29KdNOUl0+vmRn6uftvTsXBNOgk83G26MUfCmu/Kvfk/Fvtb7tF
         8+7RYs/MOO+IB259TMAZa07kGwGQqrkwr0DcRC0CN0GqQfScpxpidu+tujzHoyHoe8nj
         3KmhkHetCWu03SQR1ZxZJJjnE+w27+rh91UXJ0+5ScpVpfEF3mIwPopJOnWZakOTZd0w
         AicBfmGkS+vox43+1w5wefx4c9C1GMFivtkOZC+NG8Pv5IUsCFh3NJUnG2vk09bUbV6+
         s6Sg==
X-Gm-Message-State: AOJu0Yx/uyPo0v3Ykyppf62zamGZfKYI9WZHnIg+dlCMCjUQVFGbl0gH
	YK50xYB9wfWtuByPwRyFxQSwc5LqzbKTVEqNUkf1n3+M7dyMRi0hEpXazvrEe3uAXM6idM/d2BP
	mQIobvfe4sIKs4bvCmTN026Syng/5vIpoI+BY
X-Gm-Gg: ASbGnctEN7s+WCBPlKYTRwf9JWgSNqoYNu1ENXScXtU5SjQVCvoTdO+HF5oqRpb6bjm
	NS5YhdlfLPpfzyAO8n/tKoAVnoeMfyW7nP7Vq24/2Ho4EugTZSOW4daBaG+z84k2OVwzJBOURy2
	HjYljU9w7auWeOj9MkXrP4ZvWpRy4PehV1ytWKdbLcTOcbU2dhAq6jYno3+ibvfWPkcRlliqbFG
	GZjzMeuAiZS7vhftWne6qidOrm4Pq6PLdIsbI1elSidZE4NpscGtbOWPL3yb6SaGmJK8kMyV/PJ
	hZhlz1iqpx6ynExf8xPCziupESHaGjtSrWv95g2NTmOxSCzZ4PjfWR1O/sw28C37iNnRD3UQULK
	g7w==
X-Google-Smtp-Source: AGHT+IFH4dkrsjekz5zLoYJycMeSA//vlC6KRDSvmZdCLJmn/0Vt3nF/Y/kPNinwtl+uy4vEP7qwnDrNh85/lBewVTM=
X-Received: by 2002:a05:690e:d53:b0:63f:2db0:9968 with SMTP id
 956f58d0204a3-63f2db09c2fmr8169729d50.44.1761330808310; Fri, 24 Oct 2025
 11:33:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEAsNvS5RbZ293x0iL=Fcck4m7wKgn1VeJhN-1kxvwdBcMVU3w@mail.gmail.com>
In-Reply-To: <CAEAsNvS5RbZ293x0iL=Fcck4m7wKgn1VeJhN-1kxvwdBcMVU3w@mail.gmail.com>
From: Thomas Spear <speeddymon@gmail.com>
Date: Fri, 24 Oct 2025 13:32:51 -0500
X-Gm-Features: AWmQ_bmilK2JjTCas_GCeEbphwk2sVkldRcjmZ3eQzzd-yt33ovfJedrIML3o74
Message-ID: <CAEAsNvSFTfBKjL-3WW_hnBC31WaOY2tOi5PAXTSTDQadTDS3jw@mail.gmail.com>
Subject: Minor typo fix for enable_gcm_256 cifs module parameter description
To: linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000297f4d0641ebc9d1"

--000000000000297f4d0641ebc9d1
Content-Type: text/plain; charset="UTF-8"

Hi all,

I noticed a patch was put in during kernel 6.6 development to fix a
typo in cifsfs.c, but it seems that the patch still contained a typo
and so I wanted to submit this tiny typo fix.

Thank you,

Thomas Spear

--000000000000297f4d0641ebc9d1
Content-Type: application/x-patch; name="cifs-doc-typo-fix.patch"
Content-Disposition: attachment; filename="cifs-doc-typo-fix.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mgzhskhi0>
X-Attachment-Id: f_mgzhskhi0

ZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2lmc2ZzLmMgYi9mcy9zbWIvY2xpZW50L2NpZnNm
cy5jCmluZGV4IDRmOTU5ZjFlMC4uMTg1YWM0MWJkIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50
L2NpZnNmcy5jCisrKyBiL2ZzL3NtYi9jbGllbnQvY2lmc2ZzLmMKQEAgLTE3Myw3ICsxNzMsNyBA
QCBtb2R1bGVfcGFyYW0oZW5hYmxlX29wbG9ja3MsIGJvb2wsIDA2NDQpOwogTU9EVUxFX1BBUk1f
REVTQyhlbmFibGVfb3Bsb2NrcywgIkVuYWJsZSBvciBkaXNhYmxlIG9wbG9ja3MuIERlZmF1bHQ6
IHkvWS8xIik7CgogbW9kdWxlX3BhcmFtKGVuYWJsZV9nY21fMjU2LCBib29sLCAwNjQ0KTsKLU1P
RFVMRV9QQVJNX0RFU0MoZW5hYmxlX2djbV8yNTYsICJFbmFibGUgcmVxdWVzdGluZyBzdHJvbmdl
c3QgKDI1NiBiaXQpIEdDTSBlbmNyeXB0aW9uLiBEZWZhdWx0OiB5L1kvMCIpOworTU9EVUxFX1BB
Uk1fREVTQyhlbmFibGVfZ2NtXzI1NiwgIkVuYWJsZSByZXF1ZXN0aW5nIHN0cm9uZ2VzdCAoMjU2
IGJpdCkgR0NNIGVuY3J5cHRpb24uIERlZmF1bHQ6IHkvWS8xIik7CgogbW9kdWxlX3BhcmFtKHJl
cXVpcmVfZ2NtXzI1NiwgYm9vbCwgMDY0NCk7CiBNT0RVTEVfUEFSTV9ERVNDKHJlcXVpcmVfZ2Nt
XzI1NiwgIlJlcXVpcmUgc3Ryb25nZXN0ICgyNTYgYml0KSBHQ00gZW5jcnlwdGlvbi4gRGVmYXVs
dDogbi9OLzAiKTsK
--000000000000297f4d0641ebc9d1--
