Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927A57E8
	for <linux-cifs@vger.kernel.org>; Mon,  8 Apr 2024 22:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712615535; cv=none; b=T9aPajr6qW58nv6h82RPJOdS4fQBfrOMPg3nTHS5Oz038kWFTlnxXwebIyUIiW/yc/TPRgpuBYGPcaPdAlN7OeNykL67RrwUoAzwZQCtx/Bxg3oFYtAhUBcXSNCV6s1cQ3o3aKoAE9dWGmsoL8PAUnnn2PD3LOA+QzIKVGmkl4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712615535; c=relaxed/simple;
	bh=2mDZsHeNa5byEh7Y+zjJNw2IrYPi6dI+QrNF7olkjqc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=V84TWEc2Sj1Z+hrUaXKExlegQPB76knF0Naos58kJFZ0jcz8BNauCEndNokpqQCJAnEqOzxQhuMlaJyqDlqFmX+ZUuBEXyBYILKlKYshxFgqqkzLP7EJif4ckAiIgVaEb6eVNwcElAvNwQRSiphGUsOP26dS54JhmPGfYmt18Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y8tkNAMp; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y8tkNAMp"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-516d1ecaf25so5083683e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 08 Apr 2024 15:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712615531; x=1713220331; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MS7H+ZzblRSVpUdWZEG2GkEO6wXeupQPEuiE3BkyKBM=;
        b=Y8tkNAMppEi7dUGOdDqi+qT+h++BgnTfaZSM+EsDiyfz9G2IyuhI3UeK3Wpi2ZRqGw
         fbXjvJTSJBPY/ajxhj9cVnakFDBiMNiyM63o+V1qFYOYpXpsu7fpofwIEnTPDgDbojwO
         q5iQkTOfpIIVSMLHMUEKuS8vc6TZbaI8ynzqf5V8bQ18He9rjbLdC27+347BnxDp/iVf
         ct+zCynE0wGFkuAmotOtUaP0jAjjoogguyHu+xaIxuAFxAUcM10IvTXwNe/2Ja0TYinh
         mu4x/DVbtH4g25spFh50KKO68jQVxiuVxPv08JBJD4uvxNzwmoqDrXH25zgs0N/C1hcV
         YisA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712615531; x=1713220331;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MS7H+ZzblRSVpUdWZEG2GkEO6wXeupQPEuiE3BkyKBM=;
        b=CP9pjT9rnx/x8LJgpHivsV3F2sX4vGnCi0vwT+koHqJrTPTObMqBR62BCgWBy6OpRV
         2cslP8xRUbqQSKLIlWDeawnhXqjYsDocjPyNkOWxR/FUm76hwuE2W7V1cfN7NVmRrYg+
         IcAWKOXZXkwwPFy9UhlIKEa+IDWAFDaQUgtl2D4R8dpDr1cd6dwz4tNDix0EAV9EWxSi
         llUu6ioXvrjcGx7gubLpy3psGUHkGAh6AGeJbfg6INo+DHvlF1cNyAHPrLLRrxHIvydi
         tsN4ebjyPSHF4aJPtwIO6c5B3dMKuaTqlCmJTeAGJw3xzcmCInOM7Yui9uhOcwEtrK6G
         vcFw==
X-Gm-Message-State: AOJu0YzREEk+iTpMfy70icsp9ZcqXjbKFFefBQq52RhLnsSoPOerumWt
	Kgx2s+iZUsUD/FR8nzILuNhQbxeNgj/QlhaIwLUWn6e+4mZEt/aINCwZaItCiPD7yWU43r8+sXS
	4NrGanAbiCgIAnLiNe2vLi8tWCg3G1hGetWk=
X-Google-Smtp-Source: AGHT+IE9cuPlSgOH7/v/w+TJiQh0LWpjqcdo+yYaVVRjYLVuP8OhG+PTCICCdEPXrXCDJ0M1dQSEbAk8eSa7TpsLL6k=
X-Received: by 2002:ac2:5467:0:b0:516:a115:4a4d with SMTP id
 e7-20020ac25467000000b00516a1154a4dmr5682609lfn.68.1712615531211; Mon, 08 Apr
 2024 15:32:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 8 Apr 2024 17:31:59 -0500
Message-ID: <CAH2r5muOk9hfCqMzRKnKR3sXOOauGdjbvuzms_bKM+U0t5zihA@mail.gmail.com>
Subject: Hang in xfstest
To: CIFS <linux-cifs@vger.kernel.org>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"

I narrowed down (bisected) the cause of the crash in unmount
generic/046 (to Windows) which causes the hang on following tests
(generic/047 etc).   See
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/3/builds/61/steps/73/logs/stdio
as an example.

The regression started when I add the patch from 6.5-rc1 "cifs: Add a
laundromat thread for cached directories"

The workaround is to simply disable directory caching for that mount -
ie "nohandlecache" mount parameter.  This unmount race is only an
issue to servers which support directory leases (e.g. Windows).




-- 
Thanks,

Steve
