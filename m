Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC41C17A30A
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 17:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776359764; cv=pass; b=jedf049nIse2lRl+UNaWSuFkeN1aFrQEOJsMcootqPq1vZCVYbLtTB/H8haXY59Cc4Qtx+VCMKK+SLrpYuspoHBZD6ZIiIw5lONLKJ1lVvUn6R4nd7zfJ5ZIcWJwUEOf0Oni9AxfQofYWA5t8HUdz5fVoiCoJR5jtsyqDR6Yrys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776359764; c=relaxed/simple;
	bh=FzF4ZhMLdVZnFet8xN7Ujdzt5ELQlFxo7r5apwDCaLs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=boQkRi+T/Pvb8Cc9cM0ExIwxQPHqyAVqByu7QxKjv6LwOmn54zPjCamx/q0l0X+za6WFSvZ1IkYyHfq6f2n6FRt+Y1KsLFMSyIUVwfSxO/C24Ymgg+7fPt1c/JGwCuEInEQZ4jYd0egMPr5D52L9hP/pu+hU1MDajt7FqEdznOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qCGJgYyi; arc=pass smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qCGJgYyi"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-605def5b80cso2671428137.2
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 10:16:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776359761; cv=none;
        d=google.com; s=arc-20240605;
        b=aRDXrirsGSKKF5d+IagIUDCAmUDHeHlYNv1xXWNazQzh65iYtre8+HxSEcoUEbGNbI
         1gEpfnQJEiE08jFS+kjBDWUqMRCO4RHHGKm5j0IFuJs7c1HhG4BU952CEWT8Jmj38H9o
         EySjgWi+1RaecXudufi9FLVLgRyyV/h4K5XT9iUWXy7z4aXxw1UbvvtzLrIkSDWfUvRn
         +UvICrDQD1KkBZvZg9tu90gUc8lF+F/kOXXmZAMpGOi/FQVkfmgYXwMqGiXRb6HYMSOe
         aAg55Gm7zS9BmIs/u/s7pkqELnMWFYyfSWlhMf+rx2oWMcX8vvwOWiQ9iF40jxb1aE+y
         U+og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=tVejSxVKhi3u8DUGgWWeRmYhJQumRCLQdE17It3ejNU=;
        fh=tcnSsbh3FTBNjzxmLesZKhBvWNi4D6kCKRNA2xyM3oc=;
        b=EN9hHDSo3NFqYii/Q2grra6+FyawXkehSJjmc+iukjINfqxOaGBwK5S1CTL/pxzruj
         7sACX37ZVeqDQ0y3ZcZlqb70jBBUUPcl0H9cjmwqgR6rGTTt0KFCSm1LuFBV+QHUAFrO
         Uqu+777eM62ArQX2MkvHluAmnQsUAOKI/wYYmpOgIPdZt0aKjT98b750CiB96Izu+XGx
         uet3mBGUAYUWSbNKBUFDuWV9BAk6tsV6pKegjenqr++D4PiBeyo8tHY+/smBBm3FygO8
         wbgY+g6rtXH6gxT9pPcYooCMn+WSrX88T2rlpg0NJlHMIVmOCmKOc7rbe6fW/KibBkts
         WrCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776359761; x=1776964561; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tVejSxVKhi3u8DUGgWWeRmYhJQumRCLQdE17It3ejNU=;
        b=qCGJgYyiVC80DjIR5JjwTmUpd0Pxbd/5/MS5PdzSQ+PpYdK2id7zNni8dz7l+DEK+A
         0Rs5hhWiFmdAK2JQQPQDjZsXBB2r+6kC5su0Q5lwUfsNs2lP/F8Gpl9vmV+47kzbNjBR
         GEazJfPHinqLsYAXN/6rnCEssvcHCV6qKY4tRD7IYe6f5wb6On/BFxTjtUdlHyqkoOsT
         pJsNWJabBTOwjJFW3NGHGCMCFhdZI5dbObguDvI/lbRcuz9guBwTL2zM7t6vYpvhg0Ns
         /jiV691CbN/BHNnjLhixMC57SF6pzdewcXgUX1blRaCD0rJG5tsLLvzefua4zIGYNhnA
         tXhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776359761; x=1776964561;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tVejSxVKhi3u8DUGgWWeRmYhJQumRCLQdE17It3ejNU=;
        b=ey1uOq/0zE6lzhU5fAAQ/+tpOylNj/qhGJa2NWcviD7TGHoSG0pWZ9TohZ2NqSdjjE
         M5H60wAMyUiHnwXrQHL6ICoeFQShfUhFLkEsAOordWy0b2KrAuqjwLayN9+jMqoAxppz
         SxJ37Dl0EMIERqbt/Nk+g6ykf0Unm0WY6o5igYJGeTNYYoHn7a0ajA+DBgtGtS/8Inoe
         2nlJ+CxpW9hsA7b550qu5dSw62B2lwE3eKMpK3u4xlrZJvINIB7DOOb5QmM8MY0NAfAF
         ztNDcbnycjfS9fY5tNFrXTWiqPSUcuj+YLsVgGkkk0nbhI3w8dQO5RsdS+sitL598pz9
         JfrQ==
X-Forwarded-Encrypted: i=1; AFNElJ8IIJH+YwmXSnfssrNSWFBtJABS/TocnXAsJ5yyIAXGb7dSWKYSastw1ceXMK/w7MOBUxZ3HCqRPw09@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj0/i+e/uFU0coRL/XroDlrk8u95s/saJ05d28t+BfVr9oxrmn
	yD52wqOE9HxZxFn2fzS9mMbpWzxwncvcKluN7Fv500k5lWmoudrILDmxiDnuogWk81Tn415cUjH
	CPGa39vyTxUKhe9Z1Dg45KFuIL/L+hkg=
X-Gm-Gg: AeBDiesnODOFWC0gkvGE7om7o9HGnRj+IESBUDzmWiX4Ji4hYWXSDiEBzK16Z2+t93i
	QzzSIt0Awa2u5pfh1krpeFk0PoB5UI5kJyuH+G/h+WvpFVc669uery81SXAdIVp3/1Fl7HcEweO
	hkjKyTEXgpyM+dWRc1yYPvc1NJPjJrA/VM65/Fvb3h2lvTsA5QLKjR7fSvcnW80ogtlnEqFfTDN
	+TpUjAYEfQKk0/fP02jia91egMuq8PwVgzXpRqOqHJyfkMFSUIdr5mA5dEcZgAFU++jw8C1Pc/U
	tpgtf7hB0MF/c5ZZ8KA1gxyvrmd1dvVpzQrZ2fI0LHuhzIz+9cAElszEPMkpyQJI9+Izin0OXN9
	qLwAHipn3lBxuWMUt4C6GMlZhOjJZfGcM7RLTcU9aKiCP2jVZTpcbjnAROE/PPylYzY81+AewFc
	cwa/+5g7MCgvXYV96HHNBezKjKNAALROuR
X-Received: by 2002:a05:6102:4589:b0:5ff:efdc:e225 with SMTP id
 ada2fe7eead31-609fe7a6af5mr14188877137.3.1776359760644; Thu, 16 Apr 2026
 10:16:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 16 Apr 2026 12:15:49 -0500
X-Gm-Features: AQROBzCHeeivzmpcVvSAPghwqF_p5p8CWOLC4VBxaoyaZj-oWjV2LHhRannbxEw
Message-ID: <CAH2r5mtbfUNKWr4E=yeUgYQhBF=OikCAtxwhJGgUJmr3g0Q1jA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
81dc1e4d32b064ac47abc60b0acbf49b66a34d52:

  Merge tag 'v7.1-rc1-part1-smb3-client-fixes' of
git://git.samba.org/sfrench/cifs-2.6 (2026-04-13 17:09:00 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc1-part2-smb3-client-fixes

for you to fetch changes up to c09fb907a2822864b7da866461fb33f10713b4ed:

  MAINTAINERS: change git.samba.org to https (2026-04-15 17:56:23 -0500)

----------------------------------------------------------------
Six smb3 client fixes
- Fix integer underflow in encrypted read
- Four debug patches, adding a few tracepoints
- Minor update to MAINTAINERS file (preferred server URL for cifs)
- Remove the BUG_ON() calls in d_mark_tmpfile_name
----------------------------------------------------------------
Bharath SM (4):
      smb: client: add tracepoints for lock operations
      smb: client: add tracepoint for local lock conflicts
      smb: client: add oplock level to smb3_open_done tracepoint
      smb: client: add tracepoints for deferred handle caching

Dudu Lu (1):
      smb: client: fix integer underflow in receive_encrypted_read()

Paulo Alcantara (1):
      vfs: get rid of BUG_ON() in d_mark_tmpfile_name()

Stefan Metzmacher (1):
      MAINTAINERS: change git.samba.org to https

 MAINTAINERS             |   4 +-
 fs/dcache.c             |  14 +++--
 fs/smb/client/cifsfs.h  |  17 ++---
 fs/smb/client/dir.c     |  25 +++++---
 fs/smb/client/file.c    |  21 ++++++-
 fs/smb/client/smb2ops.c |   8 +++
 fs/smb/client/smb2pdu.c |  25 ++++++--
 fs/smb/client/trace.h   | 160 +++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/dcache.h  |   2 +-
 9 files changed, 233 insertions(+), 43 deletions(-)

--
Thanks,

Steve
