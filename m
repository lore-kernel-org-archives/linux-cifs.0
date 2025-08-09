Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD392E36EE
	for <linux-cifs@vger.kernel.org>; Sat,  9 Aug 2025 16:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754756953; cv=none; b=IxPfZ3EV4yKjPHrdY6Y4QiDQr131Tc6nbdODhwa+4UbBVYjKcOXyQXpx4UD/rTPgy+YtiTkI4Lph0dmgEw60+xDhF2zulTfBp2jbC+d5stxVkw3teD3rQLrFzlU0wWUTwzmDMHth0p8YBWp+mtaZH7ba4oBNaa+VrS495GSfZ8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754756953; c=relaxed/simple;
	bh=rZjNc/P+nCWWevDgmKOD3R/szuUQXKFC4/BX4HQgCDg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Os8CO+oDiWa0mdc7w3dyNlqH0ydOdP1iBsCblo9RIZU4A0t3j81Pf/h7Vjd+Hn2lfJCcuwrys9dL9jLwdNX9DssLs4uy43/YLMCZ6lM9qr7+L/YS/DtZjZJ7Z1HI7IIr/nmQJvhj1ZhEd3ZLJta26wquGmwcAaRLdf4Y2gCncWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hlq2W/Q7; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hlq2W/Q7"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-7076b55460eso32066206d6.0
        for <linux-cifs@vger.kernel.org>; Sat, 09 Aug 2025 09:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754756951; x=1755361751; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/fyHvYKJjU60RsBbKHpn5yRHju63oXLYkThdxO1NRhA=;
        b=Hlq2W/Q7AowYl51Mi8FRSAkz6v8Ec6+kZBETOcIANjB8DFGXOQ+VhrZ+2MSyr2QLox
         0uy5/X6Fg4xnizybqvl16KVf5q7OiayRfFT/f/Frze1rkDwffiPpIPdm5CVjXJR8vCS7
         QeqsauFkUB6DBiL8w9CJjsfdHzPIiTp9E8LHGP2mf2+2JUfsi1qQT1eBnFkrE7WuvQGR
         k00GoSVUq/yHy58pJ71bNS3MlUThCZ5dk2AKxoD8iUCQXoe7wXy56TL4uG0MZKgj56FI
         8zJjozC+EAZWwYWHz/sVe+T/zn0AjLx2NsjnIeqQG7xc1ZenuTuBjlqB/jIGdX12wpad
         /8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754756951; x=1755361751;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/fyHvYKJjU60RsBbKHpn5yRHju63oXLYkThdxO1NRhA=;
        b=W2FqImnT95t+Q/9KOlBtI7AOX6//POHrnyMZMfoCyPKMTnaLBpwEQRSOuKw2HnkrJ6
         5x2kxWm7NppJd3eui2gAzhWvSzZDYdGKW0Bys53668N4d/hRfT9E2F5NJDppHGODWpGg
         yuwlDS00wTkPStdr6KuTqWl/sK5bLFIUa8b9u/gMjzflLbiWiDPBvhYs1wYLPKYHPILt
         L2/epCQEGDxGfFZCMzEJaHthCt8vmeBXSehekW1IRivkJsvAW2fup9AbLzRaGfaeFGyh
         iZypkkHKEqm6TI4Nbh/QcVriKSXelGM09wvsscJQxdOAtmos431aqhphgsS5esAQMltu
         br6w==
X-Forwarded-Encrypted: i=1; AJvYcCVTj599oGHmVqhPl7Ss69Y0A5xiWvWwMtW9ckTNSFQiknw7u+Db5IMjAsCUl850bHjNzUWbLVssXORl@vger.kernel.org
X-Gm-Message-State: AOJu0YzlsjlihWax2zq0pmzHAFSxxKkyfTOIuS7Xik15asEgjYDxOEfT
	mBLhoCKmTerOif82FSJ7JKvvF6awsqmevw8TwvkPqS4JYAdLOu1GGSgUqaL8KgzcZvkcM+/DlAt
	cKgM0icCQnL+27IGeyvENv276vV7QfN8fyT8q
X-Gm-Gg: ASbGncuuWizZ1szrynE2fK2ngMAGHOyJoG3rMKTAv8SFUV0dsO3adLUCLmIpmf52qds
	jTDfp807OfR4SNUIRbr8VD0kZcFkgfhWDPGPd7KQJ1ko16JxYLFkVBNApBPlLYdQJFMaf8aWZH2
	B60+9xjJdoDBlHFSjSYV6HaDfLmJedCOQ745o46iXkQXVbWJ6n3K/4ZZ82ckVVh4oIQdRoKzpNc
	UqZyKO/6ImlePB054aBoB79LmqnwAEJuDZMGhE9XA==
X-Google-Smtp-Source: AGHT+IFibOrYJaO2ziYh+PY09Qh9dv7BBi7f1Z7PWdlVL6NDzCXnhSSQQ5Syb4VihcrJ5XVz5L+DBacAZq1Lv7j/dno=
X-Received: by 2002:a05:6214:627:b0:704:f7d8:edfc with SMTP id
 6a1803df08f44-7099a506801mr88849386d6.49.1754756951186; Sat, 09 Aug 2025
 09:29:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 9 Aug 2025 11:29:00 -0500
X-Gm-Features: Ac12FXxd1mnAHoASO24qy4bfYc6z70gjgOQFxLo40I8EIFKOE5zR5-ibvS3hnt0
Message-ID: <CAH2r5mv3xMgFfvioie17HmUBhU0ZqDQzMV6UMFBTF+9giK2pNQ@mail.gmail.com>
Subject: generic/023 failure to Samba
To: Paulo Alcantara <pc@manguebit.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Do you also see generic/023 now fail to Samba with current mainline
(looks like symlink issue)?

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/builds/69/steps/54/logs/stdio

-- 
Thanks,

Steve
