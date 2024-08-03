Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F67014A84;
	Sat,  3 Aug 2024 23:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722726874; cv=none; b=txy7PesvK1h+Ni7CvSiZLgFN4QM68ZILxSq1Ypc6CqIhIlWBGy5nj8zJYTX/777r90N93+d2GsxO+bhTPN8kIth7dJsA3v+0dVIVwoiqCC467DV82nu8PobwPSnU6bEQfridosR03R6HP1gWQPqc+Orsf7MVk7jdNKf06Hl1LTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722726874; c=relaxed/simple;
	bh=B55JkbSlBxpJDiKdSAijLYuz0R5ZzXko95X+7Ef/X8Y=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=EPll+xvWsUce5TS/L/Dy1hlX6RHwcF+0RhfVT8gCV9+9z3KrLW2avCQfBIfhtsYgHkRnqbRyuz1BBr94ITyW1ve0L7KVGlwH8kXbc6LFFF51ncXCbG/JmEYiQYFRaBTKB5chFCOzcQ3w+gJ7YOEZeAZayNSHKjzy1A0CQA7Qq1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cYZ/M3Jj; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cYZ/M3Jj"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52efa16aad9so13137753e87.0;
        Sat, 03 Aug 2024 16:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722726871; x=1723331671; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=g0kSt5t1uFzH8Xbkla9+TJMSfVA9igCR7XqP1zqBBoE=;
        b=cYZ/M3JjmKtKJapQNSFTnpF0sdjsQAR6cCYuUSdjCGjlAATduSua8PQnSeSCcyA/VS
         AxbdCc43VCxCcSDGXS95gvV/vRE091e//E4Fs4TJlafcEAmkTzRRP7e4kgSkzN+sDeOy
         QvDObVZqQ0j+fWbG1MMoqUgZcInz8Z30v+iFyk1Em2EUvqnycF0A7vaQktPH2ZeMuhDq
         9U7RRwDYKuNBHm/DcM6ewH0AGfgZ3FQCNsMPFKHoo6IpC4rS763DlaeTpHQ7lr4jNTIq
         Ge5x0N8lFxqrq/W+wSX2azBdBhtjm1/mwAw8Taa+md8+Zcl8SoxmHNELG2rRzqGJ0kvx
         bt7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722726871; x=1723331671;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g0kSt5t1uFzH8Xbkla9+TJMSfVA9igCR7XqP1zqBBoE=;
        b=OLajsKS0QhN9YjEeq60lPbuWTJOrkW7P5yU1SLrAooTRoDY5Hs1KfsMBzrm/l+TjY2
         /wEsBRysYj6mv+tX64MJu4HTPSDpL+Nw6ljUxF4FzTqt8IIcRkgbLMCuxfbecVuQYJyL
         bOhdZJ4RFCI+AhDplQrfHp1UkXQlmB0SNYtzJscb8Loe+6fN0sPAaHEsTPgh9E6FO2vI
         b1Q3lfFVPISq3KJv4U76Ua2ksy0CbO+W+hnCBw9BusBRCRuuN/fqV8GNLb410VHaWNIg
         hHE+zhLAv3QNqUI10v7EgSbOhCLOafkWlupjLV1ry4DxAr86MR+uvNkyEaQKtBfgfEe+
         9NgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkNiaSPgO5r/+Pji0WTqa8sMv/zucuBTQHyCSMJiPxjdplQOAn5D1nUj9tJi3xSnbCTn3tqbobj0vjfPn3vLyKNI8LLKzvjrm6MA==
X-Gm-Message-State: AOJu0YzqsJg5V5BTZd54R3mAXClWqk+lOC1TZdg0Mw5sX+dAJ2GYV4FB
	x7tKbtnjYYgymO5d0Pik/pXCqGXJamXvWAqnjDf/cQhfuEY+zvhnW+2ktFH1Vlpk7/H0mjxa4Gk
	IA6/OKYqHASuM/qLBrDAEORJfI0aPiw==
X-Google-Smtp-Source: AGHT+IEQF5asgqFLsoYXPyRMSH92SG+1wrHXlPA2hXWXM1yLMBvmjwY3KwNbqKWs+ZDCgp7CSFdozpZFCvwDk9bFzCY=
X-Received: by 2002:ac2:4c48:0:b0:52e:be49:9d32 with SMTP id
 2adb3069b0e04-530bb39613fmr4885882e87.47.1722726870745; Sat, 03 Aug 2024
 16:14:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 3 Aug 2024 18:14:19 -0500
Message-ID: <CAH2r5msSfDbF+wrZ6fWaaL7puR+N4MNQ3Vt1AH7K-Lp82nUGug@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
8400291e289ee6b2bf9779ff1c83a291501f017b:

  Linux 6.11-rc1 (2024-07-28 14:19:55 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.11-rc1-smb-client-fixes

for you to fetch changes up to a91bfa67601c07ff9d31731fd2d624b47b0039f2:

  cifs: update internal version number (2024-08-02 10:56:14 -0500)

----------------------------------------------------------------
smb3 client fixes
- two reparse point fixes
- minor cleanup
- additional trace point (to help debug a recent problem)
----------------------------------------------------------------
David Howells (1):
      cifs: Remove cifs_aio_ctx

Paulo Alcantara (2):
      smb: client: handle lack of FSCTL_GET_REPARSE_POINT support
      smb: client: fix FSCTL_GET_REPARSE_POINT against NetApp

Steve French (2):
      smb3: add dynamic tracepoints for shutdown ioctl
      cifs: update internal version number

 fs/smb/client/cifsfs.h    |  4 ++--
 fs/smb/client/cifsglob.h  | 24 -----------------------
 fs/smb/client/cifsproto.h |  2 --
 fs/smb/client/inode.c     | 17 ++++++++++++++--
 fs/smb/client/ioctl.c     | 32 +++++++++++++++++++++++-------
 fs/smb/client/misc.c      | 54
---------------------------------------------------
 fs/smb/client/reparse.c   |  4 ++++
 fs/smb/client/reparse.h   | 19 ++++++++++++++++--
 fs/smb/client/smb2inode.c |  8 ++++++--
 fs/smb/client/trace.h     | 51 +++++++++++++++++++++++++++++++++++++++++++++++-
 10 files changed, 119 insertions(+), 96 deletions(-)

--
Thanks,

Steve
