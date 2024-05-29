Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E190015A872
	for <linux-cifs@vger.kernel.org>; Wed, 29 May 2024 04:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716956286; cv=none; b=h1OeBEu84crsA3UzmwC3DVej90UWmZKhNEu5qg97ReEOuDNfj9kkUMsFxVnJeUpcZx4zpsf/yrr+3B5UvRjQjX14g2pPytVsGKd90bsZyIIkJFoQ6qu659n+VM6y08SCNJfVNewb0YulZY86BjzcJ9FEHkhlEbAcDbbVyJxqkVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716956286; c=relaxed/simple;
	bh=UABv6IKk/vFDwIZnji7GeJ5bqMHfHpktdhnsQV7zeLE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=RFnPg4G4gQcM7K0aKLZtKV325EBhVEtkyPv+67pYeeQZ2T93kwnyfHMW9SoxKyaFGiZ/zypCGNSv0MRKLKdgDEl+JQdbaL8kdOVnb0VQIdMh6J5x4YvhC7wcP+zfwzOTW0kOmKjASdzQpeaWnDgYNAPOOGmX4PCG7dHf6XYZSXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XY7fFt/q; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XY7fFt/q"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-52388d9ca98so2471727e87.0
        for <linux-cifs@vger.kernel.org>; Tue, 28 May 2024 21:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716956283; x=1717561083; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FRDJoOM1hOAoBkAqN0BWwBP0h8aMZDQpzsARbUtbeZo=;
        b=XY7fFt/q8VMod/2SEaBD33TsJac9KZw/GWMj3EyVnONWaZKzQkWCpsJhDCQjlvVCW/
         4veDwFyFM/iYGsejrOqVY65xVBDzAlGNCu95MWH0hukZDc4PEBazYhIrR80gfvBpml5l
         nKdctaQIPQugOtedbfS2lNPkNh17AhxMqQ6ll9wn/HVxMxH+TXzBpWi8tp1mdp8hpEs5
         BcNtecHo1daDAlyISLgwjARGCkx4gkfFJ0cRKETGUu+EhKHMHyuRD1gZn12eFxUJhlFC
         wO6LpcrGy4t/4JK77DmR1xeoRiVcyXuWGc6A6YkVcL62YmI0MgFWTxRFHClbvVQPV97a
         7bNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716956283; x=1717561083;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FRDJoOM1hOAoBkAqN0BWwBP0h8aMZDQpzsARbUtbeZo=;
        b=NTy3OzMcL1woy1QK40+pFZgUe8G5yD7q74MeuCHqe5VcDxZB/1Mua4EwUOan+W3gRa
         Hm4r57Un1XZoR8qLHIPvzgKtvIJi6TrkUYC6+HuDCkWs1Gnfe0nAWlfRdEm/lGKmEBP+
         9nUnw3RrnoJmsAnexpWvfkX5egrPwq2Yc7Jaa4KO/AH18GSzNF6TJOl1qZjzpywDZoQy
         gydQxyMPSBxKSEIhLZM1EHqxF4iCvMDyprD3L0Wsb1ylVYkZHILbmb93rpz0d9UWqU1i
         so1gKpOk1rYuAMBW4bVQ9Aqz8e+GnqGAZnxqlyNrYLqPoh6p0NHZw4aGbtT/1FzrvHn5
         aCww==
X-Gm-Message-State: AOJu0YzAOULsxhiXpHQW1x+0Co2WbKrWX2na4KdpPgSvY2ohwq/lYyYZ
	xAI9KePhz257q0lHDOf2sM129UG6Q7RYAzzigoobTdJ0xhadA7iMeirxMxnir6FDKrA9TxXOsYl
	qaIVZdgp40tK32GLjW0shyPuPfjqKwxY9
X-Google-Smtp-Source: AGHT+IEGKwAZiOngGR91G05JTmhnzi8gsdagPXKdgXXFWPJHsEoOvBE6/pGbS6achva3E5Iyc0fNhtyKre+SNQjuBgk=
X-Received: by 2002:a05:6512:4c1:b0:523:54a2:3836 with SMTP id
 2adb3069b0e04-52965f10e3dmr10141713e87.33.1716956282630; Tue, 28 May 2024
 21:18:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 28 May 2024 23:17:51 -0500
Message-ID: <CAH2r5msbOL10R65Wsa75yUox1ncHQW_fmnD+iPg2x3pZQmOGBA@mail.gmail.com>
Subject: creating sockets with SFU xattrs
To: CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"

I noticed xfstest generic/423 failing to Samba with "sfu" mount option
(with "cifs does not support mknod/mkfifo") which turned out to be due
to cifs.ko not supporting creating sockets with the "sfu" mount option
(it works for fifos, block and char devices but not sockets - unlike
with e.g. WSL reparse points)

Block devices are mapped using the string "IntxBLK" to identify them,
char devices with "IntxCHR" symlinks with "IntxLNK" and FIFOs with
"LnxFIFO" but there isn't a mapping for sockets.   Any thoughts on
adding "LnxSocket" for this special case (creating a unix socket when
"sfu" is enabled)?

-- 
Thanks,

Steve
