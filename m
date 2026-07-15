Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D7843848F
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 12:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784120272; cv=none; b=fAc0WhayOIa69nVwQv17WQi0r3JUUB3iHWBZz/UBQE2eTMl7UImN/wTWuOPsWu1gKygfuLYyF1SSrDiWHOFI52CfVMgLWDMQwdIuiorSODcS+HX3aNe7vJxqGeqAlKpLle9OKKw/QX7FA9P4s38gfZcPSSjpVsTyqmRQQFnjCIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784120272; c=relaxed/simple;
	bh=KCAGgRFHAv3IxHTYUhLQXgtYjFrtWGFiPej1+r96f28=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=muDCrNDKY3OQ7XmE8onLlwT2oNwWurjgq3zRGsKBkGzTZvwCBEdpYqskKurMFv5oOYFm26+B+NZR3w3ity6M38MUT8MmYFWIhDl3U0487rlesmzC5/lCP/IClYRt/FdQdn1zD/IkRREvI3XOWlfvGB0mgU3QqUL4NE+Ri0tVubs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jpartners.org; spf=pass smtp.mailfrom=jpartners.org; dkim=pass (2048-bit key) header.d=jpartners-org.20251104.gappssmtp.com header.i=@jpartners-org.20251104.gappssmtp.com header.b=wk/ig691; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jpartners.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jpartners.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jpartners-org.20251104.gappssmtp.com header.i=@jpartners-org.20251104.gappssmtp.com header.b="wk/ig691"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8f1e274ccb9so15494616d6.2
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 05:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jpartners-org.20251104.gappssmtp.com; s=20251104; t=1784120269; x=1784725069; darn=vger.kernel.org;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:content-type:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KCAGgRFHAv3IxHTYUhLQXgtYjFrtWGFiPej1+r96f28=;
        b=wk/ig6918REp9BlO6dgYSCMnEvZism4D+tu+VZ/StBE2yC2DHk+MA7QJBT5nW82kUK
         dcfD2H3hrcfJ7X3havYFy7dchX9ITyBU5k54/OE6x1FkNpx0BdApNAqIyGeaJeZmlHh7
         nu1T8GFgoOO5rpwUMtbl6Z/TlFh9Lq6cvK0U5dfAyCXAhjAaQq42B3G42T7VKfr8kT3u
         ydhiqSSYjE30BrW35pWlm/OGwGklFnpuLUxAo8SMsighSiuntUUzKS8HRC6kMOP5hxNo
         VanCqbxzxd7g95YKlB1DKTjJZn9P+1EqpZDzR2hrSWbTIF9qCC8nk4G4g6E1bPknvOAW
         MmZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784120269; x=1784725069;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KCAGgRFHAv3IxHTYUhLQXgtYjFrtWGFiPej1+r96f28=;
        b=Q1FLHYE/uAO/FOPGS0WhsMaJYgN202nP33bFsAF7YIo4jWTcJ+lfjQbwTArMvF2ThB
         k+zDEYcWG9fGwKZq9VlcZfSaDQv3yaT6X+FxMaEjaISGQ9PTfTFsQ2P/ZJsqoBuGktHO
         O7KnGo3FTu1MeduZFNzwd5sg61+c7xMGUSa1lz1B0HWEqKMY6cLbtmo7hdfgWCB0Jzx6
         ciK9+Vg4F/cIW7+XgpA5U8vgYUWDehPRVwByQ/daVfLLGPTfCj83hBu8VdlqQt/DcrVS
         6YWOkNrbr2GGIXNpVEZvVPx5YqQT7c10x3s0V75u7KmoL8vENFMxJog8WIISTEznuIO9
         q8uA==
X-Gm-Message-State: AOJu0YwE8hOv8QUI+xWBc8IWY9emLWhh8sx6RqbVd1NyW/lM5xtcJXAm
	dsXYm/FrUUNRmY3SIJpZYNXh7aD5mQsLzUovw2bqiCfV5wMgR7KZB/dQY/K7lr+qKrXeFBfvIOy
	fAN1k3It7
X-Gm-Gg: AfdE7clG9JJsM5es23HyTNuKfTr61vsbtTAB3cG0/RXF3tXwdcgSwXxAKzTMKD21SCq
	1E8X65oIXZurwGaatXtMGL9iEW7QSH9qrIbHetzDL+dKsJQw5VrOjOv3Xuc0E29GHqJsmKtMOyo
	GE3cRAIVngGcitCwQPsBRqb9KrJgjfAvNzFiZ0eo4nZxxD8QMjzkYIP1XZSI2NngWuEFAoeqixT
	6TCUH+oIVQfNCsx/Ts8lrXBUgq61Qb8VaFZqZ4kEhC7wbYfExadfn2VTdtyzLlIy1rEG0MY0adm
	ZfNKRSxraglaehUFODrX6FW/+n4ABQoTLQRj93x/gbC3lpUcOgM3A4PL0w0XLTfZctbTfIS7FlT
	3QsUkIxtY8iZOlLCsKqfz3fn3AJgiH/5oBgGru3wCQ6c7YKBGvQCQvCmCpmejHYR/wAkdOFhbAB
	l7aT/+WP4mAEoFruD0wdHg8kFMrT8H+zOldk05yNYwVmv6/VOcCsGItiL+owvMixZf1A==
X-Received: by 2002:a05:6214:2127:b0:8fd:6df3:b376 with SMTP id 6a1803df08f44-90402a6ad32mr190212606d6.58.1784120269551;
        Wed, 15 Jul 2026 05:57:49 -0700 (PDT)
Received: from smtpclient.apple (dsl-sb4-27.greenmountainaccess.net. [65.19.73.27])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd80fd82csm192636466d6.35.2026.07.15.05.57.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jul 2026 05:57:48 -0700 (PDT)
From: Carl Johnson <carl@jpartners.org>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: [BUG] cifs: readlink/stat of macOS-served symlinks returns -EINVAL on
 6.18 (works on 5.10)
Message-Id: <36A8E483-23EB-479D-AD0A-C9981861CF89@jpartners.org>
Date: Wed, 15 Jul 2026 08:57:37 -0400
Cc: sfrench@samba.org
To: linux-cifs@vger.kernel.org
X-Mailer: Apple Mail (2.3864.600.51.1.1)

Hello,

Reading a server-side symlink from Apple's built-in SMB server (macOS) =
fails
with -EINVAL on a 6.18 client, while the identical share on the =
identical
server works on a 5.10 client. This looks like a regression in how the =
client
handles STATUS_STOPPED_ON_SYMLINK when the server returns no inline =
symlink
error data.

Environment
-----------
Broken client : Debian 13, kernel 6.18.38 (armv7l/BeagleBone), =
cifs-utils 7.4
Working client: Debian 12, kernel 5.10.168 (armv7l) -- same server + =
share
Server : macOS 26.5.2 (build 25F84), built-in SMB server
Share content : ordinary symlinks, e.g. Config.json -> =
Templates/Globe/Config.json

Symptom (6.18)
--------------
$ ls -la .../Config
l????????? ? ? ? ? ? Config.json
$ readlink .../Config/Config.json # prints nothing, exit 1
$ stat .../Config/Config.json
stat: cannot statx '...': Invalid argument
dmesg: CIFS: Status code returned 0x8000002d =
STATUS_STOPPED_ON_SYMLINKThe same operations on 5.10 return the correct =
target. Accessing the symlink's
target path directly on the 6.18 mount works fine, so the reparse data =
is
retrievable; only resolving the link itself fails.Not a mount-option =
issue: tried symlink=3D{mfsymlinks,nfs,native,<default>} x
reparse=3D{nfs,<none>}, vers=3D3.0 and vers=3Ddefault -- all fail =
identically.

Root cause (from a traceSMB capture)
------------------------------------
On opening a path whose final component is a symlink, macOS returns an =
SMB2
CREATE response with STATUS_STOPPED_ON_SYMLINK (0x8000002d) and an SMB2 =
Error
Response whose ByteCount is 0 -- i.e. it does NOT inline a Symbolic Link =
Error
Response (MS-SMB2 2.2.2.2.1) carrying the target: SMB2 hdr : =
Status=3D0x8000002d Command=3D0x0005 (CREATE) =
Flags=3DSERVER_TO_REDIR|SIGNED
Error Rsp: StructureSize=3D0x0009 ErrorContextCount=3D0 =
ByteCount=3D0x00000000 (no ErrorData)Raw CREATE response (traceSMB, =
cleartext, sealing disabled; 16 bytes/line): 53fe 424d 0040 0001 002d =
8000 0005 000a .SMB@...-.......
0009 0000 0050 0000 001f 0000 0000 0000 Flags=3D9 NextCmd=3D0x50 =
MsgId=3D0x1f
0df9 0000 0002 0000 0018 0000 4b93 d0c6
8361 3db2 1ea1 3269 5d81 d833 14c5 6a0f (signature)
0009 0000 0000 0000 ... StructSize=3D9, ByteCount=3D05.10 tolerates the =
empty error data and obtains the target via a follow-up
open with FILE_OPEN_REPARSE_POINT + FSCTL_GET_REPARSE_POINT. 6.18 =
appears to
assume the target is always inline in the symlink error response and =
returns
-EINVAL when it is absent, rather than falling back to =
FSCTL_GET_REPARSE_POINT.

Suggested direction
-------------------
When STATUS_STOPPED_ON_SYMLINK is returned with an empty/insufficient =
Symbolic
Link Error Response, fall back to reading the reparse point
(FILE_OPEN_REPARSE_POINT + FSCTL_GET_REPARSE_POINT) instead of returning
-EINVAL, restoring the 5.10 behaviour for Apple SMB servers.I can =
capture full traces at higher verbosity and test patches on the 6.18
box on request.

Thanks,

--Carl=
