Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D402BE053
	for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 19:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776972777; cv=pass; b=ra1xl2DcbA++oed2bJJq6X1Uj/u7JJIROffc1SSdc5MjppQP6IF3+htxAxtAIKwBAE2frMCZ0ZvBbHt1eIbPlMCx9lrh/lDzQG0JE8DTvhf2NE8cm404Lg9aCYLXD7n1GTEF7xy53DHca464jwIhYtrM+xaNO7qBfAYLyZ+dUY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776972777; c=relaxed/simple;
	bh=aEFAo3XX2LQdfz6rxnqvFA4LNZw/qvDkbY4GYqOBFm8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=m9vF0AAd5fyr5aUCCNMqjHHFJ+6ZJTz8cAfHUbOS+cY8jmWwFc5sVxyTTNW3/qEmwPLJLgGvr23hFgbx92w7ohG8TvZU5Jm03iTu+5rYRXRHKBtyFNuRn6LURmbzRpQlVBrJQvdTirPWKKU71Ro4uCuOvXy42BPQIzQRz9Rc878=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hxj2i97V; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hxj2i97V"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-50d876329bbso81974281cf.2
        for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 12:32:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776972775; cv=none;
        d=google.com; s=arc-20240605;
        b=U1uydyYdOsazbQ375/a6EvV5ZTXvaltqiYE1AF1kBRx/wJBh5jA+xzoJOrsh95UoY4
         6+vfi27boDgv+VkwW34ljd4Wlss4r7JL+HgkwshwIsEpMjyNseOX6MB4w0cGC+SvivTK
         qs7Oi/O/FC1OgXp92CqSK+ZcVzOjGlaO5+C9yk4EpbY2sZfCufkYEajd1aQIhux0R5pk
         5yQwc+vw7txcLxW2yOBhCts54OYQPHBkeu2BJhkQf/Y5Xy1tDqJ8cugKS8DnBIcU+qX9
         TdElTUthHdZGYNOzOjFK4E8rCQQQzlGTC9WBi5tg0Z4cDQoltVWKzB4uMhc7MfWOqpGo
         GYjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=uK/sAOqHIiUW7kshUNqYVt5Q7vYo+A3VBdEQZoARV84=;
        fh=/Ht5gIEV0iWL3HQlSbQNJCHboO1we9RUsOhPdL2nMRI=;
        b=eltnjeMcG9A9SsmT1Zis+HQq9lEbVUpPHH7PNnjyWYkmxT/wSE7U9qaPNvj62eJDpL
         pqKkqIKjfGgbs+vWyxBmUFrVJBgoDW+Yh0luDPNvXPLH0HXpwTUncrlStiO/ym02oPy0
         9cP5UJxI/gGYwTHObwpBFycXWH1lfRY53xbo5S4xWxS9Y7JrP9RIYuwLEwn+DUz4ab/v
         tXs8iA/Z2+P1sGcZpEDP41XmZf8R+T66EOm6toJ7sudUoclEqXTU9PImfHikrDC/qBvA
         0soDEprcVPmm8YJUvyReaMkTTBW/jp3M3T/0e8Ku/jV8SwCyfBOFSl+vzxhMQH80Kmlc
         PYTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776972775; x=1777577575; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uK/sAOqHIiUW7kshUNqYVt5Q7vYo+A3VBdEQZoARV84=;
        b=hxj2i97V2Os5kVu4WS4JbqWt1j6DCeITXniLsOLyFPthJQXi558Ae8k8CJzTM8L9+6
         2qRg8oDuFc2S6qXqk/W7icwz3IiPuuk7IjYlr4oyvYlyWVcyQ1ri91L5TjBLSEgH0Dc9
         SWtsi6RNEEXutg1WgvdiAb/trc23+RpXtvpnXJmYyHmBu6lye5+ptSw6JKDnlazh9OCh
         woL+lSAASP00mDO0tNoGN6MK858qG5Snhk47UtCzzoeRm4cFfE+e6+B0xxqUhRRt1RXO
         x76nbF+45vahkq/2H9siHM7WOAkoFIZsLuVkquT5dEwV4kclOC7PJ/oupH57jTBg1Sd4
         VWjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776972775; x=1777577575;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uK/sAOqHIiUW7kshUNqYVt5Q7vYo+A3VBdEQZoARV84=;
        b=Kq0wjhdC396CB6Yen6kVdPEttIXeWelWaOFEBv2uuPCVECDvj+VGHJJUGzRsVacl4J
         UpDOJQVqyGwaz5fFUESyhqYen5OJbnpFCxHqUpsWh1JhsYqmjiQgpHJfil7CTO7Kfw+Z
         bgd+Rd8JGgmgLxXgTq7nXs9hSmKriW5Rm8PXUTD6J4qoR7ErMwACIJZNa0AacZ/+RscX
         PG0DrwIrXOzNsy5v7k8ULGckfjssJlmDnbjcdobfsVRfNIvmL4HFrv7s3+CQyqPNsKes
         L3McDGOgO11dTsFfwcFXUvnrWrnhIAfbHHB547CtUV8KX6V+qD8L1ukiFDKdzRfH6JBc
         4hrQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ziwBR7P75evyaVzF5ccbu3Gs+IwAe6xOzcXGGce/Rd5+tWb8TuvxmMHIaHyU1tGZJQiVhtK66mqFD@vger.kernel.org
X-Gm-Message-State: AOJu0Yz13alJenPiQkdXq4BBKNE6eoPHIi6YFrFyLBFLknac0YH9RZqn
	S8yZY9sO4AUjtDKWp4fSJGRFUKyPiEgnQo0fAN0kMiwz/X6PQTNXQXNm3qVmP6sQ3XQ7jTQdSCJ
	QpkSxlMResc4CibtfOLetxZB7zenIiwSX+pjq
X-Gm-Gg: AeBDieuOzfrPjRagjd+qNU3liZFBEiDYlXjp6EG/ykA0am6xRZzpiUPyxsFX7Lcfz8h
	Ohb5WgrPoT4+UhNe0i6FgymKED2YZs3hTbJCJ3a9Mimq/zXWvQNg78NVmfPSblAkIu0oPyFao4c
	ofr5syQ/rlmsRaCg8+rbtW+t8O6NpU95bI+DsmTv+zpdVyTpX0F8eoVL0cEjV9KPM7CoBPkXnj9
	RE9Wyur9VizzAhCjmK8dGWH2WQxL8VT39O5Jft2rt7sMzf99RlXrUbl4CVU19J2ZtX1qxCamFg5
	NFgKiY3rLoT5FwN92M42MZrkY/zUVpivnyecWhCdPLaJxMIGYlFC8fDhLQDxjeiPDsaUwHyUqfH
	FDIgAVloXOVzgtiDHAyzidkK1jvvQU7HgB13CVXb+tHsDrfRbFuFDjYYeWbwwIfZ4em8DnRdehy
	d/ViZxqPHkmseQy8ViVQX42QfhLgHXZxj8
X-Received: by 2002:a05:622a:a951:b0:50e:5a1d:8422 with SMTP id
 d75a77b69052e-50e5a1d85bbmr223471911cf.28.1776972775396; Thu, 23 Apr 2026
 12:32:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 23 Apr 2026 14:32:42 -0500
X-Gm-Features: AQROBzDpPT4n-HYT2gsmxXX4EEsZXaqmqd-LKlp4R8WgTMRQDfcxxfou2-Wrtro
Message-ID: <CAH2r5msLsRyRyu0q68y8hWMMO9Yq_-yA73Q0=owSY2hbx77BJg@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
0b2f2b1fc0c61e602a6babf580b91f895b0ea80a:

  Merge tag 'v7.1-rc1-part2-smb3-client-fixes' of
git://git.samba.org/sfrench/cifs-2.6 (2026-04-16 19:14:55 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc1-part3-smb3-client-fixes

for you to fetch changes up to a83307f34e0bd9b0e595b1074dc8fbcc1b7f3172:

  smb: client: Drop 'allocate_crypto' arg from smb*_calc_signature()
(2026-04-22 09:56:16 -0500)

----------------------------------------------------------------
Eighteen smb3 client fixes
- Four bug fixes: OOB read in ioctl query info, 3 ACL fixes
- SMB1 Unix extensions mount fix
- Four crypto improvements: move to AES-CMAC library, simpler and faster
- Remove drop_dir_cache to avoid potential crash, and move to /procfs
- Seven SMB3.1.1 compression fixes
----------------------------------------------------------------
Enzo Matsumiya (8):
      smb: client: compress: fix bad encoding on last LZ77 flag
      smb: client: fix (remove) drop_dir_cache module parameter
      smb: client: compress: fix buffer overrun in lz77_compress()
      smb: client: compress: fix counting in LZ77 match finding
      smb: client: compress: increase LZ77_MATCH_MAX_DIST
      smb: client: compress: LZ77 optimizations
      smb: client: compress: add code docs to lz77.c
      smb: common: add SMB3_COMPRESS_MAX_ALGS

Eric Biggers (4):
      smb: client: Use AES-CMAC library for SMB3 signature calculation
      smb: client: Remove obsolete cmac(aes) allocation
      smb: client: Make generate_key() return void
      smb: client: Drop 'allocate_crypto' arg from smb*_calc_signature()

Michael Bommarito (4):
      smb: client: fix OOB read in smb2_ioctl_query_info QUERY_INFO path
      smb: client: validate the whole DACL before rewriting it in cifsacl
      smb: client: require a full NFS mode SID before reading mode bits
      smb: client: scope end_of_dacl to CIFS_DEBUG2 use in parse_dacl

Paulo Alcantara (1):
      smb: client: fix dir separator in SMB1 UNIX mounts

Steve French (1):
      cifs: update internal module version number

 fs/smb/client/Kconfig         |   2 +-
 fs/smb/client/cached_dir.c    |   5 +-
 fs/smb/client/cached_dir.h    |   2 +-
 fs/smb/client/cifs_debug.c    |  56 ++++++++-
 fs/smb/client/cifs_unicode.c  |   1 +
 fs/smb/client/cifsacl.c       | 115 +++++++++++++-----
 fs/smb/client/cifsencrypt.c   |  62 +++-------
 fs/smb/client/cifsfs.c        |  38 ------
 fs/smb/client/cifsfs.h        |   4 +-
 fs/smb/client/cifsglob.h      |   7 +-
 fs/smb/client/cifsproto.h     |   3 -
 fs/smb/client/compress.c      |   6 +-
 fs/smb/client/compress/lz77.c | 274 ++++++++++++++++++++++++++++--------------
 fs/smb/client/compress/lz77.h |  32 ++++-
 fs/smb/client/connect.c       |  10 +-
 fs/smb/client/file.c          |   2 +-
 fs/smb/client/misc.c          |  57 ---------
 fs/smb/client/sess.c          |  11 --
 fs/smb/client/smb1ops.c       |  19 ++-
 fs/smb/client/smb2ops.c       |   6 +
 fs/smb/client/smb2pdu.c       |   2 +-
 fs/smb/client/smb2proto.h     |   1 -
 fs/smb/client/smb2transport.c | 113 +++++------------
 fs/smb/common/smb2pdu.h       |   2 +
 24 files changed, 438 insertions(+), 392 deletions(-)

-- 
Thanks,

Steve
