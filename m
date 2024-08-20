Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF6CB657
	for <linux-cifs@vger.kernel.org>; Tue, 20 Aug 2024 01:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724116513; cv=none; b=AcYyr2J/DH929dTRcNcoFFX7e/BNb31knMthntE7fqihaft2VCm3wE+TK5Z9saXFVox7fOF8MQrb1FE/S/1OX1SXSp1B7efY3i4/4mr/xEvvU/RU3Qlou+ACNxgfXWZacvZ7cqn3pfTLQng434ONlhybAuvAPQXBXs2zhYNKxA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724116513; c=relaxed/simple;
	bh=ni8sHyKP0apd4CJFWBj8Pg7apncKK7h+4mT5CO666Ok=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=JD6VwQNBy3QwnUoVVec9B655J0zPURkDD0jGe0c9fXCcr1uVsCV/j31JMFecRihd05CzaArbjWSrZp+UWM1cfMR/zEixNQPjGkZx1o2O74rUnOpG3Vj+tYvU+ndm/2Xw1cCT+8JZFXbvOc69SZl6d+/heqe81xbe+3/h/A6KdWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NBLz6H8G; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NBLz6H8G"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7093efbade6so3220725a34.2
        for <linux-cifs@vger.kernel.org>; Mon, 19 Aug 2024 18:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724116511; x=1724721311; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ni8sHyKP0apd4CJFWBj8Pg7apncKK7h+4mT5CO666Ok=;
        b=NBLz6H8G8CljWMJY88SNDkHQSPmxvjX8+R7jL1WRA+iGegUSwCQEb5TZ5/ADSp262k
         R+LshoPMW60D/mGNYAK9omN9O8KkTKxXrlOZ8mmdoTtcJSEdCcPYa5A/8nK/fUnyOA+T
         ts8T5gQ5aN+/H9/89jGOAJmJ0JWrPWic6jKTpO6cxMpl3zH0U90WWEjsxkwAATvzU65F
         Vt188ND29GXeGeZQARrQzvSosUjR8IzKR/W3WbxODBPtBLCw/Ca8oFgdC0OtGwI3de5M
         rpfiYiq2Zq5cMZa0avsQ4uXcCHWZ4thCMDH1FjFeXJfsflNGDej9B5NNFfgZI+QV1X0z
         Ub0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724116511; x=1724721311;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ni8sHyKP0apd4CJFWBj8Pg7apncKK7h+4mT5CO666Ok=;
        b=otfSxdt2v7DuAoeQ3mu0n3jMh4liUbtmw/okdLZllE+HBQvMedzekWt9fUCjnmZOH0
         Pv9xLAVmEqOElkNusKFjUh8mBEdsBk0KJ1D0i7fmm3rW3q24tyEdTkJ7QWMmOKKj/A3J
         LbFeHg669azx8Oe1dEfJudrgD2tQ1nVa6VcbjQABAMSL2Y1W8FplcsnTSZzgyFLnynGm
         0heQesbf4KKXIFhk5gpWRet+uuOmdzScWGvkcTawtnAVVWBlMr6CoG9Sx23BDHEEIKQ/
         5nZLZLjhnScMvlViYgOO234FRApEdnDUUm38KRwCfKrin3QK/MAH638ujra/VGis98op
         cGEw==
X-Gm-Message-State: AOJu0YwX6h2LNJYh3O5zemaJtw4ktKWq4Vwat1TVttGTdhliVGDyuumb
	1JF0OUquj25I6X/VbTynAFxsZW+NUQab4OtIJWP66pAFsWcqkXs05JThdOmUkLVPohBsWUTOftt
	pg5i7qX4ZjuM1RfTUGt+PUveCvT3tjW87
X-Google-Smtp-Source: AGHT+IG91KIK+9qaGuHlDyCqYIu6R+SLCGBsboErqsHfzQOOR0UWI6uAlIsUdMt7APEcU4HNIlxYwf4sbzXuRLSACxk=
X-Received: by 2002:a05:6830:6118:b0:709:4507:6b37 with SMTP id
 46e09a7af769-70cac8b54abmr18067549a34.31.1724116510777; Mon, 19 Aug 2024
 18:15:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Marc <1marc1@gmail.com>
Date: Tue, 20 Aug 2024 11:15:00 +1000
Message-ID: <CAMHwNVv-B+Q6wa0FEXrAuzdchzcJRsPKDDRrNaYZJd6X-+iJzw@mail.gmail.com>
Subject: Issue with kernel 6.8.0-40-generic?
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dear all,

First time posting here. Let me know if this is not the right location
for this message: I am happy to redirect it elsewhere.

I have the following setup: Windows 11 machine running in VirtualBox,
hosted on Ubuntu 22.04.

The Windows machine uses MS OneDrive to connect to our corporate
OneDrive for SharePoint. Inside the OneDrive directory structure, I
have created a Windows share. Let's call it "mydata".

Whenever the Windows 11 machine is running, on my Ubuntu host, I then
run `sudo mount.cifs //192.168.56.2/mydata /mnt/mydata -o
username=marc,uid=1000,gid=1000`. This will then mount the Windows
share and I can work with the files on Ubuntu.

This has been working great for many years. Yesterday, this stopped
working. When I tried mounting the share, I would get the following
error: "mount error(95): Operation not supported". In dmesg I see:
"VFS: parse_reparse_point: unhandled reparse tag: 0x9000601a" and
"VFS: cifs_read_super: get root inode failed".

My Ubuntu host machine is completely up to date, running kernel
6.8.0-40-generic. From this machine I am able to mount other shares on
the same Windows 11 box. It seems that as long as the shares have
nothing to do with OneDrive, it works.

When I booted my Ubuntu machine on kernel 6.5.0-45-generic, I am able
to mount the OneDrive-related shares again.

Hopefully someone can have a look into this situation.

Regards, /|/|arc.
