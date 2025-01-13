Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D47214A60C
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jan 2025 05:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736746746; cv=none; b=coAbzvOMnIXhzTC2wq3oRtgfNuox3slJPL3w8eq2UGHnm8awGEeAjUK3QZjzCnYH4OX2FnVmpV9QTFhPap54MqP9ydKxQtSWb1/M/An6J6vkDqH9hWTlENGeLExljJ34a/5TlBJoqYvg1ZvcZ86cGwYz+sESvc7IrwKhGkrPceA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736746746; c=relaxed/simple;
	bh=MXvd/OYnpLZGf3uXY//j+8SSep01blVAhhiS4E1O9e0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Dv67c77fuXGcJpAjIJx562jvaYAoGE/ODtd8qCZj8u9I0MQPtuhig6mWgSOl7W5Y2BZaW3NnzgCnIx49ueQo5Ub5eJ26NucT1yWtS5rMAhRrVee/hUVN6SxvVgErQYAd8dQWC/uUXtVjbYbqkcvXxpJgvGUUwwmvOQV21uP8lR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H2vBK6r/; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H2vBK6r/"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-aa679ad4265so939681166b.0
        for <linux-cifs@vger.kernel.org>; Sun, 12 Jan 2025 21:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736746743; x=1737351543; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Oq2Xm02nJnzgtvn3KudIQmgQMaYy6UTOBsadezzdhbI=;
        b=H2vBK6r/B+NcnTsSElQMP0lFIfJ3LU9GBgxCAsHUNEDnuCd1oHBe+04nxLThgRN+ZO
         EEfpPFRlZP2al5kPojR+tTF5Ymgto8EA3rIAkrfaqRdHENwU4CHGthpRjdJR0jRK0tau
         N/Aa7R8h3tCoA3zDOie2LAkYrIJUy83D9ilVTWErx6U8xKKNxzUDY/IfcIwk/UCJmECI
         LNL/pZk4W270eVFlV6GhyShkrZVPdOwmpa9VZncv70oC0DUJCz/j9uceTSCryN7jvfpI
         sogAVw85NXnhZNgnmf6hRPpiptSwTT1e2OjwFZ7iN/h6CjUVc2pWFdncLiBVHkcnKRxD
         Hf0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736746743; x=1737351543;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Oq2Xm02nJnzgtvn3KudIQmgQMaYy6UTOBsadezzdhbI=;
        b=FJbs0di5XETcoAFAKNHW/5+8rbj4TJHNKTRlYYaNwDYjxEu8Js2tUraekq8PsW8EZK
         zEpUXd3RwdXsnVuHHbfhZnJD0+zVJ7z1oGltxLGvnFC5ceJPQivSyU97ma91q/XZSKm0
         fk9mtUQzRmqS+zc1tIGzEjxjU1mnBXTHnz4PubgfcDxBDkdcrhV7VyB+LwyudVQ3uKD6
         5KDGup1CUViDMWOqIGsN++l8V+ABu+KEZInc5e/lo3RKfGvmMPYjUd0uRrGoQY0LQpHg
         E1fVtzOGCG2iGphq5gidXgCelNvRlF/S+UvB2auGDedwnXBtCpilJpapLi5xMi4rCKCX
         uvFw==
X-Forwarded-Encrypted: i=1; AJvYcCWRx17tenT78aSQLUmDZBfHb3602puBbbkPF+8iyXKd/dkO5zUeC24y04q2KqQBnZUdQbQmCbKxLrhF@vger.kernel.org
X-Gm-Message-State: AOJu0Yzt2Y+emFmyP4nC/Sq7N+IpX6ZNOBvEIHGr2UqJ5kdJXzUaYCaS
	mlwNL4rMwSuvwYcj6GA6nK98Q43HKY2BznGKnE5LDzpoMy96Sz+C+xSyXhFKPU5+hNm4de0waOe
	j0qTqHM06TBLBYJwr5YwouWq6Yzg=
X-Gm-Gg: ASbGncuj/N8pybUwJVQwlgGnz9cLfs0hDsHnF7wRZv2M2w/+wkNr4W9M7brCSYS4CTV
	bMYgVySgfTgluf0VM/7QaAN6tOz9eGcLkrT2ryDYh3XxX2OwGLbhzM0Gz5/QD/JViaGy+
X-Google-Smtp-Source: AGHT+IE6EUVq5gCk62bO3E/qbMborQaVFRlT2qeitragiLFAXmpeyCi31s69Cu4ugU3HbtJMgVwZv/RH2BictpsM6mE=
X-Received: by 2002:a17:907:7250:b0:ab3:2719:ca43 with SMTP id
 a640c23a62f3a-ab32719d096mr23582466b.10.1736746742496; Sun, 12 Jan 2025
 21:39:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 13 Jan 2025 11:08:51 +0530
X-Gm-Features: AbW1kvaR4jHJYUj4-Ui-aI72-rxnrlcCC9ILe6u7ilprK98bcnWYUEK64n30Pns
Message-ID: <CANT5p=o-1V2ea-+Lj+M0h4=syXyJYu73JU3F0dXij=KVwWUTOw@mail.gmail.com>
Subject: Negative dentries on Linux SMB filesystems
To: Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.com>, 
	Bharath SM <bharathsm.hsk@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

Negative dentry is a VFS concept where it maintains a cache of
dentries even for files that do not exist. This can come in handy for
situations where they are looked up. For example, many applications
first check the existence of a file before creating it.

Ideally, negative dentries should allow a filename lookup to happen
entirely from the dentry cache if the lookup had happened once
already. But I noticed that the SMB client goes to the server every
time we do a stat of a file that does not exist.

I investigated this more and it looks like vfs_getattr does make use
of negative dentry, but the revalidate always comes to
cifs_d_revalidate even for negative dentries. And we do not have the
code necessary to deal with it. We do use d_really_is_positive before
we do the dentry validation, but it looks like that comes to us as
success, even in case of non-existent dentries. Is this expected?

I compared the revalidate code on the NFS client, and it does look
like nfs_neg_need_reval deals with this situation based on some
heuristics.

-- 
Regards,
Shyam
