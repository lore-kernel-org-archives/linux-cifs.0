Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81067A31;
	Sun,  2 Mar 2025 00:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740873843; cv=none; b=uEA7rZlmhRT8cggAbkNOeVPI3FOvMlxUePRQvfc3fODM+4PLedxIWg3tmMhhdTTrXC9ueaeXSz+KyBvpEgZcTvAmR1oWfNj/+mYllqHTdJY7UbBGKxc0DV78T+QuOxqDDnlV5oEibrnBvSn57cYCdsYiL9ZwZJFo1R8tngUtWZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740873843; c=relaxed/simple;
	bh=FQHEIQqLU+bNSkSzOsPHprxMyZmJzB3tcqTwUCSXz7U=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=m0i9On9mOanARo16M0I93i4Dg89E5GoxLfe3OnoMk7AaQMB+QPr8axMlF8TuRPDm0pAzgg/J1CSLdlk5snKsogF1IC9xfOBrwYvZfoX0gydYhnbPYgQKXaw1bp/OC6CHAKnSwn6MXtrpfU1Rn+SOKjdtwHz8LYw4L3JldRw2fmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AwgdQdXg; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AwgdQdXg"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5495c1e1b63so708793e87.0;
        Sat, 01 Mar 2025 16:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740873839; x=1741478639; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zIbw6YYMdLf5UvkTslQghX7D9/dCamp4LxA8/4044M0=;
        b=AwgdQdXgdokYGIJFrBnv6BSCIld+gcUZjvuQEX9ZuF5Ck86eVUK8F33BloFuOTCNVF
         2uYFnU6gKZ0o4SMx7ZQ0TF223VjFZTiGTwm80gG8IxtRfCgBuVL/NYMh6paSG1GxYhNO
         FUyDmlS5iyhQFd7Ck8w4RssGq0e9ZSC9sVNWu3r36+6nk5UCaBZWI7duzZmFHvMVWJET
         p6UNDf/liPg61Cdjgb+cwmSEmLDGiu6QbBifUf+fMAE5XZGO8A4VyIJjSl9ekfsp8Mmz
         X3W5L6oBbwSNVqPiIHMJPAjWWxF7pTQOonCzNdOzo/O3wzWeh9nO349Jxf5fVOpoHcLZ
         +iRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740873839; x=1741478639;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zIbw6YYMdLf5UvkTslQghX7D9/dCamp4LxA8/4044M0=;
        b=vQHnl61RKGsbbRT80wT+dVSTt3i3WeIemkxUhiivo22MIq2U6mqNwb0jhbHVQ/gC0C
         aHK8WfhIOc+fIcfa6zdA9cp+7FtM0O6iXr1tTJZcP5sI3FOD6MGQV1XU/oPpxx2ZIUBb
         XsvsaZxqu9h6V+QPaaM1M46syPzfrfFJQox5IYJpUTTtdngyf8DvicsidYQHiKmKmGtH
         mlvzCKeZZyGJmlvlpyWgA1gC1THz40vrYg/0VQoNgX+flNEPqKiKihdl5+nJ/5K6WPcX
         n1YSvDo9C+jZjDGt6VGTLtKt7OC2nXTl9NBd/QQZ8MgvuZBS3UFp7b1xzJIOJEILk43N
         r4Mg==
X-Forwarded-Encrypted: i=1; AJvYcCV3I/nvNMbXh9oimMPImCAfXA5UYASTR++duwGc8JKM5JpIn8PhNssqb4C2vtauyclRHbqvg4NdQaglir63@vger.kernel.org, AJvYcCWs1ZsO0OkqCNhKlZpcKpi7QOd1sWQ6zdIcmL+2w18y4kHboltw1KDe/2Lg4M2l1CYONX9wnPt6e9L9@vger.kernel.org
X-Gm-Message-State: AOJu0Yw430L51JfR2a4/oVflNPB6GarhiC+ZwIOPwpKmjRMjOGlETebU
	X6K8C2q61DvlIP+JOboComYqeNWO4QXdcpA1MNuVrGrtGDL1RtdUTlHJiYTUVk5rEXka4ufxnzi
	MGGWtrc8Wozgssr6upcGFw5WAVNg=
X-Gm-Gg: ASbGncv5ZWTDxpSt7vK/+A3AdxuGkSbQkpoo6ovbN6GOP5gRRTWZjw7lZl0BSYepQhL
	IuhLvy2evad9in6xfEHmwnewgRavCeKcuqYhTWLUawCL8PkBfDAs8eAvqh7APPsLtsCsI9R8b9O
	1P0xOHGiwL79jcCkPiPHmjWa0MWk4tdCbo4iA6rHDZMvFUSrwyaZc1FsJCRusS
X-Google-Smtp-Source: AGHT+IGGXcUBe1XDHQRFil/1qy3s5CRopuBdak1kZRC4nCjL7PDiHulW9uFy/lF//JlTGlDvGE+hiUMVTCHR/yLYBkU=
X-Received: by 2002:a05:6512:1292:b0:545:c5f:8551 with SMTP id
 2adb3069b0e04-5494c3517b6mr3702718e87.35.1740873839356; Sat, 01 Mar 2025
 16:03:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 1 Mar 2025 18:03:47 -0600
X-Gm-Features: AQ5f1JrZvPAU1_MTEZJoE2n1BQfatZy8eYFVVIdvXxHpQoZMqH-II2UAgfjn4ac
Message-ID: <CAH2r5msEB9nwoZOq70XWmHPV98_gy145DKoY_wiDRwP+N2wOXw@mail.gmail.com>
Subject: [GIT PULL] smb client fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
d082ecbc71e9e0bf49883ee4afd435a77a5101b6:

  Linux 6.14-rc4 (2025-02-23 12:32:57 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc4-smb3-client-fix

for you to fetch changes up to 66cb85c441cd9c44b193ff75b4d0358fccdc6b9c:

  cifs: Fix the smb1 readv callback to correctly call netfs
(2025-02-25 18:35:23 -0600)

----------------------------------------------------------------
Fix SMB1 client regression in netfs read code path

----------------------------------------------------------------
David Howells (1):
      cifs: Fix the smb1 readv callback to correctly call netfs

 fs/smb/client/cifssmb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--
Thanks,

Steve
