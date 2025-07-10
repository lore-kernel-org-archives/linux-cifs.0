Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B9F24728C
	for <linux-cifs@vger.kernel.org>; Thu, 10 Jul 2025 04:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752121343; cv=none; b=NoSLqGSPMsNXzN/2AgZmqHziqtCkbkkBmfXQ1Bo1NjFWsOKyX3cyJt1eoj+/rf4ET6fRZkRAeNhi6ZlE4zdX/rTm6qub2VXCSyyjeDR5pkNscYAhQUC8pkdTnSCb2a0k72a2BBFOprz8D+urPv3ox/b1KnSaFPQ6uoCgJjmhEzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752121343; c=relaxed/simple;
	bh=crlk6CRTGZKMpbG9maBTXRpXWjqZTZDk2QTbY4wE/80=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=jmj7h1oXpAX6oc2upVHdQIqm5JYlprZlBP5lJM0y4PJX4qN8pvzUkBHOpyX221v6uEKzIAx2taR4FNSCd+9yvMkDtaU8zn1LwgVCXPHtqRRFti/hwTBKELNz7g7kxCXhsR2Snfw6ME7sl8GosX5dCHlpU53wYK/E1vicmm2RYGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VrZbNaTE; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VrZbNaTE"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6fad4e6d949so3262616d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 09 Jul 2025 21:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752121340; x=1752726140; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7gnPIUyT3f1G2z+TzAB8N1WPDBtbEShVAyaMW0dB0nA=;
        b=VrZbNaTEy+qqbJyhXwx/fy7nN78laJq0sNBCQaeNk6QyW6pYT6ZC7IHvolwSjlu74E
         jofQIjNs8xx9mAvdmYh3f3ZLUZWQcBY1o1WN/lIpCqM1h3pBeZavODJavIkPc86AXdwv
         qGPhGdcm52utlgPwGMo11SiDFzD3kBN+seUuHM5gm5yEtQgKKdp7lqtrdQ82MXwy3LGz
         4ZFVQtalF8Y4mfVC5Phgx3SeTK4aBAt4qCkjgLfWui/SnHYvwA52m57DRguO0eyIwk3w
         d3kKI1EzReqk+XfyrnGjgvCXMu72cKqE/2b8kj9+XQl+Wdbr79MuIVdeIslZosYqJBSV
         JqNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752121340; x=1752726140;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7gnPIUyT3f1G2z+TzAB8N1WPDBtbEShVAyaMW0dB0nA=;
        b=V7zYu5E9xEa0JPSqZZxQNTghV83s/+YGCLRNQRwPN3XBy9kVmD6MPh4KvJCEXIJ/tK
         UBoJFhJ5zUHP2sTbbRtqwXXLZfsbotn0KsLAeFISbziPZNxeLJNhJwgV9Ap6pSOYS/Kk
         h0T09ICzEuJJ9kKyWNKu799YYDJMxuA6zrdY6lxDiNK/WSf1MGeIdnc/OElncsYI3a/3
         3NLCGq+glFGi3A9PNYUSU8s4dJ8EcoNuV5yMrPW6+9Gp+i4ABikSxqt5ajRszhDBfr0I
         GQwaKLfzmHF9SEHQboCiZCn3DY81+hit7XbB6y1HODYhxshA4CoZEhfaV3N3Xkilr6Op
         3RKg==
X-Gm-Message-State: AOJu0Yy8HyA7JejVK1BqV3QOncwuhdB92A7wA8aovj/fTwD/bDm/NbpG
	b7rXY7MGjupy3In2LE0QV0+pDKRWhfPbhtbVsuyE0HUXYWCgvMRAr+Pb/ANR2yjpaj4LUQC9Jd8
	/g+0uWFcFP050Q5N2A7NqjfQgFnDZHchg7fjbkZM=
X-Gm-Gg: ASbGncseHyCKG8SvGS3CVgTvsdYsM4t/iyvUmtihZIruz8M2VfronMxY/l5QB0JH6P9
	eGEkWq6/VGFTN/Mi9gwMGCSPV1wHs+xdUS4sgJE4gvU8QRfHevwiI0pOgcrvqa+AJ9ptsd4C6rV
	CoF84dsTCt0Cqk4wswBShH07oA4TJhiKfw6IZXG5mam39H6ZmmruoQ7Aspk+JH/eesq3afSBEIs
	ESh
X-Google-Smtp-Source: AGHT+IFkseOjnkKcTR57OiQdfEqXh8rELuejv3VpTeBXiW50cV6spcrlrGdTmobtcXAsH8eHzOu6Nc1XBbBT/BmS18s=
X-Received: by 2002:a05:6214:21ce:b0:702:c8dc:c4a8 with SMTP id
 6a1803df08f44-7049801cf0emr12229686d6.11.1752121339986; Wed, 09 Jul 2025
 21:22:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 9 Jul 2025 23:22:08 -0500
X-Gm-Features: Ac12FXwNDfL5mMjafd4KxudDm6D8aIY7bj-OLAcKGBstzeGelxEnqNtFeWSE4Wk
Message-ID: <CAH2r5muf4eFPiVjT53Zbqirs8DTsLsjnTpGJV1sA_DYj+98x5Q@mail.gmail.com>
Subject: regression tests for SMB3.1.1 POSIX Extensions - many tests added
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"

I have updated the buildbot (now over 250 xfstests successfully run
from current cifs.ko to Samba with "linux" mount option, there are 17+
test failures to debug).  Very good progress.

   http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/11
-- 
Thanks,

Steve
