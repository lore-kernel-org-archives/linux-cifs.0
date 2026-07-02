Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F8F3F787E
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 11:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782992148; cv=none; b=DSBbpXbKqqt6DwfOAmh20GkNpqnziVGFgaXhhn6VS0/ZQRkTTNqOvDvHH2qAIcZQ4MuY0OPPcjKYVFsJsXlnfMSPtX67X2flhwVI21Yo67jpR2hSN8xPeLR5jN6XfJ/XLmfZ7gkjjKAtH2AtxxeBLOBt6YmxQgxslADXDa+1+Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782992148; c=relaxed/simple;
	bh=O6FvDtWU0F7hPefdEbubr+oUVTA7AmZHsIiHbgO52pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dgia6OPDVZi0KnIsq1VMesAK+CGoULhx7iAac+KI1Geh9p+2w+zFpy3FWPsD1HzQp5f+r3JD4Ok+9+K/t17nFrliTG8cRgH8spj8DbwZn23pjXLjHWrtw0UCPC+sb5YjvpUkJdVrxdLeAOeCHOp1iA/hK2zr3RRjekRpHb/o3Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=izgoa/AF; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="izgoa/AF"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-380cda7f00cso897087a91.0
        for <linux-cifs@vger.kernel.org>; Thu, 02 Jul 2026 04:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782992141; x=1783596941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JnFg1iP58Ku8RilWowkB486iLdB6QCCKhKMsD9HZN3o=;
        b=izgoa/AFfz3N9gPOJRSiCMCmuw6Brlbr11qQ1fizMFmjlaKsbBGkxTQOspYoQJM9IG
         ZE6kh00ipQ/ZySdkNhzKW9mkFmfyE+3G+j3Tp72xwk76hkFGdjxImdCWdn2hBLWr/SqC
         iCQYQr0hEgPXSCP/2DWmgAICuSPeU5TkEL9Oogvg+e2aVnmU/nvRqa4A0VGsaRTb9DNF
         +tlB4X7R77cY5U1orMIyy4xEn9Rl2iTLOXSj0HZk2WNr7EwUSbid7jZ9kGd7Ja9Bmjt+
         uDXA9aXgFzWWmVKQg05xwlCT4oFvLichnLCOecOFwQ2nTi4+O1TTBshSd/F2yCA6h7Ng
         2n8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782992141; x=1783596941;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JnFg1iP58Ku8RilWowkB486iLdB6QCCKhKMsD9HZN3o=;
        b=TlRRb/mfn7j41Zhz0hmxNXLF6vM6ZyPICpsJEFRC3FOT3LbwyjslnCyt5u6UYwmPat
         wpqFyl7dbGcyosnqs98z7Zd2rfwsGohpMaHXt3W9e7MTOlRQ88KHPPQd8N1q4nknU+p1
         Jz1t3SGW8WvAbesodHRklcHy7hly2FvORjiMqNza9uE2gXeqmtGrQRv/LpA1vywtEOSR
         BqkD05t9B4s+mA11SPdB9KhzB8Eotdeluk3OGqcwF1/f/61CTsiz4g9PM5PJ8J44lSHF
         FQb1kIE7znq1oUTpO5dKwSAu62RFlqdY6EpefI5eT7HOxFbNGItGQ8U6ic97iuNYWWrQ
         J3xg==
X-Gm-Message-State: AOJu0YxtdSuIMUBrsA9rGDv7MF5RMi3+LVPM8VWs4oFpDQ7Y/qBr7VTU
	yoxnTxwt9IIO2OKInwWYPx7xpUQG8L0vsBz/gWg8zTOrt9tPZ9UKqsabenNc7w==
X-Gm-Gg: AfdE7cmj5VBaEyXgma8FYEomibq4CQEZ13dKJ4dXyf7G+nVTcFC/idIELIdHlq0+HgL
	yWttfV6XjQCxY3jsQVRPa8OozdFWlqy0Hc2XOjd/7MnTiXgmkkzfCPEKF/2xbH/TnPnZYVEZ5fM
	/DuYrYUM/RNcwYP73IMrHfwjFOTFpLKLA4JSO/4M4hq0bqCt5PY0OVtXMoCFxuMRLyGbWVims98
	BnQcsOMZLHzpWvScq3VUxNMJdIDe3/LTv4GlPl5DFsD1KKFe3yGsVrU//ot7x2lwAIbEZn9lwVJ
	E+xNnVqJ8eKwc5wzY3Bm5HavDBJt7Aw4lDOT+iWs5+AWAN08v7p2FAruU4cltihmKoB9yA0aXTW
	X8RiEkKQ9M5Yz/TjGgVpp3PRMLbafjEbyihkfqE6/R2k/0buLgXwEYGFD7Nd8XfY8ffM4P7+ByM
	xxDZSDD0Ut9ffijrA59RKOJoRCuqPp7SaPtgFyFaA5Gvq3UrKnUFNMFuoOlqaa2vrMh28+FuMJ8
	BM64epVc2gENbOtzhyYrKQ=
X-Received: by 2002:a17:90b:4b85:b0:36b:b4a1:2939 with SMTP id 98e67ed59e1d1-380ba8d533cmr5216507a91.15.1782992140834;
        Thu, 02 Jul 2026 04:35:40 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bb7fd75sm9444824eec.19.2026.07.02.04.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 04:35:40 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: bharathsm@microsoft.com,
	msetiya@microsoft.com,
	smfrench@gmail.com,
	sfrench@samba.org,
	stfrench@microsoft.com,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH RESEND 0/9] smb: client: remount reconfigure option fixes
Date: Thu,  2 Jul 2026 11:35:26 +0000
Message-ID: <20260702113535.4044308-1-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Resending the full remount reconfigure series with review fixes included.

This resend includes:
- review fixes for patches 1-4
- nolease remount follow-up fix (patch 7)

Cc: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Meetakshi Setiya <msetiya@microsoft.com>

Rajasi Mandal (9):
  smb: client: sync runtime state into ctx on reconfigure
  smb: client: block non-reconfigurable option changes on remount
  smb: client: sync retrans on remount
  smb: client: block cache=ro and cache=singleclient on remount
  smb: client: apply rasize on remount
  smb: client: move struct tcon_list to cifsglob.h
  smb: client: allow nolease option to be reconfigured on remount
  smb: client: review fixes for remount ctx/retrans sync (patches 1-4)
  smb: client: review fixes for nolease remount (patch 7)

 fs/smb/client/cached_dir.c |  70 +++++-
 fs/smb/client/cached_dir.h |   4 +-
 fs/smb/client/cifs_debug.c |   2 +-
 fs/smb/client/cifs_swn.h   |  14 +-
 fs/smb/client/cifsfs.c     |   6 +-
 fs/smb/client/cifsglob.h   |   7 +-
 fs/smb/client/connect.c    |   4 +-
 fs/smb/client/file.c       |   2 +-
 fs/smb/client/fs_context.c | 422 ++++++++++++++++++++++++++++++++++++-
 fs/smb/client/misc.c       |   5 -
 fs/smb/client/smb1ops.c    |   7 +-
 fs/smb/client/smb2ops.c    |   2 +-
 fs/smb/client/smb2pdu.c    |  13 +-
 fs/smb/client/trace.h      |   2 +
 14 files changed, 530 insertions(+), 30 deletions(-)

-- 
2.43.0

