Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D2F233155;
	Fri, 22 Aug 2025 03:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755832336; cv=none; b=Os/65smNFE66JYBw4MMtxxnECFqEI8jnTVVcXLAAV7hui0FVV1Iu7QkvJJaZXFhAKG3K7kUakU1n09JNfv/gsT6E7nM7lLh+PsFbbD4nm/TmT3Fx+alcVZssrgp6dt3YjZDNQ4X3Zn4QEOvShped5vXfEH2Fl6/VL0made1OFEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755832336; c=relaxed/simple;
	bh=xgIaFQ68tlgBevrsv47YroVIQGCGYCdpFKVo25GB6FA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qDU/5LqrVR0WCO5PZFOr7/Mq3xv2/ANPQ8aeS2xapfgI76bjMjhzdTKNLTo+g5I18wSpkJ2MsSEezrTRY8nBvugmhT2HEp6X+MHRIDbBNIREjVQ22vuz33dLdL/DUmSBNGUh7spQFDl2clQkEkLPwciMhnFNZ9bw/IhoUav16Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=meEz8aOE; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="meEz8aOE"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-70d9a65c353so3013956d6.2;
        Thu, 21 Aug 2025 20:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755832334; x=1756437134; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oUCwBP5hS+RhTy0i1m8L/lHk9qguwYZ1lnkT/6sAsuM=;
        b=meEz8aOEeAYnzzjOv/f886UNGGclxYOwK6PsKHv7cnUCr6lqDt132xiCH0WZON8PIN
         fH+UGGkto2NqmXaDoeVvh5DDOE/XMIfRBpS+pNVDNkei3rhR9YvH/ClkZwjOAHlVtNUL
         iEy8owzLFZXisJ294VglGFVO6iyRYGYESCV7YUbFQublpKIzf1sDFF8WCf9Sxj3T+pFw
         UXq/4Af5MNWsIddm2mE56JFttiITP1uzNEgbMlGAMwj033G5+hMZExQ6/9obVT5YFqzS
         PcT0qf+7TzKd42B1F8wNUf5Noo0ajUVOn0CQa8ngZrZLngDDf9ETTdhaoT1jSU3GEFWl
         lXBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755832334; x=1756437134;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oUCwBP5hS+RhTy0i1m8L/lHk9qguwYZ1lnkT/6sAsuM=;
        b=YO3wFf66FyBoqdxYbjzVHDFUnjMPd3F198Fw/6ouYoOkBeK1el4CEtvMYADA7Z+cuO
         aVFMcI6fl8phxhum4rmNepdmfnciR6Apq1QkPn0nUaqJ3R9JjZnyBmFb58g80L1KP9yI
         UxNFDiP25/8kxP8dZYJ/yYr2oKSdxJPLmk989YVb3va3WWWBhhvjdjNN2TuS0H9WP8Dp
         ubIJFpUEPRuPkcN1HZAP7yHjcTTHSHfdXIe5Dxkqe703Z3s5PPYTpKc+euKt/ZHIN7iG
         Fpp7Jof7konHS0ZMDSu68zOyTXbxM/1+TNZKDdjwEUNRZKcIQZaoQlVrpaaBNkgKUWA2
         hBhg==
X-Forwarded-Encrypted: i=1; AJvYcCVkEdAJrucxjSvRcFhM+JLRsb3KB1CfrVJcX9VpKXhxKpVY7qxzRw3xr7Bex2RFvMqSsmfNDd26trRwBZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJLt40MQLJWBcDE7H0TXbWIjQWQ3F9oqoZ/B0A5iaEJq+PlSCD
	F+EdfkMgQqcTn/Ap0noYXKesN5bc+jv25Zp0HnAI931MsSQ7wIdjLfjtpD3Zdev8yITksLcG8E7
	QQeZh5QwmG8lRBqtEo9Rea4fvxu+5md7nV2qC
X-Gm-Gg: ASbGncu46rMuck7H6Bk0zsAPm5mx7xcH3oYHOeoEvwaUK0+FuWlHpf9vc6MpixfdU13
	mNf3qHsJqA26pfU13skP+N8J8XS4rRyaxDx12HRQr/RVCCZQY176fAuGb/noOPd5VnZF2/g9Bw/
	Y7woGTcqwLZSLdv0YBSxr6zRMX/jaXewzp2q7gjk5KJj3dCty2AFmApsNXswO+JnlQHDw+EwKBa
	/+Etkfi2Zf5GpGC1YcBwSh6o/wwpYrFaWFfJbrED2PgZa6MH9cdOncmKYcIB8Ut2U3JT7y4mI/m
	YxWRwwr6ONo5XkHrF5xCHYmU41NgeQo=
X-Google-Smtp-Source: AGHT+IERDV0huF80juR1IF8eB3NI3HvYVAS2icY5Pws/DXKpP/RZ/KkMEKJx7W7uca60lnz7UotrWohoAwOwnqJVRDU=
X-Received: by 2002:ad4:5766:0:b0:70d:8eb5:2c8b with SMTP id
 6a1803df08f44-70d9737c149mr22193376d6.48.1755832333995; Thu, 21 Aug 2025
 20:12:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 21 Aug 2025 22:12:02 -0500
X-Gm-Features: Ac12FXxDv_Qc8LFoAp8SWeFM3B9Hfri5wU-DYOX2zhS50Ew_iubdCQdB_7kvaEQ
Message-ID: <CAH2r5mtBRtF=ZtzjRWfdMwtvGzJ-oJ5_H2wfoBpkoZJJpfaebQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9:

  Linux 6.17-rc2 (2025-08-17 15:22:10 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.17-rc2-smb3-client-fix

for you to fetch changes up to 453a6d2a68e54a483d67233c6e1e24c4095ee4be:

  cifs: Fix oops due to uninitialised variable (2025-08-19 11:16:14 -0500)

----------------------------------------------------------------
Fix for netfs smb3 oops

----------------------------------------------------------------
David Howells (1):
      cifs: Fix oops due to uninitialised variable

 fs/smb/client/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


-- 
Thanks,

Steve
