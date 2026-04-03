Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01848346ADC
	for <linux-cifs@vger.kernel.org>; Fri,  3 Apr 2026 03:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775185401; cv=pass; b=u3wuh+KZV7u9Pp7RiDO9mhbF1pkuragfQJ24H8dNjA14W/YigfK1+Vw7Fu3OFxrEyrvIPxTntccdwazpmrWBZBHj7dLrQijluKC5ZnSaoCw6Ud83eBcc0dYDFdi+8YJ3QO8WNt7az9V9hz2fW8Ihqd6DizqHsWirE3uw5X/Gu4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775185401; c=relaxed/simple;
	bh=Fy3MBjDjUqVmqPdioW8p/7np0y2vH8BP+fUSCxl0dVw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=cwxiuEVDv+fORMNaGd8VVJBaurW0ZXt4C/wvfu4EvOahDvfBmqbuo+JpR4jb6/kueaGUUVmFjbvRXWYqnM+jw4YDVw11T8YZ9Cat4B2yZ5jSC8xmPUpQ1ogVMKZmAyxWUWA9MwqKDxm9qxm9llapby9/bkSIphzz5o2MV98oUVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c0b5w0sA; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c0b5w0sA"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-506251815a3so14442311cf.0
        for <linux-cifs@vger.kernel.org>; Thu, 02 Apr 2026 20:03:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775185399; cv=none;
        d=google.com; s=arc-20240605;
        b=J0rarzxCfzvZrUeRAUv/4ISNPateZVmFN19ZD9UWvTz/MvN51QxVD15wQPL9G+73Eb
         0Zsl7kyPl6ryjNHHLgRkiCLLZlaFpWqqq77m+csVB8xKN5ak0YToLR1a95UVuEDrlgGy
         4evbEWE1wNpAZyvUtd7EehXzkCk0TFFI8PN1ZakvaVdTwXzejEMLotSkiRecIhr84yx2
         VCS1CeMuhPBKYKfO8hwvpqMczOp/b0le9aY0TIDtw8fisOhHai7XKsvajABnxk12Ti85
         Y3tARDUzasAdrj6gTkZFDRbQ9cR3ADmlcNXhSsDlMuw26VCOAWv7vm5e/VcD18IL49Sw
         vYyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=fCA9TEgpdo/F3AVKfITv3TJSZ11zzVI7GJVVJZZcRss=;
        fh=Dr9vMbF007G1fT7e1KY6tAEhic9to8TB1cGLdeWb6ow=;
        b=eC/FKSfv2uaHqgYljyFfR1+KHLl0GAdEPInDPn+FYq7nqH5mpreoBG5uT9YvSuRS8U
         xGr+IS7qjPQO15/apv6mO/Yt7aWzLcB3fBvpAUB32oXh5Bq9D7n+mb1k6TSzLu1l4nZf
         JG9mokjnFti15WUmsO1C3voObrUwNikKDbdBtk8XsxPZTgiayxazqIKDXwkYhQbWqjXP
         fThIzDeoRXK5cu8zzPVnjg6BO6To+ELLJ2ZI51K233FZZae9ah6gDPTiIT6UTDR1qeGa
         4m/pn6FmBwIRq9Qee9qxy6Wkp60mH7V4zCDVRLr3O+ypg4b5JaJjuFana5FfYkrP/DZA
         SSYQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775185399; x=1775790199; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fCA9TEgpdo/F3AVKfITv3TJSZ11zzVI7GJVVJZZcRss=;
        b=c0b5w0sAK/NBOE7GSMN7ule6hTWPoJXohFGxwiqMyXX/VsTCaDyYfoni6oTer2JUNA
         n15v5tDSvPaf5/tqkor2zY2PTYhr3u+ym3ZADuCq/r/vHFkq54PF51t5nBvTDOWz4Y8l
         izA1ShczYcTiN9rbqSy6JpvK3E2sxKnYetbasMFiFONU+4LXOaMUWUIcR6C9rK6ywbVb
         uAqEBubpVc7yDimWZA43naf9/8ce1bS7e/V9oCdqmsbRktObzeQi4W7F35QNV4c7vSTB
         ct2WjyOqUPMVLEjzezf3dxM6wypLrNP4IQ4ym4iFrv691BhC1OD+Qo4ESd3+WjbygX9P
         QVAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775185399; x=1775790199;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fCA9TEgpdo/F3AVKfITv3TJSZ11zzVI7GJVVJZZcRss=;
        b=YKHcv+6BresyHjXb5379dLrTH9HC3f7XA0hXrV5lP2F7gAm/C32zYp2bKWXqFI4EXy
         YuGCNLJptvbEASIUowVAJIcj7JiIeKhVDeBoaOAEf66Ih37gNnBhOuymuAv30D3ePjyB
         iJZMJnh2NrRlhW7nNEi5kFDgr9R/jeoW+sK06rv7qqjZ+bhPfkh86fcujCGPgR6No+KJ
         7p6S93cCrIf/nONDzYlJv5k+vJbiz2GZjpy6XerXXvsS7FQLI4DWgx1OGJguepkaAlGW
         BoYxtvSeCgB/6TLho8PFGtYlrr63y4p49im/o3dJZcERySTT4pTtos6tBc890FnV3HoZ
         ibuw==
X-Forwarded-Encrypted: i=1; AJvYcCVL1RYD/AeqdDVos9ouFpIF32Q8AsFKq7ilamIPzzG5Mv+GRcNc2FyUhs03/Hos77/ivGXEz50EC58a@vger.kernel.org
X-Gm-Message-State: AOJu0YwTgO0LPbF7io8/KZ6VtmY9wG30gqRz0x0p2wg1iV4sSt7kH0yZ
	PHIEfJ5LjUzqI6W6UO6fcmNAtspECxA5T8+aosjPO4y50f7kRqriTairIj3U7cVdI3oWjgi9Vgd
	3hFYmrxytWhZhgbCFqDdJ4sMvmLD1u6SC2BW4
X-Gm-Gg: ATEYQzzwDNPKvdvQ8vVhnj6XDNr73ADxQU6FTsLqaIA+SgJMTmAY/c7iEJPCrjQHthu
	MhKr24yPafZ9OHlnxBE3jgo1g7zFn2AJRjB8gBeBfUuowZPrP3V8cpGRMSKmQNb8xINrDo4HZOj
	kLOuVnOswVsxrm6JhtaAbbKZkbxBhij7d/ErV5Gab3wwoP26jCPTuH655HWXHG4cTj3kTuPa/PZ
	VScI//4Tc9vQiBbPjrN/3tqMGo6jqNB3cQ1H7lhOYyKAdomJVTYy8ctkaN3XOv6+M7N55+yevqZ
	lceXxQ8AmA+a1ugVh806xatC2/XNnJQoYCOhD1+mPuQ605I7Drhk6ukCQqbUyHmeIr402GJOB1c
	dg4BQ58ZJsMEQMxq0o3UFixbV+528h/VHITCjqguyGL4sXu9nGrFfu6PpNGJKoXag/iZ1MQsLOS
	HVbQKthl9Hi05d2u4ei2FQ
X-Received: by 2002:a05:622a:30f:b0:509:127d:ee06 with SMTP id
 d75a77b69052e-50d62b4373amr21604501cf.58.1775185398915; Thu, 02 Apr 2026
 20:03:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 2 Apr 2026 22:03:07 -0500
X-Gm-Features: AQROBzCZCBz2j1ZriuiJmBxmnp3FJTGolaDOv55_3rcXS1j6FUyG7t_ajNsDO8U
Message-ID: <CAH2r5mt3DJXG6L-x-4vuF8mf9Gj2=ZBtGrNwf=obHzOtXWd-7A@mail.gmail.com>
Subject: [GIT PULL] smb3 client fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
7aaa8047eafd0bd628065b15757d9b48c5f9c07d:

  Linux 7.0-rc6 (2026-03-29 15:40:00 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc6-smb3-client-fix

for you to fetch changes up to 78ec5bf2f589ec7fd8f169394bfeca541b077317:

  fs/smb/client: fix out-of-bounds read in cifs_sanitize_prepath
(2026-03-31 18:21:14 -0500)

----------------------------------------------------------------
SMB3 client fix
- Fix potential out of bounds read in mount
----------------------------------------------------------------
Fredric Cover (1):
      fs/smb/client: fix out-of-bounds read in cifs_sanitize_prepath

 fs/smb/client/fs_context.c | 4 ++++
 1 file changed, 4 insertions(+)


-- 
Thanks,

Steve
