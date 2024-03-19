Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1BD1FBA
	for <linux-cifs@vger.kernel.org>; Tue, 19 Mar 2024 04:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710822773; cv=none; b=FPB5iqVPI0dz+vi0yFRviCD8rJbE4YeCDMGMw/JPftEz75h65jcH5GiStsaEMAU03dCiEkN09tsQA2dVKf/5rRJvBVwvC7T1znJWJdEh5WoSGuJlfqyYV2adco0YE7BsKFMt8eugBJRHT702/ZaQBEb+5ryEpEb1DrV6ucUx45U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710822773; c=relaxed/simple;
	bh=DzpEQiJBjbMCHb66dL3BRcROTBv3h8ygvWc8MUoX3ZQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=s5GktsLk7JOlnzVcItxkcFCbUNKFYQxxg48UsPu1P4l8afRIKgcFoBLjkdyWN5upphEeowbyd/JlEYZDZhJFTI3XhGfYfwhn9YWzIOts9osnsG9YFoKdopjW7vVKpZgBKUAuZmVlCwL0Ojz4yS0VU2l9H1qmwMPwGvfwjTjFhUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CYuI9Kty; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CYuI9Kty"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5148ea935b8so1413567e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 18 Mar 2024 21:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710822770; x=1711427570; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RLtdGJv67MVbMJFRsOstdqQ8dpJpGvR/GuMSSe5Fja8=;
        b=CYuI9KtyU92bqgbiWat+pa7ZYwLnxCD5wHBj7cYhXo6ERwscXfaSWAvcH4mACl25K5
         lmMWfD4l290xHmOwwAPlVIQFZvJOOqOK8laS1OUYfyOQ7xpUIiPzQUKXcwbQ9cFvPKiC
         bgLOUmroOj2+GQ+Eg9cHw+gUVrG9SLmTkE83Gejn+6BfX72PKorAv2tm918tRIh5Cv56
         4dke1zL31Pb3jWm/0v0jGWirSQ2Y7gLeUKiXo7h6quUOABZDt0q193hiWDfkDGYR2HCr
         +VQH37L24nxyQTea4xzXQxmGqRljB5pAdVoZCScqStu+h2XqGMSmugR7M2bwRvtGAcNN
         PsAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710822770; x=1711427570;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RLtdGJv67MVbMJFRsOstdqQ8dpJpGvR/GuMSSe5Fja8=;
        b=lPKS84e5TvL0EczewpOqVTEPD+fQ/mG1dILgdQ+R/0h9zKNmNsUHdFOc8C/yCkNb/7
         92hasxNqQd5wbAXkGYMagmxn5coytjSlRZ/fKzlR50RaflLRuH7fgMexmr5sYaZsvuid
         ovoRiGHiKR1N64FOXIW8qWQZbP/z6BZCUYr75CEWpCrSlFfBP7EhVqk2CCnkSsw7zftI
         jjCuOQ4MEwMMh/4kbP9XqzczljSRGxVET2UbKU5951Hvr9gOPqIWtfcmcC75jTBZu2MC
         73o7amd6o077QmY3pAmdmOQt4HYmQkdVeQ59+odiJaEqu5dgljlwtK0b7F1gXjOi0OlP
         iUeg==
X-Gm-Message-State: AOJu0YzDIl7oDnpnud6fr41YAvFIYCFND8L6r0+7N5nKYOVuFSgJownV
	cOHZQWOWbNUnA5pFhdHpQwNNMQZJdLDAE0A4i3Sbu5aw3zdQ+oWa2JZXmA+XDew1+21OfbE/sjD
	+vHuOz8diIl/4HiK1wQz+Hzv39F1zCIpNXovkNg==
X-Google-Smtp-Source: AGHT+IGuyJ0JB4Paxzqn3IYijM9xLFa+sW0lJYYDdArDZh6dpmaeohZbgNRzBDCmv/jc+C1JgnvxjHOtRnU4nYsttcI=
X-Received: by 2002:ac2:44ae:0:b0:513:a9d1:9ced with SMTP id
 c14-20020ac244ae000000b00513a9d19cedmr891418lfm.21.1710822769608; Mon, 18 Mar
 2024 21:32:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 18 Mar 2024 23:32:38 -0500
Message-ID: <CAH2r5mtkDKHZ6W9oHnOCPXjCmcZWQrXPXeSxO0VCiYZmQtQLHQ@mail.gmail.com>
Subject: Lots of test progress
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Added many xfstests - e.g. today we are now up to 218 fstests run
against ksmbd, and also have added tests to many of the other test
groups (target servers), including Windows and Azure etc.

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/10/builds/13

There is one known intermittent failure (test generic/069) for this
target server type - trying to isolate if server or client issue now.



-- 
Thanks,

Steve
