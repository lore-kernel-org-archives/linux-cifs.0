Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3227823C512;
	Tue,  3 Jun 2025 15:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748965030; cv=none; b=P6kOHu//iAtYecrvQOzBgUJAHuY8lU2chSL0QgUBRu0pvDZEsPTYmYBF5pFdd8lvG7wbhyAL3K9DWusJsJfVT0fvOe65GZdZD278zyAnw/12ERZ+Um5uBXkIGxNqK7qCQgFAGbRgAF4TKbhCZQyCy4/UY1WIyQLNwK7UBauWbco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748965030; c=relaxed/simple;
	bh=A+N9Sjw4CEgKOE3hQqQYS6tprbBqwfSbP4hSwUUtpx0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=QApIMgMFGWaM9BpgoVDMoFOlY0VVmn0l4QUMXouuqRaw0eDdgeV/6unDpYGnQ679f+UpkScVNh2iK+khSLSRp0eGktb3uvY+vghRz97IQqsVBD9gBi3EoSyNiukPssXT90TujNmgpQWJGILm6h/N7RmkQDvCsgLrWPIYzef97i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kdQ08Pbc; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kdQ08Pbc"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5534edc6493so2517247e87.1;
        Tue, 03 Jun 2025 08:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748965027; x=1749569827; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XbUKE5e8Q4R9kfrxIhCex4mb7JnX4VitZz0U7TY3fus=;
        b=kdQ08PbcN37DHG38e1xTKhOJVI9ts5WcwMaqZcohOWOBbq1nTmCeehH2zvSgUitokp
         BU9FMZkAjE984poyIHy1tC0S+6CuiZb/gZreAZcpD1jbFmMtCHZkgzWzdprB45nhGqKs
         a+liLeNHDr/AAjNEVRci0M8FDl0SPBfBlmaI9QZRuZc7eNbRmIbWLnsOnocwoZFSskZD
         eFiTp1pAAA76CAYTgT4O4CewKam8cdCVOAwHJcRctbEf/GGJLj3Cf3IZQPuRxyr6yGJk
         u1hadguIozo0i8FwF4P8ItMlqv1A3bQ3kFcBEHpFwTuAvTV5BqNvSsfxUs5Zun7IxIwc
         GlBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748965027; x=1749569827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XbUKE5e8Q4R9kfrxIhCex4mb7JnX4VitZz0U7TY3fus=;
        b=pMBe63JM9FNKAZrfooJCpxVDXUz2bBVZXYLJaOJjAjqQNwYDk0bOkw/NvhnTXVthYb
         zub2bVF/5pdY7ezhpjuSkJKel5p57KpQgEVxKI3YdX3iRdvGGgFHRdq27CdpL2lY8HnG
         PfgEmRYuIaOAaQLMhOirYVWbCPMuicxL/xwsbfhN/zc5OnnBnHhltI9zvhgExXHawudu
         sQWTJUtY6uPgjRNjeSaArIUTRmZXXh1/Q4PKCc+DSQCrPOuqxOMQzpghIeqRybxCjsWd
         3mJvyliAhMTngZWLRdDG5APe7Vcf3BTPBug3Afn3TT8PO0O1Qd+98s7bNxJYTTz2ixfi
         av/A==
X-Forwarded-Encrypted: i=1; AJvYcCUIlsnTPpdX+yt4ehFOnfdQIAoshvfjEWGyfd635LdnBXqA/1HshwD+JRc2YodsaDdCjGt5Ssr4qlJoRD0=@vger.kernel.org
X-Gm-Message-State: AOJu0YydAPP5P+/F+3CgkRpGEohQKftJHOF650PEmHg+NpMhWT4TdFLF
	JDApGnUgZu32h/IdKh2wapaR1aCUFVhNWr6fVuGDq7iyRZRJxtbgvBEfletVop/nahgL0WPRXvz
	QzoKMhubZs2Bvq4ip6i9a3kVQSon7N4ew21Os
X-Gm-Gg: ASbGncsIfEmDWdfutTzhfSBK02pQZuOhSlHkQ3aswJKBq3WPTTHnYEkcakB1mT3Y6Pi
	7AL5U2x+zAkHd5jvT4taWRaeP9JD9NSihTP24XkhPr8ix7wqhWA4Qx1WuCIJW3jeIYt8jT1oAra
	7y9D1Eqswv9POUKKnsbNZTNxhQzd0tVE8=
X-Google-Smtp-Source: AGHT+IG8GQ3fkMyAGygfawqTQLU0dAk643bBV6QMXfq0kLiio12HD26H4s8imQXHiKUaue/4i1bpkRaVAwfFo5fAdMA=
X-Received: by 2002:a05:651c:1113:b0:32a:6ccf:a455 with SMTP id
 38308e7fff4ca-32a906e79camr42334891fa.16.1748965026873; Tue, 03 Jun 2025
 08:37:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 3 Jun 2025 10:36:55 -0500
X-Gm-Features: AX0GCFtsMqWkZHR6KEk5EtELGZqXB3BWxldJN0ZVyOUtD0NmyqGOWJO2D2G1E9E
Message-ID: <CAH2r5mt-jcxLBK96EiF_w_QtOM1-2DHH4QAYKhikWSOkD1t-mA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
0ff41df1cb268fc69e703a08a57ee14ae967d0ca:

  Linux 6.15 (2025-05-25 16:09:23 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc-part1-smb-client-f=
ixes

for you to fetch changes up to 8a5ebd2be99a1f4630d0382f7fdf581561d317cd:

  cifs: update the lock ordering comments with new mutex (2025-06-02
17:13:06 -0500)

----------------------------------------------------------------
13 smb3/cifs client fixes
- Three multichannel fixes (mostly reconnect related), and
clarification of locking documentation
- automount null pointer check fix
- Three fixes to add support for ParentLeaseKey
- Minor cleanup
- Four smb1/cifs fixes

----------------------------------------------------------------
Dr. David Alan Gilbert (1):
      smb: client: Remove an unused function and variable

Henrique Carvalho (3):
      smb: client: add ParentLeaseKey support
      smb: client: use ParentLeaseKey in open_cached_dir
      smb: client: use ParentLeaseKey in cifs_do_create

Pali Roh=C3=A1r (4):
      cifs: Fix encoding of SMB1 Session Setup NTLMSSP Request in
non-UNICODE mode
      cifs: Correctly set SMB1 SessionKey field in Session Setup Request
      cifs: Fix validation of SMB1 query reparse point response
      cifs: Fix cifs_query_path_info() for Windows NT servers

Ruben Devos (1):
      smb: client: add NULL check in automount_fullpath

Shyam Prasad N (4):
      cifs: reset connections for all channels when reconnect requested
      cifs: update dstaddr whenever channel iface is updated
      cifs: dns resolution is needed only for primary channel
      cifs: update the lock ordering comments with new mutex

 fs/smb/client/cached_dir.c | 24 ++++++++++++++-
 fs/smb/client/cifsfs.c     |  1 -
 fs/smb/client/cifsglob.h   | 18 +++++++----
 fs/smb/client/cifspdu.h    |  6 ++--
 fs/smb/client/cifssmb.c    | 21 +++++++++++--
 fs/smb/client/connect.c    | 10 ++++++-
 fs/smb/client/dir.c        | 23 ++++++++++++++
 fs/smb/client/misc.c       |  8 +++++
 fs/smb/client/namespace.c  |  3 ++
 fs/smb/client/sess.c       | 25 +++++++++-------
 fs/smb/client/smb2ops.c    |  7 +++--
 fs/smb/client/smb2pdu.c    | 78
+++++++-----------------------------------------
 fs/smb/client/smb2proto.h  |  3 --
 13 files changed, 130 insertions(+), 97 deletions(-)


--=20
Thanks,

Steve
