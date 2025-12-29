Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780781A262D
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 18:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767033011; cv=none; b=leKcIy3/poVXM2nnCs7fwAhNfeYcEm0rk1IWsAo/189gqECb21tzi+aD1ppUbmk+TOt3HCZDoTAk3r+QoEnAT9dvMJxUhDPg2v9SM1Mzk36iROAWyZzloRy4sFpslfbh1Tu6rS4gqAEgbC+p+BIZUWOYFSu7zM9z/K3gXjAfTIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767033011; c=relaxed/simple;
	bh=NsADr57Sfr73PBFRiUmCAx9OAAedIrL+O73wPmmfj2w=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=fBvWqFJYSG57PZCXz+5ovgeR2MtyraJHwekqTkgO0dS2m+ZDM4y4GTZnMdLtbO7W9o+UvAY0KqUkmyNpKz+rDP3CvdYiUNkZAWNtnJPspO6OJ5KKLXcfhU1tXFXBqAY/hFLmd3DWhLCTuwMqsExb1WLKML7jhvKSOf4UIsqgQe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UtVQ6Ci2; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UtVQ6Ci2"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88888d80590so137489586d6.3
        for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 10:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767033009; x=1767637809; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J5A8IchAU7xjROn47L3+QhV6exIzgEFrHYKUKsvij6c=;
        b=UtVQ6Ci27aTPDG4+nFhhsEDR2GMTCten5G4+Nywl2UNxv1YHxDQOmIEhHHxK5oMvCo
         hIiFRPAcn7XYB1AcyoHvX/Zr937SW0Cv+A9FxE5nsLS0BpUjyhZZ6y9LeLAVkl33J5D3
         xmBfDcpnaz0m7SzABYFa6vphGr2HUoBSm55nQYzfQEsS2Oy8/Rc8OSA42ZOanUT27Em5
         g51CuiRmVH8XM6cPus7IbLkmC1P2qdIwxEC+jD3Eni0IavnAwbtk2wDtI59DLYymH6xr
         lhR8Nmt0DrzJITqag87zWDsdv7CQgXYj3Lr+1XrCGkne/MlQ2YCnJaY8YTANtdZg8T7z
         3jxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767033009; x=1767637809;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J5A8IchAU7xjROn47L3+QhV6exIzgEFrHYKUKsvij6c=;
        b=oSZ4QvS7bjoPTeC0zQdYh88Sw3nru26aN48lrjougImXNbuD3At15GgGN5z18MS2vj
         +Vebl1ltDAX2blNI1LmsY/RpQ6gOwCdSutGzKV/P6GJV3FOqSic1yFex5YVSwZC62fYf
         /lYm+kxgUay+rA3T3G6+AWW/tO+bbYRKhYLU405rytHbIYX7ejsA3SggX9PKQji1546J
         hi9MQk3cRTZdoHOkYDFpDMLIm5MsBqiMFPK8DO4mx0c2jKwHIKjoMaOIU6F+ogxQMfRb
         WSF5Oaeuwv5GLeSSZOT/Jds2ccpKoi7xBlsymzu5UwBFaSFcGSHSwcT3SB6WlYaPQyEP
         2dgw==
X-Gm-Message-State: AOJu0YzkmRCLU6zQ4FmSae6E7cmebmuh2gPbnghmb6cLs+PY5qStKHxu
	IhKZzJUsvaEVrOI52RdGCeU5KtN4cLJ73ABbaGpRDyvmt3H6PEyXUSzPoGeMv3+nEhP4adaGRQ1
	P0alGFg+2gPbYhJIEBYWXQp/KosXulV4LACmA
X-Gm-Gg: AY/fxX4roQ0fbk6cxtkyCB3sfTSBcjwHc9y7f52Q+vV6ACuHdqGROeM+xTaB8jqByji
	odyScDpNQySD7w+Bt+JljwxQpagFCog0FJgpM3G1wpJ+S0EXxgWrGpX+a1fbcT+/bHBYWc1zJMa
	2jrrEf7b8Kcn351GJEIKNkVg1OUBZdWcMAkLPsZmD/rToHZ7OKicWHqpQTi2u25yy0Ag/NciRpC
	fIxPplYIuPyjLstg/k/GbH521hzIOCcerRE097Nw+SQOZUOtCCSsxjPo7toDlTfODI3fMDCMi+8
	n6AvkTjK1q7Xcxepx0P+vnRMJmwBstLZ61cmDyhbOYXtuq+l7XYJINZ1E8BOezx/fiRnduQlJss
	aYlUnfmKIb8HXy+0tZ4fonEZvLHsG8LbY80qVA94ycbmmgaDHs1k9MrH6vlFNwAyNF5CPnqcLal
	3mB7N9REE3
X-Google-Smtp-Source: AGHT+IELYBtQ1P6/II7jvKVJvIP/tpdu1cvDnECHGPR3tyueFFAOomyT2A+RFg58lpQaLgFdF5zGgafGfHj8Y8L0NX8=
X-Received: by 2002:ad4:4091:0:b0:880:4c02:c4d with SMTP id
 6a1803df08f44-88d881ba374mr362179546d6.66.1767033008897; Mon, 29 Dec 2025
 10:30:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 29 Dec 2025 12:29:57 -0600
X-Gm-Features: AQt7F2qRgmpV7RsrIUSLPphR2bx7uMJ45fsX_qmNCWVJu9G6eUq2RXhTjuofppw
Message-ID: <CAH2r5msjKJHoc_fmhbDHEyvgqAGYdORWKTtDdimzBNaTbAAZQg@mail.gmail.com>
Subject: unsupported ioctls called by various xfstests
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

These are the six unsupported ioctls I spot when running xfstests on
SMB3.1.1 mounts to Samba. Will be interesting to check which ones we
can implement

#           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
        fsstress-20591   [008] .....  3456.488138:
smb3_unsupported_ioctl: xid=182517 fid=0x402198ef ioctl cmd=0x40285881
        fsstress-20591   [012] .....  3456.414404:
smb3_unsupported_ioctl: xid=181925 fid=0x2443a23 ioctl cmd=0x800c581e
          xfs_io-20572   [014] .....  3456.376141:
smb3_unsupported_ioctl: xid=181905 fid=0x0 ioctl cmd=0x801c581f
        fsstress-20590   [013] .....  3456.412290:
smb3_unsupported_ioctl: xid=181915 fid=0x7b5c4fb1 ioctl cmd=0x8100587e
        fsstress-20591   [012] .....  3456.413995:
smb3_unsupported_ioctl: xid=181922 fid=0x0 ioctl cmd=0xc0205865
        fsstress-20591   [012] .....  3456.413977:
smb3_unsupported_ioctl: xid=181921 fid=0x0 ioctl cmd=0xc0205866


-- 
Thanks,

Steve
