Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B732874E1
	for <linux-cifs@vger.kernel.org>; Fri, 14 Nov 2025 04:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763094240; cv=none; b=SEBokml0gkpleAi5tMgR5+/3Og90m1IVEw5JEapGfeiULmCp0pvTEij+D7W2XRjxA/wWq1delGv4LHxoEe2EjlgfkV9/4SSaMuxqYb0xYrm31wgq8HHufydqvGPNWUU2jGBv5mTiB4cTuzwMqxnH4QoSa4kGe54tyEEqQLGowKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763094240; c=relaxed/simple;
	bh=WOEBeJpH/3bKhTVqaUYh2cvoA49yCuEEq5rYoicQ6GA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=XvaM5ogxhT7gzuvFr0vFgKqTWaEolLr4YAb23EZzjlYB63+xgm8TptDP2DfAlSIfW2V8t3U7I0S3RrTULpXiyptkQB6JA3Y93+1Egvmp/IOEApPY6DVVPPMAq8ZltryjaiAhzOZ/i+67G2FtCRrozkkjroQOVlv4pkedhFwM2NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mj+0bI0+; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mj+0bI0+"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-880570bdef8so14637886d6.3
        for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 20:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763094238; x=1763699038; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JvV2JxBHeo8KCd7maFWWLWT7ClxwkPn2pGUJ4hTdNuQ=;
        b=mj+0bI0+fc1wS0H/EtaFIkgeP2Qh2ncXjD5RWuXfoiodCfSCTVTZH+O4udxowrvs20
         zAZaU7c0aTnasZHPe6txK0Yix4JIm8L/GIIdH6aXukcRkBPa+wqImpGYmMaYEpghNJ6o
         Rw8sUcy1sSjHuGytP+b1uDssr0MkpbRySsYy7nj23piEzNxORp0foKwDywM/3L7Oo9u1
         SH6D/DOplHIGWS/MUP8KYSsrDxg5JoO/OpL14AH23wAeVFlt+aGDSALlJaf03Ne0ectk
         iRuKrFJcnvzD4DmuwNkxzs1xl9g+HjUQi4KIKiUcdhZ7zvBf+w153PnlCppf5wgGKUjk
         vMyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763094238; x=1763699038;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JvV2JxBHeo8KCd7maFWWLWT7ClxwkPn2pGUJ4hTdNuQ=;
        b=BUsPEfSZFNYbzfOu7dLvy0C4tpPb/NlBOwNXa7ZtccadEWWGSmlERL+Oy5FabXgPSi
         aZMlwPGSqJP25GMjvWNP8iM446CzYqz22mUF69yFhQVqmHaadPqIh387kG8JvO98yAwN
         9bexepsc+iXg3YFwGq73sFiDZ69yHu0C/VLrROeh496Bm7kWZwPfSHYqoVsrSags+vEj
         B/fq6sgKuhs5xTkN04f8bCPWZIm/7XbUMo2ycSqKCbs6uDnW83DiIyJhjacd+SeTgZWP
         fL89CfQ5dKvOuQEGr+QqQPRlTdG2kPOZXl7t+2SZw1vJv9cux8mMvUczxQOzb+FXkcGt
         hfiQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1xUWqpgP+oW7o4hL+EkGNLFTAg0O8DVbj1SEGowwum2Rzg8kqkGh9QU+J5Fy5MZqnR3JvGU/LuWcu@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp0aSFmtwQ6e9NBqyUXUDqCRjL7wGaGBq9C3sgRIKCIBS7+SMs
	1lncGP9dFmlA8k89cvRehRUJbCrXmlvGxzQpyYiCstBKRKbBJKlBh/1j/+nKG9sF1TiiHMpslOl
	a4zYC73tju3umyEXEhgAHZm+W//91wFI=
X-Gm-Gg: ASbGncsp7xGs9lzGUq0H2LVSgEhltxht5zZqrYqhgQRR321cYZl39gDp0nHOg3z1biD
	mrzgiFNkAjAAN+TrQPW/VSct/MRtwn2+ropo1QNgwxhikJyAefJtgGYgsAGVYlNtXULcr0geFYe
	HuI38Bd0NCa0LmWQvBcPMH477XYy732l+mcUcMZYDCSl6jNEbXb0aqeg+ekWAgQxN3S4Lnk3QEi
	qSTSGBfGDztsJ5Kq7Po+tkUqsYV+KVQ1Lnw9agM9eszd/EW/8XJVEl1VLq//5PqH6BEmjuOY0Pa
	HUINUoYzTV/wUPwOBaNMuBxwOM5wOUn6eQGnh2qbdSml2QN/+92IG+3xwyfq4H3wcKfkNSlt+4K
	ag1eoqd4y+Zitlm34WOckI7XO6bu+sKgO/0Oytg1rJ/Sg8LoM
X-Google-Smtp-Source: AGHT+IEHig0zd2My9vAwftBlLBA8FFc4mRSvDgFM63diHInfaXG2wXUIsfLa5YKyuIa7kmzz9F+af8dJpG+aH1iWkTo=
X-Received: by 2002:a05:6214:29eb:b0:793:dce5:4540 with SMTP id
 6a1803df08f44-8829258f1e3mr22937336d6.2.1763094238036; Thu, 13 Nov 2025
 20:23:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 13 Nov 2025 22:23:46 -0600
X-Gm-Features: AWmQ_bng-tHFYakBWQhqx-XR4mftHX-CvYCuMiWBRg7kBDzDesKxUcuzuIlU-h8
Message-ID: <CAH2r5mvo7wL59QnXL5aBiwYYGMg9oqf4LtO1bu+AX0ym5YFQ9g@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c:

  Linux 6.18-rc5 (2025-11-09 15:10:19 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.18-rc5-smb-client-fixes

for you to fetch changes up to d93a89684dce949c2ea817b6f07feee9a45241a7:

  smb: client: let smbd_disconnect_rdma_connection() turn CREATED into
DISCONNECTED (2025-11-11 11:05:35 -0600)

----------------------------------------------------------------
Four smb client fixes, most also for stable
- Multichannel reconnect channel selection fix
- Fix for smbdirect (RDMA) disconnect bug
- Fix for incorrect username length check
- Fix memory leak in mount parm processing
----------------------------------------------------------------
Edward Adam Davis (1):
      cifs: client: fix memory leak in smb3_fs_context_parse_param

Henrique Carvalho (1):
      smb: client: fix cifs_pick_channel when channel needs reconnect

Stefan Metzmacher (1):
      smb: client: let smbd_disconnect_rdma_connection() turn CREATED
into DISCONNECTED

Yiqi Sun (1):
      smb: fix invalid username check in smb3_fs_context_parse_param()

 fs/smb/client/fs_context.c | 4 +++-
 fs/smb/client/smbdirect.c  | 3 +++
 fs/smb/client/transport.c  | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)


-- 
Thanks,

Steve
