Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73883C4565
	for <linux-cifs@vger.kernel.org>; Tue,  5 May 2026 06:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777961519; cv=none; b=A3Z58yX20Zlw+9BZYlyMPOOimeqMr21BlC/zCKuxzCn6npekVM0xjfiw9VdZWe8WO+zU36qrjiku2yBwR28jCeyEhBiD0xZYa1EHpxaMfrjTWY1TQB8TeP/nwCc6/TXJVHD4oQ1iP/lucW0HgOGuNAz1h14x7BwCb2yZEZMuTZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777961519; c=relaxed/simple;
	bh=3RwYYy8oQs7B3Nh+ZfPDXaEpMDZlE/1vWf/pCAzCJp0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tH6GfGMR+PhZt0KMl3tUYS6H1WDpG9rZLB8PnfLxYf+5ZaaktMH9wnLE+otE/9b3plym6Q9JwY8FmDGXV6uRqFMtns6Rp7T2l4jDlLnp8Ofzzekd4gVHEHefzoyVN1eY02tDOgJ2lhnpJSMJ2gQ9IBaPFkDYOgqDFjvCxr2aLgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qQs2dLly; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qQs2dLly"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-836ed29d1e5so802351b3a.2
        for <linux-cifs@vger.kernel.org>; Mon, 04 May 2026 23:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777961517; x=1778566317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X+wwvpFMRip9QGwFsLUcpUYYHp8W07YpxKheBhhRTr4=;
        b=qQs2dLlyGZFdmv+AtLC79ziwdPhf4TFpo+NcAKiQYcFSwhqV0SaQKskXLT6Jq0jJQw
         xkkk6qVUWbZPIW6KfbGdqBVArT2s/PANU8Bq38d7CMMpZbkRnNxVj4x3QkS25GD9m8OJ
         7iXAsguXe6cgK1bzk7o3ZSHMVGMD/tX9hdNTd8e7EQD9zP6yUUS8NlcSqqsuANXurxvs
         VmVp4G8n8NGzh0A2BmRFKIXRxRKGI2ofCZic0rMG9fyhibtlxfH6HDFNMxp9TQJlxtpv
         gFK1sYueBDYwkIWdidxIBKTV6C+EkNp7ORPaEyRZRR0n1+SM31ZEoFk9D7frQgGJaGYK
         Mblg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777961517; x=1778566317;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+wwvpFMRip9QGwFsLUcpUYYHp8W07YpxKheBhhRTr4=;
        b=L/pKNWrPJ9p7mlDYGtODmFbnRJP+RKM4dACDBo6ZWGMdc9yTr3lmXuARx53WeEr4D2
         uNW1jlKJQxoeN23kfB6gShE1SHwlvkvarG2wFphtRm6DAqAsTwLJPwDUhjpgcO3kwfJu
         64q3Yw4f4Uxdvx3EFE0jvLjSBa+te6Pxpt/vPmRxk73I71foi12HGf9ojHLsH9NshWs1
         snT1eluxnpo7GFCsHSrbTfHGTxyFFrcUT5TCl7jhQca4RX0KmjgGvwX7839xRRr8FsNR
         HFC9WXqRFoGyZpwD6wc8BxnrGTSnn+ocZB+rEKisHCMsTOVzYEycDKsbcf9vxaLJmOHo
         7wCw==
X-Forwarded-Encrypted: i=1; AFNElJ9L3wDy0xtNScvRTOVo7eJBbjN4iryCpjYjtYbdg3MakZk5csDr2GIByo3NTTRQQajwad3RVBnTK6AC@vger.kernel.org
X-Gm-Message-State: AOJu0YwwOnwP+9sv5nv7hu5lYMaPn9ewUVhNuknOa8FC6m9N7OUpxczW
	pp/aOkhgPq43AN/hhKcwFveAoQ+QNSORvyQwH6nxCEPit98qUykMI0S6
X-Gm-Gg: AeBDiev1rPlpkM/Q2gyTi7Hco4dqQvgz8QwCC2d5ETqwbJRg/M3LPVcPPfnL1f47bCv
	znSky1cGMSleNYhm/milQRnYjjPIQFfcx75mYBEPgqzKwaUl0bmf3W2SbO5DoCLb9M1xmZUcQCr
	fu6sjQ+GIDC1xyZX8PhBbO6jroqo+u4hLVsoplhnT1nHlw7e1X/ZkoKT3tdz+UpgFyA9SPShxD2
	DmQ+HO8c3jBdht3ylDpfglBKGyDoZU+PPsSzG4euFBggg9Hbhn7m/eJKB4nz4s6xSJuE3MMDdG5
	OsPrJMYLSyM6j9DvHSL/Q1hgYRoYShfVotBWAgThf/POSxL8E4DndEEL6FxDLGN5riSSYhWqePu
	J3/BUdFgoo3Tjn4V8QIW3lQa6vriC2lChnWqJjVWGf0lgbaHwvMSnSS98ROkTLJzRsmuL2ItAYq
	uPbdLlu39QCW9IwifX22xqCRd+U2tiYKcK9a4AyaXaIVBhMv3z
X-Received: by 2002:a05:6a00:4f88:b0:81f:4e6a:7276 with SMTP id d2e1a72fcca58-839227d1216mr1744350b3a.14.1777961517008;
        Mon, 04 May 2026 23:11:57 -0700 (PDT)
Received: from localhost ([49.207.150.30])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83967dbdda0sm903484b3a.44.2026.05.04.23.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 23:11:56 -0700 (PDT)
From: Piyush Sachdeva <s.piyush1024@gmail.com>
To: linux-fsdevel@vger.kernel.org,linux-cifs@vger.kernel.org,linux-nfs@vger.kernel.org,netfs@lists.linux.dev
Cc: sprasad@microsoft.com,linux-kernel@vger.kernel.org,sfrench@samba.org
Subject: [DISCUSSION] Preventing ENOSPC/EDQUOT writeback errors on network
 filesystems
Date: Tue, 05 May 2026 11:41:53 +0530
Message-ID: <m21pfqgzbq.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,
There have been plenty of discussions on how to handle writeback errors for
network filesystems, but most have focused on error reporting after the fac=
t.
I'd like to start a discussion around preventing writeback errors specifica=
lly
ENOSPC and EDQUOT, before they cause silent data loss.

The problem:
With buffered writes on network filesystems (cifs, nfs, etc.), the write()
syscall copies data into the page cache and returns success immediately. The
actual upload to the server happens later during writeback. If the server is
out of space at that point, the write fails with ENOSPC. The netfs/writeback
layer records this error via mapping_set_error(), but critically the folio's
writeback flag is cleared and the page is now clean. Under memory pressure,=
 the
VM can reclaim these clean pages, permanently losing data that the applicat=
ion
believes was successfully written. Meanwhile, i_size has already been updat=
ed
to reflect the new file size. So stat() shows a file size inclusive of the =
data
that was never persisted. Another inconsistency here is that total free spa=
ce
hasn't been modified for the file system on the server, leading to incorrect
values in statfs() output from the client's pov (assuming statfs() calls go
to the server).
To illustrate with real-world scenarios:

- A user or application can keep issuing writes to an fd well beyond the
  available space, since buffered writes return success as soon as data is
  copied to the page cache. A significant amount of data, exceeding the
  available quota can accumulate before fsync() is called, at which point
  critical data loss is nearly certain.

- A malicious user can exploit this to keep resources pinned and memory
  oversubscribed, impacting other applications.

The error is technically observable: fsync() will return it, and close()
surfaces it through the flush callback. But in practice, many applications
check neither, and the POSIX "just call fsync()" answer isn't satisfying for
users who lose data silently.

Local filesystems largely avoid this because they can check available space
synchronously in write_begin() and fail the write() syscall directly. Netwo=
rk
filesystems can't do this cheaply =E2=80=94 a round-trip per write to check=
 server
space would negate the benefits of buffered I/O.

Through recent development, netfs is becoming a central layer for network
filesystem I/O. It already has retry logic for transient failures (EAGAIN,
ECONNABORTED), but ENOSPC/EDQUOT remain hard failures. This affects every
network filesystem using buffered writes.

I am curious to know if NFS has a solution to this and what the approach is
towards this specific problem by NFS community?

This problem is worth solving for all network filesystems. I have a few
thoughts on approaches, combining cached statfs() output with
fallocate()-style pre-allocation on the write path:

1. Pre-allocate space on the server before writing to the page cache,
   analogous to fallocate() on the write path. This guarantees server-side
   space for page cache data.

2. Since per-write fallocate() calls require a server round-trip, effective=
ly
   negating the benefit of buffered I/O. Use cached statfs() output to gate
   when pre-allocation is triggered. For example, once free space drops bel=
ow
   20% of total space, enable fallocate() on the write path. Otherwise, let
   writes proceed as normal.

3. Handle refresh and synchronization of the cached statfs() data separately
   to avoid staleness.

I'd appreciate feedback from the community on viable approaches.

--
Regards,
Piyush
