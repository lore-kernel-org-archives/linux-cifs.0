Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825EE14287
	for <linux-cifs@vger.kernel.org>; Sun, 29 Sep 2024 15:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727623967; cv=none; b=eHHSUbWujQrF5LzYhuyenFl9338baaUUnl1K9duXAdSSiLL8W0qtnNrJYRbR3mp0GhdFyveCu9uCFIfjMf2ljCKZmOvba5yL9lSRmnER/prCRwtyUDunFpj/KkoYFZIb8KX5nUrXxemWL/xA9i9u2f6BdT6ny5xvDmavbj0mw4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727623967; c=relaxed/simple;
	bh=QRH+jJ1czjdNnCon2jzbJbXo/e5xhdgqxmQCPrpMe8I=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=i3B4XH5sSx0CNsI6NMU+Vjdr0GByktwFkkjn5Gccnj1eE+CuGrjrlutswMlsugqr5Vb1VxdKXfLRNMhA6M32K5B1Dhr+o/XyewZCi+PjGKNpsk2TkwvSaNDeCJBkY6qUCjusLaqNJd2dCJwFmjK/G5J/VE3YW38nbfEDQWipj9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EYaj/8Rc; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EYaj/8Rc"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-53992157528so435429e87.2
        for <linux-cifs@vger.kernel.org>; Sun, 29 Sep 2024 08:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727623963; x=1728228763; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tiN6X2hSg8DI82vcwWmMRF/GpIHNZY05FXXMG5qJJZE=;
        b=EYaj/8Rcksgi9i9PlDsd0AzSo5Ofn0Y3ufq+Aga+MZqtK7qqCCb8cdTn4TkYgMTA7u
         8JpbytHUIlZXQZpe3M7JBlBjKqGIN4Wpb1PqvdnMwiEv+f41PajCVcRa1qdrmVP+JdWR
         jNbiH3HMgOy+Ya/m74zajBSvVei2Q/gcHUzQGNC4t3A2nH+rRUbukOwxR/wOkYCE6USm
         7TEGCROt2sXlNtZBXTwFE+XThiGwJp9kRr0kg7Pd7b0gZiw4bwiMNLdmoLiY0O+5SppX
         H/p13nyr6sok7Bp6JeptPZa6gbotHvUkokX77wBagigpmiy/fH8Cyw1Yw5quR9zKsjWj
         4Kzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727623963; x=1728228763;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tiN6X2hSg8DI82vcwWmMRF/GpIHNZY05FXXMG5qJJZE=;
        b=ihhbWHnymB8zt/FDhFbTgCbKVKDvX6XK88IW/QzuXsjzu5qH+01eec/c2sr6kOKz0m
         kn+5h0JZ91HoFZodch129P7Uh9co2HwszenLzWIKzSB4Wmwf1v/Z1+zMig+x9KY8dEkM
         WkOZfgBa16ZPTMufeOgC21kviNKWfOzJT0EuBK26yvcem3R3VP1eW3MhbiLGrYWvMpep
         LbUm9lHbzu81XNJ0d9AAAJBk4yAk4l/O9kZYpu5bvoIsZ4G9vg1ZHdRamGhAkKgfZBvg
         X9dX4LIJ9VduJpCgQcjrr3ouvoxwK1OdQU2V9hI1OOGG9U/JmsXThqA08ZsUCqNPo5Yb
         IKvA==
X-Gm-Message-State: AOJu0YzNhX0Z24R/fI8N9Q/xRdOZIAz+J/f/zecvgLXANOXivRjQfBuY
	CYiBNdtL6KXwsmpqgrskvvL/VCP1vZupdVwe5mEEjwka7cfz+GMIqcGvmSlhjWr1owBnqbREz+V
	g4Pe3+ADMVVxV8yML2C8IWoTQh/8Gzg==
X-Google-Smtp-Source: AGHT+IGFjDycOqB0wxaGk47WRFnTKA/fwghGfhpGsT7oUNMRulkuoSUFN5XNI/jxmagi21Br2sb0ydOCZGIJ8hVaMnA=
X-Received: by 2002:a05:6512:39c6:b0:539:94df:38e9 with SMTP id
 2adb3069b0e04-53994df39c8mr384382e87.31.1727623963143; Sun, 29 Sep 2024
 08:32:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 29 Sep 2024 10:32:32 -0500
Message-ID: <CAH2r5mtp0SNG1yvDq8rDUWOYQrZh9_OtFFKWCEmOXeD=Ou5i4Q@mail.gmail.com>
Subject: xfstests generic/089
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Has anyone seen xfstest generic/089 going forever (sending compounded
open/close then open then close forever)?  This was with current
for-next, running to current Samba master (localhost) with "linux"
mount option

-- 
Thanks,

Steve
