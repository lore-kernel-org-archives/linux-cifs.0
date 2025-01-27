Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F5717C21B
	for <linux-cifs@vger.kernel.org>; Mon, 27 Jan 2025 05:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737956470; cv=none; b=uCHpludHrJtJsGHsi2q7c1R8KoBAwn1V2k+pdAtLW6BCbxnICZHoVbe3V0Eyf0cLafL4xrr4ma9dmVPkbOI9UkvxSa88wHVpdXwf3sUhH8+T1KbG0i0uac7PCooGbW1ACqaVWeWa7JWPCyf5Doilxc0+WCYNlJJ/DuFRlj3Y3N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737956470; c=relaxed/simple;
	bh=B/A7SbutVokaMpxuYqlEoZSJ/cCiYRpmDRdTPcb/+e0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=HKc7fRpwP3iT3bwKLzqRjLNCDB4YzQIod1rH1eEQlTvfxoBUcMz6u0NZSPvm4U4DcTLNwiwH6h5N6IOgd/KuY9FJKnColgNcIrvrqhquWR3MZ06ISEWYbICBd+InPbLTSh/3FnHo4vWkSBCbyKi961iuccrUuWl9FnZ0WYsLkWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GUrUHLNf; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GUrUHLNf"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-53e384e3481so3884070e87.2
        for <linux-cifs@vger.kernel.org>; Sun, 26 Jan 2025 21:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737956467; x=1738561267; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cc1jxRIURFIKDANA2epTG0hCLT3t1EH0LabI23VPB5Q=;
        b=GUrUHLNfKhGk4W23lPKa19Dneucw/VxoBi3cBn6llLjku9qJBV7hhg4Z1cHYn23k5r
         rEIoUKVc50R236tANQwskTwdsXXUPlj3WBmk3qmzn1uXqhyvEzoMUf9U5tGBIm5SVhWM
         ul71/i/1ZDC1qaRS18CwbsYY/6NPenchuRhOScTDYlAL2jSQpwiIWKkYDToK52HT1Sn5
         JLoBnrmQK+NbpU5fmNZsqFeV/RIRKxrj0TbeaDxWEgCVoXHDrFrneBciBK39OxpaFLLu
         RNx8C3mdLvyMDU+PtFl2dByy7wSDbm9eRgf2Se6hCDotFuLU6zvRZKQs+14479qGL2vS
         8G7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737956467; x=1738561267;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cc1jxRIURFIKDANA2epTG0hCLT3t1EH0LabI23VPB5Q=;
        b=QD3r9hAoOm2VdgmyP8yRQM6oWuQ8s4qfDRZuHY5UE6qgMI9mUNmd9zuMqyPW+wjC5b
         QND3FI1tkJ2mLtvidXA2s3lk27b42589qtTDu3nQsudHTg1a1hCjFQ8MNZXuC2uBuwBa
         Kys4/1r/dgV4ucrRUqUQxtXJAll5w4ykDf9jiEWJ65iR8w/5CZVA3IpgXHii42h7crXC
         gs8UNvQ5x5mbsodL3WBOH9CO/k6d61n0WojnfcGfW3vmWVZjzpI4CXdnuv2z3daQ0ghg
         3VE3uedBc1i/GzOGsgBoaCGzPZIAJrJOol8zFsHpxWEKO0p8ZKPQp1OQKw8UQTRTBTI+
         s4oQ==
X-Forwarded-Encrypted: i=1; AJvYcCXk96vAwAlKVb5jHVqxrKoKqycJ5ZFEIr64pQ2WnDfIca+xmz/Q67ns72LXF7cuVqZcQBBE2XGdpRMn@vger.kernel.org
X-Gm-Message-State: AOJu0YxHsnm+r75jM7im/iBmmxwRAPxejFF+uyJ2KwiLt4tX1HyiIIX9
	9HsSBl1Q9sABXtD3mf75kMOrcjZjFgWR9UeOCWRWtj0kD5jdEghPs4GZxezdFjHcmPGcYqMi+YR
	UiJlBtqmrFcVed39JWHUMgacM28Y=
X-Gm-Gg: ASbGncucuZtJ27+OtU8gDWBkUC3kEMTuotSpCZWMjMVwm+Ln1RksiNeNItxyxVDm4LO
	hSML9YU23rT4pNV5RE1M1H0EOjMo2ufNdwqW76f6uGsxF2xHgEXP055cM4oAy5/Nhtr4MysXkPW
	gMuFeFOWASflM3tJSo2dgQbbE3k5bbHJg=
X-Google-Smtp-Source: AGHT+IGm/X23y4G6qe15nsclLRV3zFH+Bm/rLBGq14VyqAhOd/vhlgJ4oNlwaheuT8XQ5APQqCCETsTg4QltTjUI1SM=
X-Received: by 2002:a05:6512:1092:b0:540:2122:faee with SMTP id
 2adb3069b0e04-5439c241638mr11813015e87.26.1737956466612; Sun, 26 Jan 2025
 21:41:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 26 Jan 2025 23:40:55 -0600
X-Gm-Features: AWEUYZmEvhcWE__IO8vrYorYlN7zOEWTIlszb7Wm71JbWg2y27oEcCrcxKSYQdw
Message-ID: <CAH2r5mv=ujxf7p--oQV3m9nukGqh5doo_kPReeLOzjQOSC1+DQ@mail.gmail.com>
Subject: warning building cifs in recent mainline
To: David Howells <dhowells@redhat.com>, Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
	Christian Brauner <brauner@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I see this warning building mainline from a few days ago.  Do you also
see these warnings about struct cred?

  CHECK   client/cifsacl.c
client/cifsacl.c: note: in included file (through
/home/smfrench/smb3-kernel/include/linux/sched/signal.h,
/home/smfrench/smb3-kernel/include/linux/rcuwait.h,
/home/smfrench/smb3-kernel/include/linux/percpu-rwsem.h, ...):
/home/smfrench/smb3-kernel/include/linux/cred.h:175:41: warning:
incorrect type in initializer (different address spaces)
/home/smfrench/smb3-kernel/include/linux/cred.h:175:41:    expected
struct cred const *old
/home/smfrench/smb3-kernel/include/linux/cred.h:175:41:    got struct
cred const [noderef] __rcu *cred
/home/smfrench/smb3-kernel/include/linux/cred.h:183:51: warning:
incorrect type in initializer (different address spaces)
/home/smfrench/smb3-kernel/include/linux/cred.h:183:51:    expected
struct cred const *override_cred
/home/smfrench/smb3-kernel/include/linux/cred.h:183:51:    got struct
cred const [noderef] __rcu *cred
/home/smfrench/smb3-kernel/include/linux/cred.h:175:41: warning:
incorrect type in initializer (different address spaces)
/home/smfrench/smb3-kernel/include/linux/cred.h:175:41:    expected
struct cred const *old
/home/smfrench/smb3-kernel/include/linux/cred.h:175:41:    got struct
cred const [noderef] __rcu *cred
/home/smfrench/smb3-kernel/include/linux/cred.h:183:51: warning:
incorrect type in initializer (different address spaces)
/home/smfrench/smb3-kernel/include/linux/cred.h:183:51:    expected
struct cred const *override_cred
/home/smfrench/smb3-kernel/include/linux/cred.h:183:51:    got struct
cred const [noderef] __rcu *cred
  CC [M]  client/fs_context.o
  CHECK   client/fs_context.c
  CC [M]  client/dns_resolve.o
  CHECK   client/dns_resolve.c
  CC [M]  client/cifs_spnego_negtokeninit.asn1.o
  CHECK   client/cifs_spnego_negtokeninit.asn1.c
  CC [M]  client/asn1.o
  CHECK   client/asn1.c
  CC [M]  client/namespace.o
  CHECK   client/namespace.c
  CC [M]  client/reparse.o
  CHECK   client/reparse.c
  CC [M]  client/xattr.o
  CHECK   client/xattr.c
  CC [M]  client/cifs_spnego.o
  CHECK   client/cifs_spnego.c
client/cifs_spnego.c: note: in included file (through
/home/smfrench/smb3-kernel/include/linux/sched/signal.h,
/home/smfrench/smb3-kernel/include/linux/rcuwait.h,
/home/smfrench/smb3-kernel/include/linux/percpu-rwsem.h, ...):
/home/smfrench/smb3-kernel/include/linux/cred.h:175:41: warning:
incorrect type in initializer (different address spaces)
/home/smfrench/smb3-kernel/include/linux/cred.h:175:41:    expected
struct cred const *old
/home/smfrench/smb3-kernel/include/linux/cred.h:175:41:    got struct
cred const [noderef] __rcu *cred
/home/smfrench/smb3-kernel/include/linux/cred.h:183:51: warning:
incorrect type in initializer (different address spaces)
/home/smfrench/smb3-kernel/include/linux/cred.h:183:51:    expected
struct cred const *override_cred
/home/smfrench/smb3-kernel/include/linux/cred.h:183:51:    got struct
cred const [noderef] __rcu *cred


-- 
Thanks,

Steve
