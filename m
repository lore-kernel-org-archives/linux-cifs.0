Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F6381ADF;
	Fri, 23 Feb 2024 13:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708695723; cv=none; b=OhWj4kb1eGbv/kYN9uwOgfhhl0it4Mg7wpMsLl1cBK7rI9lCSQEOQPCGIeBsV3CeKokEYVUFrmlZFfb5T2joyI1Bnt+FkiEWDgH6Y/UoIyD6ZiqIGmwvwTCRvcabRDzIhOTZYQm4ARh9Cl1hKgoQanKSM03cp2mLxYKRgqfgMF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708695723; c=relaxed/simple;
	bh=gF2VaFBFzA+2ZeXFtiLLVrvLvDWeAxLKSzdG/N1wuyE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=i2WBmwUCvm4nvz2ee7TIHghVrJqNLO/HbN7Fc1t0qZmleMb9aGrFaHzz+f+WfGnCGwvK5E4Ubyt6vzA/WGPKkZc+hqAO1Bht2/mva0pNvfc8oPrMhTdXHHXpvSihDYDBCApYw5dYQIHwwep6I9kWJm7xNz+rJa9UNF2EervmyDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MMtJu6/4; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MMtJu6/4"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-512ea6ce06aso497973e87.2;
        Fri, 23 Feb 2024 05:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708695719; x=1709300519; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=H8baDiRw1MiqTav0cH+AmCLuh3He/m/eygkvxB3xdtQ=;
        b=MMtJu6/4QsNBnXii6Vx22oY5VkYCr3Zt6np/Mkc7L50XXMMaPy146KR/1VVR6g2SDh
         4ZZ+5xhzYYSpaGpKfyZe0uPOgK1CxTsNv/5k4tC9T+Cjoelu+55DBIRGSH1XbXm52VCn
         hJXvxcAsEN/vbujsa9eJGH7yRip3WO6FmlSoyZHKWa2aC38roBDVoH0glYpxxJDNb9cn
         Dbf22gYVWF75iKSs72OQB4MGwfytP63HoOiOHhaaA+F/XqPiWMTdiwHAjbdsupns+Mia
         PBoz2KoXIwHET4qzNCVr5rQS2U6eATYhNAAGXXL86Wfowe+GfNsne7lIu6VK7IyyrABM
         9wFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708695719; x=1709300519;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H8baDiRw1MiqTav0cH+AmCLuh3He/m/eygkvxB3xdtQ=;
        b=wU6w2F7RDto4KkNMPTVvDeTqYeg2DqLFS2XhlF8zEfJVTy152hghBbC/uO+IKol4T2
         y5mz6jrj6axKphZwvNreMDTMuTCvL2QXNx62jpggRyuhhaDaDOfymrDPIXkKJOa9aGBa
         MN5xmE6YoVpd3q9I53S4vAZaOHcSdhwer0lJ1RSZ0+T1cDwmEVKcqPrAkDJUxoSeA+aI
         ZAzxkvTukj3du+jnsUezwhKk/5Y18ei4jd9faSzJVPCm8w6Otj4hIOpjFD0ZCz8IZirS
         j/8B5Fpb7woo2gjs7PvBgGrczrIJQbjVbr06fLFwtxaGm/h0+DqACWLWXjZM7yd8MtgK
         slfw==
X-Forwarded-Encrypted: i=1; AJvYcCW+EXLdbz9Z8JDZjDoggn20wT9D7iHAwNkFr5dxGLXpqSJJxCXwEYJuaaUC+2aNl0EGr7cPYxwa6vBMjIryeNyWQ6jBtNQL1YDWlw==
X-Gm-Message-State: AOJu0YzGmp9MswGcnMO3fmutupgoP4kUtL4Hrk/QiZcY6UcJgwYX/uIr
	ioT0QS7MKY59lD1bI3J6yJXmCSgO3EkAIXhSX5mBOdqDH1G+vkm43iMBmt/LueGUIM+omkX9bzC
	TLvkl8bXgfgEYwuX6TaHJgnCgsK1T6cDzXhChtQ==
X-Google-Smtp-Source: AGHT+IHNkEurwp3mC2jbPgs/f3j27sWHgKxxlq1I3Alp/u6ogpZkqenKsmfCqwauOZgNF6xIlvAQ4NxWtbXHhU/nFAA=
X-Received: by 2002:a05:6512:239a:b0:512:b04e:fb52 with SMTP id
 c26-20020a056512239a00b00512b04efb52mr1878678lfv.4.1708695719422; Fri, 23 Feb
 2024 05:41:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 23 Feb 2024 19:11:48 +0530
Message-ID: <CANT5p=rYFOkpnB_SMGd0dAV5orX--Z53O-gjVg4qRkgrH6HiqA@mail.gmail.com>
Subject: Request to include a couple of fixes to stable branches
To: Stable <stable@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi stable maintainers,

We seem to have missed adding the stable tag to a couple of important
patches that went upstream for fs/smb/client. Can you please include
them in all the stable trees?

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4f1fffa2376922f3d1d506e49c0fd445b023a28e
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=79520587fe42cd4988aff8695d60621e689109cb

-- 
Regards,
Shyam
