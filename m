Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7467DCA4E
	for <linux-cifs@vger.kernel.org>; Mon, 21 Jul 2025 23:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753141110; cv=none; b=ph/p/vC7bZnhqeZ/7JXHK5gHZeHXDg2bN6kXd1Ot3OzzahgiLlHd0wa7anRjnQHl6EGfW2wMphFA1JRuEzifZRkvoRBZ4A46H8qpIsO+q33rlC8YEjbYkgFmCnlz6I/V1YlsaU+S/f7i9dLXn67hRAVqKhwsd4f35jQXTk1fmaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753141110; c=relaxed/simple;
	bh=ahKIIki7GTGwrYcPlpw9az8qu82o6HUS7io71LIC0+4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=nTn5yj4KAbR0vcLS7JdbvTLzyxqOGmRFxYW4GpDd6oY/fXtlymXdY7/YWhumpvDmMLRWgxduKx/EqEd3RRHvo0GrZ0K5b8l4dLv+4hXzaGE//eDoD/vpLlZyVijFrQFFaVMCYhlLHnVRPGzhJIFlI1jvsJIw0zFacra6DbRlo40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kY+cU50C; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kY+cU50C"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7183d264e55so48230547b3.2
        for <linux-cifs@vger.kernel.org>; Mon, 21 Jul 2025 16:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753141108; x=1753745908; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ahKIIki7GTGwrYcPlpw9az8qu82o6HUS7io71LIC0+4=;
        b=kY+cU50C8fw0G4iDvvK9BfLGKwXFAgykzukZK8lqxiUecD/D66vMWFWZGYMY8vLkaM
         T9xrwXdXALQ6bsaZuuyxMmKlj8VAaUm6n9IMOLSfS6xzCt+/QjyFa+KLKP+tik+r7n9W
         Dul0CEPMrZgsmVyRSQ1I4/j71GQd0x9nfCbup2LP+nNyBjMD89rWgF2nU6YdypwuKSon
         QpMysxeniGB7S8BPIJCH4UB8Z37fGc9mktIPbzQpbglkvLgUsY3B96UbC6ZG0VqtHxyw
         zC+drZi014kbPwy8kFhbZvgt1uJ6sPjPBw3+PLQqwYNs2jy2zdJ1e7uU4RYrvqq5mjCF
         2Dag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753141108; x=1753745908;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ahKIIki7GTGwrYcPlpw9az8qu82o6HUS7io71LIC0+4=;
        b=cX2KtPCPdgvR8GYr31HzU2xjnn4j0ltA1CC+HXyL9SQ9tC7GH6kgYSdLw5Rj7pXG/5
         Hpix6p/24oGyhmhkaDyLweg85uTqXqCVYyOV/B8wXbeAmKCrRsHpY1OjIdCvHO23Qqdl
         +H+rpPNfY9l56+HvZFZopuUKdSE/MlhboijM8GVwMD/5MC5bb7+O9D+0F1OW5eBis5mQ
         X7MZVpfQwctmQfC19SswOImK+eQwPb14P6FcsP1KoGN1eRa7eE/j5h9Z1oI9ZZnDO7zI
         4xFad26fD2DKrS5y8aD64sGERXMkJJeXXOEXaspY8lH4PA3uE1YpdrBzCsdYmhu3QR3p
         VBMQ==
X-Gm-Message-State: AOJu0YzFcsmCAWwamMRYHT2XRVLt8Qvw+u9gG2hWAUEODc2CY/XnXH00
	L4ooGCq4Nj2q93cK1gJ05RWnHA+9ntb2hj1nkkmjHmVj2+BOahFTIeuA/T0Kv8xABC6lKf78yfy
	vDg3lAxSx0XvUBFux21LTJSGBWVuAWz/EULFXmQk=
X-Gm-Gg: ASbGnctEOsWUaoyHfhOFMeqKWPQstOtkLfc1e6okofCURKflmx34SztjxDaLAjTyoRM
	f/HuRZGocmYz6FEEO7PUehgF78/8d3XgXexEiPfTi7OpxlamRM6DXnBHxrJRjfyUZrUAy/89xpD
	I1zytFgVWayb/HkTw1h+rqaCtsWq5Jby/4p7n7XLXCo/BovLNlFknhE+VnBuB2ZMnKxT9lKBpLj
	n/sOWQ=
X-Google-Smtp-Source: AGHT+IEfMgYmD0rvwe5c84Wm8hKKXDK4BLnv+rc2SvoMNucunB85Zu9u0kx95LHYGSfVVw7HKv6EpMe8U4fN4Xtda6g=
X-Received: by 2002:a05:690c:3608:b0:718:38be:b3e1 with SMTP id
 00721157ae682-718a9823126mr245382257b3.41.1753141108262; Mon, 21 Jul 2025
 16:38:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Marc <1marc1@gmail.com>
Date: Tue, 22 Jul 2025 09:38:17 +1000
X-Gm-Features: Ac12FXxgoDBbnWWj6zoG2IenS9cfN0pC63IaHZM0eCgOtbImR77VUoCEv40uaT0
Message-ID: <CAMHwNVuy2+EjMNFJAvMKACwpuSQ5kry25q5y5c1j4u2=Rc29ng@mail.gmail.com>
Subject: Follow up on: Issue with kernel 6.8.0-40-generic?
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dear all,

This message is a follow up on a message I initially wrote about a year ago.

I have the following setup: Windows 11 machine running in VirtualBox,
hosted on Ubuntu 22.04.

The Windows machine uses MS OneDrive to connect to our corporate
OneDrive for SharePoint. Inside the OneDrive directory structure, I
have created a Windows share. Let's call it "mydata".

Whenever the Windows 11 machine is running, on my Ubuntu host, I then
run `sudo mount.cifs //192.168.56.2/mydata /mnt/mydata -o
username=marc,uid=1000,gid=1000`. This will then mount the Windows
share and I can work with the files on Ubuntu.

The reason for my message last year was that since my Ubuntu host
machine upgraded to kernel 6.8.0-40-generic, I was no longer able to
mount the "mydata" Windows share.

Thanks to the great work of the community this was addressed and in
version 6.8.0-60-generic I was able to mount the share again.
However, I noticed that any PDF file I tried to open from this share would fail.
Evince reports "Unable to open document <path to pdf file> PDF
document is damaged".
This then caused me to again revert back to kernel 6.5.0-45-generic.

Today, I found some time for some testing with a newer kernel version
to see if the issue is still present.
I used mainline-gtk to install kernel version 6.15.7-061507-generic.
This kernel portrays the same problem when trying to open a PDF file.
Opening and editing text files, spreadsheets and images via the share
is no problem.

Hopefully someone can have a look into this situation.

Thank you.

Regards, /|/|arc.
