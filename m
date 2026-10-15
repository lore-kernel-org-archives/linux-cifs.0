Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB65E4D9F91
	for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2026 11:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792063367; cv=pass; b=T14O2zHAFh8dSzhq1y98fk2tCVgimdN0KK/swJ9W9i7+zRZ8iD7vCq9JjKutXrXV4PU3krS2zoKxKc1iAFFfRiC2j9QO7vJ9miLl6CnQvKA/8VUbJ4ovShIkcK7QwL0Hs5FB50cKSZJv1/o8DEgiQC0wQwFGpX61yro58/7kPXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792063367; c=relaxed/simple;
	bh=Bp6zT0EcuaAmopOUo83h6H19QMZcKNGtIsBS/jA3GqM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=TMF7r0tYwtLfI1TWfGtCnfST2/MzdZrvwb32aFuXc/k2qntxLBaQOUDqJFRlRtsypeu2/papfYpFoHGfN41Ls6BylnUvE2uCjT698tDbgrkXBhyxREIcRyWEmYj/uY+nCTi4Z4hkuwzpJjfSya1L683o17QwjWUIH44GQqxf7Mw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QcQGlVuP; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QcQGlVuP"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c262f1186f0so683594466b.1
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2026 04:22:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792063362; cv=none;
        d=google.com; s=arc-20260327;
        b=d73pl9/aG84r3FeITpEFZiV70Jv8GpUwmnuBhovGQuysYDOxyCM/s9/fSDJElmp00l
         eL+PHcUqeCwworDpuV1E6yy9dOSm+9++aqTQtFobxjyvDvz0J+UuL+Nfh4GNVJ1da0Y+
         2mJ+fif4VUOwhOOvJWYD8FY75WHBha/7rC7i7bFn4Sl4OLlgUj74t+wJsoO8izPE80jB
         IagMylMiuPHlUE6PVuFkleSGnXfBtkaSWA8fKGKSVrTKN3BJwrLar3FNvQSl74ULZVIf
         RIwjhtab+3boJtiUjZr5l8C3GV5oPAL4Er3aFDa5XP6UF0aCqG5d7ddNvMpfYuQL/arz
         Ky6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=r7mMNM2umxZ4wtNcMODYjcnatDKtvNgKGxpXy7kuSj0=;
        fh=00kcqxNLcx76GOCvNNRiJYZWSfA20QYxFimES8ZneqM=;
        b=fPAskMqtS2C9hcoBozAtI8EuvpTXCamuQO/BdDHanQT4W1HddyC0naOo5Oklmm+ap3
         x5jQIcblff1zcq9W98fZQF50flDb0QixymOVd3B9MD8t2xxGt0g24rvuusRM7NWly0S3
         ml/DhD56yo5CUdpTO6sTj8gN2azcA/BwijUnMeF4GBmfZ49HU1CpO7o916Jl1J5HnpPG
         IB3mm89LZuOJ2D4qwazf2kaQ2yCdM4lUk5FTvXzLlztuekGKKHuWN4LlGZG5HmqYNz6o
         bjywSUTbJ1pSbV0SSdSPbtz9dvo3lHWj+lOWPfVj+MPFRpV/SOfZCgVeMXnYqCnK6Whg
         YG6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792063362; x=1792668162; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=r7mMNM2umxZ4wtNcMODYjcnatDKtvNgKGxpXy7kuSj0=;
        b=QcQGlVuP4URTF65QSv0paIZyR5Hm/PAHObF6zLNTB1hNouejTlqpLVZSaX7g182Eo5
         uCLSLiHRoELlL2CDM7gjPsju217ZyNuAWXZM0CC+m0ih8DLNABy2Klq/twFSuluTcmPO
         8V0FmqF+gZ+0mh+X8nGIFPvkAzLW68vmUHJAuYf2KfFZn6LoCSk6lOecGcfnQDTGzakt
         LHsaHKhJHzsPq5oDoUe/BVDMYLHlkk3GAqZCN/RWpzsenrTPWPtn3AeWMCvdo8U5mkIe
         0eMQl4jhQly7dWmf8p1/k00bB3Qy59WS/nemfkHaiTD7RG6WfV96M1vV1nQdkSUIQxxJ
         7b1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792063362; x=1792668162;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r7mMNM2umxZ4wtNcMODYjcnatDKtvNgKGxpXy7kuSj0=;
        b=ymqP97ZflicW9LLNLZ2Acl1HkuogfU1pn28ggTs/7kHGyJLiIEYwOldi7uOV/kz6yK
         p2qqyH2Cwfxt9gqPSTtq8HR19ojk71W9WZpnronDLTyQ29ruJUrLAk+lzGn449zgUpz5
         eVrVatzQbRGROMEvbYMzXKBKs+TMaovNZ8KLOAk4znzuVX2vkkjsvE+dtXU2iucWAllE
         0ZyYgNnDGXNlMRyJlROefz850CsSThe8jOKo4yDn9gXFvvY16olf7YEhAo28U2bMxAVl
         yK/stWqJERT6U1RBbe3ECRU8BMZsGlwxEJyWB+/iCTjm3/wvS8ISnhjaZL2YCfsCFSd8
         i+4Q==
X-Forwarded-Encrypted: i=1; AKwUvBzbKjQPO5yPuTkBJt/G5WbRVFrFOweIZmfvf7meA8CCP+t3BqMfPwHJfJTbHXLho/9QsiTHD69qg3Xw@vger.kernel.org
X-Gm-Message-State: AFq9FYJRO2NrmVkONea/jUWaMhVZCyefEnJaUmtOyCcAA/Y53EhHl7nh
	rNB7Oo9sXbOjwXDCZGe4PxFVx99kSFkoXO5U4jFbqZT7EPbNdzoNuJft2INYqwlyxBVq17V9zaL
	s5n8CoQ84aBqeotZjruEJ+kGM02ytNns=
X-Gm-Gg: AYBFou1YyGYKJnvWGlvofCYgPOWue76vY+/Yok4Ppb9qjtybgQ1ZC7BBL+iABarG2J5
	k7CqJXNBXGxQO8KWPaqZzCLiDXSf/M12D8B+Fu/3ix2sN+Mdj/trDOHaRl8Md2YotvO8j7G0DV9
	HpcYRwAI8NzX+idZTBYu9JSBpCyHMop1ligVrvmQL8fuSrYVsFHKZjnz5Ra20SoIu8NaId/0HCl
	3EbmIlCvubHsNpLHaHU7npbY5BFikN77q7P2xSbs+/8fGrFQtfVelFhhHdCN2tkRqDZVO8T0r6k
	blXHtW4Bw6OCi1NZFgfre42L6OtXVOL/S+zkg6gO5sSEBErwRHxWMl+Nxh3HHs4M6f/ki8Yk6RV
	FyY5ijeADkEs7f4HENFvPHGEcY0CLZJdHvuGx
X-Received: by 2002:a17:907:3ea6:b0:c2a:f360:1c67 with SMTP id
 a640c23a62f3a-c31aa083e50mr1651309666b.35.1792063361413; Thu, 15 Oct 2026
 04:22:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>
Date: Thu, 15 Oct 2026 18:22:28 +0700
X-Gm-Features: AclHuK8IU6vZGCWv_V9jLv2I14Sivzt3GDuZeGUrTj7rR-GOyIF3j7DEvrM-2SY
Message-ID: <CANTrAmy-Py3s30cCJC8Z+fG-Kk0JY+ihHrawGMMJQsOJCoqn-A@mail.gmail.com>
Subject: [PATCH] ksmbd: reject FSCTL_SET_ZERO_DATA on a directory handle
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, 
	Stefan Metzmacher <metze@samba.org>, sfrench@samba.org, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"

Hello Namjae and linux-cifs,

I found a remaining way to reach __kernel_write_iter() on a directory file
object in ksmbd, through the FSCTL_SET_ZERO_DATA path. An authenticated
client with a writable tree can open a directory with FILE_WRITE_DATA and
issue FSCTL_SET_ZERO_DATA on that handle. ksmbd_vfs_zero_data() then calls
kernel_write() on the directory's struct file, which has no FMODE_WRITE, so
__kernel_write_iter() trips WARN_ON_ONCE(!(file->f_mode & FMODE_WRITE)) and
panics on a panic_on_warn kernel.

This is the same class as the SMB2_WRITE directory case (CVE-2025-37775),
which added the S_ISDIR guard to ksmbd_vfs_write(). It is also a sibling of
the FSCTL_SET_ZERO_DATA access-check fix (CVE-2026-64398), which added a
per-handle FILE_WRITE_DATA requirement to this handler. On a directory,
FILE_WRITE_DATA is the legitimate "add file" right, so a directory handle
passes that check and still reaches kernel_write().

== Affected ==

Linux mainline, confirmed on 7.3-rc7 (commit 0fcb05b72344), ksmbd built in.
The FSCTL_SET_ZERO_DATA handler and ksmbd_vfs_zero_data() still lack a
directory guard after the CVE-2026-64398 fix is applied.

== Reproduction (verified) ==

Authenticated SMB3 session (guest is enough) against a writable share:

  1. CREATE "dir" with CreateOptions=FILE_DIRECTORY_FILE,
     DesiredAccess including FILE_WRITE_DATA, CreateDisposition=FILE_OPEN_IF
  2. FSCTL_SET_ZERO_DATA on the returned FileId,
     FileOffset=0, BeyondFinalZero=100

On a panic_on_warn kernel the box panics immediately. Without panic_on_warn
the kernel logs a one-time WARN and taints, and the FSCTL returns an error.

Call path:

  smb2_ioctl()
    -> case FSCTL_SET_ZERO_DATA
    -> ksmbd_vfs_zero_data()            (fs/smb/server/vfs.c)
    -> kernel_write() on the directory filp
    -> __kernel_write_iter()            (fs/read_write.c:608)
    -> WARN_ON_ONCE(!(file->f_mode & FMODE_WRITE))

Splat (7.3-rc7, KASAN, panic_on_warn):

  WARNING: fs/read_write.c:608 at __kernel_write_iter+0x74b/0x8c0
  Workqueue: ksmbd-io handle_ksmbd_work
  RIP: 0010:__kernel_write_iter+0x74b/0x8c0
  Call Trace:
   kernel_write+0x1ef/0x4d0
   ksmbd_vfs_zero_data+0x413/0x590
   smb2_ioctl+0x21fa/0x66a0
   handle_ksmbd_work+0x61b/0x1ff0
   process_one_work+0x745/0x1160
   worker_thread+0x511/0xc80

I found this with a coverage-guided ksmbd network fuzzer and reduced it to
the two requests above. A minimal reproducer input is available on request.

== Fix ==

Reject a directory handle in ksmbd_vfs_zero_data() before it writes, the
same way ksmbd_vfs_write() does.

        if (S_ISDIR(file_inode(fp->filp)->i_mode))
                return -EINVAL;

A git-formatted patch is ready and I can send it as a proper [PATCH] on
request.

== Severity ==

Availability only. Authenticated (PR:L), network (AV:N), no user
interaction. Conservative CVSS 4.0:
AV:N/AC:L/AT:N/PR:L/UI:N/VC:N/VI:N/VA:H/SC:N/SI:N/SA:N
CWE-617 (reachable WARN) reached via a missing directory check.

The fix was built (7.3-rc7 + the change above) and the same two-request
reproducer no longer warns, the FSCTL returns STATUS_INVALID_PARAMETER,
and the server stays up.

Thanks,
Lee Seong Hyeon
