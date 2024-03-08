Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DA819BDC
	for <linux-cifs@vger.kernel.org>; Fri,  8 Mar 2024 17:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709920170; cv=none; b=rrkqwpz+YY5LNZQk2PfsmxkKuNJJa0mAjQEvqC36szWdXul0Kle5vfBNF/WppTE6DJLOGkoT12MgAepdBMFbXj1icjSkaoOBdSdCLvan+/jpoPA2QsmSotpdfSzpy9P5ClGJghChFfWehEDFx+4YZ0iG4OCaAtDzPnjY0GFpTMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709920170; c=relaxed/simple;
	bh=3lVQ0n6z6vn8bh08EeENW3ENdh3VJ465aBA7MBN2WCg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=qP9l4hW0aZtRNWy5KrPeoM/diQGa9hSyK+GDf4/NaA+RuBAguYf12VHsO8slPshah5AJ21CVX32GQkAl/DNs8xSoaxi4FS5gGAeAPaGkrf2+y23WqZLo1pH38vj8CJj0VddN8rEiBywbQLvbEYL45eiA9tLQy7MSL5rCs/pIGsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hpNQRKmc; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hpNQRKmc"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5131c48055cso2687113e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 08 Mar 2024 09:49:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709920167; x=1710524967; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wlbLtZXgEaI4rt0yXt9CSbJXdBmkHrpIpsXIvGJYQRA=;
        b=hpNQRKmcvaA3RhSpHJIBkHgktHUTCNSc8dX6MR+FWCe//ssihM3EkTlOUdWIOP6LMu
         LLE1Nvg07jLiUr/4vnZzvTn245jEUoQAxaDMcBXTYKlXja6rWgyV1QeEEGUl9FZzpooV
         oy0rIgZCw1mrYHK7F3ByuAjL2hmFVuzdRmLJrz8/Ab5wKDD/WsrcCa28ef7fkjp0+99E
         ERlOKGiXX2jV8RPml7ZDGDIfBxKABdGzgCD/bNuVIquCW6nVc+ZLY/OvcJ1mFHEDnDTP
         gMgCWuU6Ro9Cn7NUxyh8NewqhdUyhBcaHK+qwjETOVzEvIhmN8uogAd5A0wNAH2RQ7dA
         k2hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709920167; x=1710524967;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wlbLtZXgEaI4rt0yXt9CSbJXdBmkHrpIpsXIvGJYQRA=;
        b=Q+MMWtVEjPrmJe0lNDzlv4buL1MOHyt7ZO/q0m7sEfqf6EOSlqlnt8fDR7tIlsqnQV
         VyxRDyiR3su92yffqQGvdauBAm8z29BTu8MLvlfN20nDEM6WFhgoM/IMMiVO0RoDgT0f
         0kPBJH53o55QbTjtL5bCk90EiqAY2LpP1KVzQUelO8rWubJUSubxjy+buANBN72Cf2jp
         jnF2tFmmiTIsqRy244mY8CSvmXxlPkgw2XIVcUl0PamUrXcUhcKyWLYNrAX1tlBfWjIk
         I2COo8ACerE2YyXprxZeQ/hozuZY5aO52LlCTWCX718rDww3E5PFbuRl+ADHsA9dN1dG
         TUZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVF++LnMbBZRhjMkzAFMYm1SBusUzUfLLrSYVOusEvwjn0PXG0lNP1VS8zSEhFK2mVkF1VhVRJX4MlGKlSQ/LvhlnhGQ7l6KQzgiQ==
X-Gm-Message-State: AOJu0YwgzUMFCOsJ3rXOk6zfq5uHtVZ5s8xE/qtrZU5uxb/yhLY9Vx1q
	26PwTrCq7AQIRAeBC9RZvQ6scWGwjVQCpG/oqjC4TuAwVOkdLVcbld9/uiWeuAs44JX4Ens473O
	sRiP935YFVFG7w34xUoKJEiRtGfEd+a3PiAo=
X-Google-Smtp-Source: AGHT+IEsnktHiF96vRlbLbju/MJU0e+1dqa9NSW9JnJ7Eszl5zuAjQmw9MlC+KQ1Oove2FMDcVfA+9/g59R8aQhm56c=
X-Received: by 2002:ac2:5e35:0:b0:513:1c6e:583e with SMTP id
 o21-20020ac25e35000000b005131c6e583emr3678635lfg.61.1709920166842; Fri, 08
 Mar 2024 09:49:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 8 Mar 2024 11:49:15 -0600
Message-ID: <CAH2r5muMVdnu2txTdz5YB=1rYNeW6bw_XW33prkLpAcPAez-jQ@mail.gmail.com>
Subject: test generic/072 crash
To: Shyam Prasad N <nspmangalore@gmail.com>, Bharath S M <bharathsm@microsoft.com>, 
	David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.com>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Anyone also hitting a crash with generic/072 with current for-next
(6.8-rc7 + 20 patches, perhaps related to David's data corruption
fix?).

I didn't see this locally, but I see it with the buildbot (but can't
ssh in to get logs unfortunately)

-- 
Thanks,

Steve
