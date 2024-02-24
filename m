Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CA5137E
	for <linux-cifs@vger.kernel.org>; Sat, 24 Feb 2024 17:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708794158; cv=none; b=rBrtlp0HQJqzmKww9Wiv37/nyHCriQ5vNw8pTr1geuNANPz3/HIbLgWcnFzwOZ6bGHPfgYt47aOgv5vFpZUjf2bHqf7fk+ehUwkNoVO8eJAwWTGOuyacKfstn6Pj7WwPlIdBGUENG4nDOOf8Z5VC2r8/+RJTLleK08jspGLYYlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708794158; c=relaxed/simple;
	bh=OttzUp8O6KGQoMQyQywTqEQCiIshEbjddI9Kfr/94jE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=ca3kCDCyq+J6q3GZBMthPKIuxLBjHS9Ze6sWT59tMOU5PyRFyIosjGKgNOJ5+4sSLr5Wo9oib2I6Q4DyJJDtNQJXeQ2G8nskBdw1ToukGoKmpilUV9ivxsjYytWz6mXwMcjIwEyLQF+1Zmn5aXaencndvINtK6eIi9Pim51fUzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FrqSp+BB; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FrqSp+BB"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2d27184197cso17462141fa.1
        for <linux-cifs@vger.kernel.org>; Sat, 24 Feb 2024 09:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708794155; x=1709398955; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bX1HjKh3irzZA/PiysGudHqhOW07nr/bQrq5ajAhz74=;
        b=FrqSp+BB1uHftshEdWIrDmYLNKwbTZPwgjyZq5wT8BsSjULDDY8ELs5Jry1XwpKEfR
         WVMettkcscOnlGdyENmoIKphEgPZ3RHmKNty1fUQ+MnLFOu+iTHuLjosdxUmpgJfyEGj
         ljrhMnGNihL7LdDJjq5e3HyoFzyBlHY1R3yZJ8dSP5jKKBfh8Gfld+T/mt6lWHBr6FGC
         BHg2pYdQLWNP0zU/6l14xk30SJOt1zWL054BfGnue2lIdIUj3Azu18Es0VdO88B2eArI
         0dj5A8LmHjfdXnZv3c+AbuFzKDKMVWfB/pivvq1blrQd2J98B9HpjWnhGW9G6dWCsxY5
         DsFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708794155; x=1709398955;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bX1HjKh3irzZA/PiysGudHqhOW07nr/bQrq5ajAhz74=;
        b=Vay3OMAbu4WjKvMzXmuyzFsXAFAAyjBlGW9AYYjq6iW1seiDCQ6/Zrr9KCzZBbfG91
         Z2zVaPjNeW4xYdU4/l8ZIx6hfpIJxg2fDEKIX0iG4+YjqRbNbLX08EFMxj/A971yeU8F
         CiUQLynL3Audz2O4Eh14ZuZ01kduOCQO7A0p9M8zlEguRSsL7cnZaq+zcJPJle91vb8L
         yHI62RuM2Dt0GU7Rz8NBOQ5cqN/nEAmCUYSSYC2vu4jw6s5JJpDQb8rVRZ0aXMzgfq5s
         CIIrJHfTVQI3cvQJ9dGaq5012MxK1+wjD0o3KXg0qB99sejhVdJR9OQ5oWRwPzl+M/xO
         afWg==
X-Forwarded-Encrypted: i=1; AJvYcCUj/lvNUNn2eVy3Dbs0POVTWUdmFwe3wGdorEVEsP5cNJ1TJtLIIzXk1nkuCoEflXmnYVCq9izZ+ehjkZjdzJfKhiOXHyDM2cFw+g==
X-Gm-Message-State: AOJu0YwhO/nS95QkV6OVhj/7vF4omHjaoRVuC8bi7R0eM6FVNIVG7SwN
	6W9BdOIl4aKHXaLSKN7st1oe2WRj/D2ngxuT0Ez1rbW+ZrnIDOco38Ay6+PwDO2XjBElqvhMZqY
	l5mkIe/OEpuQjwcQShu6P95HIsafWeZEXk2zPOQ==
X-Google-Smtp-Source: AGHT+IF71ZYbvlgFH0SyipFWzz3KC3HFcs4777CGyiNi9YnhOtcK38P2WHrAaCJg2wGSWE12UNIf9doq3LhHN1IE5aA=
X-Received: by 2002:a19:f719:0:b0:512:ac3a:7f27 with SMTP id
 z25-20020a19f719000000b00512ac3a7f27mr1414119lfe.66.1708794154650; Sat, 24
 Feb 2024 09:02:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 24 Feb 2024 11:02:23 -0600
Message-ID: <CAH2r5mtnRccqbgbrESE3rWODE4RBS91=Anb4x1KsejX2DG7VCA@mail.gmail.com>
Subject: test runs with David's netfs/folios updates for cifs.ko
To: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Test run is going ok so far with David's netfs/folios updates for
cifs.ko but it did remind me that we need to work through some of the
longstanding xfstest failures that are minor so we can reduce chance
of regressions in complex patch sets like this.   An example is why
test generic/564 has failed for so long:

generic/564 1s ... - output mismatch (see
/home/smfrench/xfstests-dev/results//local_sfu/generic/564.out.bad)
    --- tests/generic/564.out 2020-01-24 17:11:18.820854930 -0600
    +++ /home/smfrench/xfstests-dev/results//local_sfu/generic/564.out.bad
2024-02-24 10:59:47.572877816 -0600
    @@ -34,4 +34,3 @@
     copy_range: File too large

     destination larger than rlimit returns EFBIG
    -File size limit exceeded


-- 
Thanks,

Steve
