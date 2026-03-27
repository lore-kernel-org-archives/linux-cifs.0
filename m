Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86A72FFF8B
	for <linux-cifs@vger.kernel.org>; Fri, 27 Mar 2026 15:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774624120; cv=pass; b=BMrvQQyiitOcnMfSUwsVI8ADonz0sFX7kdeAEUaJRdNf0ej5ldB6LewaKTPPSB89I2MRgtMhTWOoWNFBJS5OzrhwYjP/fy/NRI0H7hmpA3lBW2jYlhCkAV7BKQRaYi69aRTEGEOiCPZgH9yk9WxtYNIUDksu05JVAYaedNakhPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774624120; c=relaxed/simple;
	bh=CY49ntPruTm/kt3GjuqP+NIOIfwvW9KllKPv/L81pWw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=th2OSirV/Deoh0rqafyO3vWLNL96bl4Z95ZJfRMs5k/xsoy8T8pYycH72g0a7kxPT52T5BUEnxZ0atpcfqicWhGmgaNRuy26+X1BDkJj9GOlTPE4ijL1mn99tNUoV5YGnUu7LnzgC2WaSZWB6DmzjC/XtvzdUP7jheenUSkRxU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P7atzvCZ; arc=pass smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P7atzvCZ"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-89c4468686dso28749506d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 27 Mar 2026 08:08:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774624117; cv=none;
        d=google.com; s=arc-20240605;
        b=LdF8U5OVltUjaOo1P1lzze5YM2zk62rTrJyv0fPyAbOYImLPHD1jguN42dp9OzT6YV
         0jssYH3wKbIExG1snLqYb5c0PBAq48atHvwvrHjw1ulGl8uYTRPZdWNheX64IfupPDzR
         DOtpAdYxvmC+Tb9TUq6Zfp21Yul+YkLCVT1g8CHO974E3kwHW0wBOc2L5eN6lpt96Sqd
         PvXko17QpYJXbZlKwgPhnlMlTZ2kG9yg2VKqajp+tK4Rf62AVu1sTA04uH2IVFcGp6/k
         6QsCV9kzhhmc98Dr7d9xwAR6V3DLNniq4AlUW5MySV3PxCbSxwyOExX3Jr1wEzDX4XMn
         nNFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=8AUHIZlZ3txbkGVv/9qrzPXja7JBtWUm+jY9lHvmLww=;
        fh=V21WnHa5Bp0UwNuU5h6XhKbr/piNqURsXp58x0ll9oI=;
        b=F2TEOdHOkijlyNx3XlLzzKHQwLgZGuSjtoHzgZe5rcgUvHuL/IcCCP8HR5ZXuZp1w2
         r3bc/bmvpVs+/a8D17Cb2Lp+eElBGHi0FSFu1fssAF2yasyLUmbELMgfkPew16d0jl+7
         4pik2I+S46FlJ/qnRQal1oyyO771ExLU0cgtsigJjEHp5UlFEmo4KTxavKU6hik890Lu
         gdMsyFNKZ+vNJBawv9LwDcL/6Xzj5vmwDkcpMDxfzj6OC0O3nKF/1DCbU36GTRa/wv25
         D4QS5bOPbS8IwFSxejbD/lA31cANnawpCnakLKQZY48tIOmRCu68o/H/Ib3fXWzM0IKm
         34cA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774624117; x=1775228917; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8AUHIZlZ3txbkGVv/9qrzPXja7JBtWUm+jY9lHvmLww=;
        b=P7atzvCZnE7kblzFo+UqE1zsWV6Qsm1VEs5AbZeioDg1KvtQFBjAw5LUjZR909Z9ZH
         5r21nOQbdothYWreF8Y/d7DqSHxlPG8KIo3JtLAmPqbD3mBlGF9ujIMwIQQtMpjDAkuY
         2UVri7Yy88CldYWI8PkAntJNA77eHdnqgKdiHEefBYWj3SIDsMNA50awXQGADDgR92PQ
         XBlOdoLRi7KktxN1uNPWEobfWmkSS9QO4ddNDFOaRA+FFRgKzhTv9FStttheAIGSjK2u
         UzLG6sGA0FM9bpn+5bZoOGZbRS22RV8eHic+o+TzOIRKk4Msnny+CnRdCHjVwzgYL6DK
         HECw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774624117; x=1775228917;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8AUHIZlZ3txbkGVv/9qrzPXja7JBtWUm+jY9lHvmLww=;
        b=ZBPJ5Y98ls9MesbZPTPxMVj25ccS8ZHyPjM4Xmyn0re9PgHtSbFnVsuvIKEnHpb13X
         4O6jkUhwuh0Wt1ZqXwDCJFJ8qNqqS+8n7ocyo4rvzdvMTtpbXqKUlFdS+i0kbQUb0Iy3
         bhZP7E1+xtnZp+ZFGvDKpmwKbS716mORqZbLKNbjS2GIlHhotEB2zH485eeR/uX4VkQ6
         CwAvhU8QWKJB+G8rFvxNXYkmUjFJQOZBCm7Tg/AfcJrUyUay1RvExcvaT90mASAcIhXO
         nBpq5oNwyodvSs7O3xc387OhGcp9+Xyc1Tt8mxVqxosU70afPO+Sz5dBVy7Fd8Prpo2O
         FeaA==
X-Gm-Message-State: AOJu0Yy5iLZC98jOIi7exF2slPizbFUOVyJhLDbtdF0IR4g0Ohq7LTUs
	MnIIyZMOOzx4ssMbdoKqDAMdVF/8oxHQSViKsnRq429Fcn5laHNB0I+UiJkkMslF7Ql/7BSkOUj
	xunSdmTR3MK6oqgMoItz+Z5LXDeVs0jdRoFud
X-Gm-Gg: ATEYQzzEZtYvWTm73U2GvHyOIWHHsX9Nq03orVAk6ODuXtHLwdFsZp+eT1iqc/zebAq
	FaHGI0RIX5xz02h4zMbSVe1Md2d1WnYjI3v8oeO3CPS6hixjddVByp7uZiUYblZzA4GCxl8ajZz
	AbhMgQV+YdYiXZCcqvdA8RimdsHrmotdke0w20OuI+uuGutoqgmyjS8891jM8eUKU0X6dhR/rvP
	w0tE3OUFTVeSGNZRC5vvdcERwo+OBqvRE9vwBtgOMq22Bl2/fK2sN8RWlMrC/UWjINiJDvaJ2HC
	U9TjcdDWzKYrsjYuRFZORpp+EVvTu7WjnD/rSL1JR/5xhAhOYXCf5lc60QKJ1GHZDoAfSurzKgc
	zMGO2zhOmbjpA3ABnTSWhCkBnmeVDEnnIabGJU4IKYzHhm22/rkDuDx60uT/ixmBoSkFcQiEjBl
	980BxRgaK9z5etGiN7OAkk
X-Received: by 2002:a05:6214:468b:b0:89c:e77d:1399 with SMTP id
 6a1803df08f44-89ce8d978d5mr39018996d6.22.1774624116983; Fri, 27 Mar 2026
 08:08:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 27 Mar 2026 10:08:24 -0500
X-Gm-Features: AQROBzAevneQCBDJzX4lul7ZV5zMW0Cpk2D1k4ZNruJufAbYC9eWwdZrDZx5s7s
Message-ID: <CAH2r5mtmSJLCNOeWrC4J+n0De6b6PypA4iNHW6FrmP6V_dW9Ug@mail.gmail.com>
Subject: full test runs of xfstests
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I did a more recent test run to Azure of all xfstests so I could
update the test wiki page (I had recently also done this for full
xfstest run to Samba), and noticed more than ten additional tests
passing as compared with a few years ago which is good news.

There are probably a few more that were skipped that could pass with
different mount options but was glad to see additional tests passing

https://wiki.samba.org/index.php/Xfstest-results-azure

-- 
Thanks,

Steve
