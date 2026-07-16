Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C2439CD03
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 22:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784240116; cv=pass; b=d5uC2U3wlWfmkhM2DKylv4Nu9Auv8fm9iollvKqx9bE93XhVHc8I4kaX5MWXJYQA3/NZ9C/X7/jo2/aX5VT5518H1+xNRrisdlg30vUHNnnjVtcZzT67Iv+cGglFsYHwEFNPa5LUQtr4GSYCLl6AwLK0yXsy/kId0CWjSqIEP6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784240116; c=relaxed/simple;
	bh=/fKHr50xsHXgcjvfiP44D8F0PAPFDHQXXS9giRpDk24=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=f/1c/1tlzsG8xAXuNtX0CxhHmjdwRjmZ8JVQM/BRRDFB/9I/ny7cnHDm52iXUAZ4kWq54/S3kWyKUJtWsV/yK4bE0ayIZswU64FrbsChf6dbWFtdR5c3QWTmnBWL2D5ThS2tPEQqrHL20e36EhSdXwBlwCbVI+n4BNsVHFdkvyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eRRhsEKu; arc=pass smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eRRhsEKu"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-668296d0ff3so1548699d50.0
        for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 15:15:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784240113; cv=none;
        d=google.com; s=arc-20260327;
        b=reAX6oQdw+lkr/zCIa14y6P65KLWHbVgZE6OAoiQJ/7wNL+pVEeNmVqFM14IoYJitu
         JSSWGcRdnbg1x3D5RSoo4bfwbs3SNkiJ4di0Ma2OO4RSW5MK7BeR9/MFl5ZuBjePMwLP
         ZPzEQh/W1L4kjC89LrZE26ci2a9EyT/wGjUnBTejX1E/hr0ks7uHp0tSyofoL82zctPz
         WKUe5nI/bzXwMFgumbzkLCnsrExoDwA7unzo8UDfvflvBCKa6bLbh0fZW1IV/+OmWo/1
         NLXZsNRDIm4wicCUfplE73zhDYHdlOfmj6lEO7zfViBG+oMctUYMzPantnJefcxsfmfq
         JhHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=/fKHr50xsHXgcjvfiP44D8F0PAPFDHQXXS9giRpDk24=;
        fh=qPdn3nxQgygyQjJTDEl9+ZhpBtTWrqIbsZA12qELXjI=;
        b=QBP2a1FQ2cUXfGRPsRmXlNcNVUM7tjmhFn4poIqYEE2NByGeox8lO2u3R/SQduvSmX
         nQu7ptOZbaaYDHTOkUpdKsTohjU/2/SgSv5VbKaNueB02HnedlQsvNFCulCCdfdkrMrj
         4vHlJAG460Kvep6FWINy9b/djFchyYGCSWk2YXLfYjMHxuqjY7SGTDkr2nBk2gPqmYFd
         AQ1OunUVkRwstwoegWVVi8/YNJFxVNwaLu7GLEXVG1usVmagFeC3AGuxD1b0LDwMGEr4
         ZA1C2s49xeqF7qJAL/hJcdDFDiNb2ZhmTbQcUBPjNobJ/x0QuwzYbzY9thfkGA4oA9gm
         gQzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784240113; x=1784844913; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/fKHr50xsHXgcjvfiP44D8F0PAPFDHQXXS9giRpDk24=;
        b=eRRhsEKuREXG/Y12mPl95lYg7rJ47ZsO2VPEGCgW2ECFL7yTN051ybDRTmp8DxtAfI
         qkuMNs8futMgbYObmHF7BqrA8DsJbN+jGw9r4a2d7E9CBEDnyxnGnHg1fVZVe0vwlf8M
         CF8ixj26UPCzKHmEK6XjbibnzhH8p85HSpZCUqFlgQMRxtRzsbjxpsDBIePt7iDmjV6S
         pQJPArAO4FhGHT/6hJXsmrk80LEy8yX1M3zmPBcRsCHRza+mYORijaRamVytnGpTyBCS
         G+52SOogloeUJ0Srfmni+TI1gyF/tIxYukRf7S3DgumFxrw4HENnTV2rU4szc3zzkYnF
         085w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784240113; x=1784844913;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/fKHr50xsHXgcjvfiP44D8F0PAPFDHQXXS9giRpDk24=;
        b=Dl8bZvgK7Os1dx/r1jlnrWuWA8c7Qy2wlxExTPx5LWMRrIznjEfNb/jSTTsZhqCwWi
         6GUjrMOOZ/6Dp+hB7d9jeWusW3ju6ntVn5TxQ1s3Ict31kfRaZR6/NBqaJAfrAJynMcu
         mYrHfu9ObvZlWirECTI5fQfvIa9Omb/VyQKT95sFPwsmi69IJyQK5C0NERSZkXP0WMe+
         8zMu1cBXfdLJRP2jayjdtcC0+thAD9YcIjkQUm6UeuxcCdh52PN0uvp401JBUKBCsODj
         doYGd1Z1UlMQY2u0J2e4SKgTtAONyWaK2TlHxkQcP6KfDbd0G9lXpdLTsepYVO24gCR0
         TvTw==
X-Gm-Message-State: AOJu0YyxxbnYyVVnyyIZUmQTL0ZUzfro9A2gHJfvkJ+va4BHPR5jRCHw
	itXWRM+Yzwyy6RbIn7evWmsu77L8/vE7fL6EbOlB5an8SqPlxCIP7SH80bPUFOmI1W/HLGHlCOc
	zMMFdC7eIAhwpe6pKKe1GzKN/wZr4GZAAplwfRJCwxQ==
X-Gm-Gg: AfdE7cms/oJoYehqRYxUt60zrG656Gcb9pHAourooyFAYe8HTz/Qc4KWdrk/ZRjhMuV
	K4UDKMdUEAgU5zCEaN+xFzlF71zDd2xJNQSjKOoarK5iPEm0Ep02Nj4GT0B7Kl6nrbhvsn/MFaR
	XA3TCS1y7L3yqIOPwwR+NBFgszQCRTJndv0uylVksCpL/RaZR1VVylKZVXhjnAxn311CaehwXo0
	71g3bs/dR5lnIXyUK0LUZoiXQzvMm4akFsyxuJqOXNKULJ3cI/XE4cGxcp2pfrvR4xZCrn39X/R
	6uv6+vJrkvtmi9KsryiiZ/2g00fttdz0kn2VlXpZUk8=
X-Received: by 2002:a05:690c:6888:b0:80e:1ad2:afc3 with SMTP id
 00721157ae682-81ecf7af68amr66200537b3.15.1784240113507; Thu, 16 Jul 2026
 15:15:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Charles Research <trilobyte777@gmail.com>
Date: Thu, 16 Jul 2026 18:15:01 -0400
X-Gm-Features: AUfX_mx4pgQ_2qye8jklRjODVnV_HkllpIHwO9X8i1PExnDP-RRwMuq73HqyRF8
Message-ID: <CAPS2u-V+MxCXWUNnXt_MbAHZa4uQfen4grtD3JNsw5AJKsWY1A@mail.gmail.com>
Subject: [SECURITY] ksmbd: SMB CREATE widens inherited POSIX ACL masks
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello KSMBD maintainers,

KSMBD widens an inherited POSIX ACL mask to rwx when an SMB client
creates a file or directory. A named user or group entry that an
administrator intentionally made ineffective with a restrictive mask
can therefore become effective on the new object. For a new directory,
KSMBD also installs the widened ACL as the default ACL, so the
exposure propagates to descendants.

Affected Versions

The vulnerable code is present in the initial in-tree KSMBD merge:

Commit: e24c567b7ecff1c8b6023a10d7f78256cef742c4 (Linux 5.15)

The issue remains present in Linux 7.2-rc3:

Commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa

I therefore assess the source-level affected range as Linux 5.15
through Linux 7.2-rc3.

I dynamically reproduced the issue on Linux 7.1.3:

Commit: 199c9959d3a9b53f346c221757fc7ac507fbac50

I did not dynamically test every intervening stable branch.

Required Conditions

CONFIG_FS_POSIX_ACL is enabled.
The backing filesystem supports POSIX ACLs.
A parent default ACL contains a named user or group entry that grants
broader permissions than the ACL mask permits.
An authenticated SMB principal creates a new object beneath that parent.
A second principal maps to the named ACL identity.

Observed Impact

In an owned disposable VM, I used two distinct SMB and Unix principals.

The parent default ACL granted the secondary principal rwx but used
mask::---, making that named entry intentionally ineffective. A
locally created VFS child preserved mask::--- and correctly denied the
secondary principal read and write access.

A child created through SMB instead received mask::rwx. The secondary
principal successfully read the creator's canary and overwrote the
file. An SMB-created directory likewise received widened access and
default ACLs, allowing a grandchild created beneath it to inherit the
widened permissions. The widened ACL state persisted across reboot.

This is a persistent cross-principal confidentiality and integrity
failure affecting newly created SMB objects.

I am not claiming:

Access to pre-existing objects.
Code execution.
Memory corruption.
Privilege beyond the affected ACL identity.

Root Cause

fs/smb/server/vfs.c:ksmbd_vfs_inherit_posix_acl() obtains the parent's
default ACL, changes ACL_MASK to 0x07, and installs it as the child's
access ACL.

For directories, it also installs the widened ACL as the child's default ACL.

The SMB CREATE path in fs/smb/server/smb2pdu.c invokes this helper
after object creation.

Reproducer

I have a tested Python source reproducer using Impacket.

The reproducer:

Creates matched local and SMB children.
Records their resulting ACLs.
Verifies denial on the locally created control object.
Verifies successful read and overwrite access on the SMB-created object.

It contains no binary-only components.

Because AI assistance was used to review and package this report, I am
treating the report as public and am not attaching the reproducer to
this public message. I can provide the Python source and retained
evidence privately upon request.

Suggested Fix

Preserve the VFS-computed inherited ACL and inherited mask.
Do not force ACL_MASK to rwx.
Do not modify a referenced parent ACL object in place.
If KSMBD must transform an ACL, clone it first and ensure that the
resulting effective permissions never exceed normal POSIX inheritance
or the requested object creation mode.

A regression test should compare local and SMB object creation using
two principals and verify both file inheritance and directory default
ACL propagation.

Temporary Mitigation

Until a fix is available, avoid KSMBD shares whose parent default ACLs
rely on a restrictive mask to suppress broader named user or group
entries.

Where possible:

Remove dormant broader ACL entries, or
Use another SMB server implementation for the affected share.

I am available to retest a proposed fix using the same disposable
two-principal test environment.

Regards,

Charles Vosburgh
