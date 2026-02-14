Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABDD27707
	for <linux-cifs@vger.kernel.org>; Sat, 14 Feb 2026 10:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771063597; cv=pass; b=DPUvVOuaVpFeL92iucXi/qJhLulrMVEsYnrotfVfng2zA4BeWLLo6ftkcUjAXDQM77SwrAVGzqddGg6FJjRQOYbFjFNhlCH5e3l9nPvShu2DCDUhzdpMqsu3bakFFx2LC2hu4uSqIXMa83TNOrQ2VkovWaaRCRaCvoJXYN7ltRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771063597; c=relaxed/simple;
	bh=jY3VYgfZdwcEWaDFOTWHCBRqnN2ieQGX76J1TWV/hN8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=MYViDjjMXckgwvZMSmHnDBJ3DMEoeZ6TjPtIETgwSREX/AxT+ur732EPfXTohk9ypMn9KIitSkkFWcZZISIN3FPUiYP45VOtiDgOOSZ/Wo/JfYP64/6wQ2SzRXgX9H9EcqQEQ2TKQ6JFnLxdzEnRj6SluccjJIJbm5xqgmgT4mM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iJWG/0TD; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iJWG/0TD"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b8d7f22d405so192188866b.0
        for <linux-cifs@vger.kernel.org>; Sat, 14 Feb 2026 02:06:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771063595; cv=none;
        d=google.com; s=arc-20240605;
        b=DtOr8N+QfFsM8vDYHr4zPoEW8VPPgDSO/Hqle4ZGqFEwpJ2oPteZeW40ke7mWZnzIr
         xUJYZRY83e2YyxOWO0fYBHAANd5TuMuUTSDrgjvJpobXYk688EJE9qfSnRGgeCQ9n5mQ
         sirG81zYcnU/HL8EnNzy10n7YlSFSBxfShEb2oyE2Ck0eFsOr5QpFf+EE/nwANKanIJS
         eP1xIbqerXJZafNU7iGhFjqa0+fvi+Lq6cgXO9KKVmOsOrV9Pk7s25V+vwxVS1QJtaHk
         gCo7/AQq1eKbKD1oKqOg+W7HUqf5X+uneIYPs0nenXeq422aDG4/l9jzzLf7AUQKq/ON
         COkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=PGGVJbddt208w/rGIVrn/yfhIsOw/8PIkZU+nOzBAdQ=;
        fh=r7c1N6HNZosojyzzUJIIjr2YgXOI79h25XHxmf+w8Ik=;
        b=SPThk18m9Kc8ZUA+YrTyTL1/XsoVOHXFca70Oh2nKYuURWTz9Nmt7A+rmg7r+k+l5G
         CZdn6YPaBfL9yIZyS9rFp6CYfIxNcDgI9A7AqvkuuQAaKrwJU1XkcnHL8wRGi+0j5sl9
         CgUNHER83alG8UJ4zlnYOiAjhYsbJKwDAJmhihkWtBvQ47GiU/piclTgyCJkWhJrMapG
         h+7H6vplr7H3FRiq0hIAoCzDOzyovnph02xjJEs9jwy20GNHeXSXEi/pt+wGUpvMrjVj
         l39rb61+j5zOSSl3x3yR5Z26DnaGPxDIx3d9DerbWyjH0gZcVVOGxCsfe6dayO8Lznsp
         8nCQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771063595; x=1771668395; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PGGVJbddt208w/rGIVrn/yfhIsOw/8PIkZU+nOzBAdQ=;
        b=iJWG/0TDNqvsdOWejxmu1z4K6eR6SkFFPeweAMKUuf4LjlqhwlPSq5tZSYCbHIPKm1
         EltXd2Tsle99bwwM3BWsEjIOZ+nolbgkUOW7pdQB3oScmn5W6gdTWWtnF1vbCuKB2nOf
         we0xiWFbptRLuR1m/hb43AuR2tOT69JGivipnH8le1LKrV6Y8EMxSJVeaAF6KkG/75Jg
         Th1xMmTon+pabWXfcBFHEA1Uh3V3RC8EaYDqxLc7yl348ADM3jt9Gzme7RyUZgyvhBqC
         EOi/GKPhKPDijFB3bTJejzBSKCQij/BWO0zam99kZ7rACGVRhnrpWBaJr8uaVKdf4CWu
         Exfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771063595; x=1771668395;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PGGVJbddt208w/rGIVrn/yfhIsOw/8PIkZU+nOzBAdQ=;
        b=i7Q//KpUJymDViUe3teBeKCPNL+HBLg+03/NlsiELyYQvwC59dycHHNzt6dwq4YD33
         6jaoBaNpQtarVxF8A9ATm0dLLJjm7ExmJmt8HXLlKG5TgjaT5FvPkJa6RgrwH0zJmzw2
         xg4fDcg82PpTNgN8I8PBqtVqNtIfoecicFKyK9EaLj7jGRmv1rDd6eQ3iIugNxLsnGrf
         kf9k3jTU+v5VlsCby7+3n/v56GXWDybnKS99iRbSe64HM6kWtO2e5SDEqsPmzU/qh3ve
         0hVEDDzJoMoBc7reraGdFStDo6m2D0sh7Fvx1D0snQ2ky4rKf2xMB+AVkVNJSyOUl+Ig
         Bbew==
X-Forwarded-Encrypted: i=1; AJvYcCVlAndDAiyt7QkKKg6o8QQlcWHso8rUm8uhS0gRXU74nXVLdi7L+cBefUgJTSIXTFG2x1mhYbTly0LV@vger.kernel.org
X-Gm-Message-State: AOJu0YxVGpMq0xVfWhAQbEtC/YKncKllTyzrT3gqMuoISAsYdYqHBrb5
	jBAZM9FMF6mi8xuDBXIgwhsMmbxHD9wLPoz8MBr14FQclxKl8lig39WKPgcqS8J0k2KRpIz6Yhm
	ZuMkZhLLZQocF3ABntwuiEKXqwsJAblk=
X-Gm-Gg: AZuq6aLbasmoV5wsvtWTwTU/X78uZkVkKgD6QJiHfPK9tSdgmhpdqe776R8S3AcBaBl
	a3VY0W3jem+9ljy9n++XacdiwllssG6NR3ar7tdYM33oaGBd21XRuiiuTXIHw6zC7/ZajKeJgm7
	2A4aThIBiCAa8L8Z7PTEF+GWeMpOiR5cGhoc2c/V93wyeGupgvaUVhvSFhxM2vm+2YxnRMYGy4k
	7inESwIBzrqphkukSE7poYFB6qcEvoVlYTwxLlXO+wj8OP1EsnahRsj+1w+VXCXx95cFshjafww
	Aws+bQ==
X-Received: by 2002:a17:906:c14d:b0:b87:6d6b:1366 with SMTP id
 a640c23a62f3a-b8fb4462ebdmr258928566b.41.1771063594865; Sat, 14 Feb 2026
 02:06:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Sat, 14 Feb 2026 15:36:22 +0530
X-Gm-Features: AaiRm53SFCWgM_DXMfR7wPwL0TsGianlEbiEEbkirbl4xvQ7utf0iFrM8-H5s6I
Message-ID: <CANT5p=rDxeYKXoCJoWRwGGXv4tPCM2OuX+US_G3hm_tL3UyqtA@mail.gmail.com>
Subject: [LSF/MM/BPF TOPIC] Namespace-aware upcalls from kernel filesystems
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, keyrings@vger.kernel.org, 
	CIFS <linux-cifs@vger.kernel.org>, linux-nfs@vger.kernel.org, brauner@kernel.org, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Kernel filesystems sometimes need to upcall to userspace to get some
work done, which cannot be achieved in kernel code (or rather it is
better to be done in userspace). Some examples are DNS resolutions,
user authentication, ID mapping etc.

Filesystems like SMB and NFS clients use the kernel keys subsystem for
some of these, which has an upcall facility that can exec a binary in
userspace. However, this upcall mechanism is not namespace aware and
upcalls to the host namespaces (namespaces of the init process).

This can be an inconvenience or a blocker for container services,
which run most code from containers and do not like to host any
binaries in the host namespace. They now need to host an upcall
handler in the host namespace, which can switch to the appropriate
namespaces based on the parameters sent before getting the work done.

I tried to prototype a namespace aware upcall mechanism for kernel keys here:
https://www.spinics.net/lists/keyrings/msg17581.html
But it has not been successful so far. I'm seeking reviews on this
approach from security point of view.

Another option that I could think of is to host a device file in
devfs. The mount could register with keys subsystem by keeping an FD
open from inside a container. The keys subsystem could then upcall on
the "right" FD based on some parameter supplied to it.

Looking forward to hearing if there is a better approach to solving
this problem.

-- 
Regards,
Shyam
